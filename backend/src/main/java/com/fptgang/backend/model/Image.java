package com.fptgang.backend.model;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;

@Entity
@Table(name = "image")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Image {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long imageId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "uploader_id", nullable = false)
    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    private Account uploader;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "blind_box_id")
    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    private BlindBox blindBox;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "toy_id")
    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    private Toy toy;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "sku_id")
    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    private StockKeepingUnit sku;

    @Column(nullable = false, columnDefinition = "NVARCHAR(255)")
    private String imageUrl;

    @Column(nullable = false, columnDefinition = "BOOLEAN DEFAULT TRUE")
    @Builder.Default
    private Boolean isVisible = true;

    @CreationTimestamp
    private LocalDateTime createdAt;
}