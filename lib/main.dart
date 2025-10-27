import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Importações do Projeto
import 'package:voltrix/services/auth_service.dart';
import 'package:voltrix/theme/theme_notifier.dart';
import 'package:voltrix/theme/app_gradients.dart'; // Para kPrimaryRed

// Importações das Páginas
import 'package:voltrix/app/adicionardispositivo.dart';
import 'package:voltrix/app/assistente.dart';
import 'package:voltrix/app/inicio.dart';
import 'package:voltrix/app/gastos.dart';
import 'package:voltrix/app/perfil.dart';
import 'package:voltrix/app/mais.dart';
import 'package:voltrix/app/cadastro.dart';
import 'package:voltrix/app/entre.dart';
import 'package:voltrix/app/gerenciar.dart';
import 'package:voltrix/app/detalhepainelsolar.dart';
// O 'detalhedispositivo.dart' é importado na 'inicio.dart', não aqui.

// Importações dos Widgets
import 'package:voltrix/widgets/navbar.dart'; // Corrigido para 'navbar.dart'

// Opções do Firebase
import 'package:voltrix/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeNotifier()),
        ChangeNotifierProvider(create: (context) => AuthService()),
      ],
      child: const VoltrixApp(),
    ),
  );
}

class VoltrixApp extends StatelessWidget {
  const VoltrixApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Ouve o ThemeNotifier
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return MaterialApp(
      title: 'Voltrix',
      debugShowCheckedModeBanner: false,
      
      // Usa o tema ATUAL do notifier
      theme: themeNotifier.currentTheme,

      // --- PONTO DE ENTRADA COM VERIFICAÇÃO DE AUTH ---
      // Verifica o estado de login para decidir a tela inicial
      home: StreamBuilder<User?>(
        stream: Provider.of<AuthService>(context, listen: false).authStateChanges,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final User? user = snapshot.data;
            // Se o usuário for nulo, vai para 'EntrePage', senão 'InicioPage'
            return user == null
                ? const EntrePage()
                : const AppScaffold(page: InicioPage(), selectedIndex: 2);
          }
          // Ecrã de carregamento enquanto o Firebase verifica
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: kPrimaryRed),
            ),
          );
        },
      ),

      // --- DEFINIÇÃO DE ROTAS ---
      routes: {
        '/entre': (_) => const EntrePage(),
        '/cadastro': (_) => const CadastroPage(),

        // Rotas que usam o AppScaffold (com Navbar)
        '/assistente': (_) => const AppScaffold(page: AssistentePage(), selectedIndex: 0),
        '/gastos': (_) => const AppScaffold(page: GastosPage(), selectedIndex: 1),
        '/inicio': (_) => const AppScaffold(page: InicioPage(), selectedIndex: 2),
        '/perfil': (_) => const AppScaffold(page: PerfilPage(), selectedIndex: 3),
        '/mais': (_) => const AppScaffold(page: MaisPage(), selectedIndex: 4),

        // Rotas que não usam o AppScaffold (sem Navbar)
        '/adicionardispositivo': (_) => const AdicionarDispositivoPage(),
        
        // ROTAS CORRIGIDAS (sem Navbar, mas pode adicionar se quiser)
        '/painel-solar': (_) => const DetalhePainelSolar(),
        '/gerenciar': (_) => const GerenciarPage(),

        // !! ROTA REMOVIDA !!
        // A linha abaixo causava o erro. A navegação será feita
        // pela 'inicio.dart' usando MaterialPageRoute.
        // '/detalhedispositivo': (_) => const DetalheDispositivoPage(), 
      },

      onUnknownRoute: (_) => MaterialPageRoute(builder: (_) => const EntrePage()),
    );
  }
}

/// Scaffold que adiciona a Navbar em todas as telas internas
class AppScaffold extends StatefulWidget {
  final Widget page;
  final int selectedIndex;

  const AppScaffold({
    super.key,
    required this.page,
    required this.selectedIndex,
  });

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  late int _selectedIndex;

  // mapeamento de índices -> rotas
  final List<String> _routes = [
    '/assistente', // 0
    '/gastos',     // 1
    '/inicio',     // 2
    '/perfil',     // 3
    '/mais',       // 4
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
  }

  void _onItemTapped(int index) {
    if (index < 0 || index >= _routes.length) return;

    final targetRoute = _routes[index];
    final currentRoute = ModalRoute.of(context)?.settings.name;

    if (currentRoute == targetRoute) {
      // Já está na página, não faz nada
      return;
    }

    // Navega para a nova rota
    Navigator.pushReplacementNamed(context, targetRoute);
  }

  @override
  Widget build(BuildContext context) {
    // Ouve o tema para as cores da Navbar
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final isDarkMode = themeNotifier.isDarkMode;
    final colors = getThemeStyles(isDarkMode);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: widget.page,
      bottomNavigationBar: Navbar( // Corrigido para 'Navbar'
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
        // Parâmetros incorretos removidos
      ),
    );
  }
}

