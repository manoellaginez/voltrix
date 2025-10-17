import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voltrix/theme/theme_notifier.dart';
import 'package:voltrix/theme/app_gradients.dart';

class AdicionarDispositivoPage extends StatefulWidget {
  const AdicionarDispositivoPage({super.key});

  @override
  State<AdicionarDispositivoPage> createState() =>
      _AdicionarDispositivoPageState();
}

class _AdicionarDispositivoPageState extends State<AdicionarDispositivoPage> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController localController = TextEditingController();
  final TextEditingController tokenController = TextEditingController();

  bool receberSugestoes = false;

  void salvarDispositivo() {
    if (nomeController.text.isEmpty ||
        localController.text.isEmpty ||
        tokenController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, preencha todos os campos obrigatórios.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Dispositivo adicionado com sucesso!'),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    // 1. Acessa o estado global do tema e as cores
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final isDarkMode = themeNotifier.isDarkMode;
    final colors = getThemeStyles(isDarkMode);

    const primaryColor = kPrimaryRed;
    final textColor = colors['textColor']!;
    final secondaryTextColor = colors['secondaryTextColor']!;
    final inputBorderColor = colors['borderColor']!;
    final inputFillColor = colors['cardBackground']!;
    final buttonTextColor = isDarkMode ? Colors.black87 : Colors.white;

    return Scaffold(
      // 2. Aplicando o Gradiente Dinâmico
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
                // Botão de voltar
                IconButton(
                  icon: Icon(Icons.arrow_back_ios_new, color: textColor), // Cor dinâmica
                  onPressed: () => Navigator.pop(context),
                ),

                const SizedBox(height: 10),

                Text(
                  "Adicionar novo dispositivo",
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  "Cadastre sua tomada Voltrix",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor, // Cor dinâmica
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Siga as instruções da caixa do seu produto e cadastre o token para conectar com o aplicativo",
                  style: TextStyle(
                    color: secondaryTextColor, // Cor dinâmica
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 28),

                // Campos de texto
                _inputField(
                  controller: nomeController,
                  label: "Nome da tomada",
                  hint: "Digite o nome da tomada",
                  helper:
                      "Escolha um nome para sua tomada para o que ela atende. Exemplo: Chuveiro elétrico",
                  // 3. Passando cores dinâmicas para o input
                  textColor: textColor,
                  helperColor: secondaryTextColor,
                  fillColor: inputFillColor,
                  primaryColor: primaryColor,
                ),
                const SizedBox(height: 20),
                _inputField(
                  controller: localController,
                  label: "Local do dispositivo",
                  hint: "Digite o local do dispositivo",
                  helper: "Ambiente que o Voltrix estará instalado",
                  textColor: textColor,
                  helperColor: secondaryTextColor,
                  fillColor: inputFillColor,
                  primaryColor: primaryColor,
                ),
                const SizedBox(height: 20),
                _inputField(
                  controller: tokenController,
                  label: "Token",
                  hint: "Digite o token",
                  helper:
                      "Verifique e digite o código de Token da caixa do produto Voltrix",
                  textColor: textColor,
                  helperColor: secondaryTextColor,
                  fillColor: inputFillColor,
                  primaryColor: primaryColor,
                ),

                const SizedBox(height: 30),

                // Toggle de sugestões
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Deseja receber sugestões para esse dispositivo?",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: textColor, // Cor dinâmica
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          receberSugestoes = !receberSugestoes;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 45,
                        height: 25,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: receberSugestoes
                              ? primaryColor
                              : inputBorderColor, // Cor dinâmica
                        ),
                        child: AnimatedAlign(
                          duration: const Duration(milliseconds: 200),
                          alignment: receberSugestoes
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(3),
                            child: Container(
                              width: 19,
                              height: 19,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                // Botão salvar
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: salvarDispositivo,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(
                      "SALVAR",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: buttonTextColor, // Cor dinâmica
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ===============================
  // 🔧 CAMPO DE INPUT REUTILIZÁVEL (Agora aceita cores dinâmicas)
  // ===============================
  Widget _inputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required String helper,
    required Color textColor,
    required Color helperColor,
    required Color fillColor,
    required Color primaryColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            controller: controller,
            style: TextStyle(color: textColor), // Cor do texto digitado
            decoration: InputDecoration(
              hintText: label,
              hintStyle: TextStyle(color: textColor.withOpacity(0.5)), // Cor da dica
              filled: true,
              fillColor: fillColor, // Cor de fundo do input
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: primaryColor, width: 1.3), // Borda focada
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          helper,
          style: TextStyle(
            fontSize: 12,
            color: helperColor, // Cor dinâmica do helper
          ),
        ),
      ],
    );
  }
}