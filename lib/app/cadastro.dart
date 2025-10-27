import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// Adicionar importação do Firebase Auth para o tratamento de exceções
import 'package:firebase_auth/firebase_auth.dart'; 

import 'package:voltrix/theme/theme_notifier.dart';
import 'package:voltrix/theme/app_gradients.dart'; // Importa getThemeStyles e kPrimaryRed
import 'package:voltrix/services/auth_service.dart';

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

  // Estado para controlar o carregamento/loading do botão
  bool _isLoading = false;

  // Referência ao serviço de autenticação
  final AuthService _authService = authService.value;

  void _showSnackBar(String message) {
     if (mounted) {
       ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
     }
  }

  // Lógica de cadastro integrada com Firebase Auth
  Future<void> _handleSubmit() async {
    // 1. Valida todos os campos do formulário
    if (!_formKey.currentState!.validate()) return;
    
    // 2. Inicia o loading
    setState(() {
      _isLoading = true;
    });

    try {
      // 3. Chamada à API do Firebase para criar a conta e atualizar o nome
      await _authService.createAccount(
        username: nomeController.text.trim(),
        email: emailController.text.trim(),
        password: senhaController.text,
      );
      
      _showSnackBar('Cadastro realizado com sucesso! Redirecionando...');

      // 4. Navega para a tela de início após o sucesso
      await Future.delayed(const Duration(milliseconds: 1500));
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/inicio');
      }

    } on FirebaseAuthException catch (e) {
      // 5. Tratamento de erros do Firebase
      String errorMessage;
      if (e.code == 'weak-password') {
        errorMessage = 'A senha deve ter pelo menos 6 caracteres.';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'O e-mail já está em uso por outra conta.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'O formato do e-mail é inválido.';
      } else {
        errorMessage = 'Erro ao cadastrar: ${e.message}';
      }
      _showSnackBar(errorMessage);

    } catch (e) {
      // 6. Tratamento de erros gerais
      debugPrint('Erro desconhecido durante o cadastro: $e');
      _showSnackBar('Ocorreu um erro inesperado. Tente novamente.');
    } finally {
      // 7. Finaliza o loading
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // 1. Acessa o estado global do tema
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final isDarkMode = themeNotifier.isDarkMode;
    
    // 2. Acessa os estilos usando a função global getThemeStyles (CORRETO)
    final colors = getThemeStyles(isDarkMode); 

    const primaryColor = kPrimaryRed;
    final inputFillColor = colors['cardBackground']!;
    final inputTextColor = colors['textColor']!; 
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
                    // Input Nome
                    _buildInput(nomeController, 'Nome completo', TextInputType.text, inputTextColor, hintTextColor, inputFillColor, primaryColor),
                    
                    // Input E-mail
                    _buildInput(emailController, 'E-mail', TextInputType.emailAddress, inputTextColor, hintTextColor, inputFillColor, primaryColor),
                    
                    // Input Senha
                    _buildInput(senhaController, 'Senha', TextInputType.visiblePassword, inputTextColor, hintTextColor, inputFillColor, primaryColor, obscure: true),
                    
                    // Input Confirmar Senha (com validação de conferência)
                    _buildInput(
                      confirmarSenhaController, 
                      'Confirmar senha', 
                      TextInputType.visiblePassword, 
                      inputTextColor, 
                      hintTextColor, 
                      inputFillColor, 
                      primaryColor, 
                      obscure: true, 
                      isConfirmPassword: true, 
                      passwordController: senhaController
                    ),
                    
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 43,
                      child: ElevatedButton(
                        // Desabilita o botão enquanto estiver carregando
                        onPressed: _isLoading ? null : _handleSubmit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          foregroundColor: Colors.white,
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
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

  // Widget de input centralizado
  Widget _buildInput(
    TextEditingController controller,
    String hint,
    TextInputType type,
    Color inputTextColor,
    Color hintTextColor,
    Color inputFillColor,
    Color primaryColor,
    {
      bool obscure = false,
      TextEditingController? passwordController, 
      bool isConfirmPassword = false, 
    }
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
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Preencha este campo';
          }
          // Validação extra para Confirmar Senha
          if (isConfirmPassword && passwordController != null && value != passwordController.text) {
            return 'As senhas não conferem';
          }
          return null; 
        },
      ),
    );
  }
}
