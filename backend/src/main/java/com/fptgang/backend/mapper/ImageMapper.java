package com.fptgang.backend.mapper;

import com.fptgang.backend.api.model.ImageDto;
import com.fptgang.backend.model.Image;
import com.fptgang.backend.repository.AccountRepos;
import com.fptgang.backend.repository.BlindBoxRepos;
import com.fptgang.backend.repository.ImageRepos;
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

    @Override
    public Image toEntity(ImageDto dto) {
        if (dto == null) {
            return null;
        }

        Optional<Image> existingImageOptional = imageRepos.findById(dto.getImageId());

        if (existingImageOptional.isPresent()) {
            Image existingImage = existingImageOptional.get();
            existingImage.setImageURL(dto.getImageURL() != null ? dto.getImageURL() : existingImage.getImageURL());
            if(dto.getBlindBoxId() != null) {
                existingImage.setBlindBox(blindBoxRepos.findById(dto.getBlindBoxId()).get());
            }
            if(dto.getAccountId() != null) {
                existingImage.setAccount(accountRepos.findByAccountId(dto.getAccountId()).get());
            }

            return existingImage;
        } else {
            Image entity = new Image();
            entity.setImageId(dto.getImageId());
            entity.setImageURL(dto.getImageURL());
            if(dto.getBlindBoxId() != null) {
                entity.setBlindBox(blindBoxRepos.findById(dto.getBlindBoxId()).get());
            }
            if(dto.getAccountId() != null) {
                entity.setAccount(accountRepos.findByAccountId(dto.getAccountId()).get());
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
        dto.setImageURL(entity.getImageURL());
        dto.setBlindBoxId(entity.getBlindBox() != null ? entity.getBlindBox().getBlindBoxId() : null);
        dto.setAccountId(entity.getAccount() != null ? entity.getAccount().getAccountId() : null);

        return dto;
    }
}