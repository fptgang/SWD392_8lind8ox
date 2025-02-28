package com.fptgang.backend.service;

import com.fptgang.backend.model.StockKeepingUnit;
import com.fptgang.backend.model.Toy;
import com.fptgang.backend.service.params.ListParams;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

public interface ToyService {
    Toy create(Toy toy);
    Toy findById(long id);
    Toy update(Toy toy);
    Toy deleteById(long id);
    Page<Toy> getAll(ListParams params);

}
