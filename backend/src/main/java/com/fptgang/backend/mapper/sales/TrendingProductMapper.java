package com.fptgang.backend.mapper.sales;

import com.fptgang.backend.api.model.*;
import com.fptgang.backend.mapper.BaseMapper;
import com.fptgang.backend.mapper.DetailLevel;
import com.fptgang.backend.model.sales.TrendingProduct;
import org.springframework.stereotype.Component;

@Component
public class    TrendingProductMapper extends BaseMapper<TrendingProductDto, TrendingProduct> {
    @Override
    public TrendingProduct toEntity(TrendingProductDto dto) {
        throw new UnsupportedOperationException();
    }

    @Override
    public TrendingProductDto toDTO(TrendingProduct entity, DetailLevel level) {
        if (entity == null) {
            return null;
        }

        BrandDto brandDto = new BrandDto();
        brandDto.setBrandId(entity.getBrandId());
        brandDto.setName(entity.getBrandName());

        BlindBoxDto blindBoxDto = new BlindBoxDto();
        blindBoxDto.setBlindBoxId(entity.getBlindBoxId());
        blindBoxDto.setName(entity.getBlindBoxName());
        blindBoxDto.setBrand(brandDto);

        StockKeepingUnitDto skuDto = new StockKeepingUnitDto();
        skuDto.setSkuId(entity.getSkuId());
        skuDto.setName(entity.getSkuName());
        skuDto.setPrice(entity.getPrice());
        skuDto.setBlindBox(new BlindBoxDto().blindBoxId(entity.getBlindBoxId()));
        skuDto.setImage(new ImageDto().imageUrl(entity.getImage()));

        TrendingProductDto trendingProductDto = new TrendingProductDto();
        trendingProductDto.setBlindbox(blindBoxDto);
        trendingProductDto.setSku(skuDto);
        trendingProductDto.setTotalSales(Math.toIntExact(entity.getOrderCount()));

        return trendingProductDto;
    }

}
