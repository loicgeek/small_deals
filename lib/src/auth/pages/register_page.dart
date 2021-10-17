import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:small_deals/home_page.dart';
import 'package:small_deals/src/auth/auth_service.dart';
import 'package:small_deals/src/utils/app_colors.dart';
import 'package:small_deals/src/utils/app_routes.dart';
import 'package:small_deals/src/utils/validators.dart';
import 'package:small_deals/src/widgets/app_back_button.dart';
import 'package:small_deals/src/widgets/app_button.dart';
import 'package:small_deals/src/widgets/app_input.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late AuthService _authService;
  String? error;

  bool isLoading = false;

  @override
  void initState() {
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _authService = AuthService();
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        title: const Text("Create Account"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
            child: Column(
              children: [
                // Padding(
                //   padding: const EdgeInsets.symmetric(
                //     vertical: 20.0,
                //     horizontal: 10,
                //   ),
                //   child: Image.asset("assets/images/bongalo.png"),
                // ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20.0,
                    horizontal: 10,
                  ),
                  child: Text("Let’s get to know you better"),
                ),
                SizedBox(
                  height: 20,
                ),
                AppInput(
                  controller: _usernameController,
                  label: "Username",
                  placeholder: "Enter username",
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

                if (isLoading)
                  const Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    ),
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

                AppButton(
                  text: "Create Account",
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        setState(() {
                          isLoading = true;
                          error = null;
                        });
                        var user =
                            await _authService.registerWithEmailAndPassword(
                          email: _emailController.text,
                          password: _passwordController.text,
                          username: _usernameController.text,
                        );
                        setState(() {
                          isLoading = false;
                        });
                        setRoot(context, const HomePage());
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'weak-password') {
                          print('The password provided is too weak.');
                        } else if (e.code == 'email-already-in-use') {
                          print('The account already exists for that email.');
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
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: RichText(
                    text: TextSpan(
                      text: "Already have an account? ",
                      style: TextStyle(
                        color: AppColors.primaryGrayText,
                      ),
                      children: [
                        TextSpan(
                          text: "Login ",
                          style: TextStyle(
                            color: AppColors.primary,
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
    );
  }
}
