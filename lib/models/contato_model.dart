class Contato {
  int id;
  String nome;
  String telefone;
  String email;

  Contato(this.id, this.nome, this.telefone, this.email);

  @override
  String toString() {
    return 'Contato{id: $id, nome: $nome, telefone: $telefone, email: $email}';
  }

  Contato.fromMap(Map<String, dynamic> map)
      : this.id = map['id'],
        this.nome = map['nome'],
        this.telefone = map['telefone'],
        this.email = map['email'];

  Map<String, dynamic> toMap() {
    Map<String, dynamic> contatoMap = Map();
    contatoMap['id'] = this.id;
    contatoMap['nome'] = this.nome;
    contatoMap['telefone'] = this.telefone;
    contatoMap['email'] = this.email;
    return contatoMap;
  }
}
