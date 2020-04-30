
class Foto{

  int id;
  int visitaId;
  String arquivo;
  String legenda;
  bool destaque;

  Foto({this.id, this.visitaId, this.arquivo, this.legenda, this.destaque});

  @override
  String toString() {
    return 'Foto{id: $id, arquivo: $arquivo, legenda: $legenda, destaque: $destaque}';
  }

  Foto.fromMap(Map<String, dynamic> fotoMap):
    this.id = fotoMap['id'],
    this.visitaId = fotoMap['visitaId'],
    this.arquivo = fotoMap['arquivo'],
    this.legenda = fotoMap['legenda'],
    this.destaque = fotoMap['destaque'];

  Map<String, dynamic> toMap(){
    Map<String, dynamic> fotoMap = Map();
    fotoMap['id'] = this.id;
    fotoMap['visitaId'] = this.visitaId;
    fotoMap['arquivo'] = this.arquivo;
    fotoMap['legenda'] = this.legenda;
    fotoMap['destaque'] = this.destaque;
    return fotoMap;
  }



}