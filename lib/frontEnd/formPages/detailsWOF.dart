import 'package:flutter/material.dart';
import 'package:turboapp/BackEnd/Models/workOrderForm_model.dart';
import '../widgets/common.dart';
import 'package:turboapp/frontEnd/widgets/helperMethodsDetails.dart';

class DetailsWOFPage extends StatelessWidget {
  final WorkOrderFormModel formWOF;

  DetailsWOFPage({required this.formWOF});

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Scaffold(
      appBar: appBar(context, "Detaylar"),
      bottomNavigationBar: bottomNav(),
      body: SafeArea(
        child: Stack(
          children: [
            background(context),
            SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  dateSection(themeData, formWOF.tarihWOF.toString()),
                  detailSection(
                      'Turbo No:', formWOF.turboNo, themeData),
                  detailSection(
                      'Araç Bilgileri:', formWOF.aracBilgileri, themeData),
                  detailSection('Müşteri Ad Soyad:', formWOF.musteriAdi,
                      themeData),
                  detailSection('Müşteri Numarası:', formWOF.musteriNumarasi.toString(),
                      themeData),
                  detailSection(
                      'Müşteri Şikayetleri:', formWOF.musteriSikayetleri,
                      themeData),
                  detailSection('Ön Tespit:', formWOF.onTespit, themeData),
                  detailSection(
                      'Turboyu Getiren:', formWOF.turboyuGetiren, themeData),
                  detailSection(
                      'Taşıma Ücreti:', formWOF.tasimaUcreti.toString(),
                      themeData),
                  detailSection(
                      'Teslim Adresi:', formWOF.teslimAdresi, themeData),
                  buildYanindaGelenlerSection(
                      formWOF.yanindaGelenler, themeData),
                  // Add more widgets to display other form data as needed
                  // If you have photo URLs, you can add photoButton widgets here
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

