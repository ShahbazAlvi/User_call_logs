// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:infinity/View/Auths/Login_screen.dart';
// import 'package:infinity/compoents/AppButton.dart';
// import 'package:infinity/compoents/AppTextfield.dart';
// import 'package:provider/provider.dart';
//
// import '../../Provider/SignUpProvider.dart';
//
// class SignUp extends StatefulWidget {
//   const SignUp({super.key});
//
//   @override
//   State<SignUp> createState() => _SignUpState();
// }
//
// class _SignUpState extends State<SignUp> {
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (_) => SignUpProvider(),
//       builder: (context, _) {
//         final provider = Provider.of<SignUpProvider>(context);
//
//         return Scaffold(
//           body: SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 children: [
//                   const SizedBox(height: 40),
//                   const Text(
//                     "Call Logs SignUp",
//                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
//                   ),
//                   const SizedBox(height: 10),
//                   AppTextField(
//                     controller: provider.fullnameController,
//                     label: 'Full Name',
//                     validator: (value) =>
//                     value!.isEmpty ? 'Enter your name' : null,
//                     icon: Icons.person,
//                   ),
//                   const SizedBox(height: 10),
//                   AppTextField(
//                     controller: provider.usernameController,
//                     label: 'User Name',
//                     validator: (value) =>
//                     value!.isEmpty ? 'Enter username' : null,
//                     icon: Icons.person,
//                   ),
//                   const SizedBox(height: 10),
//                   AppTextField(
//                     controller: provider.emailController,
//                     label: 'Email',
//                     validator: (value) =>
//                     value!.isEmpty ? 'Enter email' : null,
//                     icon: Icons.email,
//                   ),
//                   const SizedBox(height: 10),
//                   AppTextField(
//                     controller: provider.passwordController,
//                     label: "Password",
//                     validator: (value) =>
//                     value!.isEmpty ? 'Enter password' : null,
//                     icon: Icons.password,
//                   ),
//                   const SizedBox(height: 10),
//                   AppTextField(
//                     controller: provider.cpasswordController,
//                     label: 'Confirm Password',
//                     validator: (value) =>
//                     value!.isEmpty ? 'Enter confirm password' : null,
//                     icon: Icons.password,
//                   ),
//                   const SizedBox(height: 20),
//                   AppButton(
//                     title: provider.isLoading ? 'Loading...' : 'Sign Up',
//                     press: () async {
//                       final result = await provider.signUp(context);
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(content: Text(provider.message)),
//                       );
//                     },
//                     width: double.infinity,
//                   ),
//                   const SizedBox(height: 20),
//                   RichText(text: TextSpan(
//                     text: "Already have an account?",
//                     style: const TextStyle(
//                       color: Colors.black87,
//                       fontSize: 16,
//                     ),
//                     children: [
//                       TextSpan(
//                         text: 'Sign In',
//                         style: const TextStyle(
//                           color: Colors.blue, // clickable text color
//                           fontWeight: FontWeight.bold,
//                         ),
//                         recognizer: TapGestureRecognizer()
//                           ..onTap = () {
//                             // 👇 navigate to your sign-up screen
//                             Navigator.pushReplacement(context,MaterialPageRoute(builder:(context)=>LoginScreen()));
//                           },
//                       ),
//                     ],
//                   ))
//
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
//



import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:infinity/View/Auths/Login_screen.dart';
import 'package:infinity/compoents/AppButton.dart';
import 'package:infinity/compoents/AppTextfield.dart';
import 'package:provider/provider.dart';
import '../../Provider/SignUpProvider.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return ChangeNotifierProvider(
      create: (_) => SignUpProvider(),
      builder: (context, _) {
        final provider = Provider.of<SignUpProvider>(context);

        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Back Button (Optional)
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.arrow_back_ios_new, size: 20, color: Color(0xFF666666)),
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                    ),
                    SizedBox(height: screenHeight * 0.02),

                    // Header Section
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Create Account',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1A1A1A),
                            letterSpacing: -0.5,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Fill in your details to get started",
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF666666),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.04),

                    // Form Section
                    Column(
                      children: [
                        // Full Name Field
                        buildFieldWithLabel(
                          label: 'Full Name',
                          child: AppTextField(
                            controller: provider.fullnameController,
                            label: 'Enter name',
                            validator: (value) =>
                            value!.isEmpty ? 'Enter your name' : null,
                            icon: Icons.person_outline,
                            // filled: true,
                            // fillColor: Color(0xFFF8F9FA),
                          ),
                        ),
                        SizedBox(height: 16),

                        // Username Field
                        buildFieldWithLabel(
                          label: 'Username',
                          child: AppTextField(
                            controller: provider.usernameController,
                            label: 'Enter username',
                            validator: (value) =>
                            value!.isEmpty ? 'Enter username' : null,
                            icon: Icons.alternate_email,
                            // filled: true,
                            // fillColor: Color(0xFFF8F9FA),
                          ),
                        ),
                        SizedBox(height: 16),

                        // Email Field
                        buildFieldWithLabel(
                          label: 'Email Address',
                          child: AppTextField(
                            controller: provider.emailController,
                            label: 'Enter email',
                            validator: (value) =>
                            value!.isEmpty ? 'Enter email' : null,
                            icon: Icons.email_outlined,
                            // filled: true,
                            // fillColor: Color(0xFFF8F9FA),
                          ),
                        ),
                        SizedBox(height: 16),

                        // Password Field
                        buildFieldWithLabel(
                          label: 'Password',
                          child: AppTextField(
                            controller: provider.passwordController,
                            label: "Create a strong password",
                            validator: (value) =>
                            value!.isEmpty ? 'Enter password' : null,
                            icon: Icons.lock_outline,
                            // isPassword: true,
                            // suffixIcon: Icons.visibility_off,
                            // filled: true,
                            // fillColor: Color(0xFFF8F9FA),
                          ),
                        ),
                        SizedBox(height: 16),

                        // Confirm Password Field
                        buildFieldWithLabel(
                          label: 'Confirm Password',
                          child: AppTextField(
                            controller: provider.cpasswordController,
                            label: 'Re-enter your password',
                            validator: (value) =>
                            value!.isEmpty ? 'Enter confirm password' : null,
                            icon: Icons.lock_outline,
                            // isPassword: true,
                            // suffixIcon: Icons.visibility_off,
                            // filled: true,
                            // fillColor: Color(0xFFF8F9FA),
                          ),
                        ),
                        SizedBox(height: 8),

                        // Password Requirements

                        SizedBox(height: screenHeight * 0.04),

                        // Sign Up Button
                        provider.isLoading
                            ? Container(
                          width: double.infinity,
                          height: 56,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    valueColor: AlwaysStoppedAnimation(Colors.white),
                                  ),
                                ),
                                SizedBox(width: 12),
                                Text(
                                  'Creating Account...',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                            : Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.withOpacity(0.3),
                                blurRadius: 15,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: () async {
                              final result = await provider.signUp(context);
                              if (provider.message.isNotEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(provider.message),
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              minimumSize: Size(double.infinity, 56),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                              textStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.person_add_alt_1, size: 20),
                                SizedBox(width: 8),
                                Text('Create Account'),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.04),

                        // Divider


                        // Social Login Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Google Button


                            // Apple Button

                          ],
                        ),
                        SizedBox(height: screenHeight * 0.04),

                        // Sign In Link
                        Center(
                          child: RichText(
                            text: TextSpan(
                              text: "Already have an account? ",
                              style: TextStyle(
                                color: Color(0xFF666666),
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Sign In',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => LoginScreen()),
                                      );
                                    },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildFieldWithLabel({required String label, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF4A4A4A),
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: child,
        ),
      ],
    );
  }
}