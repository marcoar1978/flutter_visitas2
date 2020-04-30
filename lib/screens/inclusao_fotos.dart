import 'dart:io';
import 'package:flutter/material.dart';

import 'package:visitas_app5/database/daos/fotos_dao.dart';
import 'package:visitas_app5/models/foto_model.dart';
import 'package:visitas_app5/models/visita_model.dart';
import 'package:image_picker/image_picker.dart';

class InclusaoFoto extends StatefulWidget {
  static String routeName = '/inclusaoFoto';

  @override
  _InclusaoFotoState createState() => _InclusaoFotoState();
}

class _InclusaoFotoState extends State<InclusaoFoto> {
  Visita visita;
  File imagem;
  bool destaqueValue = false;
  TextEditingController legendaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  FotosDao fotosDao = FotosDao();
  List<Foto> fotos = List();

  @override
  void initState() {
    super.initState();
  }

  void _getImgGaleria() async {
    File imagemTemporaria =
        await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      this.imagem = imagemTemporaria;
    });
  }

  void _recebeParamVisita() {
    if (ModalRoute.of(context).settings.arguments != null &&
        ModalRoute.of(context).settings.arguments is Visita) {
      this.visita = ModalRoute.of(context).settings.arguments;
    }
  }

  Widget popupPreenchImg(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.warning,
            color: Colors.red,
            size: 36,
          ),
          SizedBox(
            height: 10,
          ),
          Text('Uma foto deve ser escolhida')
        ],
      ),
      actions: <Widget>[
        MaterialButton(
          child: Text('Fechar'),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    this._recebeParamVisita();

    fotosDao.listaPorVisita(this.visita.id).then((fotosDb) {
      setState(() {
        this.fotos = fotosDb;
      });
    });

    return Center(
      child: Scaffold(
        appBar: AppBar(
          title: Text(this.visita.titulo),
        ),
        body: Padding(
          padding: const EdgeInsets.only(
              top: 16.0, right: 8.0, left: 8.0, bottom: 8.0),
          child: Form(
            key: this._formKey,
            child: ListView(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    TextFormField(
                      controller: this.legendaController,
                      maxLength: 30,
                      decoration: InputDecoration(labelText: 'Legenda'),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Checkbox(
                          value: this.destaqueValue,
                          onChanged: (newValue) {
                            setState(() {
                              this.destaqueValue = newValue;
                            });
                          },
                        ),
                        Text('Destaque'),
                      ],
                    ),
                    Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        //mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.image,
                                size: 36.0, color: Colors.amber),
                            onPressed: () {
                              print('teste de evento');
                              this._getImgGaleria();
                            },
                          ),
                          (this.imagem != null)
                              ? Image.file(
                                  this.imagem,
                                  height: 100,
                                )
                              : Center(
                                  child: Text('Selecione uma imagem'),
                                ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    RaisedButton(
                      child: Text('Inserir Foto'),
                      onPressed: () async {
                        if (this.imagem == null) {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return popupPreenchImg(context);
                              });
                        } else {
                          Foto foto = Foto(
                              id: 0,
                              visitaId: visita.id,
                              arquivo: this.imagem.path,
                              legenda: this.legendaController.text,
                              destaque: this.destaqueValue);
                          await this.fotosDao.incluir(foto);
                          this.fotosDao.listaPorVisita(visita.id).then((f) {
                            setState(() {
                              this.fotos = f;
                              this.legendaController.text = '';
                              this.imagem = null;
                              this.destaqueValue = false;
                            });
                          });
                        }
                      },
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(border: Border()),
                  height: 150,
                  child: this.fotos.length > 0
                      ? ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: this.fotos.length,
                          itemBuilder: (context, index) {
                            Foto foto = this.fotos[index];
                            return Dismissible(
                              key: Key(foto.id.toString()),
                              background: Container(
                                alignment: Alignment.topCenter,
                                decoration: BoxDecoration(color: Colors.green),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              direction: DismissDirection.down,
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Image.file(
                                  File(foto.arquivo),
                                ),
                              ),
                              onDismissed: (d) async {
                                setState(() {
                                  this.fotos.removeAt(index);
                                });
                                await this.fotosDao.delete(foto);

                                var snack = SnackBar(
                                  content: Text('Foto Deletada'),
                                  action: SnackBarAction(
                                    label: 'Desfazer',
                                    onPressed: () async {
                                      await this.fotosDao.incluir(foto);
                                      List<Foto> listaFotos = await this
                                          .fotosDao
                                          .listaPorVisita(foto.visitaId);
                                      setState(() {
                                        this.fotos = listaFotos;
                                      });
                                    },
                                  ),
                                  duration: Duration(seconds: 3),
                                );
                                Scaffold.of(context).showSnackBar(snack);

                                //setState(() {
                                //  this.fotos.removeAt(index);
                                //});
                              },
                            );
                          },
                        )
                      : Text(''),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
