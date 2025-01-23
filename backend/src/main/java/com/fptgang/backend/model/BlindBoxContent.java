package com.fptgang.backend.model;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Entity
@Table(name = "blind_box_content")
@Data
@NoArgsConstructor
public class BlindBoxContent {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long boxContentId;

    @Column(precision = 5, scale = 2)
    private BigDecimal probability;

    private boolean isSecret;

    @ManyToOne
    @JoinColumn(name = "blind_box_id")
    private BlindBox blindBox;

    @ManyToOne
    @JoinColumn(name = "item_id")
    private Item item;
}
