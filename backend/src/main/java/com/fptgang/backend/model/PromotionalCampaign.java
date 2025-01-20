package com.fptgang.backend.model;


import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name = "promotional_campaigns")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class PromotionalCampaign {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer campaignId;

    @ManyToOne
    @JoinColumn(name = "creator_id")
    private Account creator;

    private String title;
    private String description;
    private LocalDateTime startDate;
    private LocalDateTime endDate;
    private BigDecimal discountRate;
    private String code;
    private Long quantity; // -1 for infinite

    @OneToMany(mappedBy = "campaign")
    private Set<BlindBox> blindBoxes = new HashSet<>();
}
