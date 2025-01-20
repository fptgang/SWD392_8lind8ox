package com.fptgang.backend.service;

import com.fptgang.backend.model.Order;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

public interface OrderService {
    Order create(Order order);
    Order findById(long id);
    Order update(Order order);
    Order deleteById(long id);
    Page<Order> getAll(Pageable pageable, String filter, boolean includeInvisible);
    default Page<Order> getAll(Pageable pageable, String filter) {
        return getAll(pageable, filter, false);
    }
}