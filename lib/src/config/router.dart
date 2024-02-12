import 'package:flutter_community_ibague/src/models/event.dart';
import 'package:flutter_community_ibague/src/notifiers/auth_notifier.dart';
import 'package:flutter_community_ibague/src/notifiers/event_notifier.dart';
import 'package:flutter_community_ibague/src/notifiers/events_notifier.dart';
import 'package:flutter_community_ibague/src/ui/screens/event_detail_screen.dart';
import 'package:flutter_community_ibague/src/ui/screens/events_screen.dart';
import 'package:flutter_community_ibague/src/ui/screens/home_screen.dart';
import 'package:flutter_community_ibague/src/ui/screens/person_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class Routes {
  static const person = '/person';
  static const notLogged = '/not_logged';
  static const events = '/events';
  static const eventDetails = '/event-details';
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
            child: child,
          );
        },
        routes: [
          GoRoute(
            name: Routes.eventDetails,
            path: Routes.eventDetails,
            builder: (context, state) {
              final event = state.extra as Event;
              return ChangeNotifierProvider(
                  create: (_) => EventNotifier(event: event),
                  child: const EventDetailScreen());
            },
          ),
          ShellRoute(
            builder: (context, state, child) {
              return HomeScreen(
                child: child,
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
        ])
  ],
);
