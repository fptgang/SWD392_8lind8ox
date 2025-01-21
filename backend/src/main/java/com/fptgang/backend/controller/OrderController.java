package com.fptgang.backend.controller;

import com.fptgang.backend.api.controller.OrdersApi;
import com.fptgang.backend.api.model.*;
import com.fptgang.backend.model.Role;
import com.fptgang.backend.util.OpenApiHelper;
import com.fptgang.backend.util.SecurityUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.context.request.NativeWebRequest;

import java.util.Optional;

@Slf4j
@RestController
@RequestMapping("/api/v1")
public class OrderController implements OrdersApi {

    @Override
    public Optional<NativeWebRequest> getRequest() {
        return OrdersApi.super.getRequest();
    }

    @Override
    public ResponseEntity<OrderDto> createOrder(OrderDto orderDto) {
        return OrdersApi.super.createOrder(orderDto);
    }

    @Override
    public ResponseEntity<Void> deleteOrder(Integer orderId) {
        return OrdersApi.super.deleteOrder(orderId);
    }

    @Override
    public ResponseEntity<OrderDto> getOrderById(Integer orderId) {
        return OrdersApi.super.getOrderById(orderId);
    }

    @Override
    public ResponseEntity<GetOrders200Response> getOrders(Pageable pageable, String filter, String search) {
        log.info("Getting orders");
        var page = OpenApiHelper.toPageable(pageable);
        var includeInvisible = SecurityUtil.hasPermission(Role.ADMIN);
        return OpenApiHelper.respondPage(null, GetOrders200Response.class);
    }

    @Override
    public ResponseEntity<OrderDto> updateOrder(Integer orderId, OrderDto orderDto) {
        return OrdersApi.super.updateOrder(orderId, orderDto);
    }
}
