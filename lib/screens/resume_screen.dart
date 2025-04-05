import 'package:flutter/material.dart';
import 'package:my_portfolio/models/resume_data.dart';
import 'package:my_portfolio/models/resume_model.dart';
import 'package:my_portfolio/services/pdf_service.dart';
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
  Resume? _resume;
  bool _isLoading = true;
  bool _isGeneratingPdf = false;
  String? _error;
  final _pdfService = PdfService();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      _resume = await ResumeData.getResume();
    } catch (e) {
      _error = e.toString();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _downloadPdf() async {
    if (_resume == null) return;

    try {
      setState(() {
        _isGeneratingPdf = true;
      });

      final pdfBytes = await _pdfService.generateResumePdf(_resume!);
      final fileName = '${_resume!.name.replaceAll(' ', '_')}_Resume.pdf';
      await _pdfService.savePdfFile(fileName, pdfBytes);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Resume PDF downloaded successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error generating PDF: $e')),
        );
      }
    } finally {
      setState(() {
        _isGeneratingPdf = false;
      });
    }
  }

  Future<void> _printPdf() async {
    if (_resume == null) return;

    try {
      setState(() {
        _isGeneratingPdf = true;
      });

      final pdfBytes = await _pdfService.generateResumePdf(_resume!);
      await _pdfService.printPdf(pdfBytes);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error printing PDF: $e')),
        );
      }
    } finally {
      setState(() {
        _isGeneratingPdf = false;
      });
    }
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
        actions: [
          if (!_isLoading && _resume != null) ...[
            IconButton(
              icon: const Icon(Icons.print),
              tooltip: 'Print Resume',
              onPressed: _isGeneratingPdf ? null : _printPdf,
            ),
            IconButton(
              icon: _isGeneratingPdf
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.download),
              tooltip: 'Download PDF',
              onPressed: _isGeneratingPdf ? null : _downloadPdf,
            ),
          ]
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SelectableText.rich(
              TextSpan(
                text: 'Error: $_error',
                style: const TextStyle(color: Colors.red),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadData,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_resume == null) {
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
                  _resume!.name,
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
                              personalInfo: _resume!.personalInfo),
                          const SizedBox(height: 20),
                          SkillsSection(skills: _resume!.skills),
                          const SizedBox(height: 20),
                          EducationSection(
                              educationEntries: _resume!.educationEntries),
                          const SizedBox(height: 20),
                          CertificationSection(
                              certifications: _resume!.certifications),
                          const SizedBox(height: 20),
                          _buildLanguagesSection(_resume!.languages),
                          const SizedBox(height: 20),
                          _buildWebsitesSection(_resume!.websites),
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
                          _buildSummarySection(_resume!.summary),
                          const SizedBox(height: 20),
                          ExperienceSection(
                              experiences: _resume!.workExperience),
                        ],
                      ),
                    ),
                  ],
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PersonalInfoSection(personalInfo: _resume!.personalInfo),
                    const SizedBox(height: 20),
                    _buildSummarySection(_resume!.summary),
                    const SizedBox(height: 20),
                    ExperienceSection(experiences: _resume!.workExperience),
                    const SizedBox(height: 20),
                    SkillsSection(skills: _resume!.skills),
                    const SizedBox(height: 20),
                    EducationSection(
                        educationEntries: _resume!.educationEntries),
                    const SizedBox(height: 20),
                    CertificationSection(
                        certifications: _resume!.certifications),
                    const SizedBox(height: 20),
                    _buildLanguagesSection(_resume!.languages),
                    const SizedBox(height: 20),
                    _buildWebsitesSection(_resume!.websites),
                  ],
                ),

              // Download button at the bottom for mobile
              if (!isDesktop) ...[
                const SizedBox(height: 30),
                Center(
                  child: ElevatedButton.icon(
                    icon: _isGeneratingPdf
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.download),
                    label: const Text('Download Resume PDF'),
                    onPressed: _isGeneratingPdf ? null : _downloadPdf,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ],
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
