import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/common.dart';
import 'package:turboapp/BackEnd/Repositories/workOrderForm_repo.dart';
import 'package:turboapp/BackEnd/Models/workOrderForm_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class InputWOFPage extends StatefulWidget {
  const InputWOFPage({Key? key}) : super(key: key);

  @override
  State<InputWOFPage> createState() => _InputWOFPageState();
}

class _InputWOFPageState extends State<InputWOFPage> {


  TextEditingController _controllerTurboNo = TextEditingController();
  TextEditingController _controllerTarih = TextEditingController();
  TextEditingController _controllerAracBilgileri = TextEditingController();
  TextEditingController _controllerMusteriBilgileri = TextEditingController();
  TextEditingController _controllerMusteriSikayetleri = TextEditingController();
  TextEditingController _controllerOnTespit = TextEditingController();
  TextEditingController _controllerTurboyuGetiren = TextEditingController();
  TextEditingController _controllerTasimaUcreti = TextEditingController();
  TextEditingController _controllerTeslimAdresi = TextEditingController();



  GlobalKey<FormState> key = GlobalKey();


  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _workOrderFormRepo = WorkOrderFormRepo.instance;

  int? turboNo;
  DateTime? tarih;
  String? aracBilgileri;
  String? musteriBilgileri;
  String? musteriSikayetleri;
  String? onTespit;
  String? turboyuGetiren;
  double? tasimaUcreti;
  String? teslimAdresi;


  @override
  void initState() {
    super.initState();
    tarih = DateTime.now();
  }


  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {

        // Create an instance of workOrderFormModel with the entered data
        final workOrderForm = WorkOrderFormModel(
          turboNo: turboNo!,
          tarih: tarih!,
          aracBilgileri: aracBilgileri!,
          musteriBilgileri: musteriBilgileri!,
          musteriSikayetleri: musteriSikayetleri!,
          onTespit: onTespit!,
          turboyuGetiren: turboyuGetiren!,
          tasimaUcreti: tasimaUcreti!,
          teslimAdresi: teslimAdresi!,
        );

        // Create the form
        _workOrderFormRepo.createWorkOrderForm(workOrderForm);

        // Reset the form fields
        setState(() {
          _formKey.currentState!.reset();
        });

      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, "     İş Emri"),
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
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(labelText: 'Turbo No'),
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Lütfen turbo no girin';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          turboNo = int.tryParse(value!); // Parse the string to an int
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
                            return 'Lütfen müşteri sikayeti girin, yoksa "yok" yazın';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          musteriSikayetleri = value;
                        },
                      ),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(labelText: 'Ön Tespit'),
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Lütfen ön tespit girin';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          onTespit = value;
                        },
                      ),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(labelText: 'Turboyu Getiren'),
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Lütfen araç bilgisi girin';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          turboyuGetiren = value;
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Teslim Tarihi (yyyy-MM-dd HH:mm)',
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        controller: TextEditingController(
                          text: tarih != null ? DateFormat('yyyy-MM-dd HH:mm').format(tarih!) : '',
                        ),
                        onTap: () async {
                          final selectedDate = await showDatePicker(
                            context: context,
                            initialDate: tarih ?? DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2100),
                          );

                          if (selectedDate != null) {
                            final selectedTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.fromDateTime(tarih ?? DateTime.now()),
                            );

                            if (selectedTime != null) {
                              final newDate = DateTime(
                                selectedDate.year,
                                selectedDate.month,
                                selectedDate.day,
                                selectedTime.hour,
                                selectedTime.minute,
                              );

                              setState(() {
                                tarih = newDate;
                              });
                            }
                          }
                        },
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Please enter a date';
                          }

                          final dateFormat = DateFormat('yyyy-MM-dd HH:mm');
                          try {
                            dateFormat.parse(value!);
                            return null;
                          } catch (error) {
                            return 'Invalid date format. Use yyyy-MM-dd HH:mm';
                          }
                        },
                      ),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(labelText: 'Taşıma Ücreti'),
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Lütfen taşıma ücreti girin';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          tasimaUcreti = double.tryParse(value!); // Parse the string to an int
                        },
                      ),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(labelText: 'Teslim Adresi'),
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Lütfen teslim adresi girin';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          teslimAdresi = value;
                        },
                      ),
                      SizedBox(height: 20),
                      Column(children:[
                        ElevatedButton(onPressed:() async {

                          if (_formKey.currentState!.validate()) {
                            String turboNo = _controllerTurboNo.text;
                            String tarih = _controllerTarih.text;
                            String aracBilgileri = _controllerAracBilgileri.text;
                            String musteriBilgileri = _controllerMusteriBilgileri.text;
                            String musteriSikayetleri = _controllerMusteriSikayetleri.text;
                            String onTespit= _controllerOnTespit.text;
                            String turboyuGetiren= _controllerTurboyuGetiren.text;
                            String tasimaUcreti= _controllerTasimaUcreti.text;
                            String teslimAdresi = _controllerTeslimAdresi.text;

                            // Create a Map of data
                            Map<String, String> dataToSend = {
                              "turboNo": turboNo,
                              "tarih": tarih,
                              "aracBilgileri": aracBilgileri,
                              "musteriBilgileri": musteriBilgileri,
                              "musteriSikayetleri": musteriSikayetleri,
                              "onTespit": onTespit,
                              "turboyuGetiren": turboyuGetiren,
                              "tasimaUcreti": tasimaUcreti,
                              "teslimAdresi": teslimAdresi,
                            };

                          }
                          _submitForm();
                        },
                          child: Text('Yükle'),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              primary: Colors.blue,
                              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                              textStyle: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),
                        )
                        // ... Other TextFormField widgets ...
                      ],
                      ),
                    ]
                ),
              )
          )
        ],
      ),
    );
  }
}