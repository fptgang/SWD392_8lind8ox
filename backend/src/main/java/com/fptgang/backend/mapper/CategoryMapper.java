//package com.fptgang.backend.mapper;
//
//import com.fptgang.backend.api.model.CategoryDto;
//import com.fptgang.backend.model.Brand;
//import com.fptgang.backend.repository.CategoryRepos;
//import com.fptgang.backend.util.DateTimeUtil;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.stereotype.Component;
//
//import java.util.Optional;
//
//@Component
//public class CategoryMapper extends BaseMapper<CategoryDto, Brand> {
//
//    @Autowired
//    private CategoryRepos categoryRepos;
//    @Autowired
//    private BlindBoxMapper blindBoxMapper;
//    @Autowired
//    private PackMapper packMapper;
//
//    @Override
//    public Brand toEntity(CategoryDto dto) {
//        if (dto == null) {
//            return null;
//        }
//
//        Optional<Brand> existingCategoryOptional = categoryRepos.findById(dto.getCategoryId());
//
//        if (existingCategoryOptional.isPresent()) {
//            Brand existingBrand = existingCategoryOptional.get();
//            existingBrand.setName(dto.getName() != null ? dto.getName() : existingBrand.getName());
//            existingBrand.setDescription(dto.getDescription() != null ? dto.getDescription() : existingBrand.getDescription());
//            existingBrand.setVisible(dto.getIsVisible() != null ? dto.getIsVisible() : existingBrand.isVisible());
//
//            return existingBrand;
//        } else {
//            Brand entity = new Brand();
//            entity.setCategoryId(dto.getCategoryId());
//            entity.setName(dto.getName());
//            entity.setDescription(dto.getDescription());
//            entity.setVisible(dto.getIsVisible() != null ? dto.getIsVisible() : entity.isVisible());
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
//    public CategoryDto toDTO(Brand entity) {
//        if (entity == null) {
//            return null;
//        }
//
//        CategoryDto dto = new CategoryDto();
//        dto.setCategoryId(entity.getCategoryId());
//        dto.setName(entity.getName());
//        dto.setDescription(entity.getDescription());
//
//        if(entity.getCreatedDate() != null) {
//            dto.setCreatedDate(DateTimeUtil.fromLocalToOffset(entity.getCreatedDate()));
//        }
//        if(entity.getUpdatedDate() != null) {
//            dto.setUpdatedDate(DateTimeUtil.fromLocalToOffset(entity.getUpdatedDate()));
//        }
//        dto.setIsVisible(entity.isVisible());
//        return dto;
//    }
//}