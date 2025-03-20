package com.fptgang.backend.controller;

import com.fptgang.backend.api.controller.SlotsApi;
import com.fptgang.backend.api.model.GetSlots200Response;
import com.fptgang.backend.api.model.Pageable;
import com.fptgang.backend.api.model.SlotDto;
import com.fptgang.backend.mapper.DetailLevel;
import com.fptgang.backend.mapper.SlotMapper;
import com.fptgang.backend.model.Account;
import com.fptgang.backend.service.SlotService;
import com.fptgang.backend.service.params.ListParams;
import com.fptgang.backend.util.OpenApiHelper;
import com.fptgang.backend.util.SecurityUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@Slf4j
@RestController
@RequestMapping("/api/v1")
public class SlotController implements SlotsApi {

    private final SlotService slotService;
    private final SlotMapper slotMapper;

    @Autowired
    public SlotController(SlotService slotService, SlotMapper slotMapper) {
        this.slotService = slotService;
        this.slotMapper = slotMapper;
    }

    @Override
    public ResponseEntity<SlotDto> updateSlot(Long slotId, SlotDto slotDto) {
        if (!SecurityUtil.hasPermission(Account.Role.ADMIN)&& !SecurityUtil.hasPermission(Account.Role.STAFF)) {
            throw new AccessDeniedException("Only staff and admins can update slots.");
        }
        slotDto.setSlotId(slotId); // Override slotId

        return new ResponseEntity<>(
                slotMapper.toDTO(
                        slotService.update(
                                slotMapper.toEntity(slotDto)
                        ),
                        DetailLevel.FULL
                ),
                HttpStatus.OK
        );
    }
}