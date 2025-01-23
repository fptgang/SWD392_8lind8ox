package com.fptgang.backend.model;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "pack_content")
@Data
@NoArgsConstructor
public class PackContent {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long packContentId;

    @ManyToOne
    @JoinColumn(name = "pack_id")
    private Pack pack;

    @ManyToOne
    @JoinColumn(name = "blind_box_id")
    private BlindBox blindBox;

    private Integer quantityPerPackage;
}
