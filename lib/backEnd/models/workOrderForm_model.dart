
class WorkOrderFormModel {
  final String? id;
  final int turboNo;
  final DateTime tarih;
  final String aracBilgileri;
  final String musteriBilgileri;
  final String musteriSikayetleri;
  final String onTespit;
  final String turboyuGetiren;
  final double tasimaUcreti;
  final String teslimAdresi;



  Map<String, dynamic> toJson() {
    return {
      "turboNo": turboNo,
      "tarih": tarih,
      "aracBilgileri": aracBilgileri,
      "musteriBilgileri": musteriBilgileri,
      "musteriSikayetleri": musteriSikayetleri,
      "onTespit": onTespit,
      "turboyuGetiren": turboyuGetiren,
      "tasimaUcreti": tasimaUcreti,
      "teslimAdresi": teslimAdresi,
    };
  }




  WorkOrderFormModel(  {
    this.id,
    this.turboNo = -1,
    required this.tarih,
    this.aracBilgileri = "null",
    this.musteriBilgileri = "null",
    this.musteriSikayetleri = "null",
    this.onTespit = "null",
    this.turboyuGetiren = "null",
    this.tasimaUcreti=-1,
    this.teslimAdresi="null",
  });
}
