import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../locale_cubit/locale_cubit.dart';

class DropdownCubit extends Cubit<Map<String, dynamic>> {
  final LocaleCubit localeCubit;

  @factoryMethod
  DropdownCubit(this.localeCubit) : super({
    'isOpen': false,
    'selectedLanguage': _getInitialLanguage(localeCubit),
  });

  static Map<String, String> _getInitialLanguage(LocaleCubit localeCubit) {
    String languageCode = localeCubit.state.languageCode;
    debugPrint('languageCode: $languageCode');
    return languageList.firstWhere(
          (lang) => lang['code'] == languageCode,
      orElse: () => {'code': 'en', 'name': 'English', 'flag': '🇺🇸'},
    );
  }

  static final List<Map<String, String>> languageList = [
    {'code': 'en', 'name': 'English', 'flag': '🇺🇸'},
    {'code': 'vi', 'name': 'Vietnamese', 'flag': '🇻🇳'},
  ];

  void toggleDropdown() {
    emit({...state, 'isOpen': !state['isOpen']});
  }

  void selectLanguage(Map<String, String> language) {
    emit({...state, 'selectedLanguage': language, 'isOpen': false});
  }

  void closeDropdown() {
    emit({...state, 'isOpen': false});
  }
}