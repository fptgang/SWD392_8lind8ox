package com.fptgang.backend.mapper;

import com.fptgang.backend.api.model.VideoDto;
import com.fptgang.backend.model.Video;
import com.fptgang.backend.repository.AccountRepos;
import com.fptgang.backend.repository.SlotRepos;
import com.fptgang.backend.util.DateTimeUtil;
import org.springframework.stereotype.Component;

@Component
public class VideoMapper extends BaseMapper<VideoDto, Video> {
    private final AccountMapper accountMapper;
    private final AccountRepos accountRepos;
    private final SlotRepos slotRepos;

    public VideoMapper(AccountMapper accountMapper,
                       AccountRepos accountRepos,
                       SlotRepos slotRepos) {
        this.accountMapper = accountMapper;
        this.accountRepos = accountRepos;
        this.slotRepos = slotRepos;
    }

    @Override
    public Video toEntity(VideoDto dto) {
        if (dto == null) {
            return null;
        }

        Video entity = new Video();
        entity.setVideoId(dto.getVideoId());
        entity.setAccount(accountRepos.getReferenceById(dto.getAccount().getAccountId()));
        entity.setSlot(slotRepos.getReferenceById(dto.getSlotId()));
        entity.setUrl(dto.getUrl());
        entity.setDescription(dto.getDescription());
        entity.setIsVisible(dto.getIsVisible());
        entity.setCreatedAt(DateTimeUtil.fromOffsetToLocal(dto.getCreatedAt()));
        entity.setUpdatedAt(DateTimeUtil.fromOffsetToLocal(dto.getUpdatedAt()));
        entity.setIsVerified(dto.getIsVerified());
        return entity;
    }

    @Override
    public VideoDto toDTO(Video entity, DetailLevel level) {
        if (entity == null) {
            return null;
        }

        VideoDto dto = new VideoDto();
        dto.setVideoId(entity.getVideoId());
        dto.setAccount(accountMapper.toDTO(entity.getAccount(), DetailLevel.REFERENCE));
        dto.setSlotId(entity.getSlot() != null ? entity.getSlot().getSlotId() : null);
        dto.setUrl(entity.getUrl());
        dto.setDescription(entity.getDescription());
        dto.setIsVisible(entity.getIsVisible());
        dto.setCreatedAt(DateTimeUtil.fromLocalToOffset(entity.getCreatedAt()));
        dto.setUpdatedAt(DateTimeUtil.fromLocalToOffset(entity.getUpdatedAt()));
        dto.setIsVerified(entity.getIsVerified());
        return dto;
    }
}