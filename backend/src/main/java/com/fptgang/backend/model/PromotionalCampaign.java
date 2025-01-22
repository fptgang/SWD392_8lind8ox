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
@Table(name = "promotional_campaigns")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class PromotionalCampaign {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long campaignId;

    @ManyToOne( cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "creator_id")
    private Account creator;

    @Searchable
    @Column(columnDefinition = "NVARCHAR(255)")
    private String title;
    @Searchable
    @Column(columnDefinition = "TEXT")
    private String description;
    private LocalDateTime startDate;
    private LocalDateTime endDate;
    private BigDecimal discountRate;
    private String code;
    private Long quantity; // -1 for infinite
    @CreationTimestamp
    private LocalDateTime createdDate;
    @UpdateTimestamp
    private LocalDateTime updatedDate;
    @Column(nullable = false, columnDefinition = "BOOLEAN DEFAULT TRUE")
    private boolean isVisible = true;
    @OneToMany(mappedBy = "campaign", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<BlindBox> blindBoxes = new ArrayList<>();
}
