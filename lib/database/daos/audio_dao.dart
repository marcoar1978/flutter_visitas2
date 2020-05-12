import 'package:sqflite/sqlite_api.dart';
import '../app_database.dart';
import 'package:visitas_app5/models/audio_model.dart';

class AudioDao {
  static String tableSql = 'CREATE TABLE $_tableName ('
      '$_id INTEGER PRIMARY KEY, '
      '$_visitaId INTEGER, '
      '$_legenda TEXT, '
      '$_arquivo TEXT, '
      '$_duracao TEXT )';

  static String _tableName = 'audio';
  static String _id = 'id';
  static String _visitaId = 'visitaId';
  static String _legenda = 'legenda';
  static String _arquivo = 'arquivo';
  static String _duracao = 'duracao';

  Future<Audio> incluir(Audio audio) async {
    Database db = await getDatabase();
    Map<String, dynamic> audioMap = Map();
    audioMap[_visitaId] = audio.visitaId;
    audioMap[_legenda] = audio.legenda;
    audioMap[_arquivo] = audio.arquivo;
    audioMap[_duracao] = audio.duracao;
    int audioId = await db.insert(_tableName, audioMap);
    audio.id = audioId;
    return audio;
  }

  Future<int> deletar(Audio audio) async {
    Database db = await getDatabase();
    return await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [audio.id],
    );
  }

  Future<List<Audio>> listaPorVisita(int visitaId) async {
    Database db = await getDatabase();
    List<Audio> audios = List();
    List<Map<String, dynamic>> audiosMap = await db.rawQuery(
        "SELECT * FROM $_tableName WHERE visitaId = $visitaId ORDER BY id");
    for (Map<String, dynamic> audioMap in audiosMap) {
      Audio audio = Audio();
      audio.id = audioMap[_id];
      audio.visitaId = audioMap[_visitaId];
      audio.legenda = audioMap[_legenda];
      audio.arquivo = audioMap[_arquivo];
      audio.duracao = audioMap[_duracao];
      audios.add(audio);
    }
    return audios;
  }
}
