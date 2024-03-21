import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_community_ibague/src/config/app_assets.dart';
import 'package:flutter_community_ibague/src/config/app_colors.dart';
import 'package:flutter_community_ibague/src/config/app_constants.dart';
import 'package:flutter_community_ibague/src/models/member.dart';
import 'package:flutter_community_ibague/src/notifiers/auth_notifier.dart';
import 'package:flutter_community_ibague/src/notifiers/event_notifier.dart';
import 'package:flutter_community_ibague/src/ui/fci_widgets/fci_editable_text_field/fci_editable_text_field.dart';
import 'package:flutter_community_ibague/src/ui/utils/date_utils.dart';
import 'package:flutter_community_ibague/src/ui/utils/dialogs.dart';
import 'package:flutter_community_ibague/src/ui/utils/string_utils.dart';
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
    //TODO MOVE THESE LINES TO DATE UTILS
    // Convertir la fecha al formato deseado
    DateTime fecha = DateTime.parse(event.dateTime.toString());
    String fechaFormateada = DateFormat('d MMMM, y', 'es').format(fecha);
    // Extraer la hora
    String horaFormateada = DateFormat('HH:mm').format(fecha);
    // Determinar el día de la semana
    String diaSemana = DateFormat('EEEE', 'es').format(fecha);

    ///TODO until here
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
                    await Dialogs.showDialogWithMessage(
                      context,
                      'Debes iniciar sesión para poder registrarte al evento',
                      title: const Text('Inicia sesión'),
                      showCancelBtn: false,
                    );
                    await _showDoLogin(context, notifier);
                  } else {
                    _validateUserData(
                      notifier,
                      context,
                    );
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

  Future<void> _showDoLogin(
    BuildContext context,
    EventNotifier notifier,
  ) async {
    await showModalBottomSheet<bool>(
      context: context,
      builder: (ctx) {
        final child = SignInScreen(
          actions: [
            AuthStateChangeAction<SignedIn>(
              (context, state) async {
                Navigator.pop(ctx, true);
                await _validateUserData(
                  notifier,
                  context,
                );
              },
            ),
            AuthStateChangeAction<UserCreated>(
              (_, state) async {
                Navigator.pop(ctx, true);
                await _validateUserData(
                  notifier,
                  context,
                );
              },
            ),
          ],
        );
        return Scaffold(body: child);
      },
    );
  }

  Future<void> _validateUserData(
      EventNotifier notifier, BuildContext context) async {
    Dialogs.showLoading(context);
    final userResponse = await notifier.getCurrentUser();
    Dialogs.close(context);
    userResponse.when(
      (user) {
        if (user.hasAllInformationCompleted) {
          notifier.attendEvent();
        } else {
          _showMissingDataDialog(user, context, notifier);
        }
      },
      (error) {
        Dialogs.showErrorDialogWithMessage(context, 'Ups hubo un error');
      },
    );
  }

  void _showMissingDataDialog(
      Member user, BuildContext context, EventNotifier notifier) {
    var userToUpdate = user.copyWith();
    bool updateName = false;
    Dialogs.showDialogWithContent(
      context,
      title: const Text('Completa tu perfil'),
      Column(
        children: [
          const Text(
              'Completa toda la informacion faltante de tu perfil para poder ir al evento'),
          if (user.displayName.isEmpty)
            FciEditableTextField(
              labelText: 'Nombre completo',
              hintText: 'Ingrese su nombre completo *',
              errorText: 'Número de celular invalido',
              minLength: 3,
              content: user.displayName,
              onDataSelected: (value) {
                updateName = true;
                userToUpdate = userToUpdate.copyWith(
                  displayName: value,
                );
              },
            ),
          if (user.cellPhone.isEmpty)
            FciEditableTextField(
              labelText: 'Celular',
              hintText: 'Ingrese su número de celular *',
              errorText: 'Número de celular invalido',
              maxLength: 10,
              minLength: 10,
              content: user.cellPhone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              onDataSelected: (value) {
                userToUpdate = userToUpdate.copyWith(
                  cellPhone: value,
                );
              },
            ),
          if (user.gender.isEmpty)
            FciEditableTextField.selector(
              labelText: 'Género',
              hintText: 'Ingrese el genero con el que se identifica *',
              options: AppConstants.genderList,
              content: user.gender,
              onDataSelected: (genderSelected) {
                userToUpdate = userToUpdate.copyWith(
                  gender: genderSelected,
                );
              },
            ),
          if (user.dateOfBirth == null)
            FciEditableTextField.datePicker(
              labelText: 'Edad',
              hintText: 'Ingrese su edad *',
              content: user.dateOfBirth?.dayMonthYear(),
              onDataSelected: (dateSelected) {
                userToUpdate = userToUpdate.copyWith(
                  dateOfBirth: dateSelected.convertDMYToDate(),
                );
              },
            ),
        ],
      ),
      callBack: () async {
        Dialogs.showLoading(context);
        final userResponse = await notifier.updateMember(userToUpdate);
        if (updateName) {
          await notifier.updateName(userToUpdate);
        }
        Dialogs.close(context);
        userResponse.when((member) {
          if (member.hasAllInformationCompleted) {
            notifier.attendEvent();
          } else {
            _showMissingDataDialog(member, context, notifier);
          }
        }, (error) {
          Dialogs.showErrorDialogWithMessage(context, 'Ups hubo un error');
        });
      },
    );
  }
}
