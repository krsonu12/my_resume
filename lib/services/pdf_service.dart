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
    try {
      // Print debug info
      if (kDebugMode) {
        print('Generating PDF for: ${resume.name}');
        print('Summary length: ${resume.summary.length}');
        print('Education entries: ${resume.educationEntries.length}');
        print('Skills: ${resume.skills.length}');
        print('Work experience: ${resume.workExperience.length}');
      }

      // Use a standard PDF font with Unicode support
      final font = await PdfGoogleFonts.robotoRegular();
      final boldFont = await PdfGoogleFonts.robotoBold();
      final italicFont = await PdfGoogleFonts.robotoItalic();

      // Theme color similar to web view
      final themeColor = PdfColor(0.33, 0.43, 0.48); // BlueGrey color

      // Create a document
      final pdf = pw.Document();

      // Create a multi-page document with better formatting
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(40),
          header: (context) {
            if (context.pageNumber == 1) {
              return pw.Container(
                alignment: pw.Alignment.center,
                margin: const pw.EdgeInsets.only(bottom: 20),
                child: pw.Text(
                  resume.name,
                  style: pw.TextStyle(
                    font: boldFont,
                    fontSize: 24,
                    color: themeColor,
                  ),
                ),
              );
            }
            return pw.Container();
          },
          build: (context) => [
            // Summary section
            pw.Container(
              margin: const pw.EdgeInsets.only(bottom: 20),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'PROFESSIONAL SUMMARY',
                    style: pw.TextStyle(
                      font: boldFont,
                      fontSize: 16,
                      color: themeColor,
                    ),
                  ),
                  pw.Divider(color: themeColor, thickness: 1),
                  pw.SizedBox(height: 10),
                  pw.Text(
                    resume.summary,
                    style: pw.TextStyle(font: font, fontSize: 11),
                  ),
                ],
              ),
            ),

            // Two-column layout for desktop-like appearance
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Left column (1/3 width)
                pw.Expanded(
                  flex: 1,
                  child: pw.Container(
                    margin: const pw.EdgeInsets.only(right: 20),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        // Personal info section
                        pw.Container(
                          margin: const pw.EdgeInsets.only(bottom: 20),
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(
                                'CONTACT',
                                style: pw.TextStyle(
                                  font: boldFont,
                                  fontSize: 16,
                                  color: themeColor,
                                ),
                              ),
                              pw.Divider(color: themeColor, thickness: 1),
                              pw.SizedBox(height: 10),
                              pw.Row(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Text('Email: ',
                                      style: pw.TextStyle(
                                          font: boldFont, fontSize: 10)),
                                  pw.Expanded(
                                    child: pw.Text(
                                      resume.personalInfo.email,
                                      style: pw.TextStyle(
                                          font: font, fontSize: 10),
                                    ),
                                  ),
                                ],
                              ),
                              pw.SizedBox(height: 5),
                              pw.Row(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Text('Phone: ',
                                      style: pw.TextStyle(
                                          font: boldFont, fontSize: 10)),
                                  pw.Expanded(
                                    child: pw.Text(
                                      resume.personalInfo.phone,
                                      style: pw.TextStyle(
                                          font: font, fontSize: 10),
                                    ),
                                  ),
                                ],
                              ),
                              pw.SizedBox(height: 5),
                              pw.Row(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Text('Location: ',
                                      style: pw.TextStyle(
                                          font: boldFont, fontSize: 10)),
                                  pw.Expanded(
                                    child: pw.Text(
                                      '${resume.personalInfo.location} ${resume.personalInfo.pincode}',
                                      style: pw.TextStyle(
                                          font: font, fontSize: 10),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Skills section
                        pw.Container(
                          margin: const pw.EdgeInsets.only(bottom: 20),
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(
                                'SKILLS',
                                style: pw.TextStyle(
                                  font: boldFont,
                                  fontSize: 16,
                                  color: themeColor,
                                ),
                              ),
                              pw.Divider(color: themeColor, thickness: 1),
                              pw.SizedBox(height: 10),
                              pw.Wrap(
                                spacing: 5,
                                runSpacing: 5,
                                children: resume.skills.map((skill) {
                                  return pw.Container(
                                    padding: const pw.EdgeInsets.all(4),
                                    decoration: pw.BoxDecoration(
                                      color: PdfColors.grey200,
                                      borderRadius: pw.BorderRadius.circular(4),
                                    ),
                                    child: pw.Text(
                                      skill.name,
                                      style:
                                          pw.TextStyle(font: font, fontSize: 9),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),

                        // Education section
                        pw.Container(
                          margin: const pw.EdgeInsets.only(bottom: 20),
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(
                                'EDUCATION',
                                style: pw.TextStyle(
                                  font: boldFont,
                                  fontSize: 16,
                                  color: themeColor,
                                ),
                              ),
                              pw.Divider(color: themeColor, thickness: 1),
                              pw.SizedBox(height: 10),
                              ...resume.educationEntries.map((edu) {
                                return pw.Container(
                                  margin: const pw.EdgeInsets.only(bottom: 10),
                                  child: pw.Column(
                                    crossAxisAlignment:
                                        pw.CrossAxisAlignment.start,
                                    children: [
                                      pw.Text(
                                        '${edu.degree}${edu.fieldOfStudy != null ? ' - ${edu.fieldOfStudy}' : ''}',
                                        style: pw.TextStyle(
                                            font: boldFont, fontSize: 11),
                                      ),
                                      pw.Text(
                                        '${edu.institution}, ${edu.location}',
                                        style: pw.TextStyle(
                                            font: font, fontSize: 10),
                                      ),
                                      pw.Text(
                                        'Graduated: ${DateFormat('MM/yyyy').format(edu.graduationDate)}',
                                        style: pw.TextStyle(
                                            font: italicFont, fontSize: 9),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),

                        // Languages section
                        pw.Container(
                          margin: const pw.EdgeInsets.only(bottom: 20),
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(
                                'LANGUAGES',
                                style: pw.TextStyle(
                                  font: boldFont,
                                  fontSize: 16,
                                  color: themeColor,
                                ),
                              ),
                              pw.Divider(color: themeColor, thickness: 1),
                              pw.SizedBox(height: 10),
                              ...resume.languages.map((lang) {
                                return pw.Text(
                                  lang,
                                  style: pw.TextStyle(font: font, fontSize: 10),
                                );
                              }),
                            ],
                          ),
                        ),

                        // Websites section
                        pw.Container(
                          margin: const pw.EdgeInsets.only(bottom: 20),
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(
                                'WEBSITES & PROFILES',
                                style: pw.TextStyle(
                                  font: boldFont,
                                  fontSize: 16,
                                  color: themeColor,
                                ),
                              ),
                              pw.Divider(color: themeColor, thickness: 1),
                              pw.SizedBox(height: 10),
                              ...resume.websites.map((site) {
                                return pw.Text(
                                  site,
                                  style: pw.TextStyle(
                                    font: font,
                                    fontSize: 10,
                                    color: PdfColors.blue,
                                    decoration: pw.TextDecoration.underline,
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Right column (2/3 width)
                pw.Expanded(
                  flex: 2,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      // Work Experience section
                      pw.Container(
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              'WORK EXPERIENCE',
                              style: pw.TextStyle(
                                font: boldFont,
                                fontSize: 16,
                                color: themeColor,
                              ),
                            ),
                            pw.Divider(color: themeColor, thickness: 1),
                            pw.SizedBox(height: 10),
                            ...resume.workExperience.map((exp) {
                              final startDate =
                                  DateFormat('MM/yyyy').format(exp.startDate);
                              final endDate = exp.endDate != null
                                  ? DateFormat('MM/yyyy').format(exp.endDate!)
                                  : 'Present';

                              return pw.Container(
                                margin: const pw.EdgeInsets.only(bottom: 15),
                                child: pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.Row(
                                      mainAxisAlignment:
                                          pw.MainAxisAlignment.spaceBetween,
                                      children: [
                                        pw.Expanded(
                                          child: pw.Text(
                                            '${exp.position} at ${exp.company}',
                                            style: pw.TextStyle(
                                                font: boldFont, fontSize: 12),
                                          ),
                                        ),
                                        pw.Text(
                                          '$startDate - $endDate',
                                          style: pw.TextStyle(
                                              font: italicFont, fontSize: 10),
                                        ),
                                      ],
                                    ),
                                    pw.Text(
                                      exp.location,
                                      style: pw.TextStyle(
                                          font: italicFont, fontSize: 10),
                                    ),
                                    pw.SizedBox(height: 5),
                                    ...exp.responsibilities.map((resp) {
                                      return pw.Padding(
                                        padding:
                                            const pw.EdgeInsets.only(bottom: 3),
                                        child: pw.Row(
                                          crossAxisAlignment:
                                              pw.CrossAxisAlignment.start,
                                          children: [
                                            pw.Text('• ',
                                                style: pw.TextStyle(
                                                    font: boldFont,
                                                    fontSize: 10)),
                                            pw.Expanded(
                                              child: pw.Text(
                                                resp,
                                                style: pw.TextStyle(
                                                    font: font, fontSize: 10),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                                  ],
                                ),
                              );
                            }),
                          ],
                        ),
                      ),

                      // Certifications section
                      if (resume.certifications.isNotEmpty)
                        pw.Container(
                          margin: const pw.EdgeInsets.only(top: 20),
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(
                                'CERTIFICATIONS',
                                style: pw.TextStyle(
                                  font: boldFont,
                                  fontSize: 16,
                                  color: themeColor,
                                ),
                              ),
                              pw.Divider(color: themeColor, thickness: 1),
                              pw.SizedBox(height: 10),
                              ...resume.certifications.map((cert) {
                                return pw.Container(
                                  margin: const pw.EdgeInsets.only(bottom: 8),
                                  child: pw.Column(
                                    crossAxisAlignment:
                                        pw.CrossAxisAlignment.start,
                                    children: [
                                      pw.Text(
                                        cert.name,
                                        style: pw.TextStyle(
                                            font: boldFont, fontSize: 11),
                                      ),
                                      pw.Text(
                                        'Date: ${DateFormat('MM/yyyy').format(cert.date)}',
                                        style: pw.TextStyle(
                                            font: italicFont, fontSize: 9),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );

      return pdf.save();
    } catch (e) {
      if (kDebugMode) {
        print('PDF generation error: $e');
        print('Error stack trace: ${StackTrace.current}');
      }
      // Return a simple error PDF
      final pdf = pw.Document();
      final font = await PdfGoogleFonts.robotoRegular();
      pdf.addPage(pw.Page(
        build: (context) => pw.Center(
          child: pw.Text(
            'Error creating PDF: $e',
            style: pw.TextStyle(font: font),
          ),
        ),
      ));
      return pdf.save();
    }
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
      if (kDebugMode) {
        print('PDF save error: $e');
      }
      throw Exception('Error saving PDF: $e');
    }
  }

  // Print PDF
  Future<void> printPdf(Uint8List byteList) async {
    try {
      await Printing.layoutPdf(
        onLayout: (_) async => byteList,
      );
    } catch (e) {
      if (kDebugMode) {
        print('PDF print error: $e');
      }
      throw Exception('Error printing PDF: $e');
    }
  }
}
