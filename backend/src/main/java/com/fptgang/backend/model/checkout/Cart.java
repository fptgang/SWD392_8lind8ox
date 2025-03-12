package com.fptgang.backend.model.checkout;

import com.fptgang.backend.model.Transaction;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

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

    public void validateCart() {
        if (items == null) {
            throw new IllegalArgumentException("Cart items cannot be null");
        }

        Set<Integer> slotIds = new HashSet<>();
        Set<Long> skuIds = new HashSet<>();

        for (Item item : items) {
            if (item.getQuantity() == null || item.getQuantity() <= 0) {
                throw new IllegalArgumentException("Quantity must be positive");
            }
            if (item.getSkuId() == null) {
                throw new IllegalArgumentException("SkuId cannot be null");
            }

            if (item.getSlotId() != null) {
                if (item.getQuantity() != 1) {
                    throw new IllegalArgumentException("If slotId is not null, quantity must be 1");
                }
                if (!slotIds.add(item.getSlotId())) {
                    throw new IllegalArgumentException("Duplicate slotId found: " + item.getSlotId());
                }
            }

            if (!skuIds.add(item.getSkuId())) {
                throw new IllegalArgumentException("Duplicate skuId found: " + item.getSkuId());
            }
        }
    }
}
