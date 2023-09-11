import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../widgets/common.dart';
import 'package:turboapp/BackEnd/Repositories/inProgressForm_repo.dart';
import 'package:turboapp/BackEnd/Models/inProgressForm_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  File? katricMontageImage;
  File? turboMontageImage;
  File? balanceResultsImage;

  @override
  void initState() {
    super.initState();
    tarih = DateTime.now();
  }

  Future<void> _getImage(ImageSource source, Function(File?) setImage) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setImage(File(pickedFile.path));
    }
  }

  Future<void> _uploadPhotos(String userId) async {
    final storage = FirebaseStorage.instance;
    final Reference storageRef = storage.ref().child(userId);

    if (katricMontageImage != null) {
      final katricMontageImageRef = storageRef.child('katric_montage.jpg');
      await katricMontageImageRef.putFile(katricMontageImage!);
      final katricMontageImageUrl = await katricMontageImageRef.getDownloadURL();
      katricMontageImage = null;
      // Save the URL to your InProgressFormModel
      // ...
    }

    if (turboMontageImage != null) {
      final turboMontageImageRef = storageRef.child('turbo_montage.jpg');
      await turboMontageImageRef.putFile(turboMontageImage!);
      final turboMontageImageUrl = await turboMontageImageRef.getDownloadURL();
      turboMontageImage = null;
      // Save the URL to your InProgressFormModel
      // ...
    }

    if (balanceResultsImage != null) {
      final balanceResultsImageRef = storageRef.child('balance_results.jpg');
      await balanceResultsImageRef.putFile(balanceResultsImage!);
      final balanceResultsImageUrl = await balanceResultsImageRef.getDownloadURL();
      balanceResultsImage = null;
      // Save the URL to your InProgressFormModel
      // ...
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userId = user.uid;

        // Upload photos first
        await _uploadPhotos(userId);

        // Create an instance of InProgressFormModel with the entered data
        final inProgressForm = InProgressFormModel(
          tarih: tarih!,
          aracBilgileri: aracBilgileri!,
          musteriBilgileri: musteriBilgileri!,
          musteriSikayetleri: musteriSikayetleri!,
          tespitEdilen: tespitEdilen!,
          yapilanIslemler: yapilanIslemler!,
          katricMontageUrl: null, // Set to actual URL after uploading
          turboMontageUrl: null, // Set to actual URL after uploading
          balanceResultsUrl: null, // Set to actual URL after uploading
        );

        _inProgressFormRepo.createInProgressForm(inProgressForm);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, ""),
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
                  // ... Other TextFormField widgets ...

                  ElevatedButton(
                    onPressed: () => _getImage(
                        ImageSource.camera, (image) => katricMontageImage = image),
                    child: Text('Katriç Montajı'),
                  ),
                  ElevatedButton(
                    onPressed: () => _getImage(
                        ImageSource.camera, (image) => turboMontageImage = image),
                    child: Text('Turbo Montajı'),
                  ),
                  ElevatedButton(
                    onPressed: () => _getImage(
                        ImageSource.camera, (image) => balanceResultsImage = image),
                    child: Text('Balans Değerleri'),
                  ),
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: Text('Yükle'),
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
