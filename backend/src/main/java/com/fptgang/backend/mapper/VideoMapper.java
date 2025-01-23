package com.fptgang.backend.mapper;

import com.fptgang.backend.api.model.VideoDto;
import com.fptgang.backend.model.Video;
import com.fptgang.backend.repository.*;
import com.fptgang.backend.util.DateTimeUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.Optional;

@Component
public class VideoMapper extends BaseMapper<VideoDto, Video> {

    @Autowired
    private VideoRepos videoRepos;
    @Autowired
    private BlindBoxRepos blindBoxRepos;
    @Autowired
    private AccountRepos accountRepos;
    @Autowired
    private OrderRepos orderRepos;
    @Autowired
    private OrderDetailRepos orderDetailRepos;

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
            existingVideo.setCreatedAt(dto.getCreatedAt() != null ? DateTimeUtil.fromOffsetToLocal(dto.getCreatedAt()) : existingVideo.getCreatedAt());
            existingVideo.setVisible(dto.getIsVisible() != null ? dto.getIsVisible() : existingVideo.isVisible());
            // Set other fields similarly

            return existingVideo;
        } else {
            Video entity = new Video();
            entity.setVideoId(dto.getVideoId());
            entity.setUrl(dto.getUrl());
            entity.setDescription(dto.getDescription());
            entity.setCreatedAt(DateTimeUtil.fromOffsetToLocal(dto.getCreatedAt()));
            entity.setVisible(dto.getIsVisible() != null ? dto.getIsVisible() : entity.isVisible());
            if(dto.getOrderDetailId() != null) {
                entity.setOrderDetail(orderDetailRepos.findById(dto.getOrderDetailId()).get());
            }
            if(dto.getAccountId() != null) {
                entity.setAccount(accountRepos.findById(dto.getAccountId()).get());
            }
            if(dto.getCreatedAt() != null) {
                entity.setCreatedAt(DateTimeUtil.fromOffsetToLocal(dto.getCreatedAt()));
            }
            // Set other fields similarly

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
        dto.setCreatedAt(DateTimeUtil.fromLocalToOffset(entity.getCreatedAt()));
        dto.setOrderDetailId(entity.getOrderDetail() != null ? entity.getOrderDetail().getOrderDetailId() : null);
        dto.setAccountId(entity.getAccount() != null ? entity.getAccount().getAccountId() : null);
        dto.setIsVisible(entity.isVisible());
        if(entity.getCreatedAt() != null) {
            dto.setCreatedAt(DateTimeUtil.fromLocalToOffset(entity.getCreatedAt()));
        }
        // Set other fields similarly

        return dto;
    }
}