import 'package:flutter/material.dart';
import 'package:flutter_community_ibague/src/notifiers/event_notifier.dart';
import 'package:flutter_community_ibague/src/notifiers/events_notifier.dart';
import 'package:flutter_community_ibague/src/ui/widgets/event_widget.dart';
import 'package:provider/provider.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<EventsNotifier>();
    final bigScreen = MediaQuery.sizeOf(context).width > 1000;
    return ListView(
      children: [
        // Image.asset(AppAssets.banner),
        Text(
          'Próximos eventos',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: bigScreen ? 30 : 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Wrap(alignment: WrapAlignment.center, children: [
          ...state.events
              .map(
                (event) => ChangeNotifierProvider(
                  create: (_) => EventNotifier(eventId: event.id),
                  child: EventWidget(event: event),
                ),
              )
              .toList(),
          ...state.events
              .map(
                (event) => ChangeNotifierProvider(
                  create: (_) => EventNotifier(eventId: event.id),
                  child: EventWidget(event: event),
                ),
              )
              .toList(),
          ...state.events
              .map(
                (event) => ChangeNotifierProvider(
                  create: (_) => EventNotifier(eventId: event.id),
                  child: EventWidget(event: event),
                ),
              )
              .toList(),
        ])
      ],
    );
  }
}
