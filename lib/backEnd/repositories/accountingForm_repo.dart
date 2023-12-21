import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../models/accountingForm_model.dart';

class AccountingFormRepo extends GetxController {
  static AccountingFormRepo get instance => Get.find();
  final _db = FirebaseFirestore.instance;


  createAccountingForm(AccountingFormModel accountingForm) async {
    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.email;

    // Reference to the new collection "accountingForms"
    final accountingFormsCollection = _db.collection("accountingForms");

    final formJson = accountingForm.toJson();

    await accountingFormsCollection.add({
      'yukleyenKullanici': userId, // Associate the form with the user
      ...formJson,
    });

    Get.snackbar("Form Ekleme Başarılı", "Oluşturuldu", backgroundColor: Colors.green);
  }

  Future<List<AccountingFormModel>> getAccountingForms() async {
    final user = FirebaseAuth.instance.currentUser;

    // Reference to the "accountingForms" collection
    final accountingFormsCollection = _db.collection("accountingForms");

    final QuerySnapshot formQuery = await accountingFormsCollection.get();

    final List<QueryDocumentSnapshot> formDocs = formQuery.docs;

    if (formDocs.isNotEmpty) {
      final forms = formDocs.map((formDoc) {
        final formData = formDoc.data() as Map<String, dynamic>; // Explicit casting
        return AccountingFormModel(
          tamirUcreti: (formData['tamirUcreti'] as double?) ?? 0,
          odemeSekli: (formData['odemeSekli'] as String?) ?? "",
          taksitSayisi: (formData['taksitSayisi'] as int?) ?? 0,
          muhasebeNotlari: (formData['muhasebeNotlari'] as String?) ?? "",


          tarihIPF: (formData['tarihIPF'] as Timestamp?)?.toDate() ?? DateTime.now(),
          tespitEdilen: (formData['tespitEdilen'] as String?) ?? "",
          yapilanIslemler: (formData['yapilanIslemler'] as String?) ?? "",
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


  Future<void> updateAccountingForm(String formId, AccountingFormModel updatedForm) async {
    try {
      final formRef = _db.collection("accountingForms").doc(formId);
      await formRef.update(updatedForm.toJson());
      Get.snackbar("Güncelleme Başarılı", "Form başarıyla güncellendi", backgroundColor: Colors.green);
    } catch (e) {
      Get.snackbar("Update Failed", "Failed to update form: $e", backgroundColor: Colors.red);
    }
  }

  Future<AccountingFormModel?> getFormByEgeTurboNo(int egeTurboNo) async {
    try {
      // Reference to the "accountingForms" collection
      final accountingFormsCollection = _db.collection("accountingForms");

      // Query for documents where 'egeTurbo' matches the provided egeTurboNo
      final querySnapshot = await accountingFormsCollection.where('egeTurboNo', isEqualTo: egeTurboNo).get();

      // Assuming there's only one document with this turboNo
      if (querySnapshot.docs.isNotEmpty) {
        final formDoc = querySnapshot.docs.first;
        final formData = formDoc.data() as Map<String, dynamic>;

        // Construct and return the AccountingFormModel
        return AccountingFormModel(
          tamirUcreti: (formData['tamirUcreti'] as double?) ?? 0,
          odemeSekli: (formData['odemeSekli'] as String?) ?? "",
          taksitSayisi: (formData['taksitSayisi'] as int?) ?? 0,
          muhasebeNotlari: (formData['muhasebeNotlari'] as String?) ?? "",


          tarihIPF: (formData['tarihIPF'] as Timestamp?)?.toDate() ?? DateTime.now(),
          tespitEdilen: (formData['tespitEdilen'] as String?) ?? "",
          yapilanIslemler: (formData['yapilanIslemler'] as String?) ?? "",
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
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch form: $e", backgroundColor: Colors.red);
    }
    return null;
  }

  Future<void> deleteAccountingForm(String formId) async {
    try {
      final formRef = _db.collection("accountingForms").doc(formId);
      await formRef.delete();
      Get.snackbar("Delete Successful", "Form deleted successfully", backgroundColor: Colors.green);
    } catch (e) {
      Get.snackbar("Delete Failed", "Failed to delete form: $e", backgroundColor: Colors.red);
    }
  }

}

