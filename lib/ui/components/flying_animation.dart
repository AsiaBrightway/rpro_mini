import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class FlyingItemAnimation extends StatefulWidget {
  final Offset startPosition;
  final Offset endPosition;
  final String image;
  final VoidCallback onComplete;

  const FlyingItemAnimation({
    required this.startPosition,
    required this.endPosition,
    required this.onComplete, required this.image,
  });

  @override
  _FlyingItemAnimationState createState() => _FlyingItemAnimationState();
}

class _FlyingItemAnimationState extends State<FlyingItemAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));

    _animation = Tween<Offset>(
      begin: widget.startPosition,
      end: widget.endPosition,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.forward().then((_) => widget.onComplete());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Positioned(
          left: _animation.value.dx,
          top: _animation.value.dy,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: widget.image.isEmpty
                ? Container(
                    // Fallback widget (e.g., a colored box with an icon)
                    width: 40,
                    height: 40,
                    color: Colors.grey[300],
                    child: const Icon(Icons.image, color: Colors.purple),
                  )
                : CachedNetworkImage(
                    width: 40,
                    height: 40,
                    imageUrl: widget.image,
                    fit: BoxFit.cover,
                    placeholder: (context,url) => const Icon(Icons.image, color: Colors.grey,size: 40),
                    errorWidget: (context, url, error) => const Icon(Icons.image, color: Colors.grey,size: 40),
                  ),
          ), // Adjust the item image
        );
      },
    );
  }
}
