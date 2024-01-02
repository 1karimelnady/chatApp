import 'package:chat_app/common_widgets/custom_button.dart';
import 'package:chat_app/common_widgets/custom_text_field.dart';
import 'package:chat_app/common_widgets/navigete_To.dart';
import 'package:chat_app/common_widgets/show_snack_bar.dart';
import 'package:chat_app/constants.dart';
import 'package:chat_app/screens/register_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:chat_app/screens/chat_screen.dart';

// ignore: must_be_immutable
class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
                                'Login ',
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              defaultFormField(
                                textEditingController: emailController,
                                textInputType: TextInputType.emailAddress,
                                perfix: Icons.email_outlined,
                                label: 'Email',
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Email must not be empty';
                                  }
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
                                },
                                context: context,
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              defaultbutton(
                                  // function: () async {
                                  //   if (formKey.currentState!.validate()) {
                                  //     isLoading = true;
                                  //     setState(() {});
                                  //     try {
                                  //       await userLogin();
                                  //       showSnackBar(
                                  //           context, 'Login successfully');
                                  //     } on FirebaseAuthException catch (e) {
                                  //       if (e.code == 'wrong-password') {
                                  //         showSnackBar(
                                  //             context, 'wrong-password');
                                  //       } else if (e.code == 'user-not-found') {
                                  //         print('not found');
                                  //         showSnackBar(
                                  //             context, 'Email not found');
                                  //       }
                                  //     } catch (ex) {
                                  //       print(ex);
                                  //       showSnackBar(
                                  //           context, 'There was an error');
                                  //     }
                                  //
                                  //     // print(emailController.text);
                                  //     // print(passwordController.text);
                                  //   }
                                  // },

                                  function: () async {
                                    if (formKey.currentState!.validate()) {
                                      isLoading = true;
                                      setState(() {});
                                      try {
                                        await userLogin();
                                        showSnackBar(
                                            context, 'Login  Successfully');
                                        navigateTo(
                                            context,
                                            ChatScreen(
                                              email: emailController,
                                            ));
                                      } on FirebaseAuthException catch (e) {
                                        showSnackBar(context, '${e.message}');
                                        print(
                                            'Firebase Auth Exception: ${e.message}');
                                        if (e.code == 'wrong-password') {
                                          showSnackBar(
                                              context, 'wrong-password');
                                        } else if (e.code == 'user-not-found') {
                                          showSnackBar(
                                              context, 'user not found');
                                        }
                                      } catch (ex) {
                                        print(ex);
                                        showSnackBar(
                                            context, 'There was an error');
                                      }
                                      isLoading = false;
                                      setState(() {});
                                    }
                                  },
                                  text: 'Login',
                                  radius: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Don`t have an account ? ',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      navigateTo(context, RegisterScreen());
                                    },
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                    ),
                                    child: const Text('Register',
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

  Future<void> userLogin() async {
    String email = emailController.text.trim();
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: passwordController.text,
    );
  }
}
