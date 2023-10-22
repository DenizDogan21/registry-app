import 'package:flutter/material.dart';
import 'package:turboapp/frontEnd/formPages/inputWOF.dart';
import 'package:turboapp/frontEnd/widgets/common.dart';
import 'package:turboapp/frontEnd/formPages/inputIPF.dart';
import 'package:turboapp/frontEnd/utils/customTextStyle.dart';

class AddFormPage extends StatefulWidget {
  const AddFormPage ({super.key});

  @override
  State<AddFormPage> createState() => _State();
}

class _State extends State<AddFormPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: appBar(context, "     FORM EKLE"),
      body: Stack( children:[
        background(context),
        SafeArea(child: Center(child:Row(
        children: [
          Expanded(child:
          TextButton(onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const InputWOFPage()),
            );
          }, child: Text("İş Emri Formu Ekle",style: CustomTextStyle.titleTextStyle,),
            style:
            TextButton.styleFrom(
                backgroundColor: Colors.white,
                side: BorderSide(width: 0.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
            ),),),
          SizedBox(width: 40,),
          Expanded(child:
          TextButton(onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const InputIPFPage()),
            );
          }, child: Text("İn Progress Form Ekle",style: CustomTextStyle.titleTextStyle,),
            style:
            TextButton.styleFrom(
                backgroundColor: Colors.white,
                side: BorderSide(width: 0.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
            ),),),

        ],
      )),
      ),]),
      bottomNavigationBar: bottomNav(context),
    );
  }
}
