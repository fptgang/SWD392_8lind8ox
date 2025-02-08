package com.fptgang.backend.mapper;

import com.fptgang.backend.api.model.VideoDto;
import com.fptgang.backend.model.Video;
import com.fptgang.backend.repository.AccountRepos;
import com.fptgang.backend.repository.VideoRepos;
import com.fptgang.backend.util.DateTimeUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.Optional;

@Component
public class VideoMapper extends BaseMapper<VideoDto, Video> {

    @Autowired
    private VideoRepos videoRepos;
    @Autowired
    private AccountRepos accountRepos;

    @Override
    public Video toEntity(VideoDto dto) {
        if (dto == null) {
            return null;
        }

        Optional<Video> existingVideoOptional = videoRepos.findById(dto.getVideoId());

        if (existingVideoOptional.isPresent()) {
            Video existingVideo = existingVideoOptional.get();
            existingVideo.setUrl(dto.getUrl() != null ? dto.getUrl() : existingVideo.getUrl());
            existingVideo.setDescription(dto.getDescription() != null ? dto.getDescription() : existingVideo.getDescription());
            existingVideo.setVisible(dto.getIsVisible() != null ? dto.getIsVisible() : existingVideo.isVisible());
            existingVideo.setCreatedAt(dto.getCreatedAt() != null ? DateTimeUtil.fromOffsetToLocal(dto.getCreatedAt()) : existingVideo.getCreatedAt());
            existingVideo.setUpdatedAt(dto.getUpdatedAt() != null ? DateTimeUtil.fromOffsetToLocal(dto.getUpdatedAt()) : existingVideo.getUpdatedAt());
            if (dto.getAccountId() != null) {
                existingVideo.setAccount(accountRepos.findById(dto.getAccountId()).orElse(null));
            }
            return existingVideo;
        } else {
            Video entity = new Video();
            entity.setVideoId(dto.getVideoId());
            entity.setUrl(dto.getUrl());
            entity.setDescription(dto.getDescription());
            entity.setVisible(dto.getIsVisible() != null ? dto.getIsVisible() : entity.isVisible());
            entity.setCreatedAt(dto.getCreatedAt() != null ? DateTimeUtil.fromOffsetToLocal(dto.getCreatedAt()) : null);
            entity.setUpdatedAt(dto.getUpdatedAt() != null ? DateTimeUtil.fromOffsetToLocal(dto.getUpdatedAt()) : null);
            if (dto.getAccountId() != null) {
                entity.setAccount(accountRepos.findById(dto.getAccountId()).orElse(null));
            }
            return entity;
        }
    }

    @Override
    public VideoDto toDTO(Video entity) {
        if (entity == null) {
            return null;
        }

        VideoDto dto = new VideoDto();
        dto.setVideoId(entity.getVideoId());
        dto.setUrl(entity.getUrl());
        dto.setDescription(entity.getDescription());
        dto.setIsVisible(entity.isVisible());
        dto.setCreatedAt(entity.getCreatedAt() != null ? DateTimeUtil.fromLocalToOffset(entity.getCreatedAt()) : null);
        dto.setUpdatedAt(entity.getUpdatedAt() != null ? DateTimeUtil.fromLocalToOffset(entity.getUpdatedAt()) : null);
        dto.setAccountId(entity.getAccount() != null ? entity.getAccount().getAccountId() : null);
        return dto;
    }
}