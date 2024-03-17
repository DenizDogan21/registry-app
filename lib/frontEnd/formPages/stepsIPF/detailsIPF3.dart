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
    loadFlowPhotos();
  }

  Future<void> loadFlowPhotos() async {
    try {
      // Fetch flow photos from the database
      List<FlowPhoto> flowPhotos = await InProgressFormRepo.instance.getFlowPhotos(widget.formIPF.id!);

      // Update the formIPF with the fetched flow photos
      setState(() {
        widget.formIPF.flowPhotos = flowPhotos;
      });
    } catch (e) {
      print('Error loading flow photos: $e');
      // Handle error
    }
  }

  Future<void> _saveChanges() async {

    // Save the updated model to Firebase
    await InProgressFormRepo.instance.updateInProgressForm(widget.formIPF.id!, widget.formIPF);

    Navigator.of(context).pop(); // Close the dialog
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => OutputIPFPage()));
  }


  void showFlowPhoto(BuildContext context, int index) {
    final imageUrl = widget.formIPF.flowPhotos[index].flowImageUrl;
    String notes = widget.formIPF.flowPhotos[index].flowNotes;

    TextEditingController notesController = TextEditingController(text: notes);

    if (imageUrl != null && imageUrl.isNotEmpty && imageUrl != "null") {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Yüklenen Flow Fotoğrafı'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  Image.network(imageUrl),
                  TextField(
                    controller: notesController,
                    decoration: InputDecoration(labelText: 'Notlar'),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Kapat'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // Show confirmation dialog before deleting
                  _confirmDeleteFlowPhoto(index);
                },
                child: Text('Sil'),
              ),
              TextButton(
                onPressed: () {
                  // Update notes in the model
                  setState(() {
                    widget.formIPF.flowPhotos[index].flowNotes = notesController.text;
                  });
                  // Update the Firestore database
                  InProgressFormRepo.instance.updateInProgressForm(widget.formIPF.id!, widget.formIPF);
                  Navigator.of(context).pop();
                },
                child: Text('Kaydet'),
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


  void _confirmDeleteFlowPhoto(int index) async {
    final confirmed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Flow Fotoğrafı Silinecek"),
          content: Text("Flow fotoğrafını silmek istediğinize emin misiniz?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Cancel the delete operation
              },
              child: Text("Vazgeç"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(true); // Confirm the delete operation

                // Delete the flow photo from Firebase Storage
                String imageUrl = widget.formIPF.flowPhotos[index].flowImageUrl;
                if (imageUrl != null && imageUrl.isNotEmpty && imageUrl != "null") {
                  try {
                    Reference imageRef = FirebaseStorage.instance.refFromURL(imageUrl);
                    await imageRef.delete();
                  } catch (e) {
                    print("Error deleting image from Firebase Storage: $e");
                    // Handle error if needed
                  }
                }

                // Remove the flow photo from the model
                setState(() {
                  widget.formIPF.flowPhotos.removeAt(index);
                });

                // Update the Firestore database
                await InProgressFormRepo.instance.updateInProgressForm(widget.formIPF.id!, widget.formIPF);

                // Show a snack bar or any other feedback to the user
                Get.snackbar("Silme Başarılı", "Flow fotoğrafı silindi", backgroundColor: Colors.green);
              },
              child: Text("Sil"),
            ),
          ],
        );
      },
    );

    // Handle confirmed deletion
    if (confirmed == true) {
      // Perform the deletion
    }
  }


  Widget updateFlowPhotoButton(BuildContext context,double updateFlowPhotoButtonSize) {
    return ElevatedButton.icon(
      icon: Icon(Icons.camera_alt),
      label: Text('Flow Fotoğrafı Ekle',style: TextStyle(fontSize: updateFlowPhotoButtonSize*0.75),),
      onPressed: () => pickAndUpdateFlowPhoto(context),
      style: ElevatedButton.styleFrom(
        primary: Colors.cyanAccent,
        onPrimary: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 5,
        padding: EdgeInsets.symmetric(
          horizontal: updateFlowPhotoButtonSize,
          vertical: updateFlowPhotoButtonSize,
        ),
      ),
    );
  }


  void pickAndUpdateFlowPhoto(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera, imageQuality: 10);

    if (image == null || image.path == "null") {
      print('No image selected.');
      return;
    }

    File imageFile = File(image.path);
    String fileName = 'flow-${DateTime.now().millisecondsSinceEpoch}.jpg';

    // Upload new image to Firebase Storage
    Reference ref = FirebaseStorage.instance.ref().child('images/$fileName');
    await ref.putFile(imageFile);

    // Get the download URL of the new image
    String downloadURL = await ref.getDownloadURL();

    // Update the corresponding flow photo in the model and Firestore database
    setState(() {
      widget.formIPF.flowPhotos.add(
        FlowPhoto(flowImageUrl: downloadURL, flowNotes: ''),
      );
    });
    await InProgressFormRepo.instance.updateInProgressForm(widget.formIPF.id!, widget.formIPF);
  }


  List<Widget> generateFlowPhotoButtons(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;
    List<Widget> buttons = [];
    buttons.add(updateFlowPhotoButton(context, isTablet ? 32:16));

    for (int i = 1; i <= widget.formIPF.flowPhotos.length; i++) {
      buttons.add(
        Padding(
          padding: EdgeInsets.all(isTablet ? 20: 10), // Adjust the padding as needed
          child: ElevatedButton(
            onPressed: () => showFlowPhoto(context, i - 1),
            child: Text('$i. Flow Fotoğrafı ', style: TextStyle(fontSize: isTablet ? 32:16),),
            style: ElevatedButton.styleFrom(
              primary: Colors.orange, // Customize button color
              onPrimary: Colors.black, // Customize text color
              padding: EdgeInsets.symmetric(horizontal: isTablet ? 30: 15, vertical: isTablet ? 10: 5),
            ),
          ),
        ),
      );
    }

    return buttons;
  }





  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;
    return Scaffold(
      appBar: appBar(context, "Süreç Formu |||"),
      bottomNavigationBar: bottomNav(context),
      body: SafeArea(
        child: Stack(
          children: [
            background2(context),
            SingleChildScrollView(padding: EdgeInsets.all(isTablet ? 64 : 16),
              child:
            Column(
              children: [ Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    photoButton(
                        context, 'Turbo Fotoğrafı Göster', showTurboImage, isTablet ? 32:14),
                    isTablet ? SizedBox(width: 60,): SizedBox(width: 30,),
                    updatePhotoButton(context, "turbo",isTablet ? 32:14)]),
                Row( mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      photoButton(
                          context, 'Katriç Fotoğrafı Göster', showKatricImage, isTablet ? 32:14),
                      isTablet ? SizedBox(width: 60,): SizedBox(width: 30,),
                      updatePhotoButton(context, "katric",isTablet ? 32:14),]),
                Row( mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      photoButton(
                          context, 'Balans Fotoğrafı Göster ', showBalansImage, isTablet ? 32:14),
                      isTablet ? SizedBox(width: 50,): SizedBox(width: 25,),
                      updatePhotoButton(context, "balans",isTablet ? 32:14)]),
                SizedBox(height: 20,),
                // Dynamically generate buttons based on the number of flow photos
                ...generateFlowPhotoButtons(context),


                isTablet ? SizedBox(height: 60,):SizedBox(height: 30,),
                ElevatedButton(
                  onPressed: () => showSaveAlertDialog(context, _saveChanges, OutputIPFPage()),
                  child: Text(
                    'Bitir',
                    style: TextStyle(fontSize: isTablet ? 32:16, fontWeight: FontWeight.bold, color: Colors.black), // Text styling
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.cyanAccent, // Button color
                    onPrimary: Colors.black, // Text color when button is pressed
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 5,
                    padding: EdgeInsets.symmetric(horizontal: isTablet ? 60: 30, vertical: isTablet ? 30: 15),
                  ),
                ),
                isTablet ? SizedBox(height: 60,):SizedBox(height: 30,),
                ElevatedButton(
                  onPressed: () => _confirmDeleteForm(),
                  child: Text(
                    'Formu Sil',
                    style: TextStyle(fontSize: isTablet ? 32:16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red, // Button color
                    onPrimary: Colors.white, // Text color when button is pressed
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 5,
                    padding: EdgeInsets.symmetric(horizontal: isTablet ? 60: 30, vertical: isTablet ? 15:10),
                  ),
                ),
              ],
            ),),
          ],
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

  void pickAndUpdateImage(String imageType) async {
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

    // Delete the old image from Firebase Storage if it exists
    String oldImageUrl = widget.formIPF.getImageUrl(imageType) ?? "";
    if (oldImageUrl.isNotEmpty && oldImageUrl != "null") {
      try {
        Reference oldImageRef = FirebaseStorage.instance.refFromURL(oldImageUrl);
        await oldImageRef.delete();
      } catch (e) {
        print("Error deleting old image: $e");
      }
    }

    // Update the corresponding image URL in the model and Firestore database
    setState(() {
      widget.formIPF.setImageUrl(imageType, downloadURL);
    });
    await InProgressFormRepo.instance.updateInProgressForm(widget.formIPF.id!, widget.formIPF);
  }

  Widget updatePhotoButton(BuildContext context, String text,double updatePhotoButtonSize) {
    return ElevatedButton.icon(
      icon: Icon(Icons.camera_alt),
      label: Text('Güncelle/Çek',style: TextStyle(fontSize: updatePhotoButtonSize*0.75)),
      onPressed: () => pickAndUpdateImage(text),
      style: ElevatedButton.styleFrom(
        primary: Colors.cyanAccent,
        onPrimary: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 5,
        padding: EdgeInsets.symmetric(
          horizontal: updatePhotoButtonSize, // Adjust as needed
          vertical: updatePhotoButtonSize,
        ),
      ),
    );
  }

  Widget photoButton(BuildContext context, String text, Function showImage,double photoButtonSize) {
    return Padding(
      padding:  EdgeInsets.symmetric(vertical: photoButtonSize/2),
      child: ElevatedButton.icon(
        icon: Icon(Icons.image, color: Colors.white),
        label: Text(text,style: TextStyle(fontSize: photoButtonSize*0.75),),
        onPressed: () => showImage(context),  // <-- Error is here
        style: ElevatedButton.styleFrom(
          primary: Colors.redAccent,
          onPrimary: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.01,
            vertical: photoButtonSize,
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