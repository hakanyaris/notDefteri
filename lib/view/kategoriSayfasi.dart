import 'package:flutter/material.dart';
import 'package:not_defteri/model/kategoriler.dart';
import 'package:not_defteri/yerel_veri_tabani.dart';

class Kategorisayfasi extends StatefulWidget {
  const Kategorisayfasi({super.key});

  @override
  State<Kategorisayfasi> createState() => _KategorisayfasiState();
}

class _KategorisayfasiState extends State<Kategorisayfasi> {
  YerelVeriTabani _yerelVeriTabani = YerelVeriTabani();
  List<Kategori> _kategoriler = [];
  late Future<List<Kategori>> _kategorilerFuture;
  @override
  void initState() {
    super.initState();
    _kategorilerFuture = _tumListeyiGetir(); // ✅ ekle
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(context),
      floatingActionButton: _buildKayitEkleFab(context),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(title: Center(child: Text("Şifre Kaydedici")));
  }

  Widget _buildBody(BuildContext context) {
    return FutureBuilder(future: _kategorilerFuture, builder: _buildListView);
  }

  Widget _buildListView(BuildContext context, AsyncSnapshot<dynamic> snapShot) {
    // ✅ hata kontrolü ekle
    if (snapShot.hasError) {
      return Center(child: Text("Hata: ${snapShot.error}"));
    }

    if (_kategoriler.isEmpty) {
      return Center(child: Text("Henüz kategori eklenmemiş."));
    }
    return ListView.builder(
      itemBuilder: _buildListItem,
      itemCount: _kategoriler.length,
    );
  }

  Widget _buildListItem(BuildContext context, int index) {
    return ListTile(
      title: Text(_kategoriler[index].kategoriAdi.toString()),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () {
              // _kategoriGuncelle(context, index);
            },
            icon: Icon(Icons.edit_outlined),
          ),
          IconButton(
            onPressed: () {
              // _kategoriSil(index);
            },
            icon: Icon(Icons.delete),
          ),
        ],
      ),
    );
  }

  Widget? _buildKayitEkleFab(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        _kategoriEkle(context);
      },
      child: Icon(Icons.add),
    );
  }

  Future<List<Kategori>> _tumListeyiGetir() async {
    _kategoriler = await _yerelVeriTabani.readTumKategori();
    return _kategoriler;
  }

  void _kategoriEkle(BuildContext context) async {
    String? kategoriAdi = await _kategoriPencereAc(context);
    if (kategoriAdi != null) {
      Kategori kategori = Kategori(kategoriAdi);
      int? sonuc = await _yerelVeriTabani.createKategori(kategori);
      if (sonuc != null && sonuc > 0) {
        setState(() {
          _kategorilerFuture = _tumListeyiGetir();
        });
      }
    }
  }

  Future<String?> _kategoriPencereAc(BuildContext context) async {
    return showDialog<String>(
      context: context,
      builder: (context) {
        String? sonuc;
        return AlertDialog(
          title: Text("Kategori Bilgilerini Giriniz"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  sonuc = value;
                },
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("iptal"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, sonuc);
                    },
                    child: Text("Onayla"),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
