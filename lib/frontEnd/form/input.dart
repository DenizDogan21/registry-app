import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/common.dart';
import 'package:turboapp/BackEnd/Repositories/inProgressForm_repo.dart';
import 'package:turboapp/BackEnd/Models/inProgressForm_model.dart';

class InputPage extends StatefulWidget {
  const InputPage({Key? key}) : super(key: key);

  @override
  State<InputPage> createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  final _formKey = GlobalKey<FormState>();
  final _inProgressFormRepo = InProgressFormRepo.instance;

  int? turboNo;
  DateTime? tarih;
  String? aracBilgileri;
  String? musteriBilgileri;
  String? musteriSikayetleri;
  String? tespitEdilen;
  String? yapilanIslemler;

  @override
  void initState() {
    super.initState();
    tarih = DateTime.now();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Create an instance of InProgressFormModel with the entered data
      final inProgressForm = InProgressFormModel(
        turboNo: turboNo!,
        tarih: tarih!,
        aracBilgileri: aracBilgileri!,
        musteriBilgileri: musteriBilgileri!,
        musteriSikayetleri: musteriSikayetleri!,
        tespitEdilen: tespitEdilen!,
        yapilanIslemler: yapilanIslemler!,
      );

      _inProgressFormRepo.createInProgressForm(inProgressForm);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.black),
      bottomNavigationBar: bottomNav(context),
      body: Stack(
        children: [
          background(context),
          Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Turbo No'),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Lütfen bir turbo numarası giriniz';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      turboNo = int.parse(value!);
                    },
                  ),
                  TextFormField(
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Tarih',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    onTap: () {
                      showDatePicker(
                        context: context,
                        initialDate: tarih!,
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2100),
                      ).then((selectedDate) {
                        if (selectedDate != null) {
                          setState(() {
                            final selectedTime = TimeOfDay.now();
                            tarih = DateTime(
                              selectedDate.year,
                              selectedDate.month,
                              selectedDate.day,
                              selectedTime.hour,
                              selectedTime.minute,
                            );
                          });
                        }
                      });
                    },
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter a date';
                      }
                      return null;
                    },
                    controller: TextEditingController(
                      text: DateFormat('yyyy-MM-dd HH:mm').format(
                        tarih!.toLocal(), // Adjust to local time zone
                      ),
                    ),
                    onSaved: (value) {
                      tarih = DateFormat('yyyy-MM-dd HH:mm').parse(
                        value!,
                      );
                    },
                  ),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(labelText: 'Araç Bilgileri'),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Lütfen araç bilgisi girin';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      aracBilgileri = value;
                    },
                  ),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(labelText: 'Müşteri Bilgileri'),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Lütfen müşteri bilgisi girin';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      musteriBilgileri = value;
                    },
                  ),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(labelText: 'Müşteri Şikayetleri'),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Lütfen araç bilgisi girin';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      musteriSikayetleri = value;
                    },
                  ),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(labelText: 'Tespit Edilen'),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Lütfen araç bilgisi girin';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      tespitEdilen = value;
                    },
                  ),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(labelText: 'Yapılan İşlemler'),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Lütfen araç bilgisi girin';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      yapilanIslemler = value;
                    },
                  ),
                  // Add the remaining TextFormField widgets for other fields
                  // ...
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: Text('Submit'),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
