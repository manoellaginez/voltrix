import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class GerenciarPage extends StatefulWidget {
  const GerenciarPage({super.key});

  @override
  State<GerenciarPage> createState() => _GerenciarPageState();
}

class _GerenciarPageState extends State<GerenciarPage> {
  // ---------------------- CORES ----------------------
  static const Color primaryColor = Color(0xFFB42222);
  static const Color textColor = Color(0xFF333333);
  static const Color secondaryTextColor = Color(0xFFA6A6A6);
  static const Color cardBackground = Color(0xFFF6F6F6);
  static const Color successColor = Color(0xFF28A745);
  static const Color borderColor = Color(0xFFE0E0E0);

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
    selectedDevice = availableDevices[0]['id'];
  }

  // ---------------------- FUNÇÕES ----------------------
  void handleSchedule() {
    final deviceName = availableDevices
        .firstWhere((d) => d['id'] == selectedDevice)['name'];

    String message =
        "Agendamento criado: $actionType $deviceName às $actionTime.";
    if (shouldAutoRelink) {
      message += " Ligar novamente às $relinkTime.";
    } else if (actionType == "Desligar") {
      message += " O dispositivo permanecerá desligado até ser ligado manualmente.";
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
          )
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
    final initialTime = TimeOfDay(
      hour: int.parse((isRelink ? relinkTime : actionTime).split(":")[0]),
      minute: int.parse((isRelink ? relinkTime : actionTime).split(":")[1]),
    );
    final picked = await showTimePicker(context: context, initialTime: initialTime);
    if (picked != null) {
      final formatted =
          picked.hour.toString().padLeft(2, '0') + ':' + picked.minute.toString().padLeft(2, '0');
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // VOLTAR
              Row(
                children: [
                  IconButton(
                    icon: const Icon(FeatherIcons.arrowLeft, color: textColor),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),

              // TÍTULO
              Text(
                "Gerenciamento inteligente",
                style: const TextStyle(
                  color: primaryColor,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                "Programe rotinas e ative o modo de otimização de gastos",
                style: const TextStyle(
                  color: secondaryTextColor,
                  fontSize: 17,
                ),
              ),
              const SizedBox(height: 30),

              // MODO ECONOMIA
              _CardContainer(
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
                              color: primaryColor),
                        ),
                        CustomToggle(
                          isActive: isEconomyModeActive,
                          onTap: () {
                            setState(() => isEconomyModeActive = !isEconomyModeActive);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Este modo monitora o consumo em tempo real, se seus gastos estiverem significativamente elevados e excederem a projeção da sua meta, enviaremos sugestões proativas de desligamento para reverter a tendência\n",
                      style: const TextStyle(color: textColor, fontSize: 14),
                    ),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(fontSize: 14),
                        children: [
                          const TextSpan(
                            text: "Status: ",
                            style: TextStyle(color: textColor),
                          ),
                          TextSpan(
                            text: isEconomyModeActive ? "ativo" : "desativado",
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
              const Text(
                "Agendar rotina de desligamento",
                style: TextStyle(
                    color: textColor, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              _CardContainer(
                child: Column(
                  children: [
                    // Selecionar dispositivo
                    _Label("Selecione o dispositivo:"),
                    DropdownButtonFormField<int>(
                      value: selectedDevice,
                      decoration: _inputDecoration(),
                      items: availableDevices
                          .map((d) => DropdownMenuItem(
                                value: d['id'],
                                child: Text(d['name']),
                              ))
                          .toList(),
                      onChanged: (val) => setState(() => selectedDevice = val),
                    ),
                    const SizedBox(height: 15),

                    // Ação e horário
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _Label("Ação:"),
                              DropdownButtonFormField<String>(
                                value: actionType,
                                decoration: _inputDecoration(),
                                items: const [
                                  DropdownMenuItem(
                                      value: "Desligar", child: Text("Desligar")),
                                  DropdownMenuItem(
                                      value: "Ligar", child: Text("Ligar")),
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
                              _Label("Horário:"),
                              InkWell(
                                onTap: () => pickTime(false),
                                child: InputDecorator(
                                  decoration: _inputDecoration(),
                                  child: Text(actionTime),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Ligar novamente?",
                            style: TextStyle(
                                fontSize: 16,
                                color: textColor,
                                fontWeight: FontWeight.bold),
                          ),
                          CustomToggle(
                            isActive: shouldAutoRelink,
                            onTap: () {
                              setState(() => shouldAutoRelink = !shouldAutoRelink);
                            },
                          ),
                        ],
                      ),

                    const SizedBox(height: 15),

                    if (shouldAutoRelink && actionType == "Desligar")
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _Label("Horário para ligar novamente:"),
                          InkWell(
                            onTap: () => pickTime(true),
                            child: InputDecorator(
                              decoration: _inputDecoration(),
                              child: Text(relinkTime),
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 25),

                    ElevatedButton(
                      onPressed: handleSchedule,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text(
                        "AGENDAR ROTINA",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // OTIMIZAÇÃO ATIVA - Regras
              const Text(
                "Otimização ativa",
                style: TextStyle(
                    color: textColor, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              RuleDetailCard(
                icon: FeatherIcons.target,
                title: "Otimização por metas de orçamento",
                description:
                    "O sistema monitora a projeção de gastos. Se você exceder a meta definida, o app sugere o desligamento de dispositivos de alto consumo (como aquecedores) para reverter a tendência e manter seu orçamento",
                isActive: ruleStatuses['ruleTarget']!,
                onToggle: () => toggleRule('ruleTarget'),
              ),
              RuleDetailCard(
                icon: FeatherIcons.clock,
                title: "Regra de inatividade",
                description:
                    "Se o consumo do aparelho for mantido em modo stand-by (abaixo de 5 Watts) por mais de 3 horas durante a noite (23:00h - 07:00h), o app envia um alerta sugerindo o desligamento",
                isActive: ruleStatuses['ruleClock']!,
                onToggle: () => toggleRule('ruleClock'),
              ),
              RuleDetailCard(
                icon: FeatherIcons.bolt,
                title: "Regra de consumo fantasma",
                description:
                    "Se o dispositivo estiver consumindo menos de 1 Watt por mais de 8 horas seguidas, a tomada desliga automaticamente para eliminar o consumo passivo",
                isActive: ruleStatuses['ruleBolt']!,
                onToggle: () => toggleRule('ruleBolt'),
              ),

              // VISÃO GERAL
              const SizedBox(height: 30),
              _CardContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Status das regras ativas",
                      style: TextStyle(
                          color: primaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "${ruleStatuses.values.where((e) => e).length}/3 regras ativas",
                      style: const TextStyle(
                          color: successColor, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Modo de otimização: ${isEconomyModeActive ? 'ativo' : 'desativado'}",
                      style: const TextStyle(
                          color: primaryColor, fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      "Próxima ação: nenhuma rotina agendada",
                      style: TextStyle(
                          color: secondaryTextColor, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // Estilo de input
  InputDecoration _inputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: borderColor),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: primaryColor),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  Widget _Label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: Text(
          text,
          style: const TextStyle(
              color: secondaryTextColor, fontSize: 14, fontFamily: 'Inter'),
        ),
      );
}

// ---------------------- COMPONENTES REUTILIZÁVEIS ----------------------

class CustomToggle extends StatelessWidget {
  final bool isActive;
  final VoidCallback onTap;
  const CustomToggle({super.key, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 40,
        height: 20,
        decoration: BoxDecoration(
          color: isActive ? _GerenciarPageState.primaryColor : _GerenciarPageState.borderColor,
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
                    color: Colors.black26, blurRadius: 2, offset: Offset(0, 1))
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
  const RuleDetailCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.isActive,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor = isActive
        ? _GerenciarPageState.primaryColor
        : _GerenciarPageState.secondaryTextColor;

    return _CardContainer(
      marginBottom: 15,
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
                  style: const TextStyle(
                    color: _GerenciarPageState.textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              CustomToggle(isActive: isActive, onTap: onToggle),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            description,
            style: const TextStyle(
              color: _GerenciarPageState.secondaryTextColor,
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
  const _CardContainer({required this.child, this.marginBottom = 0});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: marginBottom),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: _GerenciarPageState.cardBackground,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
              color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
        ],
      ),
      child: child,
    );
  }
}
