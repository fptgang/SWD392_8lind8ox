package com.fptgang.backend.mapper;

import com.fptgang.backend.api.model.ImageDto;
import com.fptgang.backend.model.Image;
import com.fptgang.backend.repository.AccountRepos;
import com.fptgang.backend.repository.BlindBoxRepos;
import com.fptgang.backend.repository.ToyRepos;
import com.fptgang.backend.util.DateTimeUtil;
import org.springframework.stereotype.Component;

@Component
public class ImageMapper extends BaseMapper<ImageDto, Image> {
    private final AccountRepos accountRepos;
    private final BlindBoxRepos blindBoxRepos;
    private final ToyRepos toyRepos;
    private final AccountMapper accountMapper;

    public ImageMapper(AccountRepos accountRepos,
                       BlindBoxRepos blindBoxRepos,
                       ToyRepos toyRepos,
                       AccountMapper accountMapper) {
        this.accountRepos = accountRepos;
        this.blindBoxRepos = blindBoxRepos;
        this.toyRepos = toyRepos;
        this.accountMapper = accountMapper;
    }

    @Override
    public Image toEntity(ImageDto dto) {
        if (dto == null) {
            return null;
        }

        Image entity = new Image();
        entity.setImageId(dto.getImageId());
        if (dto.getUploader() != null) {
            entity.setUploader(accountRepos.getReferenceById(dto.getUploader().getAccountId()));
        }
        if (dto.getBlindBoxId() != null) {
            entity.setBlindBox(blindBoxRepos.getReferenceById(dto.getBlindBoxId()));
        }
        if (dto.getToyId() != null) {
            entity.setToy(toyRepos.getReferenceById(dto.getToyId()));
        }
        entity.setImageUrl(dto.getImageUrl());
        entity.setIsVisible(dto.getIsVisible());
        entity.setCreatedAt(DateTimeUtil.fromOffsetToLocal(dto.getCreatedAt()));
        return entity;
    }

    @Override
    public ImageDto toDTO(Image entity, DetailLevel level) {
        if (entity == null) {
            return null;
        }

        ImageDto dto = new ImageDto();
        dto.setImageId(entity.getImageId());
        dto.setUploader(accountMapper.toDTO(entity.getUploader(), DetailLevel.REFERENCE));
        dto.setBlindBoxId(entity.getBlindBox() != null ? entity.getBlindBox().getBlindBoxId() : null);
        dto.setToyId(entity.getToy() != null ? entity.getToy().getToyId() : null);
        dto.setImageUrl(entity.getImageUrl());
        dto.setIsVisible(entity.getIsVisible());
        dto.setCreatedAt(DateTimeUtil.fromLocalToOffset(entity.getCreatedAt()));
        return dto;
    }
}