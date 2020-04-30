import 'package:sqflite/sqlite_api.dart';
import 'package:visitas_app5/database/app_database.dart';
import 'package:visitas_app5/models/contato_model.dart';

class ContatoDao {
  static String tableSql = 'CREATE TABLE $_tableName ('
      '$_id INTEGER PRIMARY KEY, '
      '$_nome TEXT, '
      '$_telefone TEXT, '
      '$_email TEXT )';

  static String _tableName = 'contatos';
  static String _id = 'id';
  static String _nome = 'nome';
  static String _telefone = 'telefone';
  static String _email = 'email';

  Future<Contato> incluir(Contato contato) async {
    Database db = await getDatabase();

    Map<String, dynamic> contatoMap = Map();
    contatoMap[_nome] = contato.nome;
    contatoMap[_telefone] = contato.telefone;
    contatoMap[_email] = contato.email;
    int contatoId = await db.insert(_tableName, contatoMap);
    contato.id = contatoId;
    return contato;
  }

  Future<int> alterar(Contato contato) async {
    Database db = await getDatabase();
    int contatoId = await db.update(
      _tableName,
      contato.toMap(),
      where: 'id = ?',
      whereArgs: [contato.id],
    );
  }

  Future<List<Contato>> listaTodos(String pesquisa) async {
    Database db = await getDatabase();
    List<Map<String, dynamic>> contatosMap = List();
    if (pesquisa != null) {
      contatosMap = await db.rawQuery("SELECT * FROM $_tableName WHERE $_nome LIKE '%$pesquisa%'");
    }
    else {
      contatosMap =
      await db.rawQuery("SELECT * FROM $_tableName ORDER BY $_nome");
    }

    List<Contato> contatos = List();
    for (Map<String, dynamic> contatoMap in contatosMap) {
      Contato contato = Contato.fromMap(contatoMap);
      contatos.add(contato);
    }
    return contatos;
  }

  Future<Contato> buscaPorId(int contatoId) async {
    Database db = await getDatabase();

    List<Map<String, dynamic>> contatos =
    await db.rawQuery('SELECT * FROM $_tableName  WHERE id = $contatoId');
    print(contatos.first);
    return Contato.fromMap(contatos.first);
  }
}
