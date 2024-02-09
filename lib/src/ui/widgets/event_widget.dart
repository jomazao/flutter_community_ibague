import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_community_ibague/src/data/events_repository.dart';
import 'package:flutter_community_ibague/src/models/event.dart';
import 'package:flutter_community_ibague/src/notifiers/auth_notifier.dart';
import 'package:flutter_community_ibague/src/notifiers/event_notifier.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
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
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Asistentes:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                '${event.attendees}',
                style: const TextStyle(fontSize: 15),
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Consumer<AuthNotifier>(
            builder: (BuildContext context, AuthNotifier state, Widget? child) {
              final User? user = state.user;
              if ((user?.displayName?.length ?? 0) < 10) {
                return const Text(
                  'Agrega tu nombre completo en tu perfil para asistir al evento',
                  style: TextStyle(color: Colors.red),
                );
              } else {
                return StreamBuilder(
                  stream: EventsRepository().attendStream(event.id, user!.uid),
                  builder:
                      (BuildContext context, AsyncSnapshot<bool> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return const CircularProgressIndicator();
                    } else {
                      final attending = snapshot.data ?? false;
                      final eventNotifier = context.read<EventNotifier>();
                      final uid = user!.uid;
                      if (attending) {
                        return ElevatedButton(
                          onPressed: () => eventNotifier.notAttendEvent(uid),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.cancel),
                              Text('Cancelar asistencia'),
                            ],
                          ),
                        );
                      } else {
                        return ElevatedButton(
                          onPressed: () => eventNotifier.attendEvent(uid),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.check),
                              Text(
                                'Confirmar asistencia',
                              ),
                            ],
                          ),
                        );
                      }
                    }
                  },
                );
              }
            },
          )
        ],
      ),
    );
  }
}
