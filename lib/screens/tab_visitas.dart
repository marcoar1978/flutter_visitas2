import 'package:flutter/material.dart';
import 'package:visitas_app5/models/visita_model.dart';
import 'package:visitas_app5/screens/consulta_fotos.dart';
import 'package:visitas_app5/screens/consulta_visita.dart';
import 'package:visitas_app5/screens/lista_audios.dart';

class TabVisitas extends StatefulWidget {
  static String routeName = '/tabVisitas';

  @override
  _TabVisitasState createState() => _TabVisitasState();
}

class _TabVisitasState extends State<TabVisitas> {
  Visita visita;
  int _selectedIndex = 0;

  void recebeParamVisita() {
    if (ModalRoute.of(context).settings.arguments != null &&
        ModalRoute.of(context).settings.arguments is Visita) {
      this.visita = ModalRoute.of(context).settings.arguments;
    }
  }

  @override
  Widget build(BuildContext context) {
    this.recebeParamVisita();

    List<Widget> _widgetOptions = <Widget>[
      ConsultaVisita(
        visita: this.visita,
      ),
      ConsultaFotos(
        visita: this.visita,
      ),
      ListaAudios(
        visita: this.visita,
      ),
    ];

    return Center(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pushNamed('/');
            },
          ),
          title: Text(this.visita.titulo),
        ),
        body: _widgetOptions.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                title: Text('Dados'),
                icon: Icon(Icons.assignment),
              ),
              BottomNavigationBarItem(
                title: Text('Fotos'),
                icon: Icon(Icons.photo_camera),
              ),
              BottomNavigationBarItem(
                title: Text('Áudios'),
                icon: Icon(Icons.play_circle_filled)
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            }),
      ),
    );
  }
}
