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
    final Reference storageRef = storage.ref().child('user_images').child(userId);

    if (katricMontageImage != null) {
      final katricMontageImageRef = storageRef.child('katric_montage.jpg');
      await katricMontageImageRef.putFile(katricMontageImage!);
    }

    if (turboMontageImage != null) {
      final turboMontageImageRef = storageRef.child('turbo_montage.jpg');
      await turboMontageImageRef.putFile(turboMontageImage!);
    }

    if (balanceResultsImage != null) {
      final balanceResultsImageRef = storageRef.child('balance_results.jpg');
      await balanceResultsImageRef.putFile(balanceResultsImage!);
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
          turboNo: turboNo!,
          tarih: tarih!,
          aracBilgileri: aracBilgileri!,
          musteriBilgileri: musteriBilgileri!,
          musteriSikayetleri: musteriSikayetleri!,
          tespitEdilen: tespitEdilen!,
          yapilanIslemler: yapilanIslemler!,
          katricMontageImage: katricMontageImage != null
              ? await _uploadAndGetUrl(userId, 'katric_montage.jpg', katricMontageImage!)
              : null,
          turboMontageImage: turboMontageImage != null
              ? await _uploadAndGetUrl(userId, 'turbo_montage.jpg', turboMontageImage!)
              : null,
          balanceResultsImage: balanceResultsImage != null
              ? await _uploadAndGetUrl(userId, 'balance_results.jpg', balanceResultsImage!)
              : null,
        );

        _inProgressFormRepo.createInProgressForm(inProgressForm);
      }
    }
  }

  Future<String?> _uploadAndGetUrl(
      String userId, String imageName, File imageFile) async {
    final storage = FirebaseStorage.instance;
    final Reference storageRef = storage.ref().child('user_images').child(userId);

    final imageRef = storageRef.child(imageName);
    final uploadTask = imageRef.putFile(imageFile);
    final snapshot = await uploadTask.whenComplete(() {});

    if (snapshot.state == TaskState.success) {
      final downloadURL = await imageRef.getDownloadURL();
      return downloadURL;
    } else {
      // Handle the error case
      return null;
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
