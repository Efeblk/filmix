// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api, camel_case_types

import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

import 'collections/film.dart';

class charts extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  charts({Key? key}) : super(key: key);

  @override
  chartsState createState() => chartsState();
}

class chartsState extends State<charts> {
  late Isar isar;
  int id = 0;
  DateTime date = DateTime.now();

  List<_SalesData> data = [
    _SalesData('Ocak', 55),
    _SalesData('Şubat', 28),
    _SalesData('Mart', 34),
    _SalesData('Nisan', 32),
    _SalesData('Mayıs', 40)
  ];

  openCon() async {
    isar = await Isar.open([FilmSchema]);
    setState(() {});
  }

  getLastAddedFilmId() async {
    final films = await isar.films.where().findAll();
    if (films.isNotEmpty) {
      films.sort((a, b) => b.id.compareTo(a.id));
      _SalesData edata = _SalesData("Bu ay", films.first.id);
      setState(() {
        id = films.first.id;
        data.add(edata);
      });
    } else {
      setState(() {});
    }
  }

  closeCon() async {
    await isar.close();
  }

  @override
  void initState() {
    openCon();
    getLastAddedFilmId();
    super.initState();
  }

  @override
  void dispose() {
    closeCon();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('chart'),
        ),
        body: Column(children: [
          ElevatedButton(
              onPressed: () => getLastAddedFilmId(),
              child: Text("film sayısını ekle")),
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
                dataCount: id,
              ),
            ),
          )
        ]));
  }
}

class _SalesData {
  _SalesData(this.year, this.sales);

  final String year;
  final int sales;
}
