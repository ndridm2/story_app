import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:story_app/data/locale/auth_local_datasource.dart';
import 'package:story_app/provider/login_provider.dart';
import 'package:story_app/service/api_service.dart';
import 'package:story_app/service/auth_service.dart';
import 'package:go_router_flow/go_router_flow.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          EdgeInsets currentPadding;

          if (constraints.maxWidth > 900) {
            currentPadding = const EdgeInsets.only(left: 200, right: 200);
          } else {
            currentPadding = const EdgeInsets.all(30);
          }

          return ChangeNotifierProvider<LoginProvider>(
            create: (_) => LoginProvider(
              apiService: ApiService(),
              authService: AuthService(
                locale: AuthLocalDatasource(
                  prefs: SharedPreferences.getInstance(),
                ),
              ),
            ),
            child: Container(
              padding: currentPadding,
              child: SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // --- Header Text ---
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Welcome Back!",
                                    style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    "Please Login to continue.",
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),

                        // --- Username & Password Textfield
                        const SizedBox(height: 40),
                        Consumer<LoginProvider>(
                          builder: (context, value, child) {
                            return Column(
                              children: [
                                TextField(
                                  controller: value.emailController,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black),
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(12),
                                        topLeft: Radius.circular(12),
                                        bottomLeft: Radius.circular(12),
                                        bottomRight: Radius.circular(12),
                                      ),
                                    ),
                                    hintText: "Email",
                                  ),
                                ),
                                const SizedBox(height: 20),
                                TextField(
                                  controller: value.passwordController,
                                  obscureText: value.isHide,
                                  decoration: InputDecoration(
                                    border: const OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black),
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(12),
                                        topLeft: Radius.circular(12),
                                        bottomLeft: Radius.circular(12),
                                        bottomRight: Radius.circular(12),
                                      ),
                                    ),
                                    hintText: "Password",
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        value.isHide
                                            ? Icons.remove_red_eye_outlined
                                            : Icons.remove_red_eye,
                                      ),
                                      onPressed: () {
                                        value.onChangeObscure();
                                      },
                                    ),
                                  ),
                                )
                              ],
                            );
                          },
                        ),

                        // --- Button Login ----
                        const SizedBox(height: 40),
                        Row(
                          children: [
                            Expanded(child: Consumer<LoginProvider>(
                              builder: (ctx, value, child) {
                                return ElevatedButton(
                                  onPressed: value.isLoading
                                      ? null
                                      : () {
                                          value.userLogin(context);
                                        },
                                  style: const ButtonStyle(
                                    backgroundColor:
                                        MaterialStatePropertyAll(Colors.black),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(18.0),
                                    child: value.isLoading
                                        ? const SizedBox(
                                            height: 20.0,
                                            width: 20.0,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                            ),
                                          )
                                        : const Text(
                                            "SIGN IN",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                  ),
                                );
                              },
                            )),
                          ],
                        ),

                        // --- Regsiter Page Offer ---
                        const SizedBox(height: 30),
                        Center(
                          child: RichText(
                            text: TextSpan(
                              text: "Don't have an account? ",
                              style: DefaultTextStyle.of(context).style,
                              children: <TextSpan>[
                                TextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => context.push("/register"),
                                  text: 'Sign Up',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ).copyWith(
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
