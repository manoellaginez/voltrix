import 'package:flutter/material.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  final TextEditingController confirmarSenhaController = TextEditingController();

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) return;

    if (senhaController.text != confirmarSenhaController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('As senhas não conferem!')),
      );
      return;
    }

    // Aqui você poderia salvar no backend ou local storage
    debugPrint("Usuário cadastrado: ${nomeController.text}, ${emailController.text}");

    // Navega para a tela de início (substitua por sua rota real)
    Navigator.pushReplacementNamed(context, '/inicio');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Cadastro',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFB42222),
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 20),
                _buildInput(nomeController, 'Nome completo', TextInputType.text),
                _buildInput(emailController, 'E-mail', TextInputType.emailAddress),
                _buildInput(senhaController, 'Senha', TextInputType.visiblePassword, obscure: true),
                _buildInput(confirmarSenhaController, 'Confirmar senha', TextInputType.visiblePassword, obscure: true),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 43,
                  child: ElevatedButton(
                    onPressed: _handleSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB42222),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'ENTRAR',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontFamily: 'Inter',
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

  Widget _buildInput(
    TextEditingController controller,
    String hint,
    TextInputType type, {
    bool obscure = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        keyboardType: type,
        obscureText: obscure,
        style: const TextStyle(
          color: Color(0xFFA6A6A6),
          fontWeight: FontWeight.w600,
          fontFamily: 'Inter',
          fontSize: 14,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            color: Color(0xFFA6A6A6),
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
          filled: true,
          fillColor: const Color(0xFFF5F5F5),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        ),
        validator: (value) => value!.isEmpty ? 'Preencha este campo' : null,
      ),
    );
  }
}
