import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voltrix/theme/theme_notifier.dart'; // Import do Notifier
import 'package:voltrix/theme/app_gradients.dart'; // Import das constantes

class GastosPage extends StatefulWidget {
  const GastosPage({Key? key}) : super(key: key);

  @override
  State<GastosPage> createState() => _GastosPageState();
}

class _GastosPageState extends State<GastosPage> {
  String activeFilter = 'Hoje';

  @override
  Widget build(BuildContext context) {
    // 1. Acessa o estado global do tema e as cores
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final isDarkMode = themeNotifier.isDarkMode;
    final colors = getThemeStyles(isDarkMode);

    const primaryColor = kPrimaryRed;
    final textColor = colors['textColor']!;
    final secondaryTextColor = colors['secondaryTextColor']!;
    final cardBackground = colors['cardBackground']!;

    return Scaffold(
      // 2. Aplicando o Gradiente Dinâmico na raiz
      body: Container(
        decoration: BoxDecoration(
          gradient: themeNotifier.currentGradient,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===================== CABEÇALHO =====================
              Text(
                'Gastos',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Monitore seus custos de energia',
                style: TextStyle(
                  fontSize: 17,
                  color: secondaryTextColor, // Cor dinâmica
                ),
              ),
              const SizedBox(height: 25),

              // ===================== FILTROS =====================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: ['Hoje', 'Semana', 'Mês'].map((filter) {
                  final bool isActive = activeFilter == filter;
                  return Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() => activeFilter = filter);
                        },
                        style: ElevatedButton.styleFrom(
                          // Cores dinâmicas para o filtro
                          backgroundColor:
                              isActive ? primaryColor : cardBackground,
                          foregroundColor:
                              isActive ? Colors.white : secondaryTextColor,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: isActive ? 3 : 0,
                        ),
                        child: Text(
                          filter.toUpperCase(),
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 25),

              // ===================== CARDS DE RESUMO =====================
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: MediaQuery.of(context).size.width < 600 ? 1 : 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 2.3,
                children: [
                  _ResumoCard(
                    label: 'Gasto total',
                    value: 'R\$ 150,50',
                    subtext: '+4.2% no último período',
                    subtextColor: Colors.green, // Cor de destaque fixa
                    icon: Icons.show_chart,
                    textColor: textColor,
                    secondaryTextColor: secondaryTextColor,
                    cardBackground: cardBackground,
                    isDarkMode: isDarkMode,
                  ),
                  _ResumoCard(
                    label: 'Hoje',
                    value: 'R\$ 5,30',
                    subtext: 'Custo ideal: R\$ 6,00',
                    subtextColor: secondaryTextColor, // Cor dinâmica
                    icon: Icons.attach_money,
                    textColor: textColor,
                    secondaryTextColor: secondaryTextColor,
                    cardBackground: cardBackground,
                    isDarkMode: isDarkMode,
                  ),
                ],
              ),

              const SizedBox(height: 25),

              // ===================== GRÁFICO =====================
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: cardBackground, // Cor dinâmica
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(isDarkMode ? 0.4 : 0.12),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Gastos por hora',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: textColor, // Cor dinâmica
                          ),
                        ),
                        Icon(Icons.filter_list, color: secondaryTextColor), // Cor dinâmica
                      ],
                    ),
                    const SizedBox(height: 15),
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: secondaryTextColor, // Cor dinâmica
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.circular(8),
                          color: isDarkMode ? Colors.black : Colors.white, // Fundo do gráfico
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              height: 5,
                              width: MediaQuery.of(context).size.width * 0.8,
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              '00:00 - 23:59',
                              style: TextStyle(fontSize: 12, color: secondaryTextColor), // Cor dinâmica
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // ===================== MÉDIA SEMANAL E PROJEÇÃO =====================
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: MediaQuery.of(context).size.width < 600 ? 1 : 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 2.3,
                children: [
                  _InfoCard(
                    label: 'Média semanal',
                    value: 'R\$ 0,00',
                    icon: Icons.show_chart,
                    iconColor: Colors.green,
                    textColor: textColor,
                    secondaryTextColor: secondaryTextColor,
                    cardBackground: cardBackground,
                    isDarkMode: isDarkMode,
                  ),
                  _InfoCard(
                    label: 'Projeção mensal',
                    value: 'R\$ 0,00',
                    icon: Icons.calendar_today,
                    iconColor: secondaryTextColor,
                    textColor: textColor,
                    secondaryTextColor: secondaryTextColor,
                    cardBackground: cardBackground,
                    isDarkMode: isDarkMode,
                  ),
                ],
              ),

              const SizedBox(height: 25),

              // ===================== CARD ASSISTENTE =====================
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: cardBackground, // Cor dinâmica
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(isDarkMode ? 0.4 : 0.12),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    )
                  ],
                  border: Border(
                    top: BorderSide(color: primaryColor, width: 4),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.smart_toy, color: primaryColor, size: 28),
                        const SizedBox(width: 10),
                        Text(
                          'Fale com a Voltrix Assistente',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: textColor, // Cor dinâmica
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Quer um resumo do seu consumo no mês? A Assistente Voltrix lê e explica seus padrões de gastos.',
                      style: TextStyle(
                        fontSize: 14,
                        color: secondaryTextColor, // Cor dinâmica
                      ),
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/assistente');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          foregroundColor: Colors.white,
                        ),
                        child: const Text(
                          'ACESSAR ASSISTENTE',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// ===================== WIDGETS REUTILIZÁVEIS =====================

class _ResumoCard extends StatelessWidget {
  final String label;
  final String value;
  final String subtext;
  final Color subtextColor;
  final IconData icon;
  final Color textColor;
  final Color secondaryTextColor;
  final Color cardBackground;
  final bool isDarkMode;

  const _ResumoCard({
    required this.label,
    required this.value,
    required this.subtext,
    required this.subtextColor,
    required this.icon,
    required this.textColor,
    required this.secondaryTextColor,
    required this.cardBackground,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: cardBackground, // Cor dinâmica
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDarkMode ? 0.4 : 0.12),
            blurRadius: 4,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 13, color: secondaryTextColor)), // Cor dinâmica
          const SizedBox(height: 5),
          Text(value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: textColor, // Cor dinâmica
              )),
          const SizedBox(height: 5),
          Row(
            children: [
              Icon(icon, size: 14, color: subtextColor),
              const SizedBox(width: 5),
              Text(
                subtext,
                style: TextStyle(fontSize: 13, color: subtextColor),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color iconColor;
  final Color textColor;
  final Color secondaryTextColor;
  final Color cardBackground;
  final bool isDarkMode;

  const _InfoCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
    required this.textColor,
    required this.secondaryTextColor,
    required this.cardBackground,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: cardBackground, // Cor dinâmica
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDarkMode ? 0.4 : 0.12),
            blurRadius: 4,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 13, color: secondaryTextColor)), // Cor dinâmica
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: textColor, // Cor dinâmica
                ),
              ),
              Icon(icon, size: 24, color: iconColor),
            ],
          )
        ],
      ),
    );
  }
}