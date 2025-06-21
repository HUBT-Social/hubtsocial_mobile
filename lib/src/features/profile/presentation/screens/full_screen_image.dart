import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FullScreenImage extends StatelessWidget {
  final String imageUrl;
  final String heroTag;

  const FullScreenImage(
      {super.key, required this.imageUrl, required this.heroTag});

  static FullScreenImage fromRoute(BuildContext context, GoRouterState state) {
    final extra = state.extra;
    if (extra is Map &&
        extra['imageUrl'] is String &&
        extra['heroTag'] is String) {
      return FullScreenImage(
        imageUrl: extra['imageUrl'] as String,
        heroTag: extra['heroTag'] as String,
      );
    }
    return const FullScreenImage(imageUrl: '', heroTag: '');
  }

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
            child: Text('Không có ảnh', style: TextStyle(color: Colors.white))),
      );
    }
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: Hero(
              tag: heroTag,
              child: Image.network(
                imageUrl,
                fit: BoxFit.contain,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),
          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              icon: Icon(Icons.close, color: Colors.white, size: 32),
              onPressed: () => context.pop(),
            ),
          ),
        ],
      ),
    );
  }
}
