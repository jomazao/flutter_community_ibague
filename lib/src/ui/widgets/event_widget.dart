import 'package:flutter/material.dart';
import 'package:flutter_community_ibague/src/models/event.dart';
import 'package:intl/intl.dart';

class EventWidget extends StatelessWidget {
  const EventWidget({super.key, required this.event});

  final Event event;

  @override
  Widget build(BuildContext context) {
    var formatter = DateFormat.yMMMMd('es');
    String formattedDate = formatter.format(event.dateTime);
    final bigScreen = MediaQuery.sizeOf(context).width > 1000;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.lightBlueAccent.withOpacity(0.1),
      ),
      constraints: const BoxConstraints(maxWidth: 800),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Row(
        children: [
          Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(event.description),
                  ),
                ],
              )),
          const SizedBox(
            width: 10,
          ),
          Expanded(flex: 1, child: Text(formattedDate))
        ],
      ),
    );
  }
}
