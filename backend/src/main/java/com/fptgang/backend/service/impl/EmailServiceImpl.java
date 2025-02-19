package com.fptgang.backend.service.impl;

import com.fptgang.backend.model.Account;
import com.fptgang.backend.model.Order;
import com.fptgang.backend.service.EmailService;
import com.resend.Resend;
import com.resend.core.exception.ResendException;
import com.resend.services.emails.model.CreateEmailOptions;
import com.resend.services.emails.model.CreateEmailResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.Resource;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.time.format.DateTimeFormatter;

@Service
public class EmailServiceImpl implements EmailService {


    private static final Logger log = LoggerFactory.getLogger(EmailServiceImpl.class);
    @Value("${RESEND_API_KEY}")
    private String API_KEY;
    @Value("${COMPANY_NAME}")
    private String companyName;
    @Value("classpath:template/OrderConfirmationTemplate.html")
    private Resource orderTemplate;

    @Override
    public void sendMail(String from, String to, String subject, String html) {
        // send email
        Resend resend = new Resend(API_KEY);
        CreateEmailOptions params = CreateEmailOptions.builder()
                //"Acme <onboarding@resend.dev>"
                .from(from )
                .to(to)
                .subject(subject)
                .html(html)
                .build();
        try {
            CreateEmailResponse data = resend.emails().send(params);
            System.out.println(data.getId());
        } catch (ResendException e) {
            log.info(e.getMessage());
        }
    }

    @Override
    public void sendOrderTemplate(Order order) throws IOException {

        String emailBody = orderTemplate.getContentAsString(StandardCharsets.UTF_8)
                .replace("{Customer Name}", order.getAccount().getFirstName() + " " + order.getAccount().getLastName())
                .replace("{OrderID}", String.valueOf(order.getOrderId()))
                .replace("{Order Date}", order.getCreatedAt().toString())
                .replace("{Total Amount}", String.format("%.2f", order.getCheckoutPrice()));
        String subject = "Order Confirmation - " + order.getOrderId();
        String from = "Admin <admin@mail.blindbox>";
        String to = order.getAccount().getEmail();

        sendMail(from, to, subject, emailBody);
        log.info("Order confirmation email sent successfully to: {}", to);

    }


}


