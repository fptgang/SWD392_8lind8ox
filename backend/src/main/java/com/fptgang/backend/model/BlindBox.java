package com.fptgang.backend.model;

import com.fptgang.backend.model.PromotionalCampaign;
import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "blind_box")
@Data
@NoArgsConstructor
public class BlindBox {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long blindBoxId;

    private String name;
    private String description;

    @Column(precision = 10, scale = 2)
    private BigDecimal currentPrice;

    private int stockQuantity;
    private boolean isOpened;

    @ManyToOne
    @JoinColumn(name = "campaign_id")
    private PromotionalCampaign campaign;


    @OneToMany(mappedBy = "blindBox")
    private List<BlindBoxContent> contents = new ArrayList<>();
}

