import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import '../Models/workOrderForm_model.dart';

class WorkOrderFormRepo extends GetxController {
  static WorkOrderFormRepo get instance => Get.find();
  final _db = FirebaseFirestore.instance;




  createWorkOrderForm(WorkOrderFormModel workOrderForm) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userId = user.uid;

      // Reference to the new collection "workOrderForms"
      final workOrderFormsCollection = _db.collection("workOrderForms");

      final formJson = workOrderForm.toJson();

      await workOrderFormsCollection.add({
        'userId': userId, // Associate the form with the user
        ...formJson,
      });

      Get.snackbar("Form Ekleme Başarılı", "Oluşturuldu");
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
            turboNo: (formData['turboNo'] as int?) ?? 0,
            tarih: (formData['tarih'] as Timestamp?)?.toDate() ?? DateTime.now(),
            aracBilgileri: (formData['aracBilgileri'] as String?) ?? "",
            musteriBilgileri: (formData['musteriBilgileri'] as String?) ?? "",
            musteriSikayetleri: (formData['musteriSikayetleri'] as String?) ?? "",
            onTespit: (formData['onTespit'] as String?) ?? "",
            turboyuGetiren: (formData['turboyuGetiren'] as String?) ?? "",
            tasimaUcreti: (formData['tasimaUcreti'] as double?) ?? 0,
            teslimAdresi: (formData['teslimAdresi'] as String?) ?? "",
          );
        }).toList();

        return forms;
      }
    } catch (error) {
      throw error;
    }

    return [];
  }


}
