package com.fptgang.backend.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.experimental.SuperBuilder;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDateTime;

@Entity
@Table(name = "blind_box_campaign")
@Data
@SuperBuilder
@AllArgsConstructor
@NoArgsConstructor
public class BlindBoxCampaign {
    @EmbeddedId
    private BlindBoxCampaignId id;

    @ManyToOne(fetch = FetchType.LAZY)
    @MapsId("blindBoxId")
    @JoinColumn(name = "blind_box_id", nullable = false)
    private BlindBox blindBox;

    @ManyToOne(fetch = FetchType.LAZY)
    @MapsId("promotionalCampaignId")
    @JoinColumn(name = "promotional_campaign_id", nullable = false)
    private PromotionalCampaign promotionalCampaign;

    @CreationTimestamp
    private LocalDateTime createdAt;

    @UpdateTimestamp
    private LocalDateTime updatedAt;

    @Column(nullable = false, columnDefinition = "BOOLEAN DEFAULT TRUE")
    @Builder.Default
    private Boolean isVisible = true;
}
