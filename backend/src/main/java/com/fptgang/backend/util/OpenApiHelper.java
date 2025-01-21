package com.fptgang.backend.util;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.persistence.criteria.CriteriaBuilder;
import jakarta.persistence.criteria.Expression;
import jakarta.persistence.criteria.Path;
import jakarta.persistence.criteria.Predicate;
import org.joor.Reflect;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.http.HttpStatus;
import org.springframework.http.HttpStatusCode;
import org.springframework.http.ResponseEntity;

import java.lang.reflect.Field;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class OpenApiHelper {
    private static final ObjectMapper OBJECT_MAPPER = new ObjectMapper();

    public static Pageable toPageable(Object pageableObj) {
        if (pageableObj == null) {
            return Pageable.unpaged();
        }

        Integer page = Reflect.on(pageableObj).field("page").get();
        Integer size = Reflect.on(pageableObj).field("size").get();
        List<String> sortFields = Reflect.on(pageableObj).field("sort").get();
        Sort sort = convertToSpringSort(sortFields);

        return PageRequest.of(page, size, sort);
    }

    private static Sort convertToSpringSort(List<String> sort) {
        String joinedSort = String.join(",", sort);
        List<Sort.Order> orders = new ArrayList<>();
        String[] fieldsAndOrders = joinedSort.split(",");

        for (int i = 0; i < fieldsAndOrders.length - 1; i += 2) {
            String field = fieldsAndOrders[i];
            String order = fieldsAndOrders[i + 1];
            if (field.isEmpty() || order.isEmpty())
                continue;

            if ("asc".equalsIgnoreCase(order)) {
                orders.add(Sort.Order.asc(field));
            } else if ("desc".equalsIgnoreCase(order)) {
                orders.add(Sort.Order.desc(field));
            }
        }

        return Sort.by(orders);
    }


    public static <T> T toPage(Page<?> page, Class<T> clazz) {
        T response = Reflect.on(clazz).create().get();
        Reflect.on(response).set("content", page.getContent());
        Reflect.on(response).set("totalElements", page.getTotalElements());
        Reflect.on(response).set("totalPages", page.getTotalPages());
        Reflect.on(response).set("last", page.isLast());
        Reflect.on(response).set("first", page.isFirst());
        Reflect.on(response).set("numberOfElements", page.getNumberOfElements());
        Reflect.on(response).set("empty", page.isEmpty());
        return response;
    }

    public static <T> ResponseEntity<T> respondPage(Page<?> page, Class<T> clazz, HttpStatusCode code) {
        return new ResponseEntity<>(toPage(page, clazz), code);
    }

    public static <T> ResponseEntity<T> respondPage(Page<?> page, Class<T> clazz) {
        return new ResponseEntity<>(toPage(page, clazz), HttpStatus.OK);
    }

    public static <T> Specification<T> searchToSpec(String search) {
        if (search == null)
            return Specification.anyOf();

        search = search.trim();

        if (search.isEmpty())
            return Specification.anyOf();

        final String normalizedSearch = search.toLowerCase();

        return (root, query, criteriaBuilder) -> {
            List<Predicate> predicates = new ArrayList<>();
            Field[] fields = root.getJavaType().getDeclaredFields();

            for (Field field : fields) {
                if (field.isAnnotationPresent(Searchable.class)) {
                    predicates.add(criteriaBuilder.like(
                            criteriaBuilder.lower(root.get(field.getName()).as(String.class)),
                            "%" + normalizedSearch + "%"
                    ));
                }
            }

            return criteriaBuilder.or(predicates.toArray(new Predicate[0]));
        };
    }

    public static <T> Specification<T> filterToSpec(String filter) {
        if (filter == null)
            return Specification.anyOf();

        filter = filter.trim();

        if (filter.isEmpty())
            return Specification.anyOf();

        if (filter.startsWith("[") && filter.endsWith("]")) {
            try {
                String[] args = OBJECT_MAPPER.readValue(filter, String[].class);
                if (args.length == 0) {
                    return Specification.anyOf();
                }

                if (args.length == 1) {
                    return toSpecificationSingle(args[0]);
                }

                //noinspection unchecked
                return Specification.allOf(
                        Arrays.stream(args)
                                .map(OpenApiHelper::toSpecificationSingle)
                                .toArray(Specification[]::new)
                );
            } catch (JsonProcessingException e) {
                throw new IllegalArgumentException("Invalid multi-filter format");
            }
        }

        return toSpecificationSingle(filter);
    }

    private static <T> Specification<T> toSpecificationSingle(String filterString) {
        String[] filterParts = filterString.split(",", 3);

        if (filterParts.length != 2 && filterParts.length != 3) {
            throw new IllegalArgumentException("Invalid filter format. Expected: field,op,value");
        }


        return (root, query, criteriaBuilder) -> {
            String[] fieldPaths = filterParts[0].split("\\.");
            Path<?> fieldPath = root.get(fieldPaths[0]);

            if (fieldPath == null) {
                return criteriaBuilder.or();
            }

            for (int i = 1; i < Math.min(5, fieldPaths.length); i++) {
                fieldPath = fieldPath.get(fieldPaths[i]);

                if (fieldPath == null) {
                    return criteriaBuilder.or();
                }
            }

            String operator = filterParts[1].toLowerCase();

            // common operators
            if (operator.equals("null")) {
                return criteriaBuilder.isNull(fieldPath);
            } else if (operator.equals("nnull")) {
                return criteriaBuilder.isNotNull(fieldPath);
            }

            String value = filterParts.length == 3 ? filterParts[2] : "";
            Class<?> javaType = fieldPath.getJavaType();

            if (javaType == boolean.class || javaType == Boolean.class) {
                return predicateForBoolean(criteriaBuilder, fieldPath.as(Boolean.class), operator, value);
            }

            if (javaType == double.class || javaType == Double.class ||
                    javaType == float.class || javaType == Float.class) {
                return predicateForDouble(criteriaBuilder, fieldPath.as(Double.class), operator, value);
            }

            if (javaType == long.class || javaType == Long.class ||
                    javaType == int.class || javaType == Integer.class ||
                    javaType == short.class || javaType == Short.class ||
                    javaType == byte.class || javaType == Byte.class) {
                return predicateForLong(criteriaBuilder, fieldPath.as(Long.class), operator, value);
            }

            if (javaType == BigDecimal.class) {
                return predicateForBigDecimal(criteriaBuilder, fieldPath.as(BigDecimal.class), operator, value);
            }

            if (javaType == LocalDateTime.class) {
                return predicateForLocalDateTime(criteriaBuilder, fieldPath.as(LocalDateTime.class), operator, value);
            }

            return predicateForString(criteriaBuilder, fieldPath.as(String.class), operator, value);
        };
    }

    private static Predicate predicateForBoolean(CriteriaBuilder criteriaBuilder,
                                                 Expression<Boolean> fieldPath,
                                                 String operator,
                                                 String value) {
        return switch (operator) {
            case "eq" ->
                    criteriaBuilder.equal(fieldPath, Boolean.parseBoolean(value));
            case "ne" ->
                    criteriaBuilder.notEqual(fieldPath, Boolean.parseBoolean(value));
            case "in" ->
                    fieldPath.in(Arrays.stream(value.split(",")).map(Boolean::parseBoolean).toList());
            case "nin" ->
                    criteriaBuilder.not(fieldPath.in(Arrays.stream(value.split(",")).map(Boolean::parseBoolean).toList()));
            default ->
                    throw new IllegalArgumentException("Unsupported operator: " + operator);
        };
    }

    private static Predicate predicateForBigDecimal(CriteriaBuilder criteriaBuilder,
                                                    Expression<BigDecimal> fieldPath,
                                                    String operator,
                                                    String value) {
        return switch (operator) {
            case "lt" ->
                    criteriaBuilder.lessThan(fieldPath, new BigDecimal(value));
            case "gt" ->
                    criteriaBuilder.greaterThan(fieldPath, new BigDecimal(value));
            case "lte" ->
                    criteriaBuilder.lessThanOrEqualTo(fieldPath, new BigDecimal(value));
            case "gte" ->
                    criteriaBuilder.greaterThanOrEqualTo(fieldPath, new BigDecimal(value));
            case "eq" -> criteriaBuilder.lt(
                    criteriaBuilder.abs(criteriaBuilder.diff(fieldPath, new BigDecimal(value))),
                    new BigDecimal("1e-9")
            );
            case "ne" -> criteriaBuilder.not(
                    criteriaBuilder.lt(
                            criteriaBuilder.abs(criteriaBuilder.diff(fieldPath, new BigDecimal(value))),
                            new BigDecimal("1e-9")
                    )
            );
            default ->
                    throw new IllegalArgumentException("Unsupported operator: " + operator);
        };
    }

    private static Predicate predicateForDouble(CriteriaBuilder criteriaBuilder,
                                                Expression<Double> fieldPath,
                                                String operator,
                                                String value) {
        return switch (operator) {
            case "lt" ->
                    criteriaBuilder.lessThan(fieldPath, Double.parseDouble(value));
            case "gt" ->
                    criteriaBuilder.greaterThan(fieldPath, Double.parseDouble(value));
            case "lte" ->
                    criteriaBuilder.lessThanOrEqualTo(fieldPath, Double.parseDouble(value));
            case "gte" ->
                    criteriaBuilder.greaterThanOrEqualTo(fieldPath, Double.parseDouble(value));
            case "eq" -> criteriaBuilder.lt(
                    criteriaBuilder.abs(criteriaBuilder.diff(fieldPath, Double.parseDouble(value))),
                    1e-9d
            );
            case "ne" -> criteriaBuilder.not(
                    criteriaBuilder.lt(
                            criteriaBuilder.abs(criteriaBuilder.diff(fieldPath, Double.parseDouble(value))),
                            1e-9d
                    )
            );
            default ->
                    throw new IllegalArgumentException("Unsupported operator: " + operator);
        };
    }

    private static Predicate predicateForLong(CriteriaBuilder criteriaBuilder,
                                              Expression<Long> fieldPath,
                                              String operator,
                                              String value) {
        return switch (operator) {
            case "lt" ->
                    criteriaBuilder.lessThan(fieldPath, Long.parseLong(value));
            case "gt" ->
                    criteriaBuilder.greaterThan(fieldPath, Long.parseLong(value));
            case "lte" ->
                    criteriaBuilder.lessThanOrEqualTo(fieldPath, Long.parseLong(value));
            case "gte" ->
                    criteriaBuilder.greaterThanOrEqualTo(fieldPath, Long.parseLong(value));
            case "eq" ->
                    criteriaBuilder.equal(fieldPath, Long.parseLong(value));
            case "ne" ->
                    criteriaBuilder.not(criteriaBuilder.equal(fieldPath, Long.parseLong(value)));
            default ->
                    throw new IllegalArgumentException("Unsupported operator: " + operator);
        };
    }

    private static Predicate predicateForLocalDateTime(CriteriaBuilder criteriaBuilder,
                                                       Expression<LocalDateTime> fieldPath,
                                                       String operator,
                                                       String value) {
        return switch (operator) {
            case "lt" ->
                    criteriaBuilder.lessThan(fieldPath, LocalDateTime.parse(value));
            case "gt" ->
                    criteriaBuilder.greaterThan(fieldPath, LocalDateTime.parse(value));
            case "lte" ->
                    criteriaBuilder.lessThanOrEqualTo(fieldPath, LocalDateTime.parse(value));
            case "gte" ->
                    criteriaBuilder.greaterThanOrEqualTo(fieldPath, LocalDateTime.parse(value));
            case "eq" ->
                    criteriaBuilder.equal(fieldPath, LocalDateTime.parse(value));
            case "ne" ->
                    criteriaBuilder.not(criteriaBuilder.equal(fieldPath, LocalDateTime.parse(value)));
            case "in" ->
                    fieldPath.in(Arrays.stream(value.split(",")).map(LocalDateTime::parse).toList());
            case "nin" ->
                    criteriaBuilder.not(fieldPath.in(Arrays.stream(value.split(",")).map(LocalDateTime::parse).toList()));
            default ->
                    throw new IllegalArgumentException("Unsupported operator: " + operator);
        };
    }

    private static Predicate predicateForString(CriteriaBuilder criteriaBuilder,
                                                Expression<String> fieldPath,
                                                String operator,
                                                String value) {

        return switch (operator) {
            case "eq" -> criteriaBuilder.equal(fieldPath, value);
            case "ne" ->
                    criteriaBuilder.not(criteriaBuilder.equal(fieldPath, value));
            case "lt" -> criteriaBuilder.lessThan(fieldPath, value);
            case "gt" -> criteriaBuilder.greaterThan(fieldPath, value);
            case "lte" -> criteriaBuilder.lessThanOrEqualTo(fieldPath, value);
            case "gte" ->
                    criteriaBuilder.greaterThanOrEqualTo(fieldPath, value);
            case "in" -> fieldPath.in(Arrays.asList(value.split(",")));
            case "nin" ->
                    criteriaBuilder.not(fieldPath.in(Arrays.asList(value.split(","))));
            case "contains" ->
                    criteriaBuilder.like(fieldPath, "%" + value + "%");
            case "ncontains" ->
                    criteriaBuilder.notLike(fieldPath, "%" + value + "%");
            case "containss" ->
                    criteriaBuilder.like(criteriaBuilder.lower(fieldPath), "%" + value.toLowerCase() + "%");
            case "ncontainss" ->
                    criteriaBuilder.notLike(criteriaBuilder.lower(fieldPath), "%" + value.toLowerCase() + "%");
            case "startswith" -> criteriaBuilder.like(fieldPath, value + "%");
            case "nstartswith" ->
                    criteriaBuilder.notLike(fieldPath, value + "%");
            case "startswiths" ->
                    criteriaBuilder.like(criteriaBuilder.lower(fieldPath), value.toLowerCase() + "%");
            case "nstartswiths" ->
                    criteriaBuilder.notLike(criteriaBuilder.lower(fieldPath), value.toLowerCase() + "%");
            case "endswith" -> criteriaBuilder.like(fieldPath, "%" + value);
            case "nendswith" -> criteriaBuilder.notLike(fieldPath, "%" + value);
            case "endswiths" ->
                    criteriaBuilder.like(criteriaBuilder.lower(fieldPath), "%" + value.toLowerCase());
            case "nendswiths" ->
                    criteriaBuilder.notLike(criteriaBuilder.lower(fieldPath), "%" + value.toLowerCase());
            default ->
                    throw new IllegalArgumentException("Unsupported operator: " + operator);
        };
    }
}