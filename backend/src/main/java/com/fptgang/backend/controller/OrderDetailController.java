package com.fptgang.backend.controller;

import com.fptgang.backend.api.controller.AccountsApi;
import com.fptgang.backend.api.controller.OrderDetailsApi;
import com.fptgang.backend.api.model.*;
import com.fptgang.backend.mapper.AccountMapper;
import com.fptgang.backend.model.Role;
import com.fptgang.backend.service.AccountService;
import com.fptgang.backend.util.OpenApiHelper;
import com.fptgang.backend.util.SecurityUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.context.request.NativeWebRequest;

import java.util.Optional;

@Slf4j
@RestController
@RequestMapping("/api/v1")
public class OrderDetailController implements OrderDetailsApi {

    @Override
    public Optional<NativeWebRequest> getRequest() {
        return OrderDetailsApi.super.getRequest();
    }

    @Override
    public ResponseEntity<OrderDetailDto> createOrderDetail(OrderDetailDto orderDetailDto) {
        return OrderDetailsApi.super.createOrderDetail(orderDetailDto);
    }

    @Override
    public ResponseEntity<Void> deleteOrderDetail(Integer orderDetailId) {
        return OrderDetailsApi.super.deleteOrderDetail(orderDetailId);
    }

    @Override
    public ResponseEntity<OrderDetailDto> getOrderDetailById(Integer orderDetailId) {
        return OrderDetailsApi.super.getOrderDetailById(orderDetailId);
    }

    @Override
    public ResponseEntity<GetOrderDetails200Response> getOrderDetails(GetAccountsPageableParameter pageable, String filter) {
        return OrderDetailsApi.super.getOrderDetails(pageable, filter);
    }

    @Override
    public ResponseEntity<OrderDetailDto> updateOrderDetail(Integer orderDetailId, OrderDetailDto orderDetailDto) {
        return OrderDetailsApi.super.updateOrderDetail(orderDetailId, orderDetailDto);
    }
}
