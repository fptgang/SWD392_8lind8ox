package com.fptgang.backend.mapper;

import com.fptgang.backend.api.model.CategoryDto;
import com.fptgang.backend.model.Category;
import com.fptgang.backend.repository.CategoryRepos;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.Optional;

@Component
public class CategoryMapper extends BaseMapper<CategoryDto, Category> {

    @Autowired
    private CategoryRepos categoryRepos;
    @Autowired
    private BlindBoxMapper blindBoxMapper;

    @Override
    public Category toEntity(CategoryDto dto) {
        if (dto == null) {
            return null;
        }

        Optional<Category> existingCategoryOptional = categoryRepos.findById(dto.getCategoryId());

        if (existingCategoryOptional.isPresent()) {
            Category existingCategory = existingCategoryOptional.get();
            existingCategory.setName(dto.getName() != null ? dto.getName() : existingCategory.getName());
            existingCategory.setDescription(dto.getDescription() != null ? dto.getDescription() : existingCategory.getDescription());
            existingCategory.setVisible(dto.getIsVisible() != null ? dto.getIsVisible() : existingCategory.isVisible());

            return existingCategory;
        } else {
            Category entity = new Category();
            entity.setCategoryId(dto.getCategoryId());
            entity.setName(dto.getName());
            entity.setDescription(dto.getDescription());
            entity.setVisible(dto.getIsVisible() != null ? dto.getIsVisible() : entity.isVisible());


            return entity;
        }
    }

    @Override
    public CategoryDto toDTO(Category entity) {
        if (entity == null) {
            return null;
        }

        CategoryDto dto = new CategoryDto();
        dto.setCategoryId(entity.getCategoryId());
        dto.setName(entity.getName());
        dto.setDescription(entity.getDescription());
        dto.setBlindBoxes(entity.getBlindBoxes().stream().map(blindBoxMapper::toDTO).toList());
        dto.setIsVisible(entity.isVisible());
        return dto;
    }
}