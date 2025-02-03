package com.fptgang.backend.service;

public interface AzureBlobService {
    String upload(String base64Data, String blobName);
}
