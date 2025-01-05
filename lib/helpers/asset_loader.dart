import 'dart:ui';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';

class PackageAssetLoader extends AssetLoader {
  final String packageName;

  const PackageAssetLoader({required this.packageName});

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) async {
    var adjustedPath = getLocalePath(path, locale);
    String packagePath = 'packages/$packageName/$adjustedPath';
    EasyLocalization.logger.debug('Load asset from $packagePath');
    return json.decode(await rootBundle.loadString(packagePath));
  }

  String getLocalePath(String basePath, Locale locale) {
    // Adjust this method if your locale pathing scheme differs
    return '$basePath/${locale.toStringWithSeparator(separator: "-")}.json';
  }
}

class RandomFacts {
  static List<String> _randomFacts = [];

  static Future<void> loadRandomFacts() async {
    final String factsContent = await rootBundle
        .loadString('packages/boxify/assets/data/randomfacts.txt');

    _randomFacts = factsContent.split('\n');
  }

  static List<String> get randomFacts => _randomFacts;
}
