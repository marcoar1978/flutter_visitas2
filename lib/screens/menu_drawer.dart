import 'package:flutter/material.dart';
import 'Dart:io';
import 'package:visitas_app5/screens/lista_clientes.dart';
import 'package:visitas_app5/screens/lista_contatos.dart';
import 'package:visitas_app5/screens/lista_visitas.dart';

class MenuDrawer extends StatefulWidget {
  @override
  _MenuDrawerState createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(''),
            decoration: BoxDecoration(
             image: DecorationImage(image: AssetImage('assets/images/projeto-engenharia-civil.jpg'))
            ),
          ),
          ListTile(
            title: Text('Visitas'),
            onTap: () async {
              await Navigator.pop(context);
              Navigator.pushNamed(context, ListaVisitas.routeName);
            },
          ),
          ListTile(
            title: Text('Clientes'),
            onTap: () async {
              await Navigator.pop(context);
              Navigator.pushNamed(context, ListaClientes.routeName);
            },
          ),
          ListTile(
            title: Text('Contatos'),
            onTap: () async {
              await Navigator.pop(context);
              Navigator.pushNamed(context, ListaContatos.routeName);
            },
          ),
          ListTile(
            title: Text('Sair'),
            onTap: () async {
              exit(0);
            },
          ),

        ],

      ),
    );
  }
}
