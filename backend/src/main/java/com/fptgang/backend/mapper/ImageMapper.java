package com.fptgang.backend.mapper;

import com.fptgang.backend.api.model.ImageDto;
import com.fptgang.backend.model.Image;
import com.fptgang.backend.repository.AccountRepos;
import com.fptgang.backend.repository.BlindBoxRepos;
import com.fptgang.backend.repository.ImageRepos;
import com.fptgang.backend.repository.SetRepos;
import com.fptgang.backend.util.DateTimeUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.Optional;

@Component
public class ImageMapper extends BaseMapper<ImageDto, Image> {

    @Autowired
    private ImageRepos imageRepos;
    @Autowired
    private BlindBoxRepos blindBoxRepos;
    @Autowired
    private AccountRepos accountRepos;
    @Autowired
    private SetRepos setRepos;

    @Override
    public Image toEntity(ImageDto dto) {
        if (dto == null) {
            return null;
        }

        Optional<Image> existingImageOptional = imageRepos.findById(dto.getImageId());

        if (existingImageOptional.isPresent()) {
            Image existingImage = existingImageOptional.get();
            existingImage.setImageUrl(dto.getImageUrl() != null ? dto.getImageUrl() : existingImage.getImageUrl());
            existingImage.setVisible(dto.getIsVisible() != null ? dto.getIsVisible() : existingImage.isVisible());
            if (dto.getBlindBoxId() != null) {
                existingImage.setBlindBox(blindBoxRepos.findById(dto.getBlindBoxId()).orElse(null));
            } else if (dto.getPackId() != null) {
                existingImage.setSet(setRepos.findById(dto.getPackId()).orElse(null));
            }
            if (dto.getUploaderId() != null) {
                existingImage.setUploader(accountRepos.findByAccountId(dto.getUploaderId()).orElse(null));
            }
            return existingImage;
        } else {
            Image entity = new Image();
            entity.setImageId(dto.getImageId());
            entity.setImageUrl(dto.getImageUrl());
            entity.setVisible(dto.getIsVisible() != null ? dto.getIsVisible() : entity.isVisible());
            if (dto.getBlindBoxId() != null) {
                entity.setBlindBox(blindBoxRepos.findById(dto.getBlindBoxId()).orElse(null));
            } else if (dto.getPackId() != null) {
                entity.setSet(setRepos.findById(dto.getPackId()).orElse(null));
            }
            if (dto.getUploaderId() != null) {
                entity.setUploader(accountRepos.findByAccountId(dto.getUploaderId()).orElse(null));
            }
            if (dto.getCreatedAt() != null) {
                entity.setCreatedAt(dto.getCreatedAt().toLocalDateTime());
            }
            return entity;
        }
    }

    @Override
    public ImageDto toDTO(Image entity) {
        if (entity == null) {
            return null;
        }

        ImageDto dto = new ImageDto();
        dto.setImageId(entity.getImageId());
        dto.setImageUrl(entity.getImageUrl());
        dto.setBlindBoxId(entity.getBlindBox() != null ? entity.getBlindBox().getBlindBoxId() : null);
        dto.setPackId(entity.getSet() != null ? entity.getSet().getSetId() : null);
        dto.setUploaderId(entity.getUploader() != null ? entity.getUploader().getAccountId() : null);
        dto.setIsVisible(entity.isVisible());
        if (entity.getCreatedAt() != null) {
            dto.setCreatedAt(DateTimeUtil.fromLocalToOffset(entity.getCreatedAt()));
        }
        return dto;
    }
}