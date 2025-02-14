package com.fptgang.backend.controller;

import com.fptgang.backend.api.controller.OrdersApi;
import com.fptgang.backend.api.model.*;
import com.fptgang.backend.mapper.OrderMapper;
import com.fptgang.backend.model.Account;
import com.fptgang.backend.service.OrderService;
import com.fptgang.backend.util.OpenApiHelper;
import com.fptgang.backend.util.SecurityUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.context.request.NativeWebRequest;

import java.util.Optional;

@Slf4j
@RestController
@RequestMapping("/api/v1")
public class OrderController implements OrdersApi {
    private final OrderService orderService;
    private final OrderMapper orderMapper;

    public OrderController(OrderService orderService, OrderMapper orderMapper) {
        this.orderService = orderService;
        this.orderMapper = orderMapper;
    }
    @Override
    public Optional<NativeWebRequest> getRequest() {
        return OrdersApi.super.getRequest();
    }

    @Override
    public ResponseEntity<OrderDto> createOrder(OrderDto orderDto) {
        log.info("Creating order");
        ResponseEntity<OrderDto> response = new ResponseEntity<>(orderMapper
                .toDTO(orderService.create(orderMapper.toEntity(orderDto))), HttpStatus.CREATED);
        return response;
    }

    @Override
    public ResponseEntity<Void> deleteOrder(Long orderId) {
        log.info("Deleting order " + orderId);
        orderService.deleteById(orderId);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @Override
    public ResponseEntity<OrderDto> getOrderById(Long orderId) {
        log.info("Getting order by id " + orderId);
        return new ResponseEntity<>(orderMapper.toDTO(orderService.findById(orderId)), HttpStatus.OK);
    }

    @Override
    public ResponseEntity<GetOrders200Response> getOrders(Pageable pageable, String filter, String search) {
        log.info("Getting orders");
        boolean includeInvisible = SecurityUtil.hasPermission(Account.Role.ADMIN);

        // If the user is not an admin, only allow fetching their own orders
        if (!includeInvisible) {
            String userEmail = SecurityUtil.requireCurrentUserEmail();
            filter = (filter == null ? "" : filter + ",") + "account.email,eq," + userEmail;
        }

        var page = OpenApiHelper.toPageable(pageable);
        var resultPage = orderService.getAll(page, filter, search, includeInvisible)
                .map(orderMapper::toDTO);

        return OpenApiHelper.respondPage(resultPage, GetOrders200Response.class);
    }

    @Override
    public ResponseEntity<OrderDto> updateOrder(Long orderId, OrderDto orderDto) {
        orderDto.setOrderId(orderId); // Override orderId

        log.info("Updating order " + orderId);
        return ResponseEntity.ok(orderMapper.toDTO(orderService.update(orderMapper.toEntity(orderDto))));
    }
}
