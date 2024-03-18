import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:flutter_community_ibague/src/config/app_assets.dart';

class CarouselSliderWidget extends StatelessWidget {
  CarouselSliderWidget({super.key});

  final List<String> images = AppAssets.carouselImages;

  final _sliderKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      child: CarouselSlider.builder(
        key: _sliderKey,
        enableAutoSlider: true,
        unlimitedMode: true,
        autoSliderTransitionTime: const Duration(seconds: 3),
        slideBuilder: (index) {
          return Container(
            alignment: Alignment.center,
            child: Image.asset(
              images[index],
            ),
          );
        },
        slideTransform: const CubeTransform(),
        slideIndicator: CircularSlideIndicator(
          padding: const EdgeInsets.only(bottom: 32),
        ),
        itemCount: images.length,
      ),
    );
  }
}
