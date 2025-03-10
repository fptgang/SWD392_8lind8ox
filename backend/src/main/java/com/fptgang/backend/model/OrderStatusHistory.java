package com.fptgang.backend.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;

@Entity
@Table(name = "order_status_history")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class OrderStatusHistory {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "order_id")
    private Order order;

    @Enumerated(EnumType.STRING)
    @Column(name = "state", nullable = false)
    private State state;

    @CreationTimestamp
    private LocalDateTime createdAt;

    public enum State {
        CREATED, // Order created, in payment

        PREPARING, // Paid success, staff is preparing
        PAYMENT_FAILED, // Failed to pay
        PAYMENT_EXPIRED, // Not paid in time
        CANCELED, // Customer canceled before paid

        READY_FOR_PICKUP, // Staff has done package, waiting for courier to pickup
        SHIPPING, // Courier is shipping
        DELIVERED, // Courier delivered
        RECEIVED, // Customer confirmed received
        COMPLETED, // The order completed without issues
    }

}
