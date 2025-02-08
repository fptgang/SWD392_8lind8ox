package com.fptgang.backend.service;

import org.springframework.web.multipart.MultipartFile;

public interface AzureBlobService {
    String upload(MultipartFile file, String blobName);
}
