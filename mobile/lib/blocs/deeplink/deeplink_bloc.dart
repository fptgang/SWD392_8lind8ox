// import 'dart:async';
// import 'package:bloc/bloc.dart';
// import 'package:flutter/material.dart';
// import 'package:uni_links/uni_links.dart';
// import 'deeplink_event.dart';
// import 'deeplink_state.dart';
//
// class DeeplinkBloc extends Bloc<DeeplinkEvent, DeeplinkState> {
//   StreamSubscription? _linkSubscription;
//
//   DeeplinkBloc() : super(DeeplinkInitial()) {
//     on<GetInitialDeepLink>(_mapGetInitialDeepLinkToState);
//     on<DeepLinkReceived>(_mapDeepLinkReceivedToState);
//
//     _initDeepLinkListener();
//   }
//
//   @override
//   Future<void> close() {
//     _linkSubscription?.cancel();
//     return super.close();
//   }
//
//   // Handle initial deep link (when the app launches with a link)
//   Future<void> _mapGetInitialDeepLinkToState(
//       GetInitialDeepLink event, Emitter<DeeplinkState> emit) async {
//     try {
//       final String? initialLink = await getInitialLink();
//       if (initialLink != null) {
//         final Uri uri = Uri.parse(initialLink);
//         _processDeepLink(uri, emit);
//       } else {
//         emit(DeepLinkError(error: "No initial deep link found."));
//       }
//     } catch (error) {
//       emit(DeepLinkError(error: "Error processing initial deep link: $error"));
//     }
//   }
//
//   // Handle runtime deep links (when the app is running)
//   void _mapDeepLinkReceivedToState(
//       DeepLinkReceived event, Emitter<DeeplinkState> emit) {
//     final Uri uri = event.uri;
//     _processDeepLink(uri, emit);
//   }
//
//   // Listen to runtime deep links
//   void _initDeepLinkListener() {
//     _linkSubscription = uriLinkStream.listen((Uri? uri) {
//       if (uri != null) {
//         add(DeepLinkReceived(uri));
//       }
//     }, onError: (err) {
//       emit(DeepLinkError(error: "Error listening to deep link stream: $err"));
//     });
//   }
//
//   // Process deep link to extract token
//   void _processDeepLink(Uri uri, Emitter<DeeplinkState> emit) {
//     if (uri.path == '/reset-password') {
//       final String? token = uri.queryParameters['token'];
//       if (token != null && token.isNotEmpty) {
//         emit(InitialDeepLinkFound(token: token));
//         debugPrint("Token found in deep link: $token");
//       } else {
//         emit(DeepLinkError(error: "Token missing or invalid in deep link."));
//       }
//     } else {
//       emit(DeepLinkError(error: "Unknown deep link path: ${uri.path}"));
//     }
//   }
// }
