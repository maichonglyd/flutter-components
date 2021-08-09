import 'package:app/components/common.dart';
import 'package:app/pages/BarChart.dart';
import 'package:app/pages/Chart1.dart';
import 'package:flutter/material.dart';

import 'PieChart.dart';

class ChartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: text('chart'),
      ),
      body: ListView(
        children: [
          // Container(
          //   color: Colors.orange.shade50,
          //   width: PageSize.width,
          //   height: PageSize.width,
          //   child: Chart1(),
          // ),
          // Container(
          //   margin: EdgeInsets.only(top: 60, bottom: 100),
          //   width: PageSize.width,
          //   height: PageSize.width,
          //   child: BarChart1(),
          // ),
          Container(
            margin: EdgeInsets.only(top: 60, bottom: 100),
            width: PageSize.width,
            child: PieChart1(),
          )
        ],
      ),
    );
  }
}
