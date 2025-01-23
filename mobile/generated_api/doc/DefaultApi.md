# openapi.api.DefaultApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost:8080/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**createAccount**](DefaultApi.md#createaccount) | **POST** /accounts | Create an account
[**deleteAccount**](DefaultApi.md#deleteaccount) | **DELETE** /accounts/{accountId} | Delete an existing account
[**forgotPassword**](DefaultApi.md#forgotpassword) | **POST** /auth/forgot-password | Forgot password
[**getAccountById**](DefaultApi.md#getaccountbyid) | **GET** /accounts/{accountId} | Get an account by ID
[**getAccounts**](DefaultApi.md#getaccounts) | **GET** /accounts | Get a list of accounts
[**getCurrentUser**](DefaultApi.md#getcurrentuser) | **GET** /auth/me | Get current user information
[**login**](DefaultApi.md#login) | **POST** /auth/login | Login to an account
[**loginWithGoogle**](DefaultApi.md#loginwithgoogle) | **POST** /auth/login-with-google | Login with Google
[**logout**](DefaultApi.md#logout) | **GET** /auth/logout | Logout from the account
[**refreshToken**](DefaultApi.md#refreshtoken) | **POST** /auth/refresh-token | Refresh access token
[**register**](DefaultApi.md#register) | **POST** /auth/register | Register a new account
[**resetPassword**](DefaultApi.md#resetpassword) | **POST** /auth/reset-password | Reset password
[**updateAccount**](DefaultApi.md#updateaccount) | **PUT** /accounts/{accountId} | Update an existing account


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
> GetAccounts200Response getAccounts(pageable, filter)

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
final pageable = ; // GetAccountsPageableParameter | Reusable pageable parameters
final filter = name,eq,John; // String | A single filter in the format `field,operator,value` (e.g., `name,eq,John`)

try {
    final result = api_instance.getAccounts(pageable, filter);
    print(result);
} catch (e) {
    print('Exception when calling DefaultApi->getAccounts: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **pageable** | [**GetAccountsPageableParameter**](.md)| Reusable pageable parameters | [optional] 
 **filter** | **String**| A single filter in the format `field,operator,value` (e.g., `name,eq,John`) | [optional] 

### Return type

[**GetAccounts200Response**](GetAccounts200Response.md)

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

