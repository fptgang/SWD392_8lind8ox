package com.fptgang.backend.util;

import jakarta.persistence.criteria.*;
import lombok.Builder;
import lombok.Data;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.mockito.junit.jupiter.MockitoSettings;
import org.mockito.quality.Strictness;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.jpa.domain.Specification;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
@MockitoSettings(strictness = Strictness.LENIENT)
public class OpenApiHelperTest {
    @Test
    public void testToPageableSingleSort() {
        var p = OpenApiHelper.toPageable(PageableParameter.builder()
                .page(3)
                .sort(List.of("email,asc"))
                .size(20)
        );
        assertEquals(3, p.getPageNumber());
        assertEquals(20, p.getPageSize());
        assertEquals("email: ASC", p.getSort().toString());
    }

    @Test
    public void testToPageableMultiSort() {
        var p = OpenApiHelper.toPageable(PageableParameter.builder()
                .page(3)
                .sort(List.of("email,asc", "name,desc"))
                .size(20)
        );
        assertEquals(3, p.getPageNumber());
        assertEquals(20, p.getPageSize());
        assertEquals("email: ASC,name: DESC", p.getSort().toString());

        p = OpenApiHelper.toPageable(PageableParameter.builder()
                .page(3)
                .sort(List.of("email,asc,name,desc"))
                .size(20)
        );
        assertEquals(3, p.getPageNumber());
        assertEquals(20, p.getPageSize());
        assertEquals("email: ASC,name: DESC", p.getSort().toString());

        p = OpenApiHelper.toPageable(PageableParameter.builder()
                .page(3)
                .sort(List.of("email", "asc,name,desc"))
                .size(20)
        );
        assertEquals(3, p.getPageNumber());
        assertEquals(20, p.getPageSize());
        assertEquals("email: ASC,name: DESC", p.getSort().toString());
    }

    @Test
    public void testToPage() {
        var ctn = List.of(
                new Dummy(),
                new Dummy(),
                new Dummy()
        );
        var p = OpenApiHelper.toPage(new PageImpl<>(
                ctn,
                PageRequest.of(1, 20),
                100
        ), ExampleGet200Response.class);
        assertEquals(ctn, p.getContent());
        assertEquals(100, p.getTotalElements());
        assertEquals(5, p.getTotalPages());
        assertFalse(p.getFirst());
        assertFalse(p.getLast());
        assertEquals(3, p.getNumberOfElements());
        assertFalse(p.getEmpty());
    }

    @Data
    private static class ExampleGet200Response {
        private List<Dummy> content = new ArrayList<>();
        private Long totalElements;
        private Integer totalPages;
        private Boolean last;
        private Boolean first;
        private Integer numberOfElements;
        private Boolean empty;
    }

    @Data
    private static class Dummy {

    }

    @Builder
    private static class PageableParameter {
        private Integer page;
        private Integer size;
        private List<String> sort;
    }

    @Nested
    class SpecificationTest {
        @Mock
        private CriteriaBuilder criteriaBuilder;

        @Mock
        private CriteriaQuery<?> criteriaQuery;

        @Mock
        private Root<String> root;

        @Test
        public void testToSpecificationEqual() {
            Specification<String> expectedSpec = (root, query, criteriaBuilder) ->
                    criteriaBuilder.equal(root.get("name"), "hello");
            Specification<String> actualSpec = OpenApiHelper.filterToSpec("name,eq,hello");
            Predicate expectedPredicate = getPredicate(expectedSpec);
            Predicate actualPredicate = getPredicate(actualSpec);
            assertEquals(expectedPredicate, actualPredicate);
        }

        @Test
        public void testToSpecificationNotEqual() {
            Specification<String> expectedSpec = (root, query, criteriaBuilder) ->
                    criteriaBuilder.notEqual(root.get("name"), "hello");
            Specification<String> actualSpec = OpenApiHelper.filterToSpec("name,ne,hello");
            Predicate expectedPredicate = getPredicate(expectedSpec);
            Predicate actualPredicate = getPredicate(actualSpec);
            assertEquals(expectedPredicate, actualPredicate);
        }

        @Test
        public void testToSpecificationLessThan() {
            Specification<String> expectedSpec = (root, query, criteriaBuilder) ->
                    criteriaBuilder.lessThan(root.get("age"), "30");
            Specification<String> actualSpec = OpenApiHelper.filterToSpec("age,lt,30");
            Predicate expectedPredicate = getPredicate(expectedSpec);
            Predicate actualPredicate = getPredicate(actualSpec);
            assertEquals(expectedPredicate, actualPredicate);
        }

        @Test
        public void testToSpecificationGreaterThan() {
            Specification<String> expectedSpec = (root, query, criteriaBuilder) ->
                    criteriaBuilder.greaterThan(root.get("age"), "30");
            Specification<String> actualSpec = OpenApiHelper.filterToSpec("age,gt,30");
            Predicate expectedPredicate = getPredicate(expectedSpec);
            Predicate actualPredicate = getPredicate(actualSpec);
            assertEquals(expectedPredicate, actualPredicate);
        }

        @Test
        public void testToSpecificationLessThanOrEqual() {
            Specification<String> expectedSpec = (root, query, criteriaBuilder) ->
                    criteriaBuilder.lessThanOrEqualTo(root.get("age"), "30");
            Specification<String> actualSpec = OpenApiHelper.filterToSpec("age,lte,30");
            Predicate expectedPredicate = getPredicate(expectedSpec);
            Predicate actualPredicate = getPredicate(actualSpec);
            assertEquals(expectedPredicate, actualPredicate);
        }

        @Test
        public void testToSpecificationGreaterThanOrEqual() {
            Specification<String> expectedSpec = (root, query, criteriaBuilder) ->
                    criteriaBuilder.greaterThanOrEqualTo(root.get("age"), "30");
            Specification<String> actualSpec = OpenApiHelper.filterToSpec("age,gte,30");
            Predicate expectedPredicate = getPredicate(expectedSpec);
            Predicate actualPredicate = getPredicate(actualSpec);
            assertEquals(expectedPredicate, actualPredicate);
        }

        @Test
        public void testToSpecificationIn() {
            Specification<String> expectedSpec = (root, query, criteriaBuilder) ->
                    root.get("name").in(Arrays.asList("apple", "banana"));
            Specification<String> actualSpec = OpenApiHelper.filterToSpec("name,in,apple,banana");
            Predicate expectedPredicate = getPredicate(expectedSpec, "name");
            Predicate actualPredicate = getPredicate(actualSpec, "name");
            assertEquals(expectedPredicate, actualPredicate);
        }

        @Test
        public void testToSpecificationNotIn() {
            Specification<String> expectedSpec = (root, query, criteriaBuilder) ->
                    criteriaBuilder.not(root.get("name").in(Arrays.asList("apple", "banana")));
            Specification<String> actualSpec = OpenApiHelper.filterToSpec("name,nin,apple,banana");
            Predicate expectedPredicate = getPredicate(expectedSpec, "name");
            Predicate actualPredicate = getPredicate(actualSpec, "name");
            assertEquals(expectedPredicate, actualPredicate);
        }

        @Test
        public void testToSpecificationContains() {
            Specification<String> expectedSpec = (root, query, criteriaBuilder) ->
                    criteriaBuilder.like(root.get("name"), "%test%");
            Specification<String> actualSpec = OpenApiHelper.filterToSpec("name,contains,test");
            Predicate expectedPredicate = getPredicate(expectedSpec);
            Predicate actualPredicate = getPredicate(actualSpec);
            assertEquals(expectedPredicate, actualPredicate);
        }

        @Test
        public void testToSpecificationNotContains() {
            Specification<String> expectedSpec = (root, query, criteriaBuilder) ->
                    criteriaBuilder.notLike(root.get("name"), "%test%");
            Specification<String> actualSpec = OpenApiHelper.filterToSpec("name,ncontains,test");
            Predicate expectedPredicate = getPredicate(expectedSpec);
            Predicate actualPredicate = getPredicate(actualSpec);
            assertEquals(expectedPredicate, actualPredicate);
        }

        @Test
        public void testToSpecificationContainsCaseInsensitive() {
            Specification<String> expectedSpec = (root, query, criteriaBuilder) ->
                    criteriaBuilder.like(criteriaBuilder.lower(root.get("name")), "%test%");
            Specification<String> actualSpec = OpenApiHelper.filterToSpec("name,containss,test");
            Predicate expectedPredicate = getPredicate(expectedSpec);
            Predicate actualPredicate = getPredicate(actualSpec);
            assertEquals(expectedPredicate, actualPredicate);
        }

        @Test
        public void testToSpecificationNotContainsCaseInsensitive() {
            Specification<String> expectedSpec = (root, query, criteriaBuilder) ->
                    criteriaBuilder.notLike(criteriaBuilder.lower(root.get("name")), "%test%");
            Specification<String> actualSpec = OpenApiHelper.filterToSpec("name,ncontainss,test");
            Predicate expectedPredicate = getPredicate(expectedSpec);
            Predicate actualPredicate = getPredicate(actualSpec);
            assertEquals(expectedPredicate, actualPredicate);
        }

        @Test
        public void testToSpecificationIsNull() {
            Specification<String> expectedSpec = (root, query, criteriaBuilder) ->
                    criteriaBuilder.isNull(root.get("name"));
            Specification<String> actualSpec = OpenApiHelper.filterToSpec("name,null,");
            Predicate expectedPredicate = getPredicate(expectedSpec);
            Predicate actualPredicate = getPredicate(actualSpec);
            assertEquals(expectedPredicate, actualPredicate);
        }

        @Test
        public void testToSpecificationIsNotNull() {
            Specification<String> expectedSpec = (root, query, criteriaBuilder) ->
                    criteriaBuilder.isNotNull(root.get("name"));
            Specification<String> actualSpec = OpenApiHelper.filterToSpec("name,nnull,");
            Predicate expectedPredicate = getPredicate(expectedSpec);
            Predicate actualPredicate = getPredicate(actualSpec);
            assertEquals(expectedPredicate, actualPredicate);
        }

        @Test
        public void testToSpecificationStartsWith() {
            Specification<String> expectedSpec = (root, query, criteriaBuilder) ->
                    criteriaBuilder.like(root.get("name"), "test%");
            Specification<String> actualSpec = OpenApiHelper.filterToSpec("name,startswith,test");
            Predicate expectedPredicate = getPredicate(expectedSpec);
            Predicate actualPredicate = getPredicate(actualSpec);
            assertEquals(expectedPredicate, actualPredicate);
        }

        @Test
        public void testToSpecificationNotStartsWith() {
            Specification<String> expectedSpec = (root, query, criteriaBuilder) ->
                    criteriaBuilder.notLike(root.get("name"), "test%");
            Specification<String> actualSpec = OpenApiHelper.filterToSpec("name,nstartswith,test");
            Predicate expectedPredicate = getPredicate(expectedSpec);
            Predicate actualPredicate = getPredicate(actualSpec);
            assertEquals(expectedPredicate, actualPredicate);
        }

        @Test
        public void testToSpecificationStartsWithCaseInsensitive() {
            Specification<String> expectedSpec = (root, query, criteriaBuilder) ->
                    criteriaBuilder.like(criteriaBuilder.lower(root.get("name")), "test%");
            Specification<String> actualSpec = OpenApiHelper.filterToSpec("name,startswiths,test");
            Predicate expectedPredicate = getPredicate(expectedSpec);
            Predicate actualPredicate = getPredicate(actualSpec);
            assertEquals(expectedPredicate, actualPredicate);
        }

        @Test
        public void testToSpecificationNotStartsWithCaseInsensitive() {
            Specification<String> expectedSpec = (root, query, criteriaBuilder) ->
                    criteriaBuilder.notLike(criteriaBuilder.lower(root.get("name")), "test%");
            Specification<String> actualSpec = OpenApiHelper.filterToSpec("name,nstartswiths,test");
            Predicate expectedPredicate = getPredicate(expectedSpec);
            Predicate actualPredicate = getPredicate(actualSpec);
            assertEquals(expectedPredicate, actualPredicate);
        }

        @Test
        public void testToSpecificationEndsWith() {
            Specification<String> expectedSpec = (root, query, criteriaBuilder) ->
                    criteriaBuilder.like(root.get("name"), "%test");
            Specification<String> actualSpec = OpenApiHelper.filterToSpec("name,endswith,test");
            Predicate expectedPredicate = getPredicate(expectedSpec);
            Predicate actualPredicate = getPredicate(actualSpec);
            assertEquals(expectedPredicate, actualPredicate);
        }

        @Test
        public void testToSpecificationNotEndsWith() {
            Specification<String> expectedSpec = (root, query, criteriaBuilder) ->
                    criteriaBuilder.notLike(root.get("name"), "%test");
            Specification<String> actualSpec = OpenApiHelper.filterToSpec("name,nendswith,test");
            Predicate expectedPredicate = getPredicate(expectedSpec);
            Predicate actualPredicate = getPredicate(actualSpec);
            assertEquals(expectedPredicate, actualPredicate);
        }

        @Test
        public void testToSpecificationEndsWithCaseInsensitive() {
            Specification<String> expectedSpec = (root, query, criteriaBuilder) ->
                    criteriaBuilder.like(criteriaBuilder.lower(root.get("name")), "%test");
            Specification<String> actualSpec = OpenApiHelper.filterToSpec("name,endswiths,test");
            Predicate expectedPredicate = getPredicate(expectedSpec);
            Predicate actualPredicate = getPredicate(actualSpec);
            assertEquals(expectedPredicate, actualPredicate);
        }

        @Test
        public void testToSpecificationNotEndsWithCaseInsensitive() {
            Specification<String> expectedSpec = (root, query, criteriaBuilder) ->
                    criteriaBuilder.notLike(criteriaBuilder.lower(root.get("name")), "%test");
            Specification<String> actualSpec = OpenApiHelper.filterToSpec("name,nendswiths,test");
            Predicate expectedPredicate = getPredicate(expectedSpec);
            Predicate actualPredicate = getPredicate(actualSpec);
            assertEquals(expectedPredicate, actualPredicate);
        }

        @Test
        public void testToSpecificationNullFilterString() {
            Specification<String> actualSpec = OpenApiHelper.filterToSpec(null);
            Predicate actualPredicate = getPredicate(actualSpec);
            assertNull(actualPredicate); // Or any other suitable assertion
        }

        @Test
        public void testToSpecificationInvalidFilterFormat() {
            assertThrows(IllegalArgumentException.class, () ->
                    OpenApiHelper.filterToSpec("name|eq"));
        }

        @Test
        public void testToSpecificationUnsupportedOperator() {
            assertDoesNotThrow(() -> OpenApiHelper.filterToSpec("name,invalidop,hello"));

            assertThrows(IllegalArgumentException.class, () ->
                    getPredicate(OpenApiHelper.filterToSpec("name,invalidop,hello"), "name"));
        }

        @Test
        public void testToSpecificationPathNotFound() {
            assertDoesNotThrow(() ->
                    getPredicate(OpenApiHelper.filterToSpec("name,invalidop,hello")));
        }

        private Predicate getPredicate(Specification<String> spec) {
            return spec.toPredicate(
                    mock(Root.class),
                    mock(CriteriaQuery.class),
                    mock(CriteriaBuilder.class));
        }

        private Predicate getPredicate(Specification<String> spec, String path) {
            var expressionMock = mock(Expression.class);

            var pathMock = mock(Path.class);
            when(pathMock.as(String.class)).thenReturn(expressionMock);

            var root = mock(Root.class);
            when(root.get(path)).thenReturn(pathMock);

            return spec.toPredicate(
                    root,
                    mock(CriteriaQuery.class),
                    mock(CriteriaBuilder.class));
        }
    }

    @Nested
    class SpecificationMultiFilterTest {
        @Mock
        private CriteriaBuilder criteriaBuilder;

        @Mock
        private CriteriaQuery<?> criteriaQuery;

        @Mock
        private Root<String> root;

        @Test
        public void testToSpecificationEqual() {
            Specification<String> expectedSpec = (root, query, criteriaBuilder) ->
                    criteriaBuilder.equal(root.get("name"), "hello");
            Specification<String> actualSpec = OpenApiHelper.filterToSpec("[\"name,eq,hello\"]");
            Predicate expectedPredicate = getPredicate(expectedSpec);
            Predicate actualPredicate = getPredicate(actualSpec);
            assertEquals(expectedPredicate, actualPredicate);
        }

        @Test
        public void testToSpecificationNotEqual() {
            Specification<String> expectedSpec = (root, query, criteriaBuilder) ->
                    criteriaBuilder.notEqual(root.get("name"), "hello");
            Specification<String> actualSpec = OpenApiHelper.filterToSpec("[\"name,ne,hello\"]");
            Predicate expectedPredicate = getPredicate(expectedSpec);
            Predicate actualPredicate = getPredicate(actualSpec);
            assertEquals(expectedPredicate, actualPredicate);
        }

        @Test
        public void testToSpecificationLessThan() {
            Specification<String> expectedSpec = (root, query, criteriaBuilder) ->
                    criteriaBuilder.lessThan(root.get("age"), "30");
            Specification<String> actualSpec = OpenApiHelper.filterToSpec("[\"age,lt,30\"]");
            Predicate expectedPredicate = getPredicate(expectedSpec);
            Predicate actualPredicate = getPredicate(actualSpec);
            assertEquals(expectedPredicate, actualPredicate);
        }

        @Test
        public void testToSpecificationGreaterThan() {
            Specification<String> expectedSpec = (root, query, criteriaBuilder) ->
                    criteriaBuilder.greaterThan(root.get("age"), "30");
            Specification<String> actualSpec = OpenApiHelper.filterToSpec("[\"age,gt,30\"]");
            Predicate expectedPredicate = getPredicate(expectedSpec);
            Predicate actualPredicate = getPredicate(actualSpec);
            assertEquals(expectedPredicate, actualPredicate);
        }

        @Test
        public void testToSpecificationLessThanOrEqual() {
            Specification<String> expectedSpec = (root, query, criteriaBuilder) ->
                    criteriaBuilder.lessThanOrEqualTo(root.get("age"), "30");
            Specification<String> actualSpec = OpenApiHelper.filterToSpec("[\"age,lte,30\"]");
            Predicate expectedPredicate = getPredicate(expectedSpec);
            Predicate actualPredicate = getPredicate(actualSpec);
            assertEquals(expectedPredicate, actualPredicate);
        }

        @Test
        public void testToSpecificationGreaterThanOrEqual() {
            Specification<String> expectedSpec = (root, query, criteriaBuilder) ->
                    criteriaBuilder.greaterThanOrEqualTo(root.get("age"), "30");
            Specification<String> actualSpec = OpenApiHelper.filterToSpec("[\"age,gte,30\"]");
            Predicate expectedPredicate = getPredicate(expectedSpec);
            Predicate actualPredicate = getPredicate(actualSpec);
            assertEquals(expectedPredicate, actualPredicate);
        }

        @Test
        public void testToSpecificationIn() {
            Specification<String> expectedSpec = (root, query, criteriaBuilder) ->
                    root.get("name").in(Arrays.asList("apple", "banana"));
            Specification<String> actualSpec = OpenApiHelper.filterToSpec("[\"name,in,apple,banana\"]");
            Predicate expectedPredicate = getPredicate(expectedSpec, "name");
            Predicate actualPredicate = getPredicate(actualSpec, "name");
            assertEquals(expectedPredicate, actualPredicate);
        }

        @Test
        public void testToSpecificationNotIn() {
            Specification<String> expectedSpec = (root, query, criteriaBuilder) ->
                    criteriaBuilder.not(root.get("name").in(Arrays.asList("apple", "banana")));
            Specification<String> actualSpec = OpenApiHelper.filterToSpec("[\"name,nin,apple,banana\"]");
            Predicate expectedPredicate = getPredicate(expectedSpec, "name");
            Predicate actualPredicate = getPredicate(actualSpec, "name");
            assertEquals(expectedPredicate, actualPredicate);
        }

        @Test
        public void testToSpecificationContains() {
            Specification<String> expectedSpec = (root, query, criteriaBuilder) ->
                    criteriaBuilder.like(root.get("name"), "%test%");
            Specification<String> actualSpec = OpenApiHelper.filterToSpec("[\"name,contains,test\"]");
            Predicate expectedPredicate = getPredicate(expectedSpec);
            Predicate actualPredicate = getPredicate(actualSpec);
            assertEquals(expectedPredicate, actualPredicate);
        }

        @Test
        public void testToSpecificationNotContains() {
            Specification<String> expectedSpec = (root, query, criteriaBuilder) ->
                    criteriaBuilder.notLike(root.get("name"), "%test%");
            Specification<String> actualSpec = OpenApiHelper.filterToSpec("[\"name,ncontains,test\"]");
            Predicate expectedPredicate = getPredicate(expectedSpec);
            Predicate actualPredicate = getPredicate(actualSpec);
            assertEquals(expectedPredicate, actualPredicate);
        }

        @Test
        public void testToSpecificationContainsCaseInsensitive() {
            Specification<String> expectedSpec = (root, query, criteriaBuilder) ->
                    criteriaBuilder.like(criteriaBuilder.lower(root.get("name")), "%test%");
            Specification<String> actualSpec = OpenApiHelper.filterToSpec("[\"name,containss,test\"]");
            Predicate expectedPredicate = getPredicate(expectedSpec);
            Predicate actualPredicate = getPredicate(actualSpec);
            assertEquals(expectedPredicate, actualPredicate);
        }

        @Test
        public void testToSpecificationNotContainsCaseInsensitive() {
            Specification<String> expectedSpec = (root, query, criteriaBuilder) ->
                    criteriaBuilder.notLike(criteriaBuilder.lower(root.get("name")), "%test%");
            Specification<String> actualSpec = OpenApiHelper.filterToSpec("[\"name,ncontainss,test\"]");
            Predicate expectedPredicate = getPredicate(expectedSpec);
            Predicate actualPredicate = getPredicate(actualSpec);
            assertEquals(expectedPredicate, actualPredicate);
        }

        @Test
        public void testToSpecificationIsNull() {
            Specification<String> expectedSpec = (root, query, criteriaBuilder) ->
                    criteriaBuilder.isNull(root.get("name"));
            Specification<String> actualSpec = OpenApiHelper.filterToSpec("[\"name,null,\"]");
            Predicate expectedPredicate = getPredicate(expectedSpec);
            Predicate actualPredicate = getPredicate(actualSpec);
            assertEquals(expectedPredicate, actualPredicate);
        }

        @Test
        public void testToSpecificationIsNotNull() {
            Specification<String> expectedSpec = (root, query, criteriaBuilder) ->
                    criteriaBuilder.isNotNull(root.get("name"));
            Specification<String> actualSpec = OpenApiHelper.filterToSpec("[\"name,nnull,\"]");
            Predicate expectedPredicate = getPredicate(expectedSpec);
            Predicate actualPredicate = getPredicate(actualSpec);
            assertEquals(expectedPredicate, actualPredicate);
        }

        @Test
        public void testToSpecificationStartsWith() {
            Specification<String> expectedSpec = (root, query, criteriaBuilder) ->
                    criteriaBuilder.like(root.get("name"), "test%");
            Specification<String> actualSpec = OpenApiHelper.filterToSpec("[\"name,startswith,test\"]");
            Predicate expectedPredicate = getPredicate(expectedSpec);
            Predicate actualPredicate = getPredicate(actualSpec);
            assertEquals(expectedPredicate, actualPredicate);
        }

        @Test
        public void testToSpecificationNotStartsWith() {
            Specification<String> expectedSpec = (root, query, criteriaBuilder) ->
                    criteriaBuilder.notLike(root.get("name"), "test%");
            Specification<String> actualSpec = OpenApiHelper.filterToSpec("[\"name,nstartswith,test\"]");
            Predicate expectedPredicate = getPredicate(expectedSpec);
            Predicate actualPredicate = getPredicate(actualSpec);
            assertEquals(expectedPredicate, actualPredicate);
        }

        @Test
        public void testToSpecificationStartsWithCaseInsensitive() {
            Specification<String> expectedSpec = (root, query, criteriaBuilder) ->
                    criteriaBuilder.like(criteriaBuilder.lower(root.get("name")), "test%");
            Specification<String> actualSpec = OpenApiHelper.filterToSpec("[\"name,startswiths,test\"]");
            Predicate expectedPredicate = getPredicate(expectedSpec);
            Predicate actualPredicate = getPredicate(actualSpec);
            assertEquals(expectedPredicate, actualPredicate);
        }

        @Test
        public void testToSpecificationNotStartsWithCaseInsensitive() {
            Specification<String> expectedSpec = (root, query, criteriaBuilder) ->
                    criteriaBuilder.notLike(criteriaBuilder.lower(root.get("name")), "test%");
            Specification<String> actualSpec = OpenApiHelper.filterToSpec("[\"name,nstartswiths,test\"]");
            Predicate expectedPredicate = getPredicate(expectedSpec);
            Predicate actualPredicate = getPredicate(actualSpec);
            assertEquals(expectedPredicate, actualPredicate);
        }

        @Test
        public void testToSpecificationEndsWith() {
            Specification<String> expectedSpec = (root, query, criteriaBuilder) ->
                    criteriaBuilder.like(root.get("name"), "%test");
            Specification<String> actualSpec = OpenApiHelper.filterToSpec("[\"name,endswith,test\"]");
            Predicate expectedPredicate = getPredicate(expectedSpec);
            Predicate actualPredicate = getPredicate(actualSpec);
            assertEquals(expectedPredicate, actualPredicate);
        }

        @Test
        public void testToSpecificationNotEndsWith() {
            Specification<String> expectedSpec = (root, query, criteriaBuilder) ->
                    criteriaBuilder.notLike(root.get("name"), "%test");
            Specification<String> actualSpec = OpenApiHelper.filterToSpec("[\"name,nendswith,test\"]");
            Predicate expectedPredicate = getPredicate(expectedSpec);
            Predicate actualPredicate = getPredicate(actualSpec);
            assertEquals(expectedPredicate, actualPredicate);
        }

        @Test
        public void testToSpecificationEndsWithCaseInsensitive() {
            Specification<String> expectedSpec = (root, query, criteriaBuilder) ->
                    criteriaBuilder.like(criteriaBuilder.lower(root.get("name")), "%test");
            Specification<String> actualSpec = OpenApiHelper.filterToSpec("[\"name,endswiths,test\"]");
            Predicate expectedPredicate = getPredicate(expectedSpec);
            Predicate actualPredicate = getPredicate(actualSpec);
            assertEquals(expectedPredicate, actualPredicate);
        }

        @Test
        public void testToSpecificationNotEndsWithCaseInsensitive() {
            Specification<String> expectedSpec = (root, query, criteriaBuilder) ->
                    criteriaBuilder.notLike(criteriaBuilder.lower(root.get("name")), "%test");
            Specification<String> actualSpec = OpenApiHelper.filterToSpec("[\"name,nendswiths,test\"]");
            Predicate expectedPredicate = getPredicate(expectedSpec);
            Predicate actualPredicate = getPredicate(actualSpec);
            assertEquals(expectedPredicate, actualPredicate);
        }

        @Test
        public void testToSpecificationInvalidFilterFormat() {
            assertThrows(IllegalArgumentException.class, () ->
                    OpenApiHelper.filterToSpec("[name,eq]"));
            assertThrows(IllegalArgumentException.class, () ->
                    OpenApiHelper.filterToSpec("[123,,,]"));
        }

        @Test
        public void testToSpecificationPathNotFound() {
            assertDoesNotThrow(() ->
                    getPredicate(OpenApiHelper.filterToSpec("[\"name,invalidop,hello\"]")));
        }

        private Predicate getPredicate(Specification<String> spec) {
            return spec.toPredicate(
                    mock(Root.class),
                    mock(CriteriaQuery.class),
                    mock(CriteriaBuilder.class));
        }

        private Predicate getPredicate(Specification<String> spec, String path) {
            var expressionMock = mock(Expression.class);

            var pathMock = mock(Path.class);
            when(pathMock.as(String.class)).thenReturn(expressionMock);

            var root = mock(Root.class);
            when(root.get(path)).thenReturn(pathMock);

            return spec.toPredicate(
                    root,
                    mock(CriteriaQuery.class),
                    mock(CriteriaBuilder.class));
        }
    }

    @Nested
    class SpecificationNestedFilterTest {

        @Test
        public void testToSpecificationWith2NestedFields() {
            Specification<String> expectedSpec = (root, query, criteriaBuilder) ->
                    criteriaBuilder.equal(root.get("parent").get("child"), "100.001");
            Specification<String> actualSpec = OpenApiHelper.filterToSpec("parent.child,eq,100.001");
            Predicate expectedPredicate = getPredicate(expectedSpec, "parent.child");
            Predicate actualPredicate = getPredicate(actualSpec, "parent.child");
            assertEquals(expectedPredicate, actualPredicate);
        }

        @Test
        public void testToSpecificationWith3NestedFields() {
            Specification<String> expectedSpec = (root, query, criteriaBuilder) ->
                    criteriaBuilder.equal(root.get("grandparent").get("parent").get("child"), "100.001");
            Specification<String> actualSpec = OpenApiHelper.filterToSpec("grandparent.parent.child,eq,100.001");
            Predicate expectedPredicate = getPredicate(expectedSpec, "grandparent.parent.child");
            Predicate actualPredicate = getPredicate(actualSpec, "grandparent.parent.child");
            assertEquals(expectedPredicate, actualPredicate);
        }

        private Predicate getPredicate(Specification<String> spec, String path) {
            var root = mock(Root.class);

            // Split the path by dot delimiter for nested path support
            String[] pathSegments = path.split("\\.");
            Path<?> currentPath = root;

            // Mock each segment in the path
            for (String segment : pathSegments) {
                var nextPath = mock(Path.class);
                when(currentPath.get(segment)).thenReturn(nextPath);
                currentPath = nextPath;
            }

            return spec.toPredicate(
                    root,
                    mock(CriteriaQuery.class),
                    mock(CriteriaBuilder.class));
        }
    }
}