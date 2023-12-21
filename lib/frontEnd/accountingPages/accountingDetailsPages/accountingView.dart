import 'package:flutter/material.dart';
import 'package:turboapp/frontEnd/widgets/helperMethodsDetails.dart';

import '../../../backEnd/models/accountingForm_model.dart';
import '../../widgets/helperMethodsAccounting.dart';
import 'package:turboapp/frontEnd/accountingPages/accountingDetailsPages/accountingRating.dart';

class AccountingViewPage extends StatelessWidget {
  final AccountingFormModel formAF;

  AccountingViewPage({required this.formAF});

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Scaffold(
      appBar: appBar(context, "Detaylar"),
      bottomNavigationBar: bottomNavAcc(),
      body: SafeArea(
        child: Stack(
          children: [
            background(context),
            SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  detailSection(
                      'Ege Turbo Numarası:', formAF.egeTurboNo.toString(), themeData),
                  dateSection(themeData, formAF.tarihWOF.toString()),
                  detailSection(
                      'Turbo No:', formAF.turboNo, themeData),
                  detailSection(
                      'Araç Bilgileri:', formAF.aracBilgileri, themeData),
                  detailSection(
                      'Araç Km:', formAF.aracKm.toString(), themeData),
                  detailSection(
                      'Araç Plakası:', formAF.aracPlaka, themeData),
                  detailSection('Müşteri Ad Soyad:', formAF.musteriAdi,
                      themeData),
                  detailSection('Müşteri Numarası:', formAF.musteriNumarasi.toString(),
                      themeData),
                  detailSection(
                      'Müşteri Şikayetleri:', formAF.musteriSikayetleri,
                      themeData),
                  buildYanindaGelenlerSection(
                      formAF.yanindaGelenler, themeData),
                  detailSection('Ön Tespit:', formAF.onTespit, themeData),
                  detailSection(
                      'Turboyu Getiren:', formAF.turboyuGetiren, themeData),
                  detailSection(
                      'Taşıma Ücreti:', formAF.tasimaUcreti.toString(),
                      themeData),
                  detailSection(
                      'Teslim Adresi:', formAF.teslimAdresi, themeData),
                  dateSection(themeData, formAF.tarihIPF.toString()),
                  detailSection(
                      'Tespit Edilen:', formAF.tespitEdilen, themeData),
                  detailSection(
                      'Yapılan İşlemler:', formAF.yapilanIslemler, themeData),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => AccountingRatingPage(formAF: formAF))),
                    child: Text(
                      'Devam',
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}