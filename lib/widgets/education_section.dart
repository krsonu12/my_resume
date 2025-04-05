import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_portfolio/models/resume_model.dart';

class EducationSection extends StatelessWidget {
  final List<EducationEntry> educationEntries;

  const EducationSection({super.key, required this.educationEntries});

  String _formatDate(DateTime date) {
    return DateFormat('MM/yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Education',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        ...educationEntries.map((entry) => _buildEducationItem(context, entry)),
      ],
    );
  }

  Widget _buildEducationItem(BuildContext context, EducationEntry entry) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${entry.degree}${entry.fieldOfStudy != null ? ' - ${entry.fieldOfStudy}' : ''}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            '${entry.institution}, ${entry.location}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 4),
          Text(
            _formatDate(entry.graduationDate),
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
