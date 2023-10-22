import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../Models/inProgressForm_model.dart';

class InProgressFormRepo extends GetxController {
  static InProgressFormRepo get instance => Get.find();
  final _db = FirebaseFirestore.instance;


  createInProgressForm(InProgressFormModel inProgressForm) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userId = user.uid;

      // Reference to the new collection "inProgressForms"
      final inProgressFormsCollection = _db.collection("inProgressForms");

      final formJson = inProgressForm.toJson();

      await inProgressFormsCollection.add({
        'userId': userId, // Associate the form with the user
        ...formJson,
      });

      Get.snackbar("Form Ekleme Başarılı", "Oluşturuldu");
    } else {
      // Handle case where the user is not signed in
      // Display an error message or redirect to the login page
    }
  }

  Future<List<InProgressFormModel>> getInProgressForms() async {
    final user = FirebaseAuth.instance.currentUser;

      // Reference to the "inProgressForms" collection
      final inProgressFormsCollection = _db.collection("inProgressForms");

      final QuerySnapshot formQuery = await inProgressFormsCollection.get();

      final List<QueryDocumentSnapshot> formDocs = formQuery.docs;

      if (formDocs.isNotEmpty) {
        final forms = formDocs.map((formDoc) {
          final formData = formDoc.data() as Map<String, dynamic>; // Explicit casting
          return InProgressFormModel(
            turboNo: (formData['turboNo'] as int?) ?? 0,
            tarih: (formData['tarih'] as Timestamp?)?.toDate() ?? DateTime.now(),
            aracBilgileri: (formData['aracBilgileri'] as String?) ?? "",
            musteriBilgileri: (formData['musteriBilgileri'] as String?) ?? "",
            musteriSikayetleri: (formData['musteriSikayetleri'] as String?) ?? "",
            tespitEdilen: (formData['tespitEdilen'] as String?) ?? "",
            yapilanIslemler: (formData['yapilanIslemler'] as String?) ?? "",
            turboImageUrl: (formData['turboImage'] as String?) ?? "",
            katricImageUrl: (formData['katricImage'] as String?) ?? "",
            balansImageUrl: (formData['balansImage'] as String?) ?? "",
          );
        }).toList();

        return forms;
      }

    return [];
  }


}
