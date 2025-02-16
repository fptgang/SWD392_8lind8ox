package com.fptgang.backend.model;

import com.fptgang.backend.util.Searchable;
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
@Table(name = "promotional_campaign")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PromotionalCampaign {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long campaignId;


    @Column(nullable = false, columnDefinition = "NVARCHAR(255)")
    @Searchable
    private String title;

    @Column(nullable = false, columnDefinition = "TEXT", length = 100000)
    @Searchable
    private String description;

    @Column(nullable = false)
    private LocalDateTime startDate;

    @Column(nullable = false)
    private LocalDateTime endDate;

    @Column(nullable = false, precision = 5, scale = 2)
    private BigDecimal discountRate;

    @OneToMany(mappedBy = "promotionalCampaign", fetch = FetchType.LAZY)
    private List<BlindBox> blindBoxes;

    @OneToMany(mappedBy = "promotionalCampaign", fetch = FetchType.LAZY)
    private List<OrderDetail> orderDetails;

    @Column(nullable = false, columnDefinition = "BOOLEAN DEFAULT TRUE")
    private boolean isVisible = true;

    @CreationTimestamp
    private LocalDateTime createdAt;

    @UpdateTimestamp
    private LocalDateTime updatedAt;
}
