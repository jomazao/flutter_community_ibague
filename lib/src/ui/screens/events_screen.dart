import 'package:flutter/material.dart';
import 'package:flutter_community_ibague/src/config/app_assets.dart';
import 'package:flutter_community_ibague/src/config/app_colors.dart';
import 'package:flutter_community_ibague/src/notifiers/event_notifier.dart';
import 'package:flutter_community_ibague/src/notifiers/events_notifier.dart';
import 'package:flutter_community_ibague/src/ui/widgets/banner_widget.dart';
import 'package:flutter_community_ibague/src/ui/widgets/event_widget.dart';
import 'package:provider/provider.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<EventsNotifier>();
    final bigScreen = MediaQuery.sizeOf(context).width > 1000;
    final widthScreen = MediaQuery.sizeOf(context).width;
    return ListView(
      children: [
        const SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                BannerWidget(
                  text: 'Únete al servidor',
                  color: AppColors.blueBackground,
                  svgImage: AppAssets.discordLogoSvg,
                  url: 'https://discord.gg/DGsuM229dj',
                ),
                BannerWidget(
                  text: 'Síguenos en LinkedIn',
                  color: AppColors.primary,
                  svgImage: AppAssets.discordLogoSvg,
                  url:
                      'https://www.linkedin.com/company/flutter-community-ibague',
                ),
                BannerWidget(
                  text: 'Síguenos en X.com ',
                  color: Colors.black,
                  svgImage: AppAssets.discordLogoSvg,
                  url: 'https://twitter.com/FlutterIbague',
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: SizedBox(
            width: bigScreen ? widthScreen * 0.3 : widthScreen * 0.8,
            child: Text(
              'Próximos eventos',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: bigScreen ? 30 : 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Wrap(alignment: WrapAlignment.center, children: [
          ...state.events
              .map(
                (event) => ChangeNotifierProvider(
                  create: (_) => EventNotifier(event: event),
                  child: const EventWidget(),
                ),
              )
              .toList(),
        ])
      ],
    );
  }
}
