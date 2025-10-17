import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import 'package:voltrix/theme/theme_notifier.dart'; // Import necessário
import 'package:voltrix/theme/app_gradients.dart'; // Import necessário (para kPrimaryRed)

class GerenciarPage extends StatefulWidget {
  const GerenciarPage({super.key});

  @override
  State<GerenciarPage> createState() => _GerenciarPageState();
}

class _GerenciarPageState extends State<GerenciarPage> {
  // ---------------------- CORES ----------------------
  // Apenas a cor primária é mantida estática, o resto será lido do tema
  static const Color primaryColor = kPrimaryRed;
  static const Color successColor = Color(0xFF28A745);

  // ---------------------- ESTADOS ----------------------
  bool isEconomyModeActive = false;
  bool shouldAutoRelink = false;

  Map<String, bool> ruleStatuses = {
    'ruleTarget': true,
    'ruleClock': true,
    'ruleBolt': false,
  };

  final List<Map<String, dynamic>> availableDevices = [
    {'id': 1, 'name': 'Lâmpada Sala'},
    {'id': 2, 'name': 'Ar Cond. Quarto'},
    {'id': 3, 'name': 'Chuveiro Elétrico'},
  ];

  int? selectedDevice;
  String actionTime = '23:00';
  String actionType = 'Desligar';
  String relinkTime = '07:00';

  @override
  void initState() {
    super.initState();
    selectedDevice = availableDevices[0]['id'] as int; // Garantir que é int
  }

  // ---------------------- FUNÇÕES ----------------------
  void handleSchedule() {
    final deviceName = availableDevices.firstWhere(
      (d) => d['id'] == selectedDevice,
    )['name'];

    String message =
        "Agendamento criado: $actionType $deviceName às $actionTime.";
    if (shouldAutoRelink) {
      message += " Ligar novamente às $relinkTime.";
    } else if (actionType == "Desligar") {
      message +=
          " O dispositivo permanecerá desligado até ser ligado manualmente.";
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Agendamento'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void toggleRule(String ruleId) {
    setState(() {
      ruleStatuses[ruleId] = !(ruleStatuses[ruleId] ?? false);
    });
  }

  Future<void> pickTime(bool isRelink) async {
    final timeString = isRelink ? relinkTime : actionTime;
    final parts = timeString.split(":");

    final initialTime = TimeOfDay(
      hour: int.tryParse(parts[0]) ?? 0,
      minute: int.tryParse(parts[1]) ?? 0,
    );

    final picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
    if (picked != null) {
      final formatted =
          picked.hour.toString().padLeft(2, '0') +
          ':' +
          picked.minute.toString().padLeft(2, '0');
      setState(() {
        if (isRelink) {
          relinkTime = formatted;
        } else {
          actionTime = formatted;
        }
      });
    }
  }

  // ---------------------- UI ----------------------
  @override
  Widget build(BuildContext context) {
    // 1. Acessa o estado global do tema e cores dinâmicas
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final isDarkMode = themeNotifier.isDarkMode;
    final colors = getThemeStyles(isDarkMode);

    final textColor = colors['textColor']!;
    final secondaryTextColor = colors['secondaryTextColor']!;
    final borderColor = colors['borderColor']!;
    final cardBackground = colors['cardBackground']!;

    return Scaffold(
      // 2. Aplicando o Gradiente na raiz
      body: Container(
        decoration: BoxDecoration(gradient: themeNotifier.currentGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // VOLTAR
                Row(
                  children: [
                    IconButton(
                      icon: Icon(FeatherIcons.arrowLeft, color: textColor),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),

                // TÍTULO
                Text(
                  "Gerenciamento inteligente",
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "Programe rotinas e ative o modo de otimização de gastos",
                  style: TextStyle(color: secondaryTextColor, fontSize: 17),
                ),
                const SizedBox(height: 30),

                // MODO ECONOMIA
                _CardContainer(
                  cardBackground: cardBackground,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Modo de otimização ativa",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                          CustomToggle(
                            isActive: isEconomyModeActive,
                            activeColor: primaryColor,
                            borderColor: borderColor,
                            onTap: () {
                              setState(
                                () =>
                                    isEconomyModeActive = !isEconomyModeActive,
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Este modo monitora o consumo em tempo real, se seus gastos estiverem significativamente elevados e excederem a projeção da sua meta, enviaremos sugestões proativas de desligamento para reverter a tendência\n",
                        style: TextStyle(color: textColor, fontSize: 14),
                      ),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(fontSize: 14, color: textColor),
                          children: [
                            const TextSpan(text: "Status: "),
                            TextSpan(
                              text: isEconomyModeActive
                                  ? "ativo"
                                  : "desativado",
                              style: TextStyle(
                                color: isEconomyModeActive
                                    ? primaryColor
                                    : secondaryTextColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),

                // AGENDAR
                Text(
                  "Agendar rotina de desligamento",
                  style: TextStyle(
                    color: textColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                _CardContainer(
                  cardBackground: cardBackground,
                  child: Column(
                    children: [
                      // Selecionar dispositivo
                      _Label("Selecione o dispositivo:", secondaryTextColor),
                      DropdownButtonFormField<int>(
                        value: selectedDevice,
                        decoration: _inputDecoration(
                          borderColor,
                          primaryColor,
                          cardBackground,
                        ),
                        // Tipagem Corrigida: items: List<DropdownMenuItem<int>>
                        items: availableDevices
                            .map(
                              (d) => DropdownMenuItem<int>(
                                value: d['id'] as int, // Conversão explícita
                                child: Text(
                                  d['name'],
                                  style: TextStyle(color: textColor),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (val) =>
                            setState(() => selectedDevice = val),
                      ),
                      const SizedBox(height: 15),

                      // Ação e horário
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _Label("Ação:", secondaryTextColor),
                                DropdownButtonFormField<String>(
                                  value: actionType,
                                  decoration: _inputDecoration(
                                    borderColor,
                                    primaryColor,
                                    cardBackground,
                                  ),
                                  items: [
                                    DropdownMenuItem(
                                      value: "Desligar",
                                      child: Text(
                                        "Desligar",
                                        style: TextStyle(color: textColor),
                                      ),
                                    ),
                                    DropdownMenuItem(
                                      value: "Ligar",
                                      child: Text(
                                        "Ligar",
                                        style: TextStyle(color: textColor),
                                      ),
                                    ),
                                  ],
                                  onChanged: (val) =>
                                      setState(() => actionType = val!),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _Label("Horário:", secondaryTextColor),
                                InkWell(
                                  onTap: () => pickTime(false),
                                  child: InputDecorator(
                                    decoration: _inputDecoration(
                                      borderColor,
                                      primaryColor,
                                      cardBackground,
                                    ),
                                    child: Text(
                                      actionTime,
                                      style: TextStyle(color: textColor),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Toggle ligar novamente
                      if (actionType == "Desligar")
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Ligar novamente?",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: textColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                CustomToggle(
                                  isActive: shouldAutoRelink,
                                  onTap: () {
                                    setState(
                                      () =>
                                          shouldAutoRelink = !shouldAutoRelink,
                                    );
                                  },
                                  activeColor: primaryColor,
                                  borderColor: borderColor,
                                ),
                              ],
                            ),

                            const SizedBox(height: 15),

                            if (shouldAutoRelink)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _Label(
                                    "Horário para ligar novamente:",
                                    secondaryTextColor,
                                  ),
                                  InkWell(
                                    onTap: () => pickTime(true),
                                    child: InputDecorator(
                                      decoration: _inputDecoration(
                                        borderColor,
                                        primaryColor,
                                        cardBackground,
                                      ),
                                      child: Text(
                                        relinkTime,
                                        style: TextStyle(color: textColor),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            const SizedBox(height: 25),
                          ],
                        ),

                      ElevatedButton(
                        onPressed: handleSchedule,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          foregroundColor: Colors.white,
                        ),
                        child: const Text(
                          "AGENDAR ROTINA",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // OTIMIZAÇÃO ATIVA - Regras
                Text(
                  "Otimização ativa",
                  style: TextStyle(
                    color: textColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                RuleDetailCard(
                  icon: FeatherIcons.target,
                  title: "Otimização por metas de orçamento",
                  description:
                      "O sistema monitora a projeção de gastos. Se você exceder a meta definida, o app sugere o desligamento de dispositivos de alto consumo (como aquecedores) para reverter a tendência e manter seu orçamento",
                  isActive: ruleStatuses['ruleTarget']!,
                  onToggle: () => toggleRule('ruleTarget'),
                  textColor: textColor,
                  secondaryTextColor: secondaryTextColor,
                  cardBackground: cardBackground,
                  activeToggleColor: primaryColor,
                  inactiveToggleColor: borderColor,
                ),
                RuleDetailCard(
                  icon: FeatherIcons.clock,
                  title: "Regra de inatividade",
                  description:
                      "Se o consumo do aparelho for mantido em modo stand-by (abaixo de 5 Watts) por mais de 3 horas durante a noite (23:00h - 07:00h), o app envia um alerta sugerindo o desligamento",
                  isActive: ruleStatuses['ruleClock']!,
                  onToggle: () => toggleRule('ruleClock'),
                  textColor: textColor,
                  secondaryTextColor: secondaryTextColor,
                  cardBackground: cardBackground,
                  activeToggleColor: primaryColor,
                  inactiveToggleColor: borderColor,
                ),
                RuleDetailCard(
                  icon: FeatherIcons.zap, // Corrigido para FeatherIcons.zap
                  title: "Regra de consumo fantasma",
                  description:
                      "Se o dispositivo estiver consumindo menos de 1 Watt por mais de 8 horas seguidas, a tomada desliga automaticamente para eliminar o consumo passivo",
                  isActive: ruleStatuses['ruleBolt']!,
                  onToggle: () => toggleRule('ruleBolt'),
                  textColor: textColor,
                  secondaryTextColor: secondaryTextColor,
                  cardBackground: cardBackground,
                  activeToggleColor: primaryColor,
                  inactiveToggleColor: borderColor,
                ),

                // VISÃO GERAL
                const SizedBox(height: 30),
                _CardContainer(
                  cardBackground: cardBackground,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Status das regras ativas",
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "${ruleStatuses.values.where((e) => e).length}/3 regras ativas",
                        style: const TextStyle(
                          color: successColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Modo de otimização: ${isEconomyModeActive ? 'ativo' : 'desativado'}",
                        style: const TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Próxima ação: nenhuma rotina agendada",
                        style: TextStyle(
                          color: secondaryTextColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Estilo de input (agora recebe as cores dinâmicas)
  InputDecoration _inputDecoration(
    Color borderColor,
    Color primaryColor,
    Color fillColor,
  ) {
    return InputDecoration(
      filled: true,
      fillColor: fillColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: borderColor),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: primaryColor),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  Widget _Label(String text, Color color) => Padding(
    padding: const EdgeInsets.only(bottom: 5),
    child: Text(
      text,
      style: TextStyle(color: color, fontSize: 14, fontFamily: 'Inter'),
    ),
  );
}

// ---------------------- COMPONENTES REUTILIZÁVEIS ----------------------

class CustomToggle extends StatelessWidget {
  final bool isActive;
  final VoidCallback onTap;
  final Color activeColor;
  final Color borderColor;

  const CustomToggle({
    super.key,
    required this.isActive,
    required this.onTap,
    required this.activeColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 40,
        height: 20,
        decoration: BoxDecoration(
          color: isActive ? activeColor : borderColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: AnimatedAlign(
          alignment: isActive ? Alignment.centerRight : Alignment.centerLeft,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          child: Container(
            width: 16,
            height: 16,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 2,
                  offset: Offset(0, 1),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RuleDetailCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final bool isActive;
  final VoidCallback onToggle;
  final Color textColor;
  final Color secondaryTextColor;
  final Color cardBackground;
  final Color activeToggleColor;
  final Color inactiveToggleColor;

  const RuleDetailCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.isActive,
    required this.onToggle,
    required this.textColor,
    required this.secondaryTextColor,
    required this.cardBackground,
    required this.activeToggleColor,
    required this.inactiveToggleColor,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor = isActive ? activeToggleColor : secondaryTextColor;

    return _CardContainer(
      marginBottom: 15,
      cardBackground: cardBackground,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 22),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              CustomToggle(
                isActive: isActive,
                onTap: onToggle,
                activeColor: activeToggleColor,
                borderColor: inactiveToggleColor,
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            description,
            style: TextStyle(
              color: secondaryTextColor,
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _CardContainer extends StatelessWidget {
  final Widget child;
  final double marginBottom;
  final Color cardBackground;

  const _CardContainer({
    required this.child,
    this.marginBottom = 0,
    required this.cardBackground,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: marginBottom),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: child,
    );
  }
}
