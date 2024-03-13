import 'package:flutter/material.dart';

class HostByWidget extends StatelessWidget {
  final List<dynamic> speakers;
  final bool bigScreen;

  const HostByWidget({
    super.key,
    required this.speakers,
    required this.bigScreen,
  });
  @override
  Widget build(BuildContext context) {
    return Text(
      speakerName(),
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: bigScreen ? 18 : 12,
      ),
    );
  }

  String speakerName() {
    String speakerName = '';
    for (var speaker in speakers) {
      if (speakerName == '') {
        speakerName = speaker;
      } else {
        speakerName = '$speakerName y $speaker';
      }
    }
    return speakerName;
  }
}
