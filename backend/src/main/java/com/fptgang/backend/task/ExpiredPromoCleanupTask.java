package com.fptgang.backend.task;

import com.fptgang.backend.model.PromotionalCampaign;
import com.fptgang.backend.service.PromotionalCampaignService;
import com.fptgang.backend.service.params.ListParams;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Pageable;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;

@Component
@Slf4j
public class ExpiredPromoCleanupTask {
    private final PromotionalCampaignService promotionalCampaignService;

    public ExpiredPromoCleanupTask(PromotionalCampaignService promotionalCampaignService) {
        this.promotionalCampaignService = promotionalCampaignService;
    }

    @Scheduled(fixedRate = 300_000) // Runs every 5 minutes
    public void runTask() {
        int count = 0;
        for (PromotionalCampaign p : promotionalCampaignService.getAll(ListParams.builder()
                .pageable(Pageable.ofSize(20))
                .setFilter("endDate", "lt", LocalDateTime.now())
                .includeInvisible(false)
                .build())) {
            promotionalCampaignService.deleteById(p.getCampaignId());
            count++;
        }
        log.info("Cleaned up {} expired promotional campaigns", count);
    }
}
