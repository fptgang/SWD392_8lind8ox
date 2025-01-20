package com.fptgang.backend.model;


import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

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
    private Integer packageId;

    private String name;
    private String description;
    private Integer quantity;
    private Double price;

    @OneToMany(mappedBy = "package_")
    private Set<BlindBox> blindBoxes = new HashSet<>();

    @OneToMany(mappedBy = "package_")
    private Set<OrderDetail> orderDetails = new HashSet<>();
}