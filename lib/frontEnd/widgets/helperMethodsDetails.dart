import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/customTextStyle.dart';
import 'package:turboapp/BackEnd/Models/inProgressForm_model.dart';

//WOF and IPF
Widget dateSection(ThemeData theme, String date) {
  // Parse the string date if it's not already a DateTime object
  DateTime parsedDate = DateTime.tryParse(date) ?? DateTime.now();

  // Format the date without seconds and milliseconds
  String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(parsedDate);

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Text(
      formattedDate,
      style: CustomTextStyle.appBarTextStyle,
    ),
  );
}

Widget detailSection(String title, String content, ThemeData theme) {
  return Card(
    margin: const EdgeInsets.symmetric(vertical: 10.0),
    child: ListTile(
      title: Text(title, style: theme.textTheme.subtitle1),
      subtitle: Text(content, style: theme.textTheme.bodyText1),
    ),
  );
}

//WOF
final Map<String, String> friendlyNames = {
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

Widget buildYanindaGelenlerSection(Map<String, bool> yanindaGelenler, ThemeData theme) {
  // Filter and concatenate the friendly names of the included items into a string
  String includedItems = yanindaGelenler.entries
      .where((entry) => entry.value)
      .map((entry) => friendlyNames[entry.key] ?? entry.key)
      .join(', ');

  return includedItems.isNotEmpty
      ? Card(
    margin: const EdgeInsets.symmetric(vertical: 10.0),
    child: ListTile(
      title: Text('Yanında Gelenler:', style: theme.textTheme.subtitle1),
      subtitle: Text(includedItems, style: theme.textTheme.bodyText1),
    ),
  )
      : SizedBox.shrink(); // Return an empty widget if there are no included items
}


void showSaveAlertDialog(BuildContext context, VoidCallback onSave, Widget nextPage) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Değişiklikleri Kaydet'),
        content: Text('Bu değişiklikleri kaydetmek istiyor musunuz?'),
        actions: <Widget>[
          TextButton(
            child: Text('Vazgeç'),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => nextPage));
            },
          ),
          TextButton(
            child: Text('Kaydet'),
            onPressed: onSave,
          ),
        ],
      );
    },
  );
}