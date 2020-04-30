import 'package:sqflite/sqlite_api.dart';
import 'package:visitas_app5/models/cliente_model.dart';
import '../app_database.dart';

class ClienteDao {
  static String tableSql = 'CREATE TABLE $_tableName('
      '$_id INTEGER PRIMARY KEY, '
      '$_nome TEXT )';

  static String _tableName = 'cliente';
  static String _id = 'id';
  static String _nome = 'nome';

  Future<Cliente> incluir(Cliente cliente) async {
    Database db = await getDatabase();
    Map<String, dynamic> clienteMap = Map();
    clienteMap['nome'] = cliente.nome;
    int clienteId = await db.insert(_tableName, clienteMap);
    cliente.id = clienteId;
    return cliente;
  }

  Future<int> alterar(Cliente cliente) async {
    Database db = await getDatabase();
    return await db.update(
      _tableName,
      cliente.toMap(),
      where: 'id = ?',
      whereArgs: [cliente.id],
    );
  }

  Future<Cliente> get(int clienteId) async {
    Database db = await getDatabase();
    List<Map<String, dynamic>> clientesMap = await db.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [clienteId],
    );

    return Cliente.fromMap(clientesMap.first);
  }

  Future<List<Cliente>> listaTodos(String pesquisa) async {
    Database db = await getDatabase();
    List<Map<String, dynamic>> result;

    if (pesquisa != null) {
      result = await db.rawQuery(
          "SELECT * FROM $_tableName WHERE $_nome LIKE '%$pesquisa%'");
    } else {
      result = await db
          .rawQuery('SELECT * FROM $_tableName ORDER BY $_nome limit 20');
    }

    List<Cliente> clientes = List();
    for (Map<String, dynamic> map in result) {
      clientes.add(
        Cliente(map[_id], map[_nome]),
      );
    }
    return clientes;
  }

  Future<Cliente> buscaPorId(int clienteId) async {
    Database db = await getDatabase();
    List<Map<String, dynamic>> clientes = await db.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [clienteId],
    );
    return Cliente.fromMap(clientes.first);
  }
}
