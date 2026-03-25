import 'dart:io';
import 'dart:typed_data';

import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;

import 'package:mess_manager/core/models/settlement.dart';
import 'package:mess_manager/core/models/member.dart';

/// Export service for generating PDFs, CSVs, XLSX, and sharing files
class ExportService {
  /// Generate Settlement PDF
  static Future<Uint8List> generateSettlementPdf({
    required int year,
    required int month,
    required double totalBazar,
    required double mealRate,
    required List<MemberBalanceSummary> balances,
    required List<SettlementItem> payments,
    required List<Member> members,
    String messName = 'Mess Manager',
  }) async {
    final pdf = pw.Document();

    final monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        header: (context) =>
            _buildPdfHeader(messName, monthNames[month - 1], year),
        footer: (context) => _buildPdfFooter(context),
        build: (context) => [
          // Summary Section
          pw.Container(
            padding: const pw.EdgeInsets.all(16),
            decoration: pw.BoxDecoration(
              color: PdfColors.blue50,
              borderRadius: pw.BorderRadius.circular(8),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryStat(
                  'Total Bazar',
                  '৳${totalBazar.toStringAsFixed(0)}',
                ),
                _buildSummaryStat(
                  'Meal Rate',
                  '৳${mealRate.toStringAsFixed(2)}',
                ),
                _buildSummaryStat('Members', '${balances.length}'),
              ],
            ),
          ),
          pw.SizedBox(height: 24),

          // Member Balances Table
          pw.Text(
            'Member Balances',
            style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 12),
          pw.TableHelper.fromTextArray(
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
            cellPadding: const pw.EdgeInsets.all(8),
            headers: ['Member', 'Bazar', 'Meal Cost', 'Balance'],
            data: balances.map((b) {
              final member = members.firstWhere(
                (m) => m.id == b.memberId,
                orElse: () => Member(
                  id: b.memberId,
                  name: 'Unknown',
                  role: MemberRole.member,
                ),
              );
              return [
                member.name,
                '৳${b.totalBazar.toStringAsFixed(0)}',
                '৳${b.mealCost.toStringAsFixed(0)}',
                '${b.balance >= 0 ? '+' : ''}৳${b.balance.toStringAsFixed(0)}',
              ];
            }).toList(),
          ),
          pw.SizedBox(height: 24),

          // Payments Section
          if (payments.isNotEmpty) ...[
            pw.Text(
              'Settlements (Who Pays Whom)',
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 12),
            pw.TableHelper.fromTextArray(
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              headerDecoration: const pw.BoxDecoration(
                color: PdfColors.grey300,
              ),
              cellPadding: const pw.EdgeInsets.all(8),
              headers: ['From', 'To', 'Amount', 'Status'],
              data: payments.map((p) {
                final from = members.firstWhere(
                  (m) => m.id == p.fromMemberId,
                  orElse: () => Member(
                    id: p.fromMemberId,
                    name: 'Unknown',
                    role: MemberRole.member,
                  ),
                );
                final to = members.firstWhere(
                  (m) => m.id == p.toMemberId,
                  orElse: () => Member(
                    id: p.toMemberId,
                    name: 'Unknown',
                    role: MemberRole.member,
                  ),
                );
                return [
                  from.name,
                  to.name,
                  '৳${p.amount.toStringAsFixed(0)}',
                  p.isPaid ? '✓ Paid' : 'Pending',
                ];
              }).toList(),
            ),
          ],
        ],
      ),
    );

    return pdf.save();
  }

  static pw.Widget _buildPdfHeader(String messName, String month, int year) {
    return pw.Container(
      padding: const pw.EdgeInsets.only(bottom: 16),
      decoration: const pw.BoxDecoration(
        border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey400)),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                messName,
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.blue800,
                ),
              ),
              pw.Text(
                'Monthly Settlement Report',
                style: const pw.TextStyle(
                  fontSize: 12,
                  color: PdfColors.grey600,
                ),
              ),
            ],
          ),
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: pw.BoxDecoration(
              color: PdfColors.blue100,
              borderRadius: pw.BorderRadius.circular(4),
            ),
            child: pw.Text(
              '$month $year',
              style: pw.TextStyle(
                fontSize: 14,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.blue800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildPdfFooter(pw.Context context) {
    return pw.Container(
      padding: const pw.EdgeInsets.only(top: 8),
      decoration: const pw.BoxDecoration(
        border: pw.Border(top: pw.BorderSide(color: PdfColors.grey300)),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            'Generated by Mess Manager',
            style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey500),
          ),
          pw.Text(
            'Page ${context.pageNumber} of ${context.pagesCount}',
            style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey500),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildSummaryStat(String label, String value) {
    return pw.Column(
      children: [
        pw.Text(
          value,
          style: pw.TextStyle(
            fontSize: 18,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.blue800,
          ),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          label,
          style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
        ),
      ],
    );
  }

  /// Print or share PDF
  static Future<void> printPdf(Uint8List pdfBytes) async {
    await Printing.layoutPdf(onLayout: (_) => pdfBytes);
  }

  /// Share PDF file
  static Future<void> sharePdf(Uint8List pdfBytes, String filename) async {
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/$filename');
    await file.writeAsBytes(pdfBytes);

    await SharePlus.instance.share(
      ShareParams(files: [XFile(file.path)], text: 'Monthly Settlement Report'),
    );
  }

  /// Generate CSV for balances
  static String generateBalancesCsv({
    required List<MemberBalanceSummary> balances,
    required List<Member> members,
  }) {
    final rows = <List<dynamic>>[
      ['Member', 'Total Bazar', 'Meal Cost', 'Monthly Share', 'Balance'],
    ];

    for (final b in balances) {
      final member = members.firstWhere(
        (m) => m.id == b.memberId,
        orElse: () =>
            Member(id: b.memberId, name: 'Unknown', role: MemberRole.member),
      );
      rows.add([
        member.name,
        b.totalBazar,
        b.mealCost,
        b.monthlyShare,
        b.balance,
      ]);
    }

    return const ListToCsvConverter().convert(rows);
  }

  /// Save CSV to file
  static Future<File> saveCsv(String csv, String filename) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$filename');
    return file.writeAsString(csv);
  }

  /// Share CSV file
  static Future<void> shareCsv(String csv, String filename) async {
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/$filename');
    await file.writeAsString(csv);

    await SharePlus.instance.share(
      ShareParams(files: [XFile(file.path)], text: 'Mess Manager Export'),
    );
  }

  // ==================== EXCEL (XLSX) EXPORT ====================

  /// Generate Excel (XLSX) file for balances
  static Uint8List generateBalancesXlsx({
    required int year,
    required int month,
    required double totalBazar,
    required double mealRate,
    required List<MemberBalanceSummary> balances,
    required List<Member> members,
    String messName = 'Mess Manager',
  }) {
    final monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    // Create workbook & sheet
    final workbook = xlsio.Workbook();
    final sheet = workbook.worksheets[0];
    sheet.name = '${monthNames[month - 1]} $year';

    // Define styles
    final headerStyle = workbook.styles.add('headerStyle');
    headerStyle.bold = true;
    headerStyle.fontColor = '#FFFFFF';
    headerStyle.backColor = '#2196F3';
    headerStyle.hAlign = xlsio.HAlignType.center;

    final titleStyle = workbook.styles.add('titleStyle');
    titleStyle.bold = true;
    titleStyle.fontSize = 16;

    final currencyStyle = workbook.styles.add('currencyStyle');
    currencyStyle.hAlign = xlsio.HAlignType.right;
    currencyStyle.numberFormat = '৳#,##0.00';

    final positiveStyle = workbook.styles.add('positiveStyle');
    positiveStyle.fontColor = '#4CAF50';
    positiveStyle.hAlign = xlsio.HAlignType.right;

    final negativeStyle = workbook.styles.add('negativeStyle');
    negativeStyle.fontColor = '#F44336';
    negativeStyle.hAlign = xlsio.HAlignType.right;

    // Title row
    sheet.getRangeByName('A1').setText('$messName - Settlement Report');
    sheet.getRangeByName('A1').cellStyle = titleStyle;
    sheet.getRangeByName('A1:E1').merge();

    // Summary row
    sheet.getRangeByName('A3').setText('Month:');
    sheet.getRangeByName('B3').setText('${monthNames[month - 1]} $year');
    sheet.getRangeByName('C3').setText('Total Bazar:');
    sheet.getRangeByName('D3').setNumber(totalBazar);
    sheet.getRangeByName('D3').cellStyle = currencyStyle;
    sheet.getRangeByName('A4').setText('Members:');
    sheet.getRangeByName('B4').setNumber(balances.length.toDouble());
    sheet.getRangeByName('C4').setText('Meal Rate:');
    sheet.getRangeByName('D4').setNumber(mealRate);
    sheet.getRangeByName('D4').cellStyle = currencyStyle;

    // Headers
    sheet.getRangeByName('A6').setText('Member');
    sheet.getRangeByName('B6').setText('Total Bazar');
    sheet.getRangeByName('C6').setText('Meal Cost');
    sheet.getRangeByName('D6').setText('Monthly Share');
    sheet.getRangeByName('E6').setText('Balance');
    for (var col in ['A6', 'B6', 'C6', 'D6', 'E6']) {
      sheet.getRangeByName(col).cellStyle = headerStyle;
    }

    // Data rows
    var row = 7;
    for (final b in balances) {
      final member = members.firstWhere(
        (m) => m.id == b.memberId,
        orElse: () =>
            Member(id: b.memberId, name: 'Unknown', role: MemberRole.member),
      );

      sheet.getRangeByName('A$row').setText(member.name);
      sheet.getRangeByName('B$row').setNumber(b.totalBazar);
      sheet.getRangeByName('B$row').cellStyle = currencyStyle;
      sheet.getRangeByName('C$row').setNumber(b.mealCost);
      sheet.getRangeByName('C$row').cellStyle = currencyStyle;
      sheet.getRangeByName('D$row').setNumber(b.monthlyShare);
      sheet.getRangeByName('D$row').cellStyle = currencyStyle;
      sheet.getRangeByName('E$row').setNumber(b.balance);
      sheet.getRangeByName('E$row').cellStyle = b.balance >= 0
          ? positiveStyle
          : negativeStyle;

      row++;
    }

    // Auto-fit columns
    for (var i = 1; i <= 5; i++) {
      sheet.autoFitColumn(i);
    }

    // Save and cleanup
    final bytes = workbook.saveAsStream();
    workbook.dispose();

    return Uint8List.fromList(bytes);
  }

  /// Share Excel file
  static Future<void> shareXlsx(Uint8List xlsxBytes, String filename) async {
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/$filename');
    await file.writeAsBytes(xlsxBytes);

    await SharePlus.instance.share(
      ShareParams(files: [XFile(file.path)], text: 'Mess Manager Excel Export'),
    );
  }

  /// Save Excel to file
  static Future<File> saveXlsx(Uint8List xlsxBytes, String filename) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$filename');
    return file.writeAsBytes(xlsxBytes);
  }
}
