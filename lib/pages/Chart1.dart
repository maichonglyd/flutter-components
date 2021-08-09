import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class Chart1 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Chart1();
}

class _Chart1 extends State<Chart1> {
  bool isShowingMainData;

  @override
  void initState() {
    super.initState();
    isShowingMainData = true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 40, left: 20, right: 20),
      child: LineChart(
        sampleData(),
        swapAnimationDuration: const Duration(milliseconds: 250),
      ),
    );
  }

  LineChartData sampleData() {
    List<List<String>> list = [];
    for (var i = 1; i < 20; i++) {
      list.add([
        '$i香蕉',
        '${(Random().nextDouble() * (i * 2.1)).toStringAsFixed(2)}'
      ]);
    }

    List<double> tmpList = list.map((e) => double.tryParse(e[1])).toList();
    tmpList.sort();

    double ymax = tmpList[tmpList.length - 1];

    var interval = (ymax ~/ 4).toInt().toDouble();
    var yinterval = (list.length ~/ 4).toInt().toDouble();

    return LineChartData(
      // extraLinesData: ExtraLinesData(
      //   horizontalLines: ykey
      //       .map((i) => HorizontalLine(
      //           y: i,
      //           label: HorizontalLineLabel(
      //               show: true, labelResolver: (_) => i.toStringAsFixed(2)),
      //           strokeWidth: 1,
      //           color: Colors.black12))
      //       .toList(),
      //   verticalLines: xkey
      //       .map(
      //         (i) => VerticalLine(
      //           strokeWidth: 0.5,
      //           x: i.toDouble(),
      //           color: Colors.black12,
      //           label: VerticalLineLabel(
      //             alignment: Alignment.bottomCenter,
      //             padding: EdgeInsets.only(bottom: -10, left: 0),
      //             show: true,
      //             labelResolver: (_) => list[i][0],
      //           ),
      //         ),
      //       )
      //       .toList(),
      // ),
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
            fitInsideHorizontally: true,
            fitInsideVertically: true,
            showOnTopOfTheChartBoxArea: true,
            tooltipBgColor: Colors.black.withOpacity(0.5),
            getTooltipItems: (List<LineBarSpot> ls) => ls
                .map((e) => LineTooltipItem(
                    '${list[e.x.toInt()][0]}:${list[e.x.toInt()][1]}',
                    TextStyle()))
                .toList()),
        touchCallback: (LineTouchResponse touchResponse) {},
        handleBuiltInTouches: true,
      ),
      gridData: FlGridData(
          horizontalInterval: interval,
          verticalInterval: yinterval,
          show: true,
          drawHorizontalLine: true,
          drawVerticalLine: true),
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(showTitles: true, interval: yinterval),
        leftTitles: SideTitles(
          interval: interval,
          showTitles: true,
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(
            color: Color(0xff4e4965),
            width: 1.5,
          ),
          left: BorderSide(
            color: Color(0xff4e4965),
            width: 1.5,
          ),
          right: BorderSide(
            color: Colors.transparent,
          ),
          top: BorderSide(
            color: Colors.transparent,
          ),
        ),
      ),
      minY: 0,
      minX: 0,
      lineBarsData: linesBarData1(list),
    );
  }

  List<LineChartBarData> linesBarData1(List<List<String>> list) {
    var flist = list
        .map((e) => FlSpot(list.indexOf(e).toDouble(), double.tryParse(e[1])))
        .toList();

    final LineChartBarData lineChartBarData1 = LineChartBarData(
      spots: flist,
      isCurved: false,
      colors: [
        Colors.green,
      ],
      barWidth: 1,
      isStrokeCapRound: false,
      dotData: FlDotData(
        show: true,
        getDotPainter: (FlSpot fs, double v, LineChartBarData lcb, int) =>
            FlDotCirclePainter(radius: 2),
      ),
      belowBarData: BarAreaData(
          show: true,
          colors: [Colors.green, Colors.green, Colors.white.withOpacity(0)],
          gradientFrom: Offset(0, 0),
          gradientTo: Offset(0, 1)),
    );

    return [
      lineChartBarData1,
      // lineChartBarData2,
      // lineChartBarData3,
    ];
  }
}
