package com.fptgang.backend.controller;

import com.fptgang.backend.service.impl.AzureBlobServiceImpl;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

@RestController
@RequestMapping("/api/v1/azure-blobs")
public class AzureBlobController {

    private final AzureBlobServiceImpl azureBlobService;

    @Value("${spring.cloud.azure.storage.blob.container-name}")
    private String containerName;

    public AzureBlobController(AzureBlobServiceImpl azureBlobService) {
        this.azureBlobService = azureBlobService;
    }

    /**
     * Endpoint to upload a file (image, video, etc.) to Azure Blob Storage.
     *
     * @param file Multipart file to upload (image/video)
     * @param blobName The name of the blob (file name)
     * @return URL of the uploaded file in Azure Blob Storage
     */
    @PostMapping("/upload")
    public ResponseEntity<String> uploadBlob(@RequestParam("file") MultipartFile file,
                                             @RequestParam("blobName") String blobName) {
        try {
            // Call AzureBlobService to upload the file to Azure Blob Storage
            String blobUrl = azureBlobService.upload(file, blobName);

            // Return the blob URL
            return ResponseEntity.status(HttpStatus.CREATED).body("Blob uploaded successfully: " + blobUrl);
        } catch (Exception e) {
            // Return error if upload fails
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error uploading blob: " + e.getMessage());
        }
    }

    /**
     * Endpoint to get the status of the container and its blobs.
     *
     * @return Status of the container
     */
    @GetMapping("/status")
    public ResponseEntity<String> getStatus() {
        // Simple status endpoint to check if the service is up and the container is accessible
        return ResponseEntity.ok("Container: " + containerName + " is accessible.");
    }
}
