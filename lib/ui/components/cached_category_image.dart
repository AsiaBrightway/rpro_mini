import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CachedCategoryImage extends StatefulWidget {
  final String imageUrl;

  const CachedCategoryImage({super.key, required this.imageUrl});

  @override
  State<CachedCategoryImage> createState() => _CachedCategoryImageState();
}

class _CachedCategoryImageState extends State<CachedCategoryImage> with AutomaticKeepAliveClientMixin {

  @override
  Widget build(BuildContext context){
    super.build(context);
    final imageProvider = CachedNetworkImageProvider(widget.imageUrl);
    precacheImage(imageProvider, context);

    return CachedNetworkImage(
      imageUrl: widget.imageUrl,
      width: 100,
      memCacheWidth: 96,
      memCacheHeight: 96,
      fit: BoxFit.cover,
      useOldImageOnUrlChange: true,
      placeholder: (context, url) => Center(child: CupertinoActivityIndicator(color: Theme.of(context).colorScheme.secondary,)),
      errorWidget: (context, url, error) =>
          Expanded(
              child: Image.asset('assets/placeholder_image.jpg',fit: BoxFit.cover,)
          ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}