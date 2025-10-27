import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:voltrix/services/auth_service.dart';
import 'package:voltrix/theme/theme_notifier.dart';
import 'package:voltrix/theme/app_gradients.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  // Cores principais
  static const Color primaryRed = kPrimaryRed;

  // Controlador para o diálogo de edição de nome
  final TextEditingController _nomeController = TextEditingController();

  @override
  void dispose() {
    _nomeController.dispose();
    super.dispose();
  }

  // Função para lidar com o "Sair"
  Future<void> _handleSignOut(AuthService authService) async {
    try {
      await authService.singOut();
      // Garante que o usuário vá para a tela de login e limpe o histórico
      if (mounted) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/entre', (route) => false);
      }
    } catch (e) {
      debugPrint("Erro ao sair: $e");
    }
  }

  // Função para mostrar o diálogo de edição
  void _showEditProfileDialog(
    BuildContext context,
    AuthService authService,
    User user,
    Color cardBackground,
    Color textColor,
    Color secondaryTextColor,
  ) {
    _nomeController.text = user.displayName ?? "";

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: cardBackground,
          title: Text('Editar Nome', style: TextStyle(color: textColor)),
          content: TextField(
            controller: _nomeController,
            autofocus: true,
            style: TextStyle(color: textColor),
            decoration: InputDecoration(
              labelText: 'Nome completo',
              labelStyle: TextStyle(color: secondaryTextColor),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: primaryRed),
              ),
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancelar', style: TextStyle(color: secondaryTextColor)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: primaryRed),
              child:
                  const Text('Salvar', style: TextStyle(color: Colors.white)),
              onPressed: () async {
                final newName = _nomeController.text.trim();
                if (newName.isNotEmpty) {
                  try {
                    await authService.updateUsername(username: newName);
                    if (mounted) Navigator.of(context).pop();
                  } catch (e) {
                    debugPrint("Erro ao atualizar nome: $e");
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // 1. Acessa o estado global do tema
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final isDarkMode = themeNotifier.isDarkMode;
    final colors = getThemeStyles(isDarkMode);

    final textColor = colors['textColor']!;
    final secondaryTextColor = colors['secondaryTextColor']!;
    final cardBackground = colors['cardBackground']!;
    final borderColor = colors['borderColor']!;
    final reverseTextColor = isDarkMode ? Colors.black : Colors.white;
    final LinearGradient currentGradient = themeNotifier.currentGradient;

    // 2. Ouve o AuthService para dados do usuário e reatividade
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: currentGradient,
        ),
        // Consumer garante que a tela se atualize se o usuário (ex: nome) mudar
        child: Consumer<AuthService>(
          builder: (context, authService, child) {
            final User? user = authService.currentUser;
            final String userName = user?.displayName ?? "Visitante";
            final String userEmail = user?.email ?? "Nenhum e-mail";
            final String status = user != null ? "CONTA ATIVA" : "OFFLINE";

            return SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 450),
                  margin: const EdgeInsets.symmetric(horizontal: 0),
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // CABEÇALHO
                      Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Perfil',
                              style: TextStyle(
                                color: primaryRed,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Inter',
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Seu espaço pessoal e dados de consumo',
                              style: TextStyle(
                                color: secondaryTextColor,
                                fontSize: 17,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ],
                        ),
                      ),

                      // CARTÃO DE INFORMAÇÕES DO USUÁRIO
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: cardBackground,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black
                                    .withOpacity(isDarkMode ? 0.4 : 0.12),
                                blurRadius: 5,
                                offset: const Offset(0, 2))
                          ],
                        ),
                        padding: const EdgeInsets.all(20),
                        margin: const EdgeInsets.only(bottom: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: secondaryTextColor.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    FeatherIcons.user,
                                    color: primaryRed,
                                    size: 30,
                                  ),
                                ),
                                if (user !=
                                    null) // Só mostra 'editar' se logado
                                  GestureDetector(
                                    onTap: () {
                                      _showEditProfileDialog(
                                        context,
                                        authService,
                                        user,
                                        cardBackground,
                                        textColor,
                                        secondaryTextColor,
                                      );
                                    },
                                    child: Icon(
                                      FeatherIcons.edit2,
                                      color: secondaryTextColor,
                                      size: 20,
                                    ),
                                  )
                              ],
                            ),
                            const SizedBox(height: 15),
                            Text(
                              userName, // Dado do Firebase
                              style: TextStyle(
                                color: textColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Inter',
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              userEmail, // Dado do Firebase
                              style: TextStyle(
                                color: secondaryTextColor,
                                fontSize: 14,
                                fontFamily: 'Inter',
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: primaryRed,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                status, // Dado dinâmico
                                style: TextStyle(
                                  color: reverseTextColor,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),

                      // ESTATÍSTICAS DE USO
                      Text(
                        'Estatísticas de uso',
                        style: TextStyle(
                          color: textColor, // Cor dinâmica
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: cardBackground, // Cor dinâmica
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black
                                    .withOpacity(isDarkMode ? 0.4 : 0.12),
                                blurRadius: 5,
                                offset: const Offset(0, 2))
                          ],
                        ),
                        // Padding do card principal
                        padding: const EdgeInsets.all(15),
                        margin: const EdgeInsets.only(bottom: 20),

                        child: GridView.count(
                          crossAxisCount: 2, // 2 colunas
                          shrinkWrap: true, // Para caber no SingleChildScrollView
                          physics: const NeverScrollableScrollPhysics(), // Desativa scroll
                          mainAxisSpacing: 10, // Espaço vertical entre os itens
                          crossAxisSpacing: 10, // Espaço horizontal entre os itens
                          children: [
                            // Passando as cores e 'isDarkMode' para o statItem
                            _statItem('25', 'Dias de uso', textColor,
                                secondaryTextColor, isDarkMode, context),
                            _statItem('12', 'Dispositivos', textColor,
                                secondaryTextColor, isDarkMode, context),
                            _statItem('R\$ 87,50', 'Economia total', textColor,
                                secondaryTextColor, isDarkMode, context),
                            _statItem('15%', 'Redução consumo', textColor,
                                secondaryTextColor, isDarkMode, context),
                          ],
                        ),
                      ),

                      // AÇÕES DE ENERGIA
                      Text(
                        'Ações de energia',
                        style: TextStyle(
                          color: textColor, // Cor dinâmica
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: cardBackground, // Cor dinâmica
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black
                                    .withOpacity(isDarkMode ? 0.4 : 0.12),
                                blurRadius: 5,
                                offset: const Offset(0, 2))
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        margin: const EdgeInsets.only(bottom: 20),
                        child: Column(
                          children: [
                            _actionItem(
                              icon: FeatherIcons.zap,
                              title: 'Meus dispositivos',
                              description:
                                  'Gerencie os aparelhos conectados',
                              onTap: () =>
                                  debugPrint('Abrir Meus Dispositivos'),
                              borderColor: borderColor,
                              textColor: textColor,
                              secondaryTextColor: secondaryTextColor,
                              primaryRed: primaryRed,
                              isLast: false,
                            ),
                            _actionItem(
                              icon: FeatherIcons.target,
                              title: 'Metas de economia',
                              description:
                                  'Defina e acompanhe seus objetivos',
                              onTap: () =>
                                  debugPrint('Abrir Metas de Economia'),
                              borderColor: borderColor,
                              textColor: textColor,
                              secondaryTextColor: secondaryTextColor,
                              primaryRed: primaryRed,
                              isLast: true,
                            ),
                          ],
                        ),
                      ),

                      // BOTÃO SAIR
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => _handleSignOut(authService),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryRed,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            shadowColor: Colors.black12,
                            elevation: 2,
                          ),
                          child: const Text(
                            'SAIR DA CONTA',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),

                      // RODAPÉ
                      Center(
                        child: Text(
                          '© 2025 Voltrix. Todos os direitos reservados.',
                          style: TextStyle(
                            color: secondaryTextColor, // Cor dinâmica
                            fontSize: 12,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _statItem(
    String value,
    String label,
    Color textColor,
    Color secondaryTextColor,
    bool isDarkMode,
    BuildContext context,
  ) {
    final Color itemBackgroundColor =
        isDarkMode ? Colors.white.withOpacity(0.05) : Colors.white;

    return Container(
      // ========== [ALTERAÇÃO AQUI] ==========
      // Padding vertical reduzido de 16 para 12
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8), 
      // ========== [FIM DA ALTERAÇÃO] ==========
      decoration: BoxDecoration(
        color: itemBackgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Centraliza o conteúdo
        children: [
          Text(
            value,
            style: TextStyle(
              color: textColor, // Cor dinâmica
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: secondaryTextColor, // Cor dinâmica
              fontSize: 12,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionItem({
    required IconData icon,
    required String title,
    String? description,
    required VoidCallback onTap,
    required Color borderColor,
    required Color textColor,
    required Color secondaryTextColor,
    required Color primaryRed,
    required bool isLast,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: isLast
              ? null
              : Border(
                  bottom: BorderSide(color: borderColor, width: 1), // Cor dinâmica
                ),
        ),
        child: Row(
          children: [
            Icon(icon, color: primaryRed, size: 20),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: textColor, // Cor dinâmica
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Inter',
                    ),
                  ),
                  if (description != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        description,
                        style: TextStyle(
                          color: secondaryTextColor, // Cor dinâmica
                          fontSize: 12,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Icon(
              FeatherIcons.chevronRight,
              color: secondaryTextColor, // Cor dinâmica
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

