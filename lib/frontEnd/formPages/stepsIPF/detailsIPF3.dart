import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:turboapp/backEnd/models/inProgressForm_model.dart';
import 'package:turboapp/frontEnd/formPages/outputIPF.dart';
import 'package:turboapp/frontEnd/widgets/common.dart';
import 'package:turboapp/frontEnd/widgets/helperMethodsDetails.dart';

import '../../../backEnd/repositories/inProgressForm_repo.dart';


class DetailsIPF3Page extends StatefulWidget {
  final InProgressFormModel formIPF;
  DetailsIPF3Page({required this.formIPF});

  @override
  _DetailsIPF3PageState createState() => _DetailsIPF3PageState();
}

class _DetailsIPF3PageState extends State<DetailsIPF3Page> {
  TextEditingController _controllerTurboImageUrl = TextEditingController();
  TextEditingController _controllerKatricImageUrl = TextEditingController();
  TextEditingController _controllerBalansImageUrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize controllers with initial values from widget.formIPF
    _controllerTurboImageUrl.text = widget.formIPF.turboImageUrl;
    _controllerKatricImageUrl.text = widget.formIPF.katricImageUrl;
    _controllerBalansImageUrl.text = widget.formIPF.balansImageUrl;
    // ... other initializations ...
  }

  Future<void> _saveChanges() async {

    // Save the updated model to Firebase
    await InProgressFormRepo.instance.updateInProgressForm(widget.formIPF.id!, widget.formIPF);

    Navigator.of(context).pop(); // Close the dialog
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => OutputIPFPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, "Detaylar"),
      bottomNavigationBar: bottomNav(),
      body: SafeArea(
          child: Stack(
              children: [
                background(context),
                SingleChildScrollView( child:
                Column(
                  children: [ Row( children: [
                    photoButton(
                        context, 'Turbo Fotoğrafı Göster', showTurboImage),
                    SizedBox(width: 41,),
                    ElevatedButton.icon(
                      icon: Icon(Icons.camera_alt),
                      label: Text('Güncelle/Çek'),
                      onPressed: () => pickAndUpdateImage('turbo'),
                    ),]),
                    Row( children: [
                      photoButton(
                          context, 'Katriç Fotoğrafı Göster', showKatricImage),
                      SizedBox(width: 40,),
                      ElevatedButton.icon(
                        icon: Icon(Icons.camera_alt),
                        label: Text('Güncelle/Çek'),
                        onPressed: () => pickAndUpdateImage('katric'),
                      ),]),
                    Row( children: [
                      photoButton(
                          context, 'Balans Fotoğrafı Göster', showBalansImage),
                      SizedBox(width: 35,),
                      ElevatedButton.icon(
                        icon: Icon(Icons.camera_alt),
                        label: Text('Güncelle/Çek'),
                        onPressed: () => pickAndUpdateImage('balans'),
                      ),]),
                    SizedBox(height: 20,),
                    ElevatedButton(
                      onPressed: () => showSaveAlertDialog(context, _saveChanges, OutputIPFPage()),
                      child: Text(
                        'Bitir',
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
                    ),
                    SizedBox(height: 30,),
                    ElevatedButton(
                      onPressed: () => _confirmDeleteForm(),
                      child: Text(
                        'Formu Sil',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red, // Button color
                        onPrimary: Colors.white, // Text color when button is pressed
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 5,
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      ),
                    ),
                  ],
                ),),
              ]
          ),
      ),
    );
  }

  Future<void> _confirmDeleteForm() async {
    final confirmed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Form Silinecek"),
          content: Text("Formu silmek istediğinize emin misiniz?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Cancel the delete operation
              },
              child: Text("Vazgeç"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Confirm the delete operation
              },
              child: Text("Sil"),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      // Call the deleteWorkOrderForm method to delete the form
      try {
        await InProgressFormRepo.instance.deleteInProgressForm(widget.formIPF.id!);
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => OutputIPFPage())); // Close the page after successful deletion
      } catch (e) {
        Get.snackbar("Form Silinemedi", "Failed to delete form: $e", backgroundColor: Colors.red);
      }
    }
  }


  Future<void> pickAndUpdateImage(String imageType) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera, imageQuality: 10);

    if (image == null || image.path == "null") {
      print('No image selected.');
      return;
    }

    File imageFile = File(image.path);
    String fileName = '$imageType-${DateTime.now().millisecondsSinceEpoch}.jpg';

      // Upload new image to Firebase Storage
      Reference ref = FirebaseStorage.instance.ref().child('images/$fileName');
      await ref.putFile(imageFile);

      // Get the download URL of the new image
      String downloadURL = await ref.getDownloadURL();

      // Update the corresponding image URL in the model and Firestore database
      setState(() {
        widget.formIPF.setImageUrl(imageType, downloadURL);
      });
      await InProgressFormRepo.instance.updateInProgressForm(widget.formIPF.id!, widget.formIPF);
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
                child: Text('Kapat'),
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
            title: Text('Hata'),
            content: Text('Fotoğraf Bulunamadı !'), // Display error message
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Kapat'),
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
                child: Text('Kapat'),
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