class Kayit {
  int? id;
  String kayitAdi;
  DateTime olusturulmaTarihi;
  String kullaniciAdi;
  String sifre;

  Kayit(this.kayitAdi, this.kullaniciAdi, this.sifre,this.olusturulmaTarihi);

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "kayitAdi": kayitAdi,
      "olusturulmaTarihi": olusturulmaTarihi.millisecondsSinceEpoch,
      "kullaniciAdi": kullaniciAdi,
      "sifre": sifre,

      
    };
  }
  Kayit.fromMap(Map<String,dynamic> map): 
    id=map['id'],
    kayitAdi=map["kayitAdi"],
    olusturulmaTarihi=DateTime.fromMillisecondsSinceEpoch(map["olusturulmaTarihi"] as int),
    kullaniciAdi=map ["kullaniciAdi"],
    sifre=map ["sifre"]
 ; 
}
