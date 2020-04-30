import 'package:flutter/material.dart';
import 'package:visitas_app5/database/daos/visita_dao.dart';
import 'enviroment/Rotas.dart';

class VisitasApp extends StatefulWidget {
  @override
  _VisitasAppState createState() => _VisitasAppState();
}

class _VisitasAppState extends State<VisitasApp> {
  @override
  Widget build(BuildContext context) {
    VisitaDao visitaDao = VisitaDao();

     return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.green[900],
        accentColor: Colors.blueAccent[700],
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.blueAccent[700],
          textTheme: ButtonTextTheme.primary,
        ),
      ),
      initialRoute: '/',
      routes: Rotas.rotas,
    );
  }
}