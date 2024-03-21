import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_community_ibague/src/config/app_constants.dart';
import 'package:flutter_community_ibague/src/notifiers/auth_notifier.dart';
import 'package:flutter_community_ibague/src/ui/fci_widgets/fci_editable_text_field/fci_editable_text_field.dart';
import 'package:flutter_community_ibague/src/ui/screens/person_screen/person_notifier.dart';
import 'package:flutter_community_ibague/src/ui/utils/date_utils.dart';
import 'package:provider/provider.dart';

class PersonScreen extends StatelessWidget {
  const PersonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthNotifier>();
    final personNotifier = context.read<PersonNotifier>();
    if (authState.user == null) {
      return SignInScreen(
        actions: [
          AuthStateChangeAction<UserCreated>((context, userCreated) async {
            await personNotifier.createMember();
          }),
          AuthStateChangeAction<SignedIn>((context, userCreated) async {
            await personNotifier.init();
          }),
        ],
      );
    } else {
      return Consumer<PersonNotifier>(
        builder: (
          context,
          vm,
          _,
        ) {
          return ProfileScreen(
            providers: const [],
            actions: [
              DisplayNameChangedAction((context, oldName, newName) async {
                personNotifier.updateUser(FieldToUpdate.name, newName);
              }),
              SignedOutAction((context) {
                personNotifier.signedOut();
              }),
              AccountDeletedAction((context, _) {
                personNotifier.signedOut();
              }),
            ],
            showMFATile: false,
            children: [
              if (vm.isLoading)
                const Center(
                  child: Padding(
                      padding: EdgeInsets.all(60),
                      child: CircularProgressIndicator()),
                ),
              if (personNotifier.currentUser != null)
                vm.currentUser!.when((user) {
                  return Column(
                    children: [
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
                          personNotifier.updateUser(
                              FieldToUpdate.cellphone, value);
                        },
                      ),
                      const SizedBox(height: 12),
                      FciEditableTextField.selector(
                        labelText: 'Género',
                        hintText:
                            'Ingrese el genero con el que se identifica *',
                        options: AppConstants.genderList,
                        content: user.gender,
                        onDataSelected: (genderSelected) {
                          personNotifier.updateUser(
                              FieldToUpdate.gender, genderSelected);
                        },
                      ),
                      const SizedBox(height: 12),
                      FciEditableTextField.datePicker(
                        labelText: 'Edad',
                        hintText: 'Ingrese su edad *',
                        content: user.dateOfBirth?.dayMonthYear(),
                        onDataSelected: (dateSelected) {
                          personNotifier.updateUser(
                              FieldToUpdate.dateOfBirth, dateSelected);
                        },
                      ),
                    ],
                  );
                }, (error) => const SizedBox.shrink())
            ],
          );
        },
      );
    }
  }
}
