import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voltrix/theme/theme_notifier.dart';
import 'package:voltrix/theme/app_gradients.dart';
import '../widgets/DispositivoCard.dart'; // Mantido, ajuste o caminho se necessário

class InicioPage extends StatefulWidget {
  const InicioPage({super.key});

  @override
  State<InicioPage> createState() => _InicioPageState();
}

class _InicioPageState extends State<InicioPage> {
  // Cor primária estática
  static const Color primaryColor = kPrimaryRed;
  
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
    // 1. Acessa o estado global do tema e as cores
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final isDarkMode = themeNotifier.isDarkMode;
    final colors = getThemeStyles(isDarkMode);

    final textColor = colors['textColor']!;
    final secondaryTextColor = colors['secondaryTextColor']!;
    final cardBackground = colors['cardBackground']!;
    
    // Cores auxiliares fixas
    const greenColor = Color(0xFF2ECC71); // verde

    return Scaffold(
      // 2. Aplicando o Gradiente Dinâmico na raiz
      body: Container(
        decoration: BoxDecoration(
          gradient: themeNotifier.currentGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Cabeçalho
                Text(
                  "Início",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Olá, Manoella",
                  style: TextStyle(
                    fontSize: 17,
                    color: secondaryTextColor, // Cor dinâmica
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
                      color: greenColor,
                      background: cardBackground, // Cor dinâmica
                      textColor: secondaryTextColor, // Cor dinâmica
                    ),
                    _statusCard(
                      icon: Icons.attach_money,
                      label: "Custo hoje",
                      value: "R\$ 0,00",
                      color: primaryColor,
                      background: cardBackground, // Cor dinâmica
                      textColor: secondaryTextColor, // Cor dinâmica
                    ),
                  ],
                ),
                const SizedBox(height: 25),

                // Consumo atual
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: cardBackground, // Cor dinâmica
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(isDarkMode ? 0.4 : 0.05),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Consumo atual",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: secondaryTextColor, // Cor dinâmica
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "0,00",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: secondaryTextColor, // Cor dinâmica
                        ),
                      ),
                      Text(
                        "kWh em uso agora",
                        style: TextStyle(color: secondaryTextColor), // Cor dinâmica
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
                        Navigator.pushNamed(context, '/adicionardispositivo'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
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
                Text(
                  "Meus dispositivos",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 10),

                // Lista de dispositivos
                ...devices.map(
                  // Nota: DispositivoCard deve ser atualizado separadamente para suportar cores dinâmicas.
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
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Center(
                      child: Text(
                        "Nenhum dispositivo instalado",
                        style: TextStyle(color: secondaryTextColor), // Cor dinâmica
                      ),
                    ),
                  ),

                const SizedBox(height: 30),

                // 🔴 Ações inteligentes
                Text(
                  "Ações inteligentes",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 10),

                // Painel solar
                _menuCard(
                  title: "Configure seu painel solar",
                  subtitle: "Acesse as configurações do seu sistema solar",
                  icon: Icons.wb_sunny,
                  onTap: () => Navigator.pushNamed(context, '/painel-solar'),
                  background: cardBackground, // Cor dinâmica
                  textColor: textColor, // Cor dinâmica
                  secondaryTextColor: secondaryTextColor, // Cor dinâmica
                ),

                // Gerenciar desligamento
                _menuCard(
                  title: "Gerenciar desligamento e economia",
                  subtitle:
                      "Programe horários e otimize o consumo de seus dispositivos",
                  icon: Icons.bolt,
                  onTap: () => Navigator.pushNamed(context, '/gerenciar'),
                  background: cardBackground, // Cor dinâmica
                  textColor: textColor, // Cor dinâmica
                  secondaryTextColor: secondaryTextColor, // Cor dinâmica
                ),
              ],
            ),
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
    required Color secondaryTextColor,
  }) {
    // Usamos o primaryColor estático para os ícones
    const redColor = primaryColor;

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
                      style: TextStyle(color: secondaryTextColor, fontSize: 13)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}