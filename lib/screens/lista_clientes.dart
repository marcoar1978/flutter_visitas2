import 'package:flutter/material.dart';
import 'package:visitas_app5/components/progress.dart';
import 'package:visitas_app5/database/daos/cliente_dao.dart';
import 'package:visitas_app5/database/daos/visita_dao.dart';
import 'package:visitas_app5/models/cliente_model.dart';
import 'package:visitas_app5/models/visita_model.dart';
import 'package:visitas_app5/screens/menu_drawer.dart';

class ListaClientes extends StatefulWidget {
  static String routeName = '/listaClientes';

  @override
  _ListaClientesState createState() => _ListaClientesState();
}

class _ListaClientesState extends State<ListaClientes> {
  List<Cliente> clientes;
  ClienteDao clienteDao = ClienteDao();
  Visita visita;
  VisitaDao visitaDao = VisitaDao();
  TextEditingController clienteController = TextEditingController();
  TextEditingController pesquisaController = TextEditingController();
  String pesquisa = null;
  final _formKeyCliente = GlobalKey<FormState>();
  final _formKeyBusca = GlobalKey<FormState>();

  @override
  void initState() {

    super.initState();
  }

  Widget _futureBuilderCliente(BuildContext context) {
    return FutureBuilder(
      future: this.clienteDao.listaTodos(this.pesquisa),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Progress();
            break;
          case ConnectionState.active:
            break;
          case ConnectionState.done:
            if (snapshot.hasData) this.clientes = snapshot.data;
            return ListView.builder(
              itemCount: this.clientes.length,
              itemBuilder: (context, index) {
                Cliente cliente = this.clientes[index];
                return _futureBuilderVisitas(context, cliente);
              },
            );

            break;
        }
        return Text('');
      },
    );
  }

  Widget _futureBuilderVisitas(BuildContext context, Cliente cliente) {
    return FutureBuilder(
      future: this.visitaDao.listaPorCliente(cliente.id),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Progress();
            break;
          case ConnectionState.active:
            break;
          case ConnectionState.done:
            List<Visita> visitas = List();
            if (snapshot.hasData) visitas = snapshot.data;
            int qdeVisitas = visitas.length;
            return this._cardClinte(context, cliente, qdeVisitas);
            break;
        }
        return Text('');
      },
    );
  }

  Widget _cardClinte(BuildContext context, Cliente cliente, int qdeVisitas) {
    return Card(
      elevation: 8,
      child: ListTile(
        title: Text(
          cliente.nome,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text('Visitas: ${qdeVisitas}'),
        onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return this._altCliente(context, cliente);
              });
        },
      ),
    );
  }

  Widget _altCliente(BuildContext context, Cliente cliente) {
    this.clienteController.text = cliente.nome;
    return AlertDialog(
      title: Text('Alteração de Cliente'),
      content: Container(
        child: Form(
          key: this._formKeyCliente,
          child: TextFormField(
            controller: this.clienteController,
            decoration: InputDecoration(
              labelText: 'Cliente',
            ),
            validator: (text) {
              if (text.isEmpty) {
                return 'Digite o nome do cliente';
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
          child: Text('Alterar'),
          onPressed: () async {
            if (this._formKeyCliente.currentState.validate()) {
              Cliente clienteAlt =
                  Cliente(cliente.id, this.clienteController.text);
              await this.clienteDao.alterar(clienteAlt);
              List<Cliente> clientesAlt = await this.clienteDao.listaTodos(this.pesquisa);
              setState(() {
                this.clientes = clientesAlt;
                Navigator.pop(context);
              });
            }
          },
        ),
      ],
    );
  }

  Widget _alertSearch(BuildContext context) {
    return AlertDialog(
      title: Text('Busca de Clientes'),
      content: Container(
        child: Form(
          key: this._formKeyBusca,
          child: TextFormField(
            controller: this.pesquisaController,
            decoration: InputDecoration(
              labelText: 'Pesquisar',
            ),
            validator: (text) {
              if (text.isEmpty) {
                return 'Digite o nome do cliente';
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
                this.pesquisa = this.pesquisaController.text;
                this.pesquisaController.text = '';
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
        title: Text('Clientes'),
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return this._alertSearch(context);
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
      body: Center(
        child: Padding(
          padding:
              EdgeInsets.only(top: 16.0, left: 8.0, right: 8.0, bottom: 8.0),
          child: _futureBuilderCliente(context),
        ),
      ),
    );
  }
}
