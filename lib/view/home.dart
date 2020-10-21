import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rypr/widget/menuLateral.dart';
import 'package:rypr/widget/myAppBar.dart';
import 'package:rypr/widget/myBottomNavigator.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        elevation: 100,
        child: MenuLateral(),
      ),
      appBar: myAppBar(context, title: "Home", disableBack:true),
      body: Center(
        child: Text("Welcome meu consagrado"),
      ),
      bottomNavigationBar: MyBottomNavigator(),
    );
  }
}
