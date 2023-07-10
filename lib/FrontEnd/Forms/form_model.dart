

class FormData {
  int id;
  int turboNo;
  DateTime tarih;
  String aracBilgileri;
  String musteriBilgileri;
  String musteriSikayetleri;
  String tespitEdilen;
  String yapilanIslemler;
  // ... add the remaining fields

  // Additional fields



  FormData({
    required this.id,
    required this.turboNo,
    required this.tarih,
    required this.aracBilgileri,
    required this.musteriBilgileri,
    required this.musteriSikayetleri,
    required this.tespitEdilen,
    required this.yapilanIslemler,
    // ... initialize the remaining fields
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'turboNo': turboNo,
      'tarih': tarih.toIso8601String(),
      'aracBilgileri': aracBilgileri,
      'musteriBilgileri': musteriBilgileri,
      'musteriSikayetleri': musteriSikayetleri,
      'tespitEdilen': tespitEdilen,
      'yapilanIslemler': yapilanIslemler,
      // ... convert the remaining fields to a map
    };
  }

  factory FormData.fromMap(Map<String, dynamic> map) {
    return FormData(
      id: map['id'],
      turboNo: map['turboNo'],
      tarih: DateTime.parse(map['tarih']),
      aracBilgileri: map['aracBilgileri'],
      musteriBilgileri: map['musteriBilgileri'],
      musteriSikayetleri: map['musteriSikayetleri'],
      tespitEdilen: map['tespitEdilen'],
      yapilanIslemler: map['yapilanIslemler'],
      // ... create new instances of the remaining fields
    );
  }
}
