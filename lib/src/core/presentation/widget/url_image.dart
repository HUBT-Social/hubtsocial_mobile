import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';

enum UrlImageShape {
  circle,
  rectangle,
}

class UrlImage extends StatelessWidget {
  const UrlImage(
    this.url, {
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    super.key,
  }) : shape = UrlImageShape.rectangle;

  const UrlImage.square(
    this.url, {
    required double size,
    this.fit = BoxFit.cover,
    super.key,
  })  : width = size,
        height = size,
        shape = UrlImageShape.rectangle;

  const UrlImage.circle(
    this.url, {
    required double size,
    this.fit = BoxFit.cover,
    super.key,
  })  : width = size,
        height = size,
        shape = UrlImageShape.circle;

  final String url;
  final double? width;
  final double? height;
  final UrlImageShape shape;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final Widget image = CachedNetworkImage(
      imageUrl: url,
      width: width,
      height: height,
      fit: fit,
      // imageBuilder: (context, imageProvider) => Container(
      //   decoration: BoxDecoration(
      //     image: DecorationImage(
      //         image: imageProvider,
      //         fit: BoxFit.cover,
      //         colorFilter: ColorFilter.mode(
      //             const Color.fromARGB(255, 255, 255, 255),
      //             BlendMode.colorBurn)),
      //   ),
      // ),
      progressIndicatorBuilder: (context, url, downloadProgress) =>
          CircularProgressIndicator(value: downloadProgress.progress),
      errorWidget: (context, url, error) => Icon(
        Icons.error,
        color: context.colorScheme.error,
      ),
    );

    return switch (shape) {
      UrlImageShape.circle => ClipOval(child: image),
      UrlImageShape.rectangle => image,
    };
  }
}
