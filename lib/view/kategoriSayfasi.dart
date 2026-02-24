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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextButton.icon(
          onPressed: () {
            _kategoriEkle(context);
          },
          icon: Icon(Icons.add),
          label: Text("Kategori ekle"),
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
              _kategoriSil(index);
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

  Future<List<Kategori>> _tumListeyiGetir() async {
    _kategoriler = await _yerelVeriTabani.readTumKategori();
    return _kategoriler;
  }

  Future<void> _kategoriGuncelle(BuildContext contex, int index) async {
    Kategori kategori = _kategoriler[index];
    List<dynamic>? guncelVeriler = await _pencereAc(
      context,
      mevcutKayitAdi: kategori.kategoriAdi,
    );
    if (guncelVeriler != null && guncelVeriler.length > 0) {
      String yeniKategoriAdi = guncelVeriler[0];

      if (kategori.kategoriAdi != yeniKayitAdi ||
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

  void _kategoriSil(int index) async {
    // Kayit kayit = _kayitlar[index];
    // int silinenKayit = await _yerelVeriTabani.deleteKayit(kayit);
    // if (silinenKayit > 0) {
    //   setState(() {});
    // }
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

  void _kategoriEkle(BuildContext context) async {
    _kategoriPencereAc(context);
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
}
