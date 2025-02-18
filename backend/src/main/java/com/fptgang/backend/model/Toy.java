package com.fptgang.backend.model;

import com.fptgang.backend.util.Searchable;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "toy")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Toy {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long toyId;

    @Column(nullable = false, columnDefinition = "NVARCHAR(255)")
    @Searchable
    private String name;

    @Column(nullable = false, columnDefinition = "TEXT", length = 100_000)
    @Searchable
    private String description;

    @Column(nullable = false, precision = 10, scale = 2)
    private BigDecimal weight;

    @Column(nullable = false)
    @Enumerated(EnumType.STRING)
    private Rarity rarity;

    @Column(nullable = false, columnDefinition = "BOOLEAN DEFAULT TRUE")
    private boolean isVisible = true;

    @CreationTimestamp
    private LocalDateTime createdAt;

    @UpdateTimestamp
    private LocalDateTime updatedAt;

//    @ManyToMany(mappedBy = "unboxedToys", fetch = FetchType.LAZY)
//    // This is the inverse side
//    private List<OrderDetail> orderDetails;


    @OneToMany(mappedBy = "toy", fetch = FetchType.LAZY, cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Slot> slots;

    @OneToMany(mappedBy = "toy", fetch = FetchType.LAZY, cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Image> images;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "blind_box_id")
    private BlindBox blindBox;

    public enum Rarity {
        REGULAR,
        SECRET
    }
}
