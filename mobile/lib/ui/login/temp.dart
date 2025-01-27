// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:get_it/get_it.dart';
// import 'package:mobile/blocs/login/login_bloc.dart';
// import 'package:mobile/data/repositories/auth_repository.dart';
// import 'package:mobile/ui/core/theme/theme.dart';
// import 'package:mobile/ui/homepage/widget/homepage_screen.dart';
// import 'package:mobile/ui/reset_password/widgets/forgot_password_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
//
// class LoginScreen extends StatelessWidget {
//   LoginScreen({super.key});
//
//   final AuthRepository authRepository = GetIt.instance<AuthRepository>();
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: BlocProvider<LoginBloc>(
//         create: (context) => LoginBloc(authRepository),
//         child: Scaffold(
//           backgroundColor: Colors.white,
//           body: Center(
//             child: SafeArea(
//               child: SingleChildScrollView(
//                 child: Padding(
//                   padding: const EdgeInsets.all(20.0),
//                   child: Column(
//                     children: [
//                       Card(
//                         color: getColorSkin().backgroundColor,
//                         elevation: 4,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.all(16.0),
//                           child: Column(
//                             children: [
//                                Text(
//                                 'Welcome Back',
//                                 style: TextStyle(
//                                   fontSize: 22,
//                                   fontWeight: FontWeight.bold,
//                                   color: getColorSkin().textColor,
//                                 ),
//                               ),
//                               const SizedBox(height: 8),
//                               Text(
//                                 'Fill out the information below in order to access your account.',
//                                 textAlign: TextAlign.center,
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   color: getColorSkin().grey,
//                                 ),
//                               ),
//
//                               const SizedBox(height: 24),
//
//                               TextField(
//                                 decoration: InputDecoration(
//                                   labelText: 'Email',
//                                   border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(12),
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(height: 16),
//
//                               TextField(
//                                 obscureText: true,
//                                 decoration: InputDecoration(
//                                   labelText: 'Password',
//                                   border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(12),
//                                   ),
//                                   suffixIcon: const Icon(Icons.visibility_off),
//                                 ),
//                               ),
//                               const SizedBox(height: 16),
//
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   TextButton(
//                                     onPressed: () {
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                           builder: (context) =>
//                                               ForgotPasswordScreen(),
//                                         ),
//                                       );
//                                     },
//                                     child: Text(
//                                       'Forgot Password?',
//                                       style: TextStyle(
//                                         color: getColorSkin().textColor,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ),
//                                   ElevatedButton(
//                                     onPressed: () {
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                           builder: (context) => HomePageScreen(),
//                                         ),
//                                       );
//                                     },
//                                     style: ElevatedButton.styleFrom(
//                                       backgroundColor: getColorSkin().accentColor,
//                                       shape: RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.circular(12),
//                                       ),
//                                       padding: const EdgeInsets.symmetric(
//                                         horizontal: 24,
//                                         vertical: 12,
//                                       ),
//                                     ),
//                                     child: Text(
//                                       'Sign In',
//                                       style: TextStyle(fontSize: 16, color: getColorSkin().backgroundColor),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//
//                               const SizedBox(height: 24),
//
//                               // Divider with Text
//                               Row(
//                                 children:  [
//                                   Expanded(
//                                     child: Divider(
//                                       color: getColorSkin().grey,
//                                       thickness: 1,
//                                     ),
//                                   ),
//                                   Padding(
//                                     padding: EdgeInsets.symmetric(horizontal: 8.0),
//                                     child: Text(
//                                       'Or sign in with',
//                                       style: TextStyle(color: getColorSkin().grey),
//                                     ),
//                                   ),
//                                   Expanded(
//                                     child: Divider(
//                                       color: getColorSkin().grey,
//                                       thickness: 1,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//
//                               const SizedBox(height: 16),
//
//                               // Social Buttons
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   ElevatedButton.icon(
//                                     onPressed: () {},
//                                     style: ElevatedButton.styleFrom(
//                                       backgroundColor: getColorSkin().backgroundColor,
//                                       side: BorderSide(color: getColorSkin().grey),
//                                       shape: RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.circular(12),
//                                       ),
//                                       padding: const EdgeInsets.symmetric(
//                                         horizontal: 16,
//                                         vertical: 12,
//                                       ),
//                                     ),
//                                     icon: Icon(Icons.g_mobiledata,
//                                         color: getColorSkin().black),
//                                     label: Text(
//                                       'Continue with Google',
//                                       style: TextStyle(color: getColorSkin().black),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Text(
//                                     'Don\'t have an account? ',
//                                     style: TextStyle(
//                                       color: getColorSkin().grey,
//                                     ),
//                                   ),
//                                   TextButton(
//                                     onPressed: () {
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                           builder: (context) => HomePageScreen(),
//                                         ),
//                                       );
//                                     },
//                                     child: Text(
//                                       'Sign Up',
//                                       style: TextStyle(
//                                         color: getColorSkin().textColor,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               )
//                             ],
//                           ),
//                         ),
//                       ),
//                       // Welcome Text
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }