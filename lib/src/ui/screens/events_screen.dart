import 'package:flutter/material.dart';
import 'package:flutter_community_ibague/src/config/app_assets.dart';
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
    return Column(
      children: [
        Image.asset(AppAssets.banner),
        Expanded(
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Text(
                'Próximos eventos',
                style: TextStyle(
                  fontSize: bigScreen ? 30 : 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ...state.events
                  .map((event) => ChangeNotifierProvider(
                      create: (_) => EventNotifier(eventId: event.id),
                      child: EventWidget(event: event)))
                  .toList()
            ],
          ),
        ),
      ],
    );
  }
}
