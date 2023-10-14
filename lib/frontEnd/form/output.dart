import 'package:flutter/material.dart';
import '../widgets/common.dart';
import 'package:turboapp/BackEnd/Repositories/inProgressForm_repo.dart';
import 'package:turboapp/BackEnd/Models/inProgressForm_model.dart';

import 'details.dart';

class OutputPage extends StatefulWidget {
  const OutputPage({Key? key}) : super(key: key);

  @override
  State<OutputPage> createState() => _OutputPageState();
}

class _OutputPageState extends State<OutputPage> {
  final _inProgressFormRepo = InProgressFormRepo.instance;
  late List<InProgressFormModel> _forms;
  late List<InProgressFormModel> _filteredForms;

  @override
  void initState() {
    super.initState();
    _forms = [];
    _filteredForms = [];
    _getInProgressForms();
  }

  void _getInProgressForms() async {
    try {
      final forms = await _inProgressFormRepo.getInProgressForms();
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
        backgroundColor: Colors.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("Kaydettiğim İş Emirleri  "),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: _SearchDelegate(_filterForms),
                );
              },
            ),
          ],
        ),
      ),

      bottomNavigationBar: bottomNav(context),
      body: Stack(
        children: [
          background(context),
          if (_filteredForms.isEmpty)
            Center(child: Text('Kayıtlı Form Bulunamadı'))
          else
            ListView.builder(
              itemCount: _filteredForms.length,
              itemBuilder: (context, index) {
                final form = _filteredForms[index];
                return ListTile(
                  title: Text('Tarih: ${form.tarih.toString()}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Turbo No: ${form.turboNo}'),
                      Text('Araç Bilgileri: ${form.aracBilgileri}'),
                      Text('Müşteri Bilgileri: ${form.musteriBilgileri}'),
                      Text('Müşteri Şikayetleri: ${form.musteriSikayetleri}'),
                      Text('Tespit Edilen: ${form.tespitEdilen}'),
                      Text('Yapılan İşlemler: ${form.yapilanIslemler}'),
                    ],
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => FormDetailsPage(form: form),
                      ),
                    );
                  },
                  // Display other form data as desired
                );
              },
            ),
        ],
      ),
    );
  }
}

class _SearchDelegate extends SearchDelegate<String> {
  final Function(String) onSearch;

  _SearchDelegate(this.onSearch);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
          onSearch(query);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    onSearch(query);
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
