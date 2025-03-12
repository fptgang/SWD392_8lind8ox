package com.fptgang.backend.mapper.template;

import com.fptgang.backend.model.Account;
import com.fptgang.backend.model.Video;
import com.fptgang.backend.util.DateTimeUtil;
import org.springframework.stereotype.Component;

import java.util.Map;
import java.util.Optional;

@Component
public class VideoSubmittedEmailTemplateMapper implements TemplateMapper<Video> {
    @Override
    public Map<String, Object> create(Video entity) {
        return Map.of(
                "videoId", entity.getVideoId(),
                "account", Map.of(
                        "firstName", Optional.ofNullable(entity.getAccount()).map(Account::getFirstName).orElse(""),
                        "lastName", Optional.ofNullable(entity.getAccount()).map(Account::getLastName).orElse("")
                ),
                "description", Optional.ofNullable(entity.getDescription()).orElse("No description provided"),
                "createdAt", DateTimeUtil.formatDate(entity.getCreatedAt()),
                "isVerified", entity.getIsVerified() ? "Verified" : "Pending",
                "url", Optional.ofNullable(entity.getUrl()).orElse("#")
        );
    }
}
