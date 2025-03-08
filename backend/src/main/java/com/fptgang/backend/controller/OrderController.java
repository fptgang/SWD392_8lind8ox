package com.fptgang.backend.controller;

import com.fptgang.backend.api.controller.OrdersApi;
import com.fptgang.backend.api.model.*;
import com.fptgang.backend.mapper.CartMapper;
import com.fptgang.backend.mapper.DetailLevel;
import com.fptgang.backend.mapper.OrderMapper;
import com.fptgang.backend.model.Account;
import com.fptgang.backend.model.Order;
import com.fptgang.backend.service.OrderService;
import com.fptgang.backend.service.params.ListParams;
import com.fptgang.backend.util.OpenApiHelper;
import com.fptgang.backend.util.SecurityUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import static com.fptgang.backend.util.SecurityUtil.getCurrentUserId;

@Slf4j
@RestController
@RequestMapping("/api/v1")
public class OrderController implements OrdersApi {
    private final OrderService orderService;
    private final OrderMapper orderMapper;
    private final CartMapper cartMapper;

    public OrderController(OrderService orderService,
                           OrderMapper orderMapper,
                           CartMapper cartMapper) {
        this.orderService = orderService;
        this.orderMapper = orderMapper;
        this.cartMapper = cartMapper;
    }

    @Override
    public ResponseEntity<PlaceOrder200Response> placeOrder(CartDto cartDto, Long accountId) {
        if (accountId != null) {
            if (accountId != SecurityUtil.requireCurrentUserId() &&
                    !SecurityUtil.hasPermission(Account.Role.STAFF)) {
                throw new AccessDeniedException("You can only place orders for yourself.");
            }
        } else {
            accountId = SecurityUtil.requireCurrentUserId();
        }


        var cart = cartMapper.toEntity(cartDto);
        cart.setAccountId(accountId);
        var res = orderService.place(cart);
        return ResponseEntity.ok(new PlaceOrder200Response()
                .order(orderMapper.toDTO(res.getOrder(), DetailLevel.FULL))
                .paymentRedirectUrl(res.getPaymentRedirectUrl()));
    }

    @Override
    public ResponseEntity<OrderDto> getOrderById(Long orderId) {
        log.info("Getting order by id " + orderId);
        Order order = orderService.findById(orderId);

        // Restrict customers to their own orders
        if (!SecurityUtil.hasPermission(Account.Role.ADMIN)) {
            String currentEmail = SecurityUtil.requireCurrentUserEmail();
            if (!order.getAccount().getEmail().equalsIgnoreCase(currentEmail)) {
                throw new AccessDeniedException("You can only view your own orders.");
            }
        }

        return new ResponseEntity<>(orderMapper.toDTO(order, DetailLevel.FULL), HttpStatus.OK);
    }

    @Override
    public ResponseEntity<GetOrders200Response> getOrders(Pageable pageable, String filter, String search) {
        log.info("Getting orders");
        var includeInvisible = SecurityUtil.hasPermission(Account.Role.ADMIN);
        var params = ListParams.builder()
                .pageable(OpenApiHelper.toPageable(pageable))
                .search(search)
                .filter(filter)
                .includeInvisible(includeInvisible);

        // Customers can only view their own orders
        if (!SecurityUtil.hasPermission(Account.Role.STAFF)) {
            params.setFilter("account.accountId", "eq", getCurrentUserId());
        }

        var resultPage = orderService.getAll(params.build())
                .map(o -> orderMapper.toDTO(o, DetailLevel.SUMMARY));

        return OpenApiHelper.respondPage(resultPage, GetOrders200Response.class);
    }

    @Override
    public ResponseEntity<OrderDto> updateOrder(Long orderId, OrderDto orderDto) {
        orderDto.setOrderId(orderId); // Override orderId

        log.info("Updating order " + orderId);
        return ResponseEntity.ok(
                orderMapper.toDTO(
                        orderService.update(orderMapper.toEntity(orderDto)),
                        DetailLevel.FULL
                )
        );
    }
}
