package com.fptgang.backend.service;

import com.fptgang.backend.model.Order;

import java.io.IOException;

public interface EmailService {

    void sendMail(String from, String to, String subject, String html);
    void sendOrderPlacedEmail(Order order) throws IOException;

}
