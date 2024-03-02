import 'package:flutter/material.dart';
import 'package:story_app/data/locale/auth_local_datasource.dart';
import 'package:story_app/service/auth_service.dart';
import 'package:go_router_flow/go_router_flow.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_strategy/url_strategy.dart';

import 'ui/add_story_page.dart';
import 'ui/detail_page.dart';
import 'ui/home_page.dart';
import 'ui/login_page.dart';
import 'ui/register_page.dart';

void main() {
  setPathUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(
       brightness: Brightness.light,
       colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
        primaryColor: const Color(0xFF35C2C1),
      ),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,

      routerConfig: GoRouter(
        initialLocation: "/login",
        redirect: (context, GoRouterState state) async {
          if (state.location == "/login" || state.location == "/register") {
            final auth = AuthService(
              locale: AuthLocalDatasource(
                prefs: SharedPreferences.getInstance(),
              ),
            );

            if (await auth.isUserLogin()) {
              return "/home";
            } else {
              return null;
            }
          }

          return null;
        },
        routes: [
          GoRoute(
            path: "/login",
            builder: (context, state) => const LoginPage(),
          ),
          GoRoute(
            path: "/register",
            builder: (context, state) => const RegisterPage(),
          ),
          GoRoute(
            path: "/home",
            builder: (context, state) => const HomePage(),
            redirect: (context, state) async {
              final auth = AuthService(
                locale: AuthLocalDatasource(
                  prefs: SharedPreferences.getInstance(),
                ),
              );

              if (await auth.isUserLogin() == false) {
                return "/login";
              } else {
                return null;
              }
            },
          ),
          GoRoute(
            path: '/detail/:storyId',
            builder: (context, state) => DetailPage(
              restaurantId: state.params['storyId']!,
            ),
          ),
          GoRoute(
            path: '/add',
            builder: (context, state) => const AddStoryPage(),
          ),
        ],
      ),
    );
  }
}
