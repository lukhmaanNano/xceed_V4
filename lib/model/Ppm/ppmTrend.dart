import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '../../Config.dart';
import 'package:xceed/Styles/responsive.dart';

import '../../Styles/CommonColor.dart';
import '../../Styles/CommonTextStyle.dart';
import '../../Widgets/mobile/shimmer.dart';
import '../../Widgets/web/helpdesk/cardView.dart';
import '../../Widgets/web/helpdesk/listView.dart';
import '../../Widgets/web/shimmer.dart';

class PpmTrend extends StatefulWidget {
  final dynamic getFunc;
  bool? sideNav, singCardView, detailBackMenu;
  String? pageName;
  PpmTrend(
      {Key? key,
      this.sideNav,
      this.singCardView,
      this.getFunc,
      this.detailBackMenu,
      this.pageName})
      : super(key: key);

  @override
  State<PpmTrend> createState() => _PpmTrendState();
}

class _PpmTrendState extends State<PpmTrend> {
  bool menuState = true, timer = true, listCard = true;
  int tab = 0;
  List<PPMTrends> values = [];

  @override
  void initState() {
    super.initState();
    trendApi();
  }

  void timerFunction() {
    Timer(const Duration(seconds: 3), () {
      setState(() {
        timer = false;
      });
    });
  }

  Future<void> trendApi() async {
    String? ip = '/VwDPPMTrendCrt/';
    const service = ApiConfig.service;
    final url = Uri.parse('$service$ip');
    final headers = {'Accept': 'application/json'};
    const json =
        '{"data":{"CountryID_varchar":0,"CustomerID_varchar":0,"ContractID_varchar":0,"LocationGroupID_varchar":0,"LocalityID_varchar":0,"BuildingID_varchar":0,"CityID_varchar":0,"FloorID_varchar":0,"SpotID_varchar":0,"DivisionID_varchar":0,"DisciplineID_varchar":0,"ServiceTypeID_varchar":0,"FromDate_datetime":"2023-02-23","ToDate_datetime":"2023-03-01","LocUserID_int":"6","PortalUserID_bit":0}}';
    final response =
        await http.post(url, headers: headers, body: json.toString());
    if (response.statusCode == 400) {
      String err = 'something went wrong!';
    } else {
      final String jsonString = jsonEncode(response.body);
      var decodedJson = jsonDecode(jsonString);
      Map<String, dynamic> map = jsonDecode(decodedJson);
      var result = map['PPMTrends']['PPMTrends'];
      for (Map<String, dynamic> i in result) {
        values.add(PPMTrends.fromJson(i));
      }
      print(values[0].label);
      timerFunction();
    }
  }

  Widget build(BuildContext context) {
    return Responsive(mobile: mobileCharts(), desktop: webCharts(context));
  }

  Widget webCharts(BuildContext context) {
    double chartHeight = MediaQuery.of(context).size.height * 0.88;
    double chartWidth = MediaQuery.of(context).size.width * 0.94;
    double navOpenTabWidth = MediaQuery.of(context).size.width * 0.80;
    double shimmerHeight = 300;
    return Padding(
      padding: const EdgeInsets.only(
        right: 5.0,
        bottom: 8.0,
      ),
      child: timer == true
          ? webShimmer(chartHeight)
          : widget.singCardView == false
              ? trendChart()
              : detailChartAndTableView(context),
    );
  }

  Widget mobileCharts() {
    double shimmerHeight = 620;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: timer == true ? MobileShimmer(shimmerHeight) : trendChart(),
    );
  }

  Widget trendChart() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: Colors.white,
      elevation: 3,
      shadowColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Flexible(
                    flex: 2,
                    child: Text(' PPM Trend', style: cartHeaderStyle),
                  ),
                  Icon(Icons.mail, color: secondaryColor),
                ],
              ),
            ),
            Flexible(
              flex: 2,
              child: SfCartesianChart(
                  enableAxisAnimation: true,
                  primaryXAxis: CategoryAxis(
                      majorGridLines:
                          const MajorGridLines(color: Colors.transparent),
                      maximumLabelWidth: 20,
                      isVisible: true,
                      arrangeByIndex: false),
                  legend: Legend(isVisible: true),
                  zoomPanBehavior: ZoomPanBehavior(
                    enableMouseWheelZooming: true,
                    zoomMode: ZoomMode.x,
                    enableDoubleTapZooming: true,
                    enableSelectionZooming: true,
                    enablePanning: true,
                    enablePinching: true,
                  ),
                  tooltipBehavior: TooltipBehavior(
                    enable: true,
                  ),
                  series: <ChartSeries>[
                    LineSeries<PPMTrends, String>(
                      // onPointTap: (pointInteractionDetails) {
                      //   var val;
                      //   val = (pointInteractionDetails
                      //           .dataPoints![
                      //               pointInteractionDetails.pointIndex!]
                      //           .y)
                      //       .toString();
                      //   setState(() {
                      //     tableName = 'By Division';
                      //     tappedValue = val;
                      //   });
                      //   chartTappedDataTable();
                      // },
                      name: 'WorkOrder',
                      dataSource: values,
                      xValueMapper: (PPMTrends data, _) => data.label,
                      yValueMapper: (PPMTrends data, _) => data.y,
                      dataLabelSettings: const DataLabelSettings(
                          isVisible: true,
                          color: Colors.black,
                          opacity: 0.8,
                          labelAlignment: ChartDataLabelAlignment.outer),
                    ),
                  ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget detailChartAndTableView(BuildContext context) {
    double chartHeight = MediaQuery.of(context).size.height * 0.88;
    double shimmerHeight = 310;
    return ConstrainedBox(
      constraints: const BoxConstraints(),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 8.0,
        ),
        child: SizedBox(
          height: chartHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 1,
                child: timer == true ? webShimmer(shimmerHeight) : trendChart(),
              ),
              VerticalDivider(
                color: Colors.grey.shade400,
                thickness: 0.8,
                indent: 20,
                endIndent: 20,
              ),
              Flexible(
                flex: 3,
                child: SizedBox(
                    height: chartHeight,
                    // width: detailWidth1,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                height: 85,
                                width: 280,
                                child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    elevation: 4,
                                    shadowColor: Colors.black12,
                                    color: Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextField(
                                        cursorColor: secondaryColor,
                                        onChanged: (value) {},
                                        decoration: InputDecoration(
                                          filled: true,
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.never,
                                          labelText: 'Search',
                                          labelStyle: const TextStyle(
                                              color: secondaryColor),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide.none,
                                          ),
                                          focusColor: secondaryColor,
                                          fillColor: buttonForeground,
                                          hoverColor: lightShade,
                                          prefixIcon: const Icon(
                                            Icons.search,
                                            color: secondaryColor,
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 10.0,
                                                  horizontal: 10.0),
                                        ),
                                      ),
                                    )),
                              ),
                              Flexible(
                                flex: 2,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    SizedBox(
                                      height: 58,
                                      width: 90,
                                      child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          elevation: 4,
                                          shadowColor: Colors.black12,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: const [
                                                  Icon(Icons.print,
                                                      color: secondaryColor,
                                                      size: 20),
                                                  Text('Print',
                                                      style: TextStyle(
                                                        color: secondaryColor,
                                                        fontSize: 15,
                                                      ))
                                                ]),
                                          )),
                                    ),
                                    SizedBox(
                                      height: 58,
                                      width: 90,
                                      child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          elevation: 4,
                                          shadowColor: Colors.black12,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: const [
                                                  Icon(Icons.present_to_all,
                                                      color: secondaryColor,
                                                      size: 20),
                                                  Text('Export',
                                                      style: TextStyle(
                                                        color: secondaryColor,
                                                        fontSize: 15,
                                                      ))
                                                ]),
                                          )),
                                    ),
                                    Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      elevation: 4,
                                      shadowColor: Colors.black12,
                                      child: ToggleSwitch(
                                        cornerRadius: 10.0,
                                        minWidth: 74.0,
                                        animate: true,
                                        animationDuration: 500,
                                        dividerColor: secondaryColor,
                                        doubleTapDisable: true,
                                        fontSize: 15,
                                        initialLabelIndex: tab,
                                        activeBgColor: const [buttonForeground],
                                        activeFgColor: secondaryColor,
                                        inactiveBgColor: Colors.white,
                                        inactiveFgColor: secondaryColor,
                                        totalSwitches: 2,
                                        icons: const [
                                          Icons.view_agenda,
                                          Icons.auto_awesome_mosaic
                                        ],
                                        labels: const ['List', 'Card'],
                                        onToggle: (index) {
                                          if (index == null) {
                                            setState(() {
                                              tab = 0;
                                              listCard = true;
                                            });
                                          } else {
                                            setState(() {
                                              tab = index;
                                              listCard = !listCard;
                                            });
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // listCard == true ? listView() : cardView(),
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget listView() {
  //   return Flexible(
  //       flex: 2,
  //       child: HelpdeskListView(
  //         data: chartdataTable1,
  //         tappedValue: tappedValue,
  //         tableName: tableName,
  //       ));
  // }
  //
  // Widget cardView() {
  //   final scaleFactor = MediaQuery.of(context).textScaleFactor;
  //   return Flexible(
  //     flex: 2,
  //     child: HelpdeskCardView(
  //         data: chartdataTable1,
  //         tappedValue: tappedValue,
  //         tableName: tableName),
  //   );
  // }
}

class PPMTrends {
  String? label;
  String? data;
  int? y;

  PPMTrends({this.label, this.data, this.y});

  PPMTrends.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    data = json['data'];
    y = json['y'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    data['data'] = this.data;
    data['y'] = this.y;
    return data;
  }
}
