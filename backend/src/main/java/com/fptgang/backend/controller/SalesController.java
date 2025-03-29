package com.fptgang.backend.controller;

import com.fptgang.backend.api.controller.SalesApi;
import com.fptgang.backend.api.model.GetBlindBoxes200Response;
import com.fptgang.backend.api.model.Pageable;
import com.fptgang.backend.api.model.TrendingProductDto;
import com.fptgang.backend.exception.InvalidInputException;
import com.fptgang.backend.mapper.BlindBoxMapper;
import com.fptgang.backend.mapper.DetailLevel;
import com.fptgang.backend.mapper.sales.TrendingProductMapper;
import com.fptgang.backend.model.Account;
import com.fptgang.backend.service.SalesService;
import com.fptgang.backend.service.params.ListParams;
import com.fptgang.backend.util.OpenApiHelper;
import com.fptgang.backend.util.SecurityUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@Slf4j
@RestController
@RequestMapping("/api/v1")
public class SalesController implements SalesApi {
    private final TrendingProductMapper trendingProductMapper;
    private final BlindBoxMapper blindBoxMapper;
    private final SalesService salesService;

    public SalesController(TrendingProductMapper trendingProductMapper, BlindBoxMapper blindBoxMapper,
                           SalesService salesService) {
        this.trendingProductMapper = trendingProductMapper;
        this.blindBoxMapper = blindBoxMapper;
        this.salesService = salesService;
    }

    @Override
    public ResponseEntity<List<TrendingProductDto>> getTrendingProducts(String interval) {
        var days = switch (interval) {
            case "DAY" -> 1;
            case "WEEK" -> 7;
            case "MONTH" -> 30;
            default ->
                throw new InvalidInputException("Expect: DAY/WEEK/MONTH");
        };
        var proj = salesService.getTrendingProducts(days);
        return ResponseEntity.ok(
                proj.stream().map(e -> {
                    return trendingProductMapper.toDTO(e, DetailLevel.FULL);
                }).toList()
        );
    }

    @Override
    public ResponseEntity<GetBlindBoxes200Response> getHotSaleProducts(Pageable pageable, String filter, String search) {
        log.info("Getting blindboxes");
        var includeInvisible = SecurityUtil.hasPermission(Account.Role.ADMIN);
        var params = ListParams.builder()
                .pageable(OpenApiHelper.toPageable(pageable))
                .search(search)
                .filter(filter)
                .includeInvisible(includeInvisible);

        var res = salesService.getAllHotSales(params.build())
                .map(e -> blindBoxMapper.toDTO(e, DetailLevel.FULL));
        return OpenApiHelper.respondPage(res, GetBlindBoxes200Response.class);
    }
}
