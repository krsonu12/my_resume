import 'package:flutter/material.dart';
import 'package:my_portfolio/modules/resume/models/resume_model.dart';
import 'package:url_launcher/url_launcher.dart';

class PersonalInfoSection extends StatelessWidget {
  final PersonalInfo personalInfo;

  const PersonalInfoSection({super.key, required this.personalInfo});

  Future<void> _launchEmail(String email) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    }
  }

  Future<void> _launchPhone(String phone) async {
    final Uri phoneLaunchUri = Uri(
      scheme: 'tel',
      path: phone,
    );
    if (await canLaunchUrl(phoneLaunchUri)) {
      await launchUrl(phoneLaunchUri);
    }
  }

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
        InkWell(
          onTap: () => _launchEmail(personalInfo.email),
          child: Row(
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
        ),
        const SizedBox(height: 4),
        InkWell(
          onTap: () => _launchPhone(personalInfo.phone),
          child: Row(
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
