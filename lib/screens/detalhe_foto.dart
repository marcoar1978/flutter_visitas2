import 'package:flutter/material.dart';
import 'dart:io';

import 'package:visitas_app5/models/foto_model.dart';

class DetalheFoto extends StatefulWidget {
  static String routeName = '/datalheFoto';

  DetalheFoto();

  @override
  _DetalheFotoState createState() => _DetalheFotoState();
}

class _DetalheFotoState extends State<DetalheFoto> {
  Foto foto;

  void _recebeParamVisita() {
    if (ModalRoute.of(context).settings.arguments != null &&
        ModalRoute.of(context).settings.arguments is Foto) {
      this.foto = ModalRoute.of(context).settings.arguments;
    }
  }

  @override
  Widget build(BuildContext context) {
    this._recebeParamVisita();
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Card(
            child: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10.0),

              alignment: Alignment.topCenter,
              child: Image.file(
                File(foto.arquivo),
                width: MediaQuery.of(context).size.width  ,
              ),
            ),

          ],
        )),
      ),
    );
  }
}
