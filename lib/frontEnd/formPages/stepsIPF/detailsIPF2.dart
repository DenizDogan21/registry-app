import 'package:flutter/material.dart';
import 'package:turboapp/BackEnd/Models/inProgressForm_model.dart';
import 'package:turboapp/frontEnd/widgets/common.dart';
import 'package:turboapp/frontEnd/widgets/helperMethodsDetails.dart';

import '../../../BackEnd/Repositories/inProgressForm_repo.dart';
import '../../utils/customTextField.dart';
import 'detailsIPF3.dart';

class DetailsIPF2 extends StatefulWidget {
  final InProgressFormModel formIPF;
  DetailsIPF2({required this.formIPF});

  @override
  _DetailsIPF2State createState() => _DetailsIPF2State();
}

class _DetailsIPF2State extends State<DetailsIPF2> {
  TextEditingController _controllerTespitEdilen = TextEditingController();
  TextEditingController _controllerYapilanIslemler = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize controllers with initial values from widget.formIPF
    _controllerTespitEdilen.text = widget.formIPF.tespitEdilen;
    _controllerYapilanIslemler.text = widget.formIPF.yapilanIslemler;
    // ... other initializations ...
  }

  Future<void> _saveChanges() async {
    widget.formIPF.tespitEdilen = _controllerTespitEdilen.text;
    widget.formIPF.yapilanIslemler = _controllerYapilanIslemler.text;

    // Save the updated model to Firebase
    await InProgressFormRepo.instance.updateInProgressForm(widget.formIPF.id!, widget.formIPF);

    Navigator.of(context).pop(); // Close the dialog
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => DetailsIPF3(formIPF: widget.formIPF)));
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
                  children: [
                    CustomTextField(
                      controller: _controllerTespitEdilen,
                      label: 'Tespit Edilen',
                      // ... other properties ...
                    ),
                    CustomTextField(
                      controller: _controllerYapilanIslemler,
                      label: 'Yapılan İşlemler',
                      // ... other properties ...
                    ),
                    ElevatedButton(
                      onPressed: () => showSaveAlertDialog(context, _saveChanges, DetailsIPF3(formIPF: widget.formIPF)),
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
                    ),
                  ],
                ),)])
      ),
    );
  }
}
