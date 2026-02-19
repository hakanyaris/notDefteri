import 'package:flutter/material.dart';
import 'package:not_defteri/model/kayitlar.dart';

class KayitlarSayfasi extends StatefulWidget {
  const KayitlarSayfasi({super.key});

  @override
  State<KayitlarSayfasi> createState() => _KayitlarSayfasiState();
}

class _KayitlarSayfasiState extends State<KayitlarSayfasi> {
  List<Kayitlar> _kayitlar = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(context),
      floatingActionButton: _buildKayitEkleFab(context),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Center(child: Text("Şifre Kaydedici")),
      actions: [
        TextButton.icon(
          onPressed: () {},
          icon: Icon(Icons.add),
          label: Text("Kategori ekle"),
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return _buildListView(context);
  }

  Widget _buildListView(BuildContext context) {
    return ListView.builder(
      itemBuilder: _buildListItem,
      itemCount: _kayitlar.length,
    );
  }

  Widget _buildListItem(BuildContext context, int index) {
    return ListTile(title: Text(_kayitlar[index].kayitAdi.toString()));
  }

  Widget? _buildKayitEkleFab(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        _kayitEkle(context);
      },
      child: Row(children: [Icon(Icons.add)]),
    );
  }

  void _kayitEkle(BuildContext context) {
    _pencereAc(context);
  }

  Future<List<dynamic>?> _pencereAc(BuildContext context) async {
    return showDialog<List<dynamic>>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Bilgileri Giriniz"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text("Kulanıcı Adı;"),
                  Expanded(child: TextField()),
                ],
              ),

              Row(
                children: [
                  Text("Şifre"),
                  Expanded(child: TextField()),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
