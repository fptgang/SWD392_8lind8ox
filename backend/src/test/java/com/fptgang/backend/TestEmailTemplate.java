package com.fptgang.backend;

import com.fptgang.backend.model.*;
import com.fptgang.backend.service.EmailService;
import lombok.extern.slf4j.Slf4j;
import org.junit.jupiter.api.Disabled;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.context.TestConfiguration;
import org.springframework.context.annotation.Import;
import org.testcontainers.junit.jupiter.Testcontainers;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@Slf4j
@SpringBootTest
@TestConfiguration(proxyBeanMethods = false)
@Testcontainers
@Import(TestcontainersConfiguration.class)
@Disabled
public class TestEmailTemplate {
    @Autowired
    private EmailService emailService;

    @Test
    public void testOrderPlacedEmail() throws IOException {
        Order order = createExampleOrder();
        log.info("Testing Order Placed Email: {}", order);
        emailService.sendOrderPlacedEmail(order);
    }

    @Test
    public void testUnpaidOrderEmail() throws IOException {
        Order order = createExampleUnpaidOrder();
        log.info("Testing Unpaid Order Email: {}", order);
        emailService.sendUnpaidOrderEmail(order);
    }

    @Test
    public void testOrderPaidEmail() throws IOException {
        Order order = createExamplePaidOrder();
        log.info("Testing Order Paid Email: {}", order);
        emailService.sendOrderPaidEmail(order);
    }

    @Test
    public void testOrderCancelledEmail() throws IOException {
        Order order = createExampleCancelledOrder();
        log.info("Testing Order Cancelled Email: {}", order);
        emailService.sendOrderCancelledEmail(order);
    }

    @Test
    public void testOrderShippedEmail() throws IOException {
        Order order = createExampleShippedOrder();
        log.info("Testing Order Shipped Email: {}", order);
        emailService.sendOrderShippedEmail(order);
    }

    @Test
    public void testOrderDeliveredEmail() throws IOException {
        Order order = createExampleDeliveredOrder();
        log.info("Testing Order Delivered Email: {}", order);
        emailService.sendOrderDeliveredEmail(order);
    }

    @Test
    public void testVideoSubmittedEmail() throws IOException {
        Video video = createExampleVideo();
        log.info("Testing Video Submitted Email: {}", video);
        emailService.sendVideoSubmittedEmail(video);
    }

    @Test
    public void testVideoVerifiedEmail() throws IOException {
        Video video = createExampleVerifiedVideo();
        log.info("Testing Video Verified Email: {}", video);
        emailService.sendVideoVerifiedEmail(video);
    }

    @Test
    public void testVoucherGiftedEmail() throws IOException {
        Voucher voucher = createExampleVoucher();
        log.info("Testing Voucher Gifted Email: {}", voucher);
        emailService.sendVoucherGiftedEmail(voucher);
    }
    @Test
    public void testSendResetPasswordEmail() throws IOException {
        Account account = new Account();
        account.setFirstName("John");
        account.setEmail("biddify.vn@gmail.com");

        String resetLink = "https://yourshop.com/reset-password?token=test123";

        log.info("Testing Reset Password Email for {}", account.getEmail());

        emailService.sendResetPasswordEmail(account, resetLink);

        log.info("Reset Password Email sent successfully for {}", account.getEmail());
    }


    public static Order createExampleOrder() {
        Account account = new Account();
        account.setFirstName("John");
        account.setEmail("biddify.vn@gmail.com");

        StockKeepingUnit sku1 = new StockKeepingUnit();
        sku1.setName("Mystery Toy Box");

        OrderDetail detail1 = new OrderDetail();
        detail1.setStockKeepingUnit(sku1);
        detail1.setUnitPrice(BigDecimal.valueOf(19.99));
        detail1.setQuantity(2);
        detail1.setFinalTotal(BigDecimal.valueOf(39.98));

        StockKeepingUnit sku2 = new StockKeepingUnit();
        sku2.setName("Limited Edition Figure");

        OrderDetail detail2 = new OrderDetail();
        detail2.setStockKeepingUnit(sku2);
        detail2.setUnitPrice(BigDecimal.valueOf(49.99));
        detail2.setQuantity(1);
        detail2.setFinalTotal(BigDecimal.valueOf(49.99));

        Order order = new Order();
        order.setOrderId(123456L);
        order.setAccount(account);
        order.setOrderDetails(List.of(detail1, detail2));
        order.setSubTotal(BigDecimal.valueOf(89.97));
        order.setFinalTotal(BigDecimal.valueOf(89.97));

        return order;
    }

    private static Order createExampleUnpaidOrder() {
        Order order = createExampleOrder();
        order.setLatestStatus(OrderStatusHistory.State.CREATED);
        return order;
    }

    private static Order createExamplePaidOrder() {
        Order order = createExampleOrder();
        order.setLatestStatus(OrderStatusHistory.State.COMPLETED);
        return order;
    }

    private static Order createExampleCancelledOrder() {
        Order order = createExampleOrder();
        order.setLatestStatus(OrderStatusHistory.State.CANCELED);
        return order;
    }

    private static Order createExampleShippedOrder() {
        Order order = createExampleOrder();
        order.setLatestStatus(OrderStatusHistory.State.SHIPPING);
        return order;
    }

    private static Order createExampleDeliveredOrder() {
        Order order = createExampleOrder();
        order.setLatestStatus(OrderStatusHistory.State.DELIVERED);
        return order;
    }

    private static Video createExampleVideo() {
        Account account = new Account();
        account.setFirstName("John");
        account.setEmail("biddify.vn@gmail.com");

        Video video = new Video();
        video.setVideoId(654321L);
        video.setAccount(account);
        video.setUrl("https://yourshop.com/video/654321");
        video.setDescription("Test video submission.");
        return video;
    }

    private static Video createExampleVerifiedVideo() {
        Video video = createExampleVideo();
        video.setIsVerified(true);
        return video;
    }

    private static Voucher createExampleVoucher() {
        Account account = new Account();
        account.setFirstName("John");
        account.setEmail("biddify.vn@gmail.com");

        Voucher voucher = new Voucher();
        voucher.setVoucherId(789012L);
        voucher.setAccount(account);
        voucher.setCode("GIFT123");
        voucher.setDiscountRate(BigDecimal.valueOf(10.00));
        voucher.setLimitAmount(BigDecimal.valueOf(50.00));

        return voucher;
    }
}
