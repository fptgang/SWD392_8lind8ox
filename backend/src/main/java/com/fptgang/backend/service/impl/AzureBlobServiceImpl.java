package com.fptgang.backend.service.impl;

import com.azure.storage.blob.BlobContainerClient;
import com.azure.storage.blob.BlobServiceClient;
import com.azure.storage.blob.models.PublicAccessType;
import com.azure.storage.blob.specialized.BlockBlobClient;
import com.fptgang.backend.service.AzureBlobService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.ByteArrayInputStream;
import java.io.IOException;
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
        String blobName = UUID.randomUUID() + "-" + file.getOriginalFilename();
        log.info("Cooking file '{}' blob name '{}' container name '{}'",
                file.getOriginalFilename(), blobName, containerName);

        BlobContainerClient containerClient = blobServiceClient.getBlobContainerClient(containerName);
        containerClient.setAccessPolicy(PublicAccessType.BLOB, null);
        BlockBlobClient blobClient = containerClient.getBlobClient(blobName).getBlockBlobClient();
        byte[] bytes = file.getBytes();
        ByteArrayInputStream byteArrayInputStream = new ByteArrayInputStream(bytes);
        blobClient.upload(byteArrayInputStream, bytes.length, true);

        String url = blobClient.getBlobUrl();
        log.info("File cooked URL {}", url);
        return url;
    }

}
