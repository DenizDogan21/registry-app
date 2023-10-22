import 'package:flutter/material.dart';
import '../../BackEnd/Models/workOrderForm_model.dart';
import '../../BackEnd/Repositories/workOrderForm_repo.dart';
import '../widgets/common.dart';
import 'detailsWOF.dart';

class OutputWOFPage extends StatefulWidget {
  const OutputWOFPage({Key? key}) : super(key: key);

  @override
  State<OutputWOFPage> createState() => _OutputWOFPageState();
}

class _OutputWOFPageState extends State<OutputWOFPage> {
  final _workOrderFormRepo = WorkOrderFormRepo.instance;
  late List<WorkOrderFormModel> _formsWOF;
  late List<WorkOrderFormModel> _filteredFormsWOF;


  @override
  void initState() {
    super.initState();
    _formsWOF = [];
    _filteredFormsWOF = [];
    _getWorkOrderForms();
  }

  void _getWorkOrderForms() async {
    try {
      final formsWOF = await _workOrderFormRepo.getWorkOrderForms();
      setState(() {
        _formsWOF = formsWOF;
        _filteredFormsWOF = formsWOF;
      });
    } catch (error) {
      print('Error: $error');
    }
  }

  void _filterForms(String keyword) {
    Future.delayed(Duration.zero, () {
      setState(() {
        if (keyword.isNotEmpty) {
          _filteredFormsWOF = _formsWOF.where((form) {
            final turboNoString = form.turboNo.toString().toLowerCase();
            final tasimaUcretiString = form.tasimaUcreti.toString().toLowerCase();
            final keywordLower = keyword.toLowerCase();
            return turboNoString.contains(keywordLower) ||
                form.aracBilgileri.toLowerCase().contains(keywordLower) ||
                form.musteriBilgileri.toLowerCase().contains(keywordLower) ||
                form.musteriSikayetleri.toLowerCase().contains(keywordLower) ||
                form.onTespit.toLowerCase().contains(keywordLower) ||
                form.turboyuGetiren.toLowerCase().contains(keywordLower) ||
                tasimaUcretiString.contains(keywordLower) ||
                form.teslimAdresi.toLowerCase().contains(keywordLower);
          }).toList();

        } else {
          _filteredFormsWOF = _formsWOF;
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
            Text("Kayıtlı İş Emirleri  "),
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
          if (_filteredFormsWOF.isEmpty)
            Center(child: Text('Kayıtlı Form Bulunamadı'))
          else
            ListView.builder(
              itemCount: _filteredFormsWOF.length,
              itemBuilder: (context, index) {
                final form = _filteredFormsWOF[index];
                return ListTile(
                  title: Text('Tarih: ${form.tarih.toString()}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Turbo No: ${form.turboNo}'),
                      Text('Araç Bilgileri: ${form.aracBilgileri}'),
                      Text('Müşteri Bilgileri: ${form.musteriBilgileri}'),
                      Text('Müşteri Şikayetleri: ${form.musteriSikayetleri}'),
                      Text('Ön Tespit: ${form.onTespit}'),
                      Text('Turboyu Getiren: ${form.turboyuGetiren}'),
                      Text('Taşıma Ücreti: ${form.tasimaUcreti}'),
                      Text('Teslim Adresi: ${form.teslimAdresi}'),
                    ],
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => DetailsWOFPage(formWOF: form),
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
