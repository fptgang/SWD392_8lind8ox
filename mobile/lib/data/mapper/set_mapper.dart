import 'package:flutter/foundation.dart';
import 'package:mobile/data/mapper/blindbox_mapper.dart';
import 'package:mobile/data/mapper/sku_mapper.dart';
import 'package:mobile/data/mapper/slot_mapper.dart';
import 'package:mobile/data/models/sets_response_model.dart';
import 'package:mobile/data/models/sku_model.dart';
import 'package:mobile/data/models/blindbox_model.dart';
import 'package:openapi/api.dart';

import '../models/set_model.dart';

class SetMapper {
  static SetModel toModel(SetDto dto) {
    // Log detailed information for debugging
    debugPrint('Mapping SetDto to SetModel. Set ID: ${dto.setId}');

    try {
      // Create fallback models for required fields
      final defaultSku = StockKeepingUnitModel(
          skuId: 0,
          price: 0,
          stock: 0,
          name: 'Unknown SKU',
          createdAt: DateTime.now());

      final defaultBlindBox = BlindBoxModel(
          blindBoxId: 0,
          name: 'Unknown Box',
          description: '',
          createdAt: DateTime.now(),
          images: []);

      return SetModel(
        setId: dto.setId ?? 0,
        sku: dto.sku != null ? SkuMapper.toModel(dto.sku!) : defaultSku,
        isVisible: dto.isVisible,
        slots: dto.slots?.map((e) => SlotMapper.toModel(e)).toList() ?? [],
        blindBox: dto.blindBox != null
            ? BlindBoxMapper.toModel(dto.blindBox!)
            : defaultBlindBox,
        createdAt: dto.createdAt ?? DateTime.now(),
        updatedAt: dto.updatedAt,
      );
    } catch (e, stackTrace) {
      debugPrint('Error mapping SetDto to SetModel: $e');
      debugPrint('Stack trace: $stackTrace');

      // Create fallback models for required fields
      final defaultSku = StockKeepingUnitModel(
          skuId: 0,
          price: 0,
          stock: 0,
          name: 'Unknown SKU',
          createdAt: DateTime.now());

      final defaultBlindBox = BlindBoxModel(
          blindBoxId: 0,
          name: 'Unknown Box',
          description: '',
          createdAt: DateTime.now(),
          images: []);

      // Return a default model with required fields
      return SetModel(
        setId: dto.setId ?? 0,
        isVisible: false,
        slots: [],
        sku: defaultSku,
        blindBox: defaultBlindBox,
        createdAt: DateTime.now(),
      );
    }
  }

  static SetResponseModel toModels(GetSets200Response dto) {
    try {
      return SetResponseModel(
        content: dto.content.map((e) {
          try {
            return SetMapper.toModel(e);
          } catch (err) {
            debugPrint('Error mapping individual set: $err');

            // Create fallback models for required fields
            final defaultSku = StockKeepingUnitModel(
                skuId: 0,
                price: 0,
                stock: 0,
                name: 'Unknown SKU',
                createdAt: DateTime.now());

            final defaultBlindBox = BlindBoxModel(
                blindBoxId: 0,
                name: 'Unknown Box',
                description: '',
                createdAt: DateTime.now(),
                images: []);

            // Return a minimal valid set
            return SetModel(
              setId: e.setId ?? 0,
              isVisible: false,
              slots: [],
              sku: defaultSku,
              blindBox: defaultBlindBox,
              createdAt: DateTime.now(),
            );
          }
        }).toList(),
        totalElements: dto.totalElements ?? 0,
        totalPages: dto.totalPages ?? 0,
        last: dto.last ?? false,
        first: dto.first ?? true,
        numberOfElements: dto.numberOfElements ?? 0,
        empty: dto.empty ?? true,
      );
    } catch (e) {
      debugPrint('Error in SetMapper.toModels: $e');

      // Create fallback models for required fields for an empty response
      final defaultSku = StockKeepingUnitModel(
          skuId: 0,
          price: 0,
          stock: 0,
          name: 'Unknown SKU',
          createdAt: DateTime.now());

      final defaultBlindBox = BlindBoxModel(
          blindBoxId: 0,
          name: 'Unknown Box',
          description: '',
          createdAt: DateTime.now(),
          images: []);

      // Return an empty response with a valid empty list
      return SetResponseModel(
        content: [],
        totalElements: 0,
        totalPages: 0,
        last: true,
        first: true,
        numberOfElements: 0,
        empty: true,
      );
    }
  }
}
