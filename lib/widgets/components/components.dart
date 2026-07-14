import 'package:flutter/material.dart';
import 'package:outc/widgets/colors/colors.dart';

class WidgetComponent {
  // static FlatButton flatButton ({
  //   Widget buttons,
  //   Color colors,
  //   @required VoidCallback onPressed,
  // }) => FlatButton(
  //   child: buttons,
  //   color: colors,
  //   onPressed: onPressed,
  // );
  static TextFormField formField({
    required String hints,
    required String label,
    required Widget suffix,
    required Widget prefix,
    required InputBorder borders,
    // bool secure: false,
    // required bool autocorrent : true,
    required Icon icon,
    // required bool enables  = true,
    required TextInputType inputType,
    required TextEditingController controllers,
    // required FormFieldValidator valids,
  }) =>
      TextFormField(
        // enabled: enables,
        // validator: valids,
        // obscureText: secure,
        keyboardType: inputType,
        // autocorrect: autocorrent,
        controller: controllers,
        decoration: InputDecoration(
          border: borders,
          icon: icon,
          labelText: label,
          hintText: hints,
          suffixIcon: suffix,
          prefixIcon: prefix,
        ),
      );

  static RawMaterialButton buttons(
    String label, {
    double? elevas,
    required double radius,
    Color? coloring,
    Color? textColor,
    FontWeight? bolds,
    EdgeInsetsGeometry? padding,
    required VoidCallback onPressed,
  }) =>
      RawMaterialButton(
          // elevation: elevas,
          // padding: padding,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius)),
          fillColor: coloring,
          onPressed: onPressed,
          child: Text(
            label,
            style: TextStyle(color: textColor, fontWeight: bolds),
          ));

  static ListTile listiles(
    String titles, {
    required IconData leads,
    required IconData icons,
    required VoidCallback onPressed,
  }) =>
      ListTile(
        leading: Icon(leads),
        title: Text(titles),
        onTap: onPressed,
        trailing: IconButton(icon: Icon(icons), onPressed: onPressed),
      );
}

TextStyle textStyleHeading() {
  return TextStyle(
      fontSize: 14.0,
      color: Colours.orangeOutC,
      fontFamily: 'poppins',
      fontWeight: FontWeight.bold);
}

// textview in Account page
class TextHeader extends StatelessWidget {
  final inputText;

  const TextHeader({
    super.key,
    required this.inputText,
  });

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Text(
            inputText,
            style: TextStyle(
              fontSize: 10.0,
              color: Colours.strongRed,
              fontFamily: 'poppins',
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      );
}

class TextContent extends StatelessWidget {
  final inputText;

  const TextContent({
    super.key,
    required this.inputText,
  });

  @override
  Widget build(BuildContext context) => Text(
        inputText,
        style: TextStyle(
          fontSize: 14.0,
          color: Colours.veryDarkGrey,
          fontFamily: 'poppins',
        ),
      );
}

class DivWithPadding extends StatelessWidget {
  const DivWithPadding({
    super.key,
  });

  @override
  Widget build(BuildContext context) => Column(
        children: [
          const SizedBox(
            height: 4.0,
          ),
          Divider(
            height: 2.0,
            color: Colours.veryDarkGrey,
          ),
          const SizedBox(
            height: 4.0,
          ),
        ],
      );
}
