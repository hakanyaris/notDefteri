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
    return FutureBuilder(future: _tumListeyiGetir(), builder: _buildListView);
  }

  Widget _buildListView(BuildContext context, AsyncSnapshot<dynamic> snapShot) {
    if (snapShot.connectionState == ConnectionState.waiting) {
      return Center(child: CircularProgressIndicator());
    }

    if (_kategoriler.isEmpty) {
      return Center(child: Text("Henüz kitap eklenmemiş."));
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
        setState(() {});
      }
    }
  }

  // void _kayitEkle(BuildContext context) async {
    // List<dynamic>? _kayitAdiKullaniciAdiSifreList = await _pencereAc(context);
    // if (_kayitAdiKullaniciAdiSifreList != null)
    //   _kayitAdiKullaniciAdiSifreList.map((value) {
    //     print(value);
    //   });
    // if (_kayitAdiKullaniciAdiSifreList != null &&
    //     _kayitAdiKullaniciAdiSifreList.length > 2) {
    //   String kayitAdi = _kayitAdiKullaniciAdiSifreList[0];
    //   String kullaniciAdi = _kayitAdiKullaniciAdiSifreList[1];
    //   String sifre = _kayitAdiKullaniciAdiSifreList[2];
    //   Kategori yeniKayit = Kategori("");
    //   int? kitapId = await _yerelVeriTabani.createKayit(yeniKayit);
    //   if (kitapId != null) {
    //     setState(() {});
    //   }
    // }
  }

  // Future<void> _kategoriGuncelle(BuildContext contex, int index) async {
  //   Kategori kategori = _kategoriler[index];
  //   List<dynamic>? guncelVeriler = await _kategoriPencereAc(
  //     context,
  //     mevcutKayitAdi: kategori.kategoriAdi,
  //   );
  //   if (guncelVeriler != null && guncelVeriler.length > 0) {
  //     String yeniKategoriAdi = guncelVeriler[0];

  //     if (kategori.kategoriAdi != yeniKayitAdi ||
  //         kayit.kullaniciAdi != yeniKullaniciAdi ||
  //         kayit.sifre != yeniSifre) {
  //       kayit.kayitAdi = yeniKayitAdi;
  //       kayit.kullaniciAdi = yeniKullaniciAdi;
  //       kayit.sifre = yeniSifre;
  //       int guncelleneneSatirSayisi = await _yerelVeriTabani.updateKayit(kayit);
  //       if (guncelleneneSatirSayisi > 0) {
  //         setState(() {});
  //       }
  //     }
  //   }
  // }

  // void _kategoriSil(int index) async {
  // Kayit kayit = _kayitlar[index];
  // int silinenKayit = await _yerelVeriTabani.deleteKayit(kayit);
  // if (silinenKayit > 0) {
  //   setState(() {});
  // }
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
