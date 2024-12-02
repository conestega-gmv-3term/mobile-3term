import 'package:flutter/material.dart';
import 'package:tic_tac_toe_app/widgets/common_header.dart';
import 'package:tic_tac_toe_app/widgets/common_bottom_bar.dart';

class RanksScreen extends StatelessWidget {
  const RanksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonHeader(pageTitle: 'Ranks'),
      body: const Center(
        child: Text('Ranks will be displayed here'),
      ),
      bottomNavigationBar: const CommonBottomBar(),
    );
  }
}
