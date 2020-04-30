import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:visitas_app5/components/progress.dart';
import 'package:visitas_app5/database/daos/contato_dao.dart';
import 'package:visitas_app5/models/contato_model.dart';
import 'package:visitas_app5/screens/menu_drawer.dart';

class ListaContatos extends StatefulWidget {
  static String routeName = 'listaContatos';

  @override
  _ListaContatosState createState() => _ListaContatosState();
}

class _ListaContatosState extends State<ListaContatos> {
  ContatoDao contatoDao = ContatoDao();
  List<Contato> contatos = List();
  final _formKeyContato = GlobalKey<FormState>();
  final _formKeyBusca = GlobalKey<FormState>();
  TextEditingController nomeController = TextEditingController();
  TextEditingController telefoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController buscaController = TextEditingController();
  String pesquisa = null;

  Widget _futureBuilderContatos(BuildContext context) {
    return FutureBuilder(
      future: this.contatoDao.listaTodos(this.pesquisa),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Progress();
            break;
          case ConnectionState.active:
            break;
          case ConnectionState.done:
            if (snapshot.hasData) this.contatos = snapshot.data;
            return ListView.builder(
              itemCount: this.contatos.length,
              itemBuilder: (context, index) {
                Contato contato = this.contatos[index];
                return this._cardContato(context, contato);
              },
            );
            break;
        }
        return Text('');
      },
    );
  }

  Widget _cardContato(BuildContext context, Contato contato) {
    return Card(
      elevation: 8,
      child: ListTile(
        title: Text(
          contato.nome,
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[Text(contato.email), Text(contato.telefone)],
        ),
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              return this._alteraContato(context, contato);
            },
          );
        },
        onLongPress: () {
          launch('tel:55 11 ${contato.telefone}');
        },
      ),
    );
  }

  Widget _alteraContato(BuildContext context, Contato contato) {
    this.nomeController.text = contato.nome;
    this.telefoneController.text = contato.telefone;
    this.emailController.text = contato.email;

    return AlertDialog(
      title: Text('Alteração de Contato'),
      content: Form(
          key: _formKeyContato,
          child: Container(
            height: 250,
            child: ListView(
              children: <Widget>[
                TextFormField(
                  controller: this.nomeController,
                  decoration: InputDecoration(
                    labelText: 'Nome',
                    icon: Icon(Icons.account_circle),
                  ),
                  validator: (text) {
                    if (text.isEmpty) {
                      return 'Digite o nome';
                    }
                  },
                ),
                TextFormField(
                  controller: this.telefoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Telefone',
                    icon: Icon(Icons.phone),
                  ),
                  validator: (text) {
                    if (text.isEmpty) {
                      return 'Digite o telefone';
                    }
                  },
                ),
                TextFormField(
                  controller: this.emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      labelText: 'Email', icon: Icon(Icons.email)),
                  validator: (text) {
                    if (text.isEmpty) {
                      return 'Digite o email';
                    }
                  },
                )
              ],
            ),
          )),
      actions: <Widget>[
        FlatButton(
          child: Text('Cancelar'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        FlatButton(
          child: Text('Alterar'),
          onPressed: () async {
            if (this._formKeyContato.currentState.validate()) {
              Contato contatoAlt = Contato(
                contato.id,
                this.nomeController.text,
                this.telefoneController.text,
                this.emailController.text,
              );
              await this.contatoDao.alterar(contatoAlt);
              //List<Contato> contatosAlt = await this.contatoDao.listaTodos();
              setState(() {
                Navigator.pop(context);
              });
            }
          },
        )
      ],
    );
  }

  Widget _buscaContato(BuildContext context) {
    return AlertDialog(
      title: Text('Busca de Contatos'),
      content: Container(
        height: 100,
        child: Form(
          key: this._formKeyBusca,
          child: TextFormField(
            controller: this.buscaController,
            decoration: InputDecoration(
              labelText: 'Pesquisar',
            ),
            validator: (text) {
              if (text.isEmpty) {
                return 'Digite o nome do contato';
              }
            },
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('Cancelar'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        FlatButton(
          child: Text('Pesquisar'),
          onPressed: () {
            if (this._formKeyBusca.currentState.validate()) {
              setState(() {
                this.pesquisa = this.buscaController.text;
                Navigator.pop(context);
              });
            }
          },
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Contatos'),
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return this._buscaContato(context);
                  });
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Icon(
                Icons.search,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
      drawer: MenuDrawer(),
      body: Padding(
        padding: EdgeInsets.only(top: 16.0, left: 8.0, right: 8.0, bottom: 8.0),
        child: this._futureBuilderContatos(context),
      ),
    );
  }
}
