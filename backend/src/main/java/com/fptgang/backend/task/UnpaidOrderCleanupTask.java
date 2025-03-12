package com.fptgang.backend.task;

import com.fptgang.backend.model.Order;
import com.fptgang.backend.model.OrderStatusHistory;
import com.fptgang.backend.service.OrderService;
import com.fptgang.backend.service.params.ListParams;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Pageable;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;

@Component
@Slf4j
public class UnpaidOrderCleanupTask {
    private final OrderService orderService;

    public UnpaidOrderCleanupTask(OrderService orderService) {
        this.orderService = orderService;
    }

    @Scheduled(fixedRate = 300_000) // Runs every 5 minutes
    public void runTask() {
        int count = 0;
        for (Order order : orderService.getAll(ListParams.builder()
                .pageable(Pageable.ofSize(20))
                .setFilter("latestStatus", "eq", "CREATED")
                .setFilter("createdAt", "lt", LocalDateTime.now().minusMinutes(15))
                .build())) {
            orderService.cancel(order, OrderStatusHistory.State.PAYMENT_EXPIRED);
            count++;
        }
        log.info("Cleaned up {} unpaid orders", count);
    }
}
