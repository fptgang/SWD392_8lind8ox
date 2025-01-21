package com.fptgang.backend.model;


import com.fptgang.backend.util.Searchable;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name = "packages")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Package {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long packageId;

    @Searchable
    private String name;
    @Searchable
    private String description;
    private Integer quantity;
    private BigDecimal price;

    @OneToMany(mappedBy = "package_", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private Set<BlindBox> blindBoxes = new HashSet<>();

    @OneToMany(mappedBy = "package_", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private Set<OrderDetail> orderDetails = new HashSet<>();
}