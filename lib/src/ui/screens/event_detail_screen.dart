import 'package:flutter/material.dart';
import 'package:flutter_community_ibague/src/models/event.dart';
import 'package:flutter_community_ibague/src/ui/widgets/event_widget.dart';
import 'package:intl/intl.dart';

class EventDetailScreen extends StatelessWidget {
  const EventDetailScreen({super.key, required this.event});

  final Event event;

  @override
  Widget build(BuildContext context) {
    final bigScreen = MediaQuery.sizeOf(context).width > 1000;
    final widthScreen = MediaQuery.sizeOf(context).width;
    // Convertir la fecha al formato deseado
    DateTime fecha = DateTime.parse(event.dateTime.toString());
    String fechaFormateada = DateFormat('d MMMM, y', 'es').format(fecha);
    // Extraer la hora
    String horaFormateada = DateFormat('HH:mm').format(fecha);
    // Determinar el día de la semana
    String diaSemana = DateFormat('EEEE', 'es').format(fecha);
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('Detalles del evento'),
              centerTitle: false,
              background: Image.network(
                event.banner == 'url'
                    ? 'https://docs.flutter.dev/assets/images/dash/early-dash-sketches3.jpg'
                    : event.banner,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Stack(alignment: Alignment.center, children: [
              Container(
                width: widthScreen * 0.6,
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const AvatarStack(
                      avatars: [
                        CircleAvatar(
                          backgroundImage:
                              NetworkImage('https://via.placeholder.com/150'),
                        ),
                        CircleAvatar(
                          backgroundImage:
                              NetworkImage('https://via.placeholder.com/150'),
                        ),
                        CircleAvatar(
                          backgroundImage:
                              NetworkImage('https://via.placeholder.com/150'),
                        ),
                        CircleAvatar(
                          backgroundImage:
                              NetworkImage('https://via.placeholder.com/150'),
                        ),
                      ],
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '+${event.attendees} Asistirán',
                      style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
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
                    Icons.calendar_month_outlined,
                    fechaFormateada,
                    '$diaSemana, $horaFormateada',
                    bigScreen,
                  ),
                  _eventDetailItem(
                    Icons.location_pin,
                    event.location,
                    'El Vergel, Ibagué',
                    bigScreen,
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
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 60,
        width: 40,
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 15,
        ),
        margin: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'ASISTIR',
              style: TextStyle(
                color: Colors.white,
                fontSize: bigScreen ? 26 : 18,
                fontWeight: FontWeight.w300,
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget _eventDetailItem(
  IconData icon,
  String date,
  String time,
  bool isBigcreen,
) {
  return Row(
    children: [
      Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(
          right: 10,
          top: 10,
          bottom: 10,
        ),
        decoration: BoxDecoration(
          color: Colors.blue[100],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon),
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            date,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: isBigcreen ? 22 : 16,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            time,
            style: TextStyle(
              fontSize: isBigcreen ? 16 : 12,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    ],
  );
}
