import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
    const primaryColor = Color(0xFFB42222);
    const secondaryInputColor = Color(0xFFF6F6F6);
    const secondaryTextColor = Color(0xFF828282);
    const inputTextColor = Color(0xFFA6A6A6);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F4F4),
      body: SafeArea(
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
                    ),
                    const SizedBox(height: 15),
                    _InputField(
                      controller: senhaController,
                      label: 'Senha',
                      hint: 'Senha',
                      obscure: true,
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
                    ),
                    const SizedBox(height: 8),
                    _MainButton(
                      text: 'CADASTRE-SE',
                      color: const Color(0xFFB42222),
                      onTap: () {
                        Navigator.pushNamed(context, '/cadastro');
                      },
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
                _GoogleButton(),

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
    );
  }
}

// ---------------------------------------------------------
// INPUT FIELD
// ---------------------------------------------------------
class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final bool obscure;

  const _InputField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.obscure,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: GoogleFonts.inter(
        color: const Color(0xFFA6A6A6),
        fontWeight: FontWeight.w600,
        fontSize: 14,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFF6F6F6),
        hintText: hint,
        hintStyle: GoogleFonts.inter(
          color: const Color(0xFFA6A6A6),
          fontWeight: FontWeight.w600,
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        // sombra leve parecida com o JSX
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------
// MAIN BUTTON
// ---------------------------------------------------------
class _MainButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onTap;

  const _MainButton({
    required this.text,
    required this.color,
    required this.onTap,
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
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------
// GOOGLE BUTTON
// ---------------------------------------------------------
class _GoogleButton extends StatelessWidget {
  const _GoogleButton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 43,
      width: double.infinity,
      child: OutlinedButton.icon(
        icon: Image.network(
          'https://upload.wikimedia.org/wikipedia/commons/5/53/Google_%22G%22_Logo.svg',
          height: 22,
        ),
        label: Text(
          'Continuar com o Google',
          style: GoogleFonts.inter(
            color: Colors.black87,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        style: OutlinedButton.styleFrom(
          backgroundColor: const Color(0xFFEEEEEE),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          side: BorderSide.none,
        ),
        onPressed: () {},
      ),
    );
  }
}

// ---------------------------------------------------------
// VOLTRIX LOGO (SVG CONVERTIDO)
// ---------------------------------------------------------
class _VoltrixLogo extends StatelessWidget {
  final Color color;
  const _VoltrixLogo({required this.color});

  @override
  Widget build(BuildContext context) {
    // por simplicidade, representaremos com apenas um texto (pode trocar depois por o SVG real)
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
