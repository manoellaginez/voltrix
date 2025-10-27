import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voltrix/theme/theme_notifier.dart';
import 'package:voltrix/theme/app_gradients.dart';

class DetalhePainelSolar extends StatefulWidget {
  const DetalhePainelSolar({super.key});

  @override
  State<DetalhePainelSolar> createState() => _DetalhePainelSolarState();
}

class _DetalhePainelSolarState extends State<DetalhePainelSolar> {
  // --- Estados Mockados para os Toggles ---
  bool statusLigado = true;
  bool modoGpsLigado = true;
  bool modoManualLigado = false;
  // ----------------------------------------

  // Cor primária estática
  final Color primaryColor = kPrimaryRed;

  @override
  Widget build(BuildContext context) {
    // Acessa o tema global e as cores dinâmicas
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final isDarkMode = themeNotifier.isDarkMode;
    final colors = getThemeStyles(isDarkMode);

    final textColor = colors['textColor']!;
    final secondaryTextColor = colors['secondaryTextColor']!;
    final cardBackground = colors['cardBackground']!;
    final inactiveToggleColor = isDarkMode ? Colors.grey.shade700 : Colors.grey.shade400;

    // Obtém a altura do ecrã
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      // Aplicando o Gradiente Dinâmico na raiz
      body: Container(
        width: double.infinity,
        constraints: BoxConstraints(minHeight: screenHeight),
        decoration: BoxDecoration(
          gradient: themeNotifier.currentGradient,
        ),
        child: SafeArea(
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
                      color: secondaryTextColor,
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // ========= TÍTULO E SUBTÍTULO =========
                Text(
                  'Painel Solar Goodwe',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Local: Varanda | Tipo: Painel modelo XX',
                  style: TextStyle(
                    fontSize: 16,
                    color: secondaryTextColor,
                  ),
                ),
                const SizedBox(height: 20),

                // ========= CARD DE STATUS =========
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  decoration: BoxDecoration(
                    color: cardBackground,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.1),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildStatusRow(
                        title: 'Status',
                        statusText: statusLigado ? 'LIGADO' : 'DESLIGADO',
                        value: statusLigado,
                        onChanged: (newValue) {
                          setState(() => statusLigado = newValue);
                        },
                        textColor: textColor,
                        secondaryTextColor: secondaryTextColor,
                        // activeColor: Colors.green, // Alterado abaixo
                        inactiveColor: inactiveToggleColor,
                        primaryAppColor: primaryColor, // Passa a cor primária
                      ),
                      Divider(color: secondaryTextColor.withOpacity(0.2), height: 1),
                      _buildStatusRow(
                        title: 'Modo melhor posição GPS',
                        statusText: modoGpsLigado ? 'LIGADO' : 'DESLIGADO',
                        value: modoGpsLigado,
                        onChanged: (newValue) {
                          setState(() => modoGpsLigado = newValue);
                        },
                        textColor: textColor,
                        secondaryTextColor: secondaryTextColor,
                        // activeColor: Colors.green, // Alterado abaixo
                        inactiveColor: inactiveToggleColor,
                        primaryAppColor: primaryColor, // Passa a cor primária
                      ),
                      Divider(color: secondaryTextColor.withOpacity(0.2), height: 1),
                      _buildStatusRow(
                        title: 'Modo manual',
                        statusText: modoManualLigado ? 'LIGADO' : 'DESLIGADO',
                        value: modoManualLigado,
                        onChanged: (newValue) {
                          setState(() => modoManualLigado = newValue);
                        },
                        textColor: textColor,
                        secondaryTextColor: secondaryTextColor,
                        // activeColor: Colors.green, // Alterado abaixo
                        inactiveColor: inactiveToggleColor,
                        primaryAppColor: primaryColor, // Passa a cor primária
                      ),
                    ],
                  )
                ),
                const SizedBox(height: 25),

                // ========= CARD COMUNICAÇÃO =========
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  decoration: BoxDecoration(
                    color: cardBackground,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.1),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Comunicação com o inversor Goodwe',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 15),
                       _buildInfoRow('Quantidade de energia gerada', 'xx kWh', textColor, secondaryTextColor),
                       _buildInfoRow('Potência máxima de pico', 'xx W', textColor, secondaryTextColor),
                       _buildInfoRow('Tensão no ponto de máxima potência', 'xx V', textColor, secondaryTextColor),
                       _buildInfoRow('Corrente no ponto de máxima potência', 'xx A', textColor, secondaryTextColor),
                       _buildInfoRow('Eficiência de módulo', 'xx %', textColor, secondaryTextColor, isLast: true),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Widget Auxiliar para Linhas de Status com Toggle ---
  Widget _buildStatusRow({
    required String title,
    required String statusText,
    required bool value,
    required ValueChanged<bool> onChanged,
    required Color textColor,
    required Color secondaryTextColor,
    // required Color activeColor, // Removido activeColor daqui
    required Color inactiveColor,
    required Color primaryAppColor, // Adicionado parâmetro para a cor vermelha
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Text(
                 title,
                 style: TextStyle(
                   color: secondaryTextColor,
                   fontSize: 15,
                   fontWeight: FontWeight.w500,
                 ),
               ),
               const SizedBox(height: 2),
               Text(
                 statusText,
                 style: TextStyle(
                   color: textColor,
                   fontSize: 13,
                   fontWeight: FontWeight.w600,
                 ),
               ),
             ],
           ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            // ========== [CORREÇÃO AQUI] ==========
            // Usa a cor primária (vermelha) passada como parâmetro
            activeTrackColor: primaryAppColor,
            // ========== [FIM DA CORREÇÃO] ==========
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: inactiveColor,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ],
      ),
    );
  }

   // --- Widget Auxiliar para Linhas de Informação com Pontilhado ---
   Widget _buildInfoRow(String label, String value, Color textColor, Color secondaryTextColor, {bool isLast = false}) {
     return Padding(
       padding: EdgeInsets.only(bottom: isLast ? 0 : 12.0),
       child: Row(
         children: [
           Text(
             label,
             style: TextStyle(color: secondaryTextColor, fontSize: 14),
           ),
           Expanded(
             child: Padding(
               padding: const EdgeInsets.symmetric(horizontal: 5.0),
               child: LayoutBuilder(
                 builder: (context, constraints) {
                   final double dashWidth = 2.0;
                   final double dashSpace = 2.0;
                   final double availableWidth = constraints.maxWidth > 0 ? constraints.maxWidth : 0;
                   final int dashCount = availableWidth > 0 ? (availableWidth / (dashWidth + dashSpace)).floor() : 0;
                   return Flex(
                     direction: Axis.horizontal,
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: List.generate(dashCount, (_) {
                       return SizedBox(
                         width: dashWidth,
                         height: 1,
                         child: DecoratedBox(
                           decoration: BoxDecoration(color: secondaryTextColor.withOpacity(0.5)),
                         ),
                       );
                     }),
                   );
                 },
               ),
             ),
           ),
           Text(
             value,
             style: TextStyle(color: textColor, fontSize: 14, fontWeight: FontWeight.w600),
           ),
         ],
       ),
     );
   }

}

