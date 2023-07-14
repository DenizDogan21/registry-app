import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../Models/inProgressForm_model.dart';


class InProgressFormRepo extends GetxController {
  static InProgressFormRepo get instance => Get.find();
  final _db = FirebaseFirestore.instance;


  createInProgressForm(InProgressFormModel inProgressForm) async {
    await _db
        .collection("inProgressForm") // Corrected collection name
        .doc()
        .set(inProgressForm.toJson())
        .whenComplete(() => Get.snackbar("Form Ekleme Başarılı", "Oluşturuldu"));
  }


  Future<List<InProgressFormModel>> getInProgressForms() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('inProgressForm')
        .get();

    final inProgressForms = querySnapshot.docs.map((doc) {
      final data = doc.data();
      return InProgressFormModel(
        turboNo: data['turboNo'] as int? ?? 0, // Provide a fallback value if null
        tarih: (data['tarih'] as Timestamp?)?.toDate() ?? DateTime.now(), // Provide a fallback value if null
        aracBilgileri: data['aracBilgileri'] as String? ?? "",
        musteriBilgileri: data['musteriBilgileri'] as String? ?? "",
        musteriSikayetleri: data['musteriSikayetleri'] as String? ?? "",
        tespitEdilen: data['tespitEdilen'] as String? ?? "",
        yapilanIslemler: data['yapilanIslemler'] as String? ?? "",
      );
    }).toList();

    return inProgressForms;
  }




}