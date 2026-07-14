import 'package:flutter/material.dart';

class MybookingListPage extends StatefulWidget {
  const MybookingListPage({super.key});

  @override
  State<MybookingListPage> createState() => _MybookingListPageState();
}

class _MybookingListPageState extends State<MybookingListPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Text("Not yet started"),
    );
  }
}
