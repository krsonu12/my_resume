import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_portfolio/modules/resume/models/resume_model.dart';

class ExperienceSection extends StatelessWidget {
  final List<WorkExperience> experiences;

  const ExperienceSection({super.key, required this.experiences});

  String _formatDate(DateTime? date) {
    if (date == null) return 'Current';
    return DateFormat('MM/yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Work Experience',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        ...experiences
            .map((experience) => _buildExperienceItem(context, experience)),
      ],
    );
  }

  Widget _buildExperienceItem(BuildContext context, WorkExperience experience) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${experience.company} - ${experience.position}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      experience.location,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              Text(
                '${_formatDate(experience.startDate)} - ${_formatDate(experience.endDate)}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...experience.responsibilities.map((responsibility) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• ',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Expanded(child: Text(responsibility)),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
