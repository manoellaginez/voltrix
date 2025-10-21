import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:voltrix/theme/theme_notifier.dart';
import 'package:voltrix/theme/app_gradients.dart';

class EntrePage extends StatefulWidget {
  const EntrePage({super.key});

  @override
  State<EntrePage> createState() => _EntrePageState();
}

class _EntrePageState extends State<EntrePage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // 1. Acessa o estado global do tema e as cores
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
      // Aplicando o Gradiente Dinâmico
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
                  // ------------------- LOGO -------------------
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

                  // ------------------- FORM -------------------
                  Column(
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
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(0, 0),
                          ),
                          onPressed: () {
                            // implementar esqueci minha senha futuramente
                          },
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

                      // -------- BOTÕES ENTRAR / CADASTRAR --------
                      _MainButton(
                        text: 'ENTRAR',
                        color: primaryColor,
                        onTap: () {
                          Navigator.pushNamed(context, '/inicio');
                        },
                        textColor: buttonTextColor,
                      ),
                      const SizedBox(height: 8),
                      _MainButton(
                        text: 'CADASTRE-SE',
                        color: primaryColor,
                        onTap: () {
                          Navigator.pushNamed(context, '/cadastro');
                        },
                        textColor: buttonTextColor,
                      ),
                    ],
                  ),

                  // -------- DIVISOR "OU" --------
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

                  // -------- GOOGLE BUTTON --------
                  _GoogleButton(
                    isDarkMode: isDarkMode,
                    secondaryTextColor: secondaryTextColor,
                    cardBackground: inputFillColor,
                  ),

                  // -------- TERMOS --------
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
// INPUT FIELD (Atualizado para cores dinâmicas)
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


  const _InputField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.obscure,
    required this.textColor,
    required this.hintTextColor,
    required this.fillColor,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
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
    );
  }
}

// ---------------------------------------------------------
// MAIN BUTTON (Atualizado para cores dinâmicas)
// ---------------------------------------------------------
class _MainButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onTap;
  final Color textColor;

  const _MainButton({
    required this.text,
    required this.color,
    required this.onTap,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 43,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 0,
        ),
        onPressed: onTap,
        child: Text(
          text,
          style: GoogleFonts.inter(
            color: textColor,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------
// GOOGLE BUTTON (Atualizado para cores dinâmicas)
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
        onPressed: () {},
      ),
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