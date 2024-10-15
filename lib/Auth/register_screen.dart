// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:instagram/Auth/login_screen.dart';
// import 'package:instagram/bottom_nav_bar.dart';
//
// class RegistrationScreen extends StatelessWidget {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//
//   Future<void> _registerUser(BuildContext context) async {
//     if (_formKey.currentState?.validate() ?? false) {
//       String email = _emailController.text.trim();
//       String username = _usernameController.text.trim();
//       String password = _passwordController.text.trim();
//
//       try {
//         UserCredential userCredential =
//             await FirebaseAuth.instance.createUserWithEmailAndPassword(
//           email: email,
//           password: password,
//         );
//
//         final User? user = userCredential.user;
//         if (user != null) {
//           await FirebaseFirestore.instance
//               .collection('InstaUser')
//               .doc(user.uid)
//               .set({
//             'email': email,
//             'username': username,
//             'pronouns': '',
//             'bio': '',
//           });
//
//           Fluttertoast.showToast(
//             msg: 'Registration successful',
//             toastLength: Toast.LENGTH_SHORT,
//             gravity: ToastGravity.BOTTOM,
//             backgroundColor: Colors.black,
//             textColor: Colors.white,
//             fontSize: 16.0,
//           );
//
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(
//               builder: (context) => const BottomNavBar(),
//             ),
//           );
//         }
//       } catch (e) {
//         Fluttertoast.showToast(
//           msg: 'Error: $e',
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.BOTTOM,
//           backgroundColor: Colors.black,
//           textColor: Colors.white,
//           fontSize: 16.0,
//         );
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final screenSize = MediaQuery.of(context).size;
//     final isPortrait =
//         MediaQuery.of(context).orientation == Orientation.portrait;
//
//     return SafeArea(
//       child: Scaffold(
//         body: SingleChildScrollView(
//           child: Padding(
//             padding: EdgeInsets.symmetric(
//               horizontal: screenSize.width * 0.05,
//               vertical: screenSize.height * 0.02,
//             ),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: <Widget>[
//                   SizedBox(
//                     height: screenSize.height * 0.1,
//                   ),
//                   Center(
//                     child: Image.asset(
//                       'assets/images/instagram.png',
//                       scale: isPortrait ? 8 : 12,
//                     ),
//                   ),
//                   SizedBox(height: screenSize.height * 0.02),
//                   Text(
//                     'Create an account',
//                     style: TextStyle(
//                       fontSize: screenSize.width * 0.07,
//                       fontWeight: FontWeight.bold,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                   SizedBox(height: screenSize.height * 0.02),
//                   TextFormField(
//                     controller: _emailController,
//                     decoration: InputDecoration(
//                       hintText: "Email",
//                       border: OutlineInputBorder(
//                         borderRadius:
//                             BorderRadius.circular(screenSize.width * 0.03),
//                       ),
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter an email';
//                       }
//                       if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
//                         return 'Please enter a valid email';
//                       }
//                       return null;
//                     },
//                   ),
//                   SizedBox(height: screenSize.height * 0.01),
//                   TextFormField(
//                     controller: _usernameController,
//                     decoration: InputDecoration(
//                       hintText: "Username",
//                       border: OutlineInputBorder(
//                         borderRadius:
//                             BorderRadius.circular(screenSize.width * 0.03),
//                       ),
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter a username';
//                       }
//                       return null;
//                     },
//                   ),
//                   SizedBox(height: screenSize.height * 0.01),
//                   TextFormField(
//                     controller: _passwordController,
//                     obscureText: true,
//                     decoration: InputDecoration(
//                       hintText: "Password",
//                       border: OutlineInputBorder(
//                         borderRadius:
//                             BorderRadius.circular(screenSize.width * 0.03),
//                       ),
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter a password';
//                       }
//                       if (value.length < 6) {
//                         return 'Password must be at least 6 characters long';
//                       }
//                       return null;
//                     },
//                   ),
//                   SizedBox(height: screenSize.height * 0.02),
//                   MaterialButton(
//                     child: Text(
//                       "Sign Up",
//                       style: TextStyle(
//                           color: Colors.white,
//                           fontSize: screenSize.width * 0.05),
//                     ),
//                     height: screenSize.height * 0.07,
//                     minWidth: screenSize.width * 0.9,
//                     color: Colors.lightBlue,
//                     shape: RoundedRectangleBorder(
//                       borderRadius:
//                           BorderRadius.circular(screenSize.width * 0.07),
//                     ),
//                     onPressed: () => _registerUser(context),
//                   ),
//                   SizedBox(height: screenSize.height * 0.01),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const Text('Already have an account?'),
//                       TextButton(
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => LogInScreen(),
//                             ),
//                           );
//                         },
//                         child: const Text("Log In"),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:instagram/Auth/login_screen.dart';
import 'package:instagram/bottom_nav_bar.dart';
import 'package:instagram/controllers/home_controller.dart';

class RegistrationScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  static const String defaultProfileImageUrl =
      'https://example.com/default_profile_image.png';

  Future<void> _registerUser(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      String email = _emailController.text.trim();
      String username = _usernameController.text.trim();
      String password = _passwordController.text.trim();

      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        final User? user = userCredential.user;
        if (user != null) {
          await FirebaseFirestore.instance
              .collection('InstaUser')
              .doc(user.uid)
              .set({
            'email': email,
            'username': username,
            'imageUrl': defaultProfileImageUrl,
            'pronouns': '',
            'bio': '',
          });

          Fluttertoast.showToast(
            msg: 'Registration successful',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0,
          );

          HomeController homeController = Get.put(HomeController());
          await homeController.fetchProfile();

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => BottomNavBar(),
            ),
          );
        }
      } catch (e) {
        Fluttertoast.showToast(
          msg: 'Error: $e',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenSize.width * 0.05,
              vertical: screenSize.height * 0.02,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(
                    height: screenSize.height * 0.1,
                  ),
                  Center(
                    child: Image.asset(
                      'assets/images/instagram.png',
                      scale: isPortrait ? 8 : 12,
                    ),
                  ),
                  SizedBox(height: screenSize.height * 0.02),
                  Text(
                    'Create an account',
                    style: TextStyle(
                      fontSize: screenSize.width * 0.07,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: screenSize.height * 0.02),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: "Email",
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(screenSize.width * 0.03),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an email';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: screenSize.height * 0.01),
                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      hintText: "Username",
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(screenSize.width * 0.03),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a username';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: screenSize.height * 0.01),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "Password",
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(screenSize.width * 0.03),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: screenSize.height * 0.02),
                  ElevatedButton(
                    onPressed: () => _registerUser(context),
                    child: Text('Register'),
                  ),
                  SizedBox(height: screenSize.height * 0.02),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LogInScreen(),
                        ),
                      );
                    },
                    child: Text('Already have an account? Login here!'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
