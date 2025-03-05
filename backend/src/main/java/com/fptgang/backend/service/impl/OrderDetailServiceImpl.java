package com.fptgang.backend.service.impl;

import com.fptgang.backend.model.OrderDetail;
import com.fptgang.backend.repository.OrderDetailRepos;
import com.fptgang.backend.service.OrderDetailService;
import com.fptgang.backend.service.params.ListParams;
import com.fptgang.backend.util.EntityUtil;
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
        OrderDetail existing = orderDetailRepos.findById(orderDetail.getOrderDetailId())
                .orElseThrow(() -> new IllegalArgumentException("OrderDetail does not exist"));
        EntityUtil.merge(existing, orderDetail);
        return orderDetailRepos.save(existing);
    }

    @Override
    public OrderDetail deleteById(long id) {
        OrderDetail orderDetail = orderDetailRepos.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("OrderDetail does not exist"));
//        orderDetail.setIsVisible(false);
        return orderDetailRepos.save(orderDetail);
    }

    @Override
    public Page<OrderDetail> getAll(ListParams params) {
        var spec = params.<OrderDetail>toSpec();
        return orderDetailRepos.findAll(spec, params.getPageable());
    }
}