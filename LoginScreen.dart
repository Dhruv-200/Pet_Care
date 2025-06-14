import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pet_care/HomeScreen.dart';
import 'package:pet_care/signup_page.dart';
import 'package:pet_care/extension.dart';

// Define the LoginScreen widget
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool passwordVisible = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Login(String email, String password) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (val) => false,
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message.toString()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('New to this app?'),
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => SignupScreen()),
              );
            },
            child: Text('Sign up'),
          ),
        ],
      )),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 60),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Login',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              SizedBox(
                height: 16,
              ),
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value?.isValidEmail() ?? false) {
                    return null;
                  }
                  return 'Please Enter Valid Email';
                },
                decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    )),
              ),
              SizedBox(
                height: 8,
              ),
              TextFormField(
                controller: passwordController,
                obscureText: !passwordVisible,
                validator: (value) {
                  if ((value?.length ?? 0) < 6) {
                    return 'Password must be at least 6 characters long';
                  } else if (value?.contains(RegExp(r'[A-Z]')) == false) {
                    return 'Password must contain at least one uppercase letter';
                  } else if (value?.contains(RegExp(r'[a-z]')) == false) {
                    return 'Password must contain at least one lowercase letter';
                  } else if (value?.contains(RegExp(r'[0-9]')) == false) {
                    return 'Password must contain at least one digit';
                  } else if ((value
                          ?.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]')) ==
                      false)) {
                    return 'Email must contain at least one special character';
                  }
                },
                decoration: InputDecoration(
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            passwordVisible = !passwordVisible;
                          });
                        },
                        icon: Icon(passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off)),
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    )),
              ),
              SizedBox(
                height: 12,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    backgroundColor: Colors.blueGrey,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      Login(emailController.text, passwordController.text);
                    }
                    print(emailController.text);
                    print(passwordController.text);
                  },
                  child: Text('Login'))
            ],
          ),
        ),
      ),
    );
  }
}
