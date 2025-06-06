import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:proyecto_practica/screens/start_screen.dart';
import 'package:proyecto_practica/services/journey_service.dart';
import 'package:proyecto_practica/widgets/signature_pad.dart';
import 'package:proyecto_practica/widgets/worker_info_view.dart';
import 'package:signature/signature.dart';
// Clase que gestiona el estado de la pantalla de finalización de jornada
class FinishScreen extends StatefulWidget {
  final DateTime fechaHora;
  final Position? posicion;
  final String trabajador;
  final String empresa;
  final String vehiculo;

  const FinishScreen({
    super.key,
    required this.fechaHora,
    required this.posicion,
    required this.trabajador,
    required this.empresa,
    required this.vehiculo,
  });

  @override
  State<FinishScreen> createState() => _FinishScreenState();
}
// Clase que gestiona el estado de la pantalla de finalización de jornada
class _FinishScreenState extends State<FinishScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _finalizado = false;
  bool _firmaValida = false;

  final SignatureController _signatureController = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
  );

  // Campos de formulario
  String _cliente = '';
  String _direccionCliente = '';
  String _cif = '';
  String _localidad = '';
  String _provincia = '';
  String _cp = '';
  String _trabajoRealizado = '';

  @override
  void initState() {
    super.initState();
    _signatureController.addListener(() {
      setState(() {
        _firmaValida = _signatureController.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _signatureController.dispose();
    super.dispose();
  }

  // Finaliza la jornada
  Future<void> _finalizarJornada() async {
    final firma = await _signatureController.toPngBytes();

    await JornadaService.instance.finalizarJornada(
      trabajador: widget.trabajador,
      empresa: widget.empresa,
      vehiculo: widget.vehiculo,
      fechaHoraInicio: widget.fechaHora,
      posicionInicio: widget.posicion,
      firma: firma,
      cliente: _cliente,
      direccionCliente: _direccionCliente,
      cif: _cif,
      localidadCliente: _localidad,
      provinciaCliente: _provincia,
      cp: _cp,
      trabajoRealizado: _trabajoRealizado,
    );

    setState(() => _finalizado = true);

    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const StartScreen()),
      (Route<dynamic> route) => false,
    );
  }

  // Limpia la firma
  void _limpiarFirma() {
    _signatureController.clear();
    setState(() => _firmaValida = false);
  }

  // Construye la pantalla de finalización de jornada
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Finalizar jornada')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WorkerInfoView(
                trabajador: widget.trabajador,
                empresa: widget.empresa,
                vehiculo: widget.vehiculo,
                fechaHora: widget.fechaHora,
                posicion: widget.posicion,
              ),
              const SizedBox(height: 24),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Cliente'),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Requerido' : null,
                      onChanged: (val) => _cliente = val,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Dirección del cliente'),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Requerido' : null,
                      onChanged: (val) => _direccionCliente = val,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'CIF'),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Requerido' : null,
                      onChanged: (val) => _cif = val,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Localidad'),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Requerido' : null,
                      onChanged: (val) => _localidad = val,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Provincia'),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Requerido' : null,
                      onChanged: (val) => _provincia = val,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Código Postal'),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Requerido' : null,
                      onChanged: (val) => _cp = val,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Trabajo realizado'),
                      maxLines: 3,
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Requerido' : null,
                      onChanged: (val) => _trabajoRealizado = val,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              SignaturePad(
                controller: _signatureController,
                onClear: _limpiarFirma,
              ),
              const SizedBox(height: 24),
              Center(
                child: !_finalizado
                    ? ElevatedButton(
                        onPressed: _firmaValida
                            ? () {
                                if (_formKey.currentState!.validate()) {
                                  _finalizarJornada();
                                }
                              }
                            : null,
                        child: const Text('Finalizar'),
                      )
                    : const Text(
                        'Jornada finalizada',
                        style: TextStyle(color: Colors.green, fontSize: 18),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
