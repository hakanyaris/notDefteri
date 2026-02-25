import 'package:not_defteri/model/kategoriler.dart';

class Kayit {
  Kayit(
    this.kayitAdi,
    this.kullaniciAdi,
    this.sifre,
    this.olusturulmaTarihi,
    this.kategoriId,
  );

  Kayit.fromMap(Map<String, dynamic> map)
    : id = map['id'],
      kayitAdi = map["kayitAdi"],
      olusturulmaTarihi = DateTime.fromMillisecondsSinceEpoch(
        map["olusturulmaTarihi"] as int,
      ),
      kullaniciAdi = map["kullaniciAdi"],
      sifre = map["sifre"],
      kategoriId = map["kategoriId"] ?? 0;

  int? id;
  int kategoriId;
  String kayitAdi;
  String kullaniciAdi;
  DateTime olusturulmaTarihi;
  String sifre;

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "kayitAdi": kayitAdi,
      "olusturulmaTarihi": olusturulmaTarihi.millisecondsSinceEpoch,
      "kullaniciAdi": kullaniciAdi,
      "sifre": sifre,
      "kategoriId": kategoriId,
    };
  }
}
