import 'package:flutter/material.dart';
import 'package:flutter_community_ibague/src/notifiers/event_notifier.dart';
import 'package:flutter_community_ibague/src/ui/widgets/host_by_widget.dart';
import 'package:provider/provider.dart';

class NavbarEventWidget extends StatelessWidget {
  final double widthScreen;
  final bool bigScreen;

  const NavbarEventWidget({
    super.key,
    required this.widthScreen,
    required this.bigScreen,
  });

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<EventNotifier>();
    final event = notifier.event;
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: widthScreen),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              event!.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: bigScreen ? 36 : 28,
              ),
            ),
            ListTile(
              leading: const CircleAvatar(),
              title: Text(
                'Hosted By',
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: bigScreen ? 18 : 12,
                ),
              ),
              subtitle: HostByWidget(
                speakers: event.speakers,
                bigScreen: bigScreen,
              ),
            ),
            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}
