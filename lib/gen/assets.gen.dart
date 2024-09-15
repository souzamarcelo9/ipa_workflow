/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsAnimationGen {
  const $AssetsAnimationGen();

  /// File path: assets/animation/1723007849584.json
  String get a1723007849584 => 'assets/animation/1723007849584.json';

  /// List of all assets
  List<String> get values => [a1723007849584];
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/2.png
  AssetGenImage get a2 => const AssetGenImage('assets/images/2.png');

  /// File path: assets/images/bgcard.png
  AssetGenImage get bgcard => const AssetGenImage('assets/images/bgcard.png');

  /// File path: assets/images/brasil.png
  AssetGenImage get brasil => const AssetGenImage('assets/images/brasil.png');

  /// File path: assets/images/camera.png
  AssetGenImage get camera => const AssetGenImage('assets/images/camera.png');

  /// File path: assets/images/chat.svg
  String get chat => 'assets/images/chat.svg';

  /// File path: assets/images/espanha.png
  AssetGenImage get espanha => const AssetGenImage('assets/images/espanha.png');

  /// File path: assets/images/estados-unidos.png
  AssetGenImage get estadosUnidos =>
      const AssetGenImage('assets/images/estados-unidos.png');

  /// File path: assets/images/google.png
  AssetGenImage get google => const AssetGenImage('assets/images/google.png');

  /// File path: assets/images/login.svg
  String get login => 'assets/images/login.svg';

  /// File path: assets/images/login_bottom.png
  AssetGenImage get loginBottom =>
      const AssetGenImage('assets/images/login_bottom.png');

  /// File path: assets/images/main_bottom.png
  AssetGenImage get mainBottom =>
      const AssetGenImage('assets/images/main_bottom.png');

  /// File path: assets/images/main_top.png
  AssetGenImage get mainTop =>
      const AssetGenImage('assets/images/main_top.png');

  /// List of all assets
  List<dynamic> get values => [
        a2,
        bgcard,
        brasil,
        camera,
        chat,
        espanha,
        estadosUnidos,
        google,
        login,
        loginBottom,
        mainBottom,
        mainTop
      ];
}

class Assets {
  Assets._();

  static const $AssetsAnimationGen animation = $AssetsAnimationGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
