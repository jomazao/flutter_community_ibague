import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_community_ibague/src/config/app_assets.dart';
import 'package:flutter_community_ibague/src/config/app_colors.dart';
import 'package:flutter_community_ibague/src/notifiers/auth_notifier.dart';
import 'package:flutter_community_ibague/src/notifiers/event_notifier.dart';
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: widthScreen),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            event.title,
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
                            subtitle: Text(
                              'Camilo Cubillos y Jorge Lopez',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: bigScreen ? 18 : 12,
                              ),
                            ),
                          ),
                          const SizedBox(height: 25),
                        ],
                      ),
                    ),
                  ),
                  Wrap(
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: bigScreen ? widthScreen * 0.5 : widthScreen,
                        ),
                        child: Column(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  child: CachedNetworkImage(
                                    imageUrl: event.banner,
                                    fit: BoxFit.cover,
                                    width: bigScreen
                                        ? widthScreen * 0.6
                                        : widthScreen,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  'Acerca del evento',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: bigScreen ? 22 : 16,
                                  ),
                                ),
                                Text(
                                  event.description,
                                  textAlign: TextAlign.justify,
                                  style:
                                      TextStyle(fontSize: bigScreen ? 20 : 14),
                                ),
                                const SizedBox(height: 20),
                                if (event.recommendations != '')
                                  Text(
                                    'Recomendaciones',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: bigScreen ? 22 : 16,
                                    ),
                                  ),
                                Text(
                                  event.recommendations,
                                  style:
                                      TextStyle(fontSize: bigScreen ? 20 : 14),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: widthScreen * 0.1),
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: bigScreen ? widthScreen * 0.3 : widthScreen,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Card(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0,
                                      vertical: 12.0,
                                    ),
                                    child: Column(
                                      children: [
                                        EventDetailItem(
                                          iconAsset: AppAssets.calendar,
                                          title: fechaFormateada,
                                          subTitle:
                                              '$diaSemana, $horaFormateada',
                                          isBigScreen: bigScreen,
                                          onTap: () {
                                            final Uri uri =
                                                Uri.parse(event.calendarUrl);
                                            launchUrl(uri);
                                          },
                                          isIcon: false,
                                        ),
                                        EventDetailItem(
                                          iconAsset: AppAssets.location,
                                          title: event.locationTitle,
                                          subTitle: event.locationDetails,
                                          isBigScreen: bigScreen,
                                          onTap: () {
                                            final Uri uri =
                                                Uri.parse(event.locationUrl);
                                            launchUrl(uri);
                                          },
                                          isIcon: false,
                                        ),
                                        EventDetailItem(
                                          iconAsset: AppAssets.location,
                                          title:
                                              '+${event.attendeesCount} Asistirán',
                                          subTitle: '',
                                          isBigScreen: bigScreen,
                                          onTap: () {},
                                          isIcon: true,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: notifier.attending
                                    ? AppColors.cancel
                                    : AppColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                padding: EdgeInsets.symmetric(
                                  vertical: bigScreen ? 20 : 15,
                                  horizontal: 100,
                                ),
                              ),
                              onPressed: () async {
                                final authNotifier =
                                    context.read<AuthNotifier>();
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
                                  final logged =
                                      await showModalBottomSheet<bool>(
                                              context: context,
                                              builder: (ctx) {
                                                late final Widget child;

                                                child = SignInScreen(
                                                  actions: [
                                                    AuthStateChangeAction<
                                                            SignedIn>(
                                                        (context, state) {
                                                      Navigator.pop(ctx, true);
                                                    }),
                                                    AuthStateChangeAction<
                                                            UserCreated>(
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
                                  }
                                } else {
                                  notifier.attendEvent();
                                }
                              },
                              child: Text(
                                notifier.attending
                                    ? 'Cancelar Asistencia'
                                    : 'Asistir',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: bigScreen ? 26 : 18,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                            if (!bigScreen) const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EventDetailItem extends StatelessWidget {
  final String iconAsset;
  final String title;
  final String subTitle;
  final bool isBigScreen;
  final VoidCallback onTap;
  final bool isIcon; // todo(davila): do not use this

  const EventDetailItem({
    super.key,
    required this.iconAsset,
    required this.title,
    required this.subTitle,
    required this.isBigScreen,
    required this.onTap,
    required this.isIcon,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
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
                child: isIcon
                    ? const Icon(
                        Icons
                            .people_outline_rounded, // todo(davila): change this logic
                        size: 30.0,
                        color: Color.fromRGBO(86, 105, 255, 1),
                      )
                    : Image.asset(
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
                      fontSize: isBigScreen ? 22 : 14,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    subTitle,
                    style: TextStyle(
                      fontSize: isBigScreen ? 16 : 10,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
