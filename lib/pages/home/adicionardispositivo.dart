import 'package:flutter/material.dart';

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

    // Exemplo de "salvar" — aqui você pode integrar com o backend depois
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
    const redColor = Color(0xFFB42222);
    const grayText = Color(0xFFA6A6A6);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Botão de voltar
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),

              const SizedBox(height: 10),

              const Text(
                "Adicionar novo dispositivo",
                style: TextStyle(
                  color: redColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                "Cadastre sua tomada Voltrix",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                "Siga as instruções da caixa do seu produto e cadastre o token para conectar com o aplicativo",
                style: TextStyle(
                  color: grayText,
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
              ),
              const SizedBox(height: 20),
              _inputField(
                controller: localController,
                label: "Local do dispositivo",
                hint: "Digite o local do dispositivo",
                helper: "Ambiente que o Voltrix estará instalado",
              ),
              const SizedBox(height: 20),
              _inputField(
                controller: tokenController,
                label: "Token",
                hint: "Digite o token",
                helper:
                    "Verifique e digite o código de Token da caixa do produto Voltrix",
              ),

              const SizedBox(height: 30),

              // Toggle de sugestões
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Deseja receber sugestões para esse dispositivo?",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
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
                            ? redColor
                            : const Color(0xFFD9D9D9),
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
                    backgroundColor: redColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    "SALVAR",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===============================
  // 🔧 CAMPO DE INPUT REUTILIZÁVEL
  // ===============================
  Widget _inputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required String helper,
  }) {
    const grayText = Color(0xFFA6A6A6);

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
            decoration: InputDecoration(
              hintText: label,
              hintStyle: const TextStyle(color: Colors.black54),
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(color: Color(0xFFB42222), width: 1.3),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          helper,
          style: const TextStyle(
            fontSize: 12,
            color: grayText,
          ),
        ),
      ],
    );
  }
}
