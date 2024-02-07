import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_community_ibague/src/notifiers/auth_notifier.dart';
import 'package:flutter_community_ibague/src/notifiers/events_notifier.dart';
import 'package:flutter_community_ibague/src/ui/screens/events_screen.dart';
import 'package:flutter_community_ibague/src/ui/screens/home_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

final providers = [EmailAuthProvider()];

class Routes {
  static const profile = '/profile';
  static const signIn = '/sign_in';
  static const notLogged = '/not_logged';
  static const events = '/events';
}

final GoRouter appRouter = GoRouter(
  initialLocation: Routes.events,
  routes: <RouteBase>[
    ShellRoute(
        builder: (context, state, child) {
          return MultiProvider(providers: [
            ChangeNotifierProvider(
              create: (_) => EventsNotifier(),
            ),
            ChangeNotifierProvider(
              create: (_) => AuthNotifier(),
            ),
          ], child: HomeScreen(page: child));
        },
        routes: [
          GoRoute(
            path: Routes.events,
            builder: (context, state) {
              return EventsScreen();
            },
          ),
          GoRoute(
            path: Routes.profile,
            builder: (context, state) {
              return ProfileScreen(
                avatar: const SizedBox(),
                actions: [
                  //   SignedOutAction((_) => context.go(Routes.start)),
                ],
              );
            },
          ),
        ]),
    GoRoute(
      path: Routes.signIn,
      builder: (context, state) {
        return SignInScreen(
          showPasswordVisibilityToggle: true,
          actions: [
            AuthStateChangeAction<SignedIn>((context, state) {
              context.pop();
            }),
            AuthStateChangeAction<UserCreated>((context, state) {
              context.pop();
            }),
          ],
        );
      },
    ),
  ],
);
