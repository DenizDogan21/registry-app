
class WorkOrderFormModel {
  final String? id;
  final String turboNo;
  final DateTime tarihWOF;
  final String aracBilgileri;
  final int aracKm;
  final String aracPlaka;
  final String musteriAdi;
  final int musteriNumarasi;
  final String musteriSikayetleri;
  final String onTespit;
  final String turboyuGetiren;
  final double tasimaUcreti;
  final String teslimAdresi;
  final Map<String, bool> yanindaGelenler;
  final String kabulDurumu;



  Map<String, dynamic> toJson() {
    return {
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




  WorkOrderFormModel(  {
    this.id,
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
    this.tasimaUcreti=-1,
    this.teslimAdresi="null",
    required this.yanindaGelenler,
    this.kabulDurumu="null",
  });
}