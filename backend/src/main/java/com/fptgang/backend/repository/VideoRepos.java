package com.fptgang.backend.repository;

import com.fptgang.backend.model.Video;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface VideoRepos extends JpaRepository<Video, Long>, JpaSpecificationExecutor<Video> {
}
