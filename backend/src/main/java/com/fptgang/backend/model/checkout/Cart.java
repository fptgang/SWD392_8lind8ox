package com.fptgang.backend.model.checkout;

import com.fptgang.backend.model.Transaction;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Cart {
    private Long accountId;
    private Long voucherId;
    private Long shippingInfoId;
    private Transaction.PaymentMethod paymentMethod;
    private List<Cart.Item> items;

    @Data
    @AllArgsConstructor
    @NoArgsConstructor
    public static class Item {
        private Long skuId;
        private Integer slotId;
        private Integer quantity;
    }
}
