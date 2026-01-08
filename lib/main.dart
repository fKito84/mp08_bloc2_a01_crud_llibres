
import 'package:flutter/material.dart';
import 'views/notes/llista_view.dart';

Future <void> main() async {
  //Tambe aquetes linies per poder executar en consola de windows ...
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Crud de Llibres Flutter',
      //Aqui afegei-xo el thema verd , pero no s'aplica al boto floating
      // i ho faig manual al arxiu llita_view en el _getAfegeixView
      theme: ThemeData(
          primarySwatch: Colors.green,
          appBarTheme: const AppBarTheme(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,)
      ),
           home: const Llista(),
    );
  }
}
