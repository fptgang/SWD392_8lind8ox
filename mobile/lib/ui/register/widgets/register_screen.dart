import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/data/repositories/auth_repository.dart';
import 'package:mobile/ui/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../blocs/register/register_bloc.dart';


class RegisterScreen extends StatelessWidget {
  // final AuthRepository authRepository;
  RegisterScreen({Key? key}) : super(key: key);

  final AuthRepository authRepository = GetIt.instance<AuthRepository>();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider<RegisterBloc>(
        create: (context) => RegisterBloc(authRepository),
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Card(
                      color: getColorSkin().backgroundColor,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  "Create Account",
                                  style: TextStyle(
                                      fontSize: 22, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 10.h),
                                Text(
                                  "Let's get started by filling out the form below.",
                                  style: TextStyle(color: getColorSkin().grey
                                      , fontSize: 16),
                                ),
                              ],
                            ),

                            SizedBox(height: 20.h),

                            // Input Fields
                            TextField(
                              decoration: InputDecoration(
                                labelText: "Email",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                            ),
                            SizedBox(height: 20.h),
                            TextField(
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: "Password",
                                suffixIcon: const Icon(Icons.visibility_off),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                            ),

                            SizedBox(height: 20.h),

                            // Get Started Button
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: getColorSkin().accentColor,
                                minimumSize: const Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                              child: Text(
                                "Get Started",
                                style: TextStyle(fontSize: 18, color: getColorSkin().backgroundColor),
                              ),
                            ),

                            SizedBox(height: 20.h),
                            Center(
                              child: Text(
                                "Or sign up with",
                                style: TextStyle(color: getColorSkin().grey, fontSize: 16),
                              ),
                            ),
                            SizedBox(height: 20.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: getColorSkin().backgroundColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        side: BorderSide(color: getColorSkin().lightGrey400)),
                                  ),
                                  icon: Icon(Icons.g_mobiledata, color: getColorSkin().black),
                                  label: Text("Continue with Google",
                                      style: TextStyle(color: getColorSkin().black)),
                                ),

                              ],
                            ),

                            SizedBox(height: 20),

                            // Continue as Guest
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                "Continue as Guest",
                                style: TextStyle(
                                    fontSize: 16, color: getColorSkin().black),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
