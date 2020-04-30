class Visita {
  int id;
  String titulo;
  int cliente;
  int tipoVisita;
  String data;
  String obs;
  int contato;

  Visita({
    this.id,
    this.titulo,
    this.cliente,
    this.tipoVisita,
    this.data,
    this.obs,
    this.contato,
  });

  @override
  String toString() {
    return 'Visita{id: $id, titulo: $titulo, cliente: $cliente, tipoVisita: $tipoVisita, data: $data, obs: $obs, contato: $contato}';
  }

  Visita.fromMap(Map map)
      : id = map['id'],
        titulo = map['titulo'],
        cliente = map['cliente'],
        tipoVisita = map['tipoVisita'],
        data = map['data'],
        obs = map['obs'],
        contato = map['contato'];

  Map toMap() {
    Map<String, dynamic> visitaMap = Map();
    //visitaMap['id'] = this.id;
    visitaMap['titulo'] = this.titulo;
    visitaMap['cliente'] = this.cliente;
    visitaMap['tipoVisita'] = this.tipoVisita;
    visitaMap['data'] = this.data;
    visitaMap['obs'] = this.obs;
    visitaMap['contato'] = this.contato;
    return visitaMap;
  }
}
