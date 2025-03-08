package com.fptgang.backend.mapper;

import com.fptgang.backend.api.model.CartDto;
import com.fptgang.backend.model.Transaction;
import com.fptgang.backend.model.checkout.Cart;
import org.springframework.stereotype.Component;

@Component
public class CartMapper extends BaseMapper<CartDto, Cart> {
    @Override
    public Cart toEntity(CartDto dto) {
        var cart = new Cart();
        cart.setVoucherId(dto.getVoucherId());
        cart.setShippingInfoId(dto.getShippingInfoId());
        cart.setItems(dto.getItems().stream().map(e -> {
            var item = new Cart.Item();
            item.setQuantity(e.getQuantity());
            item.setSkuId(e.getSkuId());
            item.setSlotId(e.getSlotId());
            return item;
        }).toList());
        cart.setPaymentMethod(Transaction.PaymentMethod.valueOf(dto.getPaymentMethod().name()));
        return cart;
    }

    @Override
    public CartDto toDTO(Cart entity, DetailLevel level) {
        throw new UnsupportedOperationException();
    }
}
