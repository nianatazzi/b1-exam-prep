import 'package:flutter/material.dart';
import 'package:b1_exam_prep/core/constants/app_spacing.dart';
import 'package:b1_exam_prep/core/constants/avatar_presets.dart';

/// Сетка пресет-аватаров 4×N. Переиспользуется в онбординге и профиле.
/// shrinkWrap — встраивается в скролл-контейнер родителя.
class AvatarPickerGrid extends StatelessWidget {
  const AvatarPickerGrid({
    super.key,
    required this.selectedId,
    required this.onSelect,
  });

  final String selectedId;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 4,
      mainAxisSpacing: AppSpacing.md,
      crossAxisSpacing: AppSpacing.md,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        for (final id in AvatarPresets.ids)
          _AvatarItem(
            id: id,
            isSelected: id == selectedId,
            onTap: () => onSelect(id),
          ),
      ],
    );
  }
}

class _AvatarItem extends StatelessWidget {
  const _AvatarItem({
    required this.id,
    required this.isSelected,
    required this.onTap,
  });

  final String id;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? cs.primary : Colors.transparent,
            width: 3,
          ),
        ),
        padding: const EdgeInsets.all(2),
        child: ClipOval(
          child: Image.asset(
            AvatarPresets.pathOf(id),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
