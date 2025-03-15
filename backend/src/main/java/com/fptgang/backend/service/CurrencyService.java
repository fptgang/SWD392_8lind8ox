package com.fptgang.backend.service;

import com.fptgang.backend.util.CurrencyType;
import java.math.BigDecimal;

public interface CurrencyService {
    BigDecimal convertUsdToVnd(BigDecimal usdAmount);
    BigDecimal convert(BigDecimal amount, CurrencyType from, CurrencyType to);
    BigDecimal fetchLatestExchangeRate(CurrencyType to);
}
