import 'package:sqflite/sqflite.dart';
import 'package:visitas_app5/models/foto_model.dart';
import '../app_database.dart';

class FotosDao {
  static String tableSql = 'CREATE TABLE $_tableName ('
      '$_id INTEGER PRIMARY KEY, '
      '$_visitaId INTEGER ,'
      '$_arquivo TEXT, '
      '$_legenda TEXT, '
      '$_destaque INTEGER )';

  static String _tableName = 'fotos';
  static String _id = 'id';
  static String _visitaId = 'visitaId';
  static String _arquivo = 'arquivo';
  static String _legenda = 'legenda';
  static String _destaque = 'destaque';

  Future<Foto> incluir(Foto foto) async {
    Database db = await getDatabase();
    Map<String, dynamic> fotoMap = Map();
    fotoMap[_visitaId] = foto.visitaId;
    fotoMap[_arquivo] = foto.arquivo;
    fotoMap[_legenda] = foto.legenda;
    fotoMap[_destaque] = foto.destaque ? 1 : 0;
    int fotoId = await db.insert(_tableName, fotoMap);
    foto.id = fotoId;
    return foto;
  }

  Future<List<Foto>> listaPorVisita(int visitaId) async {
    Database db = await getDatabase();
    List<Map<String, dynamic>> fotosMap = await db.rawQuery(
        'SELECT * FROM $_tableName WHERE visitaId = $visitaId ORDER BY id DESC');

    List<Foto> fotos = List();
    for (Map<String, dynamic> fotoMap in fotosMap) {
      bool campoDestaque;
      if (fotoMap[_destaque] == 1) {
        campoDestaque = true;
      } else {
        campoDestaque = false;
      }

      Foto foto = Foto(
          id: fotoMap[_id],
          visitaId: fotoMap[_visitaId],
          arquivo: fotoMap[_arquivo],
          legenda: fotoMap[_legenda],
          destaque: (fotoMap[_destaque] == 1) ? true : false);
      fotos.add(foto);
    }

    fotosMap.map((Map<String, dynamic> fotoMap) {
      return Foto.fromMap(fotoMap);
    });

    return fotos;
  }

  Future<int> delete(Foto foto) async {
    Database db = await getDatabase();
    int fotoId = await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [foto.id],
    );
    return fotoId;
  }
}
