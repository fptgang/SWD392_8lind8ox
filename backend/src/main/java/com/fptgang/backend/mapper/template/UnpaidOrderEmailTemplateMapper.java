package com.fptgang.backend.mapper.template;

import com.fptgang.backend.model.Order;
import com.fptgang.backend.util.CurrencyUtil;
import com.fptgang.backend.util.DateTimeUtil;
import org.springframework.stereotype.Component;

import java.util.Map;
import java.util.stream.Collectors;

@Component
public class UnpaidOrderEmailTemplateMapper implements TemplateMapper<Order> {
    @Override
    public Map<String, Object> create(Order entity) {
        return Map.of(
                "orderId", entity.getOrderId(),
                "account", Map.of(
                        "firstName", entity.getAccount().getFirstName()
                ),
                "createdAt", DateTimeUtil.formatDate(entity.getCreatedAt()),
                "subTotal", CurrencyUtil.format(entity.getSubTotal()),
                "finalTotal", CurrencyUtil.format(entity.getFinalTotal()),
                "latestStatus", entity.getLatestStatus().name()
        );
    }
}
