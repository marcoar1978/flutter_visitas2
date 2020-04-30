import 'dart:io';

import 'package:flutter/material.dart';

import 'package:visitas_app5/models/visita_model.dart';
import 'package:visitas_app5/database/daos/fotos_dao.dart';
import 'package:visitas_app5/models/foto_model.dart';
import 'package:visitas_app5/screens/detalhe_foto.dart';

class ConsultaFotos extends StatefulWidget {
  Visita visita;

  ConsultaFotos({this.visita});

  @override
  _ConsultaFotosState createState() => _ConsultaFotosState();
}

class _ConsultaFotosState extends State<ConsultaFotos> {
  List<Foto> fotos = List();
  FotosDao fotosDao = FotosDao();
  Foto foto;

  @override
  void initState() {
    this.fotosDao.listaPorVisita(widget.visita.id).then((fotos) {
      setState(() {
        this.fotos = fotos;
        //print(this.fotos);
      });
    });
    super.initState();
  }

  Widget_listaFotos(BuildContext context) {
    return ListView.builder(
        itemCount: this.fotos.length,
        itemBuilder: (context, index) {
          Foto fotoItem = this.fotos[index];
          return _cardFoto(context, fotoItem);
        });
  }

  Widget _cardFoto(BuildContext context, Foto foto) {
    return Padding(
        padding: const EdgeInsets.only(top: 8.0, left: 48.0, right: 48.0),
        child: _containerFoto(context, foto));
  }

  Widget _containerFoto(BuildContext context, Foto foto) {
    return GestureDetector(
      onLongPress: () {
        print('event 2');
        Navigator.of(context).pushNamed(DetalheFoto.routeName, arguments: foto);
      },
      child: Card(
          child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10.0),
            alignment: Alignment.topCenter,
            child: Image.file(
              File(foto.arquivo),
              width: 250,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                foto.destaque
                    ? Icon(
                        Icons.turned_in,
                        color: Colors.blue[900],
                        size: 16.0,
                      )
                    : Text(''),
                SizedBox(
                  width: 20,
                ),
                Text(foto.legenda)
              ],
            ),
          )
        ],
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Widget_listaFotos(context);
  }
}
