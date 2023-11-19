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
  var sortedEntries = yanindaGelenler.entries.toList()
    ..sort((a, b) => (friendlyNames[a.key] ?? a.key).compareTo(friendlyNames[b.key] ?? b.key));

  return Card(
    // ... existing card setup ...
    child: Column(
      children: [
        // ... existing title and divider ...
        ...sortedEntries.map((entry) {
          return _yanindaGelenlerItem(friendlyNames[entry.key] ?? entry.key, entry.value, theme);
        }).toList(),
      ],
    ),
  );
}

Widget _yanindaGelenlerItem(String name, bool isIncluded, ThemeData theme) {
  return ListTile(
    leading: Checkbox(
      value: isIncluded,
      onChanged: null, // Making the checkbox non-interactive
      activeColor: theme.primaryColor,
    ),
    title: Text(name, style: theme.textTheme.subtitle1),
  );
}

