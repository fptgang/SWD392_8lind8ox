package com.fptgang.backend.service;

import com.fptgang.backend.model.Transaction;
import com.fptgang.backend.service.params.ListParams;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Service;

@Service
public interface VNPAYService {
    String createVNPay(Transaction transaction);
}