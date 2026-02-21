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
        Expanded(child:FutureBuilder(future: _tumListeyiGetir(), builder: _buildListView )   ),
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
    return ListTile(title: Text(_kayitlar[index].kayitAdi.toString()));
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
      _yerelVeriTabani.createKayit(yeniKayit);
    }
  }

   Future<void> _tumListeyiGetir() async {
    _kayitlar=await _yerelVeriTabani.readTumKitap();
   }

  Future<List<dynamic>?> _pencereAc(BuildContext context) async {
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
