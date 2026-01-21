// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:infinity/Provider/login_provider.dart';
// import 'package:infinity/View/Auths/Sign_up.dart';
// import 'package:infinity/compoents/AppButton.dart';
// import 'package:infinity/compoents/AppTextfield.dart';
// import 'package:provider/provider.dart';
//
// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});
//
//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   @override
//   Widget build(BuildContext context) {
//     final loginProvider = Provider.of<LoginProvider>(context);
//     final screenHeight=MediaQuery.of(context).size.height;
//     final screenWidth=MediaQuery.of(context).size.width;
//     return Scaffold(
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(height:screenHeight*0.07),
//               Text('Admin Login',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
//               Text("Login to continue"),
//               SizedBox(height: screenHeight*0.02,),
//               AppTextField(controller: loginProvider.emailController, label: 'Email',icon: Icons.email,
//                 validator: (value) => value!.isEmpty ? 'Enter Email' : null,),
//               SizedBox(height: screenHeight*0.02,),
//               AppTextField(controller: loginProvider.passwordController, label: 'password',icon: Icons.password,icons: Icons.visibility_off,
//                 validator: (value) => value!.isEmpty ? 'Enter PassWord' : null,),
//               SizedBox(height: screenHeight*0.02,),
//               loginProvider.isLoading?
//                   Center(
//                     child: CircularProgressIndicator(),
//                   ):
//               AppButton(title: 'Login', press: (){
//                 loginProvider.login(context);
//               }, width: double.infinity),
//               SizedBox(height: screenHeight * 0.02),
//               if(loginProvider.message.isNotEmpty)
//                 Center(child: Text(loginProvider.message,style: TextStyle(color: Colors.red),),),
//               RichText(text: TextSpan(
//                 text: "Don't have an account? ",
//                 style: const TextStyle(
//                   color: Colors.black87,
//                   fontSize: 16,
//                 ),
//                 children: [
//                   TextSpan(
//                     text: 'Sign up',
//                     style: const TextStyle(
//                       color: Colors.blue, // clickable text color
//                       fontWeight: FontWeight.bold,
//                     ),
//                     recognizer: TapGestureRecognizer()
//                       ..onTap = () {
//                         // 👇 navigate to your sign-up screen
//                         Navigator.pushReplacement(context,MaterialPageRoute(builder:(context)=>SignUp()));
//                       },
//                   ),
//                 ],
//               ))
//
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:infinity/Provider/login_provider.dart';
import 'package:infinity/View/Auths/Sign_up.dart';
import 'package:infinity/compoents/AppButton.dart';
import 'package:infinity/compoents/AppTextfield.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.08),

                // Back button for navigation if needed
                // IconButton(
                //   onPressed: () => Navigator.pop(context),
                //   icon: Icon(Icons.arrow_back_ios_new, size: 20),
                //   padding: EdgeInsets.zero,
                //   constraints: BoxConstraints(),
                // ),
                // SizedBox(height: 20),

                // Header Section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Admin Login',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1A1A1A),
                        letterSpacing: -0.5,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Login to continue to your dashboard",
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF666666),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.06),

                // Form Section
                Column(
                  children: [
                    // Email Field
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Email',
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
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: AppTextField(
                            controller: loginProvider.emailController,
                            label: 'Enter your email',
                            icon: Icons.email_outlined,
                            validator: (value) => value!.isEmpty ? 'Enter Email' : null,
                            // filled: true,
                            // fillColor: Colors.white,
                            // borderRadius: 12,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.025),

                    // Password Field
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Password',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF4A4A4A),
                              ),
                            ),

                          ],
                        ),
                        SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: AppTextField(
                            controller: loginProvider.passwordController,
                            label: 'Enter your password',
                            icon: Icons.lock_outline,
                            icons: Icons.visibility_off,
                            validator: (value) => value!.isEmpty ? 'Enter Password' : null,
                            // filled: true,
                            // fillColor: Colors.white,
                            // borderRadius: 12,
                            // isPassword: true,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.04),

                    // Error Message
                    if (loginProvider.message.isNotEmpty)
                      AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        width: double.infinity,
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red.withOpacity(0.2)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.error_outline, color: Colors.red, size: 18),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                loginProvider.message,
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    SizedBox(height: loginProvider.message.isNotEmpty ? 16 : 0),

                    // Login Button
                    loginProvider.isLoading
                        ? Container(
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          ),
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
                        onPressed: () => loginProvider.login(context),
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
                        child: Text('Login'),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.04),

                    // Sign Up Section
                    Center(
                      child: RichText(
                        text: TextSpan(
                          text: "Don't have an account? ",
                          style: TextStyle(
                            color: Color(0xFF666666),
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                          children: [
                            TextSpan(
                              text: 'Sign up',
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.w700,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) => SignUp()),
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
  }
}
