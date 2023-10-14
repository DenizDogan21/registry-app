import 'package:flutter/material.dart';
import 'package:turboapp/BackEnd/Models/inProgressForm_model.dart';
import '../widgets/common.dart';
import 'package:turboapp/frontEnd/utils/customColors.dart';

class FormDetailsPage extends StatelessWidget {
  final InProgressFormModel form;

  FormDetailsPage({required this.form});

  void showTurboImage(BuildContext context) {
    if (form.turboImageUrl != null && form.turboImageUrl.isNotEmpty && form.turboImageUrl !="null") {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Yüklenen Fotoğraf'),
            content: Image.network(form.turboImageUrl),
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
    if (form.katricImageUrl != null && form.katricImageUrl.isNotEmpty && form.katricImageUrl !="null") {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Yüklenen Fotoğraf'),
            content: Image.network(form.katricImageUrl),
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
    if (form.balansImageUrl != null && form.balansImageUrl.isNotEmpty && form.balansImageUrl !="null") {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Yüklenen Fotoğraf'),
            content: Image.network(form.balansImageUrl),
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
      appBar: appBar(context, "     Detaylar"),
      bottomNavigationBar: bottomNav(context),
      body: SafeArea( child: Stack(
        children: [
          background(context),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                Text('${form.tarih.toString()}',style: TextStyle(fontSize: 30,color: Colors.deepOrange),),
                SizedBox(height: 20),
                Text('TURBO NO: ${form.turboNo}',style: TextStyle(fontSize: 25)),
                SizedBox(height: 20),
                Text('ARAÇ BİLGİLERİ: ${form.aracBilgileri}',style: TextStyle(fontSize: 25)),
                SizedBox(height: 20),
                Text('MÜŞTERİ BİLGİLERİ: ${form.musteriBilgileri}',style: TextStyle(fontSize: 25)),
                SizedBox(height: 20),
                Text('MÜŞTERİ ŞİKAYETLERİ: ${form.musteriSikayetleri}',style: TextStyle(fontSize: 25)),
                SizedBox(height: 20),
                Text('TESPİT EDİLEN: ${form.tespitEdilen}',style: TextStyle(fontSize: 25)),
                SizedBox(height: 20),
                Text('YAPILAN İŞLEMLER: ${form.yapilanIslemler}',style: TextStyle(fontSize: 25)),
                SizedBox(height: 20),
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
                        color: Color(0xff31274F),
                      ),
                      child: Center(
                        child: customText(
                          "Turbo Fotoğrafı Göster",
                          CustomColors.loginButtonTextColor,
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
                      color: Color(0xff31274F),
                    ),
                    child: Center(
                      child: customText(
                        "Katriç Fotoğrafı Göster",
                        CustomColors.loginButtonTextColor,
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
                      color: Color(0xff31274F),
                    ),
                    child: Center(
                      child: customText(
                        "Balans Fotoğrafı Göster",
                        CustomColors.loginButtonTextColor,
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