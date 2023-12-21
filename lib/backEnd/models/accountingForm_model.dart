
class AccountingFormModel {
  String? id;
  double tamirUcreti;
  String odemeSekli;
  int taksitSayisi;
  String muhasebeNotlari;

  DateTime tarihIPF;
  String tespitEdilen;
  String yapilanIslemler;
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
  String kabulDurumu;


  Map<String, dynamic> toJson() {
    return {
      "tamirUcreti": tamirUcreti,
      "odemeSekli": odemeSekli,
      "taksitSayisi": taksitSayisi,
      "muhasebeNotlari": muhasebeNotlari,

      "tarihIPF": tarihIPF,
      "tespitEdilen": tespitEdilen,
      "yapilanIslemler": yapilanIslemler,
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
      "kabulDurumu": kabulDurumu,
    };
  }




  AccountingFormModel( {
    this.id,
    this.tamirUcreti= -1,
    this.odemeSekli= "null",
    this.taksitSayisi= -1,
    this.muhasebeNotlari= "null",

    required this.tarihIPF,
    this.tespitEdilen = "null",
    this.yapilanIslemler = "null",
    this.egeTurboNo= -1,

    this.turboNo = "null",
    required this.tarihWOF,
    this.aracBilgileri = "null",
    this.aracKm=-1,
    this.aracPlaka="null",
    this.musteriAdi = "null",
    this.musteriNumarasi = -1,
    this.musteriSikayetleri = "null",
    this.onTespit = "null",
    this.turboyuGetiren = "null",
    this.tasimaUcreti = -1,
    this.teslimAdresi = "null",
    required this.yanindaGelenler,
    this.kabulDurumu = "null",
  });


}

