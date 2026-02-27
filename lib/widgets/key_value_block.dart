import 'package:flutter/material.dart';

import '../models/portfolio_models.dart';

class KeyValueBlock extends StatelessWidget {
  const KeyValueBlock({super.key, required this.fields});

  final List<ProfileField> fields;

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 920;
    if (isWide) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _FieldColumn(
              fields: fields.whereIndexed((i, _) => i.isEven).toList(),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: _FieldColumn(
              fields: fields.whereIndexed((i, _) => i.isOdd).toList(),
            ),
          ),
        ],
      );
    }

    return _FieldColumn(fields: fields);
  }
}

class _FieldColumn extends StatelessWidget {
  const _FieldColumn({required this.fields});

  final List<ProfileField> fields;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: fields.map((field) {
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            border: Border.all(color: theme.colorScheme.outline, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                field.label,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.78),
                  letterSpacing: 0.7,
                ),
              ),
              const SizedBox(height: 4),
              Text(field.value, style: theme.textTheme.bodyLarge),
            ],
          ),
        );
      }).toList(),
    );
  }
}

extension _WhereIndexed<T> on Iterable<T> {
  Iterable<T> whereIndexed(bool Function(int index, T value) predicate) sync* {
    var index = 0;
    for (final value in this) {
      if (predicate(index, value)) {
        yield value;
      }
      index += 1;
    }
  }
}
