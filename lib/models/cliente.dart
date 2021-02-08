class Cliente {
  Cliente(
      {this.nome,
      this.endereco,
      this.email,
      this.telefone,
      this.sexo,
      this.faixaEtaria,
      this.idOwner,
      this.idDoc});

  String nome;
  String email;
  String endereco;
  String telefone;
  String idOwner;
  String idDoc;
  String faixaEtaria;
  String sexo;

  factory Cliente.fromMap(map) => Cliente(
      endereco: map["endereco"],
      nome: map["nome"],
      email: map["email"],
      sexo: map["sexo"],
      faixaEtaria: map["faixaEtaria"],
      telefone: map["telefone"],
      idOwner: map["idOwner"]);

  Map<String, dynamic> toJson() {
    return {
      "nome": this.nome,
      "email": this.email,
      "telefone": this.telefone,
      "idOwner": this.idOwner,
      "endereco": this.endereco,
      "sexo": this.sexo,
      "faixaEtaria": this.faixaEtaria
    };
  }
}
