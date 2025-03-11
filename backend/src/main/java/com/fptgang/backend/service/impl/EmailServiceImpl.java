package com.fptgang.backend.service.impl;

import com.fptgang.backend.mapper.template.OrderPlacedEmailTemplateMapper;
import com.fptgang.backend.model.Order;
import com.fptgang.backend.service.EmailService;
import com.fptgang.backend.util.TemplateUtil;
import com.resend.Resend;
import com.resend.core.exception.ResendException;
import com.resend.services.emails.model.CreateEmailOptions;
import com.resend.services.emails.model.CreateEmailResponse;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.Resource;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.nio.charset.StandardCharsets;

@Service
@Slf4j
public class EmailServiceImpl implements EmailService {

    @Value("${RESEND_API_KEY}")
    private String API_KEY;
    @Value("${COMPANY_NAME}")
    private String companyName;
    @Value("${EMAIL_FROM}")
    private String emailFrom;

    @Value("classpath:template/OrderPlacedEmailTemplate.html")
    private Resource orderPlacedEmailTemplate;

    private final OrderPlacedEmailTemplateMapper orderPlacedEmailTemplateMapper;

    public EmailServiceImpl(OrderPlacedEmailTemplateMapper orderPlacedEmailTemplateMapper) {
        this.orderPlacedEmailTemplateMapper = orderPlacedEmailTemplateMapper;
    }

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
    public void sendOrderPlacedEmail(Order order) throws IOException {
        var template = orderPlacedEmailTemplate.getContentAsString(StandardCharsets.UTF_8);
        var data = orderPlacedEmailTemplateMapper.create(order);
        var subject = "Order Confirmation - " + order.getOrderId();
        var to = order.getAccount().getEmail();
        if (to == null) {
            throw new IllegalArgumentException("Email not found");
        }
        var content = TemplateUtil.render(orderPlacedEmailTemplate.getFilename(), template, data);
        System.out.println(content);
        sendMail(emailFrom, to, subject, content);
    }


}


