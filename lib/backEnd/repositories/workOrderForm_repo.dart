import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:turboapp/backEnd/models/workOrderForm_model.dart';

class WorkOrderFormRepo extends GetxController {
  static WorkOrderFormRepo get instance => Get.find();
  final _db = FirebaseFirestore.instance;




  createWorkOrderForm(WorkOrderFormModel workOrderForm) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userId = user.email;

      // Reference to the new collection "workOrderForms"
      final workOrderFormsCollection = _db.collection("workOrderForms");

      final formJson = workOrderForm.toJson();

      await workOrderFormsCollection.add({
        'yukleyenKullanici': userId, // Associate the form with the user
        ...formJson,
      });

      Get.snackbar("Form Ekleme Başarılı", "Oluşturuldu", backgroundColor: Colors.green);
    } else {
      // Handle case where the user is not signed in
      // Display an error message or redirect to the login page
    }
  }

  Future<List<WorkOrderFormModel>> getWorkOrderForms() async {
    try {
      // Reference to the "workOrderForms" collection
      final workOrderFormsCollection = _db.collection("workOrderForms");

      final QuerySnapshot formQuery = await workOrderFormsCollection.get();

      final List<QueryDocumentSnapshot> formDocs = formQuery.docs;

      if (formDocs.isNotEmpty) {
        final forms = formDocs.map((formDoc) {
          final formData = formDoc.data() as Map<String, dynamic>; // Explicit casting
          return WorkOrderFormModel(
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
            yanindaGelenler: Map<String, bool>.from(formData['yanindaGelenler'] ?? {}),
            kabulDurumu: (formData['kabulDurumu'] as String?) ?? "",
            id: formDoc.id,
          );
        }).toList();

        return forms;
      }
    } catch (error) {
      throw error;
    }

    return [];
  }

  Future<void> updateWorkOrderForm(String formId, WorkOrderFormModel updatedForm) async {
    try {
      final formRef = _db.collection("workOrderForms").doc(formId);
      await formRef.update(updatedForm.toJson());
      Get.snackbar("Update Successful", "Form updated successfully", backgroundColor: Colors.green);
    } catch (e) {
      Get.snackbar("Update Failed", "Failed to update form: $e", backgroundColor: Colors.red);
    }
  }

  Future<void> deleteWorkOrderForm(String formId) async {
    try {
      final formRef = _db.collection("workOrderForms").doc(formId);
      await formRef.delete();
      Get.snackbar("Delete Successful", "Form deleted successfully", backgroundColor: Colors.green);
    } catch (e) {
      Get.snackbar("Delete Failed", "Failed to delete form: $e", backgroundColor: Colors.red);
    }
  }


}