package com.fptgang.backend.service.impl;

import com.azure.storage.blob.BlobClient;
import com.azure.storage.blob.BlobContainerClient;
import com.azure.storage.blob.BlobServiceClient;
import com.azure.storage.blob.BlobServiceClientBuilder;
import com.fptgang.backend.service.AzureBlobService;
import org.apache.commons.codec.binary.Base64;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.io.ByteArrayInputStream;
import java.io.InputStream;

@Service
public class AzureBlobServiceImpl implements AzureBlobService {

    @Value("${azure.storage.connection-string}")
    private String connectionString;

    @Value("${azure.storage.container-name}")
    private String containerName;

    @Override
    public String upload(String base64Data, String blobName) {
        try {
            // Convert the base64 string to a byte array
            byte[] data = Base64.decodeBase64(base64Data);

            // Create a BlobServiceClient using the connection string
            BlobServiceClient blobServiceClient = new BlobServiceClientBuilder()
                    .connectionString(connectionString)
                    .buildClient();

            // Get the BlobContainerClient for the specific container
            BlobContainerClient containerClient = blobServiceClient.getBlobContainerClient(containerName);

            // Create a BlobClient to upload the data
            BlobClient blobClient = containerClient.getBlobClient(blobName);

            // Convert the byte array into an InputStream
            InputStream dataStream = new ByteArrayInputStream(data);

            // Upload the data to the Azure Blob Storage
            blobClient.upload(dataStream, data.length, true); // Overwrite if the blob already exists

            // Return the URL of the uploaded blob
            return blobClient.getBlobUrl();
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Error uploading file to Azure Blob Storage", e);
        }
    }
}
