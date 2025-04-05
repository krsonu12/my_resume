import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:my_portfolio/models/resume_model.dart';

class ResumeData {
  static Future<Resume> getResume() async {
    try {
      // Load JSON from asset file
      final String jsonString =
          await rootBundle.loadString('assets/data/resume.json');
      final Map<String, dynamic> jsonData = jsonDecode(jsonString);

      return Resume(
        name: jsonData['name'],
        personalInfo: PersonalInfo(
          email: jsonData['personalInfo']['email'],
          phone: jsonData['personalInfo']['phone'],
          location: jsonData['personalInfo']['location'],
          pincode: jsonData['personalInfo']['pincode'],
        ),
        summary: jsonData['summary'],
        skills: (jsonData['skills'] as List)
            .map((skill) => Skill(name: skill['name']))
            .toList(),
        workExperience: (jsonData['workExperience'] as List)
            .map((exp) => WorkExperience(
                  company: exp['company'],
                  position: exp['position'],
                  location: exp['location'],
                  startDate: DateTime.parse(exp['startDate']),
                  endDate: exp['endDate'] != null
                      ? DateTime.parse(exp['endDate'])
                      : null,
                  responsibilities: (exp['responsibilities'] as List)
                      .map((r) => r.toString())
                      .toList(),
                ))
            .toList(),
        educationEntries: (jsonData['educationEntries'] as List)
            .map((edu) => EducationEntry(
                  degree: edu['degree'],
                  institution: edu['institution'],
                  location: edu['location'],
                  graduationDate: DateTime.parse(edu['graduationDate']),
                  fieldOfStudy: edu['fieldOfStudy'],
                ))
            .toList(),
        languages: (jsonData['languages'] as List)
            .map((lang) => lang.toString())
            .toList(),
        websites: (jsonData['websites'] as List)
            .map((web) => web.toString())
            .toList(),
        certifications: (jsonData['certifications'] as List)
            .map((cert) => Certification(
                  name: cert['name'],
                  date: DateTime.parse(cert['date']),
                  organization: cert['organization'],
                ))
            .toList(),
      );
    } catch (e) {
      throw Exception('Failed to load resume data: $e');
    }
  }
}
