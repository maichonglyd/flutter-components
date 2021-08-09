import 'package:app/components/common.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

const colors = [
  Color(0xff0293ee),
  Color(0xfff8b250),
  Color(0xff845bef),
  Color(0xff13d38e),
  Colors.green,
  Colors.orange,
  Colors.red,
];

class PieChart1 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PieChart();
}

class _PieChart extends State {
  int touchedIndex;

  @override
  Widget build(BuildContext context) {
    final List<PieData> data = [
      PieData(name: '小说', value: 23),
      PieData(name: '电影', value: 53),
      PieData(name: '图片', value: 75),
      PieData(name: '文字', value: 26),
      PieData(name: '小说', value: 23),
      PieData(name: '电影', value: 53),
      PieData(name: '图片', value: 75),
      PieData(name: '文字', value: 26),
      PieData(name: '小说', value: 23),
      PieData(name: '电影', value: 53),
      PieData(name: '图片', value: 75),
      PieData(name: '文字', value: 26),
      PieData(name: '小说', value: 23),
      PieData(name: '电影', value: 53),
      PieData(name: '图片', value: 75),
      PieData(name: '文字', value: 26),
    ];
    final double width = 500;
    final double sectionsSpace = 2;
    final double centerSpaceRadius = 100;
    final double pieRadius = 80;
    final double pieClickRadius = 40;
    final bool showDotValue = true;
    return Container(
      width: double.infinity,
      height: rpx(width),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: rpx(width),
            height: rpx(width),
            child: Stack(
              children: [
                PieChart(
                  PieChartData(
                      pieTouchData:
                          PieTouchData(touchCallback: (pieTouchResponse) {
                        setState(() {
                          if (!(pieTouchResponse.touchInput is FlLongPressEnd ||
                              pieTouchResponse.touchInput is FlPanEnd)) {
                            touchedIndex = pieTouchResponse.touchedSectionIndex;
                          }
                        });
                      }),
                      startDegreeOffset: 180,
                      borderData: FlBorderData(
                        show: false,
                      ),
                      sectionsSpace: rpx(sectionsSpace),
                      centerSpaceRadius: rpx(centerSpaceRadius),
                      sections: List.generate(
                          data.length,
                          (index) => PieChartSectionData(
                                color: colors[(index % colors.length).toInt()],
                                value: data[index].value,
                                title: '',
                                radius: touchedIndex == index
                                    ? rpx(pieRadius + pieClickRadius)
                                    : rpx(pieRadius),
                              ))),
                ),
                Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    top: 0,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: text('${data[touchedIndex ?? 0]?.name}'),
                          ),
                          Container(
                            child: text('${data[touchedIndex ?? 0]?.value}'),
                          )
                        ],
                      ),
                    )),
              ],
            ),
          ),
          showDotValue
              ? Expanded(
                  child: ListView(
                  primary: false,
                  shrinkWrap: false,
                  children: List.generate(
                      data.length,
                      (index) => Container(
                            margin: EdgeInsets.only(bottom: rpx(24)),
                            child: Indicator(
                              color: colors[(index % colors.length).toInt()],
                              text: '${data[index].name}',
                            ),
                          )),
                ))
              : Container(width: 1)
        ],
      ),
    );
  }
}

class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final double size;
  final Color textColor;

  const Indicator({
    Key key,
    this.color,
    this.text,
    this.size,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size ?? rpx(20),
          height: size ?? rpx(20),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        SizedBox(
          width: rpx(24),
        ),
        Text(
          text,
          style: TextStyle(
              fontSize: rpx(24), color: Colors.black.withOpacity(0.87)),
        )
      ],
    );
  }
}

class PieData {
  String name;
  double value;
  PieData({this.name, this.value});
  toMap() {
    return {'name': this.name, 'value': this.value};
  }
}
