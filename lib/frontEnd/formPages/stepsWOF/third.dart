import 'package:flutter/material.dart';
import '../../widgets/common.dart';
import '../../widgets/helperMethodsInput.dart';
import 'fourth.dart'; // Ensure this import points to your fourth page


class ThirdStepPage extends StatefulWidget {
  final Map<String, dynamic> formData; // To hold form data across steps

  const ThirdStepPage({Key? key, required this.formData}) : super(key: key);

  @override
  _ThirdStepPageState createState() => _ThirdStepPageState();
}

class _ThirdStepPageState extends State<ThirdStepPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map? yanindaGelenler;

  int currentStep = 2;
  final int totalSteps = 6;

  Map<String, bool> yanindaGelenlerState = {
    'yagGirisContasi': false,
    'yagDonusContasi': false,
    'yagGirisBorusu': false,
    'yagDonusBorusu': false,
    'yagGirisRekoru': false,
    'yagDonusRekoru': false,
    'egzozManifoldu': false,
    'egzozContalari': false,
    'katalizorDPF': false,
    'havaFiltresiBaglantiAparati': false,
    'suGirisRekorlari': false,
    'suGirisBorulari': false,
    'sicaklikSensoru': false,
    'egzozTahliyeBorusu': false,
  };

  final Map<String, String> displayNames = {
    'yagGirisContasi': 'yağ giriş contası',
    'yagDonusContasi': 'yağ dönüş contası',
    'yagGirisBorusu': 'yağ giriş borusu',
    'yagDonusBorusu': 'yağ dönüş borusu',
    'yagGirisRekoru': 'yağ giriş rekoru',
    'yagDonusRekoru': 'yağ dönüş rekoru',
    'egzozManifoldu': 'egzoz manifoldu',
    'egzozContalari': 'egzoz contaları',
    'katalizorDPF': 'katalizör / DPF',
    'havaFiltresiBaglantiAparati': 'hava filtresi bağlantı aparatı',
    'suGirisRekorlari': 'su giriş rekorları',
    'suGirisBorulari': 'su giriş boruları',
    'sicaklikSensoru': 'sıcaklık sensörü',
    'egzozTahliyeBorusu': 'egzoz tahliye borusu',
  };

  List<Widget> _buildCheckboxes(bool isTablet) {
    var sortedKeys = yanindaGelenlerState.keys.toList()..sort();

    List<Widget> rows = [];
    for (int i = 0; i < sortedKeys.length; i += 2) {
      var widgetsInRow = <Widget>[];

      widgetsInRow.add(Expanded(
        child: _buildCheckboxTile(sortedKeys[i], isTablet),
      ));

      // Add extra space between checkboxes in the same row
      if (i + 1 < sortedKeys.length) {
        widgetsInRow.add(SizedBox(width: 20)); // Adjust the width for desired spacing
        widgetsInRow.add(Expanded(
          child: _buildCheckboxTile(sortedKeys[i + 1], isTablet),
        ));
      }

      rows.add(Row(children: widgetsInRow));

      // Add space between rows
      if (i + 2 < sortedKeys.length) {
        rows.add(SizedBox(height: 15));
      }
    }

    return rows;
  }

  Widget _buildCheckboxTile(String key, bool isTablet) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8), // Adjust vertical spacing
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              displayNames[key] ?? key,
              style: TextStyle(color: Colors.white, fontSize: isTablet ? 25 : 16),
            ),
          ),
          Checkbox(
            value: yanindaGelenlerState[key],
            onChanged: (bool? value) {
              setState(() {
                yanindaGelenlerState[key] = value!;
              });
            },
            checkColor: Colors.black, // Color of tick Mark
            fillColor: MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.selected)) {
                return Colors.green; // Color when checked
              }
              return Colors.grey; // Default color
            }),
          ),
        ],
      ),
    );
  }

  void _saveAndContinue() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      yanindaGelenler = yanindaGelenlerState;
      widget.formData['yanindaGelenler'] = yanindaGelenler;
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => FourthStepPage(formData: widget.formData),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;

    return Scaffold(
      appBar: appBar(context, "Turboyla Gelenler"),
      bottomNavigationBar: bottomNav(context),
      body: Stack(
        children: [
          background(context),
          SingleChildScrollView(
            padding: EdgeInsets.all(isTablet ? 100 : 16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      totalSteps,
                          (index) => buildStepDot(isSelected: index == currentStep),
                    ),
                  ),
                  SizedBox(height: 20),
                  ..._buildCheckboxes(isTablet),
                  SizedBox(height: 20),
                  Row(mainAxisAlignment:MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: _saveAndContinue,
                          child: Text(
                            'Devam',
                            style: TextStyle(fontSize: isTablet ? 30 : 16, fontWeight: FontWeight.bold, color: Colors.black), // Text styling
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.cyanAccent, // Button color
                            onPrimary: Colors.black, // Text color when button is pressed
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 5,
                            padding: EdgeInsets.symmetric(horizontal: 30, vertical: isTablet ? 20 : 15),
                          ),
                        ),
                      ]
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}