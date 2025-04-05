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
      // Use a standard PDF font with Unicode support
      final font = await PdfGoogleFonts.nunitoRegular();
      final boldFont = await PdfGoogleFonts.nunitoBold();
      final italicFont = await PdfGoogleFonts.nunitoItalic();

      // Use a font with good bullet point support
      final symbolFont = pw.Font.helvetica();

      // Theme color - slate blue-gray from the reference image
      final themeColor = PdfColor(0.40, 0.47, 0.55);

      // Document format with smaller margins
      final pageFormat = PdfPageFormat.a4.copyWith(
        marginTop: 25,
        marginBottom: 25,
        marginLeft: 25,
        marginRight: 25,
      );

      // Create a document
      final pdf = pw.Document();

      // Create a multi-page document instead of a single page to handle overflow
      pdf.addPage(
        pw.MultiPage(
          pageFormat: pageFormat,
          maxPages: 2,
          build: (context) => [
            _buildHeader(resume, boldFont, font, themeColor),
            pw.SizedBox(height: 15),
            _buildMainContent(
                resume, boldFont, italicFont, font, symbolFont, themeColor),
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
      final font = await PdfGoogleFonts.nunitoRegular();
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

  pw.Widget _buildHeader(
      Resume resume, pw.Font boldFont, pw.Font font, PdfColor themeColor) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // Left column (1/3 width) - Contact info
        pw.Expanded(
          flex: 1,
          child: pw.Container(
            padding: const pw.EdgeInsets.all(10),
            color: themeColor,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  resume.personalInfo.email,
                  style: pw.TextStyle(
                    font: font,
                    fontSize: 9,
                    color: PdfColors.white,
                  ),
                ),
                pw.SizedBox(height: 5),
                pw.Text(
                  resume.personalInfo.phone,
                  style: pw.TextStyle(
                    font: font,
                    fontSize: 9,
                    color: PdfColors.white,
                  ),
                ),
                pw.SizedBox(height: 5),
                pw.Text(
                  resume.personalInfo.location,
                  style: pw.TextStyle(
                    font: font,
                    fontSize: 9,
                    color: PdfColors.white,
                  ),
                ),
                pw.Text(
                  resume.personalInfo.pincode,
                  style: pw.TextStyle(
                    font: font,
                    fontSize: 9,
                    color: PdfColors.white,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Right column (2/3 width) - Name
        pw.Expanded(
          flex: 2,
          child: pw.Container(
            alignment: pw.Alignment.centerLeft,
            padding: const pw.EdgeInsets.only(left: 15),
            child: pw.Text(
              resume.name,
              style: pw.TextStyle(
                font: boldFont,
                fontSize: 24,
                color: themeColor,
              ),
            ),
          ),
        ),
      ],
    );
  }

  pw.Widget _buildMainContent(
      Resume resume,
      pw.Font boldFont,
      pw.Font italicFont,
      pw.Font font,
      pw.Font symbolFont,
      PdfColor themeColor) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // Left column (1/3 width)
        pw.Expanded(
          flex: 1,
          child: pw.Container(
            margin: const pw.EdgeInsets.only(right: 10),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Skills section
                pw.Container(
                  margin: const pw.EdgeInsets.only(bottom: 15),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'Skills',
                        style: pw.TextStyle(
                          font: boldFont,
                          fontSize: 14,
                          color: themeColor,
                        ),
                      ),
                      pw.Container(
                        height: 1,
                        width: double.infinity,
                        color: PdfColors.grey300,
                        margin: const pw.EdgeInsets.symmetric(vertical: 5),
                      ),
                      pw.SizedBox(height: 3),
                      ...resume.skills.map((skill) {
                        return pw.Padding(
                          padding: const pw.EdgeInsets.symmetric(vertical: 1),
                          child: pw.Row(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text('- ',
                                  style: pw.TextStyle(
                                    font: symbolFont,
                                    fontSize: 9,
                                  )),
                              pw.Expanded(
                                child: pw.Text(
                                  skill.name,
                                  style: pw.TextStyle(font: font, fontSize: 9),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),

                // Education section
                pw.Container(
                  margin: const pw.EdgeInsets.only(bottom: 15),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'Education',
                        style: pw.TextStyle(
                          font: boldFont,
                          fontSize: 14,
                          color: themeColor,
                        ),
                      ),
                      pw.Container(
                        height: 1,
                        width: double.infinity,
                        color: PdfColors.grey300,
                        margin: const pw.EdgeInsets.symmetric(vertical: 5),
                      ),
                      pw.SizedBox(height: 3),
                      ...resume.educationEntries.map((edu) {
                        final gradDate =
                            DateFormat('MM/yyyy').format(edu.graduationDate);
                        return pw.Container(
                          margin: const pw.EdgeInsets.only(bottom: 6),
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(
                                gradDate,
                                style: pw.TextStyle(font: font, fontSize: 9),
                              ),
                              pw.Text(
                                'Bachelor:',
                                style:
                                    pw.TextStyle(font: boldFont, fontSize: 9),
                              ),
                              pw.Text(
                                edu.degree,
                                style: pw.TextStyle(font: font, fontSize: 9),
                              ),
                              pw.Text(
                                edu.institution,
                                style: pw.TextStyle(font: font, fontSize: 9),
                              ),
                              pw.Text(
                                edu.location,
                                style: pw.TextStyle(font: font, fontSize: 9),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),

                // Websites section
                pw.Container(
                  margin: const pw.EdgeInsets.only(bottom: 15),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'Websites, Portfolios, Profiles',
                        style: pw.TextStyle(
                          font: boldFont,
                          fontSize: 14,
                          color: themeColor,
                        ),
                      ),
                      pw.Container(
                        height: 1,
                        width: double.infinity,
                        color: PdfColors.grey300,
                        margin: const pw.EdgeInsets.symmetric(vertical: 5),
                      ),
                      pw.SizedBox(height: 3),
                      ...resume.websites.map((site) {
                        return pw.Padding(
                          padding: const pw.EdgeInsets.symmetric(vertical: 1),
                          child: pw.Text(
                            site,
                            style: pw.TextStyle(
                              font: font,
                              fontSize: 9,
                              color: PdfColors.blue,
                              decoration: pw.TextDecoration.underline,
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),

                // Certifications section
                pw.Container(
                  margin: const pw.EdgeInsets.only(bottom: 15),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'Certifications',
                        style: pw.TextStyle(
                          font: boldFont,
                          fontSize: 14,
                          color: themeColor,
                        ),
                      ),
                      pw.Container(
                        height: 1,
                        width: double.infinity,
                        color: PdfColors.grey300,
                        margin: const pw.EdgeInsets.symmetric(vertical: 5),
                      ),
                      pw.SizedBox(height: 3),
                      ...resume.certifications.map((cert) {
                        final certDate =
                            DateFormat('MM/dd/yy').format(cert.date);
                        return pw.Padding(
                          padding: const pw.EdgeInsets.symmetric(vertical: 1),
                          child: pw.Text(
                            '${cert.name}, $certDate',
                            style: pw.TextStyle(font: font, fontSize: 9),
                          ),
                        );
                      }),
                    ],
                  ),
                ),

                // Languages section
                pw.Container(
                  margin: const pw.EdgeInsets.only(bottom: 15),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'Languages',
                        style: pw.TextStyle(
                          font: boldFont,
                          fontSize: 14,
                          color: themeColor,
                        ),
                      ),
                      pw.Container(
                        height: 1,
                        width: double.infinity,
                        color: PdfColors.grey300,
                        margin: const pw.EdgeInsets.symmetric(vertical: 5),
                      ),
                      pw.SizedBox(height: 3),
                      ...resume.languages.map((lang) {
                        final parts = lang.split(':');
                        if (parts.length > 1) {
                          return pw.Padding(
                            padding: const pw.EdgeInsets.symmetric(vertical: 1),
                            child: pw.RichText(
                              text: pw.TextSpan(
                                children: [
                                  pw.TextSpan(
                                    text: '${parts[0]}: ',
                                    style: pw.TextStyle(
                                        font: boldFont, fontSize: 9),
                                  ),
                                  pw.TextSpan(
                                    text: parts[1].trim(),
                                    style:
                                        pw.TextStyle(font: font, fontSize: 9),
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          return pw.Padding(
                            padding: const pw.EdgeInsets.symmetric(vertical: 1),
                            child: pw.Text(
                              lang,
                              style: pw.TextStyle(font: font, fontSize: 9),
                            ),
                          );
                        }
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        pw.SizedBox(width: 15),

        // Right column (2/3 width)
        pw.Expanded(
          flex: 2,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Personal Summary section
              pw.Container(
                margin: const pw.EdgeInsets.only(bottom: 15),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Personal Summary',
                      style: pw.TextStyle(
                        font: boldFont,
                        fontSize: 14,
                        color: themeColor,
                      ),
                    ),
                    pw.Container(
                      height: 1,
                      width: double.infinity,
                      color: PdfColors.grey300,
                      margin: const pw.EdgeInsets.symmetric(vertical: 5),
                    ),
                    pw.SizedBox(height: 3),
                    pw.Text(
                      'As a ${resume.summary}',
                      style: pw.TextStyle(font: font, fontSize: 9),
                    ),
                  ],
                ),
              ),

              // Work Experience section
              pw.Container(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Work Experience',
                      style: pw.TextStyle(
                        font: boldFont,
                        fontSize: 14,
                        color: themeColor,
                      ),
                    ),
                    pw.Container(
                      height: 1,
                      width: double.infinity,
                      color: PdfColors.grey300,
                      margin: const pw.EdgeInsets.symmetric(vertical: 5),
                    ),
                    pw.SizedBox(height: 3),
                    ...resume.workExperience.map((exp) {
                      final startDate =
                          DateFormat('MM/yyyy').format(exp.startDate);
                      final endDate = exp.endDate != null
                          ? DateFormat('MM/yyyy').format(exp.endDate!)
                          : 'Current';

                      return pw.Container(
                        margin: const pw.EdgeInsets.only(bottom: 12),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              '${exp.company} - ${exp.position}',
                              style: pw.TextStyle(font: boldFont, fontSize: 11),
                            ),
                            pw.Text(
                              exp.location,
                              style:
                                  pw.TextStyle(font: italicFont, fontSize: 9),
                            ),
                            pw.Text(
                              '$startDate - $endDate',
                              style:
                                  pw.TextStyle(font: italicFont, fontSize: 9),
                            ),
                            pw.SizedBox(height: 3),
                            ...exp.responsibilities.map((resp) {
                              return pw.Padding(
                                padding: const pw.EdgeInsets.only(bottom: 2),
                                child: pw.Row(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.Text('- ',
                                        style: pw.TextStyle(
                                          font: symbolFont,
                                          fontSize: 9,
                                        )),
                                    pw.Expanded(
                                      child: pw.Text(
                                        resp,
                                        style: pw.TextStyle(
                                            font: font, fontSize: 9),
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
            ],
          ),
        ),
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
