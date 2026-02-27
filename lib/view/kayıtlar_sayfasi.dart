import 'package:flutter/material.dart';
import 'package:not_defteri/model/kategoriler.dart';
import 'package:not_defteri/model/kayitlar.dart';
import 'package:not_defteri/view/kategoriSayfasi.dart';

import 'package:not_defteri/yerel_veri_tabani.dart';

class KayitlarSayfasi extends StatefulWidget {
  const KayitlarSayfasi({super.key});

  @override
  State<KayitlarSayfasi> createState() => _KayitlarSayfasiState();
}

class _KayitlarSayfasiState extends State<KayitlarSayfasi> {
  YerelVeriTabani _yerelVeriTabani = YerelVeriTabani();
  List<Kayit> _kayitlar = [];
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextButton.icon(
          onPressed: () {
            _kategoriSayfasinaGit(context);
          },
          icon: Icon(Icons.add),
          label: Text("Kategori Sayfasına Git"),
        ),
        Expanded(
          child: FutureBuilder(
            future: _listeleriGetir(),
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

      leading: Text(_kategoriAdi(index)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () {
              _kayitGuncelle(context, index);
            },
            icon: Icon(Icons.edit_outlined),
          ),
          IconButton(
            onPressed: () {
              _kayitSil(index);
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
      Kayit yeniKayit = Kayit(kayitAdi, kullaniciAdi, sifre, DateTime.now(), 0);
      int? kitapId = await _yerelVeriTabani.createKayit(yeniKayit);
      if (kitapId != null) {
        setState(() {});
      }
    }
  }

  Future<void> _listeleriGetir() async {
    // Future.wait her iki sorguyu aynı anda başlatır ve bitmelerini bekler.
    await Future.wait([
      _yerelVeriTabani.readTumKayit().then((gelenKayitlar) {
        _kayitlar = gelenKayitlar;
      }),
      _yerelVeriTabani.readTumKategori().then((gelenKategoriler) {
        _kategoriler = gelenKategoriler;
      }),
    ]);
  }

  Future<void> _kayitGuncelle(BuildContext contex, int index) async {
    Kayit kayit = _kayitlar[index];
    List<dynamic>? guncelVeriler = await _pencereAc(
      context,
      mevcutKayitAdi: kayit.kayitAdi,
      mevcutKullaniciAdi: kayit.kullaniciAdi,
      mevcutSifre: kayit.sifre,
    );
    if (guncelVeriler != null && guncelVeriler.length > 2) {
      String yeniKayitAdi = guncelVeriler[0];
      String yeniKullaniciAdi = guncelVeriler[1];
      String yeniSifre = guncelVeriler[2];
      if (kayit.kayitAdi != yeniKayitAdi ||
          kayit.kullaniciAdi != yeniKullaniciAdi ||
          kayit.sifre != yeniSifre) {
        kayit.kayitAdi = yeniKayitAdi;
        kayit.kullaniciAdi = yeniKullaniciAdi;
        kayit.sifre = yeniSifre;
        int guncelleneneSatirSayisi = await _yerelVeriTabani.updateKayit(kayit);
        if (guncelleneneSatirSayisi > 0) {
          setState(() {});
        }
      }
    }
  }

  void _kayitSil(int index) async {
    Kayit kayit = _kayitlar[index];
    int silinenKayit = await _yerelVeriTabani.deleteKayit(kayit);
    if (silinenKayit > 0) {
      setState(() {});
    }
  }

  Future<List<dynamic>?> _pencereAc(
    BuildContext context, {
    String mevcutKayitAdi = "",
    String mevcutKullaniciAdi = "",
    String mevcutSifre = "",
  }) async {
    TextEditingController controllerKullaniciAdi = TextEditingController(
      text: mevcutKullaniciAdi,
    );
    TextEditingController controllerSifre = TextEditingController(
      text: mevcutSifre,
    );
    TextEditingController controllerKayitAdi = TextEditingController(
      text: mevcutKayitAdi,
    );

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

  void _kategoriSayfasinaGit(BuildContext context) async {
    MaterialPageRoute sayfayolu = MaterialPageRoute(
      builder: (context) {
        return Kategorisayfasi();
      },
    );
    Navigator.push(context, sayfayolu);
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
            ],
          ),
        );
      },
    );
  }

  String _kategoriAdi(int index) {
    if (_kategoriler.isEmpty) return "Genel";
    int kategoriId = _kayitlar[index].kategoriId.toInt() + 1;
    return _kategoriler
        .firstWhere((value) => value.id == kategoriId)
        .kategoriAdi;
  }
}
