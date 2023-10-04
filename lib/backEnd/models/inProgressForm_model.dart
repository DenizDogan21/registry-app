import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class InProgressFormModel {
  final String? id;
  final int turboNo;
  final DateTime tarih;
  final String aracBilgileri;
  final String musteriBilgileri;
  final String musteriSikayetleri;
  final String tespitEdilen;
  final String yapilanIslemler;
  final String turboImageUrl;


  Map<String, dynamic> toJson() {
    return {
      "turboNo": turboNo,
      "tarih": tarih,
      "aracBilgileri": aracBilgileri,
      "musteriBilgileri": musteriBilgileri,
      "musteriSikayetleri": musteriSikayetleri,
      "tespitEdilen": tespitEdilen,
      "yapilanIslemler": yapilanIslemler,
      "turboImage": turboImageUrl,
    };
  }




  InProgressFormModel( {
    this.id,
    this.turboNo = -1,
    required this.tarih,
    this.aracBilgileri = "null",
    this.musteriBilgileri = "null",
    this.musteriSikayetleri = "null",
    this.tespitEdilen = "null",
    this.yapilanIslemler = "null",
    this.turboImageUrl="null",
  });
}
