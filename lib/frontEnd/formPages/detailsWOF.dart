import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:turboapp/backEnd/repositories/accountingForm_repo.dart';
import 'package:turboapp/frontEnd/formPages/outputWOF.dart';
import 'package:turboapp/frontEnd/widgets/common.dart';
import 'package:turboapp/frontEnd/widgets/helperMethodsDetails.dart';
import 'package:turboapp/frontEnd/utils/customTextField.dart';
import 'package:get/get.dart';

import '../../backEnd/models/accountingForm_model.dart';
import '../../backEnd/models/inProgressForm_model.dart';
import '../../backEnd/repositories/inProgressForm_repo.dart';
import '../../backEnd/repositories/workOrderForm_repo.dart';
import '../../backEnd/models/workOrderForm_model.dart';
import '../widgets/helperMethodsInput.dart';

class DetailsWOFPage extends StatefulWidget {
  final WorkOrderFormModel formWOF;
  DetailsWOFPage({required this.formWOF});

  @override
  _DetailsWOFState createState() => _DetailsWOFState();
}

class _DetailsWOFState extends State<DetailsWOFPage> {

  final _inProgressFormRepo = InProgressFormRepo.instance;
  final _accountingFormRepo = AccountingFormRepo.instance;

  TextEditingController _controllerTarihWOF = TextEditingController();
  TextEditingController _controllerTurboNo = TextEditingController();
  TextEditingController _controllerYanindaGelenler = TextEditingController();
  TextEditingController _controllerAracBilgileri = TextEditingController();
  TextEditingController _controllerAracKm = TextEditingController();
  TextEditingController _controllerAracPlaka = TextEditingController();
  TextEditingController _controllerMusteriAdi = TextEditingController();
  TextEditingController _controllerMusteriNumarasi= TextEditingController();
  TextEditingController _controllerMusteriSikayetleri = TextEditingController();
  TextEditingController _controllerOnTespit = TextEditingController();
  TextEditingController _controllerTurboyuGetiren = TextEditingController();
  TextEditingController _controllerTasimaUcreti = TextEditingController();
  TextEditingController _controllerTeslimAdresi = TextEditingController();
  TextEditingController _controllerKabulDurumu = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize controllers with initial values from widget.formIPF
    _controllerTarihWOF.text = DateFormat('yyyy-MM-dd HH:mm').format(widget.formWOF.tarihWOF);
    _controllerTurboNo.text = widget.formWOF.turboNo;
    _controllerYanindaGelenler.text = getFriendlyTrueKeys(widget.formWOF.yanindaGelenler).join(', ');
    _controllerAracBilgileri.text = widget.formWOF.aracBilgileri;
    _controllerAracKm.text = widget.formWOF.aracKm.toString();
    _controllerAracPlaka.text = widget.formWOF.aracPlaka;
    _controllerMusteriAdi.text = widget.formWOF.musteriAdi;
    _controllerMusteriNumarasi.text = widget.formWOF.musteriNumarasi.toString();
    _controllerMusteriSikayetleri.text = widget.formWOF.musteriSikayetleri;
    _controllerOnTespit.text = widget.formWOF.onTespit;
    _controllerTurboyuGetiren.text = widget.formWOF.turboyuGetiren;
    _controllerTasimaUcreti.text = widget.formWOF.tasimaUcreti.toString();
    _controllerTeslimAdresi.text = widget.formWOF.teslimAdresi;
    _controllerKabulDurumu.text = widget.formWOF.kabulDurumu;
  }


  Map<String, bool> parseYanindaGelenlerForSave(String text) {
    Map<String, bool> result = {};
    var friendlyNamesList = text.split(', ');

    friendlyNames.forEach((key, friendlyName) {
      if (friendlyNamesList.contains(friendlyName)) {
        result[key] = true;
      } else {
        result[key] = false;
      }
    });

    return result;
  }

  List<String> getFriendlyTrueKeys(Map<String, bool> map) {
    return map.entries
        .where((entry) => entry.value)
        .map((entry) => friendlyNames[entry.key] ?? entry.key)
        .toList();
  }



  Future<void> _saveChanges() async {
    if (widget.formWOF.id == null) {
      Get.snackbar("Error", "Form numarası bulunamadı", backgroundColor: Colors.red);
      return;
    }
    widget.formWOF.tarihWOF = DateTime.parse(_controllerTarihWOF.text);
    widget.formWOF.turboNo = _controllerTurboNo.text;
    widget.formWOF.yanindaGelenler = parseYanindaGelenlerForSave(_controllerYanindaGelenler.text);
    widget.formWOF.aracBilgileri = _controllerAracBilgileri.text;
    widget.formWOF.aracKm = int.parse(_controllerAracKm.text);
    widget.formWOF.aracPlaka = _controllerAracPlaka.text;
    widget.formWOF.musteriAdi = _controllerMusteriAdi.text;
    widget.formWOF.musteriNumarasi = int.parse(_controllerMusteriNumarasi.text);
    widget.formWOF.musteriSikayetleri = _controllerMusteriSikayetleri.text;
    widget.formWOF.onTespit = _controllerOnTespit.text;
    widget.formWOF.turboyuGetiren = _controllerTurboyuGetiren.text;
    widget.formWOF.tasimaUcreti = double.parse(_controllerTasimaUcreti.text);
    widget.formWOF.teslimAdresi = _controllerTeslimAdresi.text;

    // Check if the kabulDurumu has changed to "kabul edildi"
    if (_controllerKabulDurumu.text == "kabul edildi") {
      // Move the form from workOrderForms to inProgressForms
      final inProgressForm = InProgressFormModel(
        tarihIPF: DateTime.now(),
        turboNo: widget.formWOF.turboNo,
        egeTurboNo: await getAndUpdateEgeTurboNo(),
        tarihWOF: widget.formWOF.tarihWOF,
        aracBilgileri: widget.formWOF.aracBilgileri,
        aracKm: widget.formWOF.aracKm,
        aracPlaka: widget.formWOF.aracPlaka,
        musteriAdi: widget.formWOF.musteriAdi,
        musteriNumarasi: widget.formWOF.musteriNumarasi,
        musteriSikayetleri: widget.formWOF.musteriSikayetleri,
        onTespit: widget.formWOF.onTespit,
        turboyuGetiren: widget.formWOF.turboyuGetiren,
        tasimaUcreti: widget.formWOF.tasimaUcreti,
        teslimAdresi: widget.formWOF.teslimAdresi,
        yanindaGelenler: widget.formWOF.yanindaGelenler, flowPhotos: [],
      );
      final accountingForm = AccountingFormModel(
        tarihIPF: inProgressForm.tarihIPF,
        turboNo: widget.formWOF.turboNo,
        egeTurboNo: inProgressForm.egeTurboNo,
        tarihWOF: widget.formWOF.tarihWOF, // Assuming you store DateTime objects in formData
        aracBilgileri: widget.formWOF.aracBilgileri,
        aracKm: widget.formWOF.aracKm,
        aracPlaka: widget.formWOF.aracPlaka,
        musteriAdi: widget.formWOF.musteriAdi,
        musteriNumarasi: widget.formWOF.musteriNumarasi, // Assuming it's an int
        musteriSikayetleri: widget.formWOF.musteriSikayetleri,
        onTespit: widget.formWOF.onTespit,
        turboyuGetiren: widget.formWOF.turboyuGetiren,
        tasimaUcreti: widget.formWOF.tasimaUcreti, // Assuming it's a double
        teslimAdresi: widget.formWOF.teslimAdresi,
        yanindaGelenler: widget.formWOF.yanindaGelenler,
        kabulDurumu: _controllerKabulDurumu.text,
      );
      // Save inProgressForm to your database or backend
      _accountingFormRepo.createAccountingForm(accountingForm);
      _inProgressFormRepo.createInProgressForm(inProgressForm);
      await WorkOrderFormRepo.instance.deleteWorkOrderForm(widget.formWOF.id!);
    } else {
      // Update the kabulDurumu in the workOrderForm
      widget.formWOF.kabulDurumu = _controllerKabulDurumu.text;
      // Update the form in workOrderForms
      await WorkOrderFormRepo.instance.updateWorkOrderForm(widget.formWOF.id!, widget.formWOF);
    }

    // Navigate to the next page or go back
    // Logic to save changes to Firebase
    Navigator.of(context).pop(); // Close the dialog
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => OutputWOFPage()));
  }


  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;
    return Scaffold(
      appBar: appBar(context, "İş Emri Detay"),
      bottomNavigationBar: bottomNav(context),
      body: SafeArea(
          child: Stack(
              children: [
                background2(context),
                SingleChildScrollView(
                  padding: EdgeInsets.all(isTablet ? 64 : 16),
                  child:
                Column(
                  children: [
                    CustomTextField(
                      controller: _controllerTarihWOF,
                      label: 'İş Emri Tarihi',
                      keyboardType: TextInputType.datetime,
                      fieldSize: isTablet ? 30: 20,
                    ),
                    CustomTextField(
                      controller: _controllerTurboNo,
                      label: 'Turbo No',
                      fieldSize: isTablet ? 30: 20,
                    ),CustomTextField(
                        controller: _controllerYanindaGelenler,
                        label: 'Turboyla Gelenler',
                      fieldSize: isTablet ? 30: 20,
                      // ... other properties ...
                    ),CustomTextField(
                      controller: _controllerAracBilgileri,
                      label: 'Araç Bilgileri',
                      fieldSize: isTablet ? 30: 20,
                      // ... other properties ...
                    ),CustomTextField(
                        controller: _controllerAracKm,
                        label: 'Araç Km si',
                      fieldSize: isTablet ? 30: 20,
                      // ... other properties ...
                    ),CustomTextField(
                        controller: _controllerAracPlaka,
                        label: 'Araç Plakası',
                      fieldSize: isTablet ? 30: 20,
                      // ... other properties ...
                    ),CustomTextField(
                      controller: _controllerMusteriAdi,
                      label: 'Müşteri Adı',
                      fieldSize: isTablet ? 30: 20,
                      // ... other properties ...
                    ),CustomTextField(
                        controller: _controllerMusteriNumarasi,
                        label: 'Müşteri Numarası',
                      fieldSize: isTablet ? 30: 20,
                      // ... other properties ...
                    ),CustomTextField(
                      controller: _controllerMusteriSikayetleri,
                      label: 'Müşteri Şikayetleri',
                      fieldSize: isTablet ? 30: 20,
                      // ... other properties ...
                    ),CustomTextField(
                      controller: _controllerOnTespit,
                      label: 'Ön Tespit',
                      fieldSize: isTablet ? 30: 20,
                      // ... other properties ...
                    ),CustomTextField(
                      controller: _controllerTurboyuGetiren,
                      label: 'Turboyu Getiren',
                      fieldSize: isTablet ? 30: 20,
                    ),CustomTextField(
                      controller: _controllerTasimaUcreti,
                      label: 'Taşıma Ücreti',
                      fieldSize: isTablet ? 30: 20,
                      // ... other properties ...
                    ),
                    CustomTextField(
                      controller: _controllerTeslimAdresi,
                      label: 'Teslim Adresi',
                      fieldSize: isTablet ? 30: 20,
                      // ... other properties ...
                    ),
                    CustomTextField(
                      controller: _controllerKabulDurumu,
                      label: 'Kabul Durumu',
                      fieldSize: isTablet ? 30: 20,
                      // ... other properties ...
                    ),
                    isTablet ? SizedBox(height: 60,):SizedBox(height: 30,),
                    ElevatedButton(
                      onPressed: () => showSaveAlertDialog(context, _saveChanges, OutputWOFPage()),
                      child: Text(
                        'Kaydet',
                        style: TextStyle(fontSize: isTablet ? 32:16, fontWeight: FontWeight.bold, color: Colors.black), // Text styling
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.cyanAccent, // Button color
                        onPrimary: Colors.black, // Text color when button is pressed
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 5,
                        padding: EdgeInsets.symmetric(horizontal:isTablet ?  60:30, vertical: isTablet ?  30:15,),
                      ),
                    ),
                    isTablet ? SizedBox(height: 60,):SizedBox(height: 30,),
                    ElevatedButton(
                      onPressed: () => _confirmDeleteForm(),
                      child: Text(
                        'Formu Sil',
                        style: TextStyle(fontSize: isTablet ? 32:16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red, // Button color
                        onPrimary: Colors.white, // Text color when button is pressed
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 5,
                        padding: EdgeInsets.symmetric(horizontal:isTablet ?  60:30, vertical: 15),
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
        await WorkOrderFormRepo.instance.deleteWorkOrderForm(widget.formWOF.id!);
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => OutputWOFPage())); // Close the page after successful deletion
      } catch (e) {
        Get.snackbar("Form Silinemedi", "Failed to delete form: $e", backgroundColor: Colors.red);
      }
    }
  }

}