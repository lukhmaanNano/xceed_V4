import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_gradient_colors/flutter_gradient_colors.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '../../Config.dart';
import '../../Styles/CommonColor.dart';
import '../../Styles/CommonTextStyle.dart';
import '../../Styles/responsive.dart';
import '../../Widgets/mobile/shimmer.dart';
import '../../Widgets/web/ppm/ppmCardView.dart';
import '../../Widgets/web/ppm/ppmListView.dart';
import '../../Widgets/web/shimmer.dart';
import '../helpdesk/status.dart';

class PpmStatus extends StatefulWidget {
  bool? sideNav, singCardView, detailBackMenu;
  String? pageName;
  final dynamic getFunc;
  PpmStatus(
      {Key? key,
      this.sideNav,
      this.singCardView,
      this.getFunc,
      this.detailBackMenu,
      this.pageName})
      : super(key: key);

  @override
  State<PpmStatus> createState() => _PpmStatusState();
}

class _PpmStatusState extends State<PpmStatus> {
  final _horizontalScrollController = ScrollController();
  final Duration delayed = const Duration(milliseconds: 300);
  bool menuState = true, timer = true, listCard = true;
  int tab = 0;
  late String tappedValue, tableName;
  String? userName, currentDate, startDate, day = 'Today', pageName;
  int? sessionId, barSeriesId, cardBorder = 0;
  List<dynamic> displayChart = [];
  List<dynamic> count = [];
  List<dynamic> OthersCount = [];
  List<VwDHDPopUpGrdDet> chartdataTable = [];
  List<VwDPPMPopUpGrdDet> chartdataTable1 = [];
  List<VwDPPMStatusBuildingWiseCount> byBuilding = [];
  List<VwDPPMFrequencyWisePerc> values = [];
  List<VwDPPMStatusOvuerDueDays> values1 = [];
  List<Open> values2 = [];
  List<Total> devTotal = [];
  List<Closed> devClose = [];
  List<Open> devOpen = [];
  List<Total> decTotal = [];
  List<Closed> decClose = [];
  List<Open> decOpen = [];
  List<Total> freqTotal = [];
  List<Closed> freqClose = [];
  List<Open> freqOpen = [];
  List<Total> empTotal = [];
  List<Closed> empClose = [];
  List<Open> empOpen = [];
  List<VwDPPMSLAAdheranceCount> slaValue = [];
  List<VwDPPMStatusStageWiseCount> processStage = [];

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd-MM-yyyy').format(now);
    final initialDate = now.subtract(const Duration(days: 30));
    String startdate = DateFormat('dd-MM-yyyy').format(initialDate);
    setState(() {
      startDate = startdate;
      currentDate = formattedDate;
      pageName = 'PPM Status';
    });
    openByFrequencyFun();
    ppmStatusCountApi();
    overDuePPMFun();
    ppmStatusOthersApi();
    divisionApi();
    disciplineApi();
    frequencyApi();
    buildingApi();
    employeeCountApi();
    slaAdherenceApi();
    processStageApi();
  }

  void timerFunction() {
    Timer(const Duration(seconds: 1), () {
      setState(() {
        timer = false;
      });
    });
  }

  Future<void> ppmStatusCountApi() async {
    String? ip = '/VwDPPMStatusCount/';
    const service = ApiConfig.service;
    final url = Uri.parse('$service$ip');
    final headers = {
      'Accept': 'application/json'
      // 'Content-Type': 'application/json'
    };
    const json =
        '{"data":{"CountryID_varchar":0,"CustomerID_varchar":0,"ContractID_varchar":0,"LocationGroupID_varchar":0,"LocalityID_varchar":0,"BuildingID_varchar":0,"CityID_varchar":0,"FloorID_varchar":0,"SpotID_varchar":0,"DivisionID_varchar":0,"DisciplineID_varchar":0,"ServiceTypeID_varchar":0,"FromDate_datetime":"2023-01-28","ToDate_datetime":"2023-02-27","LocUserID_int":"6","PortalUserID_bit":0}}';
    final response =
        await http.post(url, headers: headers, body: json.toString());
    if (response.statusCode == 400) {
      String err = 'something went wrong!';
    } else {
      final String jsonString = jsonEncode(response.body);
      var decodedJson = jsonDecode(jsonString);
      Map<String, dynamic> map = jsonDecode(decodedJson);
      var result = map['VwDPPMStatusCount'];
      // for (Map<String, dynamic> i in result) {
      //   count.add(VwDPPMStatusCount.fromJson(i));
      // }
      setState(() {
        count = result;
      });
      timerFunction();
    }
  }

  Future<void> openByFrequencyFun() async {
    String? ip = '/VwDPPMFrequencyWisePerc/';
    const service = ApiConfig.service;
    final url = Uri.parse('$service$ip');
    final headers = {
      'Accept': 'application/json'
      // 'Content-Type': 'application/json'
    };
    const json =
        '{"data":{"CountryID_varchar":0,"CustomerID_varchar":0,"ContractID_varchar":0,"LocationGroupID_varchar":0,"LocalityID_varchar":0,"BuildingID_varchar":0,"CityID_varchar":0,"FloorID_varchar":0,"SpotID_varchar":0,"DivisionID_varchar":0,"DisciplineID_varchar":0,"ServiceTypeID_varchar":0,"FromDate_datetime":"2023-01-29","ToDate_datetime":"2023-02-28","LocUserID_int":"6","PortalUserID_bit":0}}';
    final response =
        await http.post(url, headers: headers, body: json.toString());
    if (response.statusCode == 400) {
      String err = 'something went wrong!';
    } else {
      final String jsonString = jsonEncode(response.body);
      var decodedJson = jsonDecode(jsonString);
      Map<String, dynamic> map = jsonDecode(decodedJson);
      var result = map['VwDPPMFrequencyWisePerc'];
      for (Map<String, dynamic> i in result) {
        values.add(VwDPPMFrequencyWisePerc.fromJson(i));
      }
      timerFunction();
    }
  }

  Future<void> overDuePPMFun() async {
    String? ip = '/VwDPPMStatusOvuerDueDays/';
    const service = ApiConfig.service;
    final url = Uri.parse('$service$ip');
    final headers = {
      'Accept': 'application/json'
      // 'Content-Type': 'application/json'
    };
    const json =
        '{"data":{"CountryID_varchar":0,"CustomerID_varchar":0,"ContractID_varchar":0,"LocationGroupID_varchar":0,"LocalityID_varchar":0,"BuildingID_varchar":0,"CityID_varchar":0,"FloorID_varchar":0,"SpotID_varchar":0,"DivisionID_varchar":0,"DisciplineID_varchar":0,"ServiceTypeID_varchar":0,"FromDate_datetime":"2023-01-29","ToDate_datetime":"2023-02-28","LocUserID_int":"6","PortalUserID_bit":0}}';
    final response =
        await http.post(url, headers: headers, body: json.toString());
    if (response.statusCode == 400) {
      String err = 'something went wrong!';
    } else {
      final String jsonString = jsonEncode(response.body);
      var decodedJson = jsonDecode(jsonString);
      Map<String, dynamic> map = jsonDecode(decodedJson);
      var result = map['VwDPPMStatusOvuerDueDays'];
      for (Map<String, dynamic> i in result) {
        values1.add(VwDPPMStatusOvuerDueDays.fromJson(i));
      }
      timerFunction();
    }
  }

  Future<void> ppmStatusOthersApi() async {
    String? ip = '/VwDPPMStatusOthersCount/';
    const service = ApiConfig.service;
    final url = Uri.parse('$service$ip');
    final headers = {
      'Accept': 'application/json'
      // 'Content-Type': 'application/json'
    };
    const json =
        '{"data":{"CountryID_varchar":0,"CustomerID_varchar":0,"ContractID_varchar":0,"LocationGroupID_varchar":0,"LocalityID_varchar":0,"BuildingID_varchar":0,"CityID_varchar":0,"FloorID_varchar":0,"SpotID_varchar":0,"DivisionID_varchar":0,"DisciplineID_varchar":0,"ServiceTypeID_varchar":0,"FromDate_datetime":"2023-01-29","ToDate_datetime":"2023-02-28","LocUserID_int":"6","PortalUserID_bit":0}}';
    final response =
        await http.post(url, headers: headers, body: json.toString());
    if (response.statusCode == 400) {
      String err = 'something went wrong!';
    } else {
      final String jsonString = jsonEncode(response.body);
      var decodedJson = jsonDecode(jsonString);
      Map<String, dynamic> map = jsonDecode(decodedJson);
      var result = map['VwDPPMStatusOthersCount'];
      setState(() {
        OthersCount = result;
      });
      timerFunction();
    }
  }

  Future<void> divisionApi() async {
    String? ip = '/VwDPPMDivisionWiseCount/';
    const service = ApiConfig.service;
    final url = Uri.parse('$service$ip');
    final headers = {
      'Accept': 'application/json'
      // 'Content-Type': 'application/json'
    };
    const json =
        '{"data":{"CountryID_varchar":0,"CustomerID_varchar":0,"ContractID_varchar":0,"LocationGroupID_varchar":0,"LocalityID_varchar":0,"BuildingID_varchar":0,"CityID_varchar":0,"FloorID_varchar":0,"SpotID_varchar":0,"DivisionID_varchar":0,"DisciplineID_varchar":0,"ServiceTypeID_varchar":0,"FromDate_datetime":"2023-01-29","ToDate_datetime":"2023-02-28","LocUserID_int":"6","PortalUserID_bit":0}}';
    final response =
        await http.post(url, headers: headers, body: json.toString());
    if (response.statusCode == 400) {
      String err = 'something went wrong!';
    } else {
      final String jsonString = jsonEncode(response.body);
      var decodedJson = jsonDecode(jsonString);
      Map<String, dynamic> map = jsonDecode(decodedJson);
      var result = map['ByDivision']['Total'];
      var result1 = map['ByDivision']['Closed'];
      var result2 = map['ByDivision']['Open'];
      for (Map<String, dynamic> i in result) {
        devTotal.add(Total.fromJson(i));
      }
      for (Map<String, dynamic> i in result1) {
        devClose.add(Closed.fromJson(i));
      }
      for (Map<String, dynamic> i in result2) {
        devOpen.add(Open.fromJson(i));
      }
      timerFunction();
    }
  }

  Future<void> disciplineApi() async {
    String? ip = '/VwDPPMDisciplineWiseCount/';
    const service = ApiConfig.service;
    final url = Uri.parse('$service$ip');
    final headers = {
      'Accept': 'application/json'
      // 'Content-Type': 'application/json'
    };
    const json =
        '{"data":{"CountryID_varchar":0,"CustomerID_varchar":0,"ContractID_varchar":0,"LocationGroupID_varchar":0,"LocalityID_varchar":0,"BuildingID_varchar":0,"CityID_varchar":0,"FloorID_varchar":0,"SpotID_varchar":0,"DivisionID_varchar":0,"DisciplineID_varchar":0,"ServiceTypeID_varchar":0,"FromDate_datetime":"2023-01-29","ToDate_datetime":"2023-02-28","LocUserID_int":"6","PortalUserID_bit":0}}';
    final response =
        await http.post(url, headers: headers, body: json.toString());
    if (response.statusCode == 400) {
      String err = 'something went wrong!';
    } else {
      final String jsonString = jsonEncode(response.body);
      var decodedJson = jsonDecode(jsonString);
      Map<String, dynamic> map = jsonDecode(decodedJson);
      var result = map['ByDiscipline']['Total'];
      var result1 = map['ByDiscipline']['Closed'];
      var result2 = map['ByDiscipline']['Open'];
      for (Map<String, dynamic> i in result) {
        decTotal.add(Total.fromJson(i));
      }
      for (Map<String, dynamic> i in result1) {
        decClose.add(Closed.fromJson(i));
      }
      for (Map<String, dynamic> i in result2) {
        decOpen.add(Open.fromJson(i));
      }
      timerFunction();
    }
  }

  Future<void> frequencyApi() async {
    String? ip = '/VwDPPMStatusFrequencyWiseCount/';
    const service = ApiConfig.service;
    final url = Uri.parse('$service$ip');
    final headers = {'Accept': 'application/json'};
    const json =
        '{"data":{"CountryID_varchar":0,"CustomerID_varchar":0,"ContractID_varchar":0,"LocationGroupID_varchar":0,"LocalityID_varchar":0,"BuildingID_varchar":0,"CityID_varchar":0,"FloorID_varchar":0,"SpotID_varchar":0,"DivisionID_varchar":0,"DisciplineID_varchar":0,"ServiceTypeID_varchar":0,"FromDate_datetime":"2023-01-29","ToDate_datetime":"2023-02-28","LocUserID_int":"6","PortalUserID_bit":0}}';
    final response =
        await http.post(url, headers: headers, body: json.toString());
    if (response.statusCode == 400) {
      String err = 'something went wrong!';
    } else {
      final String jsonString = jsonEncode(response.body);
      var decodedJson = jsonDecode(jsonString);
      Map<String, dynamic> map = jsonDecode(decodedJson);
      var result = map['ByFrequency']['Total'];
      var result1 = map['ByFrequency']['Closed'];
      var result2 = map['ByFrequency']['Open'];
      for (Map<String, dynamic> i in result) {
        freqTotal.add(Total.fromJson(i));
      }
      for (Map<String, dynamic> i in result1) {
        freqClose.add(Closed.fromJson(i));
      }
      for (Map<String, dynamic> i in result2) {
        freqOpen.add(Open.fromJson(i));
      }
      timerFunction();
    }
  }

  Future<void> buildingApi() async {
    String? ip = '/VwDPPMStatusBuildingWiseCount/';
    const service = ApiConfig.service;
    final url = Uri.parse('$service$ip');
    final headers = {
      'Accept': 'application/json'
      // 'Content-Type': 'application/json'
    };
    const json =
        '{"data":{"CountryID_varchar":0,"CustomerID_varchar":0,"ContractID_varchar":0,"LocationGroupID_varchar":0,"LocalityID_varchar":0,"BuildingID_varchar":0,"CityID_varchar":0,"FloorID_varchar":0,"SpotID_varchar":0,"DivisionID_varchar":0,"DisciplineID_varchar":0,"ServiceTypeID_varchar":0,"FromDate_datetime":"2023-01-29","ToDate_datetime":"2023-02-28","LocUserID_int":"6","PortalUserID_bit":0}}';
    final response =
        await http.post(url, headers: headers, body: json.toString());
    if (response.statusCode == 400) {
      String err = 'something went wrong!';
    } else {
      final String jsonString = jsonEncode(response.body);
      var decodedJson = jsonDecode(jsonString);
      Map<String, dynamic> map = jsonDecode(decodedJson);
      var result = map['VwDPPMStatusBuildingWiseCount'];
      for (Map<String, dynamic> i in result) {
        byBuilding.add(VwDPPMStatusBuildingWiseCount.fromJson(i));
      }
      timerFunction();
    }
  }

  Future<void> employeeCountApi() async {
    String? ip = '/VwDPPMStatusEmployeeWiseCount/';
    const service = ApiConfig.service;
    final url = Uri.parse('$service$ip');
    final headers = {
      'Accept': 'application/json'
      // 'Content-Type': 'application/json'
    };
    const json =
        '{"data":{"CountryID_varchar":0,"CustomerID_varchar":0,"ContractID_varchar":0,"LocationGroupID_varchar":0,"LocalityID_varchar":0,"BuildingID_varchar":0,"CityID_varchar":0,"FloorID_varchar":0,"SpotID_varchar":0,"DivisionID_varchar":0,"DisciplineID_varchar":0,"ServiceTypeID_varchar":0,"FromDate_datetime":"2023-01-29","ToDate_datetime":"2023-02-28","LocUserID_int":"6","PortalUserID_bit":0}}';
    final response =
        await http.post(url, headers: headers, body: json.toString());
    if (response.statusCode == 400) {
      String err = 'something went wrong!';
    } else {
      final String jsonString = jsonEncode(response.body);
      var decodedJson = jsonDecode(jsonString);
      Map<String, dynamic> map = jsonDecode(decodedJson);
      var result = map['ByEmployee']['Total'];
      var result1 = map['ByEmployee']['Closed'];
      var result2 = map['ByEmployee']['Open'];
      for (Map<String, dynamic> i in result) {
        empTotal.add(Total.fromJson(i));
      }
      for (Map<String, dynamic> i in result1) {
        empClose.add(Closed.fromJson(i));
      }
      for (Map<String, dynamic> i in result2) {
        empOpen.add(Open.fromJson(i));
      }
      timerFunction();
    }
  }

  Future<void> slaAdherenceApi() async {
    String? ip = '/VwDPPMSLAAdheranceCount/';
    const service = ApiConfig.service;
    final url = Uri.parse('$service$ip');
    final headers = {'Accept': 'application/json'};
    const json =
        '{"data":{"CountryID_varchar":0,"CustomerID_varchar":0,"ContractID_varchar":0,"LocationGroupID_varchar":0,"LocalityID_varchar":0,"BuildingID_varchar":0,"CityID_varchar":0,"FloorID_varchar":0,"SpotID_varchar":0,"DivisionID_varchar":0,"DisciplineID_varchar":0,"ServiceTypeID_varchar":0,"FromDate_datetime":"2021-01-04","ToDate_datetime":"2023-03-01","LocUserID_int":"6","PortalUserID_bit":0}}';
    final response =
        await http.post(url, headers: headers, body: json.toString());
    if (response.statusCode == 400) {
      String err = 'something went wrong!';
    } else {
      final String jsonString = jsonEncode(response.body);
      var decodedJson = jsonDecode(jsonString);
      Map<String, dynamic> map = jsonDecode(decodedJson);
      var result = map['VwDPPMSLAAdheranceCount'];
      for (Map<String, dynamic> i in result) {
        slaValue.add(VwDPPMSLAAdheranceCount.fromJson(i));
      }
      timerFunction();
    }
  }

  Future<void> processStageApi() async {
    String? ip = '/VwDPPMStatusStageWiseCount/';
    const service = ApiConfig.service;
    final url = Uri.parse('$service$ip');
    final headers = {'Accept': 'application/json'};
    const json =
        '{"data":{"CountryID_varchar":0,"CustomerID_varchar":0,"ContractID_varchar":0,"LocationGroupID_varchar":0,"LocalityID_varchar":0,"BuildingID_varchar":0,"CityID_varchar":0,"FloorID_varchar":0,"SpotID_varchar":0,"DivisionID_varchar":0,"DisciplineID_varchar":0,"ServiceTypeID_varchar":0,"FromDate_datetime":"2023-01-30","ToDate_datetime":"2023-03-01","LocUserID_int":"6","PortalUserID_bit":0}}';
    final response =
        await http.post(url, headers: headers, body: json.toString());
    if (response.statusCode == 400) {
      String err = 'something went wrong!';
    } else {
      final String jsonString = jsonEncode(response.body);
      var decodedJson = jsonDecode(jsonString);
      Map<String, dynamic> map = jsonDecode(decodedJson);
      var result = map['VwDPPMStatusStageWiseCount'];
      for (Map<String, dynamic> i in result) {
        processStage.add(VwDPPMStatusStageWiseCount.fromJson(i));
      }
      timerFunction();
    }
  }

  Future<void> chartTappedDataTable() async {
    cardBorder = 5;
    displayChartWidget();
    setState(() {
      displayChart.insert(0, displayChart.removeAt(4));
    });
    chartdataTable1.clear();
    String? ip = '/VwDPPMPopUpGrdDet/';
    const service = ApiConfig.service;
    final url = Uri.parse('$service$ip');
    final headers = {'Accept': 'application/json'};
    final json =
        '{"data":{"CountryID_varchar":0,"CustomerID_varchar":0,"ContractID_varchar":0,"LocationGroupID_varchar":0,"LocalityID_varchar":0,"BuildingID_varchar":0,"CityID_varchar":0,"FloorID_varchar":0,"SpotID_varchar":0,"DivisionID_varchar":0,"DisciplineID_varchar":0,"ServiceTypeID_varchar":0,"FromDate_datetime":"2023-01-30","ToDate_datetime":"2023-03-01","LocUserID_int":"6","PortalUserID_bit":0,"HeaderID_int":21,"DataParam_varchar":"$tappedValue","PageIndex_int":1,"PageSize_int":10,"ResultCount_int":null}}';
    final response =
        await http.post(url, headers: headers, body: json.toString());
    if (response.statusCode == 400) {
      String err = 'something went wrong!';
    } else {
      final String jsonString = jsonEncode(response.body);
      var decodedJson = jsonDecode(jsonString);
      Map<String, dynamic> map = jsonDecode(decodedJson);
      var result = map['VwDPPMPopUpGrdDet'];
      for (Map<String, dynamic> i in result) {
        chartdataTable1.add(VwDPPMPopUpGrdDet.fromJson(i));
      }
      timerFunction();
    }
    setState(() {
      widget.singCardView = true;
      widget.detailBackMenu = true;
      widget.sideNav = false;
      widget.pageName = 'PPM Status';
    });

    widget.getFunc(
      widget.sideNav,
      widget.detailBackMenu,
      widget.pageName,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Responsive(
        mobile: mobileChartView(),
        desktop: widget.singCardView == false
            ? webChartView()
            : detailChartAndTableView(context));
  }

  Widget mobileChartView() {
    double shimmerHeight = 300;
    double chartHeight = MediaQuery.of(context).size.height * 0.90;
    double chartWidth = MediaQuery.of(context).size.width * 0.97;
    const TextStyle columnStyle = TextStyle(
        color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600);
    const TextStyle rowstyle = TextStyle(
        // overflow: TextOverflow.ellipsis,
        fontSize: 10,
        color: Colors.black,
        fontWeight: FontWeight.w500);
    return Padding(
      padding: const EdgeInsets.only(left: 6.0),
      child: SizedBox(
        height: chartHeight,
        width: chartWidth,
        // decoration: BoxDecoration(border: Border.all(color: Colors.red)),
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: CustomScrollView(slivers: <Widget>[
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Row(
                    children: [
                      Flexible(
                        flex: 2,
                        child: timer == true
                            ? MobileShimmer(shimmerHeight)
                            : ppmStatusChart(),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        flex: 2,
                        child: timer == true
                            ? MobileShimmer(shimmerHeight)
                            : openByFrequency(),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        flex: 2,
                        child: timer == true
                            ? MobileShimmer(shimmerHeight)
                            : overDuePPM(),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        flex: 2,
                        child: timer == true
                            ? MobileShimmer(shimmerHeight)
                            : ppmStatusOther(),
                      ),
                    ],
                  ),

                  Row(
                    children: [
                      Flexible(
                        flex: 2,
                        child: timer == true
                            ? MobileShimmer(shimmerHeight)
                            : divisionChart(),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        flex: 2,
                        child: timer == true
                            ? MobileShimmer(shimmerHeight)
                            : disciplineChart(),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        flex: 2,
                        child: timer == true
                            ? MobileShimmer(shimmerHeight)
                            : buildingTable(),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        flex: 2,
                        child: timer == true
                            ? MobileShimmer(shimmerHeight)
                            : frequencyChart(),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        flex: 2,
                        child: timer == true
                            ? MobileShimmer(shimmerHeight)
                            : employeeChart(),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        flex: 2,
                        child: timer == true
                            ? MobileShimmer(shimmerHeight)
                            : slaAdherenceChart(),
                      ),
                    ],
                  ),
                  // Row(
                  //   children: [
                  //     Flexible(
                  //       flex: 2,
                  //       child: Card(
                  //         shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(15),
                  //         ),
                  //         color: Colors.white,
                  //         elevation: 3,
                  //         shadowColor: Colors.transparent,
                  //         child: Padding(
                  //           padding: const EdgeInsets.all(8.0),
                  //           child: Column(
                  //             children: [
                  //               Padding(
                  //                 padding: const EdgeInsets.symmetric(
                  //                     vertical: 8.0, horizontal: 8.0),
                  //                 child: Row(
                  //                   mainAxisAlignment:
                  //                       MainAxisAlignment.spaceBetween,
                  //                   crossAxisAlignment:
                  //                       CrossAxisAlignment.start,
                  //                   children: const [
                  //                     Flexible(
                  //                         flex: 2,
                  //                         child: Text(' By Service Type',
                  //                             style: cartHeaderStyle)),
                  //                     Icon(Icons.mail, color: secondaryColor),
                  //                   ],
                  //                 ),
                  //               ),
                  //               SizedBox(
                  //                 height: 260,
                  //                 child: SfCartesianChart(
                  //                     plotAreaBorderWidth: 0,
                  //                     tooltipBehavior:
                  //                         TooltipBehavior(enable: true),
                  //                     legend: Legend(isVisible: true),
                  //                     primaryXAxis: CategoryAxis(
                  //                       isVisible: false,
                  //                     ),
                  //                     primaryYAxis: NumericAxis(
                  //                         minimum: 0,
                  //                         maximum: 40,
                  //                         interval: 10),
                  //                     series: <ChartSeries>[
                  //                       AreaSeries<fourthData, String>(
                  //                         dataLabelSettings:
                  //                             const DataLabelSettings(
                  //                                 labelAlignment:
                  //                                     ChartDataLabelAlignment
                  //                                         .middle,
                  //                                 color: Colors.black,
                  //                                 isVisible: true),
                  //                         dataSource: data1,
                  //                         name: 'Gold',
                  //                         xValueMapper: (fourthData data, _) =>
                  //                             data.x,
                  //                         yValueMapper: (fourthData data, _) =>
                  //                             data.y,
                  //                         gradient: const LinearGradient(
                  //                             colors:
                  //                                 GradientColors.orangePink),
                  //                       ),
                  //                       AreaSeries<fourthData, String>(
                  //                         dataSource: data2,
                  //                         xValueMapper: (fourthData data, _) =>
                  //                             data.x,
                  //                         yValueMapper: (fourthData data, _) =>
                  //                             data.y,
                  //                         name: 'Gold',
                  //                         gradient: const LinearGradient(
                  //                             colors:
                  //                                 GradientColors.juicyOrange),
                  //                       )
                  //                     ]),
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // Row(children: [
                  //   Flexible(
                  //     flex: 2,
                  //     child: Card(
                  //         shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(15),
                  //         ),
                  //         color: Colors.white,
                  //         elevation: 3,
                  //         shadowColor: Colors.transparent,
                  //         child: Padding(
                  //           padding: const EdgeInsets.all(8.0),
                  //           child: Column(
                  //             children: [
                  //               Padding(
                  //                 padding: const EdgeInsets.symmetric(
                  //                     vertical: 8.0, horizontal: 8.0),
                  //                 child: Row(
                  //                   mainAxisAlignment:
                  //                       MainAxisAlignment.spaceBetween,
                  //                   crossAxisAlignment:
                  //                       CrossAxisAlignment.start,
                  //                   children: const [
                  //                     Flexible(
                  //                         flex: 2,
                  //                         child: Text(
                  //                             ' HelpDesk Month Wise Performance Status',
                  //                             style: cartHeaderStyle)),
                  //                     Icon(Icons.mail, color: secondaryColor),
                  //                   ],
                  //                 ),
                  //               ),
                  //               SizedBox(
                  //                 height: 260,
                  //                 child: SfCartesianChart(
                  //                     tooltipBehavior:
                  //                         TooltipBehavior(enable: true),
                  //                     plotAreaBorderWidth: 0,
                  //                     legend: Legend(
                  //                       isVisible: true,
                  //                     ),
                  //                     primaryXAxis: CategoryAxis(
                  //                       isVisible: false,
                  //                     ),
                  //                     series: <ChartSeries>[
                  //                       StackedColumn100Series<ChartData,
                  //                               String>(
                  //                           borderRadius:
                  //                               const BorderRadius.only(
                  //                                   bottomLeft:
                  //                                       Radius.circular(15),
                  //                                   bottomRight:
                  //                                       Radius.circular(15)),
                  //                           // gradient: const LinearGradient(
                  //                           //     colors: GradientColors.freshMilk),
                  //                           color: trending9,
                  //                           dataSource: chartData,
                  //                           name: 'Gold',
                  //                           xValueMapper: (ChartData data, _) =>
                  //                               data.x,
                  //                           yValueMapper: (ChartData data, _) =>
                  //                               data.y),
                  //                       StackedColumn100Series<ChartData,
                  //                               String>(
                  //                           // gradient: const LinearGradient(
                  //                           //     colors: GradientColors.warmFlame),
                  //                           color: trending10,
                  //                           dataSource: chartData,
                  //                           name: 'Gold1',
                  //                           xValueMapper: (ChartData data, _) =>
                  //                               data.x,
                  //                           yValueMapper: (ChartData data, _) =>
                  //                               data.y),
                  //                       StackedColumn100Series<ChartData,
                  //                               String>(
                  //                           // gradient: const LinearGradient(
                  //                           //     colors: GradientColors.gentleCare),
                  //                           color: trending11,
                  //                           name: 'Gold2',
                  //                           borderRadius:
                  //                               const BorderRadius.only(
                  //                                   topLeft:
                  //                                       Radius.circular(15),
                  //                                   topRight:
                  //                                       Radius.circular(15)),
                  //                           dataSource: chartData,
                  //                           xValueMapper: (ChartData data, _) =>
                  //                               data.x,
                  //                           yValueMapper: (ChartData data, _) =>
                  //                               data.y)
                  //                     ]),
                  //               ),
                  //             ],
                  //           ),
                  //         )),
                  //   )
                  // ]),
                  // Row(
                  //   children: [
                  //     Flexible(
                  //       flex: 2,
                  //       child: timer == true
                  //           ? MobileShimmer(shimmerHeight)
                  //           : slaResponseChart(),
                  //     )
                  //   ],
                  // ),
                  Row(
                    children: [
                      Flexible(
                        flex: 2,
                        child: timer == true
                            ? MobileShimmer(shimmerHeight)
                            : Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                color: Colors.white,
                                elevation: 4,
                                shadowColor: Colors.black12,
                                child: SizedBox(
                                  height: 220,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: const [
                                            Text('By Building',
                                                style: cartHeaderStyle),
                                            Icon(Icons.mail,
                                                color: secondaryColor),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8.0, right: 8.0, bottom: 8.0),
                                        child: Table(
                                            columnWidths: const {
                                              0: FlexColumnWidth(4),
                                              1: FlexColumnWidth(2),
                                              2: FlexColumnWidth(2),
                                              3: FlexColumnWidth(2),
                                            },
                                            border: const TableBorder(
                                              horizontalInside: BorderSide(
                                                  width: 1,
                                                  color: buttonForeground,
                                                  style: BorderStyle.solid),
                                            ),
                                            children: [
                                              const TableRow(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(
                                                                8.0),
                                                        topRight:
                                                            Radius.circular(
                                                                8.0),
                                                      ),
                                                      color: secondaryColor),
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      child: Text('Code',
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: columnStyle),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      child: Text('Total',
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: columnStyle),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      child: Text('Open',
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: columnStyle),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      child: Text('Close',
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: columnStyle),
                                                    ),
                                                  ]),
                                              for (var tabelJson
                                                  in byBuilding.sublist(0, 5))
                                                TableRow(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: tabelJson.buildingName ==
                                                              null
                                                          ? const Text('',
                                                              style: rowstyle)
                                                          : Text(
                                                              '${tabelJson.buildingName}',
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                              style: rowstyle),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Center(
                                                        child: tabelJson
                                                                    .total ==
                                                                null
                                                            ? const Text('',
                                                                style: rowstyle)
                                                            : Text(
                                                                '${tabelJson.total}',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style:
                                                                    rowstyle),
                                                      ),
                                                    ),
                                                    Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Center(
                                                          child: tabelJson
                                                                      .openCnt ==
                                                                  null
                                                              ? const Text(
                                                                  '',
                                                                  style:
                                                                      rowstyle)
                                                              : Text(
                                                                  '${tabelJson.openCnt}',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style:
                                                                      rowstyle),
                                                        )),
                                                    Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Center(
                                                          child: tabelJson
                                                                      .closed ==
                                                                  null
                                                              ? const Text(
                                                                  '',
                                                                  style:
                                                                      rowstyle)
                                                              : Text(
                                                                  '${tabelJson.closed}',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style:
                                                                      rowstyle),
                                                        ))
                                                  ],
                                                )
                                            ]),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                      )
                    ],
                  ),
                  // Row(children: [
                  //   Flexible(
                  //     flex: 2,
                  //     child: timer == true
                  //         ? MobileShimmer(shimmerHeight)
                  //         : Card(
                  //             shape: RoundedRectangleBorder(
                  //               borderRadius: BorderRadius.circular(15),
                  //             ),
                  //             color: Colors.white,
                  //             elevation: 3,
                  //             shadowColor: Colors.transparent,
                  //             child: Column(
                  //               crossAxisAlignment: CrossAxisAlignment.start,
                  //               children: [
                  //                 Padding(
                  //                   padding: const EdgeInsets.all(8.0),
                  //                   child: Row(
                  //                     mainAxisAlignment:
                  //                         MainAxisAlignment.spaceBetween,
                  //                     crossAxisAlignment:
                  //                         CrossAxisAlignment.start,
                  //                     children: const [
                  //                       Text('Root Cause Analysis',
                  //                           style: cartHeaderStyle),
                  //                       Icon(Icons.mail, color: secondaryColor),
                  //                     ],
                  //                   ),
                  //                 ),
                  //                 Padding(
                  //                   padding: const EdgeInsets.only(
                  //                       left: 8.0, right: 8.0, bottom: 8.0),
                  //                   child: Table(
                  //                       columnWidths: const {
                  //                         0: FlexColumnWidth(2),
                  //                         1: FlexColumnWidth(1),
                  //                       },
                  //                       border: const TableBorder(
                  //                         horizontalInside: BorderSide(
                  //                             width: 1,
                  //                             color: buttonForeground,
                  //                             style: BorderStyle.solid),
                  //                       ),
                  //                       children: [
                  //                         const TableRow(
                  //                             decoration: BoxDecoration(
                  //                                 borderRadius:
                  //                                     BorderRadius.only(
                  //                                   topLeft:
                  //                                       Radius.circular(8.0),
                  //                                   topRight:
                  //                                       Radius.circular(8.0),
                  //                                 ),
                  //                                 color: secondaryColor),
                  //                             children: [
                  //                               Padding(
                  //                                 padding: EdgeInsets.all(8.0),
                  //                                 child: Text('Root Cause',
                  //                                     overflow:
                  //                                         TextOverflow.ellipsis,
                  //                                     textAlign:
                  //                                         TextAlign.start,
                  //                                     style: columnStyle),
                  //                               ),
                  //                               Padding(
                  //                                 padding: EdgeInsets.all(8.0),
                  //                                 child: Text('Count',
                  //                                     overflow:
                  //                                         TextOverflow.ellipsis,
                  //                                     textAlign:
                  //                                         TextAlign.center,
                  //                                     style: columnStyle),
                  //                               ),
                  //                             ]),
                  //                         for (var tabelJson
                  //                             in rootCause.sublist(0, 5))
                  //                           TableRow(
                  //                             children: [
                  //                               Padding(
                  //                                 padding:
                  //                                     const EdgeInsets.all(8.0),
                  //                                 child: tabelJson.label == null
                  //                                     ? const Text('',
                  //                                         style: rowstyle)
                  //                                     : Text(
                  //                                         '${tabelJson.label}',
                  //                                         textAlign:
                  //                                             TextAlign.start,
                  //                                         style: rowstyle),
                  //                               ),
                  //                               Padding(
                  //                                 padding:
                  //                                     const EdgeInsets.all(8.0),
                  //                                 child: Center(
                  //                                   child: tabelJson.y == null
                  //                                       ? const Text('',
                  //                                           style: rowstyle)
                  //                                       : Text('${tabelJson.y}',
                  //                                           textAlign: TextAlign
                  //                                               .center,
                  //                                           style: rowstyle),
                  //                                 ),
                  //                               ),
                  //                             ],
                  //                           )
                  //                       ]),
                  //                 ),
                  //               ],
                  //             ),
                  //           ),
                  //   ),
                  // ]),
                  // Row(
                  //   children: [
                  //     Flexible(
                  //       flex: 2,
                  //       child: timer == true
                  //           ? MobileShimmer(shimmerHeight)
                  //           : Card(
                  //               shape: RoundedRectangleBorder(
                  //                 borderRadius: BorderRadius.circular(15),
                  //               ),
                  //               color: Colors.white,
                  //               elevation: 3,
                  //               shadowColor: Colors.transparent,
                  //               child: Column(
                  //                 crossAxisAlignment: CrossAxisAlignment.start,
                  //                 children: [
                  //                   Padding(
                  //                     padding: const EdgeInsets.all(8.0),
                  //                     child: Row(
                  //                       mainAxisAlignment:
                  //                           MainAxisAlignment.spaceBetween,
                  //                       crossAxisAlignment:
                  //                           CrossAxisAlignment.start,
                  //                       children: const [
                  //                         Text('Reason For Pending',
                  //                             style: cartHeaderStyle),
                  //                         Icon(Icons.mail,
                  //                             color: secondaryColor),
                  //                       ],
                  //                     ),
                  //                   ),
                  //                   Padding(
                  //                     padding: const EdgeInsets.only(
                  //                         left: 8.0, right: 8.0, bottom: 8.0),
                  //                     child: Table(
                  //                         columnWidths: const {
                  //                           0: FlexColumnWidth(2),
                  //                           1: FlexColumnWidth(1),
                  //                         },
                  //                         border: const TableBorder(
                  //                           horizontalInside: BorderSide(
                  //                               width: 1,
                  //                               color: buttonForeground,
                  //                               style: BorderStyle.solid),
                  //                         ),
                  //                         children: [
                  //                           const TableRow(
                  //                               decoration: BoxDecoration(
                  //                                   borderRadius:
                  //                                       BorderRadius.only(
                  //                                     topLeft:
                  //                                         Radius.circular(8.0),
                  //                                     topRight:
                  //                                         Radius.circular(8.0),
                  //                                   ),
                  //                                   color: secondaryColor),
                  //                               children: [
                  //                                 Padding(
                  //                                   padding:
                  //                                       EdgeInsets.all(8.0),
                  //                                   child: Text('Reason',
                  //                                       overflow: TextOverflow
                  //                                           .ellipsis,
                  //                                       textAlign:
                  //                                           TextAlign.start,
                  //                                       style: columnStyle),
                  //                                 ),
                  //                                 Padding(
                  //                                   padding:
                  //                                       EdgeInsets.all(8.0),
                  //                                   child: Text('Count',
                  //                                       overflow: TextOverflow
                  //                                           .ellipsis,
                  //                                       textAlign:
                  //                                           TextAlign.center,
                  //                                       style: columnStyle),
                  //                                 ),
                  //                               ]),
                  //                           for (var tabelJson in reason)
                  //                             TableRow(
                  //                               children: [
                  //                                 Padding(
                  //                                   padding:
                  //                                       const EdgeInsets.all(
                  //                                           8.0),
                  //                                   child: tabelJson
                  //                                               .cCMResonName ==
                  //                                           null
                  //                                       ? const Text('',
                  //                                           style: rowstyle)
                  //                                       : Text('${tabelJson.cCMResonName}',
                  //                                           textAlign:
                  //                                               TextAlign.start,
                  //                                           style: rowstyle),
                  //                                 ),
                  //                                 Padding(
                  //                                   padding:
                  //                                       const EdgeInsets.all(
                  //                                           8.0),
                  //                                   child: Center(
                  //                                     child: tabelJson
                  //                                                 .rCCount ==
                  //                                             null
                  //                                         ? const Text('',
                  //                                             style: rowstyle)
                  //                                         : Text(
                  //                                             '${tabelJson.rCCount}',
                  //                                             textAlign:
                  //                                                 TextAlign
                  //                                                     .center,
                  //                                             style: rowstyle),
                  //                                   ),
                  //                                 ),
                  //                               ],
                  //                             )
                  //                         ]),
                  //                   ),
                  //                 ],
                  //               ),
                  //             ),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
            SliverFillRemaining(
                child: Row(children: [
              Flexible(
                flex: 2,
                child: processStageChart(),
              )
            ])),
          ]),
        ),
      ),
    );
  }

  Widget webChartView() {
    double chartHeight = MediaQuery.of(context).size.height * 0.88;
    double chartWidth = MediaQuery.of(context).size.width * 0.94;
    double navOpenTabWidth = MediaQuery.of(context).size.width * 0.78;
    double shimmerHeight = 310;

    return Padding(
      padding: const EdgeInsets.only(
        right: 5.0,
        bottom: 8.0,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(),
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: CustomScrollView(slivers: <Widget>[
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Flexible(
                        flex: 2,
                        child: timer == true
                            ? webShimmer(shimmerHeight)
                            : ppmStatusChart(),
                      ),
                      Flexible(
                        flex: 2,
                        child: timer == true
                            ? webShimmer(shimmerHeight)
                            : openByFrequency(),
                      ),
                      Flexible(
                        flex: 2,
                        child: timer == true
                            ? webShimmer(shimmerHeight)
                            : overDuePPM(),
                      ),
                      Flexible(
                        flex: 2,
                        child: timer == true
                            ? webShimmer(shimmerHeight)
                            : ppmStatusOther(),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        flex: 2,
                        child: timer == true
                            ? webShimmer(shimmerHeight)
                            : divisionChart(),
                      ),
                      Flexible(
                        flex: 2,
                        child: timer == true
                            ? webShimmer(shimmerHeight)
                            : disciplineChart(),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        flex: 2,
                        child:
                            timer == true ? webShimmer(220) : buildingTable(),
                      ),
                      Flexible(
                        flex: 2,
                        child:
                            timer == true ? webShimmer(220) : frequencyChart(),
                      ),
                      Flexible(
                        flex: 2,
                        child:
                            timer == true ? webShimmer(220) : employeeChart(),
                      ),
                      Flexible(
                        flex: 2,
                        child: timer == true
                            ? webShimmer(220)
                            : slaAdherenceChart(),
                      ),
                      // Flexible(
                      //   flex: 2,
                      //   child: timer == true
                      //       ? webShimmer(220)
                      //       : Card(
                      //           shape: RoundedRectangleBorder(
                      //             borderRadius: BorderRadius.circular(15),
                      //           ),
                      //           color: Colors.white,
                      //           elevation: 4,
                      //           shadowColor: Colors.black12,
                      //           child: SizedBox(
                      //             height: 220,
                      //             child: Column(
                      //               crossAxisAlignment:
                      //                   CrossAxisAlignment.start,
                      //               children: [
                      //                 Padding(
                      //                   padding: const EdgeInsets.all(8.0),
                      //                   child: Row(
                      //                     mainAxisAlignment:
                      //                         MainAxisAlignment.spaceBetween,
                      //                     crossAxisAlignment:
                      //                         CrossAxisAlignment.start,
                      //                     children: const [
                      //                       Text('Reason For Pending',
                      //                           style: cartHeaderStyle),
                      //                       Icon(Icons.mail,
                      //                           color: secondaryColor),
                      //                     ],
                      //                   ),
                      //                 ),
                      //                 Padding(
                      //                   padding: const EdgeInsets.only(
                      //                       left: 8.0, right: 8.0, bottom: 8.0),
                      //                   child: Table(
                      //                       columnWidths: const {
                      //                         0: FlexColumnWidth(2),
                      //                         1: FlexColumnWidth(1),
                      //                       },
                      //                       border: const TableBorder(
                      //                         horizontalInside: BorderSide(
                      //                             width: 1,
                      //                             color: buttonForeground,
                      //                             style: BorderStyle.solid),
                      //                       ),
                      //                       children: [
                      //                         const TableRow(
                      //                             decoration: BoxDecoration(
                      //                                 borderRadius:
                      //                                     BorderRadius.only(
                      //                                   topLeft:
                      //                                       Radius.circular(
                      //                                           8.0),
                      //                                   topRight:
                      //                                       Radius.circular(
                      //                                           8.0),
                      //                                 ),
                      //                                 color: secondaryColor),
                      //                             children: [
                      //                               Padding(
                      //                                 padding:
                      //                                     EdgeInsets.all(8.0),
                      //                                 child: Text('Reason',
                      //                                     overflow: TextOverflow
                      //                                         .ellipsis,
                      //                                     textAlign:
                      //                                         TextAlign.start,
                      //                                     style: columnStyle),
                      //                               ),
                      //                               Padding(
                      //                                 padding:
                      //                                     EdgeInsets.all(8.0),
                      //                                 child: Text('Count',
                      //                                     overflow: TextOverflow
                      //                                         .ellipsis,
                      //                                     textAlign:
                      //                                         TextAlign.center,
                      //                                     style: columnStyle),
                      //                               ),
                      //                             ]),
                      //                         for (var tabelJson in reason)
                      //                           TableRow(
                      //                             children: [
                      //                               Padding(
                      //                                 padding:
                      //                                     const EdgeInsets.all(
                      //                                         8.0),
                      //                                 child: tabelJson.cCMResonName ==
                      //                                         null
                      //                                     ? const Text('',
                      //                                         style: rowstyle)
                      //                                     : Text(
                      //                                         '${tabelJson.cCMResonName}',
                      //                                         textAlign:
                      //                                             TextAlign
                      //                                                 .start,
                      //                                         style: rowstyle),
                      //                               ),
                      //                               Padding(
                      //                                 padding:
                      //                                     const EdgeInsets.all(
                      //                                         8.0),
                      //                                 child: Center(
                      //                                   child: tabelJson
                      //                                               .rCCount ==
                      //                                           null
                      //                                       ? const Text(
                      //                                           '',
                      //                                           style: rowstyle)
                      //                                       : Text(
                      //                                           '${tabelJson.rCCount}',
                      //                                           textAlign:
                      //                                               TextAlign
                      //                                                   .center,
                      //                                           style:
                      //                                               rowstyle),
                      //                                 ),
                      //                               ),
                      //                             ],
                      //                           )
                      //                       ]),
                      //                 ),
                      //               ],
                      //             ),
                      //           ),
                      //           // SfCartesianChart(
                      //           //     plotAreaBorderWidth: 0,
                      //           //     title: ChartTitle(
                      //           //         text: 'HelpDesk Trend',
                      //           //         textStyle: const TextStyle(
                      //           //             overflow: TextOverflow.ellipsis,
                      //           //             fontSize: 12,
                      //           //             color: secondaryColor,
                      //           //             fontWeight: FontWeight.w600)),
                      //           //     legend: Legend(
                      //           //       isVisible: true,
                      //           //     ),
                      //           //     primaryXAxis: CategoryAxis(
                      //           //       isVisible: false,
                      //           //     ),
                      //           //     primaryYAxis: NumericAxis(
                      //           //         minimum: 0, maximum: 40, interval: 10),
                      //           //     tooltipBehavior: TooltipBehavior(enable: true),
                      //           //     series: <ChartSeries>[
                      //           //       BubbleSeries<_ChartData, String>(
                      //           //         dataLabelSettings: const DataLabelSettings(
                      //           //             color: Colors.black, isVisible: true),
                      //           //         dataSource: val,
                      //           //         xValueMapper: (_ChartData data, _) => data.x,
                      //           //         yValueMapper: (_ChartData data, _) => data.y,
                      //           //         name: 'Gold',
                      //           //         gradient: const LinearGradient(
                      //           //             colors: GradientColors.juicyOrange),
                      //           //       ),
                      //           //       BubbleSeries<fourthData, String>(
                      //           //         dataLabelSettings: const DataLabelSettings(
                      //           //             color: Colors.black, isVisible: true),
                      //           //         dataSource: data2,
                      //           //         xValueMapper: (fourthData data, _) => data.x,
                      //           //         yValueMapper: (fourthData data, _) => data.y,
                      //           //         name: 'Gold2',
                      //           //         gradient: const LinearGradient(
                      //           //             colors: GradientColors.purpleLove),
                      //           //       )
                      //           //     ]),
                      //         ),
                      // ),
                    ],
                  ),
                ],
              ),
            ),
            SliverFillRemaining(
                child: Row(children: [
              Flexible(
                flex: 2,
                child: timer == true ? webShimmer(220) : processStageChart(),
              ),
            ])),
          ]),
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
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context)
                      .copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        GridView.builder(
                            reverse: false,
                            addSemanticIndexes: true,
                            semanticChildCount: 1,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              mainAxisExtent:
                                  MediaQuery.of(context).size.height * 0.50,
                              crossAxisCount: 1,
                            ),
                            shrinkWrap: true,
                            itemCount: displayChart.length,
                            itemBuilder: (BuildContext Context, index) {
                              final positions = displayChart[index]['func'];
                              return Row(
                                children: <Widget>[
                                  Flexible(
                                    flex: 2,
                                    child: timer == true
                                        ? webShimmer(shimmerHeight)
                                        : positions,
                                  ),
                                ],
                              );
                            }),
                      ],
                    ),
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
                        listCard == true ? listView() : cardView(),
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget listView() {
    return Flexible(
      flex: 2,
      child: PPMListView(
          data: chartdataTable1,
          tappedValue: tappedValue,
          tableName: tableName),
    );
  }

  Widget cardView() {
    return Flexible(
      flex: 2,
      child: PPMCardView(
          data: chartdataTable1,
          tappedValue: tappedValue,
          tableName: tableName),
    );
  }

  Widget ppmStatusChart() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: Colors.white,
      elevation: 4,
      shadowColor: Colors.black12,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Flexible(
                    flex: 2,
                    child: Text(' PPM Status', style: cartHeaderStyle),
                  ),
                  Icon(Icons.mail, color: secondaryColor),
                ],
              ),
            ),
            SizedBox(
              height: 260,
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: buttonForeground,
                      elevation: 2,
                      shadowColor: Colors.grey.shade100.withOpacity(0.7),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${count[0]['TotalCnt']}',
                                style: const TextStyle(
                                    fontSize: 26,
                                    color: cardText1,
                                    fontWeight: FontWeight.w600)),
                            const Text('Total PPM',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: cardText,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 11,
                                )),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 2,
                        child: SizedBox(
                          width: double.infinity,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            color: buttonForeground,
                            elevation: 2,
                            shadowColor: Colors.grey.shade100.withOpacity(0.7),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${count[0]['OpenCnt']}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 26,
                                        color: trending5,
                                      )),
                                  const Text('Open WorkOrder',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 11,
                                        color: cardText,
                                      )),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: SizedBox(
                          width: double.infinity,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            color: buttonForeground,
                            elevation: 2,
                            shadowColor: Colors.grey.shade100.withOpacity(0.7),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${count[0]['ClosedCnt']}',
                                      style: const TextStyle(
                                          fontSize: 26,
                                          color: trending4,
                                          fontWeight: FontWeight.w600)),
                                  const Text('Closed',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 11,
                                        color: cardText,
                                      )),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Flexible(
                        flex: 2,
                        child: SizedBox(
                          width: double.infinity,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            color: buttonForeground,
                            elevation: 2,
                            shadowColor: Colors.grey.shade100.withOpacity(0.7),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${count[0]['WD']}',
                                      style: const TextStyle(
                                          fontSize: 26,
                                          color: cardText2,
                                          fontWeight: FontWeight.w600)),
                                  const Text('Withdrawn  ',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: cardText,
                                      )),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: SizedBox(
                          width: double.infinity,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            color: buttonForeground,
                            elevation: 2,
                            shadowColor: Colors.grey.shade100.withOpacity(0.7),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  right: 40.0,
                                  top: 8.0,
                                  left: 8.0,
                                  bottom: 8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${count[0]['OverDueCnt']}',
                                      style: const TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.w600,
                                        color: red,
                                      )),
                                  const Text('Due By Date',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: cardText,
                                      )),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(' Completed',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 15,
                                color: secondaryColor,
                                fontWeight: FontWeight.w600)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0, right: 4.0),
                        child: LinearPercentIndicator(
                          lineHeight: 12.0,
                          barRadius: const Radius.circular(16),
                          animation: true,
                          animationDuration: 2500,
                          percent: 0.5,
                          backgroundColor: buttonForeground,
                          progressColor: secondaryColor,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(right: 17.0, top: 5.0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text("50.0%",
                              style: TextStyle(color: secondaryColor)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget overDuePPM() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: Colors.white,
      elevation: 4,
      shadowColor: Colors.black12,
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
                      child: Text(' OverDue PPM', style: cartHeaderStyle)),
                  Icon(Icons.mail, color: secondaryColor),
                ],
              ),
            ),
            SizedBox(
              height: 260,
              child: SfCartesianChart(
                  plotAreaBorderWidth: 0,
                  tooltipBehavior: TooltipBehavior(enable: true),
                  legend: Legend(isVisible: true),
                  primaryXAxis: CategoryAxis(isVisible: true),
                  primaryYAxis: NumericAxis(
                    minimum: 1,
                    maximum: 30,
                    interval: 5,
                  ),
                  series: <ChartSeries>[
                    BarSeries<VwDPPMStatusOvuerDueDays, String>(
                      dataLabelSettings: const DataLabelSettings(
                          isVisible: true,
                          color: grey1,
                          opacity: 0.8,
                          labelAlignment: ChartDataLabelAlignment.outer),
                      // name: 'Total',
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(50),
                      ),
                      color: const Color(0xFF6247aa),
                      // gradient: const LinearGradient(
                      //     colors: GradientColors.purpleLove),
                      dataSource: values1,
                      xValueMapper: (VwDPPMStatusOvuerDueDays data, _) =>
                          data.label,
                      yValueMapper: (VwDPPMStatusOvuerDueDays data, _) =>
                          int.parse('${data.y}'),
                    ),
                  ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget openByFrequency() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: Colors.white,
      elevation: 4,
      shadowColor: Colors.black12,
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
                    child: Text(' Open By Frequency', style: cartHeaderStyle),
                  ),
                  Icon(Icons.mail, color: secondaryColor),
                ],
              ),
            ),
            SizedBox(
              height: 260,
              child: SfCircularChart(
                  palette: const <Color>[
                    trending5,
                    trending6,
                    trending7,
                  ],
                  tooltipBehavior: TooltipBehavior(enable: true),
                  legend: Legend(isVisible: true),
                  series: <CircularSeries>[
                    RadialBarSeries<VwDPPMFrequencyWisePerc, String>(
                        dataLabelSettings: const DataLabelSettings(
                            labelAlignment: ChartDataLabelAlignment.outer,
                            textStyle: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                            color: grey1,
                            opacity: 0.8,
                            isVisible: true),
                        onPointTap: (pointInteractionDetails) {
                          tappedValue = pointInteractionDetails
                              .dataPoints![pointInteractionDetails.pointIndex!]
                              .x
                              .toString();
                        },
                        gap: '1',
                        dataSource: values,
                        xValueMapper: (VwDPPMFrequencyWisePerc data, _) =>
                            data.label,
                        yValueMapper: (VwDPPMFrequencyWisePerc data, _) =>
                            int.parse('${data.y}'),
                        cornerStyle: CornerStyle.bothCurve),
                  ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget ppmStatusOther() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: Colors.white,
      elevation: 4,
      shadowColor: Colors.black12,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Flexible(
                    flex: 2,
                    child: Text(' PPM Status - Others', style: cartHeaderStyle),
                  ),
                  Icon(Icons.mail, color: secondaryColor),
                ],
              ),
            ),
            SizedBox(
              height: 260,
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: buttonForeground,
                      elevation: 2,
                      shadowColor: Colors.grey.shade100.withOpacity(0.7),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text('${OthersCount[0]['DefectCnt']}',
                                  style: const TextStyle(
                                      fontSize: 20,
                                      color: cardText1,
                                      fontWeight: FontWeight.w600)),
                            ),
                            const Text('Defects Found',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: cardText,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 11,
                                )),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 2,
                        child: SizedBox(
                          width: double.infinity,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            color: buttonForeground,
                            elevation: 2,
                            shadowColor: Colors.grey.shade100.withOpacity(0.7),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child:
                                        Text('${OthersCount[0]['StandByCnt']}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 20,
                                              color: trending5,
                                            )),
                                  ),
                                  const Text('Stand By',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 11,
                                        color: cardText,
                                      )),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: SizedBox(
                          width: double.infinity,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            color: buttonForeground,
                            elevation: 2,
                            shadowColor: Colors.grey.shade100.withOpacity(0.7),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Text(
                                        '${OthersCount[0]['RescheduleCnt']}',
                                        style: const TextStyle(
                                            fontSize: 20,
                                            color: trending4,
                                            fontWeight: FontWeight.w600)),
                                  ),
                                  const Text('Rescheduled',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 11,
                                        color: cardText,
                                      )),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Flexible(
                        flex: 2,
                        child: SizedBox(
                          width: double.infinity,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            color: buttonForeground,
                            elevation: 2,
                            shadowColor: Colors.grey.shade100.withOpacity(0.7),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Text('${OthersCount[0]['WD']}',
                                        style: const TextStyle(
                                            fontSize: 20,
                                            color: cardText2,
                                            fontWeight: FontWeight.w600)),
                                  ),
                                  const Text('Withdrawn  ',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: cardText,
                                      )),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: SizedBox(
                          width: double.infinity,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            color: buttonForeground,
                            elevation: 2,
                            shadowColor: Colors.grey.shade100.withOpacity(0.7),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  right: 40.0,
                                  top: 8.0,
                                  left: 8.0,
                                  bottom: 8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Text('${OthersCount[0]['BDMCnt']}',
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                          color: red,
                                        )),
                                  ),
                                  const Text('Breakdown Registered',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: cardText,
                                      )),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(' Within 1 month of PPM',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 15,
                              color: secondaryColor,
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget divisionChart() {
    return Card(
      shape: cardBorder == 5
          ? RoundedRectangleBorder(
              side: const BorderSide(color: secondaryColor, width: 2.0),
              borderRadius: BorderRadius.circular(15),
            )
          : RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
      color: Colors.white,
      elevation: 4,
      shadowColor: Colors.black12,
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
                      child: Text(' By Division', style: cartHeaderStyle)),
                  Icon(Icons.mail, color: secondaryColor),
                ],
              ),
            ),
            SizedBox(
              height: 260,
              child: SfCartesianChart(
                  plotAreaBorderWidth: 0,
                  tooltipBehavior: TooltipBehavior(enable: true),
                  legend: Legend(isVisible: true),
                  primaryXAxis:
                      CategoryAxis(isVisible: false, arrangeByIndex: true),
                  series: <ChartSeries>[
                    ColumnSeries<Total, String>(
                      onPointTap: (pointInteractionDetails) {
                        var val;
                        val = pointInteractionDetails
                            .dataPoints![pointInteractionDetails.pointIndex!].x;
                        setState(() {
                          tableName = 'By Division';
                          tappedValue = val;
                        });
                        chartTappedDataTable();
                      },
                      dataSource: devTotal,
                      xValueMapper: (Total data, _) => data.label,
                      yValueMapper: (Total data, _) => data.y,
                      trackColor: Colors.transparent,
                      name: 'Total',
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                      gradient: const LinearGradient(
                          colors: GradientColors.midnightBloom),
                      dataLabelSettings: const DataLabelSettings(
                          isVisible: true,
                          color: grey1,
                          opacity: 0.8,
                          labelAlignment: ChartDataLabelAlignment.outer),
                    ),
                    ColumnSeries<Closed, String>(
                      onPointTap: (pointInteractionDetails) {
                        var val;
                        val = pointInteractionDetails
                            .dataPoints![pointInteractionDetails.pointIndex!].x;
                        print('val,$val');
                        setState(() {
                          tableName = 'By Division';
                          tappedValue = val;
                        });
                        print(tappedValue);
                        chartTappedDataTable();
                      },
                      dataSource: devClose,
                      xValueMapper: (Closed data, _) => data.label,
                      yValueMapper: (Closed data, _) => data.y,
                      trackColor: Colors.transparent,
                      name: 'Closed',
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                      gradient: const LinearGradient(
                          colors: GradientColors.purpleLove),
                      dataLabelSettings: const DataLabelSettings(
                          isVisible: true,
                          color: grey1,
                          opacity: 0.8,
                          labelAlignment: ChartDataLabelAlignment.outer),
                    ),
                    ColumnSeries<Open, String>(
                      onPointTap: (pointInteractionDetails) {
                        var val;
                        val = pointInteractionDetails
                            .dataPoints![pointInteractionDetails.pointIndex!].x;
                        print('val,$val');
                        setState(() {
                          tableName = 'By Division';
                          tappedValue = val;
                        });
                        print(tappedValue);
                        chartTappedDataTable();
                      },
                      dataSource: devOpen,
                      xValueMapper: (Open data, _) => data.label,
                      yValueMapper: (Open data, _) => data.y,
                      trackColor: Colors.transparent,
                      name: 'Open',
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                      gradient: const LinearGradient(
                          colors: GradientColors.nightFade),
                      dataLabelSettings: const DataLabelSettings(
                          isVisible: true,
                          color: grey1,
                          opacity: 0.8,
                          labelAlignment: ChartDataLabelAlignment.outer),
                    )
                  ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget disciplineChart() {
    return Card(
      shape: cardBorder == 6
          ? RoundedRectangleBorder(
              side: const BorderSide(color: secondaryColor, width: 2.0),
              borderRadius: BorderRadius.circular(15),
            )
          : RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
      color: Colors.white,
      elevation: 4,
      shadowColor: Colors.black12,
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
                      child: Text(' By Discipline', style: cartHeaderStyle)),
                  Icon(Icons.mail, color: secondaryColor),
                ],
              ),
            ),
            SizedBox(
              height: 260,
              child: SfCartesianChart(
                  plotAreaBorderWidth: 0,
                  tooltipBehavior: TooltipBehavior(enable: true),
                  legend: Legend(isVisible: true),
                  primaryXAxis:
                      CategoryAxis(isVisible: false, arrangeByIndex: true),
                  series: <ChartSeries>[
                    ColumnSeries<Total, String>(
                      // onPointTap: (pointInteractionDetails) {
                      //   tappedValue = pointInteractionDetails
                      //       .dataPoints![pointInteractionDetails.pointIndex!].x;
                      //   setState(() {
                      //     tableName = 'By Division';
                      //   });
                      //   chartTappedDataTable(tappedValue);
                      // },
                      dataSource: decTotal,
                      xValueMapper: (Total data, _) => data.label,
                      yValueMapper: (Total data, _) => data.y,
                      trackColor: Colors.transparent,
                      name: 'Total',
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                      gradient: const LinearGradient(
                          colors: GradientColors.midnightBloom),
                      dataLabelSettings: const DataLabelSettings(
                          isVisible: true,
                          color: grey1,
                          opacity: 0.8,
                          labelAlignment: ChartDataLabelAlignment.outer),
                    ),
                    ColumnSeries<Closed, String>(
                      // onPointTap: (pointInteractionDetails) {
                      //   tappedValue = pointInteractionDetails
                      //       .dataPoints![pointInteractionDetails.pointIndex!].x;
                      //   setState(() {
                      //     tableName = 'By Division';
                      //   });
                      //   chartTappedDataTable(tappedValue);
                      // },
                      dataSource: decClose,
                      xValueMapper: (Closed data, _) => data.label,
                      yValueMapper: (Closed data, _) => data.y,
                      trackColor: Colors.transparent,
                      name: 'Closed',
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                      gradient: const LinearGradient(
                          colors: GradientColors.purpleLove),
                      dataLabelSettings: const DataLabelSettings(
                          isVisible: true,
                          color: grey1,
                          opacity: 0.8,
                          labelAlignment: ChartDataLabelAlignment.outer),
                    ),
                    ColumnSeries<Open, String>(
                      // onPointTap: (pointInteractionDetails) {
                      //   tappedValue = pointInteractionDetails
                      //       .dataPoints![pointInteractionDetails.pointIndex!].x;
                      //   setState(() {
                      //     tableName = 'By Division';
                      //   });
                      //   chartTappedDataTable(tappedValue);
                      // },
                      dataSource: decOpen,
                      xValueMapper: (Open data, _) => data.label,
                      yValueMapper: (Open data, _) => data.y,
                      trackColor: Colors.transparent,
                      name: 'Open',
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                      gradient: const LinearGradient(
                          colors: GradientColors.nightFade),
                      dataLabelSettings: const DataLabelSettings(
                          isVisible: true,
                          color: grey1,
                          opacity: 0.8,
                          labelAlignment: ChartDataLabelAlignment.outer),
                    )
                  ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildingTable() {
    return Card(
      shape: cardBorder == 7
          ? RoundedRectangleBorder(
              side: const BorderSide(color: secondaryColor, width: 2.0),
              borderRadius: BorderRadius.circular(15),
            )
          : RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
      color: Colors.white,
      elevation: 4,
      shadowColor: Colors.black12,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('By Building', style: cartHeaderStyle),
                Icon(Icons.mail, color: secondaryColor),
              ],
            ),
          ),
          SizedBox(
            height: 275,
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
              child: Table(
                  columnWidths: const {
                    0: FlexColumnWidth(4),
                    1: FlexColumnWidth(2),
                    2: FlexColumnWidth(2),
                    3: FlexColumnWidth(2),
                  },
                  border: const TableBorder(
                    horizontalInside: BorderSide(
                        width: 1,
                        color: buttonForeground,
                        style: BorderStyle.solid),
                  ),
                  children: [
                    const TableRow(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8.0),
                              topRight: Radius.circular(8.0),
                            ),
                            color: secondaryColor),
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Code',
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.start,
                                style: columnStyle),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Total',
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: columnStyle),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Open',
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: columnStyle),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Close',
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: columnStyle),
                          ),
                        ]),
                    for (var tabelJson in byBuilding.sublist(0, 5))
                      TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: tabelJson.buildingCode == null
                                ? const Text('', style: rowstyle)
                                : Text('${tabelJson.buildingCode}',
                                    textAlign: TextAlign.start,
                                    style: rowstyle),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: tabelJson.total == null
                                  ? const Text('', style: rowstyle)
                                  : Text('${tabelJson.total}',
                                      textAlign: TextAlign.center,
                                      style: rowstyle),
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: tabelJson.openCnt == null
                                    ? const Text('', style: rowstyle)
                                    : Text('${tabelJson.openCnt}',
                                        textAlign: TextAlign.center,
                                        style: rowstyle),
                              )),
                          Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: tabelJson.closed == null
                                    ? const Text('', style: rowstyle)
                                    : Text('${tabelJson.closed}',
                                        textAlign: TextAlign.center,
                                        style: rowstyle),
                              ))
                        ],
                      )
                  ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget frequencyChart() {
    return Card(
      shape: cardBorder == 8
          ? RoundedRectangleBorder(
              side: const BorderSide(color: secondaryColor, width: 2.0),
              borderRadius: BorderRadius.circular(15),
            )
          : RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
      color: Colors.white,
      elevation: 4,
      shadowColor: Colors.black12,
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
                      child: Text(' By Frequency', style: cartHeaderStyle)),
                  Icon(Icons.mail, color: secondaryColor),
                ],
              ),
            ),
            SizedBox(
              height: 260,
              child: SfCartesianChart(
                  plotAreaBorderWidth: 0,
                  tooltipBehavior: TooltipBehavior(enable: true),
                  legend: Legend(isVisible: true),
                  primaryXAxis:
                      CategoryAxis(isVisible: false, arrangeByIndex: true),
                  series: <ChartSeries>[
                    ColumnSeries<Total, String>(
                      // onPointTap: (pointInteractionDetails) {
                      //   tappedValue = pointInteractionDetails
                      //       .dataPoints![pointInteractionDetails.pointIndex!].x;
                      //   setState(() {
                      //     tableName = 'By Division';
                      //   });
                      //   chartTappedDataTable(tappedValue);
                      // },
                      dataSource: freqTotal,
                      xValueMapper: (Total data, _) => data.label,
                      yValueMapper: (Total data, _) => data.y,
                      trackColor: Colors.transparent,
                      name: 'Total',
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                      gradient: const LinearGradient(
                          colors: GradientColors.midnightBloom),
                      dataLabelSettings: const DataLabelSettings(
                          isVisible: true,
                          color: grey1,
                          opacity: 0.8,
                          labelAlignment: ChartDataLabelAlignment.outer),
                    ),
                    ColumnSeries<Closed, String>(
                      // onPointTap: (pointInteractionDetails) {
                      //   tappedValue = pointInteractionDetails
                      //       .dataPoints![pointInteractionDetails.pointIndex!].x;
                      //   setState(() {
                      //     tableName = 'By Division';
                      //   });
                      //   chartTappedDataTable(tappedValue);
                      // },
                      dataSource: freqClose,
                      xValueMapper: (Closed data, _) => data.label,
                      yValueMapper: (Closed data, _) => data.y,
                      trackColor: Colors.transparent,
                      name: 'Closed',
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                      gradient: const LinearGradient(
                          colors: GradientColors.purpleLove),
                      dataLabelSettings: const DataLabelSettings(
                          isVisible: true,
                          color: grey1,
                          opacity: 0.8,
                          labelAlignment: ChartDataLabelAlignment.outer),
                    ),
                    ColumnSeries<Open, String>(
                      // onPointTap: (pointInteractionDetails) {
                      //   tappedValue = pointInteractionDetails
                      //       .dataPoints![pointInteractionDetails.pointIndex!].x;
                      //   setState(() {
                      //     tableName = 'By Division';
                      //   });
                      //   chartTappedDataTable(tappedValue);
                      // },
                      dataSource: freqOpen,
                      xValueMapper: (Open data, _) => data.label,
                      yValueMapper: (Open data, _) => data.y,
                      trackColor: Colors.transparent,
                      name: 'Open',
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                      gradient: const LinearGradient(
                          colors: GradientColors.nightFade),
                      dataLabelSettings: const DataLabelSettings(
                          isVisible: true,
                          color: grey1,
                          opacity: 0.8,
                          labelAlignment: ChartDataLabelAlignment.outer),
                    )
                  ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget employeeChart() {
    return Card(
      shape: cardBorder == 9
          ? RoundedRectangleBorder(
              side: const BorderSide(color: secondaryColor, width: 2.0),
              borderRadius: BorderRadius.circular(15),
            )
          : RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
      color: Colors.white,
      elevation: 4,
      shadowColor: Colors.black12,
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
                      child: Text(' By Employee', style: cartHeaderStyle)),
                  Icon(Icons.mail, color: secondaryColor),
                ],
              ),
            ),
            SizedBox(
              height: 260,
              child: SfCartesianChart(
                  plotAreaBorderWidth: 0,
                  tooltipBehavior: TooltipBehavior(enable: true),
                  legend: Legend(isVisible: true),
                  primaryXAxis:
                      CategoryAxis(isVisible: false, arrangeByIndex: true),
                  series: <ChartSeries>[
                    ColumnSeries<Total, String>(
                      // onPointTap: (pointInteractionDetails) {
                      //   tappedValue = pointInteractionDetails
                      //       .dataPoints![pointInteractionDetails.pointIndex!].x;
                      //   setState(() {
                      //     tableName = 'By Division';
                      //   });
                      //   chartTappedDataTable(tappedValue);
                      // },
                      dataSource: empTotal,
                      xValueMapper: (Total data, _) => data.label,
                      yValueMapper: (Total data, _) => data.y,
                      trackColor: Colors.transparent,
                      name: 'Total',
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                      gradient: const LinearGradient(
                          colors: GradientColors.midnightBloom),
                      dataLabelSettings: const DataLabelSettings(
                          isVisible: true,
                          color: grey1,
                          opacity: 0.8,
                          labelAlignment: ChartDataLabelAlignment.outer),
                    ),
                    ColumnSeries<Closed, String>(
                      // onPointTap: (pointInteractionDetails) {
                      //   tappedValue = pointInteractionDetails
                      //       .dataPoints![pointInteractionDetails.pointIndex!].x;
                      //   setState(() {
                      //     tableName = 'By Division';
                      //   });
                      //   chartTappedDataTable(tappedValue);
                      // },
                      dataSource: empClose,
                      xValueMapper: (Closed data, _) => data.label,
                      yValueMapper: (Closed data, _) => data.y,
                      trackColor: Colors.transparent,
                      name: 'Closed',
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                      gradient: const LinearGradient(
                          colors: GradientColors.purpleLove),
                      dataLabelSettings: const DataLabelSettings(
                          isVisible: true,
                          color: grey1,
                          opacity: 0.8,
                          labelAlignment: ChartDataLabelAlignment.outer),
                    ),
                    ColumnSeries<Open, String>(
                      // onPointTap: (pointInteractionDetails) {
                      //   tappedValue = pointInteractionDetails
                      //       .dataPoints![pointInteractionDetails.pointIndex!].x;
                      //   setState(() {
                      //     tableName = 'By Division';
                      //   });
                      //   chartTappedDataTable(tappedValue);
                      // },
                      dataSource: empOpen,
                      xValueMapper: (Open data, _) => data.label,
                      yValueMapper: (Open data, _) => data.y,
                      trackColor: Colors.transparent,
                      name: 'Open',
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                      gradient: const LinearGradient(
                          colors: GradientColors.nightFade),
                      dataLabelSettings: const DataLabelSettings(
                          isVisible: true,
                          color: grey1,
                          opacity: 0.8,
                          labelAlignment: ChartDataLabelAlignment.outer),
                    )
                  ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget slaAdherenceChart() {
    return Card(
      shape: cardBorder == 10
          ? RoundedRectangleBorder(
              side: const BorderSide(color: secondaryColor, width: 2.0),
              borderRadius: BorderRadius.circular(15),
            )
          : RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
      color: Colors.white,
      elevation: 4,
      shadowColor: Colors.black12,
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
                    child: Text(' SLA-Adherence', style: cartHeaderStyle),
                  ),
                  Icon(Icons.mail, color: secondaryColor),
                ],
              ),
            ),
            SizedBox(
              height: 260,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Flexible(
                        flex: 2,
                        child: SizedBox(
                          width: double.infinity,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            color: buttonForeground,
                            elevation: 2,
                            shadowColor: Colors.grey.shade100.withOpacity(0.7),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${slaValue[0].pPMTot}',
                                      style: const TextStyle(
                                          fontSize: 26,
                                          color: cardText2,
                                          fontWeight: FontWeight.w600)),
                                  const Text('Total  ',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: cardText,
                                      )),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: SizedBox(
                          width: double.infinity,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            color: buttonForeground,
                            elevation: 2,
                            shadowColor: Colors.grey.shade100.withOpacity(0.7),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  right: 40.0,
                                  top: 8.0,
                                  left: 8.0,
                                  bottom: 8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${slaValue[0].pPMClosed}',
                                      style: const TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.w600,
                                        color: red,
                                      )),
                                  const Text('Closed',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: cardText,
                                      )),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Flexible(
                    flex: 2,
                    child: SfCircularChart(
                        annotations: <CircularChartAnnotation>[
                          // CircularChartAnnotation(
                          //     widget: PhysicalModel(
                          //         shape: BoxShape.circle,
                          //         elevation: 10,
                          //         shadowColor: Colors.black,
                          //         color: const Color.fromRGBO(230, 230, 230, 1),
                          //         child: Container(
                          //             child: Text('${slaValue[0].pPMPrc}',
                          //                 style: const TextStyle(
                          //                     color:
                          //                         Color.fromRGBO(0, 0, 0, 0.5),
                          //                     fontSize: 25))))),
                          CircularChartAnnotation(
                              widget: Text('${slaValue[0].pPMPrc}',
                                  style: const TextStyle(
                                      color: Color.fromRGBO(0, 0, 0, 0.5),
                                      fontSize: 25)))
                        ],
                        palette: const <Color>[
                          trending16,
                          trending17,
                          trending7,
                        ],
                        tooltipBehavior: TooltipBehavior(
                          enable: true,
                        ),
                        legend: Legend(isVisible: true),
                        series: <CircularSeries>[
                          DoughnutSeries<VwDPPMSLAAdheranceCount, String>(
                              dataLabelSettings: const DataLabelSettings(
                                  isVisible: true,
                                  color: Colors.black,
                                  opacity: 0.8,
                                  labelAlignment:
                                      ChartDataLabelAlignment.outer),
                              // onPointTap: (pointInteractionDetails) {
                              //   tappedValue = pointInteractionDetails
                              //       .dataPoints![pointInteractionDetails.pointIndex!]
                              //       .x
                              //       .toString();
                              //   setState(() {
                              //     tableName = 'SLA-Response';
                              //   });
                              //   if (tappedValue == 'Ontime') {
                              //     barSeriesId = 16;
                              //   } else {
                              //     barSeriesId = 15;
                              //   }
                              //   chartTappedDataTable1();
                              // },
                              name: 'NotOnTime',
                              innerRadius: '35',
                              explode: false,
                              dataSource: slaValue,
                              xValueMapper: (VwDPPMSLAAdheranceCount data, _) =>
                                  data.pPMPrc,
                              yValueMapper: (VwDPPMSLAAdheranceCount data, _) =>
                                  int.parse('${data.pPMNotOnTime}'),
                              cornerStyle: CornerStyle.bothCurve),
                          DoughnutSeries<VwDPPMSLAAdheranceCount, String>(
                              dataLabelSettings: const DataLabelSettings(
                                  isVisible: true,
                                  color: Colors.black,
                                  opacity: 0.8,
                                  labelAlignment:
                                      ChartDataLabelAlignment.outer),
                              innerRadius: '35',
                              explode: false,
                              dataSource: slaValue,
                              xValueMapper: (VwDPPMSLAAdheranceCount data, _) =>
                                  data.pPMAchieved,
                              yValueMapper: (VwDPPMSLAAdheranceCount data, _) =>
                                  int.parse('${data.pPMOnTime}'),
                              cornerStyle: CornerStyle.bothCurve)
                        ]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget processStageChart() {
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        color: Colors.white,
        elevation: 4,
        shadowColor: Colors.black12,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Flexible(
                      flex: 2,
                      child: Text(' Level of Completion – Process Stage',
                          style: cartHeaderStyle),
                    ),
                    Icon(Icons.mail, color: secondaryColor),
                  ],
                ),
              ),
              Flexible(
                flex: 2,
                child: SfCartesianChart(
                    plotAreaBorderWidth: 0,
                    tooltipBehavior: TooltipBehavior(enable: true),
                    legend: Legend(isVisible: true),
                    primaryXAxis: CategoryAxis(
                        interval: 1,
                        maximumLabelWidth: 60,
                        borderColor: Colors.black,
                        isVisible: true,
                        majorGridLines:
                            const MajorGridLines(color: Colors.transparent),
                        arrangeByIndex: false),
                    series: <ChartSeries>[
                      ColumnSeries<VwDPPMStatusStageWiseCount, String>(
                        // onPointTap: (pointInteractionDetails) {
                        //   var val;
                        //   val = (pointInteractionDetails
                        //           .dataPoints![
                        //               pointInteractionDetails.pointIndex!]
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
                        dataSource: processStage,
                        xValueMapper: (VwDPPMStatusStageWiseCount data, _) =>
                            data.label,
                        yValueMapper: (VwDPPMStatusStageWiseCount data, _) =>
                            int.parse('${data.y}'),
                        trackColor: Colors.transparent,
                        name: 'Performance Percentage',
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15)),
                        gradient: const LinearGradient(
                            colors: GradientColors.plumPlate),
                        dataLabelSettings: const DataLabelSettings(
                            isVisible: true,
                            color: Colors.black,
                            opacity: 0.8,
                            labelAlignment: ChartDataLabelAlignment.outer),
                      )
                    ]),
              ),
            ],
          ),
        ));
  }

  List<dynamic> displayChartWidget() {
    return displayChart = [
      {"id": 1, "func": ppmStatusChart()},
      {"id": 2, "func": openByFrequency()},
      {"id": 3, "func": overDuePPM()},
      {"id": 4, "func": ppmStatusOther()},
      {"id": 5, "func": divisionChart()},
      {"id": 6, "func": disciplineChart()},
      {"id": 7, "func": buildingTable()},
      {"id": 8, "func": frequencyChart()},
      {"id": 9, "func": employeeChart()},
      {"id": 10, "func": slaAdherenceChart()},
      {"id": 11, "func": processStageChart()},
    ];
  }
}

class VwDPPMFrequencyWisePerc {
  String? label;
  String? y;
  String? perc;

  VwDPPMFrequencyWisePerc({this.label, this.y, this.perc});

  VwDPPMFrequencyWisePerc.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    y = json['y'];
    perc = json['Perc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    data['y'] = this.y;
    data['Perc'] = this.perc;
    return data;
  }
}

class VwDPPMStatusCount {
  String? totalCnt;
  String? openCnt;
  String? closedCnt;
  String? wD;
  String? overDueCnt;

  VwDPPMStatusCount(
      {this.totalCnt, this.openCnt, this.closedCnt, this.wD, this.overDueCnt});

  VwDPPMStatusCount.fromJson(Map<String, dynamic> json) {
    totalCnt = json['TotalCnt'];
    openCnt = json['OpenCnt'];
    closedCnt = json['ClosedCnt'];
    wD = json['WD'];
    overDueCnt = json['OverDueCnt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['TotalCnt'] = totalCnt;
    data['OpenCnt'] = openCnt;
    data['ClosedCnt'] = closedCnt;
    data['WD'] = wD;
    data['OverDueCnt'] = overDueCnt;
    return data;
  }
}

class VwDPPMStatusOvuerDueDays {
  String? y;
  String? label;

  VwDPPMStatusOvuerDueDays({this.y, this.label});

  VwDPPMStatusOvuerDueDays.fromJson(Map<String, dynamic> json) {
    y = json['y'];
    label = json['label'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['y'] = this.y;
    data['label'] = this.label;
    return data;
  }
}

class VwDPPMStatusBuildingWiseCount {
  String? buildingIDPK;
  String? buildingCode;
  String? buildingName;
  String? closed;
  String? openCnt;
  String? total;
  String? achieved;

  VwDPPMStatusBuildingWiseCount(
      {this.buildingIDPK,
      this.buildingCode,
      this.buildingName,
      this.closed,
      this.openCnt,
      this.total,
      this.achieved});

  VwDPPMStatusBuildingWiseCount.fromJson(Map<String, dynamic> json) {
    buildingIDPK = json['BuildingIDPK'];
    buildingCode = json['BuildingCode'];
    buildingName = json['BuildingName'];
    closed = json['Closed'];
    openCnt = json['OpenCnt'];
    total = json['Total'];
    achieved = json['Achieved'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['BuildingIDPK'] = buildingIDPK;
    data['BuildingCode'] = buildingCode;
    data['BuildingName'] = buildingName;
    data['Closed'] = closed;
    data['OpenCnt'] = openCnt;
    data['Total'] = total;
    data['Achieved'] = achieved;
    return data;
  }
}

class VwDPPMSLAAdheranceCount {
  String? pPMTot;
  String? pPMOpen;
  String? pPMClosed;
  String? wD;
  String? pPMAchieved;
  String? pPMOnTime;
  String? pPMNotOnTime;
  String? pPMPrc;

  VwDPPMSLAAdheranceCount(
      {this.pPMTot,
      this.pPMOpen,
      this.pPMClosed,
      this.wD,
      this.pPMAchieved,
      this.pPMOnTime,
      this.pPMNotOnTime,
      this.pPMPrc});

  VwDPPMSLAAdheranceCount.fromJson(Map<String, dynamic> json) {
    pPMTot = json['PPMTot'];
    pPMOpen = json['PPMOpen'];
    pPMClosed = json['PPMClosed'];
    wD = json['WD'];
    pPMAchieved = json['PPMAchieved'];
    pPMOnTime = json['PPMOnTime'];
    pPMNotOnTime = json['PPMNotOnTime'];
    pPMPrc = json['PPMPrc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['PPMTot'] = pPMTot;
    data['PPMOpen'] = pPMOpen;
    data['PPMClosed'] = pPMClosed;
    data['WD'] = wD;
    data['PPMAchieved'] = pPMAchieved;
    data['PPMOnTime'] = pPMOnTime;
    data['PPMNotOnTime'] = pPMNotOnTime;
    data['PPMPrc'] = pPMPrc;
    return data;
  }
}

class VwDPPMStatusStageWiseCount {
  String? y;
  String? label;
  String? ord;

  VwDPPMStatusStageWiseCount({this.y, this.label, this.ord});

  VwDPPMStatusStageWiseCount.fromJson(Map<String, dynamic> json) {
    y = json['y'];
    label = json['label'];
    ord = json['ord'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['y'] = y;
    data['label'] = label;
    data['ord'] = ord;
    return data;
  }
}

class VwDPPMPopUpGrdDet {
  String? creationAssetIDPK;
  String? workOrder;
  String? woDate;
  String? woStatus;
  String? stageName;
  String? assetTagNo;
  String? equipmentName;
  String? sLAHrs;
  String? frequency;
  String? divisionName;
  String? disciplineName;
  String? contractCode;
  String? contractName;
  String? localityName;
  String? buildingName;
  String? completedVia;
  String? ageingInDays;
  String? resultCount;

  VwDPPMPopUpGrdDet(
      {this.creationAssetIDPK,
      this.workOrder,
      this.woDate,
      this.woStatus,
      this.stageName,
      this.assetTagNo,
      this.equipmentName,
      this.sLAHrs,
      this.frequency,
      this.divisionName,
      this.disciplineName,
      this.contractCode,
      this.contractName,
      this.localityName,
      this.buildingName,
      this.completedVia,
      this.ageingInDays,
      this.resultCount});

  VwDPPMPopUpGrdDet.fromJson(Map<String, dynamic> json) {
    creationAssetIDPK = json['CreationAssetIDPK'];
    workOrder = json['WorkOrder'];
    woDate = json['WoDate'];
    woStatus = json['WoStatus'];
    stageName = json['StageName'];
    assetTagNo = json['AssetTagNo'];
    equipmentName = json['EquipmentName'];
    sLAHrs = json['SLAHrs'];
    frequency = json['Frequency'];
    divisionName = json['DivisionName'];
    disciplineName = json['DisciplineName'];
    contractCode = json['ContractCode'];
    contractName = json['ContractName'];
    localityName = json['LocalityName'];
    buildingName = json['BuildingName'];
    completedVia = json['CompletedVia'];
    ageingInDays = json['AgeingInDays'];
    resultCount = json['ResultCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['CreationAssetIDPK'] = creationAssetIDPK;
    data['WorkOrder'] = workOrder;
    data['WoDate'] = woDate;
    data['WoStatus'] = woStatus;
    data['StageName'] = stageName;
    data['AssetTagNo'] = assetTagNo;
    data['EquipmentName'] = equipmentName;
    data['SLAHrs'] = sLAHrs;
    data['Frequency'] = frequency;
    data['DivisionName'] = divisionName;
    data['DisciplineName'] = disciplineName;
    data['ContractCode'] = contractCode;
    data['ContractName'] = contractName;
    data['LocalityName'] = localityName;
    data['BuildingName'] = buildingName;
    data['CompletedVia'] = completedVia;
    data['AgeingInDays'] = ageingInDays;
    data['ResultCount'] = resultCount;
    return data;
  }
}
