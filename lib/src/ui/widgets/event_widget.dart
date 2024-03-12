import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_community_ibague/src/config/app_colors.dart';
import 'package:flutter_community_ibague/src/config/router.dart';
import 'package:flutter_community_ibague/src/notifiers/event_notifier.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class EventWidget extends StatelessWidget {
  final bool isDisabled;

  const EventWidget({
    super.key,
    required this.isDisabled,
  });

  @override
  Widget build(BuildContext context) {
    final bigScreen = MediaQuery.sizeOf(context).width > 1000;
    final widthScreen = MediaQuery.sizeOf(context).width;
    final notifier = context.watch<EventNotifier>();
    final event = notifier.event;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          !isDisabled ? context.push(Routes.eventDetails, extra: event) : null;
        },
        child: Opacity(
          opacity: !isDisabled ? 1.0 : 0.5,
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
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: event.banner,
                      alignment: Alignment.center,
                    ),
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
                          // const AvatarStack(
                          //   avatars: [
                          //     CircleAvatar(
                          //       backgroundImage:
                          //           NetworkImage('https://via.placeholder.com/150'),
                          //     ),
                          //     CircleAvatar(
                          //       backgroundImage:
                          //           NetworkImage('https://via.placeholder.com/150'),
                          //     ),
                          //     CircleAvatar(
                          //       backgroundImage:
                          //           NetworkImage('https://via.placeholder.com/150'),
                          //     ),
                          //     CircleAvatar(
                          //       backgroundImage:
                          //           NetworkImage('https://via.placeholder.com/150'),
                          //     ),
                          //   ],
                          // ),
                          //  const SizedBox(width: 10),
                          Text(
                            '+${event.attendeesCount} Asistirán',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryFont,
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
                            event.locationTitle,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black45,
                            ),
                          ),
                        ],
                      ),
                      // Consumer<AuthNotifier>(
                      //   builder: (BuildContext context, AuthNotifier state,
                      //       Widget? child) {
                      //     final User? user = state.user;
                      //     if ((user?.displayName?.length ?? 0) < 10) {
                      //       return const Text(
                      //         'Agrega tu nombre completo en tu perfil para asistir al evento',
                      //         style: TextStyle(color: Colors.red),
                      //       );
                      //     } else {
                      //       return StreamBuilder(
                      //         stream: EventsRepository()
                      //             .attendStream(event.id, user!.uid),
                      //         builder: (BuildContext context,
                      //             AsyncSnapshot<bool> snapshot) {
                      //           if (snapshot.connectionState ==
                      //               ConnectionState.done) {
                      //             return const CircularProgressIndicator();
                      //           } else {
                      //             final attending = snapshot.data ?? false;
                      //             final eventNotifier =
                      //                 context.read<EventNotifier>();
                      //             final uid = user.uid;
                      //             if (attending) {
                      //               return ElevatedButton(
                      //                 onPressed: () =>
                      //                     eventNotifier.notAttendEvent(uid),
                      //                 child: const Row(
                      //                   mainAxisSize: MainAxisSize.min,
                      //                   children: [
                      //                     Icon(Icons.cancel),
                      //                     Text('Cancelar asistencia'),
                      //                   ],
                      //                 ),
                      //               );
                      //             } else {
                      //               return ElevatedButton(
                      //                 onPressed: () =>
                      //                     eventNotifier.attendEvent(uid),
                      //                 child: const Row(
                      //                   mainAxisSize: MainAxisSize.min,
                      //                   children: [
                      //                     Icon(Icons.check),
                      //                     Text(
                      //                       'Confirmar asistencia',
                      //                     ),
                      //                   ],
                      //                 ),
                      //               );
                      //             }
                      //           }
                      //         },
                      //       );
                      //     }
                      //   },
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ),
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
      final avatar = ClipOval(
        child: avatars[i],
      );
      avatarList.add(avatar);
    }

    return avatarList;
  }
}
