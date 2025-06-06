import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:typed_data';

/// Servicio encargado de generar, imprimir y descargar PDFs para jornadas y listados.
class PDFService {
  // ...

  /// Genera y descarga un PDF con el listado de jornadas filtradas.
  Future<void> generateAndDownloadListadoJornadas(List<Map<String, dynamic>> jornadas, DateTime? desde, DateTime? hasta) async {
    final pdf = await _createListadoJornadasPDF(jornadas, desde, hasta);
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'listado_jornadas.pdf',
    );
  }

  /// Genera y envía a imprimir un PDF con el listado de jornadas filtradas.
  Future<void> generateAndPrintListadoJornadas(List<Map<String, dynamic>> jornadas, DateTime? desde, DateTime? hasta) async {
    final pdf = await _createListadoJornadasPDF(jornadas, desde, hasta);
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  /// Construye el documento PDF para el listado de jornadas, con tabla y cabecera de fechas.
  Future<pw.Document> _createListadoJornadasPDF(List<Map<String, dynamic>> jornadas, DateTime? desde, DateTime? hasta) async {
    final pdf = pw.Document();
    final dateFormat = pw.TextStyle(fontSize: 10);
    // Definición de las cabeceras de la tabla para el PDF de listado
    final tableHeaders = [
      'FECHA', 'CLIENTE', 'H.ENTRADA', 'H SALIDA', 'VEHICULO'
    ];
    // Mapeo de los datos de cada jornada a filas de la tabla
    final tableData = jornadas.map((j) => [
      j['fecha'] ?? '',
      j['cliente'] ?? '',
      j['hora_llegada'] ?? '',
      j['hora_salida'] ?? '',
      j['vehiculo'] ?? '',
    ]).toList();

    // Añade una página con cabecera y tabla de jornadas al PDF
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (pw.Context context) {
          return [
            // Cabecera con el rango de fechas
            pw.Text(
              'Listado partes de trabajo desde  ' +
                (desde != null ? _formatDate(desde) : '') +
                '  hasta ' +
                (hasta != null ? _formatDate(hasta) : ''),
              style: pw.TextStyle(fontSize: 16, color: PdfColors.blueGrey800),
            ),
            pw.SizedBox(height: 24),
            // Tabla de jornadas
            pw.Table(
              border: pw.TableBorder.symmetric(inside: pw.BorderSide(width: 0.5)),
              defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
              children: [
                // Fila de cabeceras
                pw.TableRow(
                  children: tableHeaders.map((h) => pw.Text(h, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11))).toList(),
                ),
                // Filas de datos
                ...tableData.map(
                  (row) => pw.TableRow(
                    children: row.map((cell) => pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                      child: pw.Text(cell.toString(), style: dateFormat),
                    )).toList(),
                  ),
                ),
              ],
            ),
          ];
        },
      ),
    );
    return pdf;
  }

  /// Formatea una fecha a dd/MM/yyyy para mostrar en los PDFs.
  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }
  // Singleton para acceder a la instancia del servicio
  static final PDFService instance = PDFService._internal();

  PDFService._internal();

  /// Genera y envía a imprimir un PDF individual de una jornada.
  Future<void> generateAndPrintJourney(Map<String, dynamic> jornada) async {
    final pdf = await _createJourneyPDF(jornada);
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  /// Genera y descarga un PDF individual de una jornada.
  Future<void> generateAndDownloadJourney(Map<String, dynamic> jornada) async {
    final pdf = await _createJourneyPDF(jornada);
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'jornada_${jornada['fecha_hora_inicio'] ?? 'sin_fecha'}.pdf',
    );
  }

  /// Construye el documento PDF para una jornada individual, con todos los datos y firma.
  Future<pw.Document> _createJourneyPDF(Map<String, dynamic> jornada) async {
    final pdf = pw.Document();
    final firmaBytes = jornada['firma'] as Uint8List?;

    // Añade una página al PDF con todos los datos de la jornada
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        build: (pw.Context context) {
          return [
            // Cabecera con número de parte
            pw.Text(
              'PARTE DE TRABAJO Nº: ${jornada['numero_parte'] ?? '---'}',
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 10),

            // Datos de la empresa
            pw.Text('EMPRESA: ${jornada['nombre_empresa'] ?? ''}',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Text('Dirección: ${jornada['direccion_empresa'] ?? ''}'),
            pw.Text('CIF: ${jornada['cif_empresa'] ?? ''}'),

            pw.SizedBox(height: 10),

            // Datos del trabajador
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Expanded(
                  flex: 2,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('${jornada['nombre_trabajador'] ?? ''}'),
                      pw.Text('${jornada['direccion_trabajador'] ?? ''}'),
                      pw.Text('${jornada['dni_trabajador'] ?? ''}'),
                      pw.Text('${jornada['localidad_trabajador'] ?? ''}'),
                    ],
                  ),
                ),
                pw.Expanded(
                  flex: 1,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text('FECHA: ${jornada['fecha'] ?? ''}'),
                      pw.Text('Hora Llegada: ${jornada['hora_llegada'] ?? ''}'),
                      pw.Text('Hora Salida: ${jornada['hora_salida'] ?? ''}'),
                    ],
                  ),
                ),
              ],
            ),

            pw.Divider(),

            // Datos del cliente
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Expanded(
                  flex: 3,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('CLIENTE: ${jornada['cliente'] ?? ''}'),
                      pw.Text('DIRECCIÓN: ${jornada['direccion_cliente'] ?? ''}'),
                      pw.Text('CP: ${jornada['cp'] ?? ''}'),
                    ],
                  ),
                ),
                pw.Expanded(
                  flex: 2,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('CIF: ${jornada['cif'] ?? ''}'),
                      pw.Text('LOC: ${jornada['localidad_cliente'] ?? ''}'),
                      pw.Text('PROV: ${jornada['provincia_cliente'] ?? ''}'),
                    ],
                  ),
                ),
              ],
            ),

            pw.Divider(),

            pw.Text('OPERARIO: ${jornada['trabajador'] ?? ''}'),
            pw.Text('Vehículo Mat.: ${jornada['vehiculo'] ?? ''}'),

            pw.SizedBox(height: 20),

            // Descripción del trabajo realizado
            pw.Text('TRABAJO EFECTUADO:',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Paragraph(
              text: '${jornada['trabajo_realizado'] ?? ''}',
            ),

            pw.SizedBox(height: 40),

            // Sección de conformidad del cliente y firma
            pw.Text('Conformidad de Cliente',
                style: pw.TextStyle(fontStyle: pw.FontStyle.italic)),

            if (firmaBytes != null && firmaBytes.isNotEmpty)
              pw.Padding(
                padding: const pw.EdgeInsets.only(top: 10),
                child: pw.Image(pw.MemoryImage(firmaBytes), height: 80),
              )
            else
              pw.Text('Sin firma'),
          ];
        },
      ),
    );

    return pdf;
  }
}
