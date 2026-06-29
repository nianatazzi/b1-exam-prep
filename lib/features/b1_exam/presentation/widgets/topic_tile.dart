import 'package:flutter/material.dart';
import 'package:linguobyte/core/constants/app_spacing.dart';
import 'package:linguobyte/features/b1_exam/domain/models/exam_section_model.dart';
import 'package:linguobyte/features/b1_exam/domain/models/exam_topic_model.dart';
import 'package:linguobyte/features/b1_exam/domain/models/topic_progress_model.dart';

class TopicTile extends StatelessWidget {
  final ExamTopicModel topic;
  final ExamSectionType sectionType;
  final TopicProgressModel progress;
  final VoidCallback onTap;

  const TopicTile({
    super.key,
    required this.topic,
    required this.sectionType,
    required this.progress,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final completedLevels = _countCompletedLevels();

    return ListTile(
      onTap: onTap,
      title: Text(topic.title),
      subtitle: topic.description.isNotEmpty ? Text(topic.description) : null,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 3 индикатора — по одному на каждый уровень подготовки
          ...List.generate(3, (i) => Padding(
            padding: const EdgeInsets.only(left: AppSpacing.xs),
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: i < completedLevels
                    ? theme.colorScheme.primary
                    : theme.colorScheme.surfaceContainerHighest,
              ),
            ),
          )),
          const SizedBox(width: AppSpacing.sm),
          const Icon(Icons.chevron_right),
        ],
      ),
    );
  }

  int _countCompletedLevels() {
    final sectionName = sectionType.name;
    int count = 0;
    for (final level in ['vocabulary', 'grammar', 'phrases']) {
      final key = '${sectionName}_${topic.tId}_$level';
      if (progress.topicResults.containsKey(key)) {
        count++;
      }
    }
    return count;
  }
}
