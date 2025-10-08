import 'package:flutter/material.dart';

class GastosPage extends StatefulWidget {
  const GastosPage({Key? key}) : super(key: key);

  @override
  State<GastosPage> createState() => _GastosPageState();
}

class _GastosPageState extends State<GastosPage> {
  String activeFilter = 'Hoje';

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    const textColor = Colors.black;
    const secondaryTextColor = Colors.grey;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
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
            const Text(
              'Monitore seus custos de energia',
              style: TextStyle(
                fontSize: 17,
                color: secondaryTextColor,
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
                        backgroundColor:
                            isActive ? primaryColor : Colors.grey.shade200,
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
                  subtextColor: Colors.green,
                  icon: Icons.show_chart,
                ),
                _ResumoCard(
                  label: 'Hoje',
                  value: 'R\$ 5,30',
                  subtext: 'Custo ideal: R\$ 6,00',
                  subtextColor: secondaryTextColor,
                  icon: Icons.attach_money,
                ),
              ],
            ),

            const SizedBox(height: 25),

            // ===================== GRÁFICO =====================
            Container(
              padding: const EdgeInsets.all(15),
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
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Gastos por hora',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                      ),
                      Icon(Icons.filter_list, color: secondaryTextColor),
                    ],
                  ),
                  const SizedBox(height: 15),
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey.shade400,
                          style: BorderStyle.solid,
                        ),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
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
                          const Text(
                            '00:00 - 23:59',
                            style: TextStyle(fontSize: 12, color: secondaryTextColor),
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
                ),
                _InfoCard(
                  label: 'Projeção mensal',
                  value: 'R\$ 0,00',
                  icon: Icons.calendar_today,
                  iconColor: secondaryTextColor,
                ),
              ],
            ),

            const SizedBox(height: 25),

            // ===================== CARD ASSISTENTE =====================
            Container(
              padding: const EdgeInsets.all(15),
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
                      const Text(
                        'Fale com a Voltrix Assistente',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Quer um resumo do seu consumo no mês? A Assistente Voltrix lê e explica seus padrões de gastos.',
                    style: TextStyle(
                      fontSize: 14,
                      color: secondaryTextColor,
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

  const _ResumoCard({
    required this.label,
    required this.value,
    required this.subtext,
    required this.subtextColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    const secondaryTextColor = Colors.grey;
    return Container(
      padding: const EdgeInsets.all(15),
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
          Text(label, style: const TextStyle(fontSize: 13, color: secondaryTextColor)),
          const SizedBox(height: 5),
          Text(value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
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

  const _InfoCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    const secondaryTextColor = Colors.grey;
    return Container(
      padding: const EdgeInsets.all(15),
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
          Text(label, style: const TextStyle(fontSize: 13, color: secondaryTextColor)),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
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
