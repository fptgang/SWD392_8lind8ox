package com.fptgang.backend.mapper.template;

import com.fptgang.backend.model.Account;
import com.fptgang.backend.model.Voucher;
import com.fptgang.backend.util.DateTimeUtil;
import com.fptgang.backend.util.CurrencyUtil;
import org.springframework.stereotype.Component;

import java.util.Map;
import java.util.Optional;

@Component
public class VoucherGiftedEmailTemplateMapper implements TemplateMapper<Voucher> {
    @Override
    public Map<String, Object> create(Voucher entity) {
        return Map.of(
                "voucherId", entity.getVoucherId(),
                "account", Map.of(
                        "firstName", Optional.ofNullable(entity.getAccount()).map(Account::getFirstName).orElse(""),
                        "lastName", Optional.ofNullable(entity.getAccount()).map(Account::getLastName).orElse(""),
                        "email", Optional.ofNullable(entity.getAccount()).map(Account::getEmail).orElse("")
                ),
                "code", entity.getCode(),
                "discountRate", entity.getDiscountRate(),
                "limitAmount", CurrencyUtil.format(entity.getLimitAmount()),
                "expiredAt", DateTimeUtil.formatDate(entity.getExpiredAt()),
                "giftedBy", "YourShop Team"
        );
    }
}
