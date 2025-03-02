import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/di/injection.dart';
import '../../cubit/dropdown_cubit/dropdown_cubit.dart';
import '../../cubit/locale_cubit/locale_cubit.dart';

class LanguageDropdown extends StatelessWidget {
  final List<Map<String, String>> languageList = [
    {'code': 'en', 'name': 'English', 'flag': '🇺🇸'},
    {'code': 'vi', 'name': 'Vietnam', 'flag': '🇻🇳'},
  ];

  final LayerLink _layerLink = LayerLink();

  @override
  Widget build(BuildContext context) {
    final dropdownCubit = getIt<DropdownCubit>();
    return MultiBlocListener(
      listeners: [
        BlocListener<LocaleCubit, Locale>(
          listener: (context, locale) {
            final newLanguage = languageList.firstWhere(
                  (lang) => lang['code'] == locale.languageCode,
              orElse: () => languageList[0],
            );
            dropdownCubit.selectLanguage(newLanguage);
          },
        ),
      ],
      child: Stack(
        children: [
          CompositedTransformTarget(
            link: _layerLink,
            child: BlocBuilder<DropdownCubit, Map<String, dynamic>>(
              builder: (context, state) {
                final selectedLanguage = state['selectedLanguage'];
                return GestureDetector(
                  onTap: () {
                    context.read<DropdownCubit>().toggleDropdown();
                    if (state['isOpen']) {
                      _showDropdown(context);
                    } else {
                      _closeDropdown();
                    }
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        selectedLanguage['flag']!,
                        style: const TextStyle(fontSize: 20),
                      ),
                      const Icon(Icons.arrow_drop_down, color: Colors.black),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  OverlayEntry? _overlayEntry;

  void _showDropdown(BuildContext context) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final Size size = renderBox.size;
    final double screenWidth = MediaQuery.of(context).size.width;

    final bool showOnLeft = (offset.dx + 200) > screenWidth;

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            GestureDetector(
              onTap: () {
                context.read<DropdownCubit>().closeDropdown();
                _closeDropdown();
              },
              behavior: HitTestBehavior.opaque,
              child: Container(),
            ),
            Positioned(
              left: showOnLeft ? offset.dx - (150 - size.width) : offset.dx,
              top: offset.dy + (size.height * 1.3),
              width: 150.w,
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                child: ListView(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  children: languageList.map((lang) {
                    return ListTile(
                      leading: Text(lang['flag']!, style: const TextStyle(fontSize: 20)),
                      title: Text(lang['name']!, style: const TextStyle(fontSize: 16)),
                      onTap: () {
                        context.read<LocaleCubit>().setLocale(Locale(lang['code']!));
                        context.read<DropdownCubit>().selectLanguage(lang);
                        _closeDropdown();
                      },
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _closeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}