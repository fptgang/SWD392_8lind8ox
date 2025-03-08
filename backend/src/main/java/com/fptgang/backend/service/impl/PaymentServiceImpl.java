package com.fptgang.backend.service.impl;

import com.fptgang.backend.model.Account;
import com.fptgang.backend.model.Transaction;
import com.fptgang.backend.service.AccountService;
import com.fptgang.backend.service.PaymentService;
import com.fptgang.backend.service.TransactionService;
import com.fptgang.backend.service.VNPAYService;
import com.fptgang.backend.util.SecurityUtil;
import jakarta.transaction.Transactional;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Service
@Slf4j
public class PaymentServiceImpl implements PaymentService {
    private final VNPAYService vnpayService;
    private final TransactionService transactionService;
    private final AccountService accountService;

    public PaymentServiceImpl(VNPAYService vnpayService,
                              TransactionService transactionService,
                              AccountService accountService) {
        this.vnpayService = vnpayService;
        this.transactionService = transactionService;
        this.accountService = accountService;
    }

    @Override
    public String generatePaymentLinkForDeposit(Transaction.PaymentMethod method,
                                                BigDecimal amount,
                                                long transactionId) {
        if (method == Transaction.PaymentMethod.VNPAY) {
            return vnpayService.createVNPay(
                    "Deposit txn " + transactionId,
                    amount,
                    "Deposit#" + transactionId,
                    SecurityUtil.getRemoteAddress()
            );
        }
        throw new UnsupportedOperationException(method.name());
    }

    @Override
    public String generatePaymentLinkForOrder(Transaction.PaymentMethod method,
                                              BigDecimal amount,
                                              long transactionId,
                                              long orderId) {
        if (method == Transaction.PaymentMethod.VNPAY) {
            return vnpayService.createVNPay(
                    "Deposit txn " + transactionId + " for order " + orderId,
                    amount,
                    "DepositOrder#" + transactionId + "#" + orderId,
                    SecurityUtil.getRemoteAddress()
            );
        }
        throw new UnsupportedOperationException(method.name());
    }

    @Override
    @Transactional
    public void handleDepositCallback(Transaction.PaymentMethod method, long depositTxnId, boolean success) {
        Transaction trans = transactionService.findById(depositTxnId);
        if (trans == null) {
            throw new IllegalArgumentException("Transaction " + depositTxnId + " not found");
        }
        if (trans.getStatus() != Transaction.Status.PENDING) {
            throw new IllegalStateException("Transaction " + depositTxnId + " is not pending");
        }
        if (trans.getType() != Transaction.Type.DEPOSIT) {
            throw new IllegalStateException("Transaction " + depositTxnId + " type is not DEPOSIT");
        }
        if (trans.getPaymentMethod() != method) {
            throw new IllegalStateException("Transaction " + depositTxnId + " method is not " + method.name());
        }

        Account account = trans.getAccount();
        BigDecimal oldBalance = account.getBalance();
        BigDecimal newBalance = oldBalance;
        if (success) {
            newBalance = oldBalance.add(trans.getAmount());
            account.setBalance(newBalance);
            account.setUpdateBalanceAt(LocalDateTime.now());
            accountService.update(account);
        }

        trans.setStatus(success ? Transaction.Status.SUCCESS : Transaction.Status.FAILED);
        trans.setOldBalance(oldBalance);
        trans.setNewBalance(newBalance);
        transactionService.update(trans);

        log.info("Deposit txn {} paid status {}", trans.getTransactionId(), trans.getStatus());
    }
}
