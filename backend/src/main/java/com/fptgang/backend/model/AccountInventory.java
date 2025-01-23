package com.fptgang.backend.model;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Entity
@Table(name = "account_inventory")
@Data
@NoArgsConstructor
public class AccountInventory {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long inventoryId;

    @ManyToOne
    @JoinColumn(name = "account_id")
    private Account account;

    @ManyToOne
    @JoinColumn(name = "item_id")
    private Item item;

    private LocalDateTime acquiredDate;

    @ManyToOne
    @JoinColumn(name = "source_order_detail_id")
    private OrderDetail sourceOrderDetail;
}