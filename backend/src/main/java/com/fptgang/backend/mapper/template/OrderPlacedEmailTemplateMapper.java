package com.fptgang.backend.mapper.template;

import com.fptgang.backend.model.Order;
import com.fptgang.backend.util.CurrencyUtil;
import org.springframework.stereotype.Component;

import java.util.Map;
import java.util.stream.Collectors;

@Component
public class OrderPlacedEmailTemplateMapper implements TemplateMapper<Order> {
    @Override
    public Map<String, Object> create(Order entity) {
        return Map.of(
                "orderId", entity.getOrderId(),
                "account", Map.of("firstName", entity.getAccount().getFirstName()),
                "orderDetails", entity.getOrderDetails().stream().map(orderDetail -> Map.of(
                        "stockKeepingUnit", Map.of("name", orderDetail.getStockKeepingUnit().getName()),
                        "unitPrice", CurrencyUtil.format(orderDetail.getUnitPrice()),
                        "quantity", orderDetail.getQuantity(),
                        "finalTotal", CurrencyUtil.format(orderDetail.getFinalTotal())
                )).collect(Collectors.toList()),
                "subTotal", CurrencyUtil.format(entity.getSubTotal()),
                "finalTotal", CurrencyUtil.format(entity.getFinalTotal())
        );
    }
}