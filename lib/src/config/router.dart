import 'package:flutter_community_ibague/src/notifiers/auth_notifier.dart';
import 'package:flutter_community_ibague/src/notifiers/events_notifier.dart';
import 'package:flutter_community_ibague/src/ui/screens/events_screen.dart';
import 'package:flutter_community_ibague/src/ui/screens/home_screen.dart';
import 'package:flutter_community_ibague/src/ui/screens/person_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class Routes {
  static const person = '/person';
  static const notLogged = '/not_logged';
  static const events = '/events';
}

final GoRouter appRouter = GoRouter(
  initialLocation: Routes.events,
  routes: <RouteBase>[
    ShellRoute(
      builder: (context, state, child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (_) => EventsNotifier(),
            ),
            ChangeNotifierProvider(
              create: (_) => AuthNotifier(),
            ),
          ],
          child: HomeScreen(
            child: child,
          ),
        );
      },
      routes: [
        GoRoute(
          name: Routes.events,
          path: Routes.events,
          builder: (context, state) {
            return const EventsScreen();
          },
        ),
        GoRoute(
          name: Routes.person,
          path: Routes.person,
          builder: (context, state) {
            return const PersonScreen();
          },
        ),
      ],
    ),
  ],
);
