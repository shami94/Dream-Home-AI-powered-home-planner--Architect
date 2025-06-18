import 'package:dreamhome_architect/common_widgets.dart/custom_button.dart';
import 'package:dreamhome_architect/common_widgets.dart/custom_text_formfield.dart';
import 'package:dreamhome_architect/features/home_screen.dart';
import 'package:dreamhome_architect/features/signin/signin_screen.dart';
import 'package:dreamhome_architect/features/signup/signup_second_screen.dart';
import 'package:dreamhome_architect/theme/app_theme.dart';
import 'package:dreamhome_architect/util/value_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../common_widgets.dart/custom_alert_dialog.dart';
import 'sign_up_bloc/sign_up_bloc.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _fullnameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isObscure = true;

  @override
  void initState() {
    Future.delayed(
        const Duration(
          milliseconds: 100,
        ), () {
      User? currentUser = Supabase.instance.client.auth.currentUser;
      if (currentUser != null &&
          currentUser.appMetadata['role'] == 'architect') {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignUpBloc(),
      child: BlocConsumer<SignUpBloc, SignUpState>(
        listener: (context, state) {
          if (state is SignUpFailureState) {
            showDialog(
              context: context,
              builder: (context) => CustomAlertDialog(
                title: 'Failure',
                description: state.message,
                primaryButton: 'Try Again',
                onPrimaryPressed: () {
                  Navigator.pop(context);
                },
              ),
            );
          } else if (state is SignUpSuccessState) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => SignupSecondScreen(
                  signupDetails: {
                    'email': _emailController.text.trim(),
                    'name': _fullnameController.text.trim(),
                    'phone': _phoneController.text.trim(),
                  },
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(32),
                        bottomRight: Radius.circular(32),
                      ),
                      child: Image.asset(
                        'assets/images/cover_photo.jpg',
                        height: MediaQuery.of(context).size.width,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Create New Account',
                            style: TextStyle(fontSize: 25),
                          ),
                          SizedBox(height: 15),
                          Text(
                            'Full Name',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          SizedBox(height: 5),
                          CustomTextFormField(
                            isLoading: state is SignUpLoadingState,
                            labelText: 'Full name',
                            controller: _fullnameController,
                            validator: alphabeticWithSpaceValidator,
                          ),
                          SizedBox(height: 15),
                          Text(
                            'Phone',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          SizedBox(height: 5),
                          CustomTextFormField(
                            isLoading: state is SignUpLoadingState,
                            labelText: 'Phone',
                            controller: _phoneController,
                            validator: phoneNumberValidator,
                          ),
                          SizedBox(height: 15),
                          Text(
                            'Email',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          SizedBox(height: 5),
                          CustomTextFormField(
                            isLoading: state is SignUpLoadingState,
                            labelText: 'Email',
                            controller: _emailController,
                            validator: emailValidator,
                          ),
                          SizedBox(height: 15),
                          Text(
                            'Password',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          SizedBox(height: 5),
                          TextFormField(
                              enabled: state is! SignUpLoadingState,
                              controller: _passwordController,
                              obscureText: isObscure,
                              validator: passwordValidator,
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      isObscure = !isObscure;
                                      setState(() {});
                                    },
                                    icon: Icon(isObscure
                                        ? Icons.visibility_off
                                        : Icons.visibility)),
                                border: const OutlineInputBorder(),
                                hintText: 'Password',
                              )),
                          SizedBox(height: 15),
                          CustomButton(
                            isLoading: state is SignUpLoadingState,
                            inverse: true,
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                BlocProvider.of<SignUpBloc>(context).add(
                                  SignUpUserEvent(
                                    email: _emailController.text.trim(),
                                    password: _passwordController.text.trim(),
                                  ),
                                );
                              }
                            },
                            label: 'Next',
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Already have an account?",
                                style: TextStyle(
                                  color: primaryColor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SigninScreen(),
                                    ),
                                  );
                                },
                                child: Text(
                                  "Sign in",
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
