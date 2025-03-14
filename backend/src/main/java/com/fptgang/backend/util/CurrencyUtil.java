package com.fptgang.backend.util;

import java.math.BigDecimal;
import java.text.DecimalFormat;

public class CurrencyUtil {
    private static final DecimalFormat DF = new DecimalFormat("#,###.00");

    public static String format(double amount) {
        return DF.format(amount);
    }

    public static String format(long amount) {
        return DF.format(amount);
    }

    public static String format(Object amount) {
        return DF.format(amount);
    }

    // Convert USD to VND with a provided exchange rate
    public static BigDecimal convertUsdToVnd(BigDecimal usdAmount, BigDecimal exchangeRate) {
        return usdAmount.multiply(exchangeRate);
    }
}
