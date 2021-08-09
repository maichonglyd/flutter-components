import 'dart:math';

import 'package:app/components/common.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarChart1 extends StatefulWidget {
  final List<Color> availableColors = [
    Colors.purpleAccent,
    Colors.yellow,
    Colors.lightBlue,
    Colors.orange,
    Colors.pink,
    Colors.redAccent,
  ];

  @override
  State<StatefulWidget> createState() => _BarChart();
}

class _BarChart extends State<BarChart1> {
  final Color barBackgroundColor = const Color(0xff72d8bf);
  final Duration animDuration = const Duration(milliseconds: 250);

  int touchedIndex;

  bool isPlaying = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.teal.shade100,
      padding: EdgeInsets.only(top: 40, left: 20, right: 20),
      child: BarChart(
        randomData(),
        // isPlaying ?  : mainBarData(),
        swapAnimationDuration: animDuration,
      ),
    );
  }

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    Color barColor = Colors.white,
    double width = 22,
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        // 同一组的多个数据在这里做多个
        BarChartRodData(
          y: y - 8,
          colors: [Colors.red],
        ),
        BarChartRodData(
          y: y + 5,
          colors: [Colors.green],
        ),
        BarChartRodData(
          y: y + 7,
          colors: [Colors.orange],
        ),
      ],
      // showingTooltipIndicators: [y.toInt(), y.toInt() + 5, y.toInt() + 9],
    );
  }

  BarChartData randomData() {
    double max = 31;
    double interval = (max ~/ 4).toInt().toDouble();
    return BarChartData(
      alignment: BarChartAlignment.spaceAround,
      gridData: FlGridData(
        show: true,
        horizontalInterval: interval,
      ),
      barTouchData: BarTouchData(
        enabled: true,
        touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.black.withOpacity(0.5),
            fitInsideVertically: true,
            fitInsideHorizontally: true,
            getTooltipItem:
                (BarChartGroupData bg, int i, BarChartRodData br, int j) {
              return BarTooltipItem('text\t\nabcdsfgsdf\t\nasdfae\t',
                  TextStyle(color: Colors.white));
            }),
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14),
          getTitles: (double value) {
            return value.toString();
          },
        ),
        leftTitles: SideTitles(
          interval: interval,
          showTitles: true,
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: Border(
              left: borderSide(2, Colors.black38),
              bottom: borderSide(2, Colors.black38))),
      barGroups: List.generate(7, (i) {
        return makeGroupData(i, max.toDouble(),
            barColor: widget.availableColors[
                Random().nextInt(widget.availableColors.length)],
            isTouched: i == touchedIndex);
      }),
    );
  }
}
