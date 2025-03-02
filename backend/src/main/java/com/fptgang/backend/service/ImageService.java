package com.fptgang.backend.service;

import com.fptgang.backend.model.Image;
import com.fptgang.backend.service.params.ListParams;
import org.springframework.data.domain.Page;
import org.springframework.web.multipart.MultipartFile;

public interface ImageService {
    Image create(Image image, MultipartFile file);
    Image findById(long id);
    Image update(Image image, MultipartFile file);
    Image deleteById(long id);
    Page<Image> getAll(ListParams params);
}