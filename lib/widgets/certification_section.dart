import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_portfolio/models/resume_model.dart';

class CertificationSection extends StatelessWidget {
  final List<Certification> certifications;

  const CertificationSection({super.key, required this.certifications});

  String _formatDate(DateTime date) {
    return DateFormat('MM/dd/yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Certifications',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        ...certifications.map((cert) => _buildCertificationItem(context, cert)),
      ],
    );
  }

  Widget _buildCertificationItem(BuildContext context, Certification cert) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.verified, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cert.name,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                if (cert.organization != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    cert.organization!,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
                const SizedBox(height: 2),
                Text(
                  _formatDate(cert.date),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
