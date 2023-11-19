
class WorkOrderFormModel {
  final String? id;
  final String turboNo;
  final DateTime tarihWOF;
  final String aracBilgileri;
  final String musteriAdi;
  final int musteriNumarasi;
  final String musteriSikayetleri;
  final String onTespit;
  final String turboyuGetiren;
  final double tasimaUcreti;
  final String teslimAdresi;
  final Map<String, bool> yanindaGelenler;



  Map<String, dynamic> toJson() {
    return {
      "turboNo": turboNo,
      "tarihWOF": tarihWOF,
      "aracBilgileri": aracBilgileri,
      "musteriAd": musteriAdi,
      "musteriNumarasi": musteriNumarasi,
      "musteriSikayetleri": musteriSikayetleri,
      "onTespit": onTespit,
      "turboyuGetiren": turboyuGetiren,
      "tasimaUcreti": tasimaUcreti,
      "teslimAdresi": teslimAdresi,
      "yanindaGelenler": yanindaGelenler,
    };
  }




  WorkOrderFormModel(  {
    this.id,
    this.turboNo = "null",
    required this.tarihWOF,
    this.aracBilgileri = "null",
    this.musteriAdi = "null",
    this.musteriNumarasi = -1,
    this.musteriSikayetleri = "null",
    this.onTespit = "null",
    this.turboyuGetiren = "null",
    this.tasimaUcreti=-1,
    this.teslimAdresi="null",
    required this.yanindaGelenler,
  });
}
