//
// import 'package:flutter/material.dart';
// import 'package:mobile/ui/core/theme/theme.dart';
// import 'package:mobile/ui/login/widgets/login_screen.dart';
// import 'package:mobile/ui/register/widgets/register_screen.dart';
//
// class AuthScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 2,
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         appBar: AppBar(
//           backgroundColor: Colors.white,
//           elevation: 0,
//           toolbarHeight: 80,
//           title: const Text(
//             "Blind Box",
//             style: TextStyle(
//               color: Colors.deepPurple,
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           centerTitle: true,
//           bottom: PreferredSize(
//             preferredSize: const Size.fromHeight(50),
//             child: Container(
//               margin: const EdgeInsets.symmetric(horizontal: 16),
//               decoration: BoxDecoration(
//                 color: getColorSkin().lightGrey300,
//                 borderRadius: BorderRadius.circular(25),
//               ),
//               child: TabBar(
//                 indicator: BoxDecoration(
//                   borderRadius: BorderRadius.circular(25),
//                   color: Colors.transparent,
//                 ),
//                 dividerColor: Colors.transparent,
//                 // indicatorColor: Colors.transparent,
//                 labelColor: Colors.black,
//                 unselectedLabelColor: Colors.black,
//                 tabs: const [
//                   Tab(text: "Sign In"),
//                   Tab(text: "Sign Up"),
//                 ],
//               )
//             ),
//           ),
//         ),
//         body: const TabBarView(
//           children: [
//             LoginScreen(),
//             RegisterScreen(),
//           ],
//         ),
//       ),
//     );
//   }
// }
