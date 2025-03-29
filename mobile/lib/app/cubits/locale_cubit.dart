import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@Singleton()
@injectable
class LocaleCubit extends Cubit<Locale> {
  LocaleCubit() : super(const Locale('vi')) {
    _loadSavedLocale();
  }

  void _loadSavedLocale() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? languageCode = prefs.getString('languageCode');
      if (languageCode != null) {
        emit(Locale(languageCode));
      }
    } catch (e) {
      // Silently fail but log error
      debugPrint('Error loading locale: $e');
    }
  }

  void setLocale(Locale locale) async {
    try {
      emit(locale);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('languageCode', "en");
    } catch (e) {
      debugPrint('Error saving locale: $e');
    }
  }

  String get languageCode => state.languageCode;
}
