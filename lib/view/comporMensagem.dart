import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:Hypr/bloc/send.dart';
import 'package:Hypr/models/cliente.dart';
import 'package:Hypr/widget/customButton.dart';
import 'package:Hypr/widget/itemLista.dart';
import 'package:Hypr/widget/myAppBar.dart';
import 'package:Hypr/widget/myBottomNavigator.dart';
import 'package:bloc_pattern/bloc_pattern.dart';

class ComporMensagem extends StatefulWidget {
  ComporMensagem({this.clientes});
  final List<Cliente> clientes;

  @override
  _ComporMensagemState createState() => _ComporMensagemState();
}

class _ComporMensagemState extends State<ComporMensagem> {
  TextEditingController _msgController = TextEditingController();

  SendBloc _bloc = BlocProvider.getBloc<SendBloc>();

  Map<String, bool> _meiosEnvio = {
    "email": false,
    "whatsapp": false,
    "sms": false
  };

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: myAppBar(context, title: "Compor"),
        body: SingleChildScrollView(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 200,
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextFormField(
                        maxLines: 20,
                        validator: (value) {
                          if (value.isNotEmpty) {
                            return "Este campo deve ser preenchido";
                          }
                          return null;
                        },
                        controller: _msgController,
                        decoration: InputDecoration(labelText: "Mensagem"),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                  width: 400,
                ),
                Text("Métodos de envio:"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Checkbox(
                            value: _meiosEnvio["email"],
                            onChanged: (value) {
                              _meiosEnvio["email"] = value;
                              setState(() {});
                            }),
                        Text("Email")
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Checkbox(
                            value: _meiosEnvio["whatsapp"],
                            onChanged: (value) {
                              _meiosEnvio["whatsapp"] = value;
                              setState(() {});
                            }),
                        Text("Whatsapp")
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Checkbox(
                            value: _meiosEnvio["sms"],
                            onChanged: (value) {
                              _meiosEnvio["sms"] = value;
                              setState(() {});
                            }),
                        Text("SMS")
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                  width: 400,
                ),
                Text("Eviar para:"),
                SizedBox(
                  height: 20,
                  width: 400,
                ),
                Column(
                  children: widget.clientes != null
                      ? _buildList(widget.clientes)
                      : [],
                ),
                widget.clientes != null
                    ? CustomButtom(
                        text: "Enviar",
                        color: Colors.white,
                        borderColor: Colors.black,
                        onPress: () {
                          _enviarMsg();
                        },
                      )
                    : CustomButtom(
                        text: "Adicionar Pessoas",
                      ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: MyBottomNavigator(),
      ),
    );
  }

  List<Widget> _buildList(List<Cliente> _clientes) {
    return _clientes.map((cliente) {
      return ItemList(cliente: cliente);
    }).toList();
  }

  _enviarMsg() {
    if (_meiosEnvio["email"] || _meiosEnvio["whatsapp"] || _meiosEnvio["sms"]) {
      _bloc.sendMsg(widget.clientes, _msgController.text, _meiosEnvio, context);
    }
  }
}
