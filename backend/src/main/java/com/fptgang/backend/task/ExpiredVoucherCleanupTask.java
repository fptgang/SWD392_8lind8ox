package com.fptgang.backend.task;

import com.fptgang.backend.model.Voucher;
import com.fptgang.backend.service.VoucherService;
import com.fptgang.backend.service.params.ListParams;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Pageable;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;

@Component
@Slf4j
public class ExpiredVoucherCleanupTask {
    private final VoucherService voucherService;

    public ExpiredVoucherCleanupTask(VoucherService voucherService) {
        this.voucherService = voucherService;
    }

    @Scheduled(fixedRate = 300_000) // Runs every 5 minutes
    public void runTask() {
        int count = 0;
        for (Voucher v : voucherService.getAll(ListParams.builder()
                .pageable(Pageable.ofSize(20))
                .setFilter("endDate", "lt", LocalDateTime.now())
                .includeInvisible(false)
                .build())) {
            v.setState(Voucher.State.EXPIRED);
            voucherService.update(v);
            count++;
        }
        log.info("Cleaned up {} expired vouchers ", count);
    }
}
