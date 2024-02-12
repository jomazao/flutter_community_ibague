import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_community_ibague/src/config/app_assets.dart';
import 'package:flutter_community_ibague/src/config/app_colors.dart';
import 'package:flutter_community_ibague/src/notifiers/auth_notifier.dart';
import 'package:flutter_community_ibague/src/notifiers/event_notifier.dart';
import 'package:flutter_community_ibague/src/ui/widgets/event_widget.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class EventDetailScreen extends StatelessWidget {
  const EventDetailScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<EventNotifier>();
    final bigScreen = MediaQuery.sizeOf(context).width > 800;
    final widthScreen = MediaQuery.sizeOf(context).width;
    final event = notifier.event;

    // Convertir la fecha al formato deseado
    DateTime fecha = DateTime.parse(event.dateTime.toString());
    String fechaFormateada = DateFormat('d MMMM, y', 'es').format(fecha);
    // Extraer la hora
    String horaFormateada = DateFormat('HH:mm').format(fecha);
    // Determinar el día de la semana
    String diaSemana = DateFormat('EEEE', 'es').format(fecha);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detalles del evento',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.flutterNavy,
        iconTheme: const IconThemeData(color: Colors.white),
        scrolledUnderElevation: 0,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  constraints: BoxConstraints(maxHeight: bigScreen ? 300 : 200),
                  alignment: Alignment.bottomCenter,
                  color: AppColors.flutterNavy,
                  child: CachedNetworkImage(
                    imageUrl: event.banner,
                  ),
                ),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const <BoxShadow>[
                              BoxShadow(
                                color: Colors.black38,
                                blurRadius: 10.0,
                                offset: Offset(0.0, 5.0),
                              )
                            ]),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const AvatarStack(
                              avatars: [Icon(Icons.people_outline_rounded)],
                            ),
                            const SizedBox(width: 5),
                            Text(
                              '+${event.attendeesCount} Asistirán',
                              style: const TextStyle(
                                color: AppColors.primaryFont,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              event.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 36,
                              ),
                            ),
                            _eventDetailItem(
                                iconAsset: AppAssets.calendar,
                                title: fechaFormateada,
                                subTitle: '$diaSemana, $horaFormateada',
                                isBigScreen: bigScreen,
                                onTap: () {
                                  final Uri uri = Uri.parse(event.calendarUrl);
                                  launchUrl(uri);
                                }),
                            _eventDetailItem(
                              iconAsset: AppAssets.location,
                              title: event.locationTitle,
                              subTitle: event.locationDetails,
                              isBigScreen: bigScreen,
                              onTap: () {
                                final Uri uri = Uri.parse(event.locationUrl);
                                launchUrl(uri);
                              },
                            ),
                            Text(
                              'Acerca del evento',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: bigScreen ? 22 : 16,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              event.description,
                              style: TextStyle(fontSize: bigScreen ? 20 : 14),
                            ),
                            const SizedBox(height: 10),
                            if (event.recommendations != '')
                              Text(
                                'Recomendaciones',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: bigScreen ? 22 : 16,
                                ),
                              ),
                            const SizedBox(height: 10),
                            Text(
                              event.recommendations,
                              style: TextStyle(fontSize: bigScreen ? 20 : 14),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 70,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      notifier.attending ? AppColors.cancel : AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: EdgeInsets.symmetric(
                      vertical: bigScreen ? 20 : 15, horizontal: 100),
                ),
                onPressed: () async {
                  final authNotifier = context.read<AuthNotifier>();
                  if (notifier.attending) {
                    notifier.notAttendEvent();
                    return;
                  }
                  if (authNotifier.user == null) {
                    await showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                              title: const Text('Inicia sesión'),
                              content: const Text(
                                  'Debes iniciar sesión para poder registrarte al evento',
                                  style: TextStyle(
                                    fontSize: 16,
                                  )),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(ctx);
                                    },
                                    child: const Text('Ok'))
                              ],
                            ));
                    final logged = await showModalBottomSheet<bool>(
                            context: context,
                            builder: (ctx) {
                              late final Widget child;

                              child = SignInScreen(
                                actions: [
                                  AuthStateChangeAction<SignedIn>(
                                      (context, state) {
                                    Navigator.pop(ctx, true);
                                  }),
                                  AuthStateChangeAction<UserCreated>(
                                      (context, state) {
                                    Navigator.pop(ctx, true);
                                  }),
                                ],
                              );

                              return Scaffold(body: child);
                            }) ??
                        false;

                    if (logged) {
                      notifier.attendEvent();
                    } else {}
                  }
                },
                child: Text(
                  notifier.attending ? 'Desistir' : 'Asistir',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: bigScreen ? 26 : 18,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

Widget _eventDetailItem({
  required String iconAsset,
  required String title,
  required String subTitle,
  required bool isBigScreen,
  required VoidCallback onTap,
}) {
  return InkWell(
    onTap: onTap,
    child: Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.only(
            right: 10,
            top: 10,
            bottom: 10,
          ),
          decoration: BoxDecoration(
            color: AppColors.iconBackground,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Image.asset(
            iconAsset,
            height: 30,
            width: 30,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: isBigScreen ? 22 : 16,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              subTitle,
              style: TextStyle(
                fontSize: isBigScreen ? 16 : 12,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
