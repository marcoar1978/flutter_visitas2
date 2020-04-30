import 'package:visitas_app5/screens/cadastro_visita.dart';
import 'package:visitas_app5/screens/consulta_visita.dart';
import 'package:visitas_app5/screens/detalhe_foto.dart';
import 'package:visitas_app5/screens/inclusao_fotos.dart';
import 'package:visitas_app5/screens/lista_clientes.dart';
import 'package:visitas_app5/screens/lista_contatos.dart';
import 'package:visitas_app5/screens/lista_visitas.dart';
import 'package:visitas_app5/screens/tab_visitas.dart';

class Rotas{
  static final rotas = {
  ListaVisitas.routeName: (context) => ListaVisitas(),
  TabVisitas.routeName: (context) => TabVisitas(),
  CadastroVisita.routeName: (context) => CadastroVisita(),
  ListaClientes.routeName: (context) => ListaClientes(),
  InclusaoFoto.routeName: (context) => InclusaoFoto(),
  DetalheFoto.routeName: (context) => DetalheFoto(),
  ListaContatos.routeName: (context) => ListaContatos()
  };
}