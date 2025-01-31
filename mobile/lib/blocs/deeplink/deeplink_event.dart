import 'package:meta/meta.dart';

@immutable
abstract class DeeplinkEvent {}

class GetInitialDeepLink extends DeeplinkEvent {}

class DeepLinkReceived extends DeeplinkEvent {
  final Uri uri;

  DeepLinkReceived(this.uri);
}
