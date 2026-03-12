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
  int guncellenenSatirSayisi = 0;

  @override
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.pop(context, guncellenenSatirSayisi);
      },
      child: Scaffold(
        appBar: _buildAppBar(),
        body: _buildBody(context),
        floatingActionButton: _buildKayitEkleFab(context),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(title: Center(child: Text("Kategoriler")));
  }

  Widget _buildBody(BuildContext context) {
    return FutureBuilder(future: _tumListeyiGetir(), builder: _buildListView);
  }

  Widget _buildListView(BuildContext context, AsyncSnapshot<dynamic> snapShot) {
    return ListView.builder(
      itemBuilder: _buildListItem,
      itemCount: _kategoriler.length,
    );
  }

  Widget _buildListItem(BuildContext context, int index) {
    return ListTile(
      title: Text(_kategoriler[index].kategoriAdi.toString()),
      leading: Text(_kategoriler[index].id.toString()),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () {
              _kategoriGuncelle(context, index);
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

  void _kategoriGuncelle(BuildContext context, int index) async {
    print(" kategori GÜncelle index $index ");
    Kategori kategori = _kategoriler[index];
    print("${kategori.kategoriAdi}");
    String? yenikategoriAd = await _kategoriPencereAc(
      context,
      mevcutKategoriAdi: _kategoriler[index].kategoriAdi,
    );
    print("yeni kategoriAdi $yenikategoriAd");
    if (yenikategoriAd != null) {
      kategori.kategoriAdi = yenikategoriAd;
      guncellenenSatirSayisi = await _yerelVeriTabani.updateKategori(kategori);
      print("güncellenenSatir sayisi KategoriAdi:$guncellenenSatirSayisi");
      if (guncellenenSatirSayisi > 0) setState(() {});
    }
  }

  void _kategoriSil(int index) async {
    Kategori kategori = _kategoriler[index];
    int silinenSatir = await _yerelVeriTabani.deleteKategori(kategori);
    if (silinenSatir > 0) {
      setState(() {});
    }
  }

  Future<String?> _kategoriPencereAc(
    BuildContext context, {
    String mevcutKategoriAdi = " ",
  }) async {
    TextEditingController _kategoriAdiControler = TextEditingController(
      text: mevcutKategoriAdi,
    );
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
                controller: _kategoriAdiControler,
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
