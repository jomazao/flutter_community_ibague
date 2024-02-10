import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_community_ibague/src/data/events_repository.dart';
import 'package:flutter_community_ibague/src/models/event.dart';
import 'package:flutter_community_ibague/src/notifiers/auth_notifier.dart';
import 'package:flutter_community_ibague/src/notifiers/event_notifier.dart';
import 'package:flutter_community_ibague/src/ui/screens/event_detail_screen.dart';
import 'package:provider/provider.dart';

class EventWidget extends StatelessWidget {
  const EventWidget({super.key, required this.event});

  final Event event;

  @override
  Widget build(BuildContext context) {
    final bigScreen = MediaQuery.sizeOf(context).width > 1000;
    final widthScreen = MediaQuery.sizeOf(context).width;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventDetailScreen(
              event: event,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(10),
        width: bigScreen ? widthScreen * 0.3 : widthScreen * 0.8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          shape: BoxShape.rectangle,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: bigScreen ? 200 : 130,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.blue,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    event.banner == 'url'
                        ? 'https://docs.flutter.dev/assets/images/dash/early-dash-sketches3.jpg'
                        : event.banner,
                  ),
                ),
                shape: BoxShape.rectangle,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Text(
                        event.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                          fontSize: bigScreen ? 22 : 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const AvatarStack(
                        avatars: [
                          CircleAvatar(
                            backgroundImage:
                                NetworkImage('https://via.placeholder.com/150'),
                          ),
                          CircleAvatar(
                            backgroundImage:
                                NetworkImage('https://via.placeholder.com/150'),
                          ),
                          CircleAvatar(
                            backgroundImage:
                                NetworkImage('https://via.placeholder.com/150'),
                          ),
                          CircleAvatar(
                            backgroundImage:
                                NetworkImage('https://via.placeholder.com/150'),
                          ),
                        ],
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '+${event.attendees} Asistirán',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_sharp,
                        color: Colors.black45,
                      ),
                      Text(
                        event.location,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black45,
                        ),
                      ),
                    ],
                  ),
                  Consumer<AuthNotifier>(
                    builder: (BuildContext context, AuthNotifier state,
                        Widget? child) {
                      final User? user = state.user;
                      if ((user?.displayName?.length ?? 0) < 10) {
                        return const Text(
                          'Agrega tu nombre completo en tu perfil para asistir al evento',
                          style: TextStyle(color: Colors.red),
                        );
                      } else {
                        return StreamBuilder(
                          stream: EventsRepository()
                              .attendStream(event.id, user!.uid),
                          builder: (BuildContext context,
                              AsyncSnapshot<bool> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return const CircularProgressIndicator();
                            } else {
                              final attending = snapshot.data ?? false;
                              final eventNotifier =
                                  context.read<EventNotifier>();
                              final uid = user.uid;
                              if (attending) {
                                return ElevatedButton(
                                  onPressed: () =>
                                      eventNotifier.notAttendEvent(uid),
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
                                  onPressed: () =>
                                      eventNotifier.attendEvent(uid),
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
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AvatarStack extends StatelessWidget {
  final List<Widget> avatars;

  const AvatarStack({
    Key? key,
    required this.avatars,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: _buildAvatarList(),
    );
  }

  List<Widget> _buildAvatarList() {
    List<Widget> avatarList = [];

    // Limitar la cantidad de avatares a mostrar a un máximo de 3
    int maxAvatars = avatars.length > 3 ? 3 : avatars.length;

    // Agregar los avatares al avatarList
    for (int i = 0; i < maxAvatars; i++) {
      final avatar = Positioned(
        left: i * 30.0, // Separación entre avatares
        child: ClipOval(
          child: avatars[i],
        ),
      );
      avatarList.add(avatar);
    }

    return avatarList;
  }
}
