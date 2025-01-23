//package com.fptgang.backend.mapper;
//
//import com.fptgang.backend.api.model.BlindBoxDto;
//import com.fptgang.backend.model.BlindBox;
//import com.fptgang.backend.repository.BlindBoxRepos;
//import com.fptgang.backend.repository.CategoryRepos;
//import com.fptgang.backend.repository.PackRepos;
//import com.fptgang.backend.repository.PromotionalCampaignRepos;
//import com.fptgang.backend.util.DateTimeUtil;
//import lombok.extern.slf4j.Slf4j;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.stereotype.Component;
//
//import java.util.Optional;
//
//@Slf4j
//@Component
//public class BlindBoxMapper extends BaseMapper<BlindBoxDto, BlindBox> {
//
//    @Autowired
//    private BlindBoxRepos blindBoxRepos;
//    @Autowired
//    private PromotionalCampaignRepos promotionalCampaignRepos;
//    @Autowired
//    private CategoryRepos categoryRepos;
//    @Autowired
//    private PackRepos packRepos;
//    @Autowired
//    private ImageMapper imageMapper;
//    @Autowired
//    private VideoMapper videoMapper;
//
//    @Override
//    public BlindBox toEntity(BlindBoxDto dto) {
//        if (dto == null) {
//            return null;
//        }
//
//        Optional<BlindBox> existingBlindBoxOptional = blindBoxRepos.findById(dto.getBlindBoxId());
//
//        if (existingBlindBoxOptional.isPresent()) {
//            BlindBox existingBlindBox = existingBlindBoxOptional.get();
//            existingBlindBox.setName(dto.getName() != null ? dto.getName() : existingBlindBox.getName());
//            existingBlindBox.setDescription(dto.getDescription() != null ? dto.getDescription() : existingBlindBox.getDescription());
//            existingBlindBox.setPrice(dto.getPrice() != null ? dto.getPrice() : existingBlindBox.getPrice());
//            existingBlindBox.setStatus(dto.getStatus() != null ? dto.getStatus() : existingBlindBox.getStatus());
//            existingBlindBox.setVisible(dto.getIsVisible() != null ? dto.getIsVisible() : existingBlindBox.isVisible());
//            return existingBlindBox;
//        } else {
//            BlindBox entity = new BlindBox();
//            entity.setBlindBoxId(dto.getBlindBoxId());
//            entity.setName(dto.getName());
//            entity.setDescription(dto.getDescription());
//            entity.setPrice(dto.getPrice());
//            entity.setStatus(dto.getStatus());
//            entity.setVisible(dto.getIsVisible() != null ? dto.getIsVisible() : entity.isVisible());
//            if(dto.getCampaignId() != null) {
//                entity.setCampaign(promotionalCampaignRepos.findById(dto.getCampaignId()).get());
//            }
//
//            if (dto.getPackId() != null) {
//                entity.setPack(packRepos.findById(dto.getPackId()).get());
//            }
//            if(dto.getCreatedDate() != null) {
//                entity.setCreatedDate(dto.getCreatedDate().toLocalDateTime());
//            }
//            if(dto.getUpdatedDate() != null) {
//                entity.setUpdatedDate(dto.getUpdatedDate().toLocalDateTime());
//            }
//
//            return entity;
//        }
//    }
//
//    @Override
//    public BlindBoxDto toDTO(BlindBox entity) {
//        if (entity == null) {
//            return null;
//        }
//        BlindBoxDto dto = new BlindBoxDto();
//        dto.setBlindBoxId(entity.getBlindBoxId());
//        dto.setName(entity.getName());
//        dto.setDescription(entity.getDescription());
//        dto.setPrice(entity.getPrice());
//        dto.setStatus(entity.getStatus());
//        dto.setCampaignId(entity.getCampaign() != null ? entity.getCampaign().getCampaignId() : null);
//        dto.setPackId(entity.getPack() != null ? entity.getPack().getPackId() : null);
//        if(entity.getCreatedDate() != null) {
//            dto.setCreatedDate(DateTimeUtil.fromLocalToOffset(entity.getCreatedDate()));
//        }
//        if(entity.getUpdatedDate() != null) {
//            dto.setUpdatedDate(DateTimeUtil.fromLocalToOffset(entity.getUpdatedDate()));
//        }
//
//        dto.setImages(entity.getImages().stream().map(imageMapper::toDTO).toList());
//        dto.setVideos(entity.getVideos().stream().map(videoMapper::toDTO).toList());
//        dto.setIsVisible(entity.isVisible());
//        return dto;
//    }
//}