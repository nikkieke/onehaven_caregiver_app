import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AvatarWidget extends StatelessWidget {
  const AvatarWidget({super.key, required this.url, required this.diameter});

  final String url;
  final double diameter;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: CachedNetworkImage(
        height: diameter,
        width: diameter,
        imageUrl: url,
        imageBuilder:
            (context, imageProvider) => Container(
              height: diameter,
              width: diameter,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
              ),
            ),
        placeholder:
            (context, url) => CircularProgressIndicator(color: Colors.teal),
        errorWidget: (context, url, error) => Icon(Icons.error),
        color: Colors.grey[200],
      ),
    );
  }
}
