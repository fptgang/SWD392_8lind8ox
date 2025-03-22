package com.fptgang.backend.controller;

import com.fptgang.backend.api.controller.AccountsApi;
import com.fptgang.backend.api.model.AccountDto;
import com.fptgang.backend.api.model.GetAccounts200Response;
import com.fptgang.backend.api.model.Pageable;
import com.fptgang.backend.mapper.AccountMapper;
import com.fptgang.backend.mapper.DetailLevel;
import com.fptgang.backend.model.Account;
import com.fptgang.backend.service.AccountService;
import com.fptgang.backend.service.AzureBlobService;
import com.fptgang.backend.service.params.ListParams;
import com.fptgang.backend.util.OpenApiHelper;
import com.fptgang.backend.util.SecurityUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;

@Slf4j
@RestController
@RequestMapping("/api/v1")
public class AccountController implements AccountsApi {
    private final AccountService accountService;
    private final AccountMapper accountMapper;
    private final AzureBlobService azureBlobService;

    public AccountController(AccountService accountService,
                             AccountMapper accountMapper,
                             AzureBlobService azureBlobService) {
        this.accountService = accountService;
        this.accountMapper = accountMapper;
        this.azureBlobService = azureBlobService;
    }

    @Override
    public ResponseEntity<AccountDto> createAccount(AccountDto accountDto) {
        log.info("Creating account");

        return new ResponseEntity<>(
                accountMapper.toDTO(
                        accountService.create(accountMapper.toEntity(accountDto)),
                        DetailLevel.FULL
                ),
                HttpStatus.CREATED
        );
    }

    @Override
    public ResponseEntity<Void> deleteAccount(Long accountId) {
        log.info("Deleting account" + accountId);
        if (!SecurityUtil.hasPermission(Account.Role.ADMIN)) {
            throw new AccessDeniedException("Only admins can delete accounts.");
        }
        accountService.deleteById(accountId);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @Override
    public ResponseEntity<AccountDto> getAccountById(Long accountId) {
        log.info("Getting account by id ");
        return new ResponseEntity<>(accountMapper.toDTO(accountService.findById(accountId), DetailLevel.FULL), HttpStatus.OK);
    }

    @Override
    @PreAuthorize("hasAnyRole('ADMIN', 'STAFF')")
    public ResponseEntity<GetAccounts200Response> getAccounts(Pageable pageable, String filter, String search) {
        log.info("Getting accounts");

        var includeInvisible = SecurityUtil.hasPermission(Account.Role.ADMIN);
        var params = ListParams.builder()
                .pageable(OpenApiHelper.toPageable(pageable))
                .search(search)
                .filter(filter)
                .includeInvisible(includeInvisible);

        // Staff cannot view Admin
        if (SecurityUtil.hasRole(Account.Role.STAFF)) {
            params.setFilter("role", "in", "STAFF,CUSTOMER");
        }

        var res = accountService.getAll(params.build())
                .map(e -> accountMapper.toDTO(e, DetailLevel.SUMMARY));
        return OpenApiHelper.respondPage(res, GetAccounts200Response.class);
    }

    @Override
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<AccountDto> updateAccount(Long accountId, AccountDto accountDto) {
       
        accountDto.setAccountId(accountId); // Override accountId

        log.info("Updating account {}", accountId);

        if (!SecurityUtil.hasPermission(Account.Role.ADMIN)) {
            accountDto.setBalance(null);
            accountDto.setRole(null);
            accountDto.setIsVisible(null);
        }

        if (!SecurityUtil.hasPermission(Account.Role.STAFF)) {
            accountDto.setIsVerified(null);
            accountDto.setVerifiedAt(null);
        }

        if (SecurityUtil.hasRole(Account.Role.CUSTOMER)) {
            if (SecurityUtil.requireCurrentUserId() != accountId) {
                return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
            }
        }

        return ResponseEntity.ok(
                accountMapper.toDTO(
                        accountService.update(accountMapper.toEntity(accountDto)),
                        DetailLevel.FULL
                )
        );
    }

    /**
     * Can access: Any
     */
    @Override
    public ResponseEntity<AccountDto> updateAccountAvatar(Long accountId, MultipartFile blob) {
        log.info("Updating account avatar");

        if (!SecurityUtil.hasRole(Account.Role.STAFF))
            accountId = SecurityUtil.requireCurrentUserId();

        try {
            String fileUrl = azureBlobService.upload(blob);
            Account account = accountService.update(
                    Account.builder()
                            .accountId(accountId)
                            .avatarUrl(fileUrl)
                            .build()
            );
            return new ResponseEntity<>(accountMapper.toDTO(account, DetailLevel.FULL), HttpStatus.OK);
        } catch (IOException e) {
            log.error("Error updating account avatar", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
}
