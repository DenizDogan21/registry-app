import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../widgets/common.dart';
import 'package:turboapp/BackEnd/Repositories/inProgressForm_repo.dart';
import 'package:turboapp/BackEnd/Models/inProgressForm_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class InputIPFPage extends StatefulWidget {
  const InputIPFPage({Key? key}) : super(key: key);

  @override
  State<InputIPFPage> createState() => _InputIPFPageState();
}

class _InputIPFPageState extends State<InputIPFPage> {


  TextEditingController _controllerTurboNo = TextEditingController();
  TextEditingController _controllerTarih = TextEditingController();
  TextEditingController _controllerAracBilgileri = TextEditingController();
  TextEditingController _controllerMusteriBilgileri = TextEditingController();
  TextEditingController _controllerMusteriSikayetleri = TextEditingController();
  TextEditingController _controllerTespitEdilen = TextEditingController();
  TextEditingController _controllerYapilanIslemler = TextEditingController();



  GlobalKey<FormState> key = GlobalKey();

  CollectionReference _reference =
  FirebaseFirestore.instance.collection('Users');


  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _inProgressFormRepo = InProgressFormRepo.instance;

  int? turboNo;
  DateTime? tarih;
  String? aracBilgileri;
  String? musteriBilgileri;
  String? musteriSikayetleri;
  String? tespitEdilen;
  String? yapilanIslemler;

  String turboImageUrl="";
  String katricImageUrl="";
  String balansImageUrl="";


  @override
  void initState() {
    super.initState();
    tarih = DateTime.now();
  }


  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (turboImageUrl.isEmpty) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Please upload an image')));
        return; // Exit the function without uploading to Firestore
      }

      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // You can remove 'userId' if it's not used here
        // final userId = user.uid;

        // Create an instance of InProgressFormModel with the entered data
        final inProgressForm = InProgressFormModel(
          turboNo: turboNo!,
          tarih: tarih!,
          aracBilgileri: aracBilgileri!,
          musteriBilgileri: musteriBilgileri!,
          musteriSikayetleri: musteriSikayetleri!,
          tespitEdilen: tespitEdilen!,
          yapilanIslemler: yapilanIslemler!,
          turboImageUrl: turboImageUrl,
          katricImageUrl: katricImageUrl,
          balansImageUrl: balansImageUrl,

        );

        // Create the form
        _inProgressFormRepo.createInProgressForm(inProgressForm);

        // Reset the form fields
        setState(() {
          // Clear ImageUrls
          turboImageUrl = "";
          katricImageUrl="";
          balansImageUrl="";
          _formKey.currentState!.reset();
        });

        // Clear the controller variables
        _controllerTurboNo.clear();
        _controllerTarih.clear();
        _controllerAracBilgileri.clear();
        _controllerMusteriBilgileri.clear();
        _controllerMusteriSikayetleri.clear();
        _controllerTespitEdilen.clear();
        _controllerYapilanIslemler.clear();
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, "     Formun Adı"),
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
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2200),
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
                  /*
                * Step 1. Pick/Capture an image   (image_picker)
                * Step 2. Upload the image to Firebase storage
                * Step 3. Get the URL of the uploaded image
                * Step 4. Store the image URL inside the corresponding
                *         document of the database.
                * Step 5. Display the image on the list
                *
                * */
                  Column(children:[ Row( children:[
                  IconButton(onPressed: () async {

                    //Install image_picker
                    //Import the corresponding library
                    ImagePicker imagePicker = ImagePicker();
                    XFile? turboFile= await imagePicker.pickImage(source:ImageSource.camera,imageQuality: 10);
                    print("${turboFile?.path}");

                    //Install firebase_storage
                    //Import the library
                    if(turboFile==null) return;

                    //Import dart:core
                    String uniqueTFileName =("t"+ DateTime.now().millisecondsSinceEpoch.toString()) ;

                    //Get a reference to storage root
                    Reference referenceRoot = FirebaseStorage.instance.ref();
                    Reference referenceDirImages =
                    referenceRoot.child('turboImages');

                    //Create a reference for the image to be stored
                    Reference referenceImageToUpload =
                    referenceDirImages.child(uniqueTFileName);

                    try {
                      // Store the file
                      await referenceImageToUpload.putFile(File(turboFile!.path));
                      // Success: get the download URL
                      turboImageUrl = await referenceImageToUpload.getDownloadURL();
                      print("Image URL: $turboImageUrl"); // Add this line for debugging
                    } catch (error) {
                      // Some error occurred
                      print("Error uploading image: $error"); // Add this line for debugging
                    }

                  }, icon: Icon(Icons.camera_alt),iconSize: 30,color: Colors.deepOrange,),Text("Turbo",style: TextStyle(fontSize: 20,color: Colors.deepOrange),)]),
                    Row( children:[IconButton(onPressed: () async {

                      //Install image_picker
                      //Import the corresponding library
                      ImagePicker imagePicker = ImagePicker();
                      XFile? katricFile= await imagePicker.pickImage(source:ImageSource.camera,imageQuality: 10);
                      print("${katricFile?.path}");

                      //Install firebase_storage
                      //Import the library
                      if(katricFile==null) return;

                      //Import dart:core
                      String uniqueKFileName =("k"+ DateTime.now().millisecondsSinceEpoch.toString()) ;

                      //Get a reference to storage root
                      Reference referenceRoot = FirebaseStorage.instance.ref();
                      Reference referenceDirImages =
                      referenceRoot.child('katricImages');

                      //Create a reference for the image to be stored
                      Reference referenceImageToUpload =
                      referenceDirImages.child(uniqueKFileName);

                      try {
                        // Store the file
                        await referenceImageToUpload.putFile(File(katricFile!.path));
                        // Success: get the download URL
                        katricImageUrl = await referenceImageToUpload.getDownloadURL();
                        print("Image URL: $katricImageUrl"); // Add this line for debugging
                      } catch (error) {
                        // Some error occurred
                        print("Error uploading image: $error"); // Add this line for debugging
                      }

                    }, icon: Icon(Icons.camera_alt),iconSize: 30,color: Colors.deepOrange,),Text("Katric",style: TextStyle(fontSize: 20,color: Colors.deepOrange),)]),
                    Row( children:[IconButton(onPressed: () async {

                      //Install image_picker
                      //Import the corresponding library
                      ImagePicker imagePicker = ImagePicker();
                      XFile? balansFile= await imagePicker.pickImage(source:ImageSource.camera,imageQuality: 10);
                      print("${balansFile?.path}");

                      //Install firebase_storage
                      //Import the library
                      if(balansFile==null) return;

                      //Import dart:core
                      String uniqueBFileName =("b"+ DateTime.now().millisecondsSinceEpoch.toString()) ;

                      //Get a reference to storage root
                      Reference referenceRoot = FirebaseStorage.instance.ref();
                      Reference referenceDirImages =
                      referenceRoot.child('balansImages');

                      //Create a reference for the image to be stored
                      Reference referenceImageToUpload =
                      referenceDirImages.child(uniqueBFileName);

                      try {
                        // Store the file
                        await referenceImageToUpload.putFile(File(balansFile!.path));
                        // Success: get the download URL
                        balansImageUrl = await referenceImageToUpload.getDownloadURL();
                        print("Image URL: $balansImageUrl"); // Add this line for debugging
                      } catch (error) {
                        // Some error occurred
                        print("Error uploading image: $error"); // Add this line for debugging
                      }

                    }, icon: Icon(Icons.camera_alt),iconSize: 30,color: Colors.deepOrange,),Text("Balans",style: TextStyle(fontSize: 20,color: Colors.deepOrange),)]),
                  ElevatedButton(onPressed:() async {
                    _submitForm();

                    if (_formKey.currentState!.validate()) {
                      String turboNo = _controllerTurboNo.text;
                      String tarih = _controllerTarih.text;
                      String aracBilgileri = _controllerAracBilgileri.text;
                      String musteriBilgileri = _controllerMusteriBilgileri.text;
                      String musteriSikayetleri = _controllerMusteriSikayetleri.text;
                      String tespitEdilen = _controllerTespitEdilen.text;
                      String yapilanIslemler = _controllerYapilanIslemler.text;

                      // Create a Map of data
                      Map<String, String> dataToSend = {
                        "turboNo": turboNo,
                        "tarih": tarih,
                        "aracBilgileri": aracBilgileri,
                        "musteriBilgileri": musteriBilgileri,
                        "musteriSikayetleri": musteriSikayetleri,
                        "tespitEdilen": tespitEdilen,
                        "yapilanIslemler": yapilanIslemler,
                        "turboImage": turboImageUrl,
                        "katricImage": katricImageUrl,
                        "balansImage":balansImageUrl,
                      };
                      //Add a new item
                      _reference.add(dataToSend);

                    }
                  },
                    child: Text('Yükle'),
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