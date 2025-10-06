import 'package:flutter/material.dart';
import '../../widgets/DispositivoCard.dart';

class InicioPage extends StatefulWidget {
  const InicioPage({super.key});

  @override
  State<InicioPage> createState() => _InicioPageState();
}

class _InicioPageState extends State<InicioPage> {
  List<Map<String, dynamic>> devices = [
    {"id": 1, "name": "Lâmpada Sala", "room": "Sala", "status": true},
    {"id": 2, "name": "Ar Cond. Quarto", "room": "Quarto", "status": false},
  ];

  int get activeCount => devices.where((d) => d["status"] == true).length;

  void toggleDevice(int id) {
    setState(() {
      final index = devices.indexWhere((d) => d["id"] == id);
      if (index != -1) {
        devices[index]["status"] = !devices[index]["status"];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const redColor = Color(0xFFB42222);
    const grayCard = Color(0xFFF6F6F6);
    const grayText = Color(0xFFA6A6A6);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cabeçalho
              const Text(
                "Início",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: redColor,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                "Olá, Manoella",
                style: TextStyle(
                  fontSize: 17,
                  color: grayText,
                ),
              ),
              const SizedBox(height: 20),

              // Status cards
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _statusCard(
                    icon: Icons.power_settings_new,
                    label: "Ativos",
                    value: "$activeCount",
                    color: Color(0xFF2ECC71), // verde
                    background: grayCard,
                    textColor: grayText,
                  ),
                  _statusCard(
                    icon: Icons.attach_money,
                    label: "Custo hoje",
                    value: "R\$ 0,00",
                    color: redColor,
                    background: grayCard,
                    textColor: grayText,
                  ),
                ],
              ),
              const SizedBox(height: 25),

              // Consumo atual
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: grayCard,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Consumo atual",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: grayText,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "0,00",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: grayText,
                      ),
                    ),
                    Text(
                      "kWh em uso agora",
                      style: TextStyle(color: grayText),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Botão adicionar dispositivo
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, '/adicionar-dispositivo'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: redColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    "ADICIONAR DISPOSITIVO",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Meus dispositivos
              const Text(
                "Meus dispositivos",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: redColor,
                ),
              ),
              const SizedBox(height: 10),

              // Lista de dispositivos
              ...devices.map(
                (device) => DispositivoCard(
                  id: device["id"],
                  name: device["name"],
                  room: device["room"],
                  status: device["status"],
                  onToggle: () => toggleDevice(device["id"]),
                  onTap: () => Navigator.pushNamed(
                      context, '/dispositivo/${device["id"]}'),
                ),
              ),

              if (devices.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 12),
                  child: Center(
                    child: Text(
                      "Nenhum dispositivo instalado",
                      style: TextStyle(color: grayText),
                    ),
                  ),
                ),

              const SizedBox(height: 30),

              // 🔴 Ações inteligentes
              const Text(
                "Ações inteligentes",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: redColor,
                ),
              ),
              const SizedBox(height: 10),

              // Painel solar
              _menuCard(
                title: "Configure seu painel solar",
                subtitle: "Acesse as configurações do seu sistema solar",
                icon: Icons.wb_sunny,
                onTap: () => Navigator.pushNamed(context, '/painel-solar'),
                background: grayCard,
                textColor: grayText,
              ),

              // Gerenciar desligamento
              _menuCard(
                title: "Gerenciar desligamento e economia",
                subtitle:
                    "Programe horários e otimize o consumo de seus dispositivos",
                icon: Icons.bolt,
                onTap: () => Navigator.pushNamed(context, '/gerenciar'),
                background: grayCard,
                textColor: grayText,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==== COMPONENTES AUXILIARES ====

  Widget _statusCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required Color background,
    required Color textColor,
  }) {
    return Container(
      width: 160,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: color,
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(label,
              style: TextStyle(
                  fontSize: 14, color: textColor, fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          Text(value,
              style: TextStyle(
                  fontSize: 16, color: textColor, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _menuCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
    required Color background,
    required Color textColor,
  }) {
    const redColor = Color(0xFFB42222);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(top: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: redColor, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: textColor)),
                  const SizedBox(height: 4),
                  Text(subtitle,
                      style: TextStyle(color: textColor, fontSize: 13)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
