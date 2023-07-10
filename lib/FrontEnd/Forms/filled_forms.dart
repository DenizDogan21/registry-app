import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../BackEnd/Database/database_helper.dart';
import 'form_model.dart';

class FilledFormsPage extends StatefulWidget {
  @override
  _FilledFormsPageState createState() => _FilledFormsPageState();
}

class _FilledFormsPageState extends State<FilledFormsPage> {
  List<FormData> _forms = [];

  @override
  void initState() {
    super.initState();
    _loadForms();
  }

  void _loadForms() async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    List<FormData> forms = await databaseHelper.getAllForms();
    setState(() {
      _forms = forms;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filled Forms'),
      ),
      body: ListView.builder(
        itemCount: _forms.length,
        itemBuilder: (context, index) {
          FormData formData = _forms[index];
          return ListTile(
            title: Text('Turbo No: ${formData.turboNo.toString()}'),
            subtitle: Text('Tarih: ${formData.tarih.toString()}'),
            // Add more fields to display in the list
          );
        },
      ),
    );
  }
}
