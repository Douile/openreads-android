import 'package:flutter/material.dart';
import 'package:openreads/core/themes/app_theme.dart';

class TagFilterChip extends StatelessWidget {
  const TagFilterChip({
    Key? key,
    required this.tag,
    required this.selected,
    required this.onTagChipPressed,
  }) : super(key: key);

  final String tag;
  final bool selected;
  final Function(bool) onTagChipPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: FilterChip(
        backgroundColor: Theme.of(context).colorScheme.surface,
        side: BorderSide(color: dividerColor, width: 1),
        label: Text(
          tag.toString(),
          style: TextStyle(
            color: selected
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.onSurface,
          ),
        ),
        checkmarkColor: Theme.of(context).colorScheme.onPrimary,
        selected: selected,
        selectedColor: Theme.of(context).colorScheme.primary,
        onSelected: onTagChipPressed,
      ),
    );
  }
}
