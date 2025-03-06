package com.fptgang.backend.service.impl;

import com.fptgang.backend.config.VnPayConfig;
import com.fptgang.backend.model.Account;
import com.fptgang.backend.model.Transaction;
import com.fptgang.backend.repository.TransactionRepos;
import com.fptgang.backend.service.AccountService;
import com.fptgang.backend.service.OrderService;
import com.fptgang.backend.service.TransactionService;
import com.fptgang.backend.service.VNPAYService;
import com.fptgang.backend.service.params.ListParams;
import com.fptgang.backend.util.OpenApiHelper;
import com.fptgang.backend.util.SecurityUtil;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;

@Slf4j
@Service
public class TransactionServiceImpl implements TransactionService {

    private final TransactionRepos transactionRepos;
    private final OrderService orderService;
    private final VNPAYService VNPAYService;
    private final AccountService accountService;

    @Autowired
    public TransactionServiceImpl(TransactionRepos transactionRepos, OrderService orderService, VNPAYService VNPAYService, AccountService accountService) {
        this.transactionRepos = transactionRepos;
        this.orderService = orderService;
        this.VNPAYService = VNPAYService;
        this.accountService = accountService;
    }

    @Override
    public String create(Transaction transaction) {
        if (transaction.getOrder() != null) {
            if (transaction.getOrder().getTransaction() != null) {
                if (transaction.getOrder().getTransaction().getStatus() != Transaction.Status.SUCCESS) {
                    transaction.getOrder().setTransaction(null);
                    orderService.update(
                            transaction.getOrder()
                    );
                } else {
                    throw new IllegalArgumentException("Order already paid");
                }
            }
        }
        try {
            transaction.setOldBalance(transaction.getAccount().getBalance());
            transaction.setNewBalance(transaction.getAccount().getBalance());
            transaction.setStatus(Transaction.Status.PENDING);
            transaction = transactionRepos.save(transaction);
            if (transaction.getPaymentMethod() == Transaction.PaymentMethod.VNPAY) {
                return VNPAYService.createVNPay(transaction, SecurityUtil.getRemoteAddress());
            }
            return "Transaction created successfully";
        } catch (Exception e) {
            log.info("Transaction creation failed " + e.getMessage());
            throw new IllegalArgumentException("Transaction creation failed");
        }
    }

    @Override
    public Transaction findById(long id) {
        return transactionRepos.findById(id).orElse(null);
    }

    @Override
    public Transaction update(Transaction transaction) {
        if (transaction.getTransactionId() == null) {
            throw new IllegalArgumentException("Transaction does not exist");
        }
        if (transaction.getStatus() == Transaction.Status.SUCCESS)
            switch (transaction.getType()) {
                case DEPOSIT -> {
                    Account account = transaction.getAccount();
                    transaction.setOldBalance(account.getBalance());
                    account.setBalance(account.getBalance().add(transaction.getAmount()));
                    transaction.setNewBalance(account.getBalance());
                    account=accountService.update(account);
                    transaction.setAccount(account);
                }
//                case WITHDRAW, PAYOUT -> {
//                    transaction.setOldBalance(transaction.getAccount().getBalance());
//                    transaction.setNewBalance(transaction.getAccount().getBalance().subtract(transaction.getAmount()));
//                }
                case ORDER -> {
                    transaction.getOrder().setTransaction(transaction);
                    orderService.update(transaction.getOrder());
                }
            }

        return transactionRepos.save(transaction);
    }

    @Override
    public Transaction deleteById(long id) {
        Transaction transaction = transactionRepos.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Transaction does not exist"));
//        transaction.setIsVisible(false);
        return transactionRepos.save(transaction);
    }

    @Override
    public Page<Transaction> getAll(ListParams params) {
        var spec = params.<Transaction>toSpec();
        return transactionRepos.findAll(spec, params.getPageable());
    }
}