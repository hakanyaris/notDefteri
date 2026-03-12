import 'package:flutter/material.dart';
import 'package:not_defteri/model/kayitlar.dart';

class KayitDetay extends StatefulWidget {
  final Kayit kayit;
  KayitDetay(Kayit this.kayit, {super.key});

  @override
  State<KayitDetay> createState() => _KayitDetayState();
}

class _KayitDetayState extends State<KayitDetay> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: appBar(), body: _buildBody());
  }

  AppBar appBar() {
    return AppBar(title: Text(widget.kayit.kayitAdi.toString()));
  }

  Widget? _buildBody() {}
}
