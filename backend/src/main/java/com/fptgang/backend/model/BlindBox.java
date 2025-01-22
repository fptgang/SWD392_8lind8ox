package com.fptgang.backend.model;


import com.fptgang.backend.util.Searchable;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name = "blind_boxes")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class BlindBox {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long blindBoxId;

    @ManyToOne(cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "category_id")
    private Category category;

    @ManyToOne(cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "campaign_id")
    private PromotionalCampaign campaign;

    @ManyToOne(cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "pack_id")
    private Pack pack;

    @Searchable
    private String name;
    @Searchable
    private String description;
    private BigDecimal price;
    private String status;

    @Column(nullable = false, columnDefinition = "BOOLEAN DEFAULT TRUE")
    private boolean isVisible = true;

    @OneToMany(mappedBy = "blindBox", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private Set<OrderDetail> orderDetails = new HashSet<>();

    @OneToMany(mappedBy = "blindBox", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private Set<Video> videos = new HashSet<>();

    @OneToMany(mappedBy = "blindBox", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private Set<Image> images = new HashSet<>();
}
