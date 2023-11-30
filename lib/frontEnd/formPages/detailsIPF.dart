import 'package:flutter/material.dart';
import 'package:turboapp/BackEnd/Models/inProgressForm_model.dart';
import '../widgets/common.dart';
import 'package:turboapp/frontEnd/widgets/helperMethodsDetails.dart';

class DetailsIPFPage extends StatefulWidget {
  final InProgressFormModel formIPF;

  DetailsIPFPage({required this.formIPF});

  @override
  _DetailsIPFPageState createState() => _DetailsIPFPageState();
}
class _DetailsIPFPageState extends State<DetailsIPFPage> {
  late PageController _pageController;




  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }


  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Scaffold(
      appBar: appBar(context, "Detaylar"),
      bottomNavigationBar: bottomNav(),
      body: SafeArea(
          child: Stack(
              children:[
                background(context),
                PageView(
                  controller: _pageController,
                  children: <Widget>[
                    buildFirstPage(themeData),
                    buildSecondPage(themeData),
                    buildThirdPage(themeData),
                  ],
                ),
              ])),
    );
  }

  Widget buildFirstPage(ThemeData themeData) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          dateSection(themeData, widget.formIPF.tarihIPF.toString()),
          detailSection(
              'İş Emri Tarihi:', widget.formIPF.tarihWOF.toString(), themeData),
          detailSection(
              'Turbo No:', widget.formIPF.turboNo, themeData),
          buildYanindaGelenlerSection(
              widget.formIPF.yanindaGelenler, themeData),
          detailSection(
              'Araç Bilgileri:', widget.formIPF.aracBilgileri, themeData),
          detailSection(
              'Müşteri Ad Soyad:', widget.formIPF.musteriAdi, themeData),
          detailSection(
              'Müşteri Numarası:', widget.formIPF.musteriNumarasi.toString(), themeData),
          detailSection(
              'Müşteri Şikayetleri:', widget.formIPF.musteriSikayetleri,themeData),
          detailSection(
              'Ön Tespit:', widget.formIPF.onTespit, themeData),
          detailSection(
              'Turboyu Getiren:', widget.formIPF.turboyuGetiren, themeData),
          detailSection(
              'Taşıma Ücreti:', widget.formIPF.tasimaUcreti.toString(), themeData),
          detailSection(
              'Teslim Adresi:', widget.formIPF.teslimAdresi, themeData),
          SizedBox(height: 10,),
          Align(
              alignment: Alignment.center,
              child:ElevatedButton(
                onPressed: () => _pageController.nextPage(
                    duration: Duration(milliseconds: 500), curve: Curves.easeInOut),
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
              )),
        ],
      ),
    );
  }

  Widget buildSecondPage(ThemeData themeData) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ... 'Tespit Edilen' and 'Yapılan İşlemler'
          detailSection(
              'Tespit Edilen:', widget.formIPF.tespitEdilen, themeData),
          detailSection(
              'Yapılan İşlemler:', widget.formIPF.yapilanIslemler, themeData),
          SizedBox(height: 10,),
          Align(
              alignment: Alignment.center,
              child:ElevatedButton(
                onPressed: () => _pageController.nextPage(
                    duration: Duration(milliseconds: 500), curve: Curves.easeInOut),
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
              )),
        ],
      ),
    );
  }

  Widget buildThirdPage(ThemeData themeData) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ... Photo buttons
          photoButton(
              context, 'Turbo Fotoğrafı Göster', showTurboImage),
          photoButton(
              context, 'Katriç Fotoğrafı Göster', showKatricImage),
          photoButton(
              context, 'Balans Fotoğrafı Göster', showBalansImage),
        ],
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
    if (widget.formIPF.turboImageUrl != null && widget.formIPF.turboImageUrl.isNotEmpty &&
        widget.formIPF.turboImageUrl != "null") {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Yüklenen Fotoğraf'),
            content: Image.network(widget.formIPF.turboImageUrl),
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
    if (widget.formIPF.katricImageUrl != null && widget.formIPF.katricImageUrl.isNotEmpty &&
        widget.formIPF.katricImageUrl != "null") {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Yüklenen Fotoğraf'),
            content: Image.network(widget.formIPF.katricImageUrl),
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
    if (widget.formIPF.balansImageUrl != null && widget.formIPF.balansImageUrl.isNotEmpty &&
        widget.formIPF.balansImageUrl != "null") {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Yüklenen Fotoğraf'),
            content: Image.network(widget.formIPF.balansImageUrl),
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