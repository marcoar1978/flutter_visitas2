import 'dart:core';

class Audio {
  int id;
  int visitaId;
  String legenda;
  String arquivo;
  String duracao;

  Audio();

  @override
  String toString() {
    return 'Audio{id: $id, visitaId: $visitaId, legenda: $legenda, arquivo: $arquivo, duracao: $duracao}';
  }

  Audio.fromMap(Map audioMap)
      : this.id = audioMap['id'],
        this.visitaId = audioMap['visitaId'],
        this.legenda = audioMap['legenda'],
        this.arquivo = audioMap['arquivo'],
        this.duracao = audioMap['duracao'];

  Map<String, dynamic> toMap() {
    Map<String, dynamic> audioMap = Map();
    audioMap['id'] = this.id;
    audioMap['visitaId'] = this.visitaId;
    audioMap['legenda'] = this.legenda;
    audioMap['arquivo'] = this.arquivo;
    audioMap['duracao'] = this.duracao;
    return audioMap;
  }
}
