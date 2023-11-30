import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../Models/inProgressForm_model.dart';

class InProgressFormRepo extends GetxController {
  static InProgressFormRepo get instance => Get.find();
  final _db = FirebaseFirestore.instance;


  createInProgressForm(InProgressFormModel inProgressForm) async {
    final user = FirebaseAuth.instance.currentUser;
      final userId = user?.email;

      // Reference to the new collection "inProgressForms"
      final inProgressFormsCollection = _db.collection("inProgressForms");

      final formJson = inProgressForm.toJson();

      await inProgressFormsCollection.add({
        'yukleyenKullanici': userId, // Associate the form with the user
        ...formJson,
      });

      Get.snackbar("Form Ekleme Başarılı", "Oluşturuldu", backgroundColor: Colors.green);
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
            tarihIPF: (formData['tarihIPF'] as Timestamp?)?.toDate() ?? DateTime.now(),
            tespitEdilen: (formData['tespitEdilen'] as String?) ?? "",
            yapilanIslemler: (formData['yapilanIslemler'] as String?) ?? "",
            turboImageUrl: (formData['turboImage'] as String?) ?? "",
            katricImageUrl: (formData['katricImage'] as String?) ?? "",
            balansImageUrl: (formData['balansImage'] as String?) ?? "",
            egeTurboNo: (formData['egeTurboNo'] as int) ?? 0,

            turboNo: (formData['turboNo'] as String?) ?? "",
            tarihWOF: (formData['tarihWOF'] as Timestamp?)?.toDate() ?? DateTime.now(),
            aracBilgileri: (formData['aracBilgileri'] as String?) ?? "",
            aracKm: (formData['aracKm'] as int) ?? 0,
            aracPlaka: (formData['aracPlaka'] as String?) ?? "",
            musteriAdi: (formData['musteriAdi'] as String?) ?? "",
            musteriNumarasi: (formData['musteriNumarasi'] as int) ?? 0,
            musteriSikayetleri: (formData['musteriSikayetleri'] as String?) ?? "",
            onTespit: (formData['onTespit'] as String?) ?? "",
            turboyuGetiren: (formData['turboyuGetiren'] as String?) ?? "",
            tasimaUcreti: (formData['tasimaUcreti'] as double?) ?? 0,
            teslimAdresi: (formData['teslimAdresi'] as String?) ?? "",
            yanindaGelenler: Map<String, bool>.from(formData['yanindaGelenler'] ?? {},),
            id: formDoc.id,
          );
        }).toList();

        return forms;
      }

    return [];
  }


  Future<void> updateInProgressForm(String formId, InProgressFormModel updatedForm) async {
    try {
      final formRef = _db.collection("inProgressForms").doc(formId);
      await formRef.update(updatedForm.toJson());
      Get.snackbar("Update Successful", "Form updated successfully", backgroundColor: Colors.green);
    } catch (e) {
      Get.snackbar("Update Failed", "Failed to update form: $e", backgroundColor: Colors.red);
    }
  }

}
