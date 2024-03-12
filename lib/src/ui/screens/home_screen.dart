import 'package:flutter/material.dart';
import 'package:flutter_community_ibague/src/config/router.dart';
import 'package:go_router/go_router.dart';

enum HomePage { events, person }

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Flutter Community Ibague'),
        elevation: 1.0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: widget.child,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          if (index == 0) {
            context.go(Routes.events);
            setState(() {
              currentIndex = 0;
            });
          } else if (index == 1) {
            context.go(Routes.person);
            setState(() {
              currentIndex = 1;
            });
          } else {
            context.go(Routes.sponsors);
            setState(() {
              currentIndex = 2;
            });
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Eventos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.handshake),
            label: 'Sponsors',
          ),
        ],
      ),
    );
  }
}
