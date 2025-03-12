package com.fptgang.backend.mapper.template;

import com.fptgang.backend.model.Order;
import com.fptgang.backend.util.CurrencyUtil;
import com.fptgang.backend.util.DateTimeUtil;
import org.springframework.stereotype.Component;

import java.util.Map;

@Component
public class OrderDeliveredEmailTemplateMapper implements TemplateMapper<Order> {
    @Override
    public Map<String, Object> create(Order entity) {
        return Map.of(
                "orderId", entity.getOrderId(),
                "account", Map.of(
                        "firstName", entity.getAccount().getFirstName()
                ),
                "shippingAddress", entity.getShippingInfo().getAddress() + ", " +
                        entity.getShippingInfo().getCity() + ", " +
                        entity.getShippingInfo().getDistrict(),
                "subTotal", CurrencyUtil.format(entity.getSubTotal()),
                "finalTotal", CurrencyUtil.format(entity.getFinalTotal()),
                "deliveredAt", DateTimeUtil.formatDate(entity.getUpdatedAt()),
                "latestStatus", entity.getLatestStatus().name()
        );
    }
}
