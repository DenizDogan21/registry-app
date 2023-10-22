import 'package:flutter/material.dart';
import 'package:turboapp/BackEnd/Models/workOrderForm_model.dart';
import '../widgets/common.dart';
import 'package:turboapp/frontEnd/utils/customColors.dart';


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
                Text('${formWOF.tarih.toString()}',style: TextStyle(fontSize: 30,color: CustomColors.yellowColor),),
                SizedBox(height: 30),
                Text('TURBO NO: ${formWOF.turboNo}',style: TextStyle(fontSize: 25, color: CustomColors.loginButtonTextColor)),
                SizedBox(height: 30),
                Text('ARAÇ BİLGİLERİ: ${formWOF.aracBilgileri}',style: TextStyle(fontSize: 25, color: CustomColors.loginButtonTextColor)),
                SizedBox(height: 30),
                Text('MÜŞTERİ BİLGİLERİ: ${formWOF.musteriBilgileri}',style: TextStyle(fontSize: 25, color: CustomColors.loginButtonTextColor)),
                SizedBox(height: 30),
                Text('MÜŞTERİ ŞİKAYETLERİ: ${formWOF.musteriSikayetleri}',style: TextStyle(fontSize: 25, color: CustomColors.loginButtonTextColor)),
                SizedBox(height: 30),
                Text('ÖN TESPİT: ${formWOF.onTespit}',style: TextStyle(fontSize: 25, color: CustomColors.loginButtonTextColor)),
                SizedBox(height: 30),
                Text('TURBOYU GETİREN: ${formWOF.turboyuGetiren}',style: TextStyle(fontSize: 25, color: CustomColors.loginButtonTextColor)),
                SizedBox(height: 30),
                Text('TAŞIMA ÜCRETİ: ${formWOF.tasimaUcreti}',style: TextStyle(fontSize: 25, color: CustomColors.loginButtonTextColor)),
                SizedBox(height: 30),
                Text('TESLİM ADRESİ: ${formWOF.teslimAdresi}',style: TextStyle(fontSize: 25, color: CustomColors.loginButtonTextColor)),
                SizedBox(height: 30),
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

