// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api, camel_case_types

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class charts extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  charts({Key? key}) : super(key: key);

  @override
  chartsState createState() => chartsState();
}

class chartsState extends State<charts> {
  List<_SalesData> data = [
    _SalesData('Ocak', 35),
    _SalesData('Şubat', 28),
    _SalesData('Mart', 34),
    _SalesData('Nisan', 32),
    _SalesData('Mayıs', 40)
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('chart'),
        ),
        body: Column(children: [
          SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              title: ChartTitle(text: 'toplam izlenmeler'),
              legend: Legend(isVisible: true),
              tooltipBehavior: TooltipBehavior(enable: true),
              series: <ChartSeries<_SalesData, String>>[
                LineSeries<_SalesData, String>(
                    dataSource: data,
                    xValueMapper: (_SalesData sales, _) => sales.year,
                    yValueMapper: (_SalesData sales, _) => sales.sales,
                    name: 'toplam\nizlenmeler',
                    dataLabelSettings: DataLabelSettings(isVisible: true))
              ]),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SfSparkLineChart.custom(
                trackball: SparkChartTrackball(
                    activationMode: SparkChartActivationMode.tap),
                marker: SparkChartMarker(
                    displayMode: SparkChartMarkerDisplayMode.all),
                labelDisplayMode: SparkChartLabelDisplayMode.all,
                xValueMapper: (int index) => data[index].year,
                yValueMapper: (int index) => data[index].sales,
                dataCount: 5,
              ),
            ),
          )
        ]));
  }
}

class _SalesData {
  _SalesData(this.year, this.sales);

  final String year;
  final double sales;
}
