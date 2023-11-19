import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/common.dart';
import 'package:turboapp/BackEnd/Repositories/inProgressForm_repo.dart';
import 'package:turboapp/BackEnd/Models/inProgressForm_model.dart';
import 'package:turboapp/frontEnd/utils/customTextStyle.dart';

import 'detailsIPF.dart';

class OutputIPFPage extends StatefulWidget {
  const OutputIPFPage({Key? key}) : super(key: key);

  @override
  State<OutputIPFPage> createState() => _OutputIPFPageState();
}

class _OutputIPFPageState extends State<OutputIPFPage> {
  final _inProgressFormRepo = InProgressFormRepo.instance;
  late List<InProgressFormModel> _forms;
  late List<InProgressFormModel> _filteredForms;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _forms = [];
    _filteredForms = [];
    _getInProgressForms();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _filterForms(_searchController.text);
  }

  void _getInProgressForms() async {
    try {
      final forms = await _inProgressFormRepo.getInProgressForms();
      forms.sort((a, b) => b.tarihIPF.compareTo(a.tarihIPF));
      setState(() {
        _forms = forms;
        _filteredForms = forms;
      });
    } catch (error) {
      print('Error: $error');
    }
  }


  void _filterForms(String keyword) {
    Future.delayed(Duration.zero, () {
      setState(() {
        if (keyword.isNotEmpty) {
          _filteredForms = _forms.where((form) {
            final turboNoString = form.turboNo.toString().toLowerCase();
            final keywordLower = keyword.toLowerCase();
            return turboNoString.contains(keywordLower) ||
                form.aracBilgileri.toLowerCase().contains(keywordLower) ||
                form.musteriBilgileri.toLowerCase().contains(keywordLower) ||
                form.musteriSikayetleri.toLowerCase().contains(keywordLower) ||
                form.tespitEdilen.toLowerCase().contains(keywordLower) ||
                form.yapilanIslemler.toLowerCase().contains(keywordLower);
          }).toList();

        } else {
          _filteredForms = _forms;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade900,
        title: TextField(
          controller: _searchController,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Ara...",
            hintStyle: TextStyle(color: Colors.white),
            border: InputBorder.none,
          ),
          onChanged: (value) => _filterForms(value),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.cancel),
            onPressed: () {
              // Clear the search field
              _searchController.clear();
            },
          ),
        ],
      ),
      bottomNavigationBar: bottomNav(), // Make sure this is the same as in OutputWOFPage
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.1, 0.9],
            colors: [
              Colors.grey.shade800,
              Colors.black87,
            ],
          ),
        ),
        child: _filteredForms.isEmpty
            ? Center(child: Text('Kayıt Bulunamadı', style: TextStyle(color: Colors.white)))
            : ListView.separated(
          itemCount: _filteredForms.length,
          separatorBuilder: (context, index) => Divider(color: Colors.grey.shade600),
          itemBuilder: (context, index) {
            final form = _filteredForms[index];
            return ListTileTheme(
              textColor: Colors.white,
              iconColor: Colors.cyanAccent,
              child: ListTile(
                leading: Icon(Icons.build_circle_outlined),
                title: Text('${formatDate(form.tarihIPF)}', style: CustomTextStyle.outputTitleTextStyle),
                subtitle: Text('Turbo No: ${form.turboNo}', style: CustomTextStyle.outputListTextStyle),
                trailing: Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => DetailsIPFPage(formIPF: form),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
  String formatDate(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd – HH:mm').format(dateTime);
  }
}

