import 'package:flutter/material.dart';
import 'package:voltrix/pages/home/adicionardispositivo.dart';
import 'package:voltrix/pages/home/inicio.dart';
import 'pages/auth/cadastro.dart';
import 'pages/auth/entre.dart'; 

void main() {
  runApp(const VoltrixApp());
}

class VoltrixApp extends StatelessWidget {
  const VoltrixApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Voltrix',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFFB42222),
        fontFamily: 'Inter',
        useMaterial3: true,
      ),

      // tela inicial
      initialRoute: '/adicionardispositivo',

      onGenerateRoute: (settings) {
        final routeName = settings.name;

        if (routeName == '/entre') {
          return MaterialPageRoute(builder: (_) => const EntrePage());
        }

        if (routeName == '/cadastro') {
          return MaterialPageRoute(builder: (_) => const CadastroPage());
        }

        if (routeName == '/inicio') {
          return MaterialPageRoute(builder: (_) => const InicioPage());
        }

        if (routeName == '/adicionardispositivo') {
          return MaterialPageRoute(builder: (_) => const AdicionarDispositivoPage());
        }

        // rota padrão se nada for encontrado
        return MaterialPageRoute(builder: (_) => const EntrePage());
      },
    );
  }
}
