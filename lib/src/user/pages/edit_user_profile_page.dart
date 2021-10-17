import 'package:flutter/material.dart';
import 'package:small_deals/src/user/user_service.dart';
import 'package:small_deals/src/utils/validators.dart';
import 'package:small_deals/src/widgets/app_back_button.dart';
import 'package:small_deals/src/widgets/app_button.dart';
import 'package:small_deals/src/widgets/app_input.dart';

class EditUserProfilePage extends StatefulWidget {
  final Map<String, dynamic> data;
  final String id;
  const EditUserProfilePage({Key? key, required this.id, required this.data})
      : super(key: key);

  @override
  _EditUserProfilePageState createState() => _EditUserProfilePageState();
}

class _EditUserProfilePageState extends State<EditUserProfilePage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  late TextEditingController _firstnameController;
  late TextEditingController _lastnameController;
  late TextEditingController _ageController;

  String? error;

  bool isLoading = false;
  late String sex;

  @override
  void initState() {
    _usernameController =
        TextEditingController(text: widget.data['username'] ?? '');
    _emailController = TextEditingController(text: widget.data['email'] ?? '');
    _passwordController = TextEditingController();
    _ageController = TextEditingController(text: widget.data['age'] ?? '');
    _firstnameController =
        TextEditingController(text: widget.data['first_name'] ?? '');
    _lastnameController =
        TextEditingController(text: widget.data['last_name'] ?? '');
    sex = widget.data['sex'] ?? 'M';
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Map<String, dynamic> getData() {
    Map<String, dynamic> data = Map();
    data['username'] = _usernameController.text;
    data['email'] = _emailController.text;
    data['age'] = _ageController.text;
    data['first_name'] = _firstnameController.text;
    data['last_name'] = _lastnameController.text;
    data['sex'] = sex;
    return data;
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        title: const Text("Edit Profile"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
            child: Column(
              children: [
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
                  controller: _firstnameController,
                  label: "First name",
                  placeholder: "Enter First name",
                ),
                AppInput(
                  controller: _lastnameController,
                  label: "Last name",
                  placeholder: "Enter Last name",
                ),
                AppInput(
                  controller: _ageController,
                  label: "Age",
                  placeholder: "Enter your age",
                ),
                // AppInput(
                //   controller: _passwordController,
                //   label: "Password",
                //   placeholder: "Choose a password",
                //   validator: (value) {
                //     return Validators.required("Password", value);
                //   },
                //   obscureText: true,
                // ),
                const SizedBox(
                  height: 45,
                ),
                RadioListTile<String>(
                  value: 'M',
                  groupValue: sex,
                  title: Text("M"),
                  onChanged: (value) {
                    setState(() {
                      sex = value!;
                    });
                  },
                ),
                RadioListTile<String>(
                  value: 'F',
                  groupValue: sex,
                  title: Text("F"),
                  onChanged: (value) {
                    setState(() {
                      sex = value!;
                    });
                  },
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
                  text: "Save",
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        UserService().updateAccount(widget.id, getData());
                      } catch (e) {
                        print(e);
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
