// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:mobile/cubit/blindbox_list_cubit/blindbox_list_bloc.dart';
// import 'package:mobile/cubit/blindbox_list_cubit/blindbox_list_state.dart';
// class CustomSearchBar extends StatelessWidget {
//   final String defaultText;
//
//   const CustomSearchBar({
//     super.key,
//     required this.defaultText,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<BlindBoxesCubit, BlindBoxesState>(
//       builder: (context, state) {
//         return TextField(
//           decoration: InputDecoration(
//             hintText: defaultText,
//             hintStyle: const TextStyle(color: Colors.grey),
//             prefixIcon: const Icon(Icons.search, color: Colors.grey),
//             filled: true,
//             fillColor: Colors.grey[100],
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: BorderSide.none,
//             ),
//             contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//           ),
//           onChanged: (value) {
//             context.read<BlindBoxesCubit>().setSearchQuery(value);
//           },
//           onSubmitted: (_) {
//             context.read<BlindBoxesCubit>().submitSearch();
//           },
//         );
//       },
//     );
//   }
// }
