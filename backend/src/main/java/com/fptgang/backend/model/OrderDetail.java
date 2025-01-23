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
import java.util.List;

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
    @JoinColumn(nullable = false, name = "product_id")
    private Product product;

    @ManyToOne
    @JoinColumn(name = "campaign_id")
    @Nullable
    private PromotionalCampaign promotionalCampaign;

    @Column(nullable = false, precision = 10, scale = 2)
    private BigDecimal originalProductPrice;

    @Column(nullable = false, precision = 10, scale = 2)
    private BigDecimal discountPrice;

    @Column(nullable = false)
    private boolean requestUnbox;

    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(
            name = "order_detail_toy",
            joinColumns = @JoinColumn(name = "order_detail_id"),
            inverseJoinColumns = @JoinColumn(name = "toy_id")
    )
    private List<Toy> unboxedToys;

    @Column(nullable = false)
    private int toyCount;

    @OneToOne(mappedBy = "orderDetail")
    @Nullable
    private Video video;

    @CreationTimestamp
    private LocalDateTime createdAt;

    @UpdateTimestamp
    private LocalDateTime updatedAt;
}