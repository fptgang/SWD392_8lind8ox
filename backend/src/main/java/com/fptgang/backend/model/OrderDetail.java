package com.fptgang.backend.model;

import jakarta.annotation.Nullable;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "order_details")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class OrderDetail {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long orderDetailId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(nullable = false, name = "order_id")
    private Order order;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(nullable = false, name = "sku_id")
    private StockKeepingUnit stockKeepingUnit;


    @ManyToOne
    @JoinColumn(name = "campaign_id")
    @Nullable
    private PromotionalCampaign promotionalCampaign;

    @Column(nullable = false, precision = 10, scale = 2)
    private BigDecimal originalPrice;

    @Column(nullable = false, precision = 10, scale = 2)
    private BigDecimal checkoutPrice;

//    @Column(nullable = false)
//    private boolean requestUnbox;
//
//    @ManyToMany(fetch = FetchType.LAZY)
//    @JoinTable(
//            name = "order_detail_toy",
//            joinColumns = @JoinColumn(name = "order_detail_id"),
//            inverseJoinColumns = @JoinColumn(name = "toy_id")
//    )
//    private List<Toy> unboxedToys;
//
//    @OneToOne(mappedBy = "orderDetail")
//    @Nullable
//    private Video video;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "slot_id")
    private Slot slot;

    @CreationTimestamp
    private LocalDateTime createdAt;

    @UpdateTimestamp
    private LocalDateTime updatedAt;
}