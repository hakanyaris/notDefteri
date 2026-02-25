import 'dart:async';
import 'dart:ffi';

import 'package:not_defteri/model/kategoriler.dart';
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
  String _sifreKayitlar = "sifre";
  String _kategoriIdKayitlar = "kategoriId";

  String _kategorilerTabloAdi = "kategoriler";
  String _idKategoriler = "id";
  String _karegoriAdiKategoriler = "kategoriAdi";

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
     $_kayitAdiKayitlar TEXT NOT NULL,
     $_olusturulmaTarihiKayitlar  INTEGER,
     $_kullaniciAdiKayitlar TEXT ,
     $_sifreKayitlar TEXT,
     $_kategoriIdKayitlar INTEGER DEFAULT 0,
      FOREIGN KEY("$_kategoriIdKayitlar") REFERENCES "$_kategorilerTabloAdi" ("$_idKategoriler") ON UPDATE CASCADE ON DELETE CASCADE
     )
    """);

    await db.execute("""
CREATE TABLE $_kategorilerTabloAdi (
	$_idKategoriler	INTEGER NOT NULL UNIQUE PRIMARY KEY AUTOINCREMENT,
  $_karegoriAdiKategoriler TEXT NOT NULL
 
);
""");
  }

  Future<int?> createKayit(Kayit kayit) async {
    Database? db = await _veriTabaniniGetir();
    print("veritabanına giden map:  ${kayit.toMap()} ");
    if (db != null) {
      return await db.insert(_kayitlarTabloAdi, kayit.toMap());
    } else
      return -1;
  }

  Future<List<Kayit>> readTumKayit() async {
    List<Kayit> kayitlar = [];
    Database? db = await _veriTabaniniGetir();
    if (db != null) {
      List<Map<String, dynamic>> mapListesi = await db.query(_kayitlarTabloAdi);

      for (Map<String, dynamic> item in mapListesi) {
        Kayit k = Kayit.fromMap(item);
        kayitlar.add(k);
      }
    }
    return kayitlar;
  }

  Future<int> updateKayit(Kayit kayit) async {
    Database? db = await _veriTabaniniGetir();
    if (db != null) {
      return await db.update(
        _kayitlarTabloAdi,
        kayit.toMap(),
        where: "$_idKayitlar = ?",
        whereArgs: [kayit.id],
      );
    }
    return 0;
  }

  Future<int> deleteKayit(Kayit kayit) async {
    Database? db = await _veriTabaniniGetir();
    if (db != null) {
      return await db.delete(
        _kayitlarTabloAdi,
        where: "$_idKayitlar = ?",
        whereArgs: [kayit.id],
      );
    } else
      return 0;
  }

  //===========KATEGORİ İŞLEMLERİ===================================================================

  Future<int?> createKategori(Kategori kategori) async {
    Database? db = await _veriTabaniniGetir();
    print("veritabanına giden map:  ${kategori.toMap()} ");
    if (db != null) {
      return await db.insert(_kategorilerTabloAdi, kategori.toMap());
    } else
      return -1;
  }

  Future<List<Kategori>> readTumKategori() async {
    List<Kategori> kategoriler = [];
    Database? db = await _veriTabaniniGetir();
    if (db != null) {
      List<Map<String, dynamic>> mapListesi = await db.query(
        _kategorilerTabloAdi,
      );

      for (Map<String, dynamic> item in mapListesi) {
        Kategori k = Kategori.fromMap(item);
        kategoriler.add(k);
      }
    }
    return kategoriler;
  }
}
