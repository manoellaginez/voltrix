import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:voltrix/theme/theme_notifier.dart';
import 'package:voltrix/theme/app_gradients.dart';
import 'package:voltrix/services/auth_service.dart';

class EntrePage extends StatefulWidget {
  const EntrePage({super.key});

  @override
  State<EntrePage> createState() => _EntrePageState();
}

class _EntrePageState extends State<EntrePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();

  // Estado para controlar o carregamento/loading
  bool _isLoading = false;

  // Referência ao serviço de autenticação
  final AuthService _authService = authService.value;

  // Função utilitária para exibir mensagens
  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  // Lógica de login
  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await _authService.singIn(
        email: emailController.text.trim(),
        password: senhaController.text,
      );

      _showSnackBar('Login bem-sucedido! Redirecionando...');
      await Future.delayed(const Duration(milliseconds: 1500));
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/inicio');
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'user-not-found' || e.code == 'wrong-password' || e.code == 'invalid-credential') {
        errorMessage = 'Credenciais inválidas. Verifique seu e-mail e senha.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'O formato do e-mail é inválido.';
      } else if (e.code == 'too-many-requests') {
        errorMessage = 'Muitas tentativas. Tente novamente mais tarde.';
      } else {
        errorMessage = 'Erro ao fazer login: ${e.message}';
      }
      _showSnackBar(errorMessage);
    } catch (e) {
      debugPrint('Erro desconhecido durante o login: $e');
      _showSnackBar('Ocorreu um erro inesperado. Tente novamente.');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Lógica para "Esqueci minha senha"
  Future<void> _handleForgotPassword() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      _showSnackBar('Por favor, insira seu e-mail para recuperar a senha.');
      return;
    }
    if (!email.contains('@')) {
       _showSnackBar('Por favor, insira um e-mail válido.');
       return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _authService.resetPassword(email: email);
      _showSnackBar(
          'E-mail de recuperação enviado para $email. Verifique sua caixa de entrada.');
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'user-not-found') {
        errorMessage = 'Nenhuma conta encontrada com este e-mail.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'O formato do e-mail é inválido.';
      } else {
        errorMessage = 'Erro ao enviar e-mail: ${e.message}';
      }
      _showSnackBar(errorMessage);
    } catch (e) {
      debugPrint('Erro desconhecido na recuperação de senha: $e');
      _showSnackBar('Ocorreu um erro inesperado. Tente novamente.');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Acessa o estado global do tema e as cores
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final isDarkMode = themeNotifier.isDarkMode;
    final colors = getThemeStyles(isDarkMode);

    const primaryColor = kPrimaryRed;
    final textColor = colors['textColor']!;
    final secondaryTextColor = colors['secondaryTextColor']!;
    final inputFillColor = colors['cardBackground']!;
    final buttonTextColor = isDarkMode ? Colors.black : Colors.white;
    final LinearGradient currentGradient = themeNotifier.currentGradient;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: currentGradient,
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // LOGO
                  Column(
                    children: [
                      _VoltrixLogo(color: primaryColor),
                      const SizedBox(height: 8),
                      Text(
                        'projetado para você.',
                        style: GoogleFonts.inter(
                          color: primaryColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),

                  // FORM
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _InputField(
                          controller: emailController,
                          label: 'E-mail',
                          hint: 'E-mail',
                          obscure: false,
                          textColor: textColor,
                          hintTextColor: secondaryTextColor,
                          fillColor: inputFillColor,
                          primaryColor: primaryColor,
                          isEmail: true,
                        ),
                        const SizedBox(height: 15),
                        _InputField(
                          controller: senhaController,
                          label: 'Senha',
                          hint: 'Senha',
                          obscure: true,
                          textColor: textColor,
                          hintTextColor: secondaryTextColor,
                          fillColor: inputFillColor,
                          primaryColor: primaryColor,
                          isEmail: false,
                        ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(0, 0),
                            ),
                            // ========== [CORREÇÃO AQUI] ==========
                            // Chama a função correta
                            onPressed: _isLoading ? null : _handleForgotPassword,
                            // ========== [FIM DA CORREÇÃO] ==========
                            child: Text(
                              'Esqueci minha senha',
                              style: GoogleFonts.inter(
                                color: primaryColor,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // BOTÕES ENTRAR / CADASTRAR
                        _MainButton(
                          text: 'ENTRAR',
                          color: primaryColor,
                          onTap: _isLoading ? null : _handleLogin,
                          textColor: buttonTextColor,
                          isLoading: _isLoading,
                        ),
                        const SizedBox(height: 8),
                        _MainButton(
                          text: 'CADASTRE-SE',
                          color: primaryColor,
                          onTap: _isLoading
                              ? null
                              : () {
                                  Navigator.pushNamed(context, '/cadastro');
                                },
                          textColor: buttonTextColor,
                          // ========== [CORREÇÃO AQUI] ==========
                          // Removido isOutline: true para torná-lo preenchido
                          isOutline: false,
                          // ========== [FIM DA CORREÇÃO] ==========
                          isLoading: false,
                        ),
                      ],
                    ),
                  ),

                  // DIVISOR "OU"
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(
                        child: Divider(color: secondaryTextColor.withOpacity(0.5)),
                      ),
                      const SizedBox(width: 15),
                      Text(
                        'ou',
                        style: GoogleFonts.inter(
                          color: secondaryTextColor,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Divider(color: secondaryTextColor.withOpacity(0.5)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // GOOGLE BUTTON
                  _GoogleButton(
                    isDarkMode: isDarkMode,
                    secondaryTextColor: secondaryTextColor,
                    cardBackground: inputFillColor,
                  ),

                  // TERMOS
                  const SizedBox(height: 50),
                  Text(
                    'Ao clicar em cadastro, você concorda com nossos\n'
                    'Termos de Serviço e com a Política de Privacidade',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      color: secondaryTextColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------
// INPUT FIELD (MODIFICADO para TextFormField e Validação)
// ---------------------------------------------------------
class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final bool obscure;
  final Color textColor;
  final Color hintTextColor;
  final Color fillColor;
  final Color primaryColor;
  final bool isEmail;


  const _InputField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.obscure,
    required this.textColor,
    required this.hintTextColor,
    required this.fillColor,
    required this.primaryColor,
    required this.isEmail,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
      style: GoogleFonts.inter(
        color: textColor,
        fontWeight: FontWeight.w600,
        fontSize: 14,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: fillColor,
        hintText: hint,
        hintStyle: GoogleFonts.inter(
          color: hintTextColor,
          fontWeight: FontWeight.w600,
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryColor, width: 1.5),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Preencha este campo';
        }
        if (isEmail && !value.contains('@')) {
          return 'Insira um e-mail válido';
        }
        return null;
      },
    );
  }
}

// ---------------------------------------------------------
// MAIN BUTTON (MODIFICADO para suportar loading e botão secundário)
// ---------------------------------------------------------
class _MainButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback? onTap;
  final Color textColor;
  final bool isLoading;
  final bool isOutline; // Para o botão de "CADASTRE-SE"

  const _MainButton({
    required this.text,
    required this.color,
    required this.onTap,
    required this.textColor,
    this.isLoading = false,
    this.isOutline = false,
  });

  @override
  Widget build(BuildContext context) {
    // Define cores com base em 'isOutline'
    final effectiveColor = isOutline ? Colors.transparent : color;
    final effectiveTextColor = isOutline ? color : textColor;

    return SizedBox(
      width: double.infinity,
      height: 43,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: effectiveColor,
          foregroundColor: effectiveTextColor, // Cor do texto/ícone
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            // Adiciona borda apenas se for 'isOutline'
            side: isOutline ? BorderSide(color: color, width: 1.5) : BorderSide.none,
          ),
          elevation: 0,
        ),
        onPressed: isLoading ? null : onTap,
        child: isLoading
            ? SizedBox( // Widget de loading
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  // Cor do loading ajustada com base no tipo de botão
                  color: isOutline ? color : textColor,
                  strokeWidth: 2,
                ),
              )
            : Text( // Texto do botão
                text,
                style: GoogleFonts.inter(
                  color: effectiveTextColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}


// ---------------------------------------------------------
// GOOGLE BUTTON (inalterado)
// ---------------------------------------------------------
class _GoogleButton extends StatelessWidget {
  final bool isDarkMode;
  final Color secondaryTextColor;
  final Color cardBackground;

  const _GoogleButton({
    required this.isDarkMode,
    required this.secondaryTextColor,
    required this.cardBackground,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 43,
      width: double.infinity,
      child: OutlinedButton.icon(
        icon: SvgPicture.asset(
          'assets/google-icon.svg',
          height: 22,
          // ignore: deprecated_member_use
          color: isDarkMode ? Colors.white : null, // Ajusta a cor do ícone no modo escuro
        ),
        label: Text(
          'Continuar com o Google',
          style: GoogleFonts.inter(
            color: isDarkMode ? Colors.white : Colors.black87,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        style: OutlinedButton.styleFrom(
          backgroundColor: cardBackground,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          side: BorderSide(color: secondaryTextColor.withOpacity(0.5), width: 1), // Borda adaptável
        ),
        onPressed: () {
          // Implementação futura do Google Sign-In
           _showSnackBar(context, 'Login com Google não implementado.');
        },
      ),
    );
  }
   // Função movida para dentro da classe para acesso ao context
  void _showSnackBar(BuildContext context, String message) {
     ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(content: Text(message)),
     );
   }
}


// ---------------------------------------------------------
// VOLTRIX LOGO (inalterado)
// ---------------------------------------------------------
class _VoltrixLogo extends StatelessWidget {
  final Color color;
  const _VoltrixLogo({required this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      'VOLTRIX',
      style: GoogleFonts.inter(
        color: color,
        fontSize: 40,
        fontWeight: FontWeight.w800,
        letterSpacing: 2,
      ),
    );
  }
}
