package com.fptgang.backend.util;

import com.fptgang.backend.model.Account;
import com.fptgang.backend.security.AppUser;
import jakarta.validation.constraints.NotNull;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.security.oauth2.server.resource.authentication.JwtAuthenticationToken;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import javax.annotation.Nullable;
import java.util.Objects;

public class SecurityUtil {

    public static boolean isAuthenticated() {
        return SecurityContextHolder.getContext().getAuthentication() != null;
    }

    public static boolean isGuest() {
        return !isAuthenticated();
    }

    @NotNull
    public static long requireCurrentUserId() {
        var userId = getCurrentUserId();
        if (userId == null)
            throw new AccessDeniedException("User is not authenticated");
        return userId;
    }

    @Nullable
    public static Long getCurrentUserId() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

        if (authentication instanceof JwtAuthenticationToken auth) {
            return getIdFromJwt(auth.getToken());
        } else if (authentication instanceof UsernamePasswordAuthenticationToken auth) {
            if (auth.getPrincipal() instanceof AppUser appUser) {
                return appUser.getAccountId();
            } else {
                throw new RuntimeException("Unable to obtain AppUser");
            }
        }

        return null;
    }

    @NotNull
    public static String requireCurrentUserEmail() {
        var email = getCurrentUserEmail();
        if (email == null)
            throw new AccessDeniedException("User is not authenticated");
        return email;
    }

    @Nullable
    public static String getCurrentUserEmail() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

        if (authentication instanceof JwtAuthenticationToken auth) {
            return getEmailFromJwt(auth.getToken());
        } else if (authentication instanceof UsernamePasswordAuthenticationToken auth) {
            return ((User) auth.getPrincipal()).getUsername();
        }

        return null;
    }

    @SuppressWarnings("BooleanMethodIsAlwaysInverted")
    @NotNull
    public static boolean hasPermission(Account.Role role) {
        return requireCurrentUserRole().hasPermission(role);
    }

    @NotNull
    public static boolean isRole(Account.Role... roles) {
        for (Account.Role role : roles) {
            if (hasPermission(role)) {
                return true;
            }
        }
        return false;
    }

    @NotNull
    public static Account.Role requireCurrentUserRole() {
        var role = getCurrentUserRole();
        if (role == null)
            throw new AccessDeniedException("User is not authenticated");
        return role;
    }

    @Nullable
    public static Account.Role getCurrentUserRole() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

        if (authentication instanceof JwtAuthenticationToken auth) {
            return getRoleFromJwt(auth.getToken());
        } else if (authentication instanceof UsernamePasswordAuthenticationToken auth) {
            String role = auth.getAuthorities().iterator().next().getAuthority();

            if (role.startsWith("ROLE_")) {
                role = role.substring(5);
            }

            return Account.Role.valueOf(role);
        }

        return null;
    }

    @Nullable
    public static Jwt getCurrentJwt() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

        if (authentication instanceof JwtAuthenticationToken) {
            return ((JwtAuthenticationToken) authentication).getToken();
        }

        return null;
    }

    @NotNull
    public static String getEmailFromJwt(Jwt jwt) {
        return Objects.requireNonNull(jwt.getSubject());
    }

    @Nullable
    public static Account.Role getRoleFromJwt(Jwt jwt) {
        String role = jwt.getClaimAsString("scope");
        if (role == null)
            return null;
        try {
            return Account.Role.valueOf(role);
        } catch (IllegalArgumentException e) {
            throw new AccessDeniedException("JWT containing invalid role");
        }
    }

    public static long getIdFromJwt(Jwt jwt) {
        String accountId = jwt.getClaimAsString("accountId");
        if (accountId == null)
            return 0;
        try {
            return Long.parseLong(accountId);
        } catch (NumberFormatException e) {
            throw new AccessDeniedException("JWT containing invalid id");
        }
    }

    @NotNull
    public static String getRemoteAddress() {
        ServletRequestAttributes attributes = (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
        if (attributes != null) {
            return attributes.getRequest().getRemoteAddr();
        }
        throw new IllegalStateException("Request attributes are not available");
    }
}
