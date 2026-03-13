import 'package:flutter/material.dart';
import 'package:not_defteri/model/kayitlar.dart';
import 'package:flutter/services.dart';

class KayitDetay extends StatefulWidget {
  final Kayit kayit;
  KayitDetay(Kayit this.kayit, {super.key});

  @override
  State<KayitDetay> createState() => _KayitDetayState();
}

class _KayitDetayState extends State<KayitDetay> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: appBar(), body: _buildBody());
  }

  AppBar appBar() {
    return AppBar(title: Text(widget.kayit.kayitAdi.toString()));
  }

  Widget? _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(flex: 1, child: Text("Kullanici Adı :")),
              Expanded(flex: 3, child: Text("${widget.kayit.kullaniciAdi}")),
            ],
          ),
          SizedBox(height: 3),
          Row(
            children: [
              Text("Şifre :"),
              Text("${widget.kayit.sifre}"),
              TextButton(
                onPressed: () {
                  // Kopyalama işlemi burada gerçekleşiyor
                  Clipboard.setData(
                    ClipboardData(text: widget.kayit.sifre),
                  ).then((_) {
                    // Kullanıcıya bilgi vermek her zaman iyi bir deneyimdir
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Metin panoya kopyalandı!")),
                    );
                  });
                },
                child: Text("Kopyala"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
