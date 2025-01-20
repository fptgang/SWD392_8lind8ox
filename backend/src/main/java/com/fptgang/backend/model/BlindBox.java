package com.fptgang.backend.model;


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
    private Integer blindBoxId;

    @ManyToOne
    @JoinColumn(name = "category_id")
    private Category category;

    @ManyToOne
    @JoinColumn(name = "campaign_id")
    private PromotionalCampaign campaign;

    @ManyToOne
    @JoinColumn(name = "package_id")
    private Package package_;

    private String name;
    private String description;
    private BigDecimal price;
    private String status;

    @OneToMany(mappedBy = "blindBox")
    private Set<OrderDetail> orderDetails = new HashSet<>();

    @OneToMany(mappedBy = "blindBox")
    private Set<Video> videos = new HashSet<>();

    @OneToMany(mappedBy = "blindBox")
    private Set<Image> images = new HashSet<>();
}
