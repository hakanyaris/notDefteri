import 'dart:async';

import 'package:not_defteri/model/kayitlar.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class YerelVeriTabani {
  YerelVeriTabani._privateConstructur();

  static final YerelVeriTabani _nesne = YerelVeriTabani._privateConstructur();

  factory YerelVeriTabani() {
    return _nesne;
  }
  Database? _veritabani;
  String _kayitlarTabloAdi = "kayitlar";
  String _idKayitlar = "id";
  String _kayitAdiKayitlar = "kayitAdi";
  String _olusturulmaTarihiKayitlar = "olusturulmaTarihi";
  String _kullaniciAdiKayitlar = "kullaniciAdi";
  String _sifreKayitlar = "kullaniciAdi";

  String _kategorilerTabloAdi = "kategoriler";
  String _idKategoriler = "id";
  String _karegoriAdiKategoriler = "kategoriAdi";
  String _kayitIdKategoriler = "kategoriId";

  Future<Database?> _veriTabaniniGetir() async {
    if (_veritabani == null) {
      String dosyaYolu = await getDatabasesPath();
      String veriTabaniYolu = join(dosyaYolu, "notDefteri.db");

      _veritabani = await openDatabase(
        veriTabaniYolu,
        version: 1,
        onCreate: _tabloOlustur,
      );
    }
    return _veritabani;
  }

  FutureOr<void> _tabloOlustur(Database db, int version) async {
    await db.execute(""" 
     CREATE TABLE $_kayitlarTabloAdi(
     $_idKayitlar INTEGER NOT NULL UNIQUE PRIMARY KEY AUTOINCREMENT,
     $_kayitAdiKayitlar INTEGER NOT NULL,
     $_olusturulmaTarihiKayitlar  INTEGER,
     $_kullaniciAdiKayitlar TEXT ,
     $_sifreKayitlar TEXT
     )
    """);

    await db.execute("""
CREATE TABLE $_kategorilerTabloAdi (
	$_idKategoriler	INTEGER NOT NULL UNIQUE PRIMARY KEY AUTOINCREMENT,
	$_kayitIdKategoriler	INTEGER NOT NULL,
  $_karegoriAdiKategoriler TEXT NOT NULL,
  FOREIGN KEY("$_kayitIdKategoriler") REFERENCES "$_kayitlarTabloAdi" ("$_idKayitlar") ON UPDATE CASCADE ON DELETE CASCADE
);
""");
  }

  Future<int?> createKayit(Kayit kayit) async {
    Database? db = await _veriTabaniniGetir();
    if (db != null)
      return await db.insert(_kayitlarTabloAdi, kayit.toMap());
    else
      return -1;
  }
}
