package com.fptgang.backend.model;

import com.fptgang.backend.util.Searchable;
import jakarta.annotation.Nullable;
import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Table(name = "account")
public class Account {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long accountId;

    @Column(nullable = false, unique = true)
    @Searchable
    private String email;

    @Column(nullable = false, columnDefinition = "NVARCHAR(255)")
    @Searchable
    private String firstName;

    @Column(columnDefinition = "NVARCHAR(255)")
    @Searchable
    @Nullable
    private String lastName;

    @Nullable
    private String password;

    @Nullable
    private String avatarUrl;

    @Column(precision = 10, scale = 2, columnDefinition = "DECIMAL(10,2) DEFAULT 0.00")
    @Builder.Default
    private BigDecimal balance = BigDecimal.ZERO;

    @Nullable
    private LocalDateTime updateBalanceAt;

    @Column(nullable = false)
    @Enumerated(EnumType.STRING)
    private Role role;

//    @Column(nullable = false, columnDefinition = "BOOLEAN DEFAULT FALSE")
//    @Builder.Default
//    private Boolean isVerified = false;
//
//    @Nullable
//    private LocalDateTime verifiedAt;

    @Column(nullable = false, columnDefinition = "BOOLEAN DEFAULT TRUE")
    @Builder.Default
    private Boolean isVisible = true;

    @CreationTimestamp
    private LocalDateTime createdAt;

    @UpdateTimestamp
    private LocalDateTime updatedAt;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "default_shipping_info_id", nullable = true)
    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    @Nullable
    private ShippingInfo defaultShippingInfo;

    public enum Role {
        ADMIN,
        STAFF,
        CUSTOMER;

        public boolean hasPermission(Role perm) {
            return switch (this) {
                case ADMIN -> true;
                case STAFF ->
                        this == perm || perm == Role.CUSTOMER;
                default -> this == perm;
            };
        }
    }
}