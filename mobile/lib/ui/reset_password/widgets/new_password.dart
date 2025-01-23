import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/ui/core/theme/theme.dart';


class NewPasswordScreen extends StatefulWidget {
  @override
  _NewPasswordScreenState createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  bool isPasswordMatch = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getColorSkin().backgroundColor, // Dark background color
      appBar: AppBar(
        backgroundColor: getColorSkin().backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: getColorSkin().backgroundColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "New Password",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: getColorSkin().backgroundColor,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              "Create a strong password for updating\nj*********0@gmail.com",
              style: TextStyle(
                fontSize: 16,
                color: getColorSkin().lightGrey300,
              ),
            ),
            SizedBox(height: 30.h),
            // Password Field
            _buildPasswordField("New Password", passwordController,
                isPasswordVisible, (value) {
                  setState(() {
                    isPasswordVisible = !isPasswordVisible;
                  });
                } as VoidCallback),
            SizedBox(height: 8.h),
            _buildPasswordStrength(),
            SizedBox(height: 16.h),
            // Confirm Password Field
            _buildPasswordField("Confirm Password", confirmPasswordController,
                isConfirmPasswordVisible, (value) {
                  setState(() {
                    isConfirmPasswordVisible = !isConfirmPasswordVisible;
                  });
                } as VoidCallback),
            if (!isPasswordMatch)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  "The password confirmation doesn’t match.",
                  style: TextStyle(color: getColorSkin().red, fontSize: 14),
                ),
              ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    isPasswordMatch = passwordController.text ==
                        confirmPasswordController.text;
                  });
                  if (isPasswordMatch) {
                    // Handle password reset logic
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: getColorSkin().accentColor, // Button color
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "Reset Password",
                  style: TextStyle(fontSize: 18, color: getColorSkin().backgroundColor),
                ),
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField(String label, TextEditingController controller,
      bool isVisible, VoidCallback toggleVisibility) {
    return TextField(
      controller: controller,
      obscureText: !isVisible,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: label,
        hintStyle: TextStyle(color: Colors.grey[400]),
        prefixIcon: Icon(Icons.lock_outline, color: Colors.grey[400]),
        suffixIcon: IconButton(
          icon: Icon(
            isVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey[400],
          ),
          onPressed: toggleVisibility,
        ),
        filled: true,
        fillColor: Color(0xFF23233D),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildPasswordStrength() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildStrengthIndicator("Min 6 characters", true),
        SizedBox(width: 10),
        _buildStrengthIndicator("Uppercase", true),
        SizedBox(width: 10),
        _buildStrengthIndicator("Lowercase", true),
      ],
    );
  }

  Widget _buildStrengthIndicator(String text, bool isMet) {
    return Row(
      children: [
        Icon(
          isMet ? Icons.check_circle : Icons.circle_outlined,
          color: isMet ? Colors.green : Colors.grey,
          size: 16,
        ),
        SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            color: isMet ? Colors.green : Colors.grey[400],
          ),
        ),
      ],
    );
  }
}
