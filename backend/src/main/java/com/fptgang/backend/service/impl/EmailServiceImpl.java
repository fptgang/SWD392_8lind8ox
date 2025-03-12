package com.fptgang.backend.service.impl;

import com.fptgang.backend.mapper.template.*;
import com.fptgang.backend.model.Account;
import com.fptgang.backend.model.Order;
import com.fptgang.backend.model.Video;
import com.fptgang.backend.model.Voucher;
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

    @Value("classpath:template/UnpaidOrderEmailTemplate.html")
    private Resource unpaidOrderEmailTemplate;

    @Value("classpath:template/OrderPaidEmailTemplate.html")
    private Resource orderPaidEmailTemplate;

    @Value("classpath:template/OrderCancelledEmailTemplate.html")
    private Resource orderCancelledEmailTemplate;

    @Value("classpath:template/OrderShippedEmailTemplate.html")
    private Resource orderShippedEmailTemplate;

    @Value("classpath:template/OrderDeliveredEmailTemplate.html")
    private Resource orderDeliveredEmailTemplate;

    @Value("classpath:template/VideoSubmittedEmailTemplate.html")
    private Resource videoSubmittedEmailTemplate;

    @Value("classpath:template/VideoVerifiedEmailTemplate.html")
    private Resource videoVerifiedEmailTemplate;

    @Value("classpath:template/VoucherGiftedEmailTemplate.html")
    private Resource voucherGiftedEmailTemplate;

    @Value("classpath:template/ResetPasswordEmailTemplate.html")
    private Resource resetPasswordEmailTemplate;

    private final OrderPaidEmailTemplateMapper orderPaidEmailTemplateMapper;
    private final OrderPlacedEmailTemplateMapper orderPlacedEmailTemplateMapper;
    private final UnpaidOrderEmailTemplateMapper unpaidOrderEmailTemplateMapper;
    private final OrderCancelledEmailTemplateMapper orderCancelledEmailTemplateMapper;
    private final OrderShippedEmailTemplateMapper orderShippedEmailTemplateMapper;
    private final OrderDeliveredEmailTemplateMapper orderDeliveredEmailTemplateMapper;
    private final VideoSubmittedEmailTemplateMapper videoSubmittedEmailTemplateMapper;
    private final VideoVerifiedEmailTemplateMapper videoVerifiedEmailTemplateMapper;
    private final VoucherGiftedEmailTemplateMapper voucherGiftedEmailTemplateMapper;
    private final ResetPasswordEmailTemplateMapper resetPasswordEmailTemplateMapper;

    public EmailServiceImpl(OrderPlacedEmailTemplateMapper orderPlacedEmailTemplateMapper,
                            UnpaidOrderEmailTemplateMapper unpaidOrderEmailTemplateMapper,
                            OrderPaidEmailTemplateMapper orderPaidEmailTemplateMapper,
                            OrderCancelledEmailTemplateMapper orderCancelledEmailTemplateMapper,
                            OrderShippedEmailTemplateMapper orderShippedEmailTemplateMapper,
                            OrderDeliveredEmailTemplateMapper orderDeliveredEmailTemplateMapper,
                            VideoSubmittedEmailTemplateMapper videoSubmittedEmailTemplateMapper,
                            VideoVerifiedEmailTemplateMapper videoVerifiedEmailTemplateMapper,
                            VoucherGiftedEmailTemplateMapper voucherGiftedEmailTemplateMapper,
                            ResetPasswordEmailTemplateMapper resetPasswordEmailTemplateMapper) {
        this.orderPlacedEmailTemplateMapper = orderPlacedEmailTemplateMapper;
        this.unpaidOrderEmailTemplateMapper = unpaidOrderEmailTemplateMapper;
        this.orderPaidEmailTemplateMapper = orderPaidEmailTemplateMapper;
        this.orderCancelledEmailTemplateMapper = orderCancelledEmailTemplateMapper;
        this.orderShippedEmailTemplateMapper = orderShippedEmailTemplateMapper;
        this.orderDeliveredEmailTemplateMapper = orderDeliveredEmailTemplateMapper;
        this.videoSubmittedEmailTemplateMapper = videoSubmittedEmailTemplateMapper;
        this.videoVerifiedEmailTemplateMapper = videoVerifiedEmailTemplateMapper;
        this.voucherGiftedEmailTemplateMapper = voucherGiftedEmailTemplateMapper;
        this.resetPasswordEmailTemplateMapper = resetPasswordEmailTemplateMapper;
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

    @Override
    public void sendUnpaidOrderEmail(Order order) throws IOException {
        var template = unpaidOrderEmailTemplate.getContentAsString(StandardCharsets.UTF_8);
        var data = unpaidOrderEmailTemplateMapper.create(order);
        var subject = "Payment Pending - Order #" + order.getOrderId();
        var to = order.getAccount().getEmail();

        if (to == null) {
            throw new IllegalArgumentException("Email not found");
        }

        var content = TemplateUtil.render(unpaidOrderEmailTemplate.getFilename(), template, data);
        log.info("Unpaid order email content: {}", content);
        sendMail(emailFrom, to, subject, content);
    }

    @Override
    public void sendOrderPaidEmail(Order order) throws IOException {
        var template = orderPaidEmailTemplate.getContentAsString(StandardCharsets.UTF_8);
        var data = orderPaidEmailTemplateMapper.create(order);
        var subject = "Payment Confirmation - Order #" + order.getOrderId();
        var to = order.getAccount().getEmail();

        if (to == null) {
            throw new IllegalArgumentException("Email not found");
        }

        var content = TemplateUtil.render(orderPaidEmailTemplate.getFilename(), template, data);
        log.info("Order paid email content: {}", content);
        sendMail(emailFrom, to, subject, content);
    }

    @Override
    public void sendOrderCancelledEmail(Order order) throws IOException {
        var template = orderCancelledEmailTemplate.getContentAsString(StandardCharsets.UTF_8);
        var data = orderCancelledEmailTemplateMapper.create(order);
        var subject = "Order Cancelled - #" + order.getOrderId();
        var to = order.getAccount().getEmail();
        if (to == null) throw new IllegalArgumentException("Email not found");

        var content = TemplateUtil.render(orderCancelledEmailTemplate.getFilename(), template, data);
        sendMail(emailFrom, to, subject, content);
    }

    @Override
    public void sendOrderShippedEmail(Order order) throws IOException {
        var template = orderShippedEmailTemplate.getContentAsString(StandardCharsets.UTF_8);
        var data = orderShippedEmailTemplateMapper.create(order);
        var subject = "Order Shipped - Order #" + order.getOrderId();
        var to = order.getAccount().getEmail();

        if (to == null) {
            throw new IllegalArgumentException("Email not found");
        }

        var content = TemplateUtil.render(orderShippedEmailTemplate.getFilename(), template, data);
        log.info("Order shipped email content: {}", content);
        sendMail(emailFrom, to, subject, content);
    }

    @Override
    public void sendOrderDeliveredEmail(Order order) throws IOException {
        var template = orderDeliveredEmailTemplate.getContentAsString(StandardCharsets.UTF_8);
        var data = orderDeliveredEmailTemplateMapper.create(order);
        var subject = "Order Delivered - Order #" + order.getOrderId();
        var to = order.getAccount().getEmail();
        if (to == null) throw new IllegalArgumentException("Email not found");

        var content = TemplateUtil.render(orderDeliveredEmailTemplate.getFilename(), template, data);
        sendMail(emailFrom, to, subject, content);
    }

    @Override
    public void sendVideoSubmittedEmail(Video video) throws IOException {
        var template = videoSubmittedEmailTemplate.getContentAsString(StandardCharsets.UTF_8);
        var data = videoSubmittedEmailTemplateMapper.create(video);
        var subject = "Video Submission Received - #" + video.getVideoId();
        var to = video.getAccount().getEmail();
        if (to == null) throw new IllegalArgumentException("Email not found");

        var content = TemplateUtil.render(videoSubmittedEmailTemplate.getFilename(), template, data);
        sendMail(emailFrom, to, subject, content);
    }

    @Override
    public void sendVideoVerifiedEmail(Video video) throws IOException {
        var template = videoVerifiedEmailTemplate.getContentAsString(StandardCharsets.UTF_8);
        var data = videoVerifiedEmailTemplateMapper.create(video);
        var subject = "Video Verified - #" + video.getVideoId();
        var to = video.getAccount().getEmail();
        if (to == null) throw new IllegalArgumentException("Email not found");

        var content = TemplateUtil.render(videoVerifiedEmailTemplate.getFilename(), template, data);
        sendMail(emailFrom, to, subject, content);
    }

    @Override
    public void sendVoucherGiftedEmail(Voucher voucher) throws IOException {
        var template = voucherGiftedEmailTemplate.getContentAsString(StandardCharsets.UTF_8);
        var data = voucherGiftedEmailTemplateMapper.create(voucher);
        var subject = "🎁 You've Received a Gift Voucher!";
        var to = voucher.getAccount().getEmail();

        if (to == null) {
            throw new IllegalArgumentException("Email not found");
        }

        var content = TemplateUtil.render(voucherGiftedEmailTemplate.getFilename(), template, data);
        sendMail(emailFrom, to, subject, content);
    }

    @Override
    public void sendResetPasswordEmail(Account account, String resetLink) throws IOException {
        if (account.getEmail() == null || account.getEmail().isBlank()) {
            throw new IllegalArgumentException("Recipient email is missing.");
        }
        if (resetLink == null || resetLink.isBlank()) {
            throw new IllegalArgumentException("Reset link is missing.");
        }

        log.info("Preparing reset password email for: {}", account.getEmail());

        var template = resetPasswordEmailTemplate.getContentAsString(StandardCharsets.UTF_8);
        var data = resetPasswordEmailTemplateMapper.create(account, resetLink);
        String subject = "Password Reset Request";
        String content = TemplateUtil.render(resetPasswordEmailTemplate.getFilename(), template, data);

        sendMail(emailFrom, account.getEmail(), subject, content);

        log.info("Password reset email successfully sent to: {}", account.getEmail());
    }

}


