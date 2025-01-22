package com.fptgang.backend.model;


import com.fptgang.backend.util.Searchable;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

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
    @Column(columnDefinition = "NVARCHAR(255)")
    private String name;
    @Searchable
    @Column(columnDefinition = "TEXT")
    private String description;
    private BigDecimal price;
    private String status;

    @CreationTimestamp
    private LocalDateTime createdDate;
    @UpdateTimestamp
    private LocalDateTime updatedDate;

    @Column(nullable = false, columnDefinition = "BOOLEAN DEFAULT TRUE")
    private boolean isVisible = true;

    @OneToMany(mappedBy = "blindBox", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<OrderDetail> orderDetails = new ArrayList<>();

    @OneToMany(mappedBy = "blindBox", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Video> videos = new ArrayList<>();

    @OneToMany(mappedBy = "blindBox", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Image> images = new ArrayList<>();
}
