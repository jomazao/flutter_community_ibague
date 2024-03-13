import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_community_ibague/src/config/app_assets.dart';
import 'package:flutter_community_ibague/src/config/app_colors.dart';
import 'package:flutter_community_ibague/src/notifiers/auth_notifier.dart';
import 'package:flutter_community_ibague/src/notifiers/event_notifier.dart';
import 'package:flutter_community_ibague/src/ui/widgets/event_detail_item_widget.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class EventDetailBodyWidget extends StatelessWidget {
  final bool bigScreen;
  final double widthScreen;

  const EventDetailBodyWidget({
    super.key,
    required this.bigScreen,
    required this.widthScreen,
  });

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<EventNotifier>();
    final event = notifier.event;

    // Convertir la fecha al formato deseado
    DateTime fecha = DateTime.parse(event!.dateTime.toString());
    String fechaFormateada = DateFormat('d MMMM, y', 'es').format(fecha);
    // Extraer la hora
    String horaFormateada = DateFormat('HH:mm').format(fecha);
    // Determinar el día de la semana
    String diaSemana = DateFormat('EEEE', 'es').format(fecha);
    return Wrap(
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
                      width: bigScreen ? widthScreen * 0.6 : widthScreen,
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
                    style: TextStyle(fontSize: bigScreen ? 20 : 14),
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
                    style: TextStyle(fontSize: bigScreen ? 20 : 14),
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
                          EventDetailItemWidget(
                            iconAsset: AppAssets.calendar,
                            title: fechaFormateada,
                            subTitle: '$diaSemana, $horaFormateada',
                            isBigScreen: bigScreen,
                            onTap: () {
                              final Uri uri = Uri.parse(event.calendarUrl);
                              launchUrl(uri);
                            },
                            isIcon: false,
                          ),
                          EventDetailItemWidget(
                            iconAsset: AppAssets.location,
                            title: event.locationTitle,
                            subTitle: event.locationDetails,
                            isBigScreen: bigScreen,
                            onTap: () {
                              final Uri uri = Uri.parse(event.locationUrl);
                              launchUrl(uri);
                            },
                            isIcon: false,
                          ),
                          EventDetailItemWidget(
                            iconAsset: AppAssets.location,
                            title: '+${event.attendeesCount} Asistirán',
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
                  backgroundColor:
                      notifier.attending ? AppColors.cancel : AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: bigScreen ? 20 : 15,
                    horizontal: 100,
                  ),
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
                    }
                  } else {
                    notifier.attendEvent();
                  }
                },
                child: Text(
                  notifier.attending ? 'Cancelar Asistencia' : 'Asistir',
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
    );
  }
}
