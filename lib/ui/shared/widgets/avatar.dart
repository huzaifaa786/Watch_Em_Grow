// import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:velocity_x/velocity_x.dart';

class Avatar extends StatelessWidget {
  final double border;
  final double radius;
  final String imageUrl;

  const Avatar({
    Key? key,
    this.border = 0,
    required this.radius,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.white,
      child: CircleAvatar(
        radius: radius - 1,
        backgroundColor: Colors.white,
        child: Center(
          child: SizedBox.expand(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child:  CachedNetworkImage(
                imageUrl: imageUrl,
                
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class NetworkImageBuilder extends StatelessWidget {
  final String imageUrl;

  const NetworkImageBuilder({
    Key? key,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (imageUrl.isEmpty)
        ? SvgPicture.asset(
            "assets/images/avatar.svg",
          )
        : Image.network(
            imageUrl,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              );
            },
            frameBuilder: (
              BuildContext context,
              Widget child,
              int? frame,
              bool wasSynchronouslyLoaded,
            ) {
              if (wasSynchronouslyLoaded) {
                return child;
              }
              return AnimatedOpacity(
                opacity: frame == null ? 0 : 1,
                duration: const Duration(seconds: 1),
                curve: Curves.easeOut,
                child: child,
              );
            },
            errorBuilder: (context, exception, stackTrace) {
              return const Icon(Icons.broken_image_outlined).centered();
            },
          );
  }
}
