package com.fptgang.backend.model;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

@Embeddable
@Data
@NoArgsConstructor
@AllArgsConstructor
public class BlindBoxCampaignId implements Serializable {
    @Column(name = "blind_box_id")
    private Long blindBoxId;

    @Column(name = "promotional_campaign_id")
    private Long promotionalCampaignId;
}
