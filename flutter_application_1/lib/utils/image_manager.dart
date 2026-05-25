import 'package:flutter/material.dart';

class AppImages {
  const AppImages._();

  static const String brand = 'assets/images/brand.png';
  static const String emptyState = 'assets/images/empty_state.png';
  static const String flag = 'assets/images/flag.png';
}

class ImageManager {
  const ImageManager._();

  static String? resolveUrl(String baseUrl, String? maybeUrlOrPath) {
    final String raw = (maybeUrlOrPath ?? '').trim();
    if (raw.isEmpty) return null;

    final Uri? parsed = Uri.tryParse(raw);
    if (parsed != null && parsed.hasScheme) {
      return raw;
    }

    final String base = baseUrl.trim();
    if (base.isEmpty) return raw;

    final Uri baseUri = Uri.parse(base);
    return baseUri.resolve(raw).toString();
  }

  static Widget asset(
    String assetPath, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
  }) {
    return Image.asset(assetPath, width: width, height: height, fit: fit);
  }

  static Widget network(
    String? url, {
    Widget? placeholder,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
  }) {
    final String raw = (url ?? '').trim();
    if (raw.isEmpty) {
      return placeholder ?? const SizedBox.shrink();
    }

    return Image.network(
      raw,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (BuildContext context, Object error, StackTrace? stack) {
        return placeholder ?? const SizedBox.shrink();
      },
      loadingBuilder: (
        BuildContext context,
        Widget child,
        ImageChunkEvent? loadingProgress,
      ) {
        if (loadingProgress == null) return child;
        return placeholder ??
            SizedBox(
              width: width,
              height: height,
              child: const Center(
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            );
      },
    );
  }
}

