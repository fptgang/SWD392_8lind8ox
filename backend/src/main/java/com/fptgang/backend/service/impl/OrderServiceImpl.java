package com.fptgang.backend.service.impl;

import com.fptgang.backend.model.Order;
import com.fptgang.backend.repository.OrderRepos;
import com.fptgang.backend.service.OrderService;
import com.fptgang.backend.service.params.ListParams;
import com.fptgang.backend.util.EntityUtil;
import com.fptgang.backend.util.OpenApiHelper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

@Service
public class OrderServiceImpl implements OrderService {


    private final OrderRepos orderRepos;

    @Autowired
    public OrderServiceImpl(OrderRepos orderRepos) {
        this.orderRepos = orderRepos;
    }

    @Override
    public Order create(Order order) {
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