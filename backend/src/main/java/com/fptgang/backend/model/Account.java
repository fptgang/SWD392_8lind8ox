package com.fptgang.backend.model;

import com.fptgang.backend.util.Searchable;
import jakarta.annotation.Nullable;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
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
    private BigDecimal balance = BigDecimal.ZERO;

    @Nullable
    private LocalDateTime updateBalanceAt;

    @Column(nullable = false)
    @Enumerated(EnumType.STRING)
    private Role role;

    @Column(nullable = false, columnDefinition = "BOOLEAN DEFAULT FALSE")
    private boolean isVerified;

    @Nullable
    private LocalDateTime verifiedAt;

    @Column(nullable = false, columnDefinition = "BOOLEAN DEFAULT TRUE")
    private boolean isVisible = true;

    @CreationTimestamp
    private LocalDateTime createdAt;

    @UpdateTimestamp
    private LocalDateTime updatedAt;

    public enum Role {
        ADMIN,
        STAFF,
        CUSTOMER;

        @NotNull
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