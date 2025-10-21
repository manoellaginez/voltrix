import 'package:flutter/material.dart';
import 'package:voltrix/pages/adicionardispositivo.dart';
import 'package:voltrix/pages/assistente.dart';
import 'package:voltrix/pages/inicio.dart';
import 'package:voltrix/pages/gastos.dart';
import 'package:voltrix/pages/perfil.dart';
import 'package:voltrix/pages/mais.dart';
import 'package:voltrix/pages/cadastro.dart';
import 'package:voltrix/pages/entre.dart';
import 'package:voltrix/widgets/navbar.dart';
import 'package:provider/provider.dart'; 
import 'package:voltrix/theme/theme_notifier.dart'; 

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';



void main() async {

    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
  ); 

  runApp(
    // Envolve todo o aplicativo com o ThemeNotifier
    ChangeNotifierProvider(
      create: (context) => ThemeNotifier(),
      child: const VoltrixApp(),
    ),
  );
}

class VoltrixApp extends StatelessWidget {
  const VoltrixApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'voltrix',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFFB42222),
        fontFamily: 'Inter',
        useMaterial3: true,
      ),

      // rota inicial
      initialRoute: '/assistente',

      // Usamos routes para simplicidade
      routes: {
        '/entre': (_) => const EntrePage(),
        '/cadastro': (_) => const CadastroPage(),

        // Rotas que usam o AppScaffold
        '/assistente': (_) => const AppScaffold(page: AssistentePage(), selectedIndex: 0),
        '/gastos': (_) => const AppScaffold(page: GastosPage(), selectedIndex: 1),
        '/inicio': (_) => const AppScaffold(page: InicioPage(), selectedIndex: 2),
        '/perfil': (_) => const AppScaffold(page: PerfilPage(), selectedIndex: 3),
        '/mais': (_) => const AppScaffold(page: MaisPage(), selectedIndex: 4),

        // rota de adicionar dispositivo (sem Navbar)
        '/adicionardispositivo': (_) => const AdicionarDispositivoPage(),
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

  // mapeamento de índices -> rotas (ordem corresponde ao BottomNavigationBar)
  final List<String> _routes = [
    '/assistente', // index 0
    '/gastos',     // index 1
    '/inicio',     // index 2
    '/perfil',     // index 3
    '/mais',       // index 4
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
  }

  void _onItemTapped(int index) {
    final current = ModalRoute.of(context)?.settings.name;
    final target = (index >= 0 && index < _routes.length) ? _routes[index] : null;
    if (target == null) return;

    if (current == target) {
      setState(() => _selectedIndex = index); 
      return;
    }

    // Navega para a nova rota
    Navigator.pushReplacementNamed(context, target);
  }

  @override
  Widget build(BuildContext context) {
    // Usar o Consumer aqui garante que o Navbar, se precisar de cor dinâmica,
    // possa se adaptar. Por enquanto, mantemos transparente.
    return Scaffold(
      backgroundColor: Colors.transparent, 
      body: widget.page,
      bottomNavigationBar: Navbar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}