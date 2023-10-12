import 'package:flutter/material.dart';
import 'package:turboapp/BackEnd/Models/inProgressForm_model.dart';
import '../widgets/common.dart';
import 'package:turboapp/frontEnd/utils/customColors.dart';

class FormDetailsPage extends StatelessWidget {
  final InProgressFormModel form;

  FormDetailsPage({required this.form});

  void showImage(BuildContext context) {
    if (form.turboImageUrl != null && form.turboImageUrl.isNotEmpty && form.turboImageUrl !="null") {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Yüklenen Fotoğraf'),
            content: Image.network(form.turboImageUrl), // $ bu işaretle ilgili bişey var alt satırlarda doğru formdan çekerken bunda işlemde olan formu bulamıyor iyi bak
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
      body: Stack(
        children: [
          background(context),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${form.tarih.toString()}',style: TextStyle(fontSize: 30,color: Colors.deepOrange),),
                SizedBox(height: 20),
                Text('Turbo No: ${form.turboNo}',style: TextStyle(fontSize: 25)),
                SizedBox(height: 20),
                Text('Araç Bilgileri: ${form.aracBilgileri}',style: TextStyle(fontSize: 25)),
                SizedBox(height: 20),
                Text('Müşteri Bilgileri: ${form.musteriBilgileri}',style: TextStyle(fontSize: 25)),
                SizedBox(height: 20),
                Text('Müşteri Şikayetleri: ${form.musteriSikayetleri}',style: TextStyle(fontSize: 25)),
                SizedBox(height: 20),
                Text('Tespit Edilen: ${form.tespitEdilen}',style: TextStyle(fontSize: 25)),
                SizedBox(height: 20),
                Text('Yapılan İşlemler: ${form.yapilanIslemler}',style: TextStyle(fontSize: 25)),
                SizedBox(height: 20),
                // Add more widgets to display other form data as needed

                // Button to show the uploaded photo
                TextButton(
                  onPressed: () => showImage(context),
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
                          "Fotoğrafı Göster",
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
    );
  }
}


Widget customText(String text, Color color) => Text(
  text,
  style: TextStyle(color: color),
);