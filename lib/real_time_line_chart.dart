import 'dart:async';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'package:temperature_plugin/temperature_plugin.dart';

class LiveLineChart extends StatefulWidget {
  @override
  _LiveLineChartState createState() => _LiveLineChartState();
}

class _LiveLineChartState extends State<LiveLineChart> {
  List<_ChartData> chartData = <_ChartData>[];
  ChartSeriesController? _chartSeriesController;

  final TemperaturePlugin _temperature = TemperaturePlugin();
  late StreamSubscription<int> _temperatureStateSubscription;

  @override
  void initState() {
    super.initState();
    _temperatureStateSubscription = _temperature.onTemperatureStateChanged.listen((int state) {
          var currentDate = DateTime.now();
          chartData.add(_ChartData(currentDate, state));
          for(int i = 0; i < chartData.length; i++) {
            if(currentDate.difference(chartData[i].dateTime) < const Duration(minutes: 10)) {
              chartData.removeRange(0, i);
              _chartSeriesController?.updateDataSource(
                addedDataIndexes: <int>[chartData.length - 1],
                removedDataIndexes: Iterable<int>.generate(i).toList(),
              );
              break;
            }
          }
        });
  }

  @override
  void dispose() {
    _temperatureStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildLiveLineChart();
  }

  SfCartesianChart _buildLiveLineChart() {
    return SfCartesianChart(
        plotAreaBorderWidth: 0,
        trackballBehavior: TrackballBehavior(
            enable: true,
            tooltipDisplayMode: TrackballDisplayMode.floatAllPoints
        ),
        primaryXAxis: DateTimeAxis(majorGridLines: const MajorGridLines(width: 0), dateFormat: DateFormat('HH:mm:ss')),
        primaryYAxis: NumericAxis(
            axisLine: const AxisLine(width: 0),
            majorTickLines: const MajorTickLines(size: 0)),
        series: <LineSeries<_ChartData, DateTime>>[
          LineSeries<_ChartData, DateTime>(
            onRendererCreated: (ChartSeriesController controller) {
              _chartSeriesController = controller;
            },
            dataSource: chartData,
            color: const Color.fromRGBO(192, 108, 132, 1),
            xValueMapper: (_ChartData sales, _) => sales.dateTime,
            yValueMapper: (_ChartData sales, _) => sales.temperature,
            animationDuration: 0,
          )
        ]);
  }
}

class _ChartData {
  _ChartData(this.dateTime, this.temperature);

  final DateTime dateTime;
  final num temperature;
}
