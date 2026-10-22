import 'package:flutter/services.dart';
import 'package:recital/features/catalog/domain/catalog.dart';
import 'package:recital/features/catalog/infrastructure/catalog_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'catalog_providers.g.dart';

@Riverpod(keepAlive: true)
CatalogRepository catalogRepository(Ref ref) => CatalogRepository(rootBundle);

@Riverpod(keepAlive: true)
Future<Catalog> catalog(Ref ref) => ref.watch(catalogRepositoryProvider).load();
