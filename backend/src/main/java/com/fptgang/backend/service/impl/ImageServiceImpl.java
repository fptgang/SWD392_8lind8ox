package com.fptgang.backend.service.impl;

import com.fptgang.backend.model.Image;
import com.fptgang.backend.repository.ImageRepos;
import com.fptgang.backend.service.AzureBlobService;
import com.fptgang.backend.service.ImageService;
import com.fptgang.backend.service.params.ListParams;
import com.fptgang.backend.util.OpenApiHelper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;

@Service
@Slf4j
public class ImageServiceImpl implements ImageService {

    private final AzureBlobService azureBlobService;
    private final ImageRepos imageRepos;

    @Autowired
    public ImageServiceImpl(ImageRepos imageRepos, AzureBlobService azureBlobService) {
        this.imageRepos = imageRepos;
        this.azureBlobService = azureBlobService;
    }

    @Override
    public Image create(Image image, MultipartFile file) {
        try {
            String originalFilename = file.getOriginalFilename();

            if (originalFilename == null || originalFilename.trim().isEmpty()) {
                log.error("Invalid file name detected.");
                throw new IllegalArgumentException("Invalid file name");
            }

            log.info("Received file for upload: {}", originalFilename);

            String uploadedUrl = azureBlobService.upload(file);
            image.setImageUrl(uploadedUrl);
            if(image.getSku() != null) {
                image.getSku().setImage(image);
            }

            log.info("File uploaded successfully. URL: {}", uploadedUrl);

            return imageRepos.save(image);
        } catch (IOException e) {
            log.error("Error uploading file: {}", e.getMessage(), e);
            throw new RuntimeException(e);
        }
    }

    @Override
    public Image findById(long id) {
        return imageRepos.findById(id).orElse(null);
    }

    @Override
    public Image update(Image image, MultipartFile file) {
        if (image.getImageId() == null) {
            throw new IllegalArgumentException("Image does not exist");
        }
        try {
            image.setImageUrl(azureBlobService.upload(file));
            return imageRepos.save(image);
        } catch (IOException e) {
            log.error(e.getMessage());
            throw new RuntimeException(e);
        }
    }

    @Override
    public Image deleteById(long id) {
        Image image = imageRepos.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Image does not exist"));
        image.setIsVisible(false);
        return imageRepos.save(image);
    }

    @Override
    public Page<Image> getAll(ListParams params) {
        var spec = params.<Image>toSpec();
        return imageRepos.findAll(spec, params.getPageable());
    }
}