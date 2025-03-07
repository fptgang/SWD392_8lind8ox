package com.fptgang.backend.model.checkout;

import com.fptgang.backend.model.Order;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class PlaceOrderResult {
    private Order order;
    private String paymentRedirectUrl;
}
