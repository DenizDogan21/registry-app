import 'package:flutter/material.dart';
import 'package:turboapp/backEnd/models/inProgressForm_model.dart';
import 'package:turboapp/frontEnd/widgets/common.dart';
import 'package:turboapp/frontEnd/widgets/helperMethodsDetails.dart';

import '../../../backEnd/repositories/accountingForm_repo.dart';
import '../../../backEnd/repositories/inProgressForm_repo.dart';
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
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with initial values from widget.formIPF
    _controllerTespitEdilen.text = widget.formIPF.tespitEdilen;
    _controllerYapilanIslemler.text = widget.formIPF.yapilanIslemler;

    // Listen to changes in text fields to determine if there are any modifications
    _controllerTespitEdilen.addListener(_onTextChanged);
    _controllerYapilanIslemler.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    // Check if the current values are different from the initial values
    bool hasChanges = _controllerTespitEdilen.text != widget.formIPF.tespitEdilen ||
        _controllerYapilanIslemler.text != widget.formIPF.yapilanIslemler;

    // Update the _hasChanges variable
    setState(() {
      _hasChanges = hasChanges;
    });
  }

  Future<void> _saveChanges() async {
    // Check if there are any changes before saving
    if (_hasChanges) {
      widget.formIPF.tespitEdilen = _controllerTespitEdilen.text;
      widget.formIPF.yapilanIslemler = _controllerYapilanIslemler.text;

      // Save the updated model to Firebase
      await InProgressFormRepo.instance.updateInProgressForm(widget.formIPF.id!, widget.formIPF);
      var accountingForm = await AccountingFormRepo.instance.getFormByEgeTurboNo(widget.formIPF.egeTurboNo);
      if (accountingForm != null) {
        accountingForm.tespitEdilen = widget.formIPF.tespitEdilen;
        accountingForm.yapilanIslemler = widget.formIPF.yapilanIslemler;

        // Save the updated accounting model to Firebase
        await AccountingFormRepo.instance.updateAccountingForm(accountingForm.id!, accountingForm);
      }
    }

    Navigator.of(context).pop(); // Close the dialog
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => DetailsIPF3Page(formIPF: widget.formIPF)));

  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;
    return Scaffold(
      appBar: appBar(context, "Süreç Formu ||"),
      bottomNavigationBar: bottomNav(context),
      body: SafeArea(
          child: Stack(
              children: [
                background2(context),
                SingleChildScrollView(padding: EdgeInsets.all(isTablet ? 64 : 16),
                 child:
                Column(
                  children: [
                    CustomTextField(
                      controller: _controllerTespitEdilen,
                      label: 'Tespit Edilen',
                      fieldSize: isTablet ? 30: 20,
                      // ... other properties ...
                    ),
                    CustomTextField(
                      controller: _controllerYapilanIslemler,
                      label: 'Yapılan İşlemler',
                      fieldSize: isTablet ? 30: 20,
                      // ... other properties ...
                    ),
                    isTablet ? SizedBox(height: 60,):SizedBox(height: 30,),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children :[
                    ElevatedButton(
                      onPressed: () {
                        if (_hasChanges) {
                          showSaveAlertDialog(context, _saveChanges, DetailsIPF3Page(formIPF: widget.formIPF));
                        } else {
                          // If no changes, navigate directly to the next page
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => DetailsIPF3Page(formIPF: widget.formIPF)));
                        }
                      },
                      child: Text(
                        'Devam',
                        style: TextStyle(fontSize: isTablet ? 32:16, fontWeight: FontWeight.bold, color: Colors.black), // Text styling
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.cyanAccent,
                        onPrimary: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 5,
                        padding: EdgeInsets.symmetric(horizontal:isTablet ?  60:30, vertical: isTablet ?  30:15,),
                      ),
                    ),])
                  ],
                ),)])
      ),
    );
  }
}
