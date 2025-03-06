package com.fptgang.backend.service.impl;

import com.fptgang.backend.model.Order;
import com.fptgang.backend.model.OrderDetail;
import com.fptgang.backend.model.StockKeepingUnit;
import com.fptgang.backend.repository.OrderRepos;
import com.fptgang.backend.service.OrderService;
import com.fptgang.backend.service.params.ListParams;
import com.fptgang.backend.util.EntityUtil;
import com.fptgang.backend.util.OpenApiHelper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class OrderServiceImpl implements OrderService {


    private final OrderRepos orderRepos;

    @Autowired
    public OrderServiceImpl(OrderRepos orderRepos) {
        this.orderRepos = orderRepos;
    }

    @Override
    public Order create(Order order) {
        // Save order first to get the ID
        List<OrderDetail> orderDetails = order.getOrderDetails();
        order.setOrderDetails(null);

        order = orderRepos.save(order);

        // Set the order reference for each detail
        if (orderDetails != null) {
            Order finalOrder = order;
            orderDetails.forEach(detail -> detail.setOrder(finalOrder));
        }
        order.setOrderDetails(orderDetails);

        // Save again to persist the details
        return orderRepos.save(order);
    }

    @Override
    public Order findById(long id) {
        return orderRepos.findById(id).orElse(null);
    }

    @Override
    public Order update(Order order) {
        Order existing = orderRepos.findById(order.getOrderId())
                .orElseThrow(() -> new IllegalArgumentException("Order does not exist"));
        EntityUtil.merge(existing, order);
        return orderRepos.save(existing);
    }

    @Override
    public Order deleteById(long id) {
        Order order = orderRepos.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Order does not exist"));
//        order.setIsVisible(false);
        return orderRepos.save(order);
    }

    @Override
    public Page<Order> getAll(ListParams params) {
        var spec = params.<Order>toSpec();
        return orderRepos.findAll(spec, params.getPageable());
    }
}