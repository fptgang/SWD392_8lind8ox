package com.fptgang.backend.model;


import com.fptgang.backend.util.Searchable;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.experimental.SuperBuilder;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "sku")
@Data
@SuperBuilder
@AllArgsConstructor
@NoArgsConstructor
public class StockKeepingUnit {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long skuId;
    @Column(nullable = false, columnDefinition = "NVARCHAR(255)")
    @Searchable
    private String name;
    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "image_id")
    private Image image;
    @Column(nullable = false, precision = 10, scale = 2)
    private BigDecimal price;

    @Column(nullable = false, columnDefinition = "INT DEFAULT 0")
    private Integer stock;

    @Column(nullable = false, columnDefinition = "INT DEFAULT 1")
    private Integer specCount;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "blind_box_id", nullable = false)
    private BlindBox blindBox;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "order_detail_id")
    private OrderDetail orderDetail;

    @CreationTimestamp
    private LocalDateTime createdAt;

    @UpdateTimestamp
    private LocalDateTime updatedAt;

    @Column(nullable = false, columnDefinition = "BOOLEAN DEFAULT TRUE")
    private boolean isVisible = true;

}
