import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recital/core/l10n.dart';
import 'package:recital/core/theme/theme_context.dart';
import 'package:recital/features/catalog/application/catalog_providers.dart';
import 'package:recital/features/catalog/domain/catalog.dart';

/// [data] once the catalogue is read; it is bundled, so this is a frame or two.
class CatalogView extends ConsumerWidget {
  const CatalogView({required this.data, super.key});

  final Widget Function(Catalog catalog) data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return switch (ref.watch(catalogProvider)) {
      AsyncData(:final value) => data(value),
      AsyncError() => Center(
        child: Padding(
          padding: EdgeInsets.all(context.spacing.lg),
          child: Text(context.l10n.catalogUnreadable),
        ),
      ),
      _ => const Center(child: CircularProgressIndicator()),
    };
  }
}
