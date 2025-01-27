# openapi.api.DefaultApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost:8080/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**createAccount**](DefaultApi.md#createaccount) | **POST** /accounts | Create an account
[**createBlindBox**](DefaultApi.md#createblindbox) | **POST** /blind-boxes | Create a blind box
[**createBrand**](DefaultApi.md#createbrand) | **POST** /brands | Create a brand
[**createImage**](DefaultApi.md#createimage) | **POST** /images | Create an image
[**createNotification**](DefaultApi.md#createnotification) | **POST** /notifications | Create a notification
[**createOrder**](DefaultApi.md#createorder) | **POST** /orders | Create an order
[**createOrderDetail**](DefaultApi.md#createorderdetail) | **POST** /order-details | Create an order detail
[**createPack**](DefaultApi.md#createpack) | **POST** /packs | Create a pack
[**createPromotionalCampaign**](DefaultApi.md#createpromotionalcampaign) | **POST** /promotional-campaigns | Create a promotional campaign
[**createTransaction**](DefaultApi.md#createtransaction) | **POST** /transactions | Create a transaction
[**createVideo**](DefaultApi.md#createvideo) | **POST** /videos | Create a video
[**createVideo_0**](DefaultApi.md#createvideo_0) | **POST** /toys | Create a video
[**deleteAccount**](DefaultApi.md#deleteaccount) | **DELETE** /accounts/{accountId} | Delete an existing account
[**deleteBlindBox**](DefaultApi.md#deleteblindbox) | **DELETE** /blind-boxes/{blindBoxId} | Delete an existing blind box
[**deleteBrand**](DefaultApi.md#deletebrand) | **DELETE** /brands/{brandId} | Delete an existing brand
[**deleteImage**](DefaultApi.md#deleteimage) | **DELETE** /images/{imageId} | Delete an existing image
[**deleteNotification**](DefaultApi.md#deletenotification) | **DELETE** /notifications/{notificationId} | Delete an existing notification
[**deleteOrder**](DefaultApi.md#deleteorder) | **DELETE** /orders/{orderId} | Delete an existing order
[**deleteOrderDetail**](DefaultApi.md#deleteorderdetail) | **DELETE** /order-details/{orderDetailId} | Delete an existing order detail
[**deletePack**](DefaultApi.md#deletepack) | **DELETE** /packs/{packId} | Delete an existing pack
[**deletePromotionalCampaign**](DefaultApi.md#deletepromotionalcampaign) | **DELETE** /promotional-campaigns/{campaignId} | Delete an existing promotional campaign
[**deleteTransaction**](DefaultApi.md#deletetransaction) | **DELETE** /transactions/{transactionId} | Delete an existing transaction
[**deleteVideo**](DefaultApi.md#deletevideo) | **DELETE** /videos/{videoId} | Delete an existing video
[**deleteVideo_0**](DefaultApi.md#deletevideo_0) | **DELETE** /toys/{toyId} | Delete an existing video
[**forgotPassword**](DefaultApi.md#forgotpassword) | **POST** /auth/forgot-password | Forgot password
[**getAccountById**](DefaultApi.md#getaccountbyid) | **GET** /accounts/{accountId} | Get an account by ID
[**getAccounts**](DefaultApi.md#getaccounts) | **GET** /accounts | Get a list of accounts
[**getBlindBoxById**](DefaultApi.md#getblindboxbyid) | **GET** /blind-boxes/{blindBoxId} | Get a blind box by ID
[**getBlindBoxes**](DefaultApi.md#getblindboxes) | **GET** /blind-boxes | Get a list of blind boxes
[**getBrandById**](DefaultApi.md#getbrandbyid) | **GET** /brands/{brandId} | Get a brand by ID
[**getBrands**](DefaultApi.md#getbrands) | **GET** /brands | Get a list of brands
[**getCurrentUser**](DefaultApi.md#getcurrentuser) | **GET** /auth/me | Get current user information
[**getImageById**](DefaultApi.md#getimagebyid) | **GET** /images/{imageId} | Get an image by imageId
[**getImages**](DefaultApi.md#getimages) | **GET** /images | Get a list of images
[**getNotificationById**](DefaultApi.md#getnotificationbyid) | **GET** /notifications/{notificationId} | Get a notification by notificationId
[**getNotifications**](DefaultApi.md#getnotifications) | **GET** /notifications | Get a list of notifications
[**getOrderById**](DefaultApi.md#getorderbyid) | **GET** /orders/{orderId} | Get an order by orderId
[**getOrderDetailById**](DefaultApi.md#getorderdetailbyid) | **GET** /order-details/{orderDetailId} | Get an order detail by orderDetailId
[**getOrderDetails**](DefaultApi.md#getorderdetails) | **GET** /order-details | Get a list of order details
[**getOrders**](DefaultApi.md#getorders) | **GET** /orders | Get a list of orders
[**getPackById**](DefaultApi.md#getpackbyid) | **GET** /packs/{packId} | Get a pack by packId
[**getPacks**](DefaultApi.md#getpacks) | **GET** /packs | Get a list of packs
[**getPromotionalCampaignById**](DefaultApi.md#getpromotionalcampaignbyid) | **GET** /promotional-campaigns/{campaignId} | Get a promotional campaign by campaignId
[**getPromotionalCampaigns**](DefaultApi.md#getpromotionalcampaigns) | **GET** /promotional-campaigns | Get a list of promotional campaigns
[**getTransactionById**](DefaultApi.md#gettransactionbyid) | **GET** /transactions/{transactionId} | Get a transaction by transactionId
[**getTransactions**](DefaultApi.md#gettransactions) | **GET** /transactions | Get a list of transactions
[**getVideoById**](DefaultApi.md#getvideobyid) | **GET** /videos/{videoId} | Get a video by videoId
[**getVideoById_0**](DefaultApi.md#getvideobyid_0) | **GET** /toys/{toyId} | Get a video by videoId
[**getVideos**](DefaultApi.md#getvideos) | **GET** /videos | Get a list of videos
[**getVideos_0**](DefaultApi.md#getvideos_0) | **GET** /toys | Get a list of videos
[**login**](DefaultApi.md#login) | **POST** /auth/login | Login to an account
[**loginWithGoogle**](DefaultApi.md#loginwithgoogle) | **POST** /auth/login-with-google | Login with Google
[**logout**](DefaultApi.md#logout) | **GET** /auth/logout | Logout from the account
[**refreshToken**](DefaultApi.md#refreshtoken) | **POST** /auth/refresh-token | Refresh access token
[**register**](DefaultApi.md#register) | **POST** /auth/register | Register a new account
[**resetPassword**](DefaultApi.md#resetpassword) | **POST** /auth/reset-password | Reset password
[**updateAccount**](DefaultApi.md#updateaccount) | **PUT** /accounts/{accountId} | Update an existing account
[**updateBlindBox**](DefaultApi.md#updateblindbox) | **PUT** /blind-boxes/{blindBoxId} | Update an existing blind box
[**updateBrand**](DefaultApi.md#updatebrand) | **PUT** /brands/{brandId} | Update an existing brand
[**updateImage**](DefaultApi.md#updateimage) | **PUT** /images/{imageId} | Update an existing image
[**updateNotification**](DefaultApi.md#updatenotification) | **PUT** /notifications/{notificationId} | Update an existing notification
[**updateOrder**](DefaultApi.md#updateorder) | **PUT** /orders/{orderId} | Update an existing order
[**updateOrderDetail**](DefaultApi.md#updateorderdetail) | **PUT** /order-details/{orderDetailId} | Update an existing order detail
[**updatePack**](DefaultApi.md#updatepack) | **PUT** /packs/{packId} | Update an existing pack
[**updatePromotionalCampaign**](DefaultApi.md#updatepromotionalcampaign) | **PUT** /promotional-campaigns/{campaignId} | Update an existing promotional campaign
[**updateTransaction**](DefaultApi.md#updatetransaction) | **PUT** /transactions/{transactionId} | Update an existing transaction
[**updateVideo**](DefaultApi.md#updatevideo) | **PUT** /videos/{videoId} | Update an existing video
[**updateVideo_0**](DefaultApi.md#updatevideo_0) | **PUT** /toys/{toyId} | Update an existing video


# **createAccount**
> AccountDto createAccount(accountDto)

Create an account

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = DefaultApi();
final accountDto = AccountDto(); // AccountDto | Account to create

try {
    final result = api_instance.createAccount(accountDto);
    print(result);
} catch (e) {
    print('Exception when calling DefaultApi->createAccount: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **accountDto** | [**AccountDto**](AccountDto.md)| Account to create | 

### Return type

[**AccountDto**](AccountDto.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createBlindBox**
> BlindBoxDto createBlindBox(blindBoxDto)

Create a blind box

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = DefaultApi();
final blindBoxDto = BlindBoxDto(); // BlindBoxDto | BlindBox to create

try {
    final result = api_instance.createBlindBox(blindBoxDto);
    print(result);
} catch (e) {
    print('Exception when calling DefaultApi->createBlindBox: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **blindBoxDto** | [**BlindBoxDto**](BlindBoxDto.md)| BlindBox to create | 

### Return type

[**BlindBoxDto**](BlindBoxDto.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createBrand**
> BrandDto createBrand(brandDto)

Create a brand

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = DefaultApi();
final brandDto = BrandDto(); // BrandDto | Brand to create

try {
    final result = api_instance.createBrand(brandDto);
    print(result);
} catch (e) {
    print('Exception when calling DefaultApi->createBrand: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **brandDto** | [**BrandDto**](BrandDto.md)| Brand to create | 

### Return type

[**BrandDto**](BrandDto.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createImage**
> ImageDto createImage(imageDto)

Create an image

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = DefaultApi();
final imageDto = ImageDto(); // ImageDto | Image to create

try {
    final result = api_instance.createImage(imageDto);
    print(result);
} catch (e) {
    print('Exception when calling DefaultApi->createImage: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **imageDto** | [**ImageDto**](ImageDto.md)| Image to create | 

### Return type

[**ImageDto**](ImageDto.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createNotification**
> NotificationDto createNotification(notificationDto)

Create a notification

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = DefaultApi();
final notificationDto = NotificationDto(); // NotificationDto | Notification to create

try {
    final result = api_instance.createNotification(notificationDto);
    print(result);
} catch (e) {
    print('Exception when calling DefaultApi->createNotification: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **notificationDto** | [**NotificationDto**](NotificationDto.md)| Notification to create | 

### Return type

[**NotificationDto**](NotificationDto.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createOrder**
> OrderDto createOrder(orderDto)

Create an order

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = DefaultApi();
final orderDto = OrderDto(); // OrderDto | Order to create

try {
    final result = api_instance.createOrder(orderDto);
    print(result);
} catch (e) {
    print('Exception when calling DefaultApi->createOrder: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **orderDto** | [**OrderDto**](OrderDto.md)| Order to create | 

### Return type

[**OrderDto**](OrderDto.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createOrderDetail**
> OrderDetailDto createOrderDetail(orderDetailDto)

Create an order detail

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = DefaultApi();
final orderDetailDto = OrderDetailDto(); // OrderDetailDto | OrderDetail to create

try {
    final result = api_instance.createOrderDetail(orderDetailDto);
    print(result);
} catch (e) {
    print('Exception when calling DefaultApi->createOrderDetail: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **orderDetailDto** | [**OrderDetailDto**](OrderDetailDto.md)| OrderDetail to create | 

### Return type

[**OrderDetailDto**](OrderDetailDto.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createPack**
> PackDto createPack(packDto)

Create a pack

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = DefaultApi();
final packDto = PackDto(); // PackDto | Pack to create

try {
    final result = api_instance.createPack(packDto);
    print(result);
} catch (e) {
    print('Exception when calling DefaultApi->createPack: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **packDto** | [**PackDto**](PackDto.md)| Pack to create | 

### Return type

[**PackDto**](PackDto.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createPromotionalCampaign**
> PromotionalCampaignDto createPromotionalCampaign(promotionalCampaignDto)

Create a promotional campaign

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = DefaultApi();
final promotionalCampaignDto = PromotionalCampaignDto(); // PromotionalCampaignDto | PromotionalCampaign to create

try {
    final result = api_instance.createPromotionalCampaign(promotionalCampaignDto);
    print(result);
} catch (e) {
    print('Exception when calling DefaultApi->createPromotionalCampaign: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **promotionalCampaignDto** | [**PromotionalCampaignDto**](PromotionalCampaignDto.md)| PromotionalCampaign to create | 

### Return type

[**PromotionalCampaignDto**](PromotionalCampaignDto.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createTransaction**
> TransactionDto createTransaction(transactionDto)

Create a transaction

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = DefaultApi();
final transactionDto = TransactionDto(); // TransactionDto | Transaction to create

try {
    final result = api_instance.createTransaction(transactionDto);
    print(result);
} catch (e) {
    print('Exception when calling DefaultApi->createTransaction: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **transactionDto** | [**TransactionDto**](TransactionDto.md)| Transaction to create | 

### Return type

[**TransactionDto**](TransactionDto.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createVideo**
> VideoDto createVideo(videoDto)

Create a video

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = DefaultApi();
final videoDto = VideoDto(); // VideoDto | Video to create

try {
    final result = api_instance.createVideo(videoDto);
    print(result);
} catch (e) {
    print('Exception when calling DefaultApi->createVideo: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **videoDto** | [**VideoDto**](VideoDto.md)| Video to create | 

### Return type

[**VideoDto**](VideoDto.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createVideo_0**
> VideoDto createVideo_0(videoDto)

Create a video

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = DefaultApi();
final videoDto = VideoDto(); // VideoDto | Video to create

try {
    final result = api_instance.createVideo_0(videoDto);
    print(result);
} catch (e) {
    print('Exception when calling DefaultApi->createVideo_0: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **videoDto** | [**VideoDto**](VideoDto.md)| Video to create | 

### Return type

[**VideoDto**](VideoDto.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteAccount**
> deleteAccount(accountId)

Delete an existing account

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = DefaultApi();
final accountId = 56; // int | 

try {
    api_instance.deleteAccount(accountId);
} catch (e) {
    print('Exception when calling DefaultApi->deleteAccount: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **accountId** | **int**|  | 

### Return type

void (empty response body)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteBlindBox**
> deleteBlindBox(blindBoxId)

Delete an existing blind box

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = DefaultApi();
final blindBoxId = 56; // int | 

try {
    api_instance.deleteBlindBox(blindBoxId);
} catch (e) {
    print('Exception when calling DefaultApi->deleteBlindBox: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **blindBoxId** | **int**|  | 

### Return type

void (empty response body)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteBrand**
> deleteBrand(brandId)

Delete an existing brand

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = DefaultApi();
final brandId = 56; // int | 

try {
    api_instance.deleteBrand(brandId);
} catch (e) {
    print('Exception when calling DefaultApi->deleteBrand: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **brandId** | **int**|  | 

### Return type

void (empty response body)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteImage**
> deleteImage(imageId)

Delete an existing image

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = DefaultApi();
final imageId = imageId_example; // String | 

try {
    api_instance.deleteImage(imageId);
} catch (e) {
    print('Exception when calling DefaultApi->deleteImage: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **imageId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteNotification**
> deleteNotification(notificationId)

Delete an existing notification

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = DefaultApi();
final notificationId = 56; // int | 

try {
    api_instance.deleteNotification(notificationId);
} catch (e) {
    print('Exception when calling DefaultApi->deleteNotification: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **notificationId** | **int**|  | 

### Return type

void (empty response body)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteOrder**
> deleteOrder(orderId)

Delete an existing order

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = DefaultApi();
final orderId = 789; // int | 

try {
    api_instance.deleteOrder(orderId);
} catch (e) {
    print('Exception when calling DefaultApi->deleteOrder: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **orderId** | **int**|  | 

### Return type

void (empty response body)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteOrderDetail**
> deleteOrderDetail(orderDetailId)

Delete an existing order detail

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = DefaultApi();
final orderDetailId = 789; // int | 

try {
    api_instance.deleteOrderDetail(orderDetailId);
} catch (e) {
    print('Exception when calling DefaultApi->deleteOrderDetail: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **orderDetailId** | **int**|  | 

### Return type

void (empty response body)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deletePack**
> deletePack(packId)

Delete an existing pack

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = DefaultApi();
final packId = 56; // int | 

try {
    api_instance.deletePack(packId);
} catch (e) {
    print('Exception when calling DefaultApi->deletePack: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **packId** | **int**|  | 

### Return type

void (empty response body)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deletePromotionalCampaign**
> deletePromotionalCampaign(campaignId)

Delete an existing promotional campaign

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = DefaultApi();
final campaignId = 789; // int | 

try {
    api_instance.deletePromotionalCampaign(campaignId);
} catch (e) {
    print('Exception when calling DefaultApi->deletePromotionalCampaign: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **campaignId** | **int**|  | 

### Return type

void (empty response body)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteTransaction**
> deleteTransaction(transactionId)

Delete an existing transaction

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = DefaultApi();
final transactionId = 789; // int | 

try {
    api_instance.deleteTransaction(transactionId);
} catch (e) {
    print('Exception when calling DefaultApi->deleteTransaction: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **transactionId** | **int**|  | 

### Return type

void (empty response body)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteVideo**
> deleteVideo(videoId)

Delete an existing video

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = DefaultApi();
final videoId = 789; // int | 

try {
    api_instance.deleteVideo(videoId);
} catch (e) {
    print('Exception when calling DefaultApi->deleteVideo: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **videoId** | **int**|  | 

### Return type

void (empty response body)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteVideo_0**
> deleteVideo_0(videoId)

Delete an existing video

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = DefaultApi();
final videoId = 789; // int | 

try {
    api_instance.deleteVideo_0(videoId);
} catch (e) {
    print('Exception when calling DefaultApi->deleteVideo_0: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **videoId** | **int**|  | 

### Return type

void (empty response body)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **forgotPassword**
> forgotPassword(forgotPasswordRequestDto)

Forgot password

### Example
```dart
import 'package:openapi/api.dart';

final api_instance = DefaultApi();
final forgotPasswordRequestDto = ForgotPasswordRequestDto(); // ForgotPasswordRequestDto | 

try {
    api_instance.forgotPassword(forgotPasswordRequestDto);
} catch (e) {
    print('Exception when calling DefaultApi->forgotPassword: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **forgotPasswordRequestDto** | [**ForgotPasswordRequestDto**](ForgotPasswordRequestDto.md)|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getAccountById**
> AccountDto getAccountById(accountId)

Get an account by ID

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = DefaultApi();
final accountId = 56; // int | 

try {
    final result = api_instance.getAccountById(accountId);
    print(result);
} catch (e) {
    print('Exception when calling DefaultApi->getAccountById: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **accountId** | **int**|  | 

### Return type

[**AccountDto**](AccountDto.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getAccounts**
> GetAccounts200Response getAccounts(pageable, filter, search)

Get a list of accounts

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = DefaultApi();
final pageable = ; // Pageable | Reusable pageable parameters
final filter = name,eq,John; // String | A single filter in the format `field,operator,value` (e.g., `name,eq,John`)
final search = ; // String | A search query

try {
    final result = api_instance.getAccounts(pageable, filter, search);
    print(result);
} catch (e) {
    print('Exception when calling DefaultApi->getAccounts: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **pageable** | [**Pageable**](.md)| Reusable pageable parameters | [optional] 
 **filter** | **String**| A single filter in the format `field,operator,value` (e.g., `name,eq,John`) | [optional] 
 **search** | **String**| A search query | [optional] 

### Return type

[**GetAccounts200Response**](GetAccounts200Response.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getBlindBoxById**
> BlindBoxDto getBlindBoxById(blindBoxId)

Get a blind box by ID

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = DefaultApi();
final blindBoxId = 56; // int | 

try {
    final result = api_instance.getBlindBoxById(blindBoxId);
    print(result);
} catch (e) {
    print('Exception when calling DefaultApi->getBlindBoxById: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **blindBoxId** | **int**|  | 

### Return type

[**BlindBoxDto**](BlindBoxDto.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getBlindBoxes**
> GetBlindBoxes200Response getBlindBoxes(pageable, filter, search)

Get a list of blind boxes

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = DefaultApi();
final pageable = ; // Pageable | Reusable pageable parameters
final filter = name,eq,John; // String | A single filter in the format `field,operator,value` (e.g., `name,eq,John`)
final search = ; // String | A search query

try {
    final result = api_instance.getBlindBoxes(pageable, filter, search);
    print(result);
} catch (e) {
    print('Exception when calling DefaultApi->getBlindBoxes: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **pageable** | [**Pageable**](.md)| Reusable pageable parameters | [optional] 
 **filter** | **String**| A single filter in the format `field,operator,value` (e.g., `name,eq,John`) | [optional] 
 **search** | **String**| A search query | [optional] 

### Return type

[**GetBlindBoxes200Response**](GetBlindBoxes200Response.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getBrandById**
> BrandDto getBrandById(brandId)

Get a brand by ID

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = DefaultApi();
final brandId = 56; // int | 

try {
    final result = api_instance.getBrandById(brandId);
    print(result);
} catch (e) {
    print('Exception when calling DefaultApi->getBrandById: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **brandId** | **int**|  | 

### Return type

[**BrandDto**](BrandDto.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getBrands**
> GetBrands200Response getBrands(pageable, filter, search)

Get a list of brands

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = DefaultApi();
final pageable = ; // Pageable | Reusable pageable parameters
final filter = name,eq,John; // String | A single filter in the format `field,operator,value` (e.g., `name,eq,John`)
final search = ; // String | A search query

try {
    final result = api_instance.getBrands(pageable, filter, search);
    print(result);
} catch (e) {
    print('Exception when calling DefaultApi->getBrands: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **pageable** | [**Pageable**](.md)| Reusable pageable parameters | [optional] 
 **filter** | **String**| A single filter in the format `field,operator,value` (e.g., `name,eq,John`) | [optional] 
 **search** | **String**| A search query | [optional] 

### Return type

[**GetBrands200Response**](GetBrands200Response.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getCurrentUser**
> AccountDto getCurrentUser()

Get current user information

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = DefaultApi();

try {
    final result = api_instance.getCurrentUser();
    print(result);
} catch (e) {
    print('Exception when calling DefaultApi->getCurrentUser: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**AccountDto**](AccountDto.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getImageById**
> ImageDto getImageById(imageId)

Get an image by imageId

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = DefaultApi();
final imageId = imageId_example; // String | 

try {
    final result = api_instance.getImageById(imageId);
    print(result);
} catch (e) {
    print('Exception when calling DefaultApi->getImageById: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **imageId** | **String**|  | 

### Return type

[**ImageDto**](ImageDto.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getImages**
> GetImages200Response getImages(pageable, filter, search)

Get a list of images

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = DefaultApi();
final pageable = ; // Pageable | Reusable pageable parameters
final filter = name,eq,John; // String | A single filter in the format `field,operator,value` (e.g., `name,eq,John`)
final search = ; // String | A search query

try {
    final result = api_instance.getImages(pageable, filter, search);
    print(result);
} catch (e) {
    print('Exception when calling DefaultApi->getImages: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **pageable** | [**Pageable**](.md)| Reusable pageable parameters | [optional] 
 **filter** | **String**| A single filter in the format `field,operator,value` (e.g., `name,eq,John`) | [optional] 
 **search** | **String**| A search query | [optional] 

### Return type

[**GetImages200Response**](GetImages200Response.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getNotificationById**
> NotificationDto getNotificationById(notificationId)

Get a notification by notificationId

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = DefaultApi();
final notificationId = 56; // int | 

try {
    final result = api_instance.getNotificationById(notificationId);
    print(result);
} catch (e) {
    print('Exception when calling DefaultApi->getNotificationById: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **notificationId** | **int**|  | 

### Return type

[**NotificationDto**](NotificationDto.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getNotifications**
> GetNotifications200Response getNotifications(pageable, filter, search)

Get a list of notifications

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = DefaultApi();
final pageable = ; // Pageable | Reusable pageable parameters
final filter = name,eq,John; // String | A single filter in the format `field,operator,value` (e.g., `name,eq,John`)
final search = ; // String | A search query

try {
    final result = api_instance.getNotifications(pageable, filter, search);
    print(result);
} catch (e) {
    print('Exception when calling DefaultApi->getNotifications: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **pageable** | [**Pageable**](.md)| Reusable pageable parameters | [optional] 
 **filter** | **String**| A single filter in the format `field,operator,value` (e.g., `name,eq,John`) | [optional] 
 **search** | **String**| A search query | [optional] 

### Return type

[**GetNotifications200Response**](GetNotifications200Response.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getOrderById**
> OrderDto getOrderById(orderId)

Get an order by orderId

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = DefaultApi();
final orderId = 789; // int | 

try {
    final result = api_instance.getOrderById(orderId);
    print(result);
} catch (e) {
    print('Exception when calling DefaultApi->getOrderById: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **orderId** | **int**|  | 

### Return type

[**OrderDto**](OrderDto.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getOrderDetailById**
> OrderDetailDto getOrderDetailById(orderDetailId)

Get an order detail by orderDetailId

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = DefaultApi();
final orderDetailId = 789; // int | 

try {
    final result = api_instance.getOrderDetailById(orderDetailId);
    print(result);
} catch (e) {
    print('Exception when calling DefaultApi->getOrderDetailById: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **orderDetailId** | **int**|  | 

### Return type

[**OrderDetailDto**](OrderDetailDto.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getOrderDetails**
> GetOrderDetails200Response getOrderDetails(pageable, filter, search)

Get a list of order details

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = DefaultApi();
final pageable = ; // Pageable | Reusable pageable parameters
final filter = name,eq,John; // String | A single filter in the format `field,operator,value` (e.g., `name,eq,John`)
final search = ; // String | A search query

try {
    final result = api_instance.getOrderDetails(pageable, filter, search);
    print(result);
} catch (e) {
    print('Exception when calling DefaultApi->getOrderDetails: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **pageable** | [**Pageable**](.md)| Reusable pageable parameters | [optional] 
 **filter** | **String**| A single filter in the format `field,operator,value` (e.g., `name,eq,John`) | [optional] 
 **search** | **String**| A search query | [optional] 

### Return type

[**GetOrderDetails200Response**](GetOrderDetails200Response.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getOrders**
> GetOrders200Response getOrders(pageable, filter, search)

Get a list of orders

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = DefaultApi();
final pageable = ; // Pageable | Reusable pageable parameters
final filter = name,eq,John; // String | A single filter in the format `field,operator,value` (e.g., `name,eq,John`)
final search = ; // String | A search query

try {
    final result = api_instance.getOrders(pageable, filter, search);
    print(result);
} catch (e) {
    print('Exception when calling DefaultApi->getOrders: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **pageable** | [**Pageable**](.md)| Reusable pageable parameters | [optional] 
 **filter** | **String**| A single filter in the format `field,operator,value` (e.g., `name,eq,John`) | [optional] 
 **search** | **String**| A search query | [optional] 

### Return type

[**GetOrders200Response**](GetOrders200Response.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getPackById**
> PackDto getPackById(packId)

Get a pack by packId

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = DefaultApi();
final packId = 56; // int | 

try {
    final result = api_instance.getPackById(packId);
    print(result);
} catch (e) {
    print('Exception when calling DefaultApi->getPackById: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **packId** | **int**|  | 

### Return type

[**PackDto**](PackDto.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getPacks**
> GetPacks200Response getPacks(pageable, filter, search)

Get a list of packs

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = DefaultApi();
final pageable = ; // Pageable | Reusable pageable parameters
final filter = name,eq,John; // String | A single filter in the format `field,operator,value` (e.g., `name,eq,John`)
final search = ; // String | A search query

try {
    final result = api_instance.getPacks(pageable, filter, search);
    print(result);
} catch (e) {
    print('Exception when calling DefaultApi->getPacks: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **pageable** | [**Pageable**](.md)| Reusable pageable parameters | [optional] 
 **filter** | **String**| A single filter in the format `field,operator,value` (e.g., `name,eq,John`) | [optional] 
 **search** | **String**| A search query | [optional] 

### Return type

[**GetPacks200Response**](GetPacks200Response.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getPromotionalCampaignById**
> PromotionalCampaignDto getPromotionalCampaignById(campaignId)

Get a promotional campaign by campaignId

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = DefaultApi();
final campaignId = 789; // int | 

try {
    final result = api_instance.getPromotionalCampaignById(campaignId);
    print(result);
} catch (e) {
    print('Exception when calling DefaultApi->getPromotionalCampaignById: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **campaignId** | **int**|  | 

### Return type

[**PromotionalCampaignDto**](PromotionalCampaignDto.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getPromotionalCampaigns**
> GetPromotionalCampaigns200Response getPromotionalCampaigns(pageable, filter, search)

Get a list of promotional campaigns

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = DefaultApi();
final pageable = ; // Pageable | Reusable pageable parameters
final filter = name,eq,John; // String | A single filter in the format `field,operator,value` (e.g., `name,eq,John`)
final search = ; // String | A search query

try {
    final result = api_instance.getPromotionalCampaigns(pageable, filter, search);
    print(result);
} catch (e) {
    print('Exception when calling DefaultApi->getPromotionalCampaigns: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **pageable** | [**Pageable**](.md)| Reusable pageable parameters | [optional] 
 **filter** | **String**| A single filter in the format `field,operator,value` (e.g., `name,eq,John`) | [optional] 
 **search** | **String**| A search query | [optional] 

### Return type

[**GetPromotionalCampaigns200Response**](GetPromotionalCampaigns200Response.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getTransactionById**
> TransactionDto getTransactionById(transactionId)

Get a transaction by transactionId

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = DefaultApi();
final transactionId = 789; // int | 

try {
    final result = api_instance.getTransactionById(transactionId);
    print(result);
} catch (e) {
    print('Exception when calling DefaultApi->getTransactionById: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **transactionId** | **int**|  | 

### Return type

[**TransactionDto**](TransactionDto.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getTransactions**
> GetTransactions200Response getTransactions(pageable, filter, search)

Get a list of transactions

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = DefaultApi();
final pageable = ; // Pageable | Reusable pageable parameters
final filter = name,eq,John; // String | A single filter in the format `field,operator,value` (e.g., `name,eq,John`)
final search = ; // String | A search query

try {
    final result = api_instance.getTransactions(pageable, filter, search);
    print(result);
} catch (e) {
    print('Exception when calling DefaultApi->getTransactions: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **pageable** | [**Pageable**](.md)| Reusable pageable parameters | [optional] 
 **filter** | **String**| A single filter in the format `field,operator,value` (e.g., `name,eq,John`) | [optional] 
 **search** | **String**| A search query | [optional] 

### Return type

[**GetTransactions200Response**](GetTransactions200Response.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getVideoById**
> VideoDto getVideoById(videoId)

Get a video by videoId

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = DefaultApi();
final videoId = 789; // int | 

try {
    final result = api_instance.getVideoById(videoId);
    print(result);
} catch (e) {
    print('Exception when calling DefaultApi->getVideoById: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **videoId** | **int**|  | 

### Return type

[**VideoDto**](VideoDto.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getVideoById_0**
> VideoDto getVideoById_0(videoId)

Get a video by videoId

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = DefaultApi();
final videoId = 789; // int | 

try {
    final result = api_instance.getVideoById_0(videoId);
    print(result);
} catch (e) {
    print('Exception when calling DefaultApi->getVideoById_0: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **videoId** | **int**|  | 

### Return type

[**VideoDto**](VideoDto.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getVideos**
> GetVideos200Response getVideos(pageable, filter, search)

Get a list of videos

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = DefaultApi();
final pageable = ; // Pageable | Reusable pageable parameters
final filter = name,eq,John; // String | A single filter in the format `field,operator,value` (e.g., `name,eq,John`)
final search = ; // String | A search query

try {
    final result = api_instance.getVideos(pageable, filter, search);
    print(result);
} catch (e) {
    print('Exception when calling DefaultApi->getVideos: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **pageable** | [**Pageable**](.md)| Reusable pageable parameters | [optional] 
 **filter** | **String**| A single filter in the format `field,operator,value` (e.g., `name,eq,John`) | [optional] 
 **search** | **String**| A search query | [optional] 

### Return type

[**GetVideos200Response**](GetVideos200Response.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getVideos_0**
> GetVideos200Response getVideos_0(pageable, filter, search)

Get a list of videos

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = DefaultApi();
final pageable = ; // Pageable | Reusable pageable parameters
final filter = name,eq,John; // String | A single filter in the format `field,operator,value` (e.g., `name,eq,John`)
final search = ; // String | A search query

try {
    final result = api_instance.getVideos_0(pageable, filter, search);
    print(result);
} catch (e) {
    print('Exception when calling DefaultApi->getVideos_0: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **pageable** | [**Pageable**](.md)| Reusable pageable parameters | [optional] 
 **filter** | **String**| A single filter in the format `field,operator,value` (e.g., `name,eq,John`) | [optional] 
 **search** | **String**| A search query | [optional] 

### Return type

[**GetVideos200Response**](GetVideos200Response.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **login**
> AuthResponseDto login(loginRequestDto)

Login to an account

### Example
```dart
import 'package:openapi/api.dart';

final api_instance = DefaultApi();
final loginRequestDto = LoginRequestDto(); // LoginRequestDto | 

try {
    final result = api_instance.login(loginRequestDto);
    print(result);
} catch (e) {
    print('Exception when calling DefaultApi->login: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **loginRequestDto** | [**LoginRequestDto**](LoginRequestDto.md)|  | 

### Return type

[**AuthResponseDto**](AuthResponseDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **loginWithGoogle**
> AuthResponseDto loginWithGoogle(body)

Login with Google

### Example
```dart
import 'package:openapi/api.dart';

final api_instance = DefaultApi();
final body = String(); // String | 

try {
    final result = api_instance.loginWithGoogle(body);
    print(result);
} catch (e) {
    print('Exception when calling DefaultApi->loginWithGoogle: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **body** | **String**|  | 

### Return type

[**AuthResponseDto**](AuthResponseDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **logout**
> logout()

Logout from the account

### Example
```dart
import 'package:openapi/api.dart';

final api_instance = DefaultApi();

try {
    api_instance.logout();
} catch (e) {
    print('Exception when calling DefaultApi->logout: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **refreshToken**
> JwtResponseDto refreshToken(body)

Refresh access token

### Example
```dart
import 'package:openapi/api.dart';

final api_instance = DefaultApi();
final body = String(); // String | 

try {
    final result = api_instance.refreshToken(body);
    print(result);
} catch (e) {
    print('Exception when calling DefaultApi->refreshToken: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **body** | **String**|  | 

### Return type

[**JwtResponseDto**](JwtResponseDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **register**
> register(registerRequestDto)

Register a new account

### Example
```dart
import 'package:openapi/api.dart';

final api_instance = DefaultApi();
final registerRequestDto = RegisterRequestDto(); // RegisterRequestDto | 

try {
    api_instance.register(registerRequestDto);
} catch (e) {
    print('Exception when calling DefaultApi->register: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **registerRequestDto** | [**RegisterRequestDto**](RegisterRequestDto.md)|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **resetPassword**
> resetPassword(resetPasswordRequestDto)

Reset password

### Example
```dart
import 'package:openapi/api.dart';

final api_instance = DefaultApi();
final resetPasswordRequestDto = ResetPasswordRequestDto(); // ResetPasswordRequestDto | 

try {
    api_instance.resetPassword(resetPasswordRequestDto);
} catch (e) {
    print('Exception when calling DefaultApi->resetPassword: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **resetPasswordRequestDto** | [**ResetPasswordRequestDto**](ResetPasswordRequestDto.md)|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateAccount**
> AccountDto updateAccount(accountId, accountDto)

Update an existing account

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = DefaultApi();
final accountId = 56; // int | 
final accountDto = AccountDto(); // AccountDto | Account to update

try {
    final result = api_instance.updateAccount(accountId, accountDto);
    print(result);
} catch (e) {
    print('Exception when calling DefaultApi->updateAccount: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **accountId** | **int**|  | 
 **accountDto** | [**AccountDto**](AccountDto.md)| Account to update | 

### Return type

[**AccountDto**](AccountDto.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateBlindBox**
> BlindBoxDto updateBlindBox(blindBoxId, blindBoxDto)

Update an existing blind box

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = DefaultApi();
final blindBoxId = 56; // int | 
final blindBoxDto = BlindBoxDto(); // BlindBoxDto | BlindBox to update

try {
    final result = api_instance.updateBlindBox(blindBoxId, blindBoxDto);
    print(result);
} catch (e) {
    print('Exception when calling DefaultApi->updateBlindBox: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **blindBoxId** | **int**|  | 
 **blindBoxDto** | [**BlindBoxDto**](BlindBoxDto.md)| BlindBox to update | 

### Return type

[**BlindBoxDto**](BlindBoxDto.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateBrand**
> BrandDto updateBrand(brandId, brandDto)

Update an existing brand

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = DefaultApi();
final brandId = 56; // int | 
final brandDto = BrandDto(); // BrandDto | Brand to update

try {
    final result = api_instance.updateBrand(brandId, brandDto);
    print(result);
} catch (e) {
    print('Exception when calling DefaultApi->updateBrand: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **brandId** | **int**|  | 
 **brandDto** | [**BrandDto**](BrandDto.md)| Brand to update | 

### Return type

[**BrandDto**](BrandDto.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateImage**
> ImageDto updateImage(imageId, imageDto)

Update an existing image

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = DefaultApi();
final imageId = imageId_example; // String | 
final imageDto = ImageDto(); // ImageDto | Image to update

try {
    final result = api_instance.updateImage(imageId, imageDto);
    print(result);
} catch (e) {
    print('Exception when calling DefaultApi->updateImage: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **imageId** | **String**|  | 
 **imageDto** | [**ImageDto**](ImageDto.md)| Image to update | 

### Return type

[**ImageDto**](ImageDto.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateNotification**
> NotificationDto updateNotification(notificationId, notificationDto)

Update an existing notification

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = DefaultApi();
final notificationId = 56; // int | 
final notificationDto = NotificationDto(); // NotificationDto | Notification to update

try {
    final result = api_instance.updateNotification(notificationId, notificationDto);
    print(result);
} catch (e) {
    print('Exception when calling DefaultApi->updateNotification: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **notificationId** | **int**|  | 
 **notificationDto** | [**NotificationDto**](NotificationDto.md)| Notification to update | 

### Return type

[**NotificationDto**](NotificationDto.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateOrder**
> OrderDto updateOrder(orderId, orderDto)

Update an existing order

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = DefaultApi();
final orderId = 789; // int | 
final orderDto = OrderDto(); // OrderDto | Order to update

try {
    final result = api_instance.updateOrder(orderId, orderDto);
    print(result);
} catch (e) {
    print('Exception when calling DefaultApi->updateOrder: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **orderId** | **int**|  | 
 **orderDto** | [**OrderDto**](OrderDto.md)| Order to update | 

### Return type

[**OrderDto**](OrderDto.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateOrderDetail**
> OrderDetailDto updateOrderDetail(orderDetailId, orderDetailDto)

Update an existing order detail

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = DefaultApi();
final orderDetailId = 789; // int | 
final orderDetailDto = OrderDetailDto(); // OrderDetailDto | OrderDetail to update

try {
    final result = api_instance.updateOrderDetail(orderDetailId, orderDetailDto);
    print(result);
} catch (e) {
    print('Exception when calling DefaultApi->updateOrderDetail: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **orderDetailId** | **int**|  | 
 **orderDetailDto** | [**OrderDetailDto**](OrderDetailDto.md)| OrderDetail to update | 

### Return type

[**OrderDetailDto**](OrderDetailDto.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updatePack**
> PackDto updatePack(packId, packDto)

Update an existing pack

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = DefaultApi();
final packId = 56; // int | 
final packDto = PackDto(); // PackDto | Pack to update

try {
    final result = api_instance.updatePack(packId, packDto);
    print(result);
} catch (e) {
    print('Exception when calling DefaultApi->updatePack: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **packId** | **int**|  | 
 **packDto** | [**PackDto**](PackDto.md)| Pack to update | 

### Return type

[**PackDto**](PackDto.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updatePromotionalCampaign**
> PromotionalCampaignDto updatePromotionalCampaign(campaignId, promotionalCampaignDto)

Update an existing promotional campaign

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = DefaultApi();
final campaignId = 789; // int | 
final promotionalCampaignDto = PromotionalCampaignDto(); // PromotionalCampaignDto | PromotionalCampaign to update

try {
    final result = api_instance.updatePromotionalCampaign(campaignId, promotionalCampaignDto);
    print(result);
} catch (e) {
    print('Exception when calling DefaultApi->updatePromotionalCampaign: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **campaignId** | **int**|  | 
 **promotionalCampaignDto** | [**PromotionalCampaignDto**](PromotionalCampaignDto.md)| PromotionalCampaign to update | 

### Return type

[**PromotionalCampaignDto**](PromotionalCampaignDto.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateTransaction**
> TransactionDto updateTransaction(transactionId, transactionDto)

Update an existing transaction

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = DefaultApi();
final transactionId = 789; // int | 
final transactionDto = TransactionDto(); // TransactionDto | Transaction to update

try {
    final result = api_instance.updateTransaction(transactionId, transactionDto);
    print(result);
} catch (e) {
    print('Exception when calling DefaultApi->updateTransaction: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **transactionId** | **int**|  | 
 **transactionDto** | [**TransactionDto**](TransactionDto.md)| Transaction to update | 

### Return type

[**TransactionDto**](TransactionDto.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateVideo**
> VideoDto updateVideo(videoId, videoDto)

Update an existing video

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = DefaultApi();
final videoId = 789; // int | 
final videoDto = VideoDto(); // VideoDto | Video to update

try {
    final result = api_instance.updateVideo(videoId, videoDto);
    print(result);
} catch (e) {
    print('Exception when calling DefaultApi->updateVideo: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **videoId** | **int**|  | 
 **videoDto** | [**VideoDto**](VideoDto.md)| Video to update | 

### Return type

[**VideoDto**](VideoDto.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateVideo_0**
> VideoDto updateVideo_0(videoId, videoDto)

Update an existing video

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = DefaultApi();
final videoId = 789; // int | 
final videoDto = VideoDto(); // VideoDto | Video to update

try {
    final result = api_instance.updateVideo_0(videoId, videoDto);
    print(result);
} catch (e) {
    print('Exception when calling DefaultApi->updateVideo_0: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **videoId** | **int**|  | 
 **videoDto** | [**VideoDto**](VideoDto.md)| Video to update | 

### Return type

[**VideoDto**](VideoDto.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

