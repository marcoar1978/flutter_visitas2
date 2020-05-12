import 'package:flutter/material.dart';
import 'package:visitas_app5/components/progress.dart';
import 'package:visitas_app5/database/daos/audio_dao.dart';
import 'package:visitas_app5/database/daos/fotos_dao.dart';
import 'package:visitas_app5/database/daos/visita_dao.dart';
import 'package:visitas_app5/models/audio_model.dart';

import 'package:visitas_app5/models/visita_model.dart';
import 'package:visitas_app5/screens/cadastro_visita.dart';
import 'package:visitas_app5/screens/consulta_visita.dart';
import 'package:visitas_app5/screens/inclusao_audio.dart';
import 'package:visitas_app5/screens/inclusao_fotos.dart';
import 'package:visitas_app5/screens/menu_drawer.dart';
import 'package:visitas_app5/screens/tab_visitas.dart';
import 'package:visitas_app5/models/foto_model.dart';

class ListaVisitas extends StatefulWidget {
  static String routeName = '/';

  @override
  _ListaVisitasState createState() => _ListaVisitasState();
}

class _ListaVisitasState extends State<ListaVisitas> {
  TextEditingController pesquisaController = TextEditingController();
  String pesquisa = null;
  VisitaDao visitaDao = VisitaDao();
  FotosDao fotosDao = FotosDao();
  List<Visita> visitas = List();
  int qdeFotos;
  List<Foto> fotos = List();
  AudioDao audioDao = AudioDao();
  int qdeAudios;
  List<Audio> audios = List();

  Widget _listaVisitas(BuildContext context) {
    return FutureBuilder(
      future: visitaDao.consultaPorTitulo(this.pesquisa),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Progress();
            break;
          case ConnectionState.active:
            // TODO: Handle this case.
            break;
          case ConnectionState.done:
            if (snapshot.hasData) this.visitas = snapshot.data;
            this.visitas.sort((a, b) {
              var dataA = _converteData(a.data);
              var dataB = _converteData(b.data);
              if (dataA.isAfter(dataB))
                return -1;
              else if (dataA.isBefore(dataB))
                return 1;
              else
                return 0;
            });
            return ListView.builder(
              itemCount: this.visitas.length,
              itemBuilder: (context, index) {
                Visita visita = this.visitas[index];

                return _listaVisitaFotos(context, visita);
              },
            );
            break;
        }
        return Text('Erro desconhecido');
      },
    );
  }

  Widget _listaVisitaFotos(BuildContext context, Visita visita) {
    return FutureBuilder(
      future: this.fotosDao.listaPorVisita(visita.id),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Progress();
            break;
          case ConnectionState.active:
            // TODO: Handle this case.
            break;
          case ConnectionState.done:
            if (snapshot.hasData) this.fotos = snapshot.data;

            return this._dismissibleCard(context, visita, this.fotos.length);

            break;
        }
        return Text('Erro desconhecido');
      },
    );
  }

  DateTime _converteData(String data) {
    var dataSplit = data.split('-');
    DateTime dataConvert = DateTime(
      int.tryParse(dataSplit[0]),
      int.tryParse(dataSplit[1]),
      int.tryParse(dataSplit[2]),
    );
    return dataConvert;
  }

  Widget _dismissibleCard(BuildContext context, Visita visita, intQdeFotos) {
    return Dismissible(
      key: Key(visita.id.toString()),
      background: Container(
        decoration: BoxDecoration(color: Colors.amber),
        child: Align(
          alignment: Alignment(-0.9, 0.0),
          child: Icon(
            Icons.delete_outline,
            color: Colors.white,
          ),
        ),
      ),
      direction: DismissDirection.startToEnd,
      child: this._cardLista(context, visita, intQdeFotos),
      onDismissed: (d) async {
        List<Audio> listaAudios = await this.audioDao.listaPorVisita(visita.id);
        if ((intQdeFotos > 0) || (listaAudios.length > 0)) {
          showDialog(
            context: context,
            builder: (context) {
              return this._alertFotosCadastrada(context, visita);
            },
          );
        } else {
          await this.visitaDao.deletar(visita.id);
          var snack = SnackBar(
            content: Text('Visita Deletada'),
            action: SnackBarAction(
              label: 'Desfazer',
              onPressed: () async {
                Visita visitaInsert = await this.visitaDao.incluir(visita);
                List<Visita> listaVisitas = await this.visitaDao.listaTodos();
                setState(() {
                  this.visitas = listaVisitas;
                });
              },
            ),
            duration: Duration(seconds: 4),
          );
          Scaffold.of(context).showSnackBar(snack);
        }
      },
    );
  }

  Widget _alertFotosCadastrada(BuildContext context, Visita visita) {
    return AlertDialog(
      title: Text(visita.titulo),
      content: Container(
        height: 50,
        child: Column(
          children: <Widget>[
            Text('Há fotos ou audios.'),
            Text('Não é possível excluir esta visita'),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('Fechar'),
          onPressed: () {
            setState(() {});
            Navigator.pop(context);
          },
        )
      ],
    );
  }

  Widget _cardLista(BuildContext context, Visita visita, intQdeFotos) {
    return Card(
      elevation: 8,
      child: ListTile(
        title: Text(
          visita.titulo,
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          _formataData(visita.data),
          style: TextStyle(fontSize: 12.0),
        ),
        onTap: () {
          this._menuBottom(context, visita);
        },
        leading: Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blue[100],
          ),
          child: Text(intQdeFotos.toString()),
        ),
      ),
    );
  }

  String _formataData(String data) {
    var dataSplit = data.split('-');
    //return '$dataSplit[2].$dataSplit[1].$dataSplit[0]';
    return dataSplit[2] + '.' + dataSplit[1] + '.' + dataSplit[0];
  }

  void _menuBottom(BuildContext context, Visita visita) {
    showBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheet(
            builder: (context) {
              return Container(
                width: double.maxFinite,
                height: (MediaQuery.of(context).size.height/2) + 30 ,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[200],
                      blurRadius: 3.0,
                      // has the effect of softening the shadow
                      spreadRadius: 3.0,
                      // has the effect of extending the shadow
                      offset: Offset(
                        5.0, // horizontal, move right 10
                        5.0, // vertical, move down 10
                      ),
                    )
                  ],
                ),
                child: ListView(
                  //mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Center(
                          child: Container(
                        child: Column(
                          children: <Widget>[
                            Text(
                              visita.titulo,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 16.0),
                            ),
                          ],
                        ),
                      )),
                    ),
                    Container(
                      height: 200,
                      child: GridView.count(
                        childAspectRatio: 2.0,
                        crossAxisCount: 2,
                        crossAxisSpacing: 2.0,
                        mainAxisSpacing: 2.0,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Card(
                              child: Container(
                                height: 50,
                                //width: 150,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                        TabVisitas.routeName,
                                        arguments: visita);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Row(
                                      children: <Widget>[
                                        Icon(Icons.zoom_in),
                                        SizedBox(width: 10),
                                        Text('Visualizar',
                                            style: TextStyle(fontSize: 16.0)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                  CadastroVisita.routeName,
                                  arguments: visita,
                                );
                              },
                              child: Card(
                                child: Container(
                                    //width: 150,
                                    height: 50,
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Row(
                                        children: <Widget>[
                                          Icon(Icons.edit),
                                          SizedBox(width: 10),
                                          Text('Editar',
                                              style: TextStyle(fontSize: 16.0)),
                                        ],
                                      ),
                                    )),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                  InclusaoFoto.routeName,
                                  arguments: visita,
                                );
                              },
                              child: Card(
                                child: Container(
                                  //width: 150,
                                  height: 50,
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Row(
                                      children: <Widget>[
                                        Icon(Icons.camera_alt),
                                        SizedBox(width: 10),
                                        Text('Incluir Fotos',
                                            style: TextStyle(fontSize: 16.0)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                  InclusaoAudio.routeName,
                                  arguments: visita,
                                );
                              },
                              child: Card(
                                child: Container(
                                  //width: 150,
                                  height: 50,
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Row(
                                      children: <Widget>[
                                        Icon(Icons.record_voice_over),
                                        SizedBox(width: 10),
                                        Text('Incluir Áudio',
                                            style: TextStyle(fontSize: 16.0)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Card(
                          child: Container(
                            height: 50,
                            //width: 150,
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.close),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text('Fechar',
                                      style: TextStyle(fontSize: 16.0)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            onClosing: () {},
          );
        });
  }

  Widget _alertSearch() {
    return AlertDialog(
      title: Text('Busca de Visitas'),
      content: TextField(
        controller: this.pesquisaController,
        decoration: InputDecoration(
          labelText: 'Pesquisar',
          border: OutlineInputBorder(),
        ),
        onSubmitted: (text) async {
          setState(() {
            this.pesquisa = this.pesquisaController.text;
            Navigator.pop(context);
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MenuDrawer(),
      appBar: AppBar(
        title: Text('Visitas'),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return this._alertSearch();
                    });
              },
              child: Icon(
                Icons.search,
                size: 32.0,
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 16.0, left: 8.0, right: 8.0, bottom: 8.0),
        child: this._listaVisitas(context),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed(CadastroVisita.routeName);
        },
      ),
    );
  }
}
