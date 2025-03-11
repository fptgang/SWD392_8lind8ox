package com.fptgang.backend.service;

import com.fptgang.backend.model.Order;
import com.fptgang.backend.model.Video;
import com.fptgang.backend.model.Voucher;

import java.io.IOException;

public interface EmailService {

    void sendMail(String from, String to, String subject, String html);
    void sendOrderPlacedEmail(Order order) throws IOException;
    void sendUnpaidOrderEmail(Order order) throws IOException;
    void sendOrderPaidEmail(Order order) throws IOException;
    void sendOrderCancelledEmail(Order order) throws IOException;
    void sendOrderShippedEmail(Order order) throws IOException;
    void sendOrderDeliveredEmail(Order order) throws IOException;
    void sendVideoSubmittedEmail(Video video) throws IOException;
    void sendVideoVerifiedEmail(Video video) throws IOException;
    void sendVoucherGiftedEmail(Voucher voucher) throws IOException;
}
