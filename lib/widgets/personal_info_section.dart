import 'package:flutter/material.dart';
import 'package:my_portfolio/models/resume_model.dart';

class PersonalInfoSection extends StatelessWidget {
  final PersonalInfo personalInfo;

  const PersonalInfoSection({super.key, required this.personalInfo});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contact Information',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.email, size: 16),
            const SizedBox(width: 8),
            Text(
              personalInfo.email,
              style: const TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            const Icon(Icons.phone, size: 16),
            const SizedBox(width: 8),
            Text(
              personalInfo.phone,
              style: const TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            const Icon(Icons.location_on, size: 16),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                '${personalInfo.location} ${personalInfo.pincode}',
              ),
            ),
          ],
        ),
      ],
    );
  }
}
