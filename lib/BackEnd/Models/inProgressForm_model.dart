class InProgressFormModel {
  final String? id;
  final int turboNo;
  final DateTime tarih;
  final String aracBilgileri;
  final String musteriBilgileri;
  final String musteriSikayetleri;
  final String tespitEdilen;
  final String yapilanIslemler;

  Map<String, dynamic> toJson() {
    return {
      "turboNo": turboNo,
      "tarih": tarih,
      "aracBilgileri": aracBilgileri,
      "musteriBilgileri": musteriBilgileri,
      "musteriSikayetleri": musteriSikayetleri,
      "tespitEdilen": tespitEdilen,
      "yapilanIslemler": yapilanIslemler,
    };
  }

  const InProgressFormModel({
    this.id,
    required this.turboNo,
    required this.tarih,
    required this.aracBilgileri,
    required this.musteriBilgileri,
    required this.musteriSikayetleri,
    required this.tespitEdilen,
    required this.yapilanIslemler,
  });

}