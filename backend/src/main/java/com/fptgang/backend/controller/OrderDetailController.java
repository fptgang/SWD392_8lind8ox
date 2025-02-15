package com.fptgang.backend.controller;

import com.fptgang.backend.api.controller.OrderDetailsApi;
import com.fptgang.backend.api.model.*;
import com.fptgang.backend.mapper.OrderDetailMapper;
import com.fptgang.backend.model.Account;
import com.fptgang.backend.model.OrderDetail;
import com.fptgang.backend.service.OrderDetailService;
import com.fptgang.backend.util.OpenApiHelper;
import com.fptgang.backend.util.SecurityUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.context.request.NativeWebRequest;

import java.util.Optional;

@Slf4j
@RestController
@RequestMapping("/api/v1")
public class OrderDetailController implements OrderDetailsApi {

    private final OrderDetailService orderDetailService;
    private final OrderDetailMapper orderDetailMapper;

    public OrderDetailController(OrderDetailService orderDetailService, OrderDetailMapper orderDetailMapper) {
        this.orderDetailService = orderDetailService;
        this.orderDetailMapper = orderDetailMapper;
    }

    @Override
    public Optional<NativeWebRequest> getRequest() {
        return OrderDetailsApi.super.getRequest();
    }

    @Override
    public ResponseEntity<OrderDetailDto> createOrderDetail(OrderDetailDto orderDetailDto) {
        log.info("Creating order detail");
        if (!SecurityUtil.hasPermission(Account.Role.ADMIN)) {
            throw new AccessDeniedException("Only admins can create order details.");
        }
        ResponseEntity<OrderDetailDto> response = new ResponseEntity<>(orderDetailMapper
                .toDTO(orderDetailService.create(orderDetailMapper.toEntity(orderDetailDto))), HttpStatus.CREATED);
        return response;
    }

    @Override
    public ResponseEntity<Void> deleteOrderDetail(Long orderDetailId) {
        log.info("Deleting order detail " + orderDetailId);
        if (!SecurityUtil.hasPermission(Account.Role.ADMIN)) {
            throw new AccessDeniedException("Only admins can delete order details.");
        }
        orderDetailService.deleteById(orderDetailId);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @Override
    public ResponseEntity<OrderDetailDto> getOrderDetailById(Long orderDetailId) {
        OrderDetail orderDetail = orderDetailService.findById(orderDetailId);

        // Restrict customers to their own order details
        if (!SecurityUtil.hasPermission(Account.Role.ADMIN)) {
            String currentEmail = SecurityUtil.requireCurrentUserEmail();
            if (!orderDetail.getOrder().getAccount().getEmail().equalsIgnoreCase(currentEmail)) {
                throw new AccessDeniedException("You can only view your own order details.");
            }
        }

        return new ResponseEntity<>(orderDetailMapper.toDTO(orderDetail), HttpStatus.OK);
    }

    @Override
    public ResponseEntity<GetOrderDetails200Response> getOrderDetails(Pageable pageable, String filter, String search) {
        log.info("Getting order details");
        var page = OpenApiHelper.toPageable(pageable);
        var includeInvisible = SecurityUtil.hasPermission(Account.Role.ADMIN);
        var res = orderDetailService.getAll(page, filter, search, includeInvisible).map(orderDetailMapper::toDTO);
        return OpenApiHelper.respondPage(res, GetOrderDetails200Response.class);
    }

    @Override
    public ResponseEntity<OrderDetailDto> updateOrderDetail(Long orderDetailId, OrderDetailDto orderDetailDto) {
        if (!SecurityUtil.hasPermission(Account.Role.ADMIN)) {
            throw new AccessDeniedException("Only admins can update order details.");
        }

        orderDetailDto.setOrderDetailId(orderDetailId); // Override orderDetailId

        log.info("Updating order detail " + orderDetailId);
        return ResponseEntity.ok(orderDetailMapper.toDTO(orderDetailService.update(orderDetailMapper.toEntity(orderDetailDto))));
    }
}
