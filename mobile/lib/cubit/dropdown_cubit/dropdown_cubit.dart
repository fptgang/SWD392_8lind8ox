import 'package:bloc/bloc.dart';

class DropdownCubit extends Cubit<Map<String, dynamic>> {
  DropdownCubit()
      : super({
    'isOpen': false,
    'selectedLanguage': {'code': 'en', 'name': 'English', 'flag': '🇺🇸'},
  });

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
