import 'dart:async';
import 'package:flutter/material.dart';

// Simulação de chamada de API — substitua pela sua implementação real
Future<Map<String, dynamic>> fetchEnergia(String id) async {
  await Future.delayed(const Duration(seconds: 1));
  return {
    'w_instantaneo': 532.45,
    'kwh_hoje': 1.234,
    'kwh_mes': 23.876,
    'ligado': true,
  };
}

class DetalhePainelSolar extends StatefulWidget {
  const DetalhePainelSolar({Key? key}) : super(key: key);

  @override
  State<DetalhePainelSolar> createState() => _DetalhePainelSolarState();
}

class _DetalhePainelSolarState extends State<DetalhePainelSolar> {
  bool ligado = false;
  Map<String, dynamic>? energia;
  bool loadingEnergia = true;
  String? erroEnergia;
  bool inicializadoLigado = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    _loadEnergia();
    timer = Timer.periodic(const Duration(seconds: 5), (_) => _loadEnergia());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> _loadEnergia() async {
    try {
      setState(() {
        loadingEnergia = true;
        erroEnergia = null;
      });

      final data = await fetchEnergia('painel');
      setState(() {
        energia = data;
        // Inicializa o "ligado" na primeira vez com base na telemetria
        if (!inicializadoLigado && data.containsKey('ligado')) {
          ligado = data['ligado'] == true;
          inicializadoLigado = true;
        }
      });
    } catch (e) {
      setState(() {
        erroEnergia = e.toString();
      });
    } finally {
      setState(() {
        loadingEnergia = false;
      });
    }
  }

  String fmt(dynamic n, [int digits = 3]) {
    if (n == null) return '—';
    final num? numValue = num.tryParse(n.toString());
    if (numValue == null) return '—';
    return numValue.toStringAsFixed(digits);
  }

  @override
  Widget build(BuildContext context) {
    final watts = energia?['w_instantaneo'];
    final kwhHoje = energia?['kwh_hoje'];
    final kwhMes = energia?['kwh_mes'];

    final primaryColor = Theme.of(context).primaryColor;
    const lightText = Colors.white;
    const darkText = Colors.black87;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ========= BOTÃO VOLTAR =========
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios_new, size: 22),
                    color: Colors.grey[700],
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // ========= TÍTULO =========
              Text(
                'Painel solar',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Configuração e monitoramento do seu painel',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 20),

              // ========= CARD STATUS =========
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: BoxDecoration(
                  color: ligado ? primaryColor : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    )
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Status',
                          style: TextStyle(
                            color: ligado ? lightText : Colors.black54,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          ligado ? 'LIGADO' : 'DESLIGADO',
                          style: TextStyle(
                            color: ligado ? lightText : darkText,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    // SWITCH personalizado
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          ligado = !ligado;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 55,
                        height: 30,
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: ligado ? Colors.green : Colors.grey.shade400,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        alignment:
                            ligado ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ========= CARD CONSUMO =========
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Informações de uso',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (loadingEnergia)
                      const Text(
                        'Carregando telemetria…',
                        style: TextStyle(color: Colors.black54),
                      ),
                    if (erroEnergia != null && !loadingEnergia)
                      Text(
                        'Erro: $erroEnergia',
                        style: TextStyle(color: primaryColor),
                      ),
                    if (!loadingEnergia && erroEnergia == null) ...[
                      Text(
                        'Potência agora: ${fmt(watts, 2)} W',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Hoje: ${fmt(kwhHoje, 3)} kWh',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Mês: ${fmt(kwhMes, 3)} kWh',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
