package com.fptgang.backend.service.impl;

import com.fptgang.backend.model.OrderDetail;
import com.fptgang.backend.repository.OrderDetailRepos;
import com.fptgang.backend.service.OrderDetailService;
import com.fptgang.backend.util.OpenApiHelper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

@Service
public class OrderDetailServiceImpl implements OrderDetailService {

    private final OrderDetailRepos orderDetailRepos;

    @Autowired
    public OrderDetailServiceImpl(OrderDetailRepos orderDetailRepos) {
        this.orderDetailRepos = orderDetailRepos;
    }

    @Override
    public OrderDetail create(OrderDetail orderDetail) {
        return orderDetailRepos.save(orderDetail);
    }

    @Override
    public OrderDetail findById(long id) {
        return orderDetailRepos.findById(id).orElse(null);
    }

    @Override
    public OrderDetail update(OrderDetail orderDetail) {
        if (orderDetail.getOrderDetailId() == null) {
            throw new IllegalArgumentException("OrderDetail does not exist");
        }
        return orderDetailRepos.save(orderDetail);
    }

    @Override
    public OrderDetail deleteById(long id) {
        OrderDetail orderDetail = orderDetailRepos.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("OrderDetail does not exist"));
        orderDetail.setVisible(false);
        return orderDetailRepos.save(orderDetail);
    }

    @Override
    public Page<OrderDetail> getAll(Pageable pageable, String filter, String search, boolean includeInvisible) {
        var spec = OpenApiHelper.<OrderDetail>filterToSpec(filter);
        spec = spec.and(OpenApiHelper.searchToSpec(search));
        if (!includeInvisible) {
            spec = spec.and((a, _, cb) -> cb.isTrue(a.get("isVisible")));
        }
        return orderDetailRepos.findAll(spec, pageable);
    }
}