package com.fptgang.backend.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Entity
@Table(name = "transactions")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Transaction {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer transactionId;

    @ManyToOne
    @JoinColumn(name = "account_id")
    private Account account;

    private String type;
    private LocalDateTime dateTime;
    private String paymentMethod;
    private Double amount;
    private Double oldBalance;

    @OneToOne(mappedBy = "transaction")
    private Order order;
}