import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'line_titles.dart';

class LineChartWidget extends StatelessWidget {
  final List<FlSpot> spotList;
  final List<String>  xValues=[],yValues;

  // Setting Color schemes for chart
  final List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  LineChartWidget({this.spotList, this.yValues});

  @override
  Widget build(BuildContext context) => LineChart(
        LineChartData(
          // Setting minimum,maximum values can be placed on x and y axis.
          // minX:maxNumber(),
          // maxX:maxNumber(),
          // minY: yValues.length.toDouble(),
          // maxY: yValues.length.toDouble(),
          //Placing x and y axis values
          titlesData: LineTitles.getTitleData(xValues, yValues),
          gridData: FlGridData(
            show: true,
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: const Color(0xff37434d), width: 1),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spotList,
              isCurved: true,
              colors: gradientColors,
              barWidth: 5,
              // dotData: FlDotData(show: false),
              // belowBarData: BarAreaData(
              //   show: true,
              //   colors: gradientColors
              //       .map((color) => color.withOpacity(0.3))
              //       .toList(),
              // ),
            ),
          ],
        ),
      );

  double maxNumber(){
    if(xValues.length>0) {
      return yValues.length.toDouble();
    } else
      return 0;
  }
}
