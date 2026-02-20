class Kayit {
  int? id;
  String kayitAdi;
  DateTime? olusturulmaTarihi;
  String kullaniciAdi;
  String sifre;

  Kayit(this.kayitAdi, this.kullaniciAdi, this.sifre);

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "kayitAdi": kayitAdi,
      "olusturulmaTarihi": olusturulmaTarihi,
      "kullaniciAdi": kullaniciAdi,
      "sifre": sifre,
    };
  }
}
