import 'package:flutter/material.dart';
import 'package:turboapp/BackEnd/Models/inProgressForm_model.dart';
import '../widgets/common.dart';
import 'package:turboapp/frontEnd/widgets/helperMethodsDetails.dart';

class DetailsIPFPage extends StatelessWidget {
  final InProgressFormModel formIPF;

  DetailsIPFPage({required this.formIPF});

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
                  dateSection(themeData, formIPF.tarihIPF.toString()),
                  detailSection(
                      'Turbo No:', formIPF.turboNo.toString(), themeData),
                  detailSection(
                      'Araç Bilgileri:', formIPF.aracBilgileri, themeData),
                  detailSection('Müşteri Bilgileri:', formIPF.musteriBilgileri,
                      themeData),
                  detailSection(
                      'Müşteri Şikayetleri:', formIPF.musteriSikayetleri,
                      themeData),
                  detailSection(
                      'Tespit Edilen:', formIPF.tespitEdilen, themeData),
                  detailSection(
                      'Yapılan İşlemler:', formIPF.yapilanIslemler, themeData),
                  // Add more widgets to display other form data as needed
                  photoButton(
                      context, 'Turbo Fotoğrafı Göster', showTurboImage),
                  photoButton(
                      context, 'Katriç Fotoğrafı Göster', showKatricImage),
                  photoButton(
                      context, 'Balans Fotoğrafı Göster', showBalansImage),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget photoButton(BuildContext context, String text, Function showImage) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton.icon(
        icon: Icon(Icons.image, color: Colors.white),
        label: Text(text),
        onPressed: () => showImage(context),
        style: ElevatedButton.styleFrom(
          primary: Colors.redAccent,
          onPrimary: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
        ),
      ),
    );
  }

  void showTurboImage(BuildContext context) {
    if (formIPF.turboImageUrl != null && formIPF.turboImageUrl.isNotEmpty &&
        formIPF.turboImageUrl != "null") {
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
    if (formIPF.katricImageUrl != null && formIPF.katricImageUrl.isNotEmpty &&
        formIPF.katricImageUrl != "null") {
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
    if (formIPF.balansImageUrl != null && formIPF.balansImageUrl.isNotEmpty &&
        formIPF.balansImageUrl != "null") {
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

}
