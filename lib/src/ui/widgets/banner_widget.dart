import 'package:flutter/material.dart';
import 'package:flutter_community_ibague/src/config/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class BannerWidget extends StatelessWidget {
  const BannerWidget({
    super.key,
    required this.text,
    required this.color,
    required this.svgImage,
    required this.url,
  });

  final String text;
  final Color color;
  final String svgImage;
  final String url;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        final Uri uri = Uri.parse(url);
        launchUrl(uri);
      },
      child: Container(
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(10)),
        height: 110,
        width: 313,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        padding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 25,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: AppColors.white),
            ),
            const SizedBox(
              height: 10,
            ),
            SvgPicture.asset(
              svgImage,
              height: 50,
            )
          ],
        ),
      ),
    );
  }
}
