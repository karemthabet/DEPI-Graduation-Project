import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class GeneralNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double? height;
  final double? width;

  const GeneralNetworkImage({super.key, required this.imageUrl, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(18)),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
                height: height,
              width: width??  double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                 height: height ,
                color: Colors.grey[200],
                child: const Center(child: CircularProgressIndicator()),
              ),
              errorWidget: (context, url, error) => const Icon(
                size: 60,
                Icons.broken_image,
                color: Colors.red,
              ),
            ),
          );
  }
}