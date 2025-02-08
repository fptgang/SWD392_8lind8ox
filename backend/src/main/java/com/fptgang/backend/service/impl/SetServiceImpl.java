package com.fptgang.backend.service.impl;

import com.fptgang.backend.model.Set;
import com.fptgang.backend.repository.SetRepos;
import com.fptgang.backend.service.SetService;
import com.fptgang.backend.util.OpenApiHelper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

@Service
public class SetServiceImpl implements SetService {

    private final SetRepos setRepos;

    @Autowired
    public SetServiceImpl(SetRepos setRepos) {
        this.setRepos = setRepos;
    }

    @Override
    public Set create(Set set) {
        return setRepos.save(set);
    }

    @Override
    public Set findById(long id) {
        return setRepos.findById(id).orElse(null);
    }

    @Override
    public Set update(Set set) {
        if (set.getSetId() == null) {
            throw new IllegalArgumentException("Setage does not exist");
        }
        return setRepos.save(set);
    }

    @Override
    public Set deleteById(long id) {
        Set set = setRepos.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Setage does not exist"));
//        set.setVisible(false);
        return setRepos.save(set);
    }

    @Override
    public Page<Set> getAll(Pageable pageable, String filter, String search, boolean includeInvisible) {
        var spec = OpenApiHelper.<Set>filterToSpec(filter);
        spec = spec.and(OpenApiHelper.searchToSpec(search));
        if (!includeInvisible) {
            spec = spec.and((a, _, cb) -> cb.isTrue(a.get("isVisible")));
        }
        return setRepos.findAll(spec, pageable);
    }
}