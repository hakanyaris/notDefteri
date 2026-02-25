class Kategori {
  int? id;
  String kategoriAdi;
  
  Kategori(this.kategoriAdi, );

  Map<String, dynamic> toMap() {
    return {"id": id, "kategoriAdi": kategoriAdi, };
  }

  Kategori.fromMap(Map<String, dynamic> map)
    : id = map["id"],
      kategoriAdi = map["kategoriAdi"];
      
}
