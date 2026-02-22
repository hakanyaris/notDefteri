import 'package:flutter/material.dart';
import 'package:not_defteri/model/kayitlar.dart';
import 'package:not_defteri/yerel_veri_tabani.dart';

class KayitlarSayfasi extends StatefulWidget {
  const KayitlarSayfasi({super.key});

  @override
  State<KayitlarSayfasi> createState() => _KayitlarSayfasiState();
}

class _KayitlarSayfasiState extends State<KayitlarSayfasi> {
  YerelVeriTabani _yerelVeriTabani = YerelVeriTabani();
  List<Kayit> _kayitlar = [];
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            TextButton.icon(
              onPressed: () {},
              icon: Icon(Icons.add),
              label: Text("Kategori ekle"),
            ),
          ],
        ),
        Expanded(
          child: FutureBuilder(
            future: _tumListeyiGetir(),
            builder: _buildListView,
          ),
        ),
      ],
    );
  }

  Widget _buildListView(BuildContext context, AsyncSnapshot<dynamic> any) {
    return ListView.builder(
      itemBuilder: _buildListItem,
      itemCount: _kayitlar.length,
    );
  }

  Widget _buildListItem(BuildContext context, int index) {
    return ListTile(
      title: Text(_kayitlar[index].kayitAdi.toString()),
      trailing: Row(
        children: [
          IconButton(
            onPressed: () {
              _kayitGuncelle(context, index);
            },
            icon: Icon(Icons.edit_outlined),
          ),
          IconButton(onPressed: () {}, icon: Icon(Icons.delete)),
        ],
      ),
    );
  }

  Widget? _buildKayitEkleFab(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        _kayitEkle(context);
      },
      child: Icon(Icons.add),
    );
  }

  void _kayitEkle(BuildContext context) async {
    List<dynamic>? _kayitAdiKullaniciAdiSifreList = await _pencereAc(context);
    if (_kayitAdiKullaniciAdiSifreList != null)
      _kayitAdiKullaniciAdiSifreList.map((value) {
        print(value);
      });
    if (_kayitAdiKullaniciAdiSifreList != null &&
        _kayitAdiKullaniciAdiSifreList.length > 2) {
      String kayitAdi = _kayitAdiKullaniciAdiSifreList[0];
      String kullaniciAdi = _kayitAdiKullaniciAdiSifreList[1];
      String sifre = _kayitAdiKullaniciAdiSifreList[2];
      Kayit yeniKayit = Kayit(kayitAdi, kullaniciAdi, sifre, DateTime.now());
      int? kitapId = await _yerelVeriTabani.createKayit(yeniKayit);
      if (kitapId != null) {
        setState(() {});
      }
    }
  }

  Future<void> _tumListeyiGetir() async {
    _kayitlar = await _yerelVeriTabani.readTumKayit();
  }

  Future<void> _kayitGuncelle(BuildContext contex, int index) async {
    List<dynamic>? gundelVeriler = await _pencereAc(
      context,
      mevcutKayitAdi: _kayitlar[index].kayitAdi,
      mevcutKullaniciAdi: _kayitlar[index].kayitAdi,
      mevcutSifre: _kayitlar[index].sifre
    );
  }

  Future<List<dynamic>?> _pencereAc(
    BuildContext context, {
    String mevcutKayitAdi = "",
    String mevcutKullaniciAdi = "",
    String mevcutSifre = "",
  }) async {
    TextEditingController controllerKullaniciAdi = TextEditingController();
    TextEditingController controllerSifre = TextEditingController();
    TextEditingController controllerKayitAdi = TextEditingController();

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
                  Text("Kayıt adı;"),
                  Expanded(child: TextField(controller: controllerKayitAdi)),
                ],
              ),

              Row(
                children: [
                  Text("Kulanıcı Adı;"),
                  Expanded(
                    child: TextField(controller: controllerKullaniciAdi),
                  ),
                ],
              ),

              Row(
                children: [
                  Text("Şifre"),
                  Expanded(child: TextField(controller: controllerSifre)),
                ],
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("İptal"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, [
                        controllerKayitAdi.text.trim(),
                        controllerKullaniciAdi.text.trim(),
                        controllerSifre.text.trim(),
                      ]);
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
