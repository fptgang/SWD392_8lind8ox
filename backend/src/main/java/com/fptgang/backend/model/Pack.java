package com.fptgang.backend.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;
import lombok.experimental.SuperBuilder;

import java.util.List;

@SuppressWarnings({"JpaObjectClassSignatureInspection", "LombokAllArgsInspection"})
@Entity
@Table(name = "packs")
@Data
@EqualsAndHashCode(callSuper = true)
@SuperBuilder
@AllArgsConstructor
@NoArgsConstructor
public class Pack extends Product {

    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(
            name = "pack_guaranteed_toy",
            joinColumns = @JoinColumn(name = "product_id"),
            inverseJoinColumns = @JoinColumn(name = "toy_id")
    )
    private List<Toy> guaranteedToys;

    @Column(nullable = false)
    private int toyCount;
}