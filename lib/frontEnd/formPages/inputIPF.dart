import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../widgets/common.dart';
import 'package:turboapp/BackEnd/Repositories/inProgressForm_repo.dart';
import 'package:turboapp/BackEnd/Models/inProgressForm_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:turboapp/frontEnd/utils/customColors.dart';
import 'package:turboapp/frontEnd/widgets/helperMethodsInput.dart';

class InputIPFPage extends StatefulWidget {
  const InputIPFPage({Key? key}) : super(key: key);

  @override
  State<InputIPFPage> createState() => _InputIPFPageState();
}

class _InputIPFPageState extends State<InputIPFPage> {


  TextEditingController _controllerTurboNo = TextEditingController();
  TextEditingController _controllertarihIPF = TextEditingController();
  TextEditingController _controllerAracBilgileri = TextEditingController();
  TextEditingController _controllerMusteriBilgileri = TextEditingController();
  TextEditingController _controllerMusteriSikayetleri = TextEditingController();
  TextEditingController _controllerTespitEdilen = TextEditingController();
  TextEditingController _controllerYapilanIslemler = TextEditingController();


  GlobalKey<FormState> key = GlobalKey();

  bool isImagePickerActive = false;


  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _inProgressFormRepo = InProgressFormRepo.instance;

  int? turboNo;
  DateTime? tarihIPF;
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
    tarihIPF = DateTime.now();
  }


  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (turboImageUrl.isEmpty) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Turbo Fotoğrafı Yükleyin')));
        return; // Exit the function without uploading to Firestore
      }
      if (katricImageUrl.isEmpty) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Katric Fotoğrafı Yükleyin')));
        return; // Exit the function without uploading to Firestore
      }
      if (balansImageUrl.isEmpty) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Balans Fotoğrafı Yükleyin')));
        return; // Exit the function without uploading to Firestore
      }

      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {

        // Create an instance of InProgressFormModel with the entered data
        final inProgressForm = InProgressFormModel(
          turboNo: turboNo!,
          tarihIPF: tarihIPF!,
          aracBilgileri: aracBilgileri!,
          musteriBilgileri: musteriBilgileri!,
          musteriSikayetleri: musteriSikayetleri!,
          tespitEdilen: tespitEdilen!,
          yapilanIslemler: yapilanIslemler!,
          turboImageUrl: turboImageUrl!,
          katricImageUrl: katricImageUrl!,
          balansImageUrl: balansImageUrl!,

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

      }
    }
  }

  Future<void> pickImage(ImageSource source, String type) async {
    if (isImagePickerActive) {
      return;
    }

    isImagePickerActive = true;

    ImagePicker imagePicker = ImagePicker();
    XFile? imageFile = await imagePicker.pickImage(source: source, imageQuality: 10);

    if (imageFile != null) {
      String fileName = type + DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('${type}Images/$fileName');

      try {
        await storageReference.putFile(File(imageFile.path));
        String imageUrl = await storageReference.getDownloadURL();

        // Update the state with the new image URL
        setState(() {
          if (type == 't') {
            turboImageUrl = imageUrl;
          } else if (type == 'k') {
            katricImageUrl = imageUrl;
          } else if (type == 'b') {
            balansImageUrl = imageUrl;
          }
        });
      } catch (e) {
        print("Error uploading image: $e");
      }
    }

    isImagePickerActive = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, "     SÜREÇ"),
      bottomNavigationBar: bottomNav(),
      body: Stack(
        children: [
          background(context),
          SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  buildDatePickerFormField(
                    context: context,
                    labelText: 'Süreç Başlama Tarihi',
                    errorText: 'Tarih girin',
                    onSave: (DateTime value) {
                      tarihIPF = value; // Directly save the DateTime value
                    },
                  ),
                  buildTextFormField(
                    labelText: 'Turbo No',
                    errorText: 'Lütfen turbo no girin',
                    onSave: (value) => turboNo = int.tryParse(value!),
                    keyboardType: TextInputType.number,
                  ),
                  buildTextFormField(
                    labelText: 'Araç Bilgileri',
                    errorText: 'Lütfen araç bilgisi girin',
                    onSave: (value) => aracBilgileri = value,
                  ),
                  buildTextFormField(
                    labelText: 'Müşteri Bilgileri',
                    errorText: 'Lütfen müşteri bilgisi girin',
                    onSave: (value) => musteriBilgileri = value,
                  ),
                  buildTextFormField(
                    labelText: 'Müşteri Şikayetleri',
                    errorText: 'Lütfen müşteri şikayeti girin',
                    onSave: (value) => musteriSikayetleri = value,
                  ),
                  buildTextFormField(
                    labelText: 'Tespit Edilen',
                    errorText: 'Lütfen tespit edileni girin',
                    onSave: (value) => tespitEdilen = value,
                  ),
                  buildTextFormField(
                    labelText: 'Yapılan İşlemler',
                    errorText: 'Lütfen yapılan işlemleri girin',
                    onSave: (value) => yapilanIslemler = value,
                  ),
                  SizedBox(height: 20,),
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

                  }, icon: Icon(Icons.camera_alt),iconSize: 30,color: CustomColors.loginButtonTextColor,),
                    Text("Turbo",style: TextStyle(fontSize: 20,color: Colors.white),)]),

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

                    }, icon: Icon(Icons.camera_alt),iconSize: 30,color: CustomColors.loginButtonTextColor,),
                      Text("Katric",style: TextStyle(fontSize: 20,color: Colors.white,),)]),

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

                    }, icon: Icon(Icons.camera_alt),iconSize: 30,color: CustomColors.loginButtonTextColor,),
                      Text("Balans",style: TextStyle(fontSize: 20,color: Colors.white))]),

                  SizedBox(height: 20,),
                    ElevatedButton(onPressed:() async {

                    if (_formKey.currentState!.validate()) {
                      String turboNo = _controllerTurboNo.text;
                      String aracBilgileri = _controllerAracBilgileri.text;
                      String musteriBilgileri = _controllerMusteriBilgileri.text;
                      String musteriSikayetleri = _controllerMusteriSikayetleri.text;
                      String tespitEdilen = _controllerTespitEdilen.text;
                      String yapilanIslemler = _controllerYapilanIslemler.text;

                      // Create a Map of data
                      Map<String, String> dataToSend = {
                        "turboNo": turboNo,
                        "aracBilgileri": aracBilgileri,
                        "musteriBilgileri": musteriBilgileri,
                        "musteriSikayetleri": musteriSikayetleri,
                        "tespitEdilen": tespitEdilen,
                        "yapilanIslemler": yapilanIslemler,
                        "turboImage": turboImageUrl,
                        "katricImage": katricImageUrl,
                        "balansImage":balansImageUrl,
                      };

                    }
                    _submitForm();
                  },
                    child: Text('Yükle', style: TextStyle(color: Colors.redAccent),),
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        primary: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                        textStyle: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(height: 10,),
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
