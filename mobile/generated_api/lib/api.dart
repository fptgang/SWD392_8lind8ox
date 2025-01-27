//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

library openapi.api;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

part 'api_client.dart';
part 'api_helper.dart';
part 'api_exception.dart';
part 'auth/authentication.dart';
part 'auth/api_key_auth.dart';
part 'auth/oauth.dart';
part 'auth/http_basic_auth.dart';
part 'auth/http_bearer_auth.dart';

part 'api/default_api.dart';

part 'model/account_dto.dart';
part 'model/auth_response_dto.dart';
part 'model/blind_box_dto.dart';
part 'model/brand_dto.dart';
part 'model/error_response.dart';
part 'model/forgot_password_request_dto.dart';
part 'model/get_accounts200_response.dart';
part 'model/get_blind_boxes200_response.dart';
part 'model/get_brands200_response.dart';
part 'model/get_images200_response.dart';
part 'model/get_notifications200_response.dart';
part 'model/get_order_details200_response.dart';
part 'model/get_orders200_response.dart';
part 'model/get_packs200_response.dart';
part 'model/get_promotional_campaigns200_response.dart';
part 'model/get_transactions200_response.dart';
part 'model/get_videos200_response.dart';
part 'model/image_dto.dart';
part 'model/jwt_response_dto.dart';
part 'model/login_request_dto.dart';
part 'model/notification_dto.dart';
part 'model/order_detail_dto.dart';
part 'model/order_dto.dart';
part 'model/pack_dto.dart';
part 'model/package_dto.dart';
part 'model/page.dart';
part 'model/pageable.dart';
part 'model/promotion_campaign_dto.dart';
part 'model/promotional_campaign_dto.dart';
part 'model/refresh_token_dto.dart';
part 'model/register_request_dto.dart';
part 'model/reset_password_request_dto.dart';
part 'model/toy_dto.dart';
part 'model/transaction_dto.dart';
part 'model/video_dto.dart';


/// An [ApiClient] instance that uses the default values obtained from
/// the OpenAPI specification file.
var defaultApiClient = ApiClient();

const _delimiters = {'csv': ',', 'ssv': ' ', 'tsv': '\t', 'pipes': '|'};
const _dateEpochMarker = 'epoch';
const _deepEquality = DeepCollectionEquality();
final _dateFormatter = DateFormat('yyyy-MM-dd');
final _regList = RegExp(r'^List<(.*)>$');
final _regSet = RegExp(r'^Set<(.*)>$');
final _regMap = RegExp(r'^Map<String,(.*)>$');

bool _isEpochMarker(String? pattern) => pattern == _dateEpochMarker || pattern == '/$_dateEpochMarker/';
