import 'package:android_path_provider/android_path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:turboapp/backEnd/repositories/accountingForm_repo.dart';
import 'package:turboapp/frontEnd/widgets/helperMethodsAccounting.dart';
import 'package:excel/excel.dart';
import 'dart:io';
import 'package:turboapp/frontEnd/utils/customTextStyle.dart';

import '../../backEnd/models/accountingForm_model.dart';


class AccountingDownloadPage extends StatefulWidget {
  const AccountingDownloadPage({super.key});

  @override
  State<AccountingDownloadPage> createState() => _AccountingDownloadPageState();
}



class _AccountingDownloadPageState extends State<AccountingDownloadPage> {
  String? downloadedFilePath;
  @override
  void initState() {
    super.initState();
    Get.put(BottomNavigationControllerAcc()); // Register the controller
  }

  Future<String> createExcel(List<AccountingFormModel> forms) async {
    var excel = Excel.createExcel();
    Sheet sheetObject = excel['Sheet1'];

    List<String> headers = [
      'Ege Turbo No','İş Emri Tarihi', 'Turbo No','Araç Bilgileri','Araç Km',
      'Araç Plakası','Müşteri Ad Soyad','Müşteri Numarası','Müşteri Şikayetleri',
      'Turbonun Yanında Gelenler','Ön Tespit','Turboyu Getiren','Taşıma Ücreti',
      'Teslim Adresi','İşe Başlama Tarihi','Tespit Edilen','Yapılan İşlemler',
      'Tamir Ücreti','Ödeme Şekli','Taksit Sayısı','Nuhasebe Notları',//... add all your fields
    ];

    sheetObject.appendRow(headers);

    for (var form in forms) {
      List<dynamic> row = [
        form.egeTurboNo,
        form.tarihWOF,
        form.turboNo,
        form.aracBilgileri,
        form.aracKm,
        form.aracPlaka,
        form.musteriAdi,
        form.musteriNumarasi,
        form.musteriSikayetleri,
        form.yanindaGelenler,
        form.onTespit,
        form.turboyuGetiren,
        form.tasimaUcreti,
        form.teslimAdresi,
        form.tarihIPF,
        form.tespitEdilen,
        form.yapilanIslemler,
        form.tamirUcreti,
        form.odemeSekli,
        form.taksitSayisi,
        form.muhasebeNotlari,
        //... add all your fields
      ];
      sheetObject.appendRow(row);
    }

    // Save or Download the Excel file
    var fileBytes = excel.save();

    // Getting the downloads directory path
    String downloadsDirectoryPath;
    try {
      downloadsDirectoryPath = await AndroidPathProvider.downloadsPath;
    } on PlatformException {
      print('Could not get the downloads directory');
      return '';
    }

    // Create a unique filename with a timestamp
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    String uniqueFileName = 'forms_$timestamp.xlsx';

    final file = File('$downloadsDirectoryPath/$uniqueFileName');

    // Write the file
    file.writeAsBytesSync(fileBytes!);

    return file.path;
  }

  DateTimeRange? selectedRange;

  Future<void> _selectDateRange() async {
    DateTimeRange? range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      initialDateRange: selectedRange,
    );

    if (range != null) {
      setState(() {
        selectedRange = range;
      });
    }
  }


  void _downloadData() async {
    if (selectedRange == null) {
      // Alert the user to select a date range first
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lütfen Önce Tarih Seçin')),
      );
      return;
    }

    var forms = await AccountingFormRepo.instance.getAccountingForms(); // Fetch forms

    // Check if forms are not empty
    if (forms.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('İndirilecek dosya yok')),
      );
      return;
    }

    // Filter forms based on selectedRange
    var filteredForms = forms.where((form) =>
    form.tarihWOF.isAfter(selectedRange!.start) &&
        form.tarihWOF.isBefore(selectedRange!.end)).toList();

    if (filteredForms.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bu tarihler arasında form bulunamadı')),
      );
      return;
    }

    downloadedFilePath = await createExcel(filteredForms); // Convert to Excel and Download once
    if (downloadedFilePath != null) {
      setState(() {});
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, "            Muhasebe"),
      bottomNavigationBar: bottomNavAcc(),
      body: SafeArea(
        child: Stack(children: [
          background(context),
          SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                onPressed: _selectDateRange,
            child: Text('Aralık Seçin',
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
              SizedBox(height: 20),
              Text(
                selectedRange == null
                    ? 'Lütfen iki tane tarih seçin'
                    : 'Seçilen aralık: ${selectedRange!.start.toLocal()} ile ${selectedRange!.end.toLocal()} arası',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              SizedBox(height: 80),
              ElevatedButton(
                onPressed: _downloadData,
                child: Text(
                  'Excel Olarak İndir',
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
              SizedBox(height: 10,),
              if (downloadedFilePath != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Text(
                    'İndirilen Excel Dosyası Yolu: $downloadedFilePath',
                    textAlign: TextAlign.center,
                    style: CustomTextStyle.outputListTextStyle,
                  ),
                ),
              // Add other widgets here if needed
            ],
          ),
        ),
          ]
      ),
      ),
    );
  }

}


