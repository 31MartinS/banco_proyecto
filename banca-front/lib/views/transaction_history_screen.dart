import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:provider/provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../controllers/transaction_controller.dart';
import '../controllers/auth_controller.dart';
import '../models/transaction.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({Key? key}) : super(key: key);
  @override
  State<TransactionHistoryScreen> createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  @override
  void initState() {
    super.initState();
    final authController = Provider.of<AuthController>(context, listen: false);
    final transactionController = Provider.of<TransactionController>(context, listen: false);
    transactionController.fetchTransactions(authController.currentUser!.id, authController.idToken!);
  }

  // Función para generar el PDF en formato de tabla
  Future<pw.Document> _generatePdfWithTable(List<TransactionModel> transactions) async {
    final pdf = pw.Document();

    // Creamos una página (MultiPage si la tabla puede ser larga)
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        build: (pw.Context context) {
          return [
            pw.Text(
              'Historial de Transacciones',
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 16),
            _buildTransactionsTable(transactions),
          ];
        },
      ),
    );

    return pdf;
  }

// Helper que crea la tabla
  pw.Widget _buildTransactionsTable(List<TransactionModel> transactions) {
    // Encabezados de la tabla
    final headers = [
      'Fecha',
      'Monto',
      'Detalles',
    ];

    // Filas de la tabla
    final dataRows = transactions.map((tx) {
      // Formatear la fecha
      String formattedDate;
      try {
        final date = DateTime.parse(tx.date);
        formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(date);
      } catch (_) {
        formattedDate = tx.date;
      }
      return [
        formattedDate,
        '\$${tx.amount.toStringAsFixed(2)}',
        tx.details,
      ];
    }).toList();

    // Retornamos un pw.Table
    return pw.Table(
      border: pw.TableBorder.all(),
      columnWidths: {
        0: const pw.FlexColumnWidth(2), // fecha
        1: const pw.FlexColumnWidth(2), // monto
        2: const pw.FlexColumnWidth(4), // detalles
      },
      children: [
        // Fila de encabezados
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey300),
          children: headers
              .map(
                (header) => pw.Padding(
              padding: const pw.EdgeInsets.all(8),
              child: pw.Text(
                header,
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
            ),
          )
              .toList(),
        ),
        // Filas de datos
        for (var row in dataRows)
          pw.TableRow(
            children: [
              for (var cell in row)
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text(cell),
                ),
            ],
          )
      ],
    );
  }

  void _downloadPdf(List<TransactionModel> transactions) async {
    final pdf = await _generatePdfWithTable(transactions);
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final transactionController = Provider.of<TransactionController>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Historial de Transacciones')),
      body: transactionController.transactions.isEmpty
          ? const Center(child: Text('No hay transacciones registradas.'))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: transactionController.transactions.length,
        itemBuilder: (context, index) {
          TransactionModel tx = transactionController.transactions[index];
          // Formatear la fecha para mostrar solo "yyyy-MM-dd"
          String formattedDate;
          try {
            final date = DateTime.parse(tx.date);
            formattedDate = DateFormat('yyyy-MM-dd').format(date);
          } catch (_) {
            formattedDate = tx.date;
          }
          return Card(
            elevation: 4,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('\$${tx.amount.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('Fecha: $formattedDate', style: const TextStyle(fontSize: 14)),
                  const SizedBox(height: 2),
                  Text('Detalles: ${tx.details}', style: const TextStyle(fontSize: 14)),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.picture_as_pdf),
        onPressed: () {
          // Genera y descarga el PDF
          _downloadPdf(transactionController.transactions);
        },
      ),
    );
  }
}
