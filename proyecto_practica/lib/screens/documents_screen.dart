import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:proyecto_practica/services/journey_service.dart';
import 'package:proyecto_practica/services/pdf_service.dart';
import 'package:proyecto_practica/widgets/date_filter_bar.dart';
import 'package:proyecto_practica/widgets/journey_card.dart';
// Clase que gestiona el estado de la pantalla de documentos de jornadas
class DocumentsScreen extends StatefulWidget {
  const DocumentsScreen({super.key});

  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}
// Clase que gestiona el estado de la pantalla de documentos de jornadas
class _DocumentsScreenState extends State<DocumentsScreen> {
  List<Map<String, dynamic>> jornadas = [];
  bool isLoading = true;
  DateTime? _fechaInicioFiltro;
  DateTime? _fechaFinFiltro;
  final formatoFecha = DateFormat('dd-MM-yyyy HH:mm:ss');
  // Constructor
  @override
  void initState() {
    super.initState();
    _loadJornadas();
  }

  // Carga las jornadas desde la base de datos
  Future<void> _loadJornadas({DateTime? desde, DateTime? hasta}) async {
    setState(() => isLoading = true);
    DateTime? realDesde = desde;
    DateTime? realHasta = hasta;
    if (desde != null && hasta != null) {
      // Si son el mismo día, filtrar todo ese día
      if (desde.year == hasta.year && desde.month == hasta.month && desde.day == hasta.day) {
        realDesde = DateTime(desde.year, desde.month, desde.day, 0, 0, 0);
        realHasta = DateTime(hasta.year, hasta.month, hasta.day, 23, 59, 59, 999);
      } else {
        realDesde = DateTime(desde.year, desde.month, desde.day, 0, 0, 0);
        realHasta = DateTime(hasta.year, hasta.month, hasta.day, 23, 59, 59, 999);
      }
    } else if (desde != null) {
      realDesde = DateTime(desde.year, desde.month, desde.day, 0, 0, 0);
    } else if (hasta != null) {
      realHasta = DateTime(hasta.year, hasta.month, hasta.day, 23, 59, 59, 999);
    }
    final jornadasData = await JornadaService.instance.obtenerJornadas(
      desde: realDesde,
      hasta: realHasta,
    );
    setState(() {
      jornadas = jornadasData;
      isLoading = false;
    });
  }
  // Limpia los filtros y vuelve a cargar las jornadas 
  void _clearFilters() {
    setState(() {
      _fechaInicioFiltro = null;
      _fechaFinFiltro = null;
    });
    _loadJornadas();
  }

  // Construye la pantalla de documentos de jornadas
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Documentos de Jornadas')),
      body: Column(
        children: [
          DateFilterBar(
            fechaInicio: _fechaInicioFiltro,
            fechaFin: _fechaFinFiltro,
            onFechaInicioChanged:
                (fecha) => setState(() => _fechaInicioFiltro = fecha),
            onFechaFinChanged:
                (fecha) => setState(() => _fechaFinFiltro = fecha),
            onSearch:
                () => _loadJornadas(
                  desde: _fechaInicioFiltro,
                  hasta: _fechaFinFiltro,
                ),
            onClear: _clearFilters,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Wrap(
              spacing: 12,
              alignment: WrapAlignment.end,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.download),
                  label: const Text('Descargar listado'),
                  onPressed: isLoading || jornadas.isEmpty
                      ? null
                      : () {
                          PDFService.instance.generateAndDownloadListadoJornadas(
                            jornadas,
                            _fechaInicioFiltro,
                            _fechaFinFiltro,
                          );
                        },
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.print),
                  label: const Text('Imprimir listado'),
                  onPressed: isLoading || jornadas.isEmpty
                      ? null
                      : () {
                          PDFService.instance.generateAndPrintListadoJornadas(
                            jornadas,
                            _fechaInicioFiltro,
                            _fechaFinFiltro,
                          );
                        },
                ),
              ],
            ),
          ),
          Expanded(
            child:
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : jornadas.isEmpty
                    ? const Center(child: Text('No hay jornadas registradas.'))
                    : _buildJourneysListView(),
          ),
        ],
      ),
    );
  }

  /// Construye una lista de tarjetas (JourneyCard) para mostrar todas las jornadas filtradas.
  Widget _buildJourneysListView() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: jornadas.length,
      itemBuilder: (context, index) {
        final jornada = jornadas[index]; // Datos de la jornada actual
        String fechaInicio = '';
        String fechaFin = '';

        // Formatea la fecha de inicio de la jornada para mostrarla de forma legible
        try {
          fechaInicio = formatoFecha.format(
            DateTime.parse(jornada['fecha_hora_inicio']),
          );
        } catch (_) {
          fechaInicio = jornada['fecha_hora_inicio'] ?? '';
        }
        // Formatea la fecha de fin de la jornada para mostrarla de forma legible
        try {
          fechaFin = formatoFecha.format(
            DateTime.parse(jornada['fecha_hora_fin']),
          );
        } catch (_) {
          fechaFin = jornada['fecha_hora_fin'] ?? '';
        }

        // Genera la tarjeta visual de la jornada con opciones para PDF individuales
        return JourneyCard(
          jornada: jornada,
          fechaInicio: fechaInicio,
          fechaFin: fechaFin,
          onDownloadPDF:
              () => PDFService.instance.generateAndDownloadJourney(jornada),
          onPrint: () => PDFService.instance.generateAndPrintJourney(jornada),
        );
      },
    );
  }
}
