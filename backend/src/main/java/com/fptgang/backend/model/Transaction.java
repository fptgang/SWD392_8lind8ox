package com.fptgang.backend.model;

import jakarta.annotation.Nullable;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "transaction")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Transaction {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long transactionId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "account_id")
    private Account account;

    @Column(nullable = false)
    @Enumerated(EnumType.STRING)
    private Type type;

    @Column()
    @Enumerated(EnumType.STRING)
    private PaymentMethod paymentMethod;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "order_id")
    private Order order;

    @Column(precision = 10, scale = 2, nullable = false)
    private BigDecimal amount;

    @Column(precision = 10, scale = 2)
    @Nullable
    private BigDecimal oldBalance;

    @Column(precision = 10, scale = 2)
    @Nullable
    private BigDecimal newBalance;

    @Column(nullable = false)
    @Enumerated(EnumType.STRING)
    private Status status;

    @CreationTimestamp
    private LocalDateTime createdAt;

    @UpdateTimestamp
    private LocalDateTime updatedAt;

    public enum Status {
        PENDING,
        SUCCESS,
        FAILED
    }

    public enum Type {
        DEPOSIT,
        ORDER
    }

    public enum PaymentMethod {
        INTERNAL_WALLET,
        PAYPAL,
        VNPAY,
        PAYOS
    }
}