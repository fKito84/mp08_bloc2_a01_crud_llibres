
import 'dart:io';
//He agut de afegir aixo que he trobat en els manuals perque tal i com esta el projecte
//NOMES HO HE POGUT EXECUTAR EN CONSOLA DE WINDOWS ... PERO AFEGIN AQUETES LINIES
// HEM DONAVA MOLTS ERRORS .. I EN EDGE O CHROME HEM DIU QUE ESTA DEPRECATED
// nomes funciona si executes en jdk de movils
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart';


import 'package:flutter/material.dart';
import 'views/notes/llista_view.dart';

Future <void> main() async {
  //Tambe aquetes linies per poder executar en consola de windows ...
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux) {
    // Inicializa sqflite para escritorio
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
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
