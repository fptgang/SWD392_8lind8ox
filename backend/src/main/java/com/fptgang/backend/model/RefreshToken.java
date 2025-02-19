package com.fptgang.backend.model;

import jakarta.annotation.Nullable;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.Instant;

@Table(name = "refresh_token")
@Entity
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class RefreshToken {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long refreshTokenId;

    @Column(nullable = false, unique = true, columnDefinition = "nvarchar(255)")
    private String token;

    @Nullable
    private String ipAddress;

    @Nullable
    private String sessionId;

    @Nullable
    private String clientInfo;

    @Column(nullable = false)
    private Instant expiryDate;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "account_id", nullable = false)
    private Account account;
}