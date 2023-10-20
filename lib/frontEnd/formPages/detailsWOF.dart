import 'package:flutter/material.dart';
import 'package:turboapp/BackEnd/Models/workOrderForm_model.dart';
import '../widgets/common.dart';


class DetailsWOFPage extends StatelessWidget {
  final WorkOrderFormModel formWOF;

  DetailsWOFPage({required this.formWOF});




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, "     Detaylar"),
      bottomNavigationBar: bottomNav(context),
      body: SafeArea( child: Stack(
        children: [
          background(context),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                Text('${formWOF.tarih.toString()}',style: TextStyle(fontSize: 30,color: Colors.deepOrange),),
                SizedBox(height: 20),
                Text('TURBO NO: ${formWOF.turboNo}',style: TextStyle(fontSize: 25)),
                SizedBox(height: 20),
                Text('ARAÇ BİLGİLERİ: ${formWOF.aracBilgileri}',style: TextStyle(fontSize: 25)),
                SizedBox(height: 20),
                Text('MÜŞTERİ BİLGİLERİ: ${formWOF.musteriBilgileri}',style: TextStyle(fontSize: 25)),
                SizedBox(height: 20),
                Text('MÜŞTERİ ŞİKAYETLERİ: ${formWOF.musteriSikayetleri}',style: TextStyle(fontSize: 25)),
                SizedBox(height: 20),
                Text('ÖN TESPİT: ${formWOF.onTespit}',style: TextStyle(fontSize: 25)),
                SizedBox(height: 20),
                Text('TURBOYU GETİREN: ${formWOF.turboyuGetiren}',style: TextStyle(fontSize: 25)),
                SizedBox(height: 20),
                Text('TAŞIMA ÜCRETİ: ${formWOF.tasimaUcreti}',style: TextStyle(fontSize: 25)),
                SizedBox(height: 20),
                Text('TESLİM ADRESİ: ${formWOF.teslimAdresi}',style: TextStyle(fontSize: 25)),
                SizedBox(height: 20),
                // Add more widgets to display other form data as needed


              ],
            ),
          ),
        ],
      ),
      ),
    );
  }
}

