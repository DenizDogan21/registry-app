import 'package:flutter/material.dart';
import 'package:turboapp/BackEnd/Models/inProgressForm_model.dart';
import '../widgets/common.dart';
import 'package:turboapp/frontEnd/utils/customColors.dart';

class DetailsIPFPage extends StatelessWidget {
  final InProgressFormModel formIPF;

  DetailsIPFPage({required this.formIPF});

  void showTurboImage(BuildContext context) {
    if (formIPF.turboImageUrl != null && formIPF.turboImageUrl.isNotEmpty && formIPF.turboImageUrl !="null") {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Yüklenen Fotoğraf'),
            content: Image.network(formIPF.turboImageUrl),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close'),
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Fotoğraf Bulunamadı !'), // Display error message
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close'),
              ),
            ],
          );
        },
      );
    }
  }
  void showKatricImage(BuildContext context) {
    if (formIPF.katricImageUrl != null && formIPF.katricImageUrl.isNotEmpty && formIPF.katricImageUrl !="null") {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Yüklenen Fotoğraf'),
            content: Image.network(formIPF.katricImageUrl),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close'),
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Fotoğraf Bulunamadı !'), // Display error message
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close'),
              ),
            ],
          );
        },
      );
    }
  }
  void showBalansImage(BuildContext context) {
    if (formIPF.balansImageUrl != null && formIPF.balansImageUrl.isNotEmpty && formIPF.balansImageUrl !="null") {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Yüklenen Fotoğraf'),
            content: Image.network(formIPF.balansImageUrl),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close'),
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Fotoğraf Bulunamadı !'), // Display error message
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close'),
              ),
            ],
          );
        },
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, ""),
      bottomNavigationBar: bottomNav(),
      body: SafeArea( child: Stack(
        children: [
          background(context),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                Text('${formIPF.tarih.toString()}',style: TextStyle(fontSize: 30,color: CustomColors.yellowColor),),
                SizedBox(height: 30),
                Text('TURBO NO: ${formIPF.turboNo}',style: TextStyle(fontSize: 25, color: CustomColors.loginButtonTextColor)),
                SizedBox(height: 30),
                Text('ARAÇ BİLGİLERİ: ${formIPF.aracBilgileri}',style: TextStyle(fontSize: 25, color: CustomColors.loginButtonTextColor)),
                SizedBox(height: 30),
                Text('MÜŞTERİ BİLGİLERİ: ${formIPF.musteriBilgileri}',style: TextStyle(fontSize: 25, color: CustomColors.loginButtonTextColor)),
                SizedBox(height: 30),
                Text('MÜŞTERİ ŞİKAYETLERİ: ${formIPF.musteriSikayetleri}',style: TextStyle(fontSize: 25, color: CustomColors.loginButtonTextColor)),
                SizedBox(height: 30),
                Text('TESPİT EDİLEN: ${formIPF.tespitEdilen}',style: TextStyle(fontSize: 25, color: CustomColors.loginButtonTextColor)),
                SizedBox(height: 30),
                Text('YAPILAN İŞLEMLER: ${formIPF.yapilanIslemler}',style: TextStyle(fontSize: 25, color: CustomColors.loginButtonTextColor)),
                SizedBox(height: 30),
                // Add more widgets to display other form data as needed

                // Button to show the uploaded photo
                TextButton(
                  onPressed: () => showTurboImage(context),
                    child: Container(
                      height: 50,
                      width: 150,
                      margin: EdgeInsetsDirectional.symmetric(horizontal: 90),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.horizontal(left: Radius.circular(20), right: Radius.circular(20)),
                        color: Colors.white,
                      ),
                      child: Center(
                        child: customText(
                          "Turbo Fotoğrafı Göster",
                          Colors.redAccent,
                        ),
                      ),
                    ),
                  ),
                TextButton(
                  onPressed: () => showKatricImage(context),
                  child: Container(
                    height: 50,
                    width: 150,
                    margin: EdgeInsetsDirectional.symmetric(horizontal: 90),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.horizontal(left: Radius.circular(20), right: Radius.circular(20)),
                      color: Colors.white,
                    ),
                    child: Center(
                      child: customText(
                        "Katriç Fotoğrafı Göster",
                        Colors.redAccent,
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => showBalansImage(context),
                  child: Container(
                    height: 50,
                    width: 150,
                    margin: EdgeInsetsDirectional.symmetric(horizontal: 90),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.horizontal(left: Radius.circular(20), right: Radius.circular(20)),
                      color: Colors.white,
                    ),
                    child: Center(
                      child: customText(
                        "Balans Fotoğrafı Göster",
                        Colors.redAccent,
                      ),
                    ),
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


Widget customText(String text, Color color) => Text(
  text,
  style: TextStyle(color: color),
);