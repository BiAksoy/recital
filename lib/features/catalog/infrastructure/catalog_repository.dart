import 'package:flutter/services.dart';
import 'package:recital/features/catalog/domain/catalog.dart';

/// Reads the catalogue bundled with the app.
class CatalogRepository {
  const CatalogRepository(this._bundle);

  final AssetBundle _bundle;

  Future<Catalog> load() async =>
      CatalogMapper.fromJson(await _bundle.loadString('assets/catalog.json'));
}
