class InProgressFormModel {
  String? id;
  DateTime tarihIPF;
  String tespitEdilen;
  String yapilanIslemler;
  String turboImageUrl;
  String katricImageUrl;
  String balansImageUrl;
  List<FlowPhoto> flowPhotos;
  int egeTurboNo;

  String turboyuGetiren;
  double tasimaUcreti;
  String teslimAdresi;
  String turboNo;
  Map<String, bool> yanindaGelenler;
  DateTime tarihWOF;
  String aracBilgileri;
  int aracKm;
  String aracPlaka;
  String musteriAdi;
  int musteriNumarasi;
  String musteriSikayetleri;
  String onTespit;


  Map<String, dynamic> toJson() {
    return {
      "tarihIPF": tarihIPF,
      "tespitEdilen": tespitEdilen,
      "yapilanIslemler": yapilanIslemler,
      "turboImage": turboImageUrl,
      "katricImage": katricImageUrl,
      "balansImage": balansImageUrl,
      "egeTurboNo": egeTurboNo,

      "turboNo": turboNo,
      "tarihWOF": tarihWOF,
      "aracBilgileri": aracBilgileri,
      "aracKm": aracKm,
      "aracPlaka": aracPlaka,
      "musteriAdi": musteriAdi,
      "musteriNumarasi": musteriNumarasi,
      "musteriSikayetleri": musteriSikayetleri,
      "onTespit": onTespit,
      "turboyuGetiren": turboyuGetiren,
      "tasimaUcreti": tasimaUcreti,
      "teslimAdresi": teslimAdresi,
      "yanindaGelenler": yanindaGelenler,
      "flowPhotos": flowPhotos.map((photo) => photo.toJson()).toList(), // Add flowPhotos to the JSON serialization
    };
  }

  InProgressFormModel({
    this.id,
    required this.tarihIPF,
    this.tespitEdilen = "null",
    this.yapilanIslemler = "null",
    this.turboImageUrl = "null",
    this.katricImageUrl = "null",
    this.balansImageUrl = "null",
    required this.flowPhotos,
    this.egeTurboNo = 0,


    this.turboNo = "null",
    required this.tarihWOF,
    this.aracBilgileri = "null",
    this.aracKm = -1,
    this.aracPlaka = "null",
    this.musteriAdi = "null",
    this.musteriNumarasi = -1,
    this.musteriSikayetleri = "null",
    this.onTespit = "null",
    this.turboyuGetiren = "null",
    this.tasimaUcreti = -1,
    this.teslimAdresi = "null",
    required this.yanindaGelenler,
    // Initialize flowPhotos as an empty list
  });

  void setImageUrl(String imageType, String url) {
    if (imageType == 'turbo') {
      turboImageUrl = url;
    } else if (imageType == 'katric') {
      katricImageUrl = url;
    } else if (imageType == 'balans') {
      balansImageUrl = url;
    }
  }

  String? getImageUrl(String imageType) {
    if (imageType == 'turbo') {
      return turboImageUrl;
    } else if (imageType == 'katric') {
      return katricImageUrl;
    } else if (imageType == 'balans') {
      return balansImageUrl;
    }
    return null;
  }
}

class FlowPhoto {
  String flowImageUrl;
  String flowNotes;

  FlowPhoto({
    required this.flowImageUrl,
    required this.flowNotes,
  });

  Map<String, dynamic> toJson() {
    return {
      "flowImageUrl": flowImageUrl,
      "flowNotes": flowNotes,
    };
  }
}