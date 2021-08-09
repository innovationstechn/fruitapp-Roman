import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:fruitapp/Chart/line_chart_widget.dart';
import 'package:fruitapp/widgets/appbar.dart';


// Statistics(noYValues:["0","2000","500","300","900"],mlYValues:["0","500","1000","300","900"],kgYValues:["0","1000","500","300","900"],time:"00:00:00")

class Statistics extends StatefulWidget {

  final List<String> noYValues;
  final List<String> mlYValues;
  final List<String> kgYValues;
  final String time;

  Statistics({this.noYValues,this.mlYValues,this.kgYValues,this.time});

  @override
  _Statistics createState() => _Statistics(noYValues,mlYValues,kgYValues,time);
}

class _Statistics extends State<Statistics> {

  List<String> noYValues=[];
  List<String> mlYValues=[];
  List<String> kgYValues=[];
  final List<FlSpot> noflSpot = [];
  final List<FlSpot> mlflSpot = [];
  final List<FlSpot> kgflSpot = [];
  String time="00:00:00";

  _Statistics(List<String>noYValues,List<String>mlYValues,List<String>kgYValues,String time){

    if(noYValues.length>0) {
      for (int i = 0; i < noYValues.length; i++) {
        this.noflSpot.add(
            FlSpot(double.parse(i.toString()), double.parse(noYValues[i])));
        this.mlflSpot.add(
            FlSpot(double.parse(i.toString()), double.parse(mlYValues[i])));
        this.kgflSpot.add(
            FlSpot(double.parse(i.toString()), double.parse(kgYValues[i])));

        this.noYValues = noYValues;
        this.kgYValues = kgYValues;
        this.mlYValues = mlYValues;
      }
    }
    else{
      this.noflSpot.add(FlSpot(0, 0));
      this.mlflSpot.add(FlSpot(0,0));
      this.kgflSpot.add(FlSpot(0,0));
    }
    this.time = time;
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0,20,0,0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20,0,0,20),
                        child: Text("No:",style: TextStyle(fontSize: 20,fontWeight:FontWeight.bold),),
                      )],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [LineChartWidget(spotList:noflSpot,yValues:noYValues)],),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20,0,0,20),
                        child: Text("ML:",style: TextStyle(fontSize: 20,fontWeight:FontWeight.bold),),
                      )],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Center(child: LineChartWidget(spotList:mlflSpot,yValues:mlYValues))],),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20,0,0,20),
                        child: Text("Kg:",style: TextStyle(fontSize: 20,fontWeight:FontWeight.bold),),
                      )],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Center(child: LineChartWidget(spotList:kgflSpot,yValues:kgYValues))],),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20,0,0,20),
                        child: Text("Time:",style: TextStyle(fontSize: 20,fontWeight:FontWeight.bold),),
                      )],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(this.time,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                    )])
                ],
              ),
            ),
          ),
    );
  }
}
