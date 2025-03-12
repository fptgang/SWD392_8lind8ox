package com.fptgang.backend.service.impl;

import com.azure.storage.blob.BlobClient;
import com.azure.storage.blob.BlobContainerClient;
import com.azure.storage.blob.BlobServiceClient;
import com.azure.storage.blob.BlobServiceClientBuilder;
import com.fptgang.backend.service.AzureBlobService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.io.InputStream;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.UUID;


@Slf4j
@Service
public class AzureBlobServiceImpl implements AzureBlobService {

    @Value("${spring.cloud.azure.storage.blob.container-name}")
    private String containerName;

    private final BlobServiceClient blobServiceClient;

    @Autowired
    public AzureBlobServiceImpl(BlobServiceClient blobServiceClient) {
        this.blobServiceClient = blobServiceClient;
    }


    public String upload(MultipartFile file) throws IOException {
        String blobName = file.getOriginalFilename(); // Lấy tên file từ MultipartFile
        if (blobName == null || blobName.isEmpty()) {
            throw new IllegalArgumentException("File name cannot be empty");
        }

        BlobContainerClient containerClient = blobServiceClient.getBlobContainerClient(containerName);
        BlobClient blobClient = containerClient.getBlobClient(blobName);

        try (InputStream dataStream = file.getInputStream()) {
            blobClient.upload(dataStream, file.getSize(), true);
        }

        return blobClient.getBlobUrl();
    }

}
