package com.fptgang.backend.service.impl;

import com.fptgang.backend.model.Order;
import com.fptgang.backend.repository.OrderRepos;
import com.fptgang.backend.service.OrderService;
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
        if (order.getOrderId() == null) {
            throw new IllegalArgumentException("Order does not exist");
        }
        return orderRepos.save(order);
    }

    @Override
    public Order deleteById(long id) {
        Order order = orderRepos.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Order does not exist"));
//        order.setVisible(false);
        return orderRepos.save(order);
    }

    @Override
    public Page<Order> getAll(Pageable pageable, String filter, String search, boolean includeInvisible) {
        var spec = OpenApiHelper.<Order>filterToSpec(filter);
        spec = spec.and(OpenApiHelper.searchToSpec(search));
//        if (!includeInvisible) {
//            spec = spec.and((a, _, cb) -> cb.isTrue(a.get("isVisible")));
//        }
        return orderRepos.findAll(spec, pageable);
    }
}