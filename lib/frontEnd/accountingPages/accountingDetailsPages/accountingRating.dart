import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:turboapp/frontEnd/utils/customTextField.dart';

import '../../../backEnd/models/accountingForm_model.dart';
import '../../../backEnd/repositories/accountingForm_repo.dart';
import '../../widgets/helperMethodsAccounting.dart';
import '../../widgets/helperMethodsDetails.dart';
import 'package:turboapp/frontEnd/accountingPages/accountingAddShow.dart';


class AccountingRatingPage extends StatefulWidget {

  final AccountingFormModel formAF;
  AccountingRatingPage({required this.formAF});

  @override
  _AccountingRatingPageState createState() => _AccountingRatingPageState();
}

class _AccountingRatingPageState extends State<AccountingRatingPage> {
  final _accountingFormRepo = AccountingFormRepo.instance;

  TextEditingController _controllerTamirUcreti = TextEditingController();
  TextEditingController _controllerOdemeSekli = TextEditingController();
  TextEditingController _controllerTaksitSayisi = TextEditingController();
  TextEditingController _controllerMuhasebeNotlari = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize controllers with initial values from widget.formIPF
    _controllerTamirUcreti.text = widget.formAF.tamirUcreti.toString();
    _controllerOdemeSekli.text = widget.formAF.odemeSekli;
    _controllerTaksitSayisi.text = widget.formAF.taksitSayisi.toString();
    _controllerMuhasebeNotlari.text = widget.formAF.muhasebeNotlari;
  }

  Future<void> _saveChanges() async {
    if (widget.formAF.id == null) {
      Get.snackbar("Error", "Form numarası bulunamadı", backgroundColor: Colors.red);
      return;
    }
    widget.formAF.tamirUcreti = double.parse(_controllerTamirUcreti.text);
    widget.formAF.odemeSekli = _controllerOdemeSekli.text;
    widget.formAF.taksitSayisi = int.parse(_controllerTaksitSayisi.text);
    widget.formAF.muhasebeNotlari = _controllerMuhasebeNotlari.text;

    await AccountingFormRepo.instance.updateAccountingForm(widget.formAF.id!, widget.formAF);


    // Navigate to the next page or go back
    // Logic to save changes to Firebase
    Navigator.of(context).pop(); // Close the dialog
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => AccountingAddShowPage()));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, "Muhasebe"),
      bottomNavigationBar: bottomNavAcc(),
      body: SafeArea(
          child: Stack(
              children: [
                background(context),
                SingleChildScrollView( child:
                Column(
                  children: [
                    CustomTextField(
                        controller: _controllerTamirUcreti,
                        label: 'Tamir Ücreti'
                    ),CustomTextField(
                        controller: _controllerOdemeSekli,
                        label: 'Ödeme Şekli'
                      // ... other properties ...
                    ),CustomTextField(
                      controller: _controllerTaksitSayisi,
                      label: 'Taksit Sayısı',
                      // ... other properties ...
                    ),CustomTextField(
                        controller: _controllerMuhasebeNotlari,
                        label: 'Nuhasebe Notları'
                      // ... other properties ...
                    ),
                    ElevatedButton(
                      onPressed: () => showSaveAlertDialog(context, _saveChanges, AccountingAddShowPage()),
                      child: Text(
                        'Kaydet',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black), // Text styling
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.cyanAccent, // Button color
                        onPrimary: Colors.black, // Text color when button is pressed
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 5,
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      ),
                    ),
                    SizedBox(height: 30,),
                    ElevatedButton(
                      onPressed: () => _confirmDeleteForm(),
                      child: Text(
                        'Formu Sil',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red, // Button color
                        onPrimary: Colors.white, // Text color when button is pressed
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 5,
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      ),
                    ),

                  ],
                ),
                ),
              ])
      ),
    );
  }
  Future<void> _confirmDeleteForm() async {
    final confirmed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Form Silinecek"),
          content: Text("Formu silmek istediğinize emin misiniz?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Cancel the delete operation
              },
              child: Text("Vazgeç"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Confirm the delete operation
              },
              child: Text("Sil"),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      // Call the deleteWorkOrderForm method to delete the form
      try {
        await AccountingFormRepo.instance.deleteAccountingForm(widget.formAF.id!);
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => AccountingAddShowPage())); // Close the page after successful deletion
      } catch (e) {
        Get.snackbar("Form Silinemedi", "Failed to delete form: $e", backgroundColor: Colors.red);
      }
    }
  }
}
