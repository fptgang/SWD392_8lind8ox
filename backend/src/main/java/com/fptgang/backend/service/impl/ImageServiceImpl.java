package com.fptgang.backend.service.impl;

import com.fptgang.backend.model.Image;
import com.fptgang.backend.repository.ImageRepos;
import com.fptgang.backend.service.ImageService;
import com.fptgang.backend.util.OpenApiHelper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ImageServiceImpl implements ImageService {
    private static final List<String> WHITELIST_PATHS =
            List.of("imageId", "imageURL", "createdAt", "updatedAt");

    private final ImageRepos imageRepos;

    @Autowired
    public ImageServiceImpl(ImageRepos imageRepos) {
        this.imageRepos = imageRepos;
    }

    @Override
    public Image create(Image image) {
        return imageRepos.save(image);
    }

    @Override
    public Image findById(long id) {
        return imageRepos.findById(id).orElse(null);
    }

    @Override
    public Image update(Image image) {
        if (image.getImageId() == null) {
            throw new IllegalArgumentException("Image does not exist");
        }
        return imageRepos.save(image);
    }

    @Override
    public Image deleteById(long id) {
        Image image = imageRepos.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Image does not exist"));
        image.setVisible(false);
        return imageRepos.save(image);
    }

    @Override
    public Page<Image> getAll(Pageable pageable, String filter, boolean includeInvisible) {
        var spec = OpenApiHelper.<Image>toSpecification(filter, WHITELIST_PATHS);
        if (!includeInvisible) {
            spec = spec.and((a, _, cb) -> cb.isTrue(a.get("isVisible")));
        }
        return imageRepos.findAll(spec, pageable);
    }
}