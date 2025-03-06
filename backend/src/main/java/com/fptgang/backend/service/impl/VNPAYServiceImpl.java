package com.fptgang.backend.service.impl;

import com.fptgang.backend.config.VnPayConfig;
import com.fptgang.backend.model.Account;
import com.fptgang.backend.model.Transaction;
import com.fptgang.backend.repository.TransactionRepos;
import com.fptgang.backend.service.OrderService;
import com.fptgang.backend.service.VNPAYService;
import com.fptgang.backend.service.params.ListParams;
import com.fptgang.backend.util.SecurityUtil;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
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
public class VNPAYServiceImpl implements VNPAYService {

    @Override
    public String createVNPay(Transaction transaction) {
        String vnp_IpAddr= SecurityUtil.getRemoteAddress();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMddHHmmss");
        ZonedDateTime now = ZonedDateTime.now(ZoneId.of("Asia/Ho_Chi_Minh"));

        Map<String, String> vnp_Params = new HashMap<>();
        vnp_Params.put("vnp_Version", "2.1.0");
        vnp_Params.put("vnp_Command", "pay");
        vnp_Params.put("vnp_TmnCode", VnPayConfig.vnp_TmnCode);
        vnp_Params.put("vnp_Amount", transaction.getAmount().multiply(BigDecimal.valueOf(100)).intValue() + "");
        vnp_Params.put("vnp_CreateDate", formatter.format(now));
        vnp_Params.put("vnp_CurrCode", "VND");
        vnp_Params.put("vnp_IpAddr", vnp_IpAddr);
        vnp_Params.put("vnp_Locale", VnPayConfig.vnp_Locale);
        vnp_Params.put("vnp_OrderInfo", transaction.getType() + " #" + transaction.getTransactionId());
        vnp_Params.put("vnp_OrderType", "250000");
        vnp_Params.put("vnp_ReturnUrl", VnPayConfig.vnp_ReturnUrl);
        vnp_Params.put("vnp_ExpireDate", formatter.format(now.plusMinutes(15)));
        vnp_Params.put("vnp_TxnRef", String.valueOf(transaction.getTransactionId()));

        Account account = transaction.getAccount();
        if (account == null) {
            throw new IllegalArgumentException("Account does not exist");
        }

//        //Billing
//        vnp_Params.put("vnp_Bill_Mobile", "0123456789");
//        vnp_Params.put("vnp_Bill_Email", account.getEmail());
//        vnp_Params.put("vnp_Bill_FirstName", "");
//        vnp_Params.put("vnp_Bill_LastName", "");
//        if(account.getFirstName() != null && !account.getFirstName().isEmpty()) {
//            vnp_Params.put("vnp_Bill_FirstName", account.getFirstName());
//        }
//        if(account.getLastName() != null && !account.getLastName().isEmpty()) {
//            vnp_Params.put("vnp_Bill_LastName", account.getLastName());
//        }
//
//        vnp_Params.put("vnp_Bill_Address", "123");
//        vnp_Params.put("vnp_Bill_City", "Hanoi");
//        vnp_Params.put("vnp_Bill_Country", "Vietnam");
//        vnp_Params.put("vnp_Bill_State", "Hanoi");
//
//        // Invoice
//        vnp_Params.put("vnp_Inv_Phone", "0123456789");
//        vnp_Params.put("vnp_Inv_Email", account.getEmail());
//        vnp_Params.put("vnp_Inv_Customer", normalize(account.getFirstName() + " " + account.getLastName()) );
//        vnp_Params.put("vnp_Inv_Address", "123");
//        vnp_Params.put("vnp_Inv_Company", "FPT");
//        vnp_Params.put("vnp_Inv_Taxcode", "123456789");
//        vnp_Params.put("vnp_Inv_Type", "1");

        //Build data to hash and querystring
        List<String> fieldNames = new ArrayList<>(vnp_Params.keySet());
        Collections.sort(fieldNames);
        StringBuilder hashData = new StringBuilder();
        StringBuilder query = new StringBuilder();

        Iterator<String> itr = fieldNames.iterator();
        while (itr.hasNext()) {
            String fieldName = itr.next();
            String fieldValue = vnp_Params.get(fieldName);
            if ((fieldValue != null) && (fieldValue.length() > 0)) {
                //Build hash data
                hashData.append(fieldName);
                hashData.append('=');
                hashData.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII));
                //Build query
                query.append(URLEncoder.encode(fieldName, StandardCharsets.US_ASCII));
                query.append('=');
                query.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII));
                if (itr.hasNext()) {
                    query.append('&');
                    hashData.append('&');
                }
            }
        }

        String queryUrl = query.toString();
        String vnp_SecureHash = VnPayConfig.hmacSHA512(VnPayConfig.secretKey, hashData.toString());
        String paymentUrl = VnPayConfig.vnp_PayUrl + "?" + queryUrl + "&vnp_SecureHash=" + vnp_SecureHash;

        log.info("VnPay URL: " + paymentUrl);

        return paymentUrl;
    }

}