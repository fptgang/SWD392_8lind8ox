package com.fptgang.backend.service.impl;

import com.fptgang.backend.exception.InvalidInputException;
import com.fptgang.backend.model.Account;
import com.fptgang.backend.model.Video;
import com.fptgang.backend.repository.AccountRepos;
import com.fptgang.backend.repository.VideoRepos;
import com.fptgang.backend.service.AzureBlobService;
import com.fptgang.backend.service.EmailService;
import com.fptgang.backend.service.VideoService;
import com.fptgang.backend.util.OpenApiHelper;
import org.springframework.beans.factory.annotation.Autowired;
import lombok.extern.slf4j.Slf4j;
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
    @Autowired
    public VideoServiceImpl(VideoRepos videoRepos, AzureBlobService azureBlobService, AccountRepos accountRepos, EmailService emailService) {
        this.videoRepos = videoRepos;
        this.azureBlobService = azureBlobService;
        this.accountRepos = accountRepos;
        this.emailService = emailService;
    }

    @Override
    public Video create(Video video, MultipartFile file) {
        Account account = accountRepos.findByEmail(video.getAccount().getEmail())
                .orElseThrow(() -> new InvalidInputException("User not found"));
        try {
            // Upload video to Azure
            String videoUrl = azureBlobService.upload(file, file.getName());
            video.setUrl(videoUrl);

            // Save video details in DB
            Video savedVideo = videoRepos.save(video);

            // Generate email content dynamically inside this method
            String emailBody = String.format("""
                <h1>🎥 Your Video is Ready!</h1>
                <p>Dear %s,</p>
                <p>We are excited to inform you that your unboxing video has been successfully uploaded!</p>
                <p>Click the link below to watch your video:</p>
                %s
                <br>
                <p>Thank you for being with us!</p>
                <p>Best regards,</p>
                <p><strong>Your Company Team</strong></p>
                """, account.getFirstName() + " " + account.getLastName(), videoUrl);

            // Send email
            String subject = "\uD83D\uDE80 Your Exclusive Unboxing Video is Now Live!";
            String from = "Admin <admin@mail.biddify.fun>";
            emailService.sendMail(from, account.getEmail(), subject, emailBody);

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
            video.setUrl(azureBlobService.upload(file, file.getName()));
            return videoRepos.save(video);
        } catch (IOException e) {
            log.error(e.getMessage());
            throw new RuntimeException(e);
        }
    }

    @Override
    public Video deleteById(long id) {
        Video video = videoRepos.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Video does not exist"));
        video.setVisible(false);
        return videoRepos.save(video);
    }

    @Override
    public Page<Video> getAll(Pageable pageable, String filter, String search, boolean includeInvisible) {
        var spec = OpenApiHelper.<Video>filterToSpec(filter);
        spec = spec.and(OpenApiHelper.searchToSpec(search));
        if (!includeInvisible) {
            spec = spec.and((a, _, cb) -> cb.isTrue(a.get("isVisible")));
        }
        return videoRepos.findAll(spec, pageable);
    }
}