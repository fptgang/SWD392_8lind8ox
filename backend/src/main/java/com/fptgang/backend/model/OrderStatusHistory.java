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

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "account_id")
    private Account creator;

    @Enumerated(EnumType.STRING)
    @Column(name = "state", nullable = false)
    private State state;
    @CreationTimestamp
    private LocalDateTime createdAt;

    public enum State {
        CREATED, COURIER_ACCEPTED, SHIPPING, DELIVERED, RECEIVED, COMPLETED
    }

}
