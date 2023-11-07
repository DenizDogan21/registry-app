import 'package:flutter/material.dart';
import '../../BackEnd/Models/workOrderForm_model.dart';
import '../../BackEnd/Repositories/workOrderForm_repo.dart';
import '../widgets/common.dart';
import 'detailsWOF.dart';
import 'package:turboapp/frontEnd/utils/customTextStyle.dart';

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
        backgroundColor: Colors.grey.shade900,
        title: Text("Registered Work Orders", style: TextStyle(color: Colors.cyanAccent)),
        actions: [
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
      bottomNavigationBar: bottomNav(),
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
        child: _filteredFormsWOF.isEmpty
            ? Center(child: Text('No Records Found', style: TextStyle(color: Colors.white)))
            : ListView.separated(
          itemCount: _filteredFormsWOF.length,
          separatorBuilder: (context, index) => Divider(color: Colors.grey.shade600),
          itemBuilder: (context, index) {
            final form = _filteredFormsWOF[index];
            return ListTileTheme(
              textColor: Colors.white,
              iconColor: Colors.cyanAccent,
              child: ListTile(
                leading: Icon(Icons.build_circle_outlined),
                title: Text('${form.tarih.toString()}', style: CustomTextStyle.outputTitleTextStyle),
                subtitle: Text('Turbo No: ${form.turboNo}', style: CustomTextStyle.outputListTextStyle),
                trailing: Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => DetailsWOFPage(formWOF: form),
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
