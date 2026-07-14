import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Utils {
  static List<Widget> modelBuilder<M>(
          List<M> models, Widget Function(int index, M model) builder) =>
      models
          .asMap()
          .map<int, Widget>(
              (index, model) => MapEntry(index, builder(index, model)))
          .values
          .toList();

  /// Alternativaly: You can display an Android Styled Bottom Sheet instead of an iOS styled bottom Sheet
  // static showSheet(
  //   BuildContext context, {
  //   required Widget child,
  // }) =>
  //     showModalBottomSheet(
  //       context: context,
  //       builder: (context) => child,
  //     );

  static showSheet(
    BuildContext context, {
    required Widget child,
    required VoidCallback onClicked,
  }) =>
      showCupertinoModalPopup(
        context: context,
        builder: (context) => CupertinoActionSheet(
          actions: [
            child,
          ],
          // cancelButton: CupertinoActionSheetAction(
          //   child: Text(
          //     'Done',
          //     style: TextStyle(
          //       fontSize: 20.0,
          //       color: Color(0xffFF6700),
          //       fontFamily: 'Poppins-regular',
          //       fontWeight: FontWeight.w400,
          //     ),
          //   ),
          //   onPressed: onClicked,
          // ),
        ),
      );

  static void showSnackBar(BuildContext context, String text) {
    final snackBar = SnackBar(
      content: Text(text, style: const TextStyle(fontSize: 14)),
    );

    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
