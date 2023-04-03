import 'dart:async';
import 'dart:convert';
import '../../Widgets/web/shimmer.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gradient_colors/flutter_gradient_colors.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:xceed/Styles/responsive.dart';
import 'package:http/http.dart' as http;
import '../../Config.dart';
import '../../Styles/CommonColor.dart';
import '../../Styles/CommonTextStyle.dart';
import '../../Widgets/mobile/shimmer.dart';
import '../helpdesk/performance.dart';

class PpmPerformance extends StatefulWidget {
  final dynamic getFunc;
  bool? sideNav, singCardView, detailBackMenu;
  String? pageName;
  PpmPerformance(
      {Key? key,
      this.sideNav,
      this.singCardView,
      this.getFunc,
      this.detailBackMenu,
      this.pageName})
      : super(key: key);

  @override
  State<PpmPerformance> createState() => _PpmPerformanceState();
}

class _PpmPerformanceState extends State<PpmPerformance> {
  bool timer = true, menuState = true, positive = true, listCard = true;
  String types = 'Select Type';
  var tappedValue, tableName;
  int daysButton = 0, tab = 0;
  List<Total> PerformPrec = [];
  List<Closed> TargetPerc = [];
  List<PerformPre> dayWise = [];
  List<TargetPer> dayWise1 = [];
  final labels = ["7D", "10D", "30D"];

  @override
  void initState() {
    super.initState();
    monthWise();
    dayWiseApi();
  }

  Future<void> monthWise() async {
    String? ip = '/VwDPPMPerfomanceMonth/';
    const service = ApiConfig.service;
    final url = Uri.parse('$service$ip');
    final headers = {
      'Accept': 'application/json'
      // 'Content-Type': 'application/json'
    };
    const json =
        '{"data":{"CountryID_varchar":0,"CustomerID_varchar":0,"ContractID_varchar":0,"LocationGroupID_varchar":0,"LocalityID_varchar":0,"BuildingID_varchar":0,"CityID_varchar":0,"FloorID_varchar":0,"SpotID_varchar":0,"DivisionID_varchar":0,"DisciplineID_varchar":0,"ServiceTypeID_varchar":0,"FromDate_datetime":"2023-03-01","ToDate_datetime":"2023-03-01","LocUserID_int":"6","PortalUserID_bit":0}}';
    final response =
        await http.post(url, headers: headers, body: json.toString());
    if (response.statusCode == 400) {
      String err = 'something went wrong!';
    } else {
      final String jsonString = jsonEncode(response.body);
      var decodedJson = jsonDecode(jsonString);
      Map<String, dynamic> map = jsonDecode(decodedJson);
      var result = map['PerfomanceMonthStatus']['PerformPrec'];
      var result1 = map['PerfomanceMonthStatus']['TargetPerc'];
      for (Map<String, dynamic> i in result) {
        PerformPrec.add(Total.fromJson(i));
      }
      for (Map<String, dynamic> i in result1) {
        TargetPerc.add(Closed.fromJson(i));
      }
      timerFunction();
    }
  }

  Future<void> dayWiseApi() async {
    String? ip = '/VwDPPMPerfomanceDay/';
    const service = ApiConfig.service;
    final url = Uri.parse('$service$ip');
    final headers = {'Accept': 'application/json'};
    const json =
        '{"data":{"CountryID_varchar":0,"CustomerID_varchar":0,"ContractID_varchar":0,"LocationGroupID_varchar":0,"LocalityID_varchar":0,"BuildingID_varchar":0,"CityID_varchar":0,"FloorID_varchar":0,"SpotID_varchar":0,"DivisionID_varchar":0,"DisciplineID_varchar":0,"ServiceTypeID_varchar":0,"FromDate_datetime":"2023-01-31","ToDate_datetime":"2023-03-01","LocUserID_int":"6","PortalUserID_bit":0}}';
    final response =
        await http.post(url, headers: headers, body: json.toString());
    if (response.statusCode == 400) {
      String err = 'something went wrong!';
    } else {
      final String jsonString = jsonEncode(response.body);
      var decodedJson = jsonDecode(jsonString);
      Map<String, dynamic> map = jsonDecode(decodedJson);
      var result = map['PerfomanceDayStatus']['PerformPrec'];
      var result1 = map['PerfomanceDayStatus']['TargetPerc'];
      for (Map<String, dynamic> i in result) {
        dayWise.add(PerformPre.fromJson(i));
      }
      for (Map<String, dynamic> i in result1) {
        dayWise1.add(TargetPer.fromJson(i));
      }
      timerFunction();
    }
  }

  void timerFunction() {
    Timer(const Duration(seconds: 2), () {
      setState(() {
        timer = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Responsive(mobile: mobileCharts(), desktop: webCharts());
  }

  Widget webCharts() {
    double chartHeight = MediaQuery.of(context).size.height * 0.88;

    return Padding(
        padding: const EdgeInsets.only(
          right: 5.0,
          bottom: 8.0,
        ),
        child: timer == true
            ? webShimmer(chartHeight)
            : widget.singCardView == false
                ? Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    color: Colors.white,
                    elevation: 3,
                    shadowColor: Colors.transparent,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        webControls(),
                        chartS(),
                      ],
                    ),
                  )
                : detailChartAndTableView(context));
  }

  Widget mobileCharts() {
    double shimmerHeight = 630;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: timer == true
          ? MobileShimmer(shimmerHeight)
          : Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              color: Colors.white,
              elevation: 3,
              shadowColor: Colors.transparent,
              child: Column(
                children: [
                  mobileControls(),
                  chartS(),
                ],
              ),
            ),
    );
  }

  Widget chartS() {
    return positive == true
        ? Flexible(
            flex: 2,
            child: SfCartesianChart(
                plotAreaBorderWidth: 0,
                tooltipBehavior: TooltipBehavior(enable: true),
                legend: Legend(isVisible: true),
                primaryXAxis: CategoryAxis(
                    interval: 1,
                    maximumLabelWidth: 30,
                    borderColor: Colors.black,
                    isVisible: true,
                    majorGridLines:
                        const MajorGridLines(color: Colors.transparent),
                    arrangeByIndex: false),
                zoomPanBehavior: ZoomPanBehavior(
                  enableMouseWheelZooming: true,
                  zoomMode: ZoomMode.x,
                  enableDoubleTapZooming: true,
                  enableSelectionZooming: true,
                  enablePanning: true,
                  enablePinching: true,
                ),
                series: <ChartSeries>[
                  ColumnSeries<Total, String>(
                    // onPointTap: (pointInteractionDetails) {
                    //   var val;
                    //   val = (pointInteractionDetails
                    //           .dataPoints![pointInteractionDetails.pointIndex!]
                    //           .y)
                    //       .toString();
                    //   print(val);
                    //   setState(() {
                    //     tableName = 'By Division';
                    //     tappedValue = val;
                    //   });
                    //
                    //   chartTappedDataTable();
                    // },
                    dataSource: PerformPrec,
                    xValueMapper: (Total data, _) => data.label,
                    yValueMapper: (Total data, _) => data.y,
                    trackColor: Colors.transparent,
                    name: 'Performance',
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15)),
                    gradient: const LinearGradient(
                        colors: GradientColors.juicyOrange),
                    dataLabelSettings: const DataLabelSettings(
                        isVisible: true,
                        color: Colors.black,
                        opacity: 0.8,
                        labelAlignment: ChartDataLabelAlignment.outer),
                  ),
                  ColumnSeries<Closed, String>(
                    // onPointTap: (pointInteractionDetails) {
                    //   var val;
                    //   val = (pointInteractionDetails
                    //           .dataPoints![pointInteractionDetails.pointIndex!]
                    //           .y)
                    //       .toString();
                    //   print(val);
                    //   setState(() {
                    //     tableName = 'By Division';
                    //     tappedValue = val;
                    //   });
                    //
                    //   chartTappedDataTable();
                    // },
                    dataSource: TargetPerc,
                    xValueMapper: (Closed data, _) => data.label,
                    yValueMapper: (Closed data, _) => data.y,
                    trackColor: Colors.transparent,
                    name: 'Target',
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15)),
                    gradient:
                        const LinearGradient(colors: GradientColors.purpleLove),
                    dataLabelSettings: const DataLabelSettings(
                        isVisible: true,
                        color: Colors.black,
                        opacity: 0.8,
                        labelAlignment: ChartDataLabelAlignment.outer),
                  ),
                ]),
          )
        : Flexible(
            flex: 2,
            child: SfCartesianChart(
                plotAreaBorderWidth: 0,
                tooltipBehavior: TooltipBehavior(enable: true),
                legend: Legend(isVisible: true),
                primaryXAxis: CategoryAxis(
                    interval: 1,
                    maximumLabelWidth: 26,
                    borderColor: Colors.black,
                    isVisible: true,
                    majorGridLines:
                        const MajorGridLines(color: Colors.transparent),
                    arrangeByIndex: false),
                zoomPanBehavior: ZoomPanBehavior(
                  enableMouseWheelZooming: true,
                  zoomMode: ZoomMode.x,
                  enableDoubleTapZooming: true,
                  enableSelectionZooming: true,
                  enablePanning: true,
                  enablePinching: true,
                ),
                series: <ChartSeries>[
                  ColumnSeries<PerformPre, String>(
                    // onPointTap: (pointInteractionDetails) {
                    //   var val;
                    //   val = (pointInteractionDetails
                    //           .dataPoints![pointInteractionDetails.pointIndex!]
                    //           .y)
                    //       .toString();
                    //   print(val);
                    //   setState(() {
                    //     tableName = 'By Division';
                    //     tappedValue = val;
                    //   });
                    //
                    //   chartTappedDataTable();
                    // },
                    dataSource: dayWise,
                    xValueMapper: (PerformPre data, _) => data.label,
                    yValueMapper: (PerformPre data, _) => data.y,
                    trackColor: Colors.transparent,
                    name: 'Performance',
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15)),
                    gradient:
                        const LinearGradient(colors: GradientColors.plumPlate),
                    dataLabelSettings: const DataLabelSettings(
                        isVisible: true,
                        color: Colors.black,
                        opacity: 0.8,
                        labelAlignment: ChartDataLabelAlignment.outer),
                  ),
                  ColumnSeries<TargetPer, String>(
                    // onPointTap: (pointInteractionDetails) {
                    //   var val;
                    //   val = (pointInteractionDetails
                    //           .dataPoints![pointInteractionDetails.pointIndex!]
                    //           .y)
                    //       .toString();
                    //   print(val);
                    //   setState(() {
                    //     tableName = 'By Division';
                    //     tappedValue = val;
                    //   });
                    //
                    //   chartTappedDataTable();
                    // },
                    dataSource: dayWise1,
                    xValueMapper: (TargetPer data, _) => data.label,
                    yValueMapper: (TargetPer data, _) => data.y,
                    trackColor: Colors.transparent,
                    name: 'Target',
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15)),
                    gradient: const LinearGradient(colors: GradientColors.ver),
                    dataLabelSettings: const DataLabelSettings(
                        isVisible: true,
                        color: Colors.black,
                        opacity: 0.8,
                        labelAlignment: ChartDataLabelAlignment.outer),
                  )
                ]),
          );
  }

  Widget webControls() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            flex: 2,
            child: positive == true
                ? const Text(' PPM Month Wise Performance Status',
                    style: cartHeaderStyle)
                : const Text(' PPM Day Wise Performance Status',
                    style: cartHeaderStyle),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  positive == true
                      ? Row(
                          children: [
                            SizedBox(
                              height: 46,
                              child: Card(
                                color: buttonForeground,
                                shadowColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                elevation: 3,
                                clipBehavior: Clip.antiAlias,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: const [
                                      Text('2022',
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: secondaryColor,
                                              fontWeight: FontWeight.w600)),
                                      Icon(Icons.keyboard_arrow_down,
                                          color: secondaryColor)
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            PopupMenuButton(
                              splashRadius: 0,
                              tooltip: 'Select Type',
                              position: PopupMenuPosition.under,
                              elevation: 2,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                              child: SizedBox(
                                height: 46,
                                child: Card(
                                  color: buttonForeground,
                                  shadowColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  elevation: 3,
                                  clipBehavior: Clip.antiAlias,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(types,
                                            style: const TextStyle(
                                                fontSize: 13,
                                                color: secondaryColor,
                                                fontWeight: FontWeight.w600)),
                                        const Icon(Icons.keyboard_arrow_down,
                                            color: secondaryColor)
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  onTap: () => {
                                    setState(() {
                                      types = 'Complaints';
                                    })
                                  },
                                  child: const SizedBox(
                                    height: 15,
                                    child: Text('Complaints',
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: secondaryColor)),
                                  ),
                                ),
                                PopupMenuItem(
                                  onTap: () => {
                                    setState(() {
                                      types = 'Service Request';
                                    })
                                  },
                                  child: const SizedBox(
                                    height: 15,
                                    child: Text('Service Request',
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: secondaryColor)),
                                  ),
                                ),
                                PopupMenuItem(
                                  onTap: () => {
                                    setState(() {
                                      types = 'Incidents';
                                    })
                                  },
                                  child: const SizedBox(
                                    height: 15,
                                    child: Text('Incidents',
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: secondaryColor)),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      : SizedBox(
                          height: 43,
                          width: 182,
                          child: Tooltip(
                            message: 'Selected Days',
                            child: ToggleSwitch(
                              cornerRadius: 10.0,
                              // customTextStyles: const [
                              //   TextStyle(
                              //       fontWeight: FontWeight.w600, color: Colors.white)
                              // ],
                              minWidth: 60.0,
                              minHeight: 60.0,
                              animate: true,
                              animationDuration: 500,
                              dividerColor: secondaryColor,
                              // doubleTapDisable: true,
                              fontSize: 12,
                              initialLabelIndex: 0,
                              activeBgColor: const [secondaryColor],
                              activeFgColor: Colors.white,
                              inactiveBgColor: buttonForeground,
                              inactiveFgColor: secondaryColor,
                              totalSwitches: 3,
                              labels: labels,
                              onToggle: (index) {
                                print('switched to: $index');
                              },
                            ),
                          ),
                        ),
                ],
              ),
              const SizedBox(width: 10),
              SizedBox(
                height: 40,
                width: 150,
                child: AnimatedToggleSwitch<bool>.dual(
                  current: positive,
                  first: false,
                  second: true,
                  dif: 50.0,
                  borderColor: Colors.transparent,
                  borderWidth: 5.0,
                  height: 55,
                  borderRadius: BorderRadius.circular(10.0),
                  innerColor: buttonForeground,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      spreadRadius: -8.0,
                      blurRadius: 8.0,
                      offset: Offset(-4.0, 4.0),
                    ),

                    // BoxShadow(
                    //   color: Colors.black26,
                    //   spreadRadius: 1.0,
                    //   blurRadius: 11.0,
                    //   offset: Offset(4.0, 4.0),
                    // ),
                    // BoxShadow(
                    //   color: Colors.white,
                    //   spreadRadius: 1.0,
                    //   blurRadius: 15.0,
                    //   offset: Offset(-5.0, -4.0),
                    // ),
                  ],
                  foregroundBoxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: Offset(0, 1.5),
                    ),
                  ],
                  onChanged: (b) => setState(() => positive = b),
                  colorBuilder: (b) => b ? secondaryColor : secondaryColor,
                  iconBuilder: (value) => value
                      ? const Icon(Icons.calendar_today,
                          size: 12, color: Colors.white)
                      : const Icon(Icons.calendar_month,
                          size: 12, color: Colors.white),
                  textBuilder: (value) => value
                      ? const Center(
                          child: Text(
                          'Month Wise',
                          style: TextStyle(
                              color: secondaryColor,
                              fontSize: 13,
                              fontWeight: FontWeight.w600),
                        ))
                      : const Center(
                          child: Text(
                          'Day Wise',
                          style: TextStyle(
                              color: secondaryColor,
                              fontSize: 13,
                              fontWeight: FontWeight.w600),
                        )),
                ),
              ),
              const SizedBox(width: 10),
              const Icon(Icons.mail, color: secondaryColor),
            ],
          ),
        ],
      ),
    );
  }

  Widget mobileControls() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 2,
                child: positive == true
                    ? const Text(' PPM Month Wise Performance Status',
                        style: cartHeaderStyle)
                    : const Text(' PPM Day Wise Performance Status',
                        style: cartHeaderStyle),
              ),
              const Icon(Icons.mail, color: secondaryColor),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              positive == true
                  ? Row(
                      children: [
                        SizedBox(
                          height: 46,
                          child: Card(
                            color: buttonForeground,
                            shadowColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            elevation: 3,
                            clipBehavior: Clip.antiAlias,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: const [
                                  Text('2022',
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: secondaryColor,
                                          fontWeight: FontWeight.w600)),
                                  Icon(Icons.keyboard_arrow_down,
                                      color: secondaryColor)
                                ],
                              ),
                            ),
                          ),
                        ),
                        PopupMenuButton(
                          splashRadius: 0,
                          tooltip: 'Select Type',
                          position: PopupMenuPosition.under,
                          elevation: 2,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                          ),
                          child: SizedBox(
                            height: 46,
                            child: Card(
                              color: buttonForeground,
                              shadowColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              elevation: 3,
                              clipBehavior: Clip.antiAlias,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(types,
                                        style: const TextStyle(
                                            fontSize: 13,
                                            color: secondaryColor,
                                            fontWeight: FontWeight.w600)),
                                    const Icon(Icons.keyboard_arrow_down,
                                        color: secondaryColor)
                                  ],
                                ),
                              ),
                            ),
                          ),
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              onTap: () => {
                                setState(() {
                                  types = 'Complaints';
                                })
                              },
                              child: const SizedBox(
                                height: 15,
                                child: Text('Complaints',
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: secondaryColor)),
                              ),
                            ),
                            PopupMenuItem(
                              onTap: () => {
                                setState(() {
                                  types = 'Service Request';
                                })
                              },
                              child: const SizedBox(
                                height: 15,
                                child: Text('Service Request',
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: secondaryColor)),
                              ),
                            ),
                            PopupMenuItem(
                              onTap: () => {
                                setState(() {
                                  types = 'Incidents';
                                })
                              },
                              child: const SizedBox(
                                height: 15,
                                child: Text('Incidents',
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: secondaryColor)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  : SizedBox(
                      height: 40,
                      child: Tooltip(
                        message: 'Selected Days',
                        child: ToggleSwitch(
                          cornerRadius: 10.0,
                          // customTextStyles: const [
                          //   TextStyle(
                          //       fontWeight: FontWeight.w600, color: Colors.white)
                          // ],
                          minWidth: 40.0,
                          minHeight: 60.0,
                          // doubleTapDisable: true,
                          fontSize: 10,
                          initialLabelIndex: 0,
                          activeBgColor: const [secondaryColor],
                          activeFgColor: Colors.white,
                          inactiveBgColor: Colors.grey[200],
                          inactiveFgColor: secondaryColor,
                          totalSwitches: 3,
                          labels: labels,
                          onToggle: (index) {
                            print('switched to: $index');
                          },
                        ),
                      ),
                    ),
              Flexible(
                flex: 2,
                child: SizedBox(
                  height: 40,
                  width: 150,
                  child: AnimatedToggleSwitch<bool>.dual(
                    current: positive,
                    first: false,
                    second: true,
                    dif: 50.0,
                    borderColor: Colors.transparent,
                    borderWidth: 5.0,
                    height: 55,
                    borderRadius: BorderRadius.circular(10.0),
                    innerColor: buttonForeground,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        spreadRadius: -8.0,
                        blurRadius: 8.0,
                        offset: Offset(-4.0, 4.0),
                      ),
                    ],
                    foregroundBoxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: Offset(0, 1.5),
                      ),
                    ],
                    onChanged: (b) => setState(() => positive = b),
                    colorBuilder: (b) => b ? secondaryColor : secondaryColor,
                    iconBuilder: (value) => value
                        ? const Icon(Icons.calendar_today,
                            size: 12, color: Colors.white)
                        : const Icon(Icons.calendar_month,
                            size: 12, color: Colors.white),
                    textBuilder: (value) => value
                        ? const Center(
                            child: Text(
                            'Month Wise',
                            style: TextStyle(
                                color: secondaryColor,
                                fontSize: 13,
                                fontWeight: FontWeight.w600),
                          ))
                        : const Center(
                            child: Text(
                            'Day Wise',
                            style: TextStyle(
                                color: secondaryColor,
                                fontSize: 13,
                                fontWeight: FontWeight.w600),
                          )),
                  ),
                ),
              ),
            ],
          ),
        ],
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
                child: timer == true
                    ? webShimmer(shimmerHeight)
                    : Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        color: Colors.white,
                        elevation: 3,
                        shadowColor: Colors.transparent,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            webControls(),
                            chartS(),
                          ],
                        ),
                      ),
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
}

class PerformPre {
  String? label;
  String? data;
  int? y;

  PerformPre({this.label, this.data, this.y});

  PerformPre.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    data = json['data'];
    y = json['y'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['label'] = label;
    data['data'] = data;
    data['y'] = y;
    return data;
  }
}

class TargetPer {
  String? label;
  int? y;

  TargetPer({this.label, this.y});

  TargetPer.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    y = json['y'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['label'] = label;
    data['y'] = y;
    return data;
  }
}
