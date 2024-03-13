import 'package:flutter/material.dart';

class EventDetailItemWidget extends StatelessWidget {
  final String iconAsset;
  final String title;
  final String subTitle;
  final bool isBigScreen;
  final VoidCallback onTap;
  final bool isIcon; // todo(davila): do not use this

  const EventDetailItemWidget({
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
      ),
    );
  }
}
