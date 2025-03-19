import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CachedCategoryImage extends StatelessWidget {
  final String imageUrl;

  const CachedCategoryImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    // Cache the image manually before displaying
    final imageProvider = CachedNetworkImageProvider(imageUrl);
    precacheImage(imageProvider, context);

    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: 100,
      memCacheWidth: 96,
      memCacheHeight: 96,
      fit: BoxFit.cover,
      useOldImageOnUrlChange: true,
      placeholder: (context, url) => const Center(child: CupertinoActivityIndicator()),
      errorWidget: (context, url, error) => const Icon(Icons.error, color: Colors.red),
    );
  }
}