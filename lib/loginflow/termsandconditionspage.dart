import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:outc/widgets/colors/colors.dart';

class TermsandConditions extends StatelessWidget {
  const TermsandConditions({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colours.strongRed,
        elevation: 0,
         leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: const Icon(Icons.arrow_back,color: Colors.white,size: 25,)),
        title: Text('Terms and Conditions',style: GoogleFonts.poppins(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w500),),
      ),
      body:  Padding(
        padding: const  EdgeInsets.all(8.0),
        child: Text('Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.',
        style: GoogleFonts.poppins(fontSize: 16,fontWeight: FontWeight.w400,height: 2),),
      ),
    );
  }
}