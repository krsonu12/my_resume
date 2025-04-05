import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:my_portfolio/models/resume_model.dart' as pdf_model;
import 'package:my_portfolio/modules/common/core/di.dart';
import 'package:my_portfolio/modules/resume/core/resume_store.dart';
import 'package:my_portfolio/modules/resume/widgets/certification_section.dart';
import 'package:my_portfolio/modules/resume/widgets/education_section.dart';
import 'package:my_portfolio/modules/resume/widgets/experience_section.dart';
import 'package:my_portfolio/modules/resume/widgets/personal_info_section.dart';
import 'package:my_portfolio/modules/resume/widgets/skills_section.dart';
import 'package:my_portfolio/services/pdf_service.dart';
import 'package:url_launcher/url_launcher.dart';

class ResumeScreen extends StatefulWidget {
  const ResumeScreen({super.key});

  @override
  State<ResumeScreen> createState() => ResumeScreenState();
}

class ResumeScreenState extends State<ResumeScreen> {
  late final ResumeStore _resumeStore;
  final _pdfService = PdfService();
  bool _isGeneratingPdf = false;

  @override
  void initState() {
    super.initState();
    _resumeStore = DI.resumeStore;
    _loadData();
  }

  Future<void> _loadData() async {
    await _resumeStore.loadResume();
  }

  // Convert from module Resume model to PDF service Resume model
  pdf_model.Resume _convertToPdfModel(resume) {
    // Convert education entries
    final educationEntries = resume.education.entries
        .map((entry) => pdf_model.EducationEntry(
              degree: entry.degree,
              institution: entry.institution,
              location: entry.location,
              graduationDate: entry.graduationDate,
              fieldOfStudy: entry.fieldOfStudy,
            ))
        .toList();

    // Convert certifications
    final certifications = resume.certifications
        .map((cert) => pdf_model.Certification(
              name: cert.name,
              date: cert.date,
              organization: cert.organization,
            ))
        .toList();

    // Convert work experience
    final workExperience = resume.workExperience
        .map((exp) => pdf_model.WorkExperience(
              position: exp.position,
              company: exp.company,
              location: exp.location,
              startDate: exp.startDate,
              endDate: exp.endDate,
              responsibilities: exp.responsibilities,
            ))
        .toList();

    // Convert skills
    final skills = resume.skills
        .map((skill) => pdf_model.Skill(
              name: skill.name,
              category: skill.category,
            ))
        .toList();

    // Convert personal info
    final personalInfo = pdf_model.PersonalInfo(
      email: resume.personalInfo.email,
      phone: resume.personalInfo.phone,
      location: resume.personalInfo.location,
      pincode: resume.personalInfo.pincode,
    );

    // Create and return the PDF model
    return pdf_model.Resume(
      name: resume.name,
      personalInfo: personalInfo,
      summary: resume.summary,
      skills: skills,
      workExperience: workExperience,
      educationEntries: educationEntries,
      languages: resume.languages,
      websites: resume.websites,
      certifications: certifications,
    );
  }

  Future<void> _downloadPdf() async {
    if (_resumeStore.resume == null) return;

    try {
      setState(() {
        _isGeneratingPdf = true;
      });

      // Convert the module resume model to PDF service resume model
      final pdfResume = _convertToPdfModel(_resumeStore.resume!);
      final pdfBytes = await _pdfService.generateResumePdf(pdfResume);
      final fileName =
          '${_resumeStore.resume!.name.replaceAll(' ', '_')}_Resume.pdf';
      await _pdfService.savePdfFile(fileName, pdfBytes);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Resume PDF downloaded successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error downloading PDF: $e')),
        );
      }
    } finally {
      setState(() {
        _isGeneratingPdf = false;
      });
    }
  }

  Future<void> _printPdf() async {
    if (_resumeStore.resume == null) return;

    try {
      setState(() {
        _isGeneratingPdf = true;
      });

      // Convert the module resume model to PDF service resume model
      final pdfResume = _convertToPdfModel(_resumeStore.resume!);

      // Debug logging
      print('Converting to PDF with model:');
      print('- Name: ${pdfResume.name}');
      print('- Education entries: ${pdfResume.educationEntries.length}');
      print('- Certifications: ${pdfResume.certifications.length}');
      print('- Work experience: ${pdfResume.workExperience.length}');

      final pdfBytes = await _pdfService.generateResumePdf(pdfResume);
      await _pdfService.printPdf(pdfBytes);
    } catch (e) {
      print('PDF print error in ResumeScreen: $e');
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
        actions: [
          Observer(builder: (_) {
            if (!_resumeStore.isLoading && _resumeStore.resume != null) {
              return Row(
                children: [
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
                ],
              );
            }
            return const SizedBox.shrink();
          }),
        ],
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
