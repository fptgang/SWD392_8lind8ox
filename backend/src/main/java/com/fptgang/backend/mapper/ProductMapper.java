package com.fptgang.backend.mapper;

import com.fptgang.backend.api.model.BlindBoxDto;
import com.fptgang.backend.api.model.ProductDto;
import com.fptgang.backend.model.BlindBox;
import com.fptgang.backend.model.Pack;
import com.fptgang.backend.model.Product;
import com.fptgang.backend.repository.BrandRepos;
import com.fptgang.backend.repository.ProductRepos;
import com.fptgang.backend.util.DateTimeUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.Optional;
import java.util.stream.Collectors;

@Component
public class ProductMapper extends BaseMapper<ProductDto, Product> {

    @Autowired
    private ProductRepos productRepos;
    @Autowired
    private BrandRepos brandRepos;
    @Autowired
    private ImageMapper imageMapper;

    @Override
    public Product toEntity(ProductDto dto) {
        if (dto == null) {
            return null;
        }

        Optional<Product> existingProductOptional = productRepos.findById(dto.getProductId());

        if (existingProductOptional.isPresent()) {
            Product existingProduct = existingProductOptional.get();
            existingProduct.setName(dto.getName() != null ? dto.getName() : existingProduct.getName());
            existingProduct.setDescription(dto.getDescription() != null ? dto.getDescription() : existingProduct.getDescription());
            existingProduct.setCurrentPrice(dto.getCurrentPrice() != null ? dto.getCurrentPrice() : existingProduct.getCurrentPrice());
            existingProduct.setVisible(dto.getIsVisible() != null ? dto.getIsVisible() : existingProduct.isVisible());
            if (dto.getImages() != null) {
                existingProduct.setImages(dto.getImages().stream().map(imageMapper::toEntity).collect(Collectors.toList()));
            }
            return existingProduct;
        } else {
            Product entity;
            if (dto.getClass().equals(BlindBoxDto.class)) {
                entity = new BlindBox();
            } else {
                entity = new Pack();
            }
            entity.setProductId(dto.getProductId());
            entity.setName(dto.getName());
            entity.setDescription(dto.getDescription());
            entity.setCurrentPrice(dto.getCurrentPrice());
            entity.setVisible(dto.getIsVisible() != null ? dto.getIsVisible() : entity.isVisible());
            if (dto.getBrandId() != null) {
                entity.setBrand(brandRepos.findById(dto.getBrandId()).get());
            }
            if (dto.getImages() != null) {
                entity.setImages(dto.getImages().stream().map(imageMapper::toEntity).collect(Collectors.toList()));
            }
            if (dto.getCreatedAt() != null) {
                entity.setCreatedAt(dto.getCreatedAt().toLocalDateTime());
            }
            if (dto.getUpdatedAt() != null) {
                entity.setUpdatedAt(dto.getUpdatedAt().toLocalDateTime());
            }
            return entity;
        }
    }

    @Override
    public ProductDto toDTO(Product entity) {
        if (entity == null) {
            return null;
        }

        ProductDto dto = new ProductDto();
        dto.setProductId(entity.getProductId());
        dto.setName(entity.getName());
        dto.setDescription(entity.getDescription());
        dto.setCurrentPrice(entity.getCurrentPrice());
        dto.setBrandId(entity.getBrand() != null ? entity.getBrand().getBrandId() : null);
        dto.setImages(entity.getImages().stream().map(imageMapper::toDTO).collect(Collectors.toList()));
        dto.setIsVisible(entity.isVisible());
        if (entity.getCreatedAt() != null) {
            dto.setCreatedAt(DateTimeUtil.fromLocalToOffset(entity.getCreatedAt()));
        }
        if (entity.getUpdatedAt() != null) {
            dto.setUpdatedAt(DateTimeUtil.fromLocalToOffset(entity.getUpdatedAt()));
        }
        return dto;
    }
}