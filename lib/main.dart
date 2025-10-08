import 'package:flutter/material.dart';
import 'package:voltrix/pages/home/adicionardispositivo.dart';
import 'package:voltrix/pages/home/assistente.dart';
import 'package:voltrix/pages/home/inicio.dart';
import 'package:voltrix/pages/home/gastos.dart';
import 'package:voltrix/pages/home/perfil.dart';
import 'package:voltrix/pages/home/mais.dart';
import 'package:voltrix/pages/auth/cadastro.dart';
import 'package:voltrix/pages/auth/entre.dart';
import 'package:voltrix/widgets/navbar.dart';

void main() {
  runApp(const VoltrixApp());
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

        // Todas essas rotas internas passam pelo AppScaffold (mantém navbar)
        '/assistente': (_) => const AppScaffold(page: AssistentePage(), selectedIndex: 0),
        '/gastos': (_) => const AppScaffold(page: GastosPage(), selectedIndex: 1),
        '/inicio': (_) => const AppScaffold(page: InicioPage(), selectedIndex: 2),
        '/perfil': (_) => const AppScaffold(page: PerfilPage(), selectedIndex: 3),
        '/mais': (_) => const AppScaffold(page: MaisPage(), selectedIndex: 4),

        // rota de adicionar dispositivo (exemplo)
        '/adicionardispositivo': (_) => const AppScaffold(page: AdicionarDispositivoPage(), selectedIndex: 0),
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
    // evita navegar para a mesma rota repetidamente
    final current = ModalRoute.of(context)?.settings.name;
    final target = (index >= 0 && index < _routes.length) ? _routes[index] : null;
    if (target == null) return;

    if (current == target) {
      setState(() => _selectedIndex = index); // apenas atualiza seleção visual
      return;
    }

    // substitui a rota atual pela nova (mantém a AppScaffold)
    Navigator.pushReplacementNamed(context, target);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.page,
      bottomNavigationBar: Navbar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
