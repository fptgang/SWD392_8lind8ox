package com.fptgang.backend.model;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "item")
@Data
@NoArgsConstructor
public class Item {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "item_id")
    private Long itemId;

    private String name;
    private String description;
    private String rarity;

    @OneToMany(mappedBy = "item")
    private List<BlindBoxContent> boxContents = new ArrayList<>();

    @OneToMany(mappedBy = "item")
    private List<AccountInventory> inventories = new ArrayList<>();
}
