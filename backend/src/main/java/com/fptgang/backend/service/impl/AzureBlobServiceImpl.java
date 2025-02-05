package com.fptgang.backend.service.impl;

import com.azure.storage.blob.BlobClient;
import com.azure.storage.blob.BlobContainerClient;
import com.azure.storage.blob.BlobServiceClient;
import com.azure.storage.blob.BlobServiceClientBuilder;
import com.fptgang.backend.service.AzureBlobService;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.io.InputStream;

@Service
public class AzureBlobServiceImpl implements AzureBlobService {

    @Value("${spring.cloud.azure.storage.blob.connection-string}")
    private String connectionString;

    @Value("${spring.cloud.azure.storage.blob.container-name}")
    private String containerName;

    @Value("${spring.cloud.azure.storage.blob.sas-token}")
    private String sasToken;

    @Override
    public String upload(MultipartFile file, String blobName) {
        try {
            // Get the byte data from MultipartFile
            byte[] data = file.getBytes();

            // Create a BlobServiceClient using the connection string
            String endpoint = connectionString + containerName + "?" + sasToken;
            BlobServiceClient blobServiceClient = new BlobServiceClientBuilder()
                    .endpoint(endpoint)  // Endpoint with SAS token appended
                    .buildClient();

            // Get the BlobContainerClient for the specific container
            BlobContainerClient containerClient = blobServiceClient.getBlobContainerClient(containerName);

            // Create a BlobClient to upload the data
            BlobClient blobClient = containerClient.getBlobClient(blobName);

            // Convert the byte array into an InputStream
            InputStream dataStream = file.getInputStream();

            // Upload the data to the Azure Blob Storage
            blobClient.upload(dataStream, data.length, true); // Overwrite if the blob already exists

            // Return the URL of the uploaded blob
            return blobClient.getBlobUrl();
        } catch (IOException e) {
            e.printStackTrace();
            throw new RuntimeException("Error uploading file to Azure Blob Storage", e);
        }
    }
}
