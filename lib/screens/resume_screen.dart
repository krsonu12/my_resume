import 'package:flutter/material.dart';
import 'package:my_portfolio/models/resume_data.dart';
import 'package:my_portfolio/models/resume_model.dart';
import 'package:my_portfolio/widgets/certification_section.dart';
import 'package:my_portfolio/widgets/education_section.dart';
import 'package:my_portfolio/widgets/experience_section.dart';
import 'package:my_portfolio/widgets/personal_info_section.dart';
import 'package:my_portfolio/widgets/skills_section.dart';
import 'package:url_launcher/url_launcher.dart';

class ResumeScreen extends StatefulWidget {
  const ResumeScreen({super.key});

  @override
  State<ResumeScreen> createState() => ResumeScreenState();
}

class ResumeScreenState extends State<ResumeScreen> {
  late Resume _resume;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    // Simulating API call with delay
    await Future.delayed(const Duration(milliseconds: 500));
    _resume = ResumeData.getResume();

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _launchUrl(String url) async {
    if (!url.startsWith('http')) {
      url = 'https://$url';
    }

    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch $url')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resume'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isDesktop = constraints.maxWidth > 800;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with name
                      Center(
                        child: Text(
                          _resume.name,
                          style: Theme.of(context).textTheme.headlineLarge,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Content
                      if (isDesktop)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Left column
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  PersonalInfoSection(
                                      personalInfo: _resume.personalInfo),
                                  const SizedBox(height: 20),
                                  SkillsSection(skills: _resume.skills),
                                  const SizedBox(height: 20),
                                  EducationSection(
                                      educationEntries:
                                          _resume.educationEntries),
                                  const SizedBox(height: 20),
                                  CertificationSection(
                                      certifications: _resume.certifications),
                                  const SizedBox(height: 20),
                                  _buildLanguagesSection(_resume.languages),
                                  const SizedBox(height: 20),
                                  _buildWebsitesSection(_resume.websites),
                                ],
                              ),
                            ),
                            const SizedBox(width: 40),
                            // Right column
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildSummarySection(_resume.summary),
                                  const SizedBox(height: 20),
                                  ExperienceSection(
                                      experiences: _resume.workExperience),
                                ],
                              ),
                            ),
                          ],
                        )
                      else
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            PersonalInfoSection(
                                personalInfo: _resume.personalInfo),
                            const SizedBox(height: 20),
                            _buildSummarySection(_resume.summary),
                            const SizedBox(height: 20),
                            ExperienceSection(
                                experiences: _resume.workExperience),
                            const SizedBox(height: 20),
                            SkillsSection(skills: _resume.skills),
                            const SizedBox(height: 20),
                            EducationSection(
                                educationEntries: _resume.educationEntries),
                            const SizedBox(height: 20),
                            CertificationSection(
                                certifications: _resume.certifications),
                            const SizedBox(height: 20),
                            _buildLanguagesSection(_resume.languages),
                            const SizedBox(height: 20),
                            _buildWebsitesSection(_resume.websites),
                          ],
                        ),
                    ],
                  );
                },
              ),
            ),
    );
  }

  Widget _buildSummarySection(String summary) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Personal Summary',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Text(summary),
      ],
    );
  }

  Widget _buildLanguagesSection(List<String> languages) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Languages',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: languages.map((language) {
            return Chip(label: Text(language));
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildWebsitesSection(List<String> websites) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Websites, Portfolios, Profiles',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: websites.map((website) {
            return InkWell(
              onTap: () => _launchUrl(website),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(
                  website,
                  style: const TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
