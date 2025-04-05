import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:my_portfolio/modules/common/core/di.dart';
import 'package:my_portfolio/modules/resume/core/resume_store.dart';
import 'package:my_portfolio/modules/resume/widgets/certification_section.dart';
import 'package:my_portfolio/modules/resume/widgets/education_section.dart';
import 'package:my_portfolio/modules/resume/widgets/experience_section.dart';
import 'package:my_portfolio/modules/resume/widgets/personal_info_section.dart';
import 'package:my_portfolio/modules/resume/widgets/skills_section.dart';
import 'package:url_launcher/url_launcher.dart';

class ResumeScreen extends StatefulWidget {
  const ResumeScreen({super.key});

  @override
  State<ResumeScreen> createState() => ResumeScreenState();
}

class ResumeScreenState extends State<ResumeScreen> {
  late final ResumeStore _resumeStore;

  @override
  void initState() {
    super.initState();
    _resumeStore = DI.resumeStore;
    _loadData();
  }

  Future<void> _loadData() async {
    await _resumeStore.loadResume();
  }

  Future<void> _launchUrl(String url) async {
    if (!url.startsWith('http')) {
      url = 'https://$url';
    }

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
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
      body: Observer(
        builder: (_) {
          if (_resumeStore.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_resumeStore.errorMessage != null) {
            return Center(
              child: SelectableText.rich(
                TextSpan(
                  text: 'Error: ${_resumeStore.errorMessage}',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            );
          }

          final resume = _resumeStore.resume;
          if (resume == null) {
            return const Center(child: Text('No resume data available'));
          }

          return SingleChildScrollView(
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
                        resume.name,
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
                                    personalInfo: resume.personalInfo),
                                const SizedBox(height: 20),
                                SkillsSection(skills: resume.skills),
                                const SizedBox(height: 20),
                                EducationSection(education: resume.education),
                                const SizedBox(height: 20),
                                CertificationSection(
                                    certifications: resume.certifications),
                                const SizedBox(height: 20),
                                _buildLanguagesSection(resume.languages),
                                const SizedBox(height: 20),
                                _buildWebsitesSection(resume.websites),
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
                                _buildSummarySection(resume.summary),
                                const SizedBox(height: 20),
                                ExperienceSection(
                                    experiences: resume.workExperience),
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
                              personalInfo: resume.personalInfo),
                          const SizedBox(height: 20),
                          _buildSummarySection(resume.summary),
                          const SizedBox(height: 20),
                          ExperienceSection(experiences: resume.workExperience),
                          const SizedBox(height: 20),
                          SkillsSection(skills: resume.skills),
                          const SizedBox(height: 20),
                          EducationSection(education: resume.education),
                          const SizedBox(height: 20),
                          CertificationSection(
                              certifications: resume.certifications),
                          const SizedBox(height: 20),
                          _buildLanguagesSection(resume.languages),
                          const SizedBox(height: 20),
                          _buildWebsitesSection(resume.websites),
                        ],
                      ),
                  ],
                );
              },
            ),
          );
        },
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
