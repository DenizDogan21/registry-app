import 'package:flutter/material.dart';
import '../widgets/common.dart';
import 'package:turboapp/BackEnd/Repositories/workOrderForm_repo.dart';
import 'package:turboapp/BackEnd/Models/workOrderForm_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:turboapp/frontEnd/widgets/helperMethodsInput.dart';

class InputWOFPage extends StatefulWidget {
  const InputWOFPage({Key? key}) : super(key: key);

  @override
  State<InputWOFPage> createState() => _InputWOFPageState();
}

class _InputWOFPageState extends State<InputWOFPage> {


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


  List<Widget> _buildCheckboxes() {
    return yanindaGelenlerState.keys.map((String key) {
      return CheckboxListTile(
        title: Text(displayNames[key] ?? key), // Fallback to key if no display name is found
        value: yanindaGelenlerState[key],
        onChanged: (bool? value) {
          setState(() {
            yanindaGelenlerState[key] = value!;
          });
        },
      );
    }).toList();
  }


  GlobalKey<FormState> key = GlobalKey();


  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _workOrderFormRepo = WorkOrderFormRepo.instance;

  String? turboNo;
  DateTime? tarihWOF;
  String? aracBilgileri;
  String? musteriAdi;
  int? musteriNumarasi;
  String? musteriSikayetleri;
  String? onTespit;
  String? turboyuGetiren;
  double? tasimaUcreti;
  String? teslimAdresi;



  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {

        // Create an instance of workOrderFormModel with the entered data
        final workOrderForm = WorkOrderFormModel(
          turboNo: turboNo!,
          tarihWOF: tarihWOF!,
          aracBilgileri: aracBilgileri!,
          musteriAdi: musteriAdi!,
          musteriNumarasi: musteriNumarasi!,
          musteriSikayetleri: musteriSikayetleri!,
          onTespit: onTespit!,
          turboyuGetiren: turboyuGetiren!,
          tasimaUcreti: tasimaUcreti!,
          teslimAdresi: teslimAdresi!,
          yanindaGelenler: yanindaGelenlerState,
        );

        // Create the form
        _workOrderFormRepo.createWorkOrderForm(workOrderForm);

        // Reset the form fields
        setState(() {
          _formKey.currentState!.reset();
        });

      }
    }
  }


  int _currentStep = 0;

  List<Step> get _steps => [
    Step(
      title: const Text('1'),
      content: Column(
        children: [
          buildDatePickerFormField(
            context: context,
            labelText: 'İş Emri Tarihi',
            errorText: 'Tarih girin',
            onSave: (DateTime value) {
              tarihWOF = value; // Directly save the DateTime value
            },
          ),
          buildTextFormField(
            labelText: 'Turbo No',
            errorText: 'Lütfen turbo no girin',
            onSave: (value) => turboNo = value,
          ),
          buildTextFormField(
            labelText: 'Araç Bilgileri',
            errorText: 'Lütfen araç bilgisi girin',
            onSave: (value) => aracBilgileri = value,
          ),
        ],
      ),
      isActive: _currentStep >= 0,
      state: _currentStep >= 1 ? StepState.complete : StepState.indexed,
    ),
    Step(
      title: const Text('2'),
      content: Column(
        children: [
          buildTextFormField(
            labelText: 'Müşteri Ad Soyad',
            errorText: 'Lütfen müşteri adı girin',
            onSave: (value) => musteriAdi = value,
          ),
          buildTextFormField(
            labelText: 'Müşteri Numarası',
            errorText: 'Lütfen müşteri numarası',
            onSave: (value) => musteriNumarasi = int.tryParse(value!),
            keyboardType: TextInputType.number,
          ),
          buildTextFormField(
            labelText: 'Müşteri Şikayetleri',
            errorText: 'Lütfen müşteri şikayeti girin',
            onSave: (value) => musteriSikayetleri = value,
          ),
        ],
      ),
      isActive: _currentStep >= 1,
      state: _currentStep >= 2 ? StepState.complete : StepState.indexed,
    ),
    Step(
      title: const Text('3'),
      content: Column(
        children: [
          ..._buildCheckboxes(),
        ],
      ),
      isActive: _currentStep >= 2,
      state: _currentStep >= 3 ? StepState.complete : StepState.indexed,
    ),
    Step(
      title: const Text('4'),
      content: Column(
        children: [
          buildTextFormField(
            labelText: 'Ön Tespit',
            errorText: 'Lütfen ön tespiti girin',
            onSave: (value) => onTespit = value,
          ),
        ],
      ),
      isActive: _currentStep >= 3,
      state: _currentStep >= 4 ? StepState.complete : StepState.indexed,
    ),
    Step(
      title: const Text('5'),
      content: Column(
        children: [
          buildTextFormField(
            labelText: 'Turboyu Getiren',
            errorText: 'Lütfen turboyu getireni girin',
            onSave: (value) => turboyuGetiren = value,
          ),
          buildTextFormField(
            labelText: 'Taşıma Ücreti',
            errorText: 'Lütfen taşıma ücreti girin',
            onSave: (value) => tasimaUcreti = double.tryParse(value!),
            keyboardType: TextInputType.number,
          ),
          buildTextFormField(
            labelText: 'Teslim Adresi',
            errorText: 'Lütfen teslim adresi girin',
            onSave: (value) => teslimAdresi = value,
          ),
        ],
      ),
      isActive: _currentStep >= 4,
      state: _currentStep >= 5 ? StepState.complete : StepState.indexed,
    ),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, "İŞ EMRİ"),
      bottomNavigationBar: bottomNav(),
      body: Stack(
        children: [
          background(context),
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Stepper(
                currentStep: _currentStep,
                onStepContinue: () {
                  if (_currentStep < _steps.length - 1) {
                    setState(() => _currentStep += 1);
                  } else {
                    _submitForm(); // Submit the form on the last step
                  }
                },
                onStepCancel: () {
                  if (_currentStep > 0) {
                    setState(() => _currentStep -= 1);
                  }
                },
                steps: _steps,
              ),
            ),
          ),
        ],
      ),
    );
  }
}