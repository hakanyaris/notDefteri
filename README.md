# not_defteri

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
1. Ayarlar Menüsünden (En Kolay Yol)
Ayarları Aç: Klavyenden Ctrl + , (virgül) tuşlarına bas (Mac kullanıyorsan Cmd + ,).
Arama Çubuğuna Yaz: Üstteki arama kutusuna "bracket pairs" yaz.
Ayarı Değiştir: Listelenen sonuçlar arasından Editor > Guides: Bracket Pairs seçeneğini bul.
Aktif Et: Buradaki açılır menüden "active" (veya bazı sürümlerde kutucuğu işaretleyerek true) seçeneğini seç.

2. DevTools'u Açın
VS Code üzerinden DevTools'u başlatmanın iki hızlı yolu vardır:

Komut Paleti: Ctrl + Shift + P (Mac'te Cmd + Shift + P) tuşlarına basın ve "Dart: Open DevTools" yazıp Enter'a basın.

=> String _kategoriAdi(int index) DÜZENLENDİ , kategoriler ana listede görüntülendi,kategori ekle ve kategori sil yaz, ana ekranda kategori seçme dropdown koy 

1. Güncel Verileri Çek
Öncelikle sunucudaki en son değişiklikleri bilgisayarına "indir" ama henüz birleştirme (merge) yapma:

Bash
git fetch --all
2. Üzerine Yazma İşlemini Başlat
Şu anki dalını (branch), sunucudaki dalın kopyası olacak şekilde sıfırla. Eğer ana dalda çalışıyorsan (genelde main veya master olur):

Bash
git reset --hard origin/master

Bash
flutter pub run build_runner build --delete-conflicting-outputs
Bu komut, eski ve hatalı oluşturulmuş dosyaları siler ve her şeyi sıfırdan temiz bir şekilde bağlar.


Terminali açın ve şu komutu çalıştırın. Bu komut, paketi projenizin "geliştirme bağımlılıkları" (dev_dependencies) kısmına ekleyecektir:

Bash
dart run build_runner build