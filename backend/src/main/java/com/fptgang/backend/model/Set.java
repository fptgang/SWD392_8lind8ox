package com.fptgang.backend.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.experimental.SuperBuilder;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

//@SuppressWarnings({"JpaObjectClassSignatureInspection", "LombokAllArgsInspection"})
@Entity
@Table(name = "sets")
@Data
@SuperBuilder
@AllArgsConstructor
@NoArgsConstructor
public class Set {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long setId;

    @Column(nullable = false, precision = 10, scale = 2)
    private BigDecimal currentPrice;

    @OneToMany(mappedBy = "set", fetch = FetchType.LAZY, cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Image> images;

    @Column(nullable = false, columnDefinition = "BOOLEAN DEFAULT TRUE")
    private boolean isVisible = true;

    @OneToMany(mappedBy = "set", fetch = FetchType.LAZY, cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Slot> slots;

    @CreationTimestamp
    private LocalDateTime createdAt;

    @UpdateTimestamp
    private LocalDateTime updatedAt;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "blind_box_id", nullable = false)
    private BlindBox blindBox;


}