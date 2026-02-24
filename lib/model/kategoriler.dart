class Kategori {
  int? id;
  String kategoriAdi;
  int kayitId;
  Kategori(this.kategoriAdi, this.kayitId);

  Map<String, dynamic> toMap() {
    return {"id": id, "kategoriAdi": kategoriAdi, "kayitId": kayitId};
  }

  Kategori.fromMap(Map<String, dynamic> map)
    : id = map["id"],
      kategoriAdi = map["kategoriAdi"],
      kayitId = map["kayitAdi"];
}
