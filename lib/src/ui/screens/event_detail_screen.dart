import 'package:flutter/material.dart';
import 'package:flutter_community_ibague/src/config/app_colors.dart';
import 'package:flutter_community_ibague/src/ui/widgets/event_detail_body_widget.dart';
import 'package:flutter_community_ibague/src/ui/widgets/navbar_event_widget.dart';

class EventDetailScreen extends StatelessWidget {
  const EventDetailScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bigScreen = MediaQuery.sizeOf(context).width > 800;
    final widthScreen = MediaQuery.sizeOf(context).width;

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
                  NavbarEventWidget(
                    widthScreen: widthScreen,
                    bigScreen: bigScreen,
                  ),
                  EventDetailBodyWidget(
                    bigScreen: bigScreen,
                    widthScreen: widthScreen,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
