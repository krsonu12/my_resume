import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:my_portfolio/models/resume_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:universal_html/html.dart' as html;

class PdfService {
  Future<Uint8List> generateResumePdf(Resume resume) async {
    final pdf = pw.Document();

    // Load Google fonts
    final regularFont = await PdfGoogleFonts.nunitoRegular();
    final boldFont = await PdfGoogleFonts.nunitoBold();
    final italicFont = await PdfGoogleFonts.nunitoItalic();

    final themeColor = PdfColor.fromHex('#546E7A'); // BlueGrey primary color

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        header: (pw.Context context) =>
            _buildHeader(resume, boldFont, themeColor),
        build: (pw.Context context) => [
          _buildSummary(resume.summary, regularFont, boldFont, themeColor),
          pw.SizedBox(height: 20),

          // Create a row with two columns to match the web layout
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Left column - smaller
              pw.Expanded(
                flex: 1,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _buildPersonalInfo(
                        resume.personalInfo, regularFont, boldFont, themeColor),
                    pw.SizedBox(height: 16),
                    _buildSkills(
                        resume.skills, regularFont, boldFont, themeColor),
                    pw.SizedBox(height: 16),
                    _buildEducation(resume.educationEntries, regularFont,
                        boldFont, italicFont, themeColor),
                    pw.SizedBox(height: 16),
                    _buildLanguages(
                        resume.languages, regularFont, boldFont, themeColor),
                    pw.SizedBox(height: 16),
                    _buildWebsites(
                        resume.websites, regularFont, boldFont, themeColor),
                    pw.SizedBox(height: 16),
                    _buildCertifications(resume.certifications, regularFont,
                        boldFont, italicFont, themeColor),
                  ],
                ),
              ),
              pw.SizedBox(width: 24),
              // Right column - larger
              pw.Expanded(
                flex: 2,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _buildWorkExperience(resume.workExperience, regularFont,
                        boldFont, italicFont, themeColor),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );

    return pdf.save();
  }

  pw.Widget _buildHeader(
      Resume resume, pw.Font headerFont, PdfColor themeColor) {
    return pw.Container(
      padding: const pw.EdgeInsets.only(bottom: 8),
      decoration: pw.BoxDecoration(
        border: pw.Border(bottom: pw.BorderSide(color: themeColor, width: 1.5)),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            resume.name.toUpperCase(),
            style: pw.TextStyle(
              font: headerFont,
              fontSize: 24,
              color: themeColor,
            ),
          ),
          pw.Text(
            'Résumé',
            style: pw.TextStyle(
              font: headerFont,
              fontSize: 14,
              color: themeColor,
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildSummary(String summary, pw.Font regularFont, pw.Font boldFont,
      PdfColor themeColor) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'PROFESSIONAL SUMMARY',
          style: pw.TextStyle(
            font: boldFont,
            fontSize: 14,
            color: themeColor,
          ),
        ),
        pw.SizedBox(height: 8),
        pw.Text(
          summary,
          style: pw.TextStyle(
            font: regularFont,
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  pw.Widget _buildPersonalInfo(PersonalInfo info, pw.Font regularFont,
      pw.Font boldFont, PdfColor themeColor) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'CONTACT',
          style: pw.TextStyle(
            font: boldFont,
            fontSize: 14,
            color: themeColor,
          ),
        ),
        pw.SizedBox(height: 8),
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'Email: ',
              style: pw.TextStyle(
                font: boldFont,
                fontSize: 10,
              ),
            ),
            pw.Expanded(
              child: pw.Text(
                info.email,
                style: pw.TextStyle(
                  font: regularFont,
                  fontSize: 10,
                  color: PdfColors.blue,
                ),
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 4),
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'Phone: ',
              style: pw.TextStyle(
                font: boldFont,
                fontSize: 10,
              ),
            ),
            pw.Text(
              info.phone,
              style: pw.TextStyle(
                font: regularFont,
                fontSize: 10,
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 4),
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'Location: ',
              style: pw.TextStyle(
                font: boldFont,
                fontSize: 10,
              ),
            ),
            pw.Expanded(
              child: pw.Text(
                '${info.location} ${info.pincode}',
                style: pw.TextStyle(
                  font: regularFont,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildWorkExperience(
      List<WorkExperience> experiences,
      pw.Font regularFont,
      pw.Font boldFont,
      pw.Font italicFont,
      PdfColor themeColor) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'WORK EXPERIENCE',
          style: pw.TextStyle(
            font: boldFont,
            fontSize: 14,
            color: themeColor,
          ),
        ),
        pw.SizedBox(height: 8),
        ...experiences.map((exp) =>
            _buildExperienceItem(exp, regularFont, boldFont, italicFont)),
      ],
    );
  }

  pw.Widget _buildExperienceItem(WorkExperience exp, pw.Font regularFont,
      pw.Font boldFont, pw.Font italicFont) {
    final dateFormat = DateFormat('MM/yyyy');
    final startDate = dateFormat.format(exp.startDate);
    final endDate =
        exp.endDate != null ? dateFormat.format(exp.endDate!) : 'Present';

    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 12),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Expanded(
                child: pw.Text(
                  '${exp.position} at ${exp.company}',
                  style: pw.TextStyle(
                    font: boldFont,
                    fontSize: 12,
                  ),
                ),
              ),
              pw.Text(
                '$startDate - $endDate',
                style: pw.TextStyle(
                  font: italicFont,
                  fontSize: 10,
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 2),
          pw.Text(
            exp.location,
            style: pw.TextStyle(
              font: italicFont,
              fontSize: 10,
            ),
          ),
          pw.SizedBox(height: 4),
          ...exp.responsibilities.map((resp) => pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 2),
                child: pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('• ',
                        style: pw.TextStyle(font: boldFont, fontSize: 10)),
                    pw.Expanded(
                      child: pw.Text(
                        resp,
                        style: pw.TextStyle(font: regularFont, fontSize: 10),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  pw.Widget _buildSkills(List<Skill> skills, pw.Font regularFont,
      pw.Font boldFont, PdfColor themeColor) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'SKILLS',
          style: pw.TextStyle(
            font: boldFont,
            fontSize: 14,
            color: themeColor,
          ),
        ),
        pw.SizedBox(height: 8),
        pw.Wrap(
          spacing: 5,
          runSpacing: 5,
          children: skills
              .map((skill) => pw.Container(
                    padding: const pw.EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: pw.BoxDecoration(
                      color: PdfColors.grey200,
                      borderRadius: pw.BorderRadius.circular(4),
                    ),
                    child: pw.Text(
                      skill.name,
                      style: pw.TextStyle(
                        font: regularFont,
                        fontSize: 9,
                      ),
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }

  pw.Widget _buildEducation(List<EducationEntry> entries, pw.Font regularFont,
      pw.Font boldFont, pw.Font italicFont, PdfColor themeColor) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'EDUCATION',
          style: pw.TextStyle(
            font: boldFont,
            fontSize: 14,
            color: themeColor,
          ),
        ),
        pw.SizedBox(height: 8),
        ...entries.map((edu) {
          final dateFormat = DateFormat('MM/yyyy');
          final gradDate = dateFormat.format(edu.graduationDate);

          return pw.Container(
            margin: const pw.EdgeInsets.only(bottom: 8),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  '${edu.degree}${edu.fieldOfStudy != null ? ' - ${edu.fieldOfStudy}' : ''}',
                  style: pw.TextStyle(
                    font: boldFont,
                    fontSize: 11,
                  ),
                ),
                pw.SizedBox(height: 2),
                pw.Text(
                  '${edu.institution}, ${edu.location}',
                  style: pw.TextStyle(
                    font: regularFont,
                    fontSize: 10,
                  ),
                ),
                pw.SizedBox(height: 2),
                pw.Text(
                  'Graduated: $gradDate',
                  style: pw.TextStyle(
                    font: italicFont,
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  pw.Widget _buildLanguages(List<String> languages, pw.Font regularFont,
      pw.Font boldFont, PdfColor themeColor) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'LANGUAGES',
          style: pw.TextStyle(
            font: boldFont,
            fontSize: 14,
            color: themeColor,
          ),
        ),
        pw.SizedBox(height: 8),
        ...languages.map((lang) => pw.Text(
              lang,
              style: pw.TextStyle(
                font: regularFont,
                fontSize: 10,
              ),
            )),
      ],
    );
  }

  pw.Widget _buildWebsites(List<String> websites, pw.Font regularFont,
      pw.Font boldFont, PdfColor themeColor) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'WEBSITES & PROFILES',
          style: pw.TextStyle(
            font: boldFont,
            fontSize: 14,
            color: themeColor,
          ),
        ),
        pw.SizedBox(height: 8),
        ...websites.map((site) => pw.Text(
              site,
              style: pw.TextStyle(
                font: regularFont,
                fontSize: 10,
                color: PdfColors.blue,
                decoration: pw.TextDecoration.underline,
              ),
            )),
      ],
    );
  }

  pw.Widget _buildCertifications(
      List<Certification> certifications,
      pw.Font regularFont,
      pw.Font boldFont,
      pw.Font italicFont,
      PdfColor themeColor) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'CERTIFICATIONS',
          style: pw.TextStyle(
            font: boldFont,
            fontSize: 14,
            color: themeColor,
          ),
        ),
        pw.SizedBox(height: 8),
        ...certifications.map((cert) {
          final dateFormat = DateFormat('MM/yyyy');
          final certDate = dateFormat.format(cert.date);

          return pw.Container(
            margin: const pw.EdgeInsets.only(bottom: 6),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  cert.name,
                  style: pw.TextStyle(
                    font: boldFont,
                    fontSize: 10,
                  ),
                ),
                if (cert.organization != null &&
                    cert.organization!.isNotEmpty) ...[
                  pw.SizedBox(height: 2),
                  pw.Text(
                    cert.organization!,
                    style: pw.TextStyle(
                      font: regularFont,
                      fontSize: 9,
                    ),
                  ),
                ],
                pw.SizedBox(height: 2),
                pw.Text(
                  'Date: $certDate',
                  style: pw.TextStyle(
                    font: italicFont,
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  // Save PDF file
  Future<void> savePdfFile(String fileName, Uint8List byteList) async {
    try {
      if (kIsWeb) {
        // For web, create a download link
        final blob = html.Blob([byteList], 'application/pdf');
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..setAttribute('download', fileName)
          ..click();
        html.Url.revokeObjectUrl(url);
      } else {
        // For mobile/desktop, save to device storage
        final output = await getTemporaryDirectory();
        final filePath = '${output.path}/$fileName';
        final file = File(filePath);
        await file.writeAsBytes(byteList);
      }
    } catch (e) {
      throw Exception('Error saving PDF: $e');
    }
  }

  // Print PDF
  Future<void> printPdf(Uint8List byteList) async {
    await Printing.layoutPdf(
      onLayout: (_) async => byteList,
    );
  }
}
