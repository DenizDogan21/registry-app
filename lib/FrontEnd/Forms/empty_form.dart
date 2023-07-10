import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'common_frontend.dart';
import '../../BackEnd/Database/database_helper.dart';
import 'form_model.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class EmptyFormPage extends StatefulWidget {
  @override
  _EmptyFormPageState createState() => _EmptyFormPageState();
}

class _EmptyFormPageState extends State<EmptyFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _turboNoController = TextEditingController();
  final TextEditingController _tarihController = TextEditingController();
  final TextEditingController _aracBilgileriController = TextEditingController();
  final TextEditingController _musteriBilgileriController = TextEditingController();
  final TextEditingController _musteriSikayetleriController = TextEditingController();
  final TextEditingController _tespitEdilenController = TextEditingController();
  final TextEditingController _yapilanIslemlerController = TextEditingController();
  // ... add the remaining controllers for other fields

  @override
  void initState() {
    super.initState();
    _tarihController.text = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
  }

  Widget buildBackground(BuildContext context) => background(context);
  Widget buildBottomNav(BuildContext context) => bottomNav(context);

  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      FormData formData = FormData(
        id: int.parse(_idController.text),
        turboNo: int.parse(_turboNoController.text),
        tarih: DateTime.parse(_tarihController.text),
        aracBilgileri: _aracBilgileriController.text,
        musteriBilgileri: _musteriBilgileriController.text,
        musteriSikayetleri: _musteriSikayetleriController.text,
        tespitEdilen: _tespitEdilenController.text,
        yapilanIslemler: _yapilanIslemlerController.text,
        // ... assign values from other controllers to respective fields
      );

      DatabaseHelper databaseHelper = DatabaseHelper();
      await databaseHelper.insertForm(formData);

      Navigator.pushReplacementNamed(context! as BuildContext, '/filled_forms');
    }
  }

  @override
  void dispose() {
    _turboNoController.dispose();
    _tarihController.dispose();
    _aracBilgileriController.dispose();
    _musteriBilgileriController.dispose();
    _musteriSikayetleriController.dispose();
    _tespitEdilenController.dispose();
    _yapilanIslemlerController.dispose();
    // ... dispose the remaining controllers
    super.dispose();
  }


  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: buildBottomNav(context),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Ege  Turbo', style: TextStyle( color: Colors.deepPurple, fontStyle: FontStyle.italic, fontSize: 30),),
      ),
      body: Stack(
        children: [
          buildBackground(context),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  TextFormField(
                    controller: _turboNoController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Turbo No'),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Lütfen bir turbo numarası giriniz';
                      }
                      return null;
                    },
                  ),

                  TextFormField(
                    controller: _tarihController,
                    keyboardType: TextInputType.datetime,
                    decoration: InputDecoration(labelText: 'Tarih'),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter a date';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _aracBilgileriController,
                    decoration: InputDecoration(labelText: 'Araç Bilgileri'),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Lütfen araç bilgilerini giriniz';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _musteriBilgileriController,
                    decoration: InputDecoration(labelText: 'Müşteri Bilgileri'),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Lütfen müşteri bilgilerini giriniz';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _musteriSikayetleriController,
                    decoration: InputDecoration(labelText: 'Müşteri Şikayetleri'),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Lütfen müşteri şikayetlerini giriniz';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _tespitEdilenController,
                    decoration: InputDecoration(labelText: 'Tespit Edilen'),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Lütfen tespit edilenleri giriniz';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _yapilanIslemlerController,
                    decoration: InputDecoration(labelText: 'Yapılan İşlemler'),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Lütfen yapılan işlemleri giriniz';
                      }
                      return null;
                    },
                  ),


              // Add form fields for araç bilgileri, müşteri bilgileri, müşteri şikayetleri, tespit edilen, yapılan işlemler, and other fields

                  ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black, // Background color
                    ),
                    child: Text('Submit'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
