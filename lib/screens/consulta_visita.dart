import 'package:flutter/material.dart';
import 'package:visitas_app5/database/daos/audio_dao.dart';
import 'package:visitas_app5/database/daos/cliente_dao.dart';
import 'package:visitas_app5/database/daos/contato_dao.dart';
import 'package:visitas_app5/database/daos/fotos_dao.dart';
import 'package:visitas_app5/enviroment/TipoVisita.dart';
import 'package:visitas_app5/models/audio_model.dart';
import 'package:visitas_app5/models/cliente_model.dart';
import 'package:visitas_app5/models/contato_model.dart';
import 'package:visitas_app5/models/foto_model.dart';
import 'package:visitas_app5/models/visita_model.dart';

class ConsultaVisita extends StatefulWidget {
  Visita visita;

  ConsultaVisita({this.visita});

  @override
  _ConsultaVisitaState createState() => _ConsultaVisitaState();
}

class _ConsultaVisitaState extends State<ConsultaVisita> {
  Contato contato;
  ContatoDao contatoDao = ContatoDao();
  Cliente cliente;
  ClienteDao clienteDao = ClienteDao();
  TiposVisita tipoVisita;
  List<Audio> audios = List();
  AudioDao audioDao = AudioDao();
  List<Foto> fotos = List();
  FotosDao fotosDao = FotosDao();

  @override
  initState() {
    contatoDao.buscaPorId(widget.visita.contato).then((c) {
      setState(() {
        this.contato = c;
      });
    });

    clienteDao.buscaPorId(widget.visita.cliente).then((c) {
      setState(() {
        this.cliente = c;
      });
    });

    fotosDao.listaPorVisita(widget.visita.id).then((fotos) {
      this.fotos = fotos;
    });

    audioDao.listaPorVisita(widget.visita.id).then((audios) {
      this.audios = audios;
    });
  }

  String _formataData(String data) {
    var dataSplit = data.split('-');
    //return '$dataSplit[2].$dataSplit[1].$dataSplit[0]';
    return dataSplit[2] + '.' + dataSplit[1] + '.' + dataSplit[0];
  }

  Widget _campoConsulta(String label, String valor) {
    return Row(
      children: <Widget>[
        Container(
          width: 90,
          child: Text(
            label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        Text(valor, style: TextStyle(fontSize: 16))
      ],
    );
  }

  String getTipoVisita(int tipo) {
    if (tipo == 0) {
      return 'Reclamação';
    } else {
      return 'Acompanhamento';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: 24.0,
            ),
            _campoConsulta(
              'Data',
              this._formataData(widget.visita.data.toString()),
            ),
            SizedBox(
              height: 16.0,
            ),
            _campoConsulta(
              'Título',
              widget.visita.titulo,
            ),
            SizedBox(
              height: 16.0,
            ),
            _campoConsulta(
              'Cliente',
              this.cliente != null ? this.cliente.nome : '',
            ),
            SizedBox(
              height: 16.0,
            ),
            _campoConsulta(
              'Tipo',
              getTipoVisita(widget.visita.tipoVisita),
            ),
            SizedBox(
              height: 16.0,
            ),
            _campoConsulta(
              'Obs',
              widget.visita.obs.toString(),
            ),
            Divider(
              height: 32.0,
            ),
            _campoConsulta(
              'Contato',
              this.contato != null ? this.contato.nome : '',
            ),
            SizedBox(
              height: 16.0,
            ),
            _campoConsulta(
              'Telefone',
              this.contato != null ? this.contato.telefone : '',
            ),
            SizedBox(
              height: 16.0,
            ),
            _campoConsulta(
              'Email',
              this.contato != null ? this.contato.email : '',
            ),
            Divider(
              height: 32.0,
            ),
            _campoConsulta(
              'Qde fotos',
              this.fotos.length.toString(),
            ),
            SizedBox(
              height: 16.0,
            ),
            _campoConsulta(
              'Qde audios',
              this.audios.length.toString(),
            )
          ],
        ),
      ),
    );
  }
}
