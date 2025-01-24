package com.fptgang.backend.model;

import com.fptgang.backend.util.Searchable;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;
import lombok.experimental.SuperBuilder;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@SuppressWarnings({"JpaObjectClassSignatureInspection", "LombokAllArgsInspection"})
@Entity
@Table(name = "packs")
@Data
@SuperBuilder
@AllArgsConstructor
@NoArgsConstructor
public class Pack {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long packId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "brand_id", nullable = false)
    private Brand brand;

    @Column(nullable = false, columnDefinition = "NVARCHAR(255)")
    @Searchable
    private String name;

    @Column(nullable = false, columnDefinition = "TEXT", length = 100_000)
    @Searchable
    private String description;

    @Column(nullable = false, precision = 10, scale = 2)
    private BigDecimal currentPrice;

    @OneToMany(mappedBy = "pack", fetch = FetchType.LAZY, cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Image> images;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "promotional_campaign_id", nullable = false)
    private PromotionalCampaign promotionalCampaign;

    @Column(nullable = false, columnDefinition = "BOOLEAN DEFAULT TRUE")
    private boolean isVisible = true;

    @CreationTimestamp
    private LocalDateTime createdAt;

    @UpdateTimestamp
    private LocalDateTime updatedAt;

    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(
            name = "pack_guaranteed_toy",
            joinColumns = @JoinColumn(name = "product_id"),
            inverseJoinColumns = @JoinColumn(name = "toy_id")
    )
    private List<Toy> guaranteedToys;

    @Column(nullable = false)
    private int toyCount;
}