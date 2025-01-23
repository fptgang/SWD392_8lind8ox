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
@Table(name = "packs")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Pack {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long packId;

    private String name;
    private String description;

    @Column(precision = 10, scale = 2)
    private BigDecimal packagePrice;

    @ManyToOne
    @JoinColumn(name = "secret_item_id")
    private Item secretItem;

    @Column(precision = 5, scale = 2)
    private BigDecimal secretChance;

    @ManyToOne
    private Brand brand;

    @OneToMany(mappedBy = "pack", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<PackContent> contents = new ArrayList<>();
}