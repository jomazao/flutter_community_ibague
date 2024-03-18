import 'package:flutter/material.dart';
import 'package:flutter_community_ibague/src/notifiers/event_notifier.dart';
import 'package:flutter_community_ibague/src/notifiers/events_notifier.dart';
import 'package:flutter_community_ibague/src/ui/widgets/carousel_slider_widget.dart';
import 'package:flutter_community_ibague/src/ui/widgets/event_widget.dart';
import 'package:provider/provider.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<EventsNotifier>();
    final bigScreen = MediaQuery.sizeOf(context).width > 1000;
    final widthScreen = MediaQuery.sizeOf(context).width;
    return ListView(
      children: [
        CarouselSliderWidget(),
        _eventsText('Próximos eventos', bigScreen, widthScreen),
        const SizedBox(
          height: 10,
        ),
        _eventWidget(state, true),
        _eventsText('Anteriores eventos', bigScreen, widthScreen),
        _eventWidget(state, false),
      ],
    );
  }

  Widget _eventWidget(EventsNotifier state, bool isNewEvent) {
    DateTime dateNow = DateTime.now();
    return Wrap(alignment: WrapAlignment.center, children: [
      ...state.events
          .map(
            (event) => ChangeNotifierProvider(
              create: (_) => EventNotifier(event: event),
              child: isNewEvent
                  ? event.dateTime.isAfter(dateNow)
                      ? const EventWidget(isDisabled: false)
                      : const SizedBox()
                  : event.dateTime.isBefore(dateNow)
                      ? const EventWidget(isDisabled: true)
                      : const SizedBox(),
            ),
          )
          .toList(),
    ]);
  }

  Widget _eventsText(
    String text,
    bool bigScreen,
    double widthScreen,
  ) {
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        width: bigScreen ? widthScreen * 0.3 : widthScreen * 0.8,
        child: Text(
          text,
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: bigScreen ? 30 : 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
