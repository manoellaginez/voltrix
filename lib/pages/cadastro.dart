import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voltrix/theme/theme_notifier.dart';
import 'package:voltrix/theme/app_gradients.dart';

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
    // 1. Acessa o estado global do tema e as cores
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final isDarkMode = themeNotifier.isDarkMode;
    final colors = getThemeStyles(isDarkMode);

    const primaryColor = kPrimaryRed;
    final inputFillColor = colors['cardBackground']!;
    final inputTextColor = isDarkMode ? Colors.white : const Color(0xFFA6A6A6); // Cor do texto digitado
    final hintTextColor = colors['secondaryTextColor']!;
    
    final LinearGradient currentGradient = themeNotifier.currentGradient;

    return Scaffold(
      // Aplicando o Gradiente Dinâmico
      body: Container(
        decoration: BoxDecoration(
          gradient: currentGradient,
        ),
        child: SafeArea(
          child: Center(
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
                        color: primaryColor,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Passando cores dinâmicas
                    _buildInput(nomeController, 'Nome completo', TextInputType.text, inputTextColor, hintTextColor, inputFillColor, primaryColor),
                    _buildInput(emailController, 'E-mail', TextInputType.emailAddress, inputTextColor, hintTextColor, inputFillColor, primaryColor),
                    _buildInput(senhaController, 'Senha', TextInputType.visiblePassword, inputTextColor, hintTextColor, inputFillColor, primaryColor, obscure: true),
                    _buildInput(confirmarSenhaController, 'Confirmar senha', TextInputType.visiblePassword, inputTextColor, hintTextColor, inputFillColor, primaryColor, obscure: true),
                    
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 43,
                      child: ElevatedButton(
                        onPressed: _handleSubmit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          foregroundColor: Colors.white,
                        ),
                        child: const Text(
                          'CADASTRAR',
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
        ),
      ),
    );
  }

  // Widget de input atualizado para aceitar cores dinâmicas
  Widget _buildInput(
    TextEditingController controller,
    String hint,
    TextInputType type,
    Color inputTextColor,
    Color hintTextColor,
    Color inputFillColor,
    Color primaryColor,
    {bool obscure = false,}
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        keyboardType: type,
        obscureText: obscure,
        style: TextStyle(
          color: inputTextColor,
          fontWeight: FontWeight.w600,
          fontFamily: 'Inter',
          fontSize: 14,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: hintTextColor.withOpacity(0.7),
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
          filled: true,
          fillColor: inputFillColor,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: primaryColor, width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        ),
        validator: (value) => value!.isEmpty ? 'Preencha este campo' : null,
      ),
    );
  }
}