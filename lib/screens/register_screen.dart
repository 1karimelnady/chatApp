import 'package:chat_app/common_widgets/custom_button.dart';
import 'package:chat_app/common_widgets/custom_text_field.dart';
import 'package:chat_app/common_widgets/navigete_To.dart';
import 'package:chat_app/common_widgets/show_snack_bar.dart';
import 'package:chat_app/constants.dart';
import 'package:chat_app/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:chat_app/screens/chat_screen.dart';

// ignore: must_be_immutable
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  bool isPassword = true;

  IconData iconData = Icons.visibility_off_outlined;

  var formKey = GlobalKey<FormState>();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
          backgroundColor: kPrimaryColor,
          body: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            child: Image.asset(
                                width: 100,
                                height: 80,
                                fit: BoxFit.cover,
                                'assets/images/download.png'),
                          ),
                          const Text(
                            'Chat',
                            style: TextStyle(
                              fontSize: 26,
                              color: Colors.white,
                              fontFamily: 'Pacifico',
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Register ',
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 15),
                              defaultFormField(
                                textEditingController: emailController,
                                textInputType: TextInputType.text,
                                perfix: Icons.email_outlined,
                                label: 'Email',
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Email must not be empty';
                                  }
                                  return null;
                                },
                                context: context,
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              defaultFormField(
                                textEditingController: passwordController,
                                textInputType: TextInputType.text,
                                ispassword: isPassword,
                                perfix: Icons.password_outlined,
                                suffix: isPassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                suffixpressed: () {
                                  setState(() {
                                    isPassword = !isPassword;
                                    isPassword
                                        ? iconData = Icons.visibility_outlined
                                        : iconData;
                                  });
                                },
                                label: 'Password',
                                validator: (String? value) {
                                  if (value!.isEmpty) {
                                    return 'Password must not be empty';
                                  }
                                  return null;
                                },
                                context: context,
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              defaultbutton(
                                  function: () async {
                                    if (formKey.currentState!.validate()) {
                                      isLoading = true;
                                      setState(() {});
                                      try {
                                        await userRegister();
                                        showSnackBar(context,
                                            'Email created Successfully');
                                        navigateTo(
                                            context,
                                            ChatScreen(
                                              email: emailController,
                                            ));
                                        navigateTo(context, LoginScreen());
                                      } on FirebaseAuthException catch (e) {
                                        if (e.code == 'weak-password') {
                                          showSnackBar(
                                              context, 'weak-password');
                                        } else if (e.code ==
                                            'email-already-in-use') {
                                          showSnackBar(
                                              context, 'Email already exist');
                                        }
                                      } catch (ex) {
                                        showSnackBar(
                                            context, 'There was an error');
                                      }
                                      isLoading = false;
                                      setState(() {});
                                    }
                                  },
                                  text: 'Register',
                                  radius: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Already have an account',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                    ),
                                    child: const Text('Login',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Color(0xffC7EDE6),
                                        )),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          )),
    );
  }

  Future<void> userRegister() async {
    UserCredential user =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text,
    );
  }
}
