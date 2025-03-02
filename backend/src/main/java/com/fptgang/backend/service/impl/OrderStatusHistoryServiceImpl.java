package com.fptgang.backend.service.impl;

import com.fptgang.backend.model.OrderStatusHistory;
import com.fptgang.backend.repository.OrderStatusHistoryRepos;
import com.fptgang.backend.service.OrderStatusHistoryService;
import com.fptgang.backend.service.params.ListParams;
import com.fptgang.backend.util.OpenApiHelper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

@Service
public class OrderStatusHistoryServiceImpl implements OrderStatusHistoryService {


    private final OrderStatusHistoryRepos orderRepos;

    @Autowired
    public OrderStatusHistoryServiceImpl(OrderStatusHistoryRepos orderRepos) {
        this.orderRepos = orderRepos;
    }

    @Override
    public OrderStatusHistory create(OrderStatusHistory order) {
        return orderRepos.save(order);
    }

    @Override
    public OrderStatusHistory findById(long id) {
        return orderRepos.findById(id).orElse(null);
    }

    @Override
    public OrderStatusHistory update(OrderStatusHistory order) {
        if (order.getId() == null) {
            throw new IllegalArgumentException("OrderStatusHistory does not exist");
        }
        return orderRepos.save(order);
    }

    @Override
    public OrderStatusHistory deleteById(long id) {
        OrderStatusHistory order = orderRepos.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("OrderStatusHistory does not exist"));
//        order.setVisible(false);
        return orderRepos.save(order);
    }

    @Override
    public Page<OrderStatusHistory> getAll(ListParams params) {
        var spec = params.<OrderStatusHistory>toSpec();
        return orderRepos.findAll(spec, params.getPageable());
    }
}