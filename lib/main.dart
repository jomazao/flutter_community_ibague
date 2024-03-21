import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_localizations/firebase_ui_localizations.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';
import 'package:flutter_community_ibague/firebase_options.dart';
import 'package:flutter_community_ibague/src/config/app_colors.dart';
import 'package:flutter_community_ibague/src/config/dependecy_injection.dart';
import 'package:flutter_community_ibague/src/config/es.dart';
import 'package:flutter_community_ibague/src/config/router.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('es');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  DependecyInjection.registerInjections();
  FirebaseUIAuth.configureProviders([
    EmailAuthProvider(),
    GoogleProvider(
        clientId:
            '802320953608-0vkf65o9k90ea1d6g2nsk0ggb0hmq5pr.apps.googleusercontent.com'),
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Community Ibagué',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        useMaterial3: true,
      ),
      localizationsDelegates: [
        FirebaseUILocalizations.withDefaultOverrides(const EsLocalizations()),
      ],
      routerConfig: appRouter,
    );
  }
}
