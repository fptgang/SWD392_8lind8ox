package com.fptgang.backend.service.impl;

import com.fptgang.backend.config.BlindBoxConfig;
import com.fptgang.backend.exception.InvalidInputException;
import com.fptgang.backend.model.Account;
import com.fptgang.backend.model.Slot;
import com.fptgang.backend.model.Video;
import com.fptgang.backend.repository.AccountRepos;
import com.fptgang.backend.repository.VideoRepos;
import com.fptgang.backend.service.AzureBlobService;
import com.fptgang.backend.service.EmailService;
import com.fptgang.backend.service.VideoService;
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
public class VideoServiceImpl implements VideoService {

    private final AccountRepos accountRepos;
    private final VideoRepos videoRepos;
    private final AzureBlobService azureBlobService;
    private final EmailService emailService;
    private final BlindBoxConfig blindBoxConfig;

    @Autowired
    public VideoServiceImpl(
            VideoRepos videoRepos,
            AzureBlobService azureBlobService,
            AccountRepos accountRepos,
            EmailService emailService,
            BlindBoxConfig blindBoxConfig) {
        this.videoRepos = videoRepos;
        this.azureBlobService = azureBlobService;
        this.accountRepos = accountRepos;
        this.emailService = emailService;
        this.blindBoxConfig = blindBoxConfig;
    }

    @Override
    public Video create(Video video, MultipartFile file) {
        Account account = accountRepos.findByEmail(video.getAccount().getEmail())
                .orElseThrow(() -> new InvalidInputException("User not found"));
        try {
            // Upload video to Azure
            String videoUrl = azureBlobService.upload(file);
            video.setUrl(videoUrl);
            video.setDescription("Unboxing video by " + account.getFirstName() + " " + account.getLastName());
            video.setIsVerified(false);
            video.getSlot().setVideo(video);
            // Save video details in DB
            Video savedVideo = videoRepos.save(video);

            // Use email template method
            emailService.sendVideoSubmittedEmail(savedVideo);
            log.info("Video upload confirmation email sent to: {}", account.getEmail());

            return savedVideo;
        } catch (IOException e) {
            log.error("Error uploading video: {}", e.getMessage());
            throw new RuntimeException("Failed to upload video", e);
        }
    }

    @Override
    public Video findById(long id) {
        return videoRepos.findById(id).orElse(null);
    }

    @Override
    public Video update(Video video, MultipartFile file) {
        if (video.getVideoId() == null) {
            throw new IllegalArgumentException("Video does not exist");
        }
        try {
            video.setUrl(azureBlobService.upload(file));
            return videoRepos.save(video);
        } catch (IOException e) {
            log.error(e.getMessage());
            throw new RuntimeException(e);
        }
    }

    @Override
    public Video verified(long id) {
        Video video = videoRepos.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Video does not exist"));
        video.setIsVerified(true);
        video.getSlot().setState(Slot.State.OPENED);

        try {
            emailService.sendVideoVerifiedEmail(video);
            log.info("Video verified email sent to: {}", video.getAccount().getEmail());
        } catch (IOException e) {
            log.warn("Failed to send video verified email", e);
        }
        return videoRepos.save(video);
    }

    @Override
    public Video deleteById(long id) {
        Video video = videoRepos.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Video does not exist"));
        video.setIsVisible(false);
        return videoRepos.save(video);
    }

    @Override
    public Page<Video> getAll(ListParams params) {
        var spec = params.<Video>toSpec();
        return videoRepos.findAll(spec, params.getPageable());
    }
}