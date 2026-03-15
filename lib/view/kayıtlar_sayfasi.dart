import 'package:flutter/material.dart';
import 'package:not_defteri/model/kategoriler.dart';
import 'package:not_defteri/model/kayitlar.dart';
import 'package:not_defteri/view/kategoriSayfasi.dart';
import 'package:not_defteri/view/kayitDetay.dart';

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
  int? secilenKategori;
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
            builder: _buildColumn,
          ),
        ),
      ],
    );
  }

  Widget _buildColumn(BuildContext context, AsyncSnapshot<dynamic> any) {
    //   if (snapshot.connectionState == ConnectionState.waiting) {
    //   return const Center(child: CircularProgressIndicator());
    // }
    final filtrelenmisListe = secilenKategori != null
        ? _kayitlar
        : _kayitlar.where((element) {
            return element.kategoriId == secilenKategori;
          }).toList();
    return Column(
      children: [
        if (_kategoriler.isNotEmpty)
          DropdownButton(
            hint: Text("Kategori Seçiniz"),
            items: _kategoriler.map((Kategori element) {
              return DropdownMenuItem(
                value: element.id,
                child: Text(element.kategoriAdi),
              );
            }).toList(),
            onChanged: (value) {
              secilenKategori = value;
              setState(() {
                
              });
              print(value);
            },
          )
        else
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Kategori bulunamadı"),
          ),
        Expanded(
          child: ListView.builder(
            itemBuilder: _buildListItem,
            itemCount: filtrelenmisListe.length,
          ),
        ),
      ],
    );
  }

  // Widget _buildListView(BuildContext context, AsyncSnapshot<dynamic> any) {
  //   return ListView.builder(
  //     itemBuilder: _buildListItem,
  //     itemCount: _kayitlar.length,
  //   );
  // }

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
      onTap: () {
        _kayitDetaySayfasinaGit(_kayitlar[index]);
      },
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
    List<dynamic>? _kayitAdiKullaniciAdiSifreListKategoriId = await _pencereAc(
      context,
    );
    if (_kayitAdiKullaniciAdiSifreListKategoriId != null)
      _kayitAdiKullaniciAdiSifreListKategoriId.map((value) {
        print(value);
      });
    if (_kayitAdiKullaniciAdiSifreListKategoriId != null &&
        _kayitAdiKullaniciAdiSifreListKategoriId.length > 2) {
      String kayitAdi = _kayitAdiKullaniciAdiSifreListKategoriId[0];
      String kullaniciAdi = _kayitAdiKullaniciAdiSifreListKategoriId[1];
      String sifre = _kayitAdiKullaniciAdiSifreListKategoriId[2];
      int kategoriId = _kayitAdiKullaniciAdiSifreListKategoriId[3];

      Kayit yeniKayit = Kayit(
        kayitAdi,
        kullaniciAdi,
        sifre,
        DateTime.now(),
        kategoriId,
      );
      int? kitapId = await _yerelVeriTabani.createKayit(yeniKayit);
      if (kitapId != null) {
        setState(() {});
      }
    }
  }

  Future<bool> _listeleriGetir() async {
    // Future.wait her iki sorguyu aynı anda başlatır ve bitmelerini bekler.
    await Future.wait([
      _yerelVeriTabani.readTumKayit().then((gelenKayitlar) {
        _kayitlar = gelenKayitlar;
      }),
      _yerelVeriTabani.readTumKategori().then((gelenKategoriler) {
        _kategoriler = gelenKategoriler;
      }),
    ]);
    return true;
  }

  Future<void> _kayitGuncelle(BuildContext contex, int index) async {
    Kayit kayit = _kayitlar[index];
    List<dynamic>? guncelVeriler = await _pencereAc(
      context,
      mevcutKayitAdi: kayit.kayitAdi,
      mevcutKullaniciAdi: kayit.kullaniciAdi,
      mevcutSifre: kayit.sifre,
      mevcutKategoriId: kayit.kategoriId,
    );
    if (guncelVeriler != null && guncelVeriler.length > 3) {
      String yeniKayitAdi = guncelVeriler[0];
      String yeniKullaniciAdi = guncelVeriler[1];
      String yeniSifre = guncelVeriler[2];
      int yenikategoriId = guncelVeriler[3];
      if (kayit.kayitAdi != yeniKayitAdi ||
          kayit.kullaniciAdi != yeniKullaniciAdi ||
          kayit.sifre != yeniSifre ||
          kayit.kategoriId != yenikategoriId) {
        kayit.kayitAdi = yeniKayitAdi;
        kayit.kullaniciAdi = yeniKullaniciAdi;
        kayit.sifre = yeniSifre;
        kayit.kategoriId = yenikategoriId;
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
    int mevcutKategoriId = 1,
  }) async {
    print("mevcutKategoriId $mevcutKategoriId");
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
              DropdownButton<int>(
                value: mevcutKategoriId,
                items: _kategoriler.map((Kategori a) {
                  return DropdownMenuItem<int>(
                    child: Text(a.kategoriAdi),
                    value: a.id,
                  );
                }).toList(),
                onChanged: (value) {
                  mevcutKategoriId = value ?? 0;
                },
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
                        mevcutKategoriId,
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
    Navigator.push(context, sayfayolu).then((gelenVeri) {
      if (gelenVeri > 0) {
        setState(() {});
      }
      ;
    });
  }

  String _kategoriAdi(int index) {
    int? kategoriId;

    print(_kategoriler);
    int a = _kayitlar[index].kategoriId.toInt(); //index =0 ,kategoriId=3
    print(a);
    if (_kategoriler.isEmpty) return "Genel";
    try {
      kategoriId = _kayitlar[index].kategoriId.toInt();
      print(kategoriId);
      return _kategoriler
          .firstWhere((value) => value.id == kategoriId)
          .kategoriAdi;
    } catch (e) {
      print("hata");
    }
    return "Genel";
  }

  void _kayitDetaySayfasinaGit(Kayit kayit) {
    MaterialPageRoute sayfaYolu = MaterialPageRoute(
      builder: (context) {
        return KayitDetay(kayit);
      },
    );
    Navigator.push(context, sayfaYolu);
  }
}
