package com.fptgang.backend.model;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Entity
@Table(name = "ORDER_DETAIL")
@Data
@NoArgsConstructor
public class OrderDetail {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long orderDetailId;

    @Enumerated(EnumType.STRING)
    private PurchaseType purchaseType;

    @ManyToOne
    @JoinColumn(name = "blind_box_id")
    private BlindBox blindBox;

    @ManyToOne
    @JoinColumn(name = "pack_id")
    private Pack pack;

    @Column(precision = 10, scale = 2)
    private BigDecimal historicalPrice;

    private boolean requestOpen;
    private boolean reSell;

    @ManyToOne
    private Order order;
}