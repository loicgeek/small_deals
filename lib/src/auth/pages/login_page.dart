import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:small_deals/home_page.dart';
import 'package:small_deals/src/auth/auth_service.dart';
import 'package:small_deals/src/auth/pages/register_page.dart';
import 'package:small_deals/src/utils/app_colors.dart';
import 'package:small_deals/src/utils/validators.dart';
import 'package:small_deals/src/widgets/app_button.dart';
import 'package:small_deals/src/widgets/app_input.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late AuthService _authService;
  String? error;

  bool isLoading = false;

  @override
  void initState() {
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _authService = AuthService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                height: screenHeight,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 20,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: screenHeight * .12,
                    ),
                    RichText(
                      text: TextSpan(
                        text: "Book ",
                        style: TextStyle(
                          fontSize: 37,
                          fontWeight: FontWeight.w700,
                          letterSpacing: .2,
                          color: Colors.black,
                        ),
                        children: [
                          TextSpan(
                            text: "ahead ",
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 37,
                              fontWeight: FontWeight.w700,
                              letterSpacing: .2,
                            ),
                          ),
                          TextSpan(
                            text: "your next trip or vacation",
                            style: TextStyle(
                              fontSize: 37,
                              fontWeight: FontWeight.w700,
                              height: 1,
                              letterSpacing: .2,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    AppInput(
                      controller: _emailController,
                      label: "Email",
                      placeholder: "Enter email address",
                      validator: (value) {
                        return Validators.required("Email", value);
                      },
                    ),
                    AppInput(
                      controller: _passwordController,
                      label: "Password",
                      placeholder: "Choose a password",
                      validator: (value) {
                        return Validators.required("Password", value);
                      },
                      obscureText: true,
                    ),
                    const SizedBox(
                      height: 45,
                    ),
                    if (error != null)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          error!,
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      ),
                    if (isLoading)
                      const Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    Expanded(
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppButton(
                              text: "Login",
                              bgColor: Colors.black,
                              textColor: Colors.white,
                              onTap: () async {
                                if (_formKey.currentState!.validate()) {
                                  try {
                                    setState(() {
                                      isLoading = true;
                                      error = null;
                                    });
                                    var user = await _authService
                                        .loginWithEmailAndPassword(
                                      email: _emailController.text,
                                      password: _passwordController.text,
                                    );
                                    setState(() {
                                      isLoading = false;
                                    });
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const HomePage()));
                                  } on FirebaseAuthException catch (e) {
                                    if (e.code == 'weak-password') {
                                      print(
                                          'The password provided is too weak.');
                                    } else if (e.code ==
                                        'email-already-in-use') {
                                      print(
                                          'The account already exists for that email.');
                                    }

                                    setState(() {
                                      isLoading = false;
                                      error = e.message;
                                    });
                                  } catch (e) {
                                    print(e);
                                    setState(() {
                                      isLoading = false;
                                      e.toString();
                                    });
                                  }
                                }
                              },
                            ),
                            AppButton(
                              text: "Create Account",
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const RegisterPage(),
                                  ),
                                );
                              },
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 17.0),
                              child: Text(
                                "Or",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            AppButton(
                              text: "Continue with Google",
                              bgColor: Colors.white,
                              textColor: AppColors.primaryText,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
