package com.fptgang.backend.service;

import com.fptgang.backend.model.BlindBox;
import com.fptgang.backend.service.params.ListParams;
import org.springframework.data.domain.Page;

public interface BlindBoxService {
    BlindBox create(BlindBox blindBox);
    BlindBox findById(long id);
    BlindBox update(BlindBox blindBox);
    BlindBox deleteById(long id);
    Page<BlindBox> getAll(ListParams params);
}
