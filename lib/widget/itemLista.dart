import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:Hypr/models/cliente.dart';
import 'package:Hypr/view/detalheCliente.dart';

class ItemList extends StatelessWidget {
  ItemList({this.cliente, this.selected, this.onSelect});

  final Cliente cliente;
  final bool selected;
  final Function onSelect;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetalheCliente(cliente: cliente)));
      },
      child: Column(
        children: [
          Row(
            children: <Widget>[
              Container(
                width: width * .15,
                margin: EdgeInsets.only(right: width * .02),
                child: Icon(
                  Icons.person_pin,
                  size: width * .15,
                ),
              ),
              Container(
                width: width * .65,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      cliente.nome,
                      style: Theme.of(context).textTheme.body1,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text("TELEFONE: " + cliente.telefone,
                        style: Theme.of(context).textTheme.body2),
                    Text("EMAIL: " + cliente.email,
                        style: Theme.of(context).textTheme.body2),
                  ],
                ),
              ),
              selected != null
                  ? Checkbox(value: selected, onChanged: onSelect)
                  : Container(),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Divider()
        ],
      ),
    );
  }
}
