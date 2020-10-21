class Cliente {
  Cliente({this.nome, this.email, this.telefone, this.idOwner, this.idDoc});

  String nome;
  String email;
  String telefone;
  String idOwner;
  String idDoc;

factory Cliente.fromMap(map)=>
  Cliente(nome: map["nome"],email: map["email"],telefone: map["telefone"], idOwner: map["idOwner"]);


  Map<String, dynamic> toJson(){
return {
  "nome": this.nome,
  "email": this.email,
  "telefone": this.telefone,
  "idOwner": this.idOwner
};
  }
}
