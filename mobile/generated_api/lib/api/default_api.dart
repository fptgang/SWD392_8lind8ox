//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class DefaultApi {
  DefaultApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Create an account
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [AccountDto] accountDto (required):
  ///   Account to create
  Future<Response> createAccountWithHttpInfo(AccountDto accountDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/accounts';

    // ignore: prefer_final_locals
    Object? postBody = accountDto;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Create an account
  ///
  /// Parameters:
  ///
  /// * [AccountDto] accountDto (required):
  ///   Account to create
  Future<AccountDto?> createAccount(AccountDto accountDto,) async {
    final response = await createAccountWithHttpInfo(accountDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'AccountDto',) as AccountDto;
    
    }
    return null;
  }

  /// Create a blind box
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [BlindBoxDto] blindBoxDto (required):
  ///   BlindBox to create
  Future<Response> createBlindBoxWithHttpInfo(BlindBoxDto blindBoxDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/blind-boxes';

    // ignore: prefer_final_locals
    Object? postBody = blindBoxDto;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Create a blind box
  ///
  /// Parameters:
  ///
  /// * [BlindBoxDto] blindBoxDto (required):
  ///   BlindBox to create
  Future<BlindBoxDto?> createBlindBox(BlindBoxDto blindBoxDto,) async {
    final response = await createBlindBoxWithHttpInfo(blindBoxDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'BlindBoxDto',) as BlindBoxDto;
    
    }
    return null;
  }

  /// Create a brand
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [BrandDto] brandDto (required):
  ///   Brand to create
  Future<Response> createBrandWithHttpInfo(BrandDto brandDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/brands';

    // ignore: prefer_final_locals
    Object? postBody = brandDto;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Create a brand
  ///
  /// Parameters:
  ///
  /// * [BrandDto] brandDto (required):
  ///   Brand to create
  Future<BrandDto?> createBrand(BrandDto brandDto,) async {
    final response = await createBrandWithHttpInfo(brandDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'BrandDto',) as BrandDto;
    
    }
    return null;
  }

  /// Create an image
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [ImageDto] imageDto (required):
  ///   Image to create
  Future<Response> createImageWithHttpInfo(ImageDto imageDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/images';

    // ignore: prefer_final_locals
    Object? postBody = imageDto;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Create an image
  ///
  /// Parameters:
  ///
  /// * [ImageDto] imageDto (required):
  ///   Image to create
  Future<ImageDto?> createImage(ImageDto imageDto,) async {
    final response = await createImageWithHttpInfo(imageDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ImageDto',) as ImageDto;
    
    }
    return null;
  }

  /// Create a notification
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [NotificationDto] notificationDto (required):
  ///   Notification to create
  Future<Response> createNotificationWithHttpInfo(NotificationDto notificationDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/notifications';

    // ignore: prefer_final_locals
    Object? postBody = notificationDto;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Create a notification
  ///
  /// Parameters:
  ///
  /// * [NotificationDto] notificationDto (required):
  ///   Notification to create
  Future<NotificationDto?> createNotification(NotificationDto notificationDto,) async {
    final response = await createNotificationWithHttpInfo(notificationDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'NotificationDto',) as NotificationDto;
    
    }
    return null;
  }

  /// Create an order
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [OrderDto] orderDto (required):
  ///   Order to create
  Future<Response> createOrderWithHttpInfo(OrderDto orderDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/orders';

    // ignore: prefer_final_locals
    Object? postBody = orderDto;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Create an order
  ///
  /// Parameters:
  ///
  /// * [OrderDto] orderDto (required):
  ///   Order to create
  Future<OrderDto?> createOrder(OrderDto orderDto,) async {
    final response = await createOrderWithHttpInfo(orderDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'OrderDto',) as OrderDto;
    
    }
    return null;
  }

  /// Create an order detail
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [OrderDetailDto] orderDetailDto (required):
  ///   OrderDetail to create
  Future<Response> createOrderDetailWithHttpInfo(OrderDetailDto orderDetailDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/order-details';

    // ignore: prefer_final_locals
    Object? postBody = orderDetailDto;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Create an order detail
  ///
  /// Parameters:
  ///
  /// * [OrderDetailDto] orderDetailDto (required):
  ///   OrderDetail to create
  Future<OrderDetailDto?> createOrderDetail(OrderDetailDto orderDetailDto,) async {
    final response = await createOrderDetailWithHttpInfo(orderDetailDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'OrderDetailDto',) as OrderDetailDto;
    
    }
    return null;
  }

  /// Create a pack
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [PackDto] packDto (required):
  ///   Pack to create
  Future<Response> createPackWithHttpInfo(PackDto packDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/packs';

    // ignore: prefer_final_locals
    Object? postBody = packDto;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Create a pack
  ///
  /// Parameters:
  ///
  /// * [PackDto] packDto (required):
  ///   Pack to create
  Future<PackDto?> createPack(PackDto packDto,) async {
    final response = await createPackWithHttpInfo(packDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'PackDto',) as PackDto;
    
    }
    return null;
  }

  /// Create a promotional campaign
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [PromotionalCampaignDto] promotionalCampaignDto (required):
  ///   PromotionalCampaign to create
  Future<Response> createPromotionalCampaignWithHttpInfo(PromotionalCampaignDto promotionalCampaignDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/promotional-campaigns';

    // ignore: prefer_final_locals
    Object? postBody = promotionalCampaignDto;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Create a promotional campaign
  ///
  /// Parameters:
  ///
  /// * [PromotionalCampaignDto] promotionalCampaignDto (required):
  ///   PromotionalCampaign to create
  Future<PromotionalCampaignDto?> createPromotionalCampaign(PromotionalCampaignDto promotionalCampaignDto,) async {
    final response = await createPromotionalCampaignWithHttpInfo(promotionalCampaignDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'PromotionalCampaignDto',) as PromotionalCampaignDto;
    
    }
    return null;
  }

  /// Create a transaction
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [TransactionDto] transactionDto (required):
  ///   Transaction to create
  Future<Response> createTransactionWithHttpInfo(TransactionDto transactionDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/transactions';

    // ignore: prefer_final_locals
    Object? postBody = transactionDto;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Create a transaction
  ///
  /// Parameters:
  ///
  /// * [TransactionDto] transactionDto (required):
  ///   Transaction to create
  Future<TransactionDto?> createTransaction(TransactionDto transactionDto,) async {
    final response = await createTransactionWithHttpInfo(transactionDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'TransactionDto',) as TransactionDto;
    
    }
    return null;
  }

  /// Create a video
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [VideoDto] videoDto (required):
  ///   Video to create
  Future<Response> createVideoWithHttpInfo(VideoDto videoDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/videos';

    // ignore: prefer_final_locals
    Object? postBody = videoDto;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Create a video
  ///
  /// Parameters:
  ///
  /// * [VideoDto] videoDto (required):
  ///   Video to create
  Future<VideoDto?> createVideo(VideoDto videoDto,) async {
    final response = await createVideoWithHttpInfo(videoDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'VideoDto',) as VideoDto;
    
    }
    return null;
  }

  /// Create a video
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [VideoDto] videoDto (required):
  ///   Video to create
  Future<Response> createVideo_1WithHttpInfo(VideoDto videoDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/toys';

    // ignore: prefer_final_locals
    Object? postBody = videoDto;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Create a video
  ///
  /// Parameters:
  ///
  /// * [VideoDto] videoDto (required):
  ///   Video to create
  Future<VideoDto?> createVideo_1(VideoDto videoDto,) async {
    final response = await createVideo_1WithHttpInfo(videoDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'VideoDto',) as VideoDto;
    
    }
    return null;
  }

  /// Delete an existing account
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] accountId (required):
  Future<Response> deleteAccountWithHttpInfo(int accountId,) async {
    // ignore: prefer_const_declarations
    final path = r'/accounts/{accountId}'
      .replaceAll('{accountId}', accountId.toString());

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'DELETE',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Delete an existing account
  ///
  /// Parameters:
  ///
  /// * [int] accountId (required):
  Future<void> deleteAccount(int accountId,) async {
    final response = await deleteAccountWithHttpInfo(accountId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Delete an existing blind box
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] blindBoxId (required):
  Future<Response> deleteBlindBoxWithHttpInfo(int blindBoxId,) async {
    // ignore: prefer_const_declarations
    final path = r'/blind-boxes/{blindBoxId}'
      .replaceAll('{blindBoxId}', blindBoxId.toString());

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'DELETE',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Delete an existing blind box
  ///
  /// Parameters:
  ///
  /// * [int] blindBoxId (required):
  Future<void> deleteBlindBox(int blindBoxId,) async {
    final response = await deleteBlindBoxWithHttpInfo(blindBoxId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Delete an existing brand
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] brandId (required):
  Future<Response> deleteBrandWithHttpInfo(int brandId,) async {
    // ignore: prefer_const_declarations
    final path = r'/brands/{brandId}'
      .replaceAll('{brandId}', brandId.toString());

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'DELETE',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Delete an existing brand
  ///
  /// Parameters:
  ///
  /// * [int] brandId (required):
  Future<void> deleteBrand(int brandId,) async {
    final response = await deleteBrandWithHttpInfo(brandId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Delete an existing image
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] imageId (required):
  Future<Response> deleteImageWithHttpInfo(String imageId,) async {
    // ignore: prefer_const_declarations
    final path = r'/images/{imageId}'
      .replaceAll('{imageId}', imageId);

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'DELETE',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Delete an existing image
  ///
  /// Parameters:
  ///
  /// * [String] imageId (required):
  Future<void> deleteImage(String imageId,) async {
    final response = await deleteImageWithHttpInfo(imageId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Delete an existing notification
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] notificationId (required):
  Future<Response> deleteNotificationWithHttpInfo(int notificationId,) async {
    // ignore: prefer_const_declarations
    final path = r'/notifications/{notificationId}'
      .replaceAll('{notificationId}', notificationId.toString());

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'DELETE',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Delete an existing notification
  ///
  /// Parameters:
  ///
  /// * [int] notificationId (required):
  Future<void> deleteNotification(int notificationId,) async {
    final response = await deleteNotificationWithHttpInfo(notificationId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Delete an existing order
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] orderId (required):
  Future<Response> deleteOrderWithHttpInfo(int orderId,) async {
    // ignore: prefer_const_declarations
    final path = r'/orders/{orderId}'
      .replaceAll('{orderId}', orderId.toString());

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'DELETE',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Delete an existing order
  ///
  /// Parameters:
  ///
  /// * [int] orderId (required):
  Future<void> deleteOrder(int orderId,) async {
    final response = await deleteOrderWithHttpInfo(orderId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Delete an existing order detail
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] orderDetailId (required):
  Future<Response> deleteOrderDetailWithHttpInfo(int orderDetailId,) async {
    // ignore: prefer_const_declarations
    final path = r'/order-details/{orderDetailId}'
      .replaceAll('{orderDetailId}', orderDetailId.toString());

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'DELETE',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Delete an existing order detail
  ///
  /// Parameters:
  ///
  /// * [int] orderDetailId (required):
  Future<void> deleteOrderDetail(int orderDetailId,) async {
    final response = await deleteOrderDetailWithHttpInfo(orderDetailId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Delete an existing pack
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] packId (required):
  Future<Response> deletePackWithHttpInfo(int packId,) async {
    // ignore: prefer_const_declarations
    final path = r'/packs/{packId}'
      .replaceAll('{packId}', packId.toString());

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'DELETE',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Delete an existing pack
  ///
  /// Parameters:
  ///
  /// * [int] packId (required):
  Future<void> deletePack(int packId,) async {
    final response = await deletePackWithHttpInfo(packId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Delete an existing promotional campaign
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] campaignId (required):
  Future<Response> deletePromotionalCampaignWithHttpInfo(int campaignId,) async {
    // ignore: prefer_const_declarations
    final path = r'/promotional-campaigns/{campaignId}'
      .replaceAll('{campaignId}', campaignId.toString());

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'DELETE',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Delete an existing promotional campaign
  ///
  /// Parameters:
  ///
  /// * [int] campaignId (required):
  Future<void> deletePromotionalCampaign(int campaignId,) async {
    final response = await deletePromotionalCampaignWithHttpInfo(campaignId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Delete an existing transaction
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] transactionId (required):
  Future<Response> deleteTransactionWithHttpInfo(int transactionId,) async {
    // ignore: prefer_const_declarations
    final path = r'/transactions/{transactionId}'
      .replaceAll('{transactionId}', transactionId.toString());

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'DELETE',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Delete an existing transaction
  ///
  /// Parameters:
  ///
  /// * [int] transactionId (required):
  Future<void> deleteTransaction(int transactionId,) async {
    final response = await deleteTransactionWithHttpInfo(transactionId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Delete an existing video
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] videoId (required):
  Future<Response> deleteVideoWithHttpInfo(int videoId,) async {
    // ignore: prefer_const_declarations
    final path = r'/videos/{videoId}'
      .replaceAll('{videoId}', videoId.toString());

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'DELETE',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Delete an existing video
  ///
  /// Parameters:
  ///
  /// * [int] videoId (required):
  Future<void> deleteVideo(int videoId,) async {
    final response = await deleteVideoWithHttpInfo(videoId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Delete an existing video
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] videoId (required):
  Future<Response> deleteVideo_2WithHttpInfo(int videoId,) async {
    // ignore: prefer_const_declarations
    final path = r'/toys/{toyId}'
      .replaceAll('{videoId}', videoId.toString());

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'DELETE',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Delete an existing video
  ///
  /// Parameters:
  ///
  /// * [int] videoId (required):
  Future<void> deleteVideo_2(int videoId,) async {
    final response = await deleteVideo_2WithHttpInfo(videoId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Forgot password
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [ForgotPasswordRequestDto] forgotPasswordRequestDto (required):
  Future<Response> forgotPasswordWithHttpInfo(ForgotPasswordRequestDto forgotPasswordRequestDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/auth/forgot-password';

    // ignore: prefer_final_locals
    Object? postBody = forgotPasswordRequestDto;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Forgot password
  ///
  /// Parameters:
  ///
  /// * [ForgotPasswordRequestDto] forgotPasswordRequestDto (required):
  Future<void> forgotPassword(ForgotPasswordRequestDto forgotPasswordRequestDto,) async {
    final response = await forgotPasswordWithHttpInfo(forgotPasswordRequestDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Get an account by ID
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] accountId (required):
  Future<Response> getAccountByIdWithHttpInfo(int accountId,) async {
    // ignore: prefer_const_declarations
    final path = r'/accounts/{accountId}'
      .replaceAll('{accountId}', accountId.toString());

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Get an account by ID
  ///
  /// Parameters:
  ///
  /// * [int] accountId (required):
  Future<AccountDto?> getAccountById(int accountId,) async {
    final response = await getAccountByIdWithHttpInfo(accountId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'AccountDto',) as AccountDto;
    
    }
    return null;
  }

  /// Get a list of accounts
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [Pageable] pageable:
  ///   Reusable pageable parameters
  ///
  /// * [String] filter:
  ///   A single filter in the format `field,operator,value` (e.g., `name,eq,John`)
  ///
  /// * [String] search:
  ///   A search query
  Future<Response> getAccountsWithHttpInfo({ Pageable? pageable, String? filter, String? search, }) async {
    // ignore: prefer_const_declarations
    final path = r'/accounts';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (pageable != null) {
      queryParams.addAll(_queryParams('', 'Pageable', pageable));
    }
    if (filter != null) {
      queryParams.addAll(_queryParams('', 'filter', filter));
    }
    if (search != null) {
      queryParams.addAll(_queryParams('', 'search', search));
    }

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Get a list of accounts
  ///
  /// Parameters:
  ///
  /// * [Pageable] pageable:
  ///   Reusable pageable parameters
  ///
  /// * [String] filter:
  ///   A single filter in the format `field,operator,value` (e.g., `name,eq,John`)
  ///
  /// * [String] search:
  ///   A search query
  Future<GetAccounts200Response?> getAccounts({ Pageable? pageable, String? filter, String? search, }) async {
    final response = await getAccountsWithHttpInfo( pageable: pageable, filter: filter, search: search, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'GetAccounts200Response',) as GetAccounts200Response;
    
    }
    return null;
  }

  /// Get a blind box by ID
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] blindBoxId (required):
  Future<Response> getBlindBoxByIdWithHttpInfo(int blindBoxId,) async {
    // ignore: prefer_const_declarations
    final path = r'/blind-boxes/{blindBoxId}'
      .replaceAll('{blindBoxId}', blindBoxId.toString());

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Get a blind box by ID
  ///
  /// Parameters:
  ///
  /// * [int] blindBoxId (required):
  Future<BlindBoxDto?> getBlindBoxById(int blindBoxId,) async {
    final response = await getBlindBoxByIdWithHttpInfo(blindBoxId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'BlindBoxDto',) as BlindBoxDto;
    
    }
    return null;
  }

  /// Get a list of blind boxes
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [Pageable] pageable:
  ///   Reusable pageable parameters
  ///
  /// * [String] filter:
  ///   A single filter in the format `field,operator,value` (e.g., `name,eq,John`)
  ///
  /// * [String] search:
  ///   A search query
  Future<Response> getBlindBoxesWithHttpInfo({ Pageable? pageable, String? filter, String? search, }) async {
    // ignore: prefer_const_declarations
    final path = r'/blind-boxes';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (pageable != null) {
      queryParams.addAll(_queryParams('', 'Pageable', pageable));
    }
    if (filter != null) {
      queryParams.addAll(_queryParams('', 'filter', filter));
    }
    if (search != null) {
      queryParams.addAll(_queryParams('', 'search', search));
    }

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Get a list of blind boxes
  ///
  /// Parameters:
  ///
  /// * [Pageable] pageable:
  ///   Reusable pageable parameters
  ///
  /// * [String] filter:
  ///   A single filter in the format `field,operator,value` (e.g., `name,eq,John`)
  ///
  /// * [String] search:
  ///   A search query
  Future<GetBlindBoxes200Response?> getBlindBoxes({ Pageable? pageable, String? filter, String? search, }) async {
    final response = await getBlindBoxesWithHttpInfo( pageable: pageable, filter: filter, search: search, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'GetBlindBoxes200Response',) as GetBlindBoxes200Response;
    
    }
    return null;
  }

  /// Get a brand by ID
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] brandId (required):
  Future<Response> getBrandByIdWithHttpInfo(int brandId,) async {
    // ignore: prefer_const_declarations
    final path = r'/brands/{brandId}'
      .replaceAll('{brandId}', brandId.toString());

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Get a brand by ID
  ///
  /// Parameters:
  ///
  /// * [int] brandId (required):
  Future<BrandDto?> getBrandById(int brandId,) async {
    final response = await getBrandByIdWithHttpInfo(brandId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'BrandDto',) as BrandDto;
    
    }
    return null;
  }

  /// Get a list of brands
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [Pageable] pageable:
  ///   Reusable pageable parameters
  ///
  /// * [String] filter:
  ///   A single filter in the format `field,operator,value` (e.g., `name,eq,John`)
  ///
  /// * [String] search:
  ///   A search query
  Future<Response> getBrandsWithHttpInfo({ Pageable? pageable, String? filter, String? search, }) async {
    // ignore: prefer_const_declarations
    final path = r'/brands';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (pageable != null) {
      queryParams.addAll(_queryParams('', 'Pageable', pageable));
    }
    if (filter != null) {
      queryParams.addAll(_queryParams('', 'filter', filter));
    }
    if (search != null) {
      queryParams.addAll(_queryParams('', 'search', search));
    }

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Get a list of brands
  ///
  /// Parameters:
  ///
  /// * [Pageable] pageable:
  ///   Reusable pageable parameters
  ///
  /// * [String] filter:
  ///   A single filter in the format `field,operator,value` (e.g., `name,eq,John`)
  ///
  /// * [String] search:
  ///   A search query
  Future<GetBrands200Response?> getBrands({ Pageable? pageable, String? filter, String? search, }) async {
    final response = await getBrandsWithHttpInfo( pageable: pageable, filter: filter, search: search, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'GetBrands200Response',) as GetBrands200Response;
    
    }
    return null;
  }

  /// Get current user information
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> getCurrentUserWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/auth/me';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Get current user information
  Future<AccountDto?> getCurrentUser() async {
    final response = await getCurrentUserWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'AccountDto',) as AccountDto;
    
    }
    return null;
  }

  /// Get an image by imageId
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] imageId (required):
  Future<Response> getImageByIdWithHttpInfo(String imageId,) async {
    // ignore: prefer_const_declarations
    final path = r'/images/{imageId}'
      .replaceAll('{imageId}', imageId);

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Get an image by imageId
  ///
  /// Parameters:
  ///
  /// * [String] imageId (required):
  Future<ImageDto?> getImageById(String imageId,) async {
    final response = await getImageByIdWithHttpInfo(imageId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ImageDto',) as ImageDto;
    
    }
    return null;
  }

  /// Get a list of images
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [Pageable] pageable:
  ///   Reusable pageable parameters
  ///
  /// * [String] filter:
  ///   A single filter in the format `field,operator,value` (e.g., `name,eq,John`)
  ///
  /// * [String] search:
  ///   A search query
  Future<Response> getImagesWithHttpInfo({ Pageable? pageable, String? filter, String? search, }) async {
    // ignore: prefer_const_declarations
    final path = r'/images';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (pageable != null) {
      queryParams.addAll(_queryParams('', 'Pageable', pageable));
    }
    if (filter != null) {
      queryParams.addAll(_queryParams('', 'filter', filter));
    }
    if (search != null) {
      queryParams.addAll(_queryParams('', 'search', search));
    }

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Get a list of images
  ///
  /// Parameters:
  ///
  /// * [Pageable] pageable:
  ///   Reusable pageable parameters
  ///
  /// * [String] filter:
  ///   A single filter in the format `field,operator,value` (e.g., `name,eq,John`)
  ///
  /// * [String] search:
  ///   A search query
  Future<GetImages200Response?> getImages({ Pageable? pageable, String? filter, String? search, }) async {
    final response = await getImagesWithHttpInfo( pageable: pageable, filter: filter, search: search, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'GetImages200Response',) as GetImages200Response;
    
    }
    return null;
  }

  /// Get a notification by notificationId
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] notificationId (required):
  Future<Response> getNotificationByIdWithHttpInfo(int notificationId,) async {
    // ignore: prefer_const_declarations
    final path = r'/notifications/{notificationId}'
      .replaceAll('{notificationId}', notificationId.toString());

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Get a notification by notificationId
  ///
  /// Parameters:
  ///
  /// * [int] notificationId (required):
  Future<NotificationDto?> getNotificationById(int notificationId,) async {
    final response = await getNotificationByIdWithHttpInfo(notificationId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'NotificationDto',) as NotificationDto;
    
    }
    return null;
  }

  /// Get a list of notifications
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [Pageable] pageable:
  ///   Reusable pageable parameters
  ///
  /// * [String] filter:
  ///   A single filter in the format `field,operator,value` (e.g., `name,eq,John`)
  ///
  /// * [String] search:
  ///   A search query
  Future<Response> getNotificationsWithHttpInfo({ Pageable? pageable, String? filter, String? search, }) async {
    // ignore: prefer_const_declarations
    final path = r'/notifications';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (pageable != null) {
      queryParams.addAll(_queryParams('', 'Pageable', pageable));
    }
    if (filter != null) {
      queryParams.addAll(_queryParams('', 'filter', filter));
    }
    if (search != null) {
      queryParams.addAll(_queryParams('', 'search', search));
    }

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Get a list of notifications
  ///
  /// Parameters:
  ///
  /// * [Pageable] pageable:
  ///   Reusable pageable parameters
  ///
  /// * [String] filter:
  ///   A single filter in the format `field,operator,value` (e.g., `name,eq,John`)
  ///
  /// * [String] search:
  ///   A search query
  Future<GetNotifications200Response?> getNotifications({ Pageable? pageable, String? filter, String? search, }) async {
    final response = await getNotificationsWithHttpInfo( pageable: pageable, filter: filter, search: search, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'GetNotifications200Response',) as GetNotifications200Response;
    
    }
    return null;
  }

  /// Get an order by orderId
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] orderId (required):
  Future<Response> getOrderByIdWithHttpInfo(int orderId,) async {
    // ignore: prefer_const_declarations
    final path = r'/orders/{orderId}'
      .replaceAll('{orderId}', orderId.toString());

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Get an order by orderId
  ///
  /// Parameters:
  ///
  /// * [int] orderId (required):
  Future<OrderDto?> getOrderById(int orderId,) async {
    final response = await getOrderByIdWithHttpInfo(orderId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'OrderDto',) as OrderDto;
    
    }
    return null;
  }

  /// Get an order detail by orderDetailId
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] orderDetailId (required):
  Future<Response> getOrderDetailByIdWithHttpInfo(int orderDetailId,) async {
    // ignore: prefer_const_declarations
    final path = r'/order-details/{orderDetailId}'
      .replaceAll('{orderDetailId}', orderDetailId.toString());

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Get an order detail by orderDetailId
  ///
  /// Parameters:
  ///
  /// * [int] orderDetailId (required):
  Future<OrderDetailDto?> getOrderDetailById(int orderDetailId,) async {
    final response = await getOrderDetailByIdWithHttpInfo(orderDetailId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'OrderDetailDto',) as OrderDetailDto;
    
    }
    return null;
  }

  /// Get a list of order details
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [Pageable] pageable:
  ///   Reusable pageable parameters
  ///
  /// * [String] filter:
  ///   A single filter in the format `field,operator,value` (e.g., `name,eq,John`)
  ///
  /// * [String] search:
  ///   A search query
  Future<Response> getOrderDetailsWithHttpInfo({ Pageable? pageable, String? filter, String? search, }) async {
    // ignore: prefer_const_declarations
    final path = r'/order-details';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (pageable != null) {
      queryParams.addAll(_queryParams('', 'Pageable', pageable));
    }
    if (filter != null) {
      queryParams.addAll(_queryParams('', 'filter', filter));
    }
    if (search != null) {
      queryParams.addAll(_queryParams('', 'search', search));
    }

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Get a list of order details
  ///
  /// Parameters:
  ///
  /// * [Pageable] pageable:
  ///   Reusable pageable parameters
  ///
  /// * [String] filter:
  ///   A single filter in the format `field,operator,value` (e.g., `name,eq,John`)
  ///
  /// * [String] search:
  ///   A search query
  Future<GetOrderDetails200Response?> getOrderDetails({ Pageable? pageable, String? filter, String? search, }) async {
    final response = await getOrderDetailsWithHttpInfo( pageable: pageable, filter: filter, search: search, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'GetOrderDetails200Response',) as GetOrderDetails200Response;
    
    }
    return null;
  }

  /// Get a list of orders
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [Pageable] pageable:
  ///   Reusable pageable parameters
  ///
  /// * [String] filter:
  ///   A single filter in the format `field,operator,value` (e.g., `name,eq,John`)
  ///
  /// * [String] search:
  ///   A search query
  Future<Response> getOrdersWithHttpInfo({ Pageable? pageable, String? filter, String? search, }) async {
    // ignore: prefer_const_declarations
    final path = r'/orders';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (pageable != null) {
      queryParams.addAll(_queryParams('', 'Pageable', pageable));
    }
    if (filter != null) {
      queryParams.addAll(_queryParams('', 'filter', filter));
    }
    if (search != null) {
      queryParams.addAll(_queryParams('', 'search', search));
    }

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Get a list of orders
  ///
  /// Parameters:
  ///
  /// * [Pageable] pageable:
  ///   Reusable pageable parameters
  ///
  /// * [String] filter:
  ///   A single filter in the format `field,operator,value` (e.g., `name,eq,John`)
  ///
  /// * [String] search:
  ///   A search query
  Future<GetOrders200Response?> getOrders({ Pageable? pageable, String? filter, String? search, }) async {
    final response = await getOrdersWithHttpInfo( pageable: pageable, filter: filter, search: search, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'GetOrders200Response',) as GetOrders200Response;
    
    }
    return null;
  }

  /// Get a pack by packId
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] packId (required):
  Future<Response> getPackByIdWithHttpInfo(int packId,) async {
    // ignore: prefer_const_declarations
    final path = r'/packs/{packId}'
      .replaceAll('{packId}', packId.toString());

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Get a pack by packId
  ///
  /// Parameters:
  ///
  /// * [int] packId (required):
  Future<PackDto?> getPackById(int packId,) async {
    final response = await getPackByIdWithHttpInfo(packId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'PackDto',) as PackDto;
    
    }
    return null;
  }

  /// Get a list of packs
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [Pageable] pageable:
  ///   Reusable pageable parameters
  ///
  /// * [String] filter:
  ///   A single filter in the format `field,operator,value` (e.g., `name,eq,John`)
  ///
  /// * [String] search:
  ///   A search query
  Future<Response> getPacksWithHttpInfo({ Pageable? pageable, String? filter, String? search, }) async {
    // ignore: prefer_const_declarations
    final path = r'/packs';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (pageable != null) {
      queryParams.addAll(_queryParams('', 'Pageable', pageable));
    }
    if (filter != null) {
      queryParams.addAll(_queryParams('', 'filter', filter));
    }
    if (search != null) {
      queryParams.addAll(_queryParams('', 'search', search));
    }

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Get a list of packs
  ///
  /// Parameters:
  ///
  /// * [Pageable] pageable:
  ///   Reusable pageable parameters
  ///
  /// * [String] filter:
  ///   A single filter in the format `field,operator,value` (e.g., `name,eq,John`)
  ///
  /// * [String] search:
  ///   A search query
  Future<GetPacks200Response?> getPacks({ Pageable? pageable, String? filter, String? search, }) async {
    final response = await getPacksWithHttpInfo( pageable: pageable, filter: filter, search: search, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'GetPacks200Response',) as GetPacks200Response;
    
    }
    return null;
  }

  /// Get a promotional campaign by campaignId
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] campaignId (required):
  Future<Response> getPromotionalCampaignByIdWithHttpInfo(int campaignId,) async {
    // ignore: prefer_const_declarations
    final path = r'/promotional-campaigns/{campaignId}'
      .replaceAll('{campaignId}', campaignId.toString());

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Get a promotional campaign by campaignId
  ///
  /// Parameters:
  ///
  /// * [int] campaignId (required):
  Future<PromotionalCampaignDto?> getPromotionalCampaignById(int campaignId,) async {
    final response = await getPromotionalCampaignByIdWithHttpInfo(campaignId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'PromotionalCampaignDto',) as PromotionalCampaignDto;
    
    }
    return null;
  }

  /// Get a list of promotional campaigns
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [Pageable] pageable:
  ///   Reusable pageable parameters
  ///
  /// * [String] filter:
  ///   A single filter in the format `field,operator,value` (e.g., `name,eq,John`)
  ///
  /// * [String] search:
  ///   A search query
  Future<Response> getPromotionalCampaignsWithHttpInfo({ Pageable? pageable, String? filter, String? search, }) async {
    // ignore: prefer_const_declarations
    final path = r'/promotional-campaigns';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (pageable != null) {
      queryParams.addAll(_queryParams('', 'Pageable', pageable));
    }
    if (filter != null) {
      queryParams.addAll(_queryParams('', 'filter', filter));
    }
    if (search != null) {
      queryParams.addAll(_queryParams('', 'search', search));
    }

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Get a list of promotional campaigns
  ///
  /// Parameters:
  ///
  /// * [Pageable] pageable:
  ///   Reusable pageable parameters
  ///
  /// * [String] filter:
  ///   A single filter in the format `field,operator,value` (e.g., `name,eq,John`)
  ///
  /// * [String] search:
  ///   A search query
  Future<GetPromotionalCampaigns200Response?> getPromotionalCampaigns({ Pageable? pageable, String? filter, String? search, }) async {
    final response = await getPromotionalCampaignsWithHttpInfo( pageable: pageable, filter: filter, search: search, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'GetPromotionalCampaigns200Response',) as GetPromotionalCampaigns200Response;
    
    }
    return null;
  }

  /// Get a transaction by transactionId
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] transactionId (required):
  Future<Response> getTransactionByIdWithHttpInfo(int transactionId,) async {
    // ignore: prefer_const_declarations
    final path = r'/transactions/{transactionId}'
      .replaceAll('{transactionId}', transactionId.toString());

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Get a transaction by transactionId
  ///
  /// Parameters:
  ///
  /// * [int] transactionId (required):
  Future<TransactionDto?> getTransactionById(int transactionId,) async {
    final response = await getTransactionByIdWithHttpInfo(transactionId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'TransactionDto',) as TransactionDto;
    
    }
    return null;
  }

  /// Get a list of transactions
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [Pageable] pageable:
  ///   Reusable pageable parameters
  ///
  /// * [String] filter:
  ///   A single filter in the format `field,operator,value` (e.g., `name,eq,John`)
  ///
  /// * [String] search:
  ///   A search query
  Future<Response> getTransactionsWithHttpInfo({ Pageable? pageable, String? filter, String? search, }) async {
    // ignore: prefer_const_declarations
    final path = r'/transactions';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (pageable != null) {
      queryParams.addAll(_queryParams('', 'Pageable', pageable));
    }
    if (filter != null) {
      queryParams.addAll(_queryParams('', 'filter', filter));
    }
    if (search != null) {
      queryParams.addAll(_queryParams('', 'search', search));
    }

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Get a list of transactions
  ///
  /// Parameters:
  ///
  /// * [Pageable] pageable:
  ///   Reusable pageable parameters
  ///
  /// * [String] filter:
  ///   A single filter in the format `field,operator,value` (e.g., `name,eq,John`)
  ///
  /// * [String] search:
  ///   A search query
  Future<GetTransactions200Response?> getTransactions({ Pageable? pageable, String? filter, String? search, }) async {
    final response = await getTransactionsWithHttpInfo( pageable: pageable, filter: filter, search: search, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'GetTransactions200Response',) as GetTransactions200Response;
    
    }
    return null;
  }

  /// Get a video by videoId
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] videoId (required):
  Future<Response> getVideoByIdWithHttpInfo(int videoId,) async {
    // ignore: prefer_const_declarations
    final path = r'/videos/{videoId}'
      .replaceAll('{videoId}', videoId.toString());

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Get a video by videoId
  ///
  /// Parameters:
  ///
  /// * [int] videoId (required):
  Future<VideoDto?> getVideoById(int videoId,) async {
    final response = await getVideoByIdWithHttpInfo(videoId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'VideoDto',) as VideoDto;
    
    }
    return null;
  }

  /// Get a video by videoId
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] videoId (required):
  Future<Response> getVideoById_3WithHttpInfo(int videoId,) async {
    // ignore: prefer_const_declarations
    final path = r'/toys/{toyId}'
      .replaceAll('{videoId}', videoId.toString());

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Get a video by videoId
  ///
  /// Parameters:
  ///
  /// * [int] videoId (required):
  Future<VideoDto?> getVideoById_3(int videoId,) async {
    final response = await getVideoById_3WithHttpInfo(videoId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'VideoDto',) as VideoDto;
    
    }
    return null;
  }

  /// Get a list of videos
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [Pageable] pageable:
  ///   Reusable pageable parameters
  ///
  /// * [String] filter:
  ///   A single filter in the format `field,operator,value` (e.g., `name,eq,John`)
  ///
  /// * [String] search:
  ///   A search query
  Future<Response> getVideosWithHttpInfo({ Pageable? pageable, String? filter, String? search, }) async {
    // ignore: prefer_const_declarations
    final path = r'/videos';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (pageable != null) {
      queryParams.addAll(_queryParams('', 'Pageable', pageable));
    }
    if (filter != null) {
      queryParams.addAll(_queryParams('', 'filter', filter));
    }
    if (search != null) {
      queryParams.addAll(_queryParams('', 'search', search));
    }

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Get a list of videos
  ///
  /// Parameters:
  ///
  /// * [Pageable] pageable:
  ///   Reusable pageable parameters
  ///
  /// * [String] filter:
  ///   A single filter in the format `field,operator,value` (e.g., `name,eq,John`)
  ///
  /// * [String] search:
  ///   A search query
  Future<GetVideos200Response?> getVideos({ Pageable? pageable, String? filter, String? search, }) async {
    final response = await getVideosWithHttpInfo( pageable: pageable, filter: filter, search: search, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'GetVideos200Response',) as GetVideos200Response;
    
    }
    return null;
  }

  /// Get a list of videos
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [Pageable] pageable:
  ///   Reusable pageable parameters
  ///
  /// * [String] filter:
  ///   A single filter in the format `field,operator,value` (e.g., `name,eq,John`)
  ///
  /// * [String] search:
  ///   A search query
  Future<Response> getVideos_4WithHttpInfo({ Pageable? pageable, String? filter, String? search, }) async {
    // ignore: prefer_const_declarations
    final path = r'/toys';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (pageable != null) {
      queryParams.addAll(_queryParams('', 'Pageable', pageable));
    }
    if (filter != null) {
      queryParams.addAll(_queryParams('', 'filter', filter));
    }
    if (search != null) {
      queryParams.addAll(_queryParams('', 'search', search));
    }

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Get a list of videos
  ///
  /// Parameters:
  ///
  /// * [Pageable] pageable:
  ///   Reusable pageable parameters
  ///
  /// * [String] filter:
  ///   A single filter in the format `field,operator,value` (e.g., `name,eq,John`)
  ///
  /// * [String] search:
  ///   A search query
  Future<GetVideos200Response?> getVideos_4({ Pageable? pageable, String? filter, String? search, }) async {
    final response = await getVideos_4WithHttpInfo( pageable: pageable, filter: filter, search: search, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'GetVideos200Response',) as GetVideos200Response;
    
    }
    return null;
  }

  /// Login to an account
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [LoginRequestDto] loginRequestDto (required):
  Future<Response> loginWithHttpInfo(LoginRequestDto loginRequestDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/auth/login';

    // ignore: prefer_final_locals
    Object? postBody = loginRequestDto;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Login to an account
  ///
  /// Parameters:
  ///
  /// * [LoginRequestDto] loginRequestDto (required):
  Future<AuthResponseDto?> login(LoginRequestDto loginRequestDto,) async {
    final response = await loginWithHttpInfo(loginRequestDto,);
    print("API response: $response");
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'AuthResponseDto',) as AuthResponseDto;
    
    }
    return null;
  }

  /// Login with Google
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] body (required):
  Future<Response> loginWithGoogleWithHttpInfo(String body,) async {
    // ignore: prefer_const_declarations
    final path = r'/auth/login-with-google';

    // ignore: prefer_final_locals
    Object? postBody = body;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Login with Google
  ///
  /// Parameters:
  ///
  /// * [String] body (required):
  Future<AuthResponseDto?> loginWithGoogle(String body,) async {
    final response = await loginWithGoogleWithHttpInfo(body,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'AuthResponseDto',) as AuthResponseDto;
    
    }
    return null;
  }

  /// Logout from the account
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> logoutWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/auth/logout';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Logout from the account
  Future<void> logout() async {
    final response = await logoutWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Refresh access token
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] body (required):
  Future<Response> refreshTokenWithHttpInfo(String body,) async {
    // ignore: prefer_const_declarations
    final path = r'/auth/refresh-token';

    // ignore: prefer_final_locals
    Object? postBody = body;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Refresh access token
  ///
  /// Parameters:
  ///
  /// * [String] body (required):
  Future<JwtResponseDto?> refreshToken(String body,) async {
    final response = await refreshTokenWithHttpInfo(body,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'JwtResponseDto',) as JwtResponseDto;
    
    }
    return null;
  }

  /// Register a new account
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [RegisterRequestDto] registerRequestDto (required):
  Future<Response> registerWithHttpInfo(RegisterRequestDto registerRequestDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/auth/register';

    // ignore: prefer_final_locals
    Object? postBody = registerRequestDto;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Register a new account
  ///
  /// Parameters:
  ///
  /// * [RegisterRequestDto] registerRequestDto (required):
  Future<void> register(RegisterRequestDto registerRequestDto,) async {
    final response = await registerWithHttpInfo(registerRequestDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Reset password
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [ResetPasswordRequestDto] resetPasswordRequestDto (required):
  Future<Response> resetPasswordWithHttpInfo(ResetPasswordRequestDto resetPasswordRequestDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/auth/reset-password';

    // ignore: prefer_final_locals
    Object? postBody = resetPasswordRequestDto;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Reset password
  ///
  /// Parameters:
  ///
  /// * [ResetPasswordRequestDto] resetPasswordRequestDto (required):
  Future<void> resetPassword(ResetPasswordRequestDto resetPasswordRequestDto,) async {
    final response = await resetPasswordWithHttpInfo(resetPasswordRequestDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Update an existing account
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] accountId (required):
  ///
  /// * [AccountDto] accountDto (required):
  ///   Account to update
  Future<Response> updateAccountWithHttpInfo(int accountId, AccountDto accountDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/accounts/{accountId}'
      .replaceAll('{accountId}', accountId.toString());

    // ignore: prefer_final_locals
    Object? postBody = accountDto;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'PUT',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Update an existing account
  ///
  /// Parameters:
  ///
  /// * [int] accountId (required):
  ///
  /// * [AccountDto] accountDto (required):
  ///   Account to update
  Future<AccountDto?> updateAccount(int accountId, AccountDto accountDto,) async {
    final response = await updateAccountWithHttpInfo(accountId, accountDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'AccountDto',) as AccountDto;
    
    }
    return null;
  }

  /// Update an existing blind box
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] blindBoxId (required):
  ///
  /// * [BlindBoxDto] blindBoxDto (required):
  ///   BlindBox to update
  Future<Response> updateBlindBoxWithHttpInfo(int blindBoxId, BlindBoxDto blindBoxDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/blind-boxes/{blindBoxId}'
      .replaceAll('{blindBoxId}', blindBoxId.toString());

    // ignore: prefer_final_locals
    Object? postBody = blindBoxDto;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'PUT',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Update an existing blind box
  ///
  /// Parameters:
  ///
  /// * [int] blindBoxId (required):
  ///
  /// * [BlindBoxDto] blindBoxDto (required):
  ///   BlindBox to update
  Future<BlindBoxDto?> updateBlindBox(int blindBoxId, BlindBoxDto blindBoxDto,) async {
    final response = await updateBlindBoxWithHttpInfo(blindBoxId, blindBoxDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'BlindBoxDto',) as BlindBoxDto;
    
    }
    return null;
  }

  /// Update an existing brand
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] brandId (required):
  ///
  /// * [BrandDto] brandDto (required):
  ///   Brand to update
  Future<Response> updateBrandWithHttpInfo(int brandId, BrandDto brandDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/brands/{brandId}'
      .replaceAll('{brandId}', brandId.toString());

    // ignore: prefer_final_locals
    Object? postBody = brandDto;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'PUT',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Update an existing brand
  ///
  /// Parameters:
  ///
  /// * [int] brandId (required):
  ///
  /// * [BrandDto] brandDto (required):
  ///   Brand to update
  Future<BrandDto?> updateBrand(int brandId, BrandDto brandDto,) async {
    final response = await updateBrandWithHttpInfo(brandId, brandDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'BrandDto',) as BrandDto;
    
    }
    return null;
  }

  /// Update an existing image
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] imageId (required):
  ///
  /// * [ImageDto] imageDto (required):
  ///   Image to update
  Future<Response> updateImageWithHttpInfo(String imageId, ImageDto imageDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/images/{imageId}'
      .replaceAll('{imageId}', imageId);

    // ignore: prefer_final_locals
    Object? postBody = imageDto;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'PUT',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Update an existing image
  ///
  /// Parameters:
  ///
  /// * [String] imageId (required):
  ///
  /// * [ImageDto] imageDto (required):
  ///   Image to update
  Future<ImageDto?> updateImage(String imageId, ImageDto imageDto,) async {
    final response = await updateImageWithHttpInfo(imageId, imageDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ImageDto',) as ImageDto;
    
    }
    return null;
  }

  /// Update an existing notification
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] notificationId (required):
  ///
  /// * [NotificationDto] notificationDto (required):
  ///   Notification to update
  Future<Response> updateNotificationWithHttpInfo(int notificationId, NotificationDto notificationDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/notifications/{notificationId}'
      .replaceAll('{notificationId}', notificationId.toString());

    // ignore: prefer_final_locals
    Object? postBody = notificationDto;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'PUT',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Update an existing notification
  ///
  /// Parameters:
  ///
  /// * [int] notificationId (required):
  ///
  /// * [NotificationDto] notificationDto (required):
  ///   Notification to update
  Future<NotificationDto?> updateNotification(int notificationId, NotificationDto notificationDto,) async {
    final response = await updateNotificationWithHttpInfo(notificationId, notificationDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'NotificationDto',) as NotificationDto;
    
    }
    return null;
  }

  /// Update an existing order
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] orderId (required):
  ///
  /// * [OrderDto] orderDto (required):
  ///   Order to update
  Future<Response> updateOrderWithHttpInfo(int orderId, OrderDto orderDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/orders/{orderId}'
      .replaceAll('{orderId}', orderId.toString());

    // ignore: prefer_final_locals
    Object? postBody = orderDto;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'PUT',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Update an existing order
  ///
  /// Parameters:
  ///
  /// * [int] orderId (required):
  ///
  /// * [OrderDto] orderDto (required):
  ///   Order to update
  Future<OrderDto?> updateOrder(int orderId, OrderDto orderDto,) async {
    final response = await updateOrderWithHttpInfo(orderId, orderDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'OrderDto',) as OrderDto;
    
    }
    return null;
  }

  /// Update an existing order detail
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] orderDetailId (required):
  ///
  /// * [OrderDetailDto] orderDetailDto (required):
  ///   OrderDetail to update
  Future<Response> updateOrderDetailWithHttpInfo(int orderDetailId, OrderDetailDto orderDetailDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/order-details/{orderDetailId}'
      .replaceAll('{orderDetailId}', orderDetailId.toString());

    // ignore: prefer_final_locals
    Object? postBody = orderDetailDto;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'PUT',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Update an existing order detail
  ///
  /// Parameters:
  ///
  /// * [int] orderDetailId (required):
  ///
  /// * [OrderDetailDto] orderDetailDto (required):
  ///   OrderDetail to update
  Future<OrderDetailDto?> updateOrderDetail(int orderDetailId, OrderDetailDto orderDetailDto,) async {
    final response = await updateOrderDetailWithHttpInfo(orderDetailId, orderDetailDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'OrderDetailDto',) as OrderDetailDto;
    
    }
    return null;
  }

  /// Update an existing pack
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] packId (required):
  ///
  /// * [PackDto] packDto (required):
  ///   Pack to update
  Future<Response> updatePackWithHttpInfo(int packId, PackDto packDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/packs/{packId}'
      .replaceAll('{packId}', packId.toString());

    // ignore: prefer_final_locals
    Object? postBody = packDto;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'PUT',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Update an existing pack
  ///
  /// Parameters:
  ///
  /// * [int] packId (required):
  ///
  /// * [PackDto] packDto (required):
  ///   Pack to update
  Future<PackDto?> updatePack(int packId, PackDto packDto,) async {
    final response = await updatePackWithHttpInfo(packId, packDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'PackDto',) as PackDto;
    
    }
    return null;
  }

  /// Update an existing promotional campaign
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] campaignId (required):
  ///
  /// * [PromotionalCampaignDto] promotionalCampaignDto (required):
  ///   PromotionalCampaign to update
  Future<Response> updatePromotionalCampaignWithHttpInfo(int campaignId, PromotionalCampaignDto promotionalCampaignDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/promotional-campaigns/{campaignId}'
      .replaceAll('{campaignId}', campaignId.toString());

    // ignore: prefer_final_locals
    Object? postBody = promotionalCampaignDto;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'PUT',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Update an existing promotional campaign
  ///
  /// Parameters:
  ///
  /// * [int] campaignId (required):
  ///
  /// * [PromotionalCampaignDto] promotionalCampaignDto (required):
  ///   PromotionalCampaign to update
  Future<PromotionalCampaignDto?> updatePromotionalCampaign(int campaignId, PromotionalCampaignDto promotionalCampaignDto,) async {
    final response = await updatePromotionalCampaignWithHttpInfo(campaignId, promotionalCampaignDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'PromotionalCampaignDto',) as PromotionalCampaignDto;
    
    }
    return null;
  }

  /// Update an existing transaction
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] transactionId (required):
  ///
  /// * [TransactionDto] transactionDto (required):
  ///   Transaction to update
  Future<Response> updateTransactionWithHttpInfo(int transactionId, TransactionDto transactionDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/transactions/{transactionId}'
      .replaceAll('{transactionId}', transactionId.toString());

    // ignore: prefer_final_locals
    Object? postBody = transactionDto;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'PUT',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Update an existing transaction
  ///
  /// Parameters:
  ///
  /// * [int] transactionId (required):
  ///
  /// * [TransactionDto] transactionDto (required):
  ///   Transaction to update
  Future<TransactionDto?> updateTransaction(int transactionId, TransactionDto transactionDto,) async {
    final response = await updateTransactionWithHttpInfo(transactionId, transactionDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'TransactionDto',) as TransactionDto;
    
    }
    return null;
  }

  /// Update an existing video
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] videoId (required):
  ///
  /// * [VideoDto] videoDto (required):
  ///   Video to update
  Future<Response> updateVideoWithHttpInfo(int videoId, VideoDto videoDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/videos/{videoId}'
      .replaceAll('{videoId}', videoId.toString());

    // ignore: prefer_final_locals
    Object? postBody = videoDto;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'PUT',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Update an existing video
  ///
  /// Parameters:
  ///
  /// * [int] videoId (required):
  ///
  /// * [VideoDto] videoDto (required):
  ///   Video to update
  Future<VideoDto?> updateVideo(int videoId, VideoDto videoDto,) async {
    final response = await updateVideoWithHttpInfo(videoId, videoDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'VideoDto',) as VideoDto;
    
    }
    return null;
  }

  /// Update an existing video
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] videoId (required):
  ///
  /// * [VideoDto] videoDto (required):
  ///   Video to update
  Future<Response> updateVideo_5WithHttpInfo(int videoId, VideoDto videoDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/toys/{toyId}'
      .replaceAll('{videoId}', videoId.toString());

    // ignore: prefer_final_locals
    Object? postBody = videoDto;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'PUT',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Update an existing video
  ///
  /// Parameters:
  ///
  /// * [int] videoId (required):
  ///
  /// * [VideoDto] videoDto (required):
  ///   Video to update
  Future<VideoDto?> updateVideo_5(int videoId, VideoDto videoDto,) async {
    final response = await updateVideo_5WithHttpInfo(videoId, videoDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'VideoDto',) as VideoDto;
    
    }
    return null;
  }
}
