import 'package:android_path_provider/android_path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:turboapp/backEnd/repositories/accountingForm_repo.dart';
import 'package:turboapp/frontEnd/widgets/helperMethodsAccounting.dart';
import 'package:excel/excel.dart';
import 'dart:io';
import 'package:turboapp/frontEnd/utils/customTextStyle.dart';
import 'package:turboapp/frontEnd/formPages/detailsWOF.dart';

import '../../backEnd/models/accountingForm_model.dart';
import '../widgets/helperMethodsDetails.dart';


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

    String parseTurbonunYanindaGelenler(Map<String, bool> turbonunYanindaGelenler) {
      List<String> trueValues = turbonunYanindaGelenler.entries
          .where((entry) => entry.value)
          .map((entry) => friendlyNames[entry.key] ?? entry.key)
          .toList();

      return trueValues.join(', ');
    }

    for (var form in forms) {
      List<dynamic> row = [
        form.egeTurboNo,
        DateFormat('yyyy-MM-dd-HH:mm').format(form.tarihWOF), // Format date here
        form.turboNo,
        form.aracBilgileri,
        form.aracKm,
        form.aracPlaka,
        form.musteriAdi,
        form.musteriNumarasi,
        form.musteriSikayetleri,
        parseTurbonunYanindaGelenler(form.yanindaGelenler),
        form.onTespit,
        form.turboyuGetiren,
        form.tasimaUcreti,
        form.teslimAdresi,
        DateFormat('yyyy-MM-dd-HH:mm').format(form.tarihIPF),
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
      print('Dosya yolu bulunamadı');
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
        SnackBar(content: Text('Lütfen Önce Tarih Seçin',style: TextStyle(color: Colors.redAccent),)),
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
        form.tarihWOF.isBefore(selectedRange!.end.add(Duration(days: 1)))).toList();

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
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;
    return Scaffold(
      appBar: appBar(context, "Dosya İndir"),
      bottomNavigationBar: bottomNavAcc(context),
      body: SafeArea(
        child: Stack(children: [
          background(context),
          SingleChildScrollView(
            padding: EdgeInsets.all(isTablet ? 200 : 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                onPressed: _selectDateRange,
            child: Text('Aralık Seçin',
                  style: TextStyle(fontSize: isTablet ? 32:16, fontWeight: FontWeight.bold, color: Colors.black), // Text styling
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.cyanAccent, // Button color
                  onPrimary: Colors.black, // Text color when button is pressed
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 5,
                  padding: EdgeInsets.symmetric(horizontal: isTablet ? 30:15, vertical: isTablet ? 15:8),
                ),
              ),
              isTablet ? SizedBox(height: 40):SizedBox(height: 20),
              Column(
                children: [
                  Text(
                    selectedRange == null
                        ? 'Lütfen İki Tane Tarih Seçin'
                        : 'SEÇİLEN ARALIK:',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: isTablet ? 32:16, fontWeight: FontWeight.bold, color: Colors.greenAccent),
                  ),
                  isTablet ? SizedBox(height: 10):SizedBox(height: 5), // Adjust the spacing between lines if needed
                  Text(
                    selectedRange == null
                        ? ''
                        : '${DateFormat('dd-MM-yyyy').format(selectedRange!.start)}\n${DateFormat('dd-MM-yyyy').format(selectedRange!.end)} ',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: isTablet ? 32:16, fontWeight: FontWeight.w300, color: Colors.white),
                  ),
                ],
              ),

              SizedBox(height: 80),
              ElevatedButton(
                onPressed: _downloadData,
                child: Text(
                  'Excel Olarak İndir',
                  style: TextStyle(fontSize: isTablet ? 32:16, fontWeight: FontWeight.bold, color: Colors.black), // Text styling
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.cyanAccent, // Button color
                  onPrimary: Colors.black, // Text color when button is pressed
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 5,
                  padding: EdgeInsets.symmetric(horizontal: isTablet ? 30:15, vertical: isTablet ? 15:8),
                ),
              ),
              SizedBox(height: 10,),
              if (downloadedFilePath != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Column(
                    children: [
                      Text(
                        'DOSYA YOLU:',
                        textAlign: TextAlign.center,
                        style: CustomTextStyle.outputListTextStyle.copyWith(fontSize: isTablet ? 32:16, color: Colors.greenAccent,
                        fontWeight: FontWeight.w600),
                      ),
                      isTablet ? SizedBox(height: 10):SizedBox(height: 5), // Adjust the spacing between lines if needed
                      Text(
                        '$downloadedFilePath',
                        textAlign: TextAlign.center,
                        style: CustomTextStyle.outputListTextStyle.copyWith(fontSize: isTablet ? 32:16),
                      ),
                    ],
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


