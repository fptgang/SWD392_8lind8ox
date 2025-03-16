package com.fptgang.backend.security;

import com.fptgang.backend.model.Account;
import org.jetbrains.annotations.NotNull;
import org.springframework.lang.Nullable;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.authentication.InsufficientAuthenticationException;

public interface AuthContext {
    @Nullable Long getAccountId();
    @Nullable String getEmail();
    @Nullable Account.Role getRole();
    default long requireAccountId() {
        var val = getAccountId();
        if (val == null)
            throw new InsufficientAuthenticationException("User is not authenticated");
        return val;
    }
    default @NotNull String requireEmail() {
        var val = getEmail();
        if (val == null)
            throw new InsufficientAuthenticationException("User is not authenticated");
        return val;
    }
    default @NotNull Account.Role requireRole() {
        var val = getRole();
        if (val == null)
            throw new InsufficientAuthenticationException("User is not authenticated");
        return val;
    }
    default void requirePermission(Account.Role role) {
        if (!requireRole().hasPermission(role)) {
            throw new AccessDeniedException("No access");
        }
    }
    default void requireAccountId(long accountId) {
        if (requireAccountId() != accountId) {
            throw new AccessDeniedException("No access");
        }
    }
    default void requirePermissionOrAccountIds(Account.Role role, long... accountIds) {
        if (requireRole().hasPermission(role)) {
            return;
        }
        for (long accountId : accountIds) {
            if (requireAccountId() == accountId) {
                return;
            }
        }
        throw new AccessDeniedException("No access");
    }
    boolean isAuthenticated();
}
