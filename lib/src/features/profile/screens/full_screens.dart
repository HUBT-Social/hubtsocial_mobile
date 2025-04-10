import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FullScreenImage extends StatelessWidget {
  final ImageProvider imageProvider;
  final String heroTag;

  const FullScreenImage({
    super.key,
    required this.imageProvider,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Full screen image with Hero animation
          Center(
            child: Hero(
              tag: heroTag,
              child: Image(image: imageProvider),
            ),
          ),
          // Close button
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    context.pop();
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
