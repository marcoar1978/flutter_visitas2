import 'package:sqflite/sqlite_api.dart';
import 'package:visitas_app5/database/app_database.dart';
import 'package:visitas_app5/models/visita_model.dart';

class VisitaDao {
  static String tableSql = 'CREATE TABLE $tableName ('
      '$_id INTEGER PRIMARY KEY, '
      '$_titulo TEXT , '
      '$_cliente INTEGER ,'
      '$_tipoVisita INTEGER , '
      '$_data TEXT , '
      '$_obs TEXT , '
      '$_contato INTEGER)';

  static String tableName = 'visitas';
  static String _id = 'id';
  static String _titulo = 'titulo';
  static String _cliente = 'cliente';
  static String _tipoVisita = 'tipoVisita';
  static String _data = 'data';
  static String _obs = 'obs';
  static String _contato = 'contato';

  Future<Visita> incluir(Visita visita) async {
    Database db = await getDatabase();
    int visitaId = await db.insert(
      tableName,
      visita.toMap(),
    );
    visita.id = visitaId;
    return visita;
  }

  Future<List<Visita>> consultaPorTitulo(String titulo) async {
    Database db = await getDatabase();
    List<Map<String, dynamic>> result;
    if (titulo != null) {
      result = await db
          .rawQuery("SELECT * FROM $tableName WHERE titulo LIKE '%$titulo%'");
    } else {
      result = await db
          .rawQuery("SELECT * FROM $tableName ORDER BY $_id DESC LIMIT 10");
    }

    List<Visita> visitas = List();
    for (Map<String, dynamic> map in result) {
      visitas.add(
        Visita(
            id: map[_id],
            titulo: map[_titulo],
            cliente: map[_cliente],
            tipoVisita: map[_tipoVisita],
            data: map[_data],
            obs: map[_obs],
            contato: map[_contato]),
      );
    }
    return visitas;
  }

  Future<int> alterar(Visita visita) async {
    Database db = await getDatabase();
    int visitaId = await db.update(
      tableName,
      visita.toMap(),
      where: 'id = ?',
      whereArgs: [visita.id],
    );
  }

  Future<List<Visita>> listaTodos() async {
    Database db = await getDatabase();
    List<Map<String, dynamic>> result = await db.query(tableName);
    List<Visita> visitas = List();

    for (Map<String, dynamic> map in result) {
      visitas.add(
        Visita(
            id: map[_id],
            titulo: map[_titulo],
            cliente: map[_cliente],
            tipoVisita: map[_tipoVisita],
            data: map[_data],
            obs: map[_obs],
            contato: map[_contato]),
      );
    }
    return visitas;
  }

  Future<List<Visita>> listaPorCliente(int clienteId) async {
    Database db = await getDatabase();
    List<Map<String, dynamic>> result = await db.query(
      tableName,
      where: 'cliente = ?',
      whereArgs: [clienteId],
    );
    List<Visita> visitas = List();

    for (Map<String, dynamic> map in result) {
      visitas.add(
        Visita(
            id: map[_id],
            titulo: map[_titulo],
            cliente: map[_cliente],
            tipoVisita: map[_tipoVisita],
            data: map[_data],
            obs: map[_obs],
            contato: map[_contato]),
      );
    }
    return visitas;
  }

  Future<int> deletar(int visitaId) async {
    Database db = await getDatabase();
    int visitaDelId = await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [visitaId],
    );
  }
}
