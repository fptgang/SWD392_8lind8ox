package com.fptgang.backend.controller;

import com.fptgang.backend.api.controller.VouchersApi;
import com.fptgang.backend.api.model.GetVouchers200Response;
import com.fptgang.backend.api.model.Pageable;
import com.fptgang.backend.api.model.VoucherDto;
import com.fptgang.backend.mapper.DetailLevel;
import com.fptgang.backend.mapper.VoucherMapper;
import com.fptgang.backend.model.Account;
import com.fptgang.backend.service.VoucherService;
import com.fptgang.backend.service.params.ListParams;
import com.fptgang.backend.util.OpenApiHelper;
import com.fptgang.backend.util.SecurityUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.context.request.NativeWebRequest;

import java.util.Optional;

@Slf4j
@RestController
@RequestMapping("/api/v1")
public class VoucherController implements VouchersApi {
    private final VoucherService voucherService;
    private final VoucherMapper voucherMapper;

    @Autowired
    public VoucherController(VoucherMapper voucherMapper, VoucherService voucherService) {
        this.voucherService = voucherService;
        this.voucherMapper = voucherMapper;
    }

    @Override
    public ResponseEntity<VoucherDto> createVoucher(VoucherDto voucherDto) {
        log.info("Creating voucher");
        if (!SecurityUtil.hasPermission(Account.Role.ADMIN)) {
            throw new AccessDeniedException("Only admin can create vouchers");
        }
        return new ResponseEntity<>(
                voucherMapper.toDTO(
                        voucherService.create(voucherMapper.toEntity(voucherDto)),
                        DetailLevel.FULL
                ),
                HttpStatus.CREATED
        );
    }

    @Override
    public ResponseEntity<Void> deleteVoucher(Long voucherId) {
        log.info("Deleting voucher " + voucherId);
        if (!SecurityUtil.hasPermission(Account.Role.ADMIN)) {
            throw new AccessDeniedException("Only admin can delete vouchers");
        }
        voucherService.deleteById(voucherId);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @Override
    public ResponseEntity<VoucherDto> getVoucherById(Long voucherId) {
        log.info("Getting voucher by id " + voucherId);
        if (!SecurityUtil.hasPermission(Account.Role.ADMIN)) {
            throw new AccessDeniedException("Only admins can view detailed voucher info.");
        }
        return new ResponseEntity<>(voucherMapper.toDTO(voucherService.findById(voucherId), DetailLevel.FULL), HttpStatus.OK);
    }

    @Override
    public ResponseEntity<GetVouchers200Response> getVouchers(Pageable pageable, String filter, String search) {
        log.info("Getting vouchers");
        var includeInvisible = SecurityUtil.hasPermission(Account.Role.ADMIN);
        var params = ListParams.builder()
                .pageable(OpenApiHelper.toPageable(pageable))
                .search(search)
                .filter(filter)
                .includeInvisible(includeInvisible);

        // Customers can only view their own vouchers
s        if (!SecurityUtil.hasPermission(Account.Role.STAFF)) {
            params.setFilter("account.accountId", "eq", SecurityUtil.getCurrentUserId());
        }

        var res = voucherService.getAll(params.build())
                .map(v -> voucherMapper.toDTO(v, DetailLevel.SUMMARY));
        return OpenApiHelper.respondPage(res, GetVouchers200Response.class);
    }

    @Override
    public ResponseEntity<VoucherDto> updateVoucher(Long voucherId, VoucherDto voucherDto) {
        voucherDto.setVoucherId(voucherId); // Override voucherId
        if (!SecurityUtil.hasPermission(Account.Role.ADMIN)) {
            throw new AccessDeniedException("Only admins can update vouchers.");
        }
        return ResponseEntity.ok(
                voucherMapper.toDTO(
                        voucherService.update(voucherMapper.toEntity(voucherDto)),
                        DetailLevel.FULL
                )
        );
    }
}