import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
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

      final userDocRef = _db.collection("Users").doc(userId);
      final userDoc = await userDocRef.get();

      if (userDoc.exists) {
        final inProgressForms =
            userDoc.data()?['inProgressForm'] as List<dynamic>? ?? [];
        final formJson = inProgressForm.toJson();

        inProgressForms.add(formJson);

        await userDocRef.update({'inProgressForm': inProgressForms});
        Get.snackbar("Form Ekleme Başarılı", "Oluşturuldu");
      } else {
        await userDocRef.set({
          'inProgressForm': [
            {
              ...inProgressForm.toJson(),
            }
          ],
          'email': user.email, // Add other user properties if needed
          'fullname': user.displayName,
        });
        Get.snackbar("Kullanıcı oluşturuldu", "Form Ekleme Başarılı");
      }
    } else {
      // Handle case where the user is not signed in
      // Display an error message or redirect to the login page
    }
  }

  Future<List<InProgressFormModel>> getInProgressForms() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userId = user.uid;
      final userDocRef = _db.collection('Users').doc(userId);
      final userDoc = await userDocRef.get();

      if (userDoc.exists) {
        final inProgressForms =
            userDoc.data()?['inProgressForm'] as List<dynamic>? ?? [];
        final forms = inProgressForms.map((formData) {
          return InProgressFormModel(
            turboNo: formData['turboNo'] as int? ?? 0,
            tarih: (formData['tarih'] as Timestamp?)?.toDate() ?? DateTime.now(),
            aracBilgileri: formData['aracBilgileri'] as String? ?? "",
            musteriBilgileri: formData['musteriBilgileri'] as String? ?? "",
            musteriSikayetleri: formData['musteriSikayetleri'] as String? ?? "",
            tespitEdilen: formData['tespitEdilen'] as String? ?? "",
            yapilanIslemler: formData['yapilanIslemler'] as String? ?? "",
          );
        }).toList();

        return forms;
      }
    }

    return [];
  }
}
