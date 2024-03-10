import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../backEnd/repositories/workOrderForm_repo.dart';
import 'package:turboapp/backEnd/models/workOrderForm_model.dart';
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
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _formsWOF = [];
    _filteredFormsWOF = [];
    _getWorkOrderForms();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _filterForms(_searchController.text);
  }

  void _getWorkOrderForms() async {
    try {
      final formsWOF = await _workOrderFormRepo.getWorkOrderForms();
      formsWOF.sort((a, b) => b.tarihWOF.compareTo(a.tarihWOF));
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
            final keywordLower = keyword.toLowerCase();
            return form.turboNo.toLowerCase().contains(keywordLower) ||
                form.aracBilgileri.toLowerCase().contains(keywordLower) ||
                form.aracPlaka.toLowerCase().contains(keywordLower) ||
                form.musteriAdi.toLowerCase().contains(keywordLower) ||
                form.musteriSikayetleri.toLowerCase().contains(keywordLower) ||
                form.onTespit.toLowerCase().contains(keywordLower) ||
                form.turboyuGetiren.toLowerCase().contains(keywordLower) ||
                form.teslimAdresi.toLowerCase().contains(keywordLower) ||
                form.kabulDurumu.toLowerCase().contains(keywordLower);
          }).toList();
        } else {
          _filteredFormsWOF = _formsWOF;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(isTablet ? 80 : 40), // Adjust height for tablets
        child: AppBar(
          backgroundColor: Colors.grey.shade900,
          title: Padding(
            padding: isTablet ? EdgeInsets.only(top: 20): EdgeInsets.only(top: 10),
            child: TextField(
              controller: _searchController,
              style: TextStyle(color: Colors.white, fontSize: isTablet ? 50 : 25), // Increase font size for tablets
              decoration: InputDecoration(
                hintText: "Ara...",
                hintStyle: TextStyle(color: Colors.white),
                border: InputBorder.none,
              ),
              onChanged: (value) => _filterForms(value),
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.cancel,size: isTablet ? 40 : 20,),
              onPressed: () {
                _searchController.clear();
              },
              padding: isTablet ? EdgeInsets.only(top: 20,right: 20): EdgeInsets.only(top: 10,right: 10)
            ),
          ],
        ),
      ),
      bottomNavigationBar: bottomNav(context),
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
            ? Center(
          child: Text(
            'Kayıt Bulunamadı',
            style: TextStyle(color: Colors.white, fontSize: isTablet ? 30 : 16),
          ),
        )
            : ListView.separated(
          itemCount: _filteredFormsWOF.length,
          separatorBuilder: (context, index) => Divider(color: Colors.grey.shade600),
          itemBuilder: (context, index) {
            final form = _filteredFormsWOF[index];
            Color tileColor =
            form.kabulDurumu == 'reddedildi' ? Colors.red : Colors.yellow;
            return ListTileTheme(
              textColor: Colors.white,
              iconColor: tileColor,
              child: ListTile(
                leading: Icon(Icons.build_circle_outlined),
                title: Text(
                  '${formatDate(form.tarihWOF)}',
                  style: CustomTextStyle.outputTitleTextStyle.copyWith(
                    fontSize: isTablet ? 40 : 20,
                  ),
                ),
                subtitle: Text(
                  'Turbo No: ${form.turboNo}',
                  style: CustomTextStyle.outputListTextStyle.copyWith(
                    fontSize: isTablet ? 30 : 15,
                  ),
                ),
                trailing: Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => DetailsWOFPage(formWOF: form),
                    ),
                  );
                },
                tileColor: tileColor, // Set tile color based on kabulDurumu
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
