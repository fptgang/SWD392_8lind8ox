package com.fptgang.backend;

import com.fptgang.backend.model.Account;
import com.fptgang.backend.model.Order;
import com.fptgang.backend.model.OrderDetail;
import com.fptgang.backend.model.StockKeepingUnit;
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
    public void testEmailTemplate() throws IOException {
        Order order = createExampleOrder();
        log.info("Order: {}", order);

        emailService.sendOrderPlacedEmail(
                order
        );
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
}
