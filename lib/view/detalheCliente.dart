import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rypr/models/cliente.dart';
import 'package:rypr/view/comporMensagem.dart';
import 'package:rypr/widget/customButton.dart';
import 'package:rypr/widget/myAppBar.dart';
import 'package:rypr/widget/myBottomNavigator.dart';

class DetalheCliente extends StatefulWidget {
  DetalheCliente({this.cliente});
  final Cliente cliente;

  @override
  _DetalheClienteState createState() => _DetalheClienteState();
}

class _DetalheClienteState extends State<DetalheCliente> {
  TextEditingController _msgController = TextEditingController();


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _heightField = 90;
    return Scaffold(
      appBar: myAppBar(context, title: widget.cliente.nome.split(" ")[0]),
      body: SingleChildScrollView(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              Container(
                height: _heightField,
                child: Text("Nome : ${widget.cliente.nome}"),
              ),
              Container(
                height: _heightField,
                child: Text("Email : ${widget.cliente.email}"),
              ),
              Container(
                height: _heightField,
                child: Text("Telefone : ${widget.cliente.telefone}"),
              ),
              Container(
                height: _heightField,
                child: Card(
                  color: Colors.grey,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(
                      maxLines: 8,
                      validator: (value) {
                        if (value.isNotEmpty) {
                          return "Este campo deve ser preenchido";
                        }
                        return null;
                      },
                      controller: _msgController,
                      decoration:
                          InputDecoration.collapsed(hintText: "Mensagem"),
                    ),
                  ),
                ),
              ),
              CustomButtom(
                text: "Mensagem",
                color: Colors.white,
                borderColor: Colors.black,
                onPress: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ComporMensagem(clientes: [widget.cliente])));
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: MyBottomNavigator(),
    );
  }


}
