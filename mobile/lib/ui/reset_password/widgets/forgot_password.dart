
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/blocs/reset_password/reset_password_bloc.dart';
import 'package:mobile/data/repositories/auth_repository.dart';
import 'package:mobile/ui/core/theme/theme.dart';
import 'package:mobile/ui/reset_password/widgets/pin_code.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  ForgotPasswordScreen({super.key});
  final AuthRepository authRepository = GetIt.instance<AuthRepository>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getColorSkin().backgroundColor,
      appBar: AppBar(
        title: const Text("Forgot Password"),
        backgroundColor: getColorSkin().backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: getColorSkin().brown),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocProvider<ResetPasswordBloc>(
        create: (context) => ResetPasswordBloc(authRepository),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Forgot Password",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: getColorSkin().backgroundColor,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                "Please enter your email account to send the link verification to reset your password.",
                style: TextStyle(
                  fontSize: 16,
                  color: getColorSkin().grey,
                ),
              ),
              SizedBox(height: 30.h),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(color: getColorSkin().lightGrey700),
                decoration: InputDecoration(
                  hintText: "Email Address",
                  hintStyle: TextStyle(color: getColorSkin().lightGrey700),
                  prefixIcon: Icon(Icons.email_outlined, color: getColorSkin().lightGrey400),
                  filled: true,
                  fillColor: getColorSkin().backgroundColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: getColorSkin().lightGrey700, width: 2),
                  ),
                ),
              ),
              Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => PinCode()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: getColorSkin().accentColor,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Send Email",
                    style: TextStyle(fontSize: 18, color: getColorSkin().backgroundColor),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
