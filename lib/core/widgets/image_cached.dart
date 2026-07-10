import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'shimmer_loading.dart';

class CachedImageWidget extends StatelessWidget {
  final String imageUrl;
  final double? height;
  final double? width;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Widget? errorWidget;

  const CachedImageWidget({
    Key? key,
    required this.imageUrl,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.errorWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(0),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        height: height,
        width: width,
        fit: fit,
        placeholder: (context, url) => ShimmerLoading(
          height: height ?? 200,
          width: width,
        ),
        errorWidget: (context, url, error) =>
            errorWidget ??
            Container(
              height: height,
              width: width,
              color: Colors.grey[300],
              child: const Icon(Icons.image_not_supported),
            ),
      ),
    );
  }
}
