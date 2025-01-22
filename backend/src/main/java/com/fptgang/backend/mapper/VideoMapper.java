package com.fptgang.backend.mapper;

import com.fptgang.backend.api.model.VideoDto;
import com.fptgang.backend.model.Video;
import com.fptgang.backend.repository.AccountRepos;
import com.fptgang.backend.repository.BlindBoxRepos;
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
    private BlindBoxRepos blindBoxRepos;
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
            existingVideo.setUploadDate(dto.getUploadDate() != null ? DateTimeUtil.fromOffsetToLocal(dto.getUploadDate()) : existingVideo.getUploadDate());
            existingVideo.setVisible(dto.getIsVisible() != null ? dto.getIsVisible() : existingVideo.isVisible());
            // Set other fields similarly

            return existingVideo;
        } else {
            Video entity = new Video();
            entity.setVideoId(dto.getVideoId());
            entity.setUrl(dto.getUrl());
            entity.setDescription(dto.getDescription());
            entity.setUploadDate(DateTimeUtil.fromOffsetToLocal(dto.getUploadDate()));
            entity.setVisible(dto.getIsVisible() != null ? dto.getIsVisible() : entity.isVisible());
            if(dto.getBlindBoxId() != null) {
                entity.setBlindBox(blindBoxRepos.findById(dto.getBlindBoxId()).get());
            }
            if(dto.getAccountId() != null) {
                entity.setAccount(accountRepos.findById(dto.getAccountId()).get());
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
        dto.setUploadDate(DateTimeUtil.fromLocalToOffset(entity.getUploadDate()));
        dto.setBlindBoxId(entity.getBlindBox() != null ? entity.getBlindBox().getBlindBoxId() : null);
        dto.setAccountId(entity.getAccount() != null ? entity.getAccount().getAccountId() : null);
        dto.setIsVisible(entity.isVisible());
        // Set other fields similarly

        return dto;
    }
}