import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_gradient_colors/flutter_gradient_colors.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:http/http.dart' as http;

import '../../Config.dart';
import '../../Styles/CommonColor.dart';
import '../../Styles/CommonTextStyle.dart';
import '../../Styles/responsive.dart';
import '../../Widgets/mobile/shimmer.dart';
import '../../Widgets/web/shimmer.dart';

class Kpi extends StatefulWidget {
  bool? sideNav, singCardView, detailBackMenu;
  String? pageName;
  final dynamic getFunc;
  Kpi(
      {Key? key,
      this.sideNav,
      this.singCardView,
      this.getFunc,
      this.detailBackMenu,
      this.pageName})
      : super(key: key);

  @override
  State<Kpi> createState() => _KpiState();
}

class _KpiState extends State<Kpi> {
  final Duration delayed = const Duration(milliseconds: 300);
  bool menuState = true, timer = true, listCard = true;
  int tab = 0;
  String? userName, currentDate, startDate, day = 'Today', pageName;
  int? sessionId, barSeriesId, cardBorder = 0;
  var ComplaintIDPK, containerIndex;
  List<dynamic> displayChart = [],
      contributionCount = [],
      complaintCount = [],
      serviceCount = [],
      incidentCount = [],
      complaint2Count = [],
      service2Count = [],
      incident2Count = [],
      preventiveCount = [],
      assetCount = [];
  List<VwDKPIMonthDetCharts> breakdownCount = [];
  var tappedValue, tableName;
  double duration = 2;
  bool canShowMarker = false, showMarker = false;
  final TrackballDisplayMode _mode = TrackballDisplayMode.groupAllPoints;

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
      pageName = 'Assets';
    });
    local();
    contributionApi();
    complaintsApi();
    serviceApi();
    incidentApi();
    complaints2Api();
    service2Api();
    incident2Api();
    preventiveApi();
    breakdownApi();
    assetCountApi();
  }

  Future<void> local() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('UserName');
      sessionId = prefs.getInt('SessionId')!;
    });
  }

  Future<void> contributionApi() async {
    String? ip = '/VwDKPIContribution/';
    const service = ApiConfig.service;
    final url = Uri.parse('$service$ip');
    final headers = {'Accept': 'application/json'};
    const json =
        '{"data":{"CountryID_varchar":0,"CustomerID_varchar":0,"ContractID_varchar":0,"LocationGroupID_varchar":0,"LocalityID_varchar":0,"BuildingID_varchar":0,"CityID_varchar":0,"FloorID_varchar":0,"SpotID_varchar":0,"DivisionID_varchar":0,"DisciplineID_varchar":0,"ServiceTypeID_varchar":0,"FromDate_datetime":"2023-02-05","ToDate_datetime":"2023-03-07","LocUserID_int":"6","PortalUserID_bit":0,"HeaderID_int":1,"DataParam_varchar":null,"PageIndex_int":1,"PageSize_int":10,"ResultCount_int":null}}';
    final response =
        await http.post(url, headers: headers, body: json.toString());
    if (response.statusCode == 400) {
      String err = 'something went wrong!';
    } else {
      final String jsonString = jsonEncode(response.body);
      var decodedJson = jsonDecode(jsonString);
      Map<String, dynamic> map = jsonDecode(decodedJson);
      var result = map['VwDKPIContribution'];
      setState(() {
        contributionCount = result;
      });
      timerFunction();
    }
  }

  Future<void> complaintsApi() async {
    String? ip = '/VwDKPICorrectiveMaint/';
    const service = ApiConfig.service;
    final url = Uri.parse('$service$ip');
    final headers = {'Accept': 'application/json'};
    const json =
        '{"data":{"CountryID_varchar":0,"CustomerID_varchar":0,"ContractID_varchar":0,"LocationGroupID_varchar":0,"LocalityID_varchar":0,"BuildingID_varchar":0,"CityID_varchar":0,"FloorID_varchar":0,"SpotID_varchar":0,"DivisionID_varchar":0,"DisciplineID_varchar":0,"ServiceTypeID_varchar":0,"FromDate_datetime":"2023-02-05","ToDate_datetime":"2023-03-07","LocUserID_int":"6","PortalUserID_bit":0,"HeaderID_int":1,"DataParam_varchar":null,"PageIndex_int":1,"PageSize_int":10,"ResultCount_int":null}}';
    final response =
        await http.post(url, headers: headers, body: json.toString());
    if (response.statusCode == 400) {
      String err = 'something went wrong!';
    } else {
      final String jsonString = jsonEncode(response.body);
      var decodedJson = jsonDecode(jsonString);
      Map<String, dynamic> map = jsonDecode(decodedJson);
      var result = map['VwDKPICorrectiveMaint'];
      setState(() {
        complaintCount = result;
      });
      timerFunction();
    }
  }

  Future<void> serviceApi() async {
    String? ip = '/VwDKPIServiceRequest/';
    const service = ApiConfig.service;
    final url = Uri.parse('$service$ip');
    final headers = {'Accept': 'application/json'};
    const json =
        '{"data":{"CountryID_varchar":0,"CustomerID_varchar":0,"ContractID_varchar":0,"LocationGroupID_varchar":0,"LocalityID_varchar":0,"BuildingID_varchar":0,"CityID_varchar":0,"FloorID_varchar":0,"SpotID_varchar":0,"DivisionID_varchar":0,"DisciplineID_varchar":0,"ServiceTypeID_varchar":0,"FromDate_datetime":"2023-02-05","ToDate_datetime":"2023-03-08","LocUserID_int":"6","PortalUserID_bit":0,"HeaderID_int":1,"DataParam_varchar":null,"PageIndex_int":1,"PageSize_int":10,"ResultCount_int":null}}';
    final response =
        await http.post(url, headers: headers, body: json.toString());
    if (response.statusCode == 400) {
      String err = 'something went wrong!';
    } else {
      final String jsonString = jsonEncode(response.body);
      var decodedJson = jsonDecode(jsonString);
      Map<String, dynamic> map = jsonDecode(decodedJson);
      var result = map['VwDKPIServiceRequest'];
      setState(() {
        serviceCount = result;
      });
      timerFunction();
    }
  }

  Future<void> incidentApi() async {
    String? ip = '/VwDKPIIncident/';
    const service = ApiConfig.service;
    final url = Uri.parse('$service$ip');
    final headers = {'Accept': 'application/json'};
    const json =
        '{"data":{"CountryID_varchar":0,"CustomerID_varchar":0,"ContractID_varchar":0,"LocationGroupID_varchar":0,"LocalityID_varchar":0,"BuildingID_varchar":0,"CityID_varchar":0,"FloorID_varchar":0,"SpotID_varchar":0,"DivisionID_varchar":0,"DisciplineID_varchar":0,"ServiceTypeID_varchar":0,"FromDate_datetime":"2023-02-06","ToDate_datetime":"2023-03-08","LocUserID_int":"6","PortalUserID_bit":0,"HeaderID_int":1,"DataParam_varchar":null,"PageIndex_int":1,"PageSize_int":10,"ResultCount_int":null}}';
    final response =
        await http.post(url, headers: headers, body: json.toString());
    if (response.statusCode == 400) {
      String err = 'something went wrong!';
    } else {
      final String jsonString = jsonEncode(response.body);
      var decodedJson = jsonDecode(jsonString);
      Map<String, dynamic> map = jsonDecode(decodedJson);
      var result = map['VwDKPIIncident'];
      if (result.isNotEmpty) {
        setState(() {
          incidentCount = result;
        });
        timerFunction();
      }
    }
  }

  Future<void> complaints2Api() async {
    String? ip = '/VwDKPICRSLAPerf/';
    const service = ApiConfig.service;
    final url = Uri.parse('$service$ip');
    final headers = {'Accept': 'application/json'};
    const json =
        '{"data":{"CountryID_varchar":0,"CustomerID_varchar":0,"ContractID_varchar":0,"LocationGroupID_varchar":0,"LocalityID_varchar":0,"BuildingID_varchar":0,"CityID_varchar":0,"FloorID_varchar":0,"SpotID_varchar":0,"DivisionID_varchar":0,"DisciplineID_varchar":0,"ServiceTypeID_varchar":0,"FromDate_datetime":"2023-02-06","ToDate_datetime":"2023-03-08","LocUserID_int":"6","PortalUserID_bit":0,"HeaderID_int":1,"DataParam_varchar":null,"PageIndex_int":1,"PageSize_int":10,"ResultCount_int":null}}';
    final response =
        await http.post(url, headers: headers, body: json.toString());
    if (response.statusCode == 400) {
      String err = 'something went wrong!';
    } else {
      final String jsonString = jsonEncode(response.body);
      var decodedJson = jsonDecode(jsonString);
      Map<String, dynamic> map = jsonDecode(decodedJson);
      var result = map['VwDKPICRSLAPerf'];
      if (result.isNotEmpty) {
        setState(() {
          complaint2Count = result;
        });
        timerFunction();
      }
    }
  }

  Future<void> service2Api() async {
    String? ip = '/VwDKPISRSLAPerf/';
    const service = ApiConfig.service;
    final url = Uri.parse('$service$ip');
    final headers = {'Accept': 'application/json'};
    const json =
        '{"data":{"CountryID_varchar":0,"CustomerID_varchar":0,"ContractID_varchar":"3","LocationGroupID_varchar":0,"LocalityID_varchar":0,"BuildingID_varchar":0,"CityID_varchar":0,"FloorID_varchar":0,"SpotID_varchar":0,"DivisionID_varchar":0,"DisciplineID_varchar":0,"ServiceTypeID_varchar":0,"FromDate_datetime":"2023-02-06","ToDate_datetime":"2023-03-08","LocUserID_int":"6","PortalUserID_bit":0,"HeaderID_int":1,"DataParam_varchar":null,"PageIndex_int":1,"PageSize_int":10,"ResultCount_int":null}}';
    final response =
        await http.post(url, headers: headers, body: json.toString());
    if (response.statusCode == 400) {
      String err = 'something went wrong!';
    } else {
      final String jsonString = jsonEncode(response.body);
      var decodedJson = jsonDecode(jsonString);
      Map<String, dynamic> map = jsonDecode(decodedJson);
      var result = map['VwDKPISRSLAPerf'];
      if (result.isNotEmpty) {
        setState(() {
          service2Count = result;
        });
        timerFunction();
      }
    }
  }

  Future<void> incident2Api() async {
    String? ip = '/VwDKPIINCSLAPerf/';
    const service = ApiConfig.service;
    final url = Uri.parse('$service$ip');
    final headers = {'Accept': 'application/json'};
    const json =
        '{"data":{"CountryID_varchar":0,"CustomerID_varchar":0,"ContractID_varchar":"3","LocationGroupID_varchar":0,"LocalityID_varchar":0,"BuildingID_varchar":0,"CityID_varchar":0,"FloorID_varchar":0,"SpotID_varchar":0,"DivisionID_varchar":0,"DisciplineID_varchar":0,"ServiceTypeID_varchar":0,"FromDate_datetime":"2023-02-06","ToDate_datetime":"2023-03-08","LocUserID_int":"6","PortalUserID_bit":0,"HeaderID_int":1,"DataParam_varchar":null,"PageIndex_int":1,"PageSize_int":10,"ResultCount_int":null}}';
    final response =
        await http.post(url, headers: headers, body: json.toString());
    if (response.statusCode == 400) {
      String err = 'something went wrong!';
    } else {
      final String jsonString = jsonEncode(response.body);
      var decodedJson = jsonDecode(jsonString);
      Map<String, dynamic> map = jsonDecode(decodedJson);
      var result = map['VwDKPIINCSLAPerf'];
      if (result.isNotEmpty) {
        setState(() {
          incident2Count = result;
        });
        timerFunction();
      }
    }
  }

  Future<void> preventiveApi() async {
    String? ip = '/VwDKPIPPMSLAPerf/';
    const service = ApiConfig.service;
    final url = Uri.parse('$service$ip');
    final headers = {'Accept': 'application/json'};
    const json =
        '{"data":{"CountryID_varchar":0,"CustomerID_varchar":0,"ContractID_varchar":0,"LocationGroupID_varchar":0,"LocalityID_varchar":0,"BuildingID_varchar":0,"CityID_varchar":0,"FloorID_varchar":0,"SpotID_varchar":0,"DivisionID_varchar":0,"DisciplineID_varchar":0,"ServiceTypeID_varchar":0,"FromDate_datetime":"2023-02-06","ToDate_datetime":"2023-03-08","LocUserID_int":"6","PortalUserID_bit":0,"HeaderID_int":1,"DataParam_varchar":null,"PageIndex_int":1,"PageSize_int":10,"ResultCount_int":null}} ';
    final response =
        await http.post(url, headers: headers, body: json.toString());
    if (response.statusCode == 400) {
      String err = 'something went wrong!';
    } else {
      final String jsonString = jsonEncode(response.body);
      var decodedJson = jsonDecode(jsonString);
      Map<String, dynamic> map = jsonDecode(decodedJson);
      var result = map['VwDKPIPPMSLAPerf'];
      if (result.isNotEmpty) {
        setState(() {
          preventiveCount = result;
        });
        timerFunction();
      }
    }
  }

  Future<void> breakdownApi() async {
    String? ip = '/VwDKPIMonthDetCharts/';
    const service = ApiConfig.service;
    final url = Uri.parse('$service$ip');
    final headers = {'Accept': 'application/json'};
    const json =
        '{"data":{"CountryID_varchar":0,"CustomerID_varchar":0,"ContractID_varchar":0,"LocationGroupID_varchar":0,"LocalityID_varchar":0,"BuildingID_varchar":0,"CityID_varchar":0,"FloorID_varchar":0,"SpotID_varchar":0,"DivisionID_varchar":0,"DisciplineID_varchar":0,"ServiceTypeID_varchar":0,"FromDate_datetime":"2023-02-06","ToDate_datetime":"2023-03-09","LocUserID_int":"6","PortalUserID_bit":0,"HeaderID_int":1,"DataParam_varchar":null,"PageIndex_int":1,"PageSize_int":10,"ResultCount_int":null}}';
    final response =
        await http.post(url, headers: headers, body: json.toString());
    if (response.statusCode == 400) {
      String err = 'something went wrong!';
    } else {
      final String jsonString = jsonEncode(response.body);
      var decodedJson = jsonDecode(jsonString);
      Map<String, dynamic> map = jsonDecode(decodedJson);
      var result = map['VwDKPIMonthDetCharts'];
      if (result.isNotEmpty) {
        for (Map<String, dynamic> i in result) {
          breakdownCount.add(VwDKPIMonthDetCharts.fromJson(i));
        }
        timerFunction();
      }
    }
  }

  Future<void> assetCountApi() async {
    String? ip = '/VwDKPIAssetSummary/';
    const service = ApiConfig.service;
    final url = Uri.parse('$service$ip');
    final headers = {
      'Accept': 'application/json'
      // 'Content-Type': 'application/json'
    };
    const json =
        '{"data":{"CountryID_varchar":0,"CustomerID_varchar":0,"ContractID_varchar":0,"LocationGroupID_varchar":0,"LocalityID_varchar":0,"BuildingID_varchar":0,"CityID_varchar":0,"FloorID_varchar":0,"SpotID_varchar":0,"DivisionID_varchar":0,"DisciplineID_varchar":0,"ServiceTypeID_varchar":0,"FromDate_datetime":"2023-02-11","ToDate_datetime":"2023-03-13","LocUserID_int":"6","PortalUserID_bit":0,"HeaderID_int":1,"DataParam_varchar":null,"PageIndex_int":1,"PageSize_int":10,"ResultCount_int":null}}';
    final response =
        await http.post(url, headers: headers, body: json.toString());
    if (response.statusCode == 400) {
      String err = 'something went wrong!';
    } else {
      final String jsonString = jsonEncode(response.body);
      var decodedJson = jsonDecode(jsonString);
      Map<String, dynamic> map = jsonDecode(decodedJson);
      var result = map['VwDKPIAssetSummary'];
      setState(() {
        assetCount = result;
      });
      timerFunction();
    }
  }

  void timerFunction() {
    Timer(const Duration(seconds: 1), () {
      setState(() {
        timer = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Responsive(
        mobile: mobileChartView(),
        desktop: widget.singCardView == false
            ? webChartView()
            : detailChartAndTableView(context));
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
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0, top: 8.0, bottom: 8.0),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: DefaultTextStyle(
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.black38),
                          child: Text(
                            'Helpdesk / Breakdown Maintenance',
                          ),
                        )),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Flexible(
                        flex: 2,
                        child: timer == true
                            ? webShimmer(shimmerHeight)
                            : contributionChart(),
                      ),
                      Flexible(
                        flex: 2,
                        child: timer == true
                            ? webShimmer(shimmerHeight)
                            : complaintChart(),
                      ),
                      Flexible(
                        flex: 2,
                        child: timer == true
                            ? webShimmer(shimmerHeight)
                            : serviceChart(),
                      ),
                      Flexible(
                        flex: 2,
                        child: timer == true
                            ? webShimmer(shimmerHeight)
                            : incidentChart(),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        flex: 2,
                        child: timer == true
                            ? webShimmer(shimmerHeight)
                            : complaints2Chart(),
                      ),
                      Flexible(
                        flex: 2,
                        child: timer == true
                            ? webShimmer(shimmerHeight)
                            : service2Chart(),
                      ),
                      Flexible(
                        flex: 2,
                        child: timer == true
                            ? webShimmer(shimmerHeight)
                            : incident2Chart(),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0, top: 8.0, bottom: 8.0),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: DefaultTextStyle(
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.black38),
                          child: Text(
                            'Preventive Maintenance',
                          ),
                        )),
                  ),
                  Row(
                    children: [
                      Flexible(
                        flex: 2,
                        child: timer == true
                            ? webShimmer(shimmerHeight)
                            : preventiveChart(),
                      ),
                      Flexible(
                        flex: 2,
                        child: timer == true
                            ? webShimmer(shimmerHeight)
                            : ppmCompletionChart(),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0, top: 8.0, bottom: 8.0),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: DefaultTextStyle(
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.black38),
                          child: Text(
                            'Planned (vs) Breakdown Maintenance Ratio',
                          ),
                        )),
                  ),
                  Row(
                    children: [
                      Flexible(
                        flex: 2,
                        child: timer == true
                            ? webShimmer(shimmerHeight)
                            : breakdownChart1(),
                      ),
                      Flexible(
                        flex: 4,
                        child: timer == true
                            ? webShimmer(shimmerHeight)
                            : breakdownChart(),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0, top: 8.0, bottom: 8.0),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: DefaultTextStyle(
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.black38),
                          child: Text(
                            'Asset(s)',
                          ),
                        )),
                  ),
                  Row(
                    children: [
                      Flexible(
                        flex: 2,
                        child: timer == true
                            ? webShimmer(shimmerHeight)
                            : assetsChart(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SliverFillRemaining(
                child: Row(children: [
              Flexible(
                flex: 2,
                child: timer == true
                    ? webShimmer(shimmerHeight)
                    : Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        color: white,
                        elevation: 4,
                        shadowColor: Colors.black12,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Flexible(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: const [
                                      Flexible(
                                        flex: 2,
                                        child: Text(
                                            ' Lost Contract Entry - Month Wise',
                                            overflow: TextOverflow.ellipsis,
                                            style: cartHeaderStyle),
                                      ),
                                      Icon(Icons.mail, color: secondaryColor),
                                    ],
                                  ),
                                ),
                              ),
                              // Flexible(
                              //   flex: 2,
                              //   // height: 220,
                              //   child: Column(
                              //     mainAxisAlignment:
                              //     MainAxisAlignment.spaceAround,
                              //     children: [
                              //       Flexible(
                              //         flex: 1,
                              //         child: Row(
                              //           mainAxisAlignment:
                              //           MainAxisAlignment.spaceAround,
                              //           children: [
                              //             Flexible(
                              //               flex: 1,
                              //               child: HoverAnimatedContainer(
                              //                   decoration: BoxDecoration(
                              //                     border: Border.all(
                              //                       color:
                              //                       chartNum, // red as border color
                              //                     ),
                              //                     borderRadius:
                              //                     const BorderRadius.all(
                              //                         Radius.circular(10)),
                              //                     color: white,
                              //                   ),
                              //                   hoverDecoration:
                              //                   const BoxDecoration(
                              //                     borderRadius:
                              //                     BorderRadius.all(
                              //                         Radius.circular(10)),
                              //                     color: trending21,
                              //                   ),
                              //                   width: 130,
                              //                   height: 60,
                              //                   child: Padding(
                              //                     padding:
                              //                     const EdgeInsets.all(8.0),
                              //                     child: Column(
                              //                       mainAxisAlignment:
                              //                       MainAxisAlignment
                              //                           .spaceAround,
                              //                       crossAxisAlignment:
                              //                       CrossAxisAlignment
                              //                           .start,
                              //                       children: const [
                              //                         Flexible(
                              //                           flex: 1,
                              //                           child: Text('1 (0.02%)',
                              //                               style: TextStyle(
                              //                                 fontWeight:
                              //                                 FontWeight
                              //                                     .w600,
                              //                                 fontSize: 13,
                              //                                 color: trending5,
                              //                               )),
                              //                         ),
                              //                         Flexible(
                              //                           flex: 2,
                              //                           child: Text(
                              //                               'Assets Insurance In Active',
                              //                               style: TextStyle(
                              //                                   fontSize: 10,
                              //                                   color:
                              //                                   buttonBackground)),
                              //                         ),
                              //                       ],
                              //                     ),
                              //                   )),
                              //             ),
                              //             const SizedBox(
                              //               width: 5,
                              //             ),
                              //             Flexible(
                              //               flex: 1,
                              //               child: HoverAnimatedContainer(
                              //                   decoration: BoxDecoration(
                              //                     border: Border.all(
                              //                       color:
                              //                       chartNum, // red as border color
                              //                     ),
                              //                     borderRadius:
                              //                     const BorderRadius.all(
                              //                         Radius.circular(10)),
                              //                     color: white,
                              //                   ),
                              //                   hoverDecoration:
                              //                   const BoxDecoration(
                              //                     borderRadius:
                              //                     BorderRadius.all(
                              //                         Radius.circular(10)),
                              //                     color: trending21,
                              //                   ),
                              //                   width: 130,
                              //                   height: 60,
                              //                   child: Padding(
                              //                     padding:
                              //                     const EdgeInsets.all(8.0),
                              //                     child: Column(
                              //                       mainAxisAlignment:
                              //                       MainAxisAlignment
                              //                           .spaceAround,
                              //                       crossAxisAlignment:
                              //                       CrossAxisAlignment
                              //                           .start,
                              //                       children: const [
                              //                         Flexible(
                              //                           flex: 1,
                              //                           child: Text('0 (0%)',
                              //                               style: TextStyle(
                              //                                 fontWeight:
                              //                                 FontWeight
                              //                                     .w600,
                              //                                 fontSize: 13,
                              //                                 color: trending6,
                              //                               )),
                              //                         ),
                              //                         Flexible(
                              //                           flex: 2,
                              //                           child: Text(
                              //                               'Assets Insurance Expired',
                              //                               style: TextStyle(
                              //                                   fontSize: 10,
                              //                                   color:
                              //                                   buttonBackground)),
                              //                         ),
                              //                       ],
                              //                     ),
                              //                   )),
                              //             ),
                              //             const SizedBox(
                              //               width: 5,
                              //             ),
                              //             Flexible(
                              //               flex: 1,
                              //               child: HoverAnimatedContainer(
                              //                   decoration: BoxDecoration(
                              //                     border: Border.all(
                              //                       color:
                              //                       chartNum, // red as border color
                              //                     ),
                              //                     borderRadius:
                              //                     const BorderRadius.all(
                              //                         Radius.circular(10)),
                              //                     color: white,
                              //                   ),
                              //                   hoverDecoration:
                              //                   const BoxDecoration(
                              //                     borderRadius:
                              //                     BorderRadius.all(
                              //                         Radius.circular(10)),
                              //                     color: trending21,
                              //                   ),
                              //                   width: 130,
                              //                   height: 60,
                              //                   child: Padding(
                              //                     padding:
                              //                     const EdgeInsets.all(8.0),
                              //                     child: Column(
                              //                       mainAxisAlignment:
                              //                       MainAxisAlignment
                              //                           .spaceAround,
                              //                       crossAxisAlignment:
                              //                       CrossAxisAlignment
                              //                           .start,
                              //                       children: const [
                              //                         Flexible(
                              //                           flex: 1,
                              //                           child: Text(
                              //                               '6336 (99.98%)',
                              //                               style: TextStyle(
                              //                                 fontWeight:
                              //                                 FontWeight
                              //                                     .w600,
                              //                                 fontSize: 13,
                              //                                 color: trending7,
                              //                               )),
                              //                         ),
                              //                         Flexible(
                              //                           flex: 2,
                              //                           child: Text(
                              //                               'Assets Not Insured',
                              //                               style: TextStyle(
                              //                                   fontSize: 10,
                              //                                   color:
                              //                                   buttonBackground)),
                              //                         ),
                              //                       ],
                              //                     ),
                              //                   )),
                              //             ),
                              //           ],
                              //         ),
                              //       ),
                              //       Flexible(
                              //         flex: 2,
                              //         child: SfCartesianChart(
                              //             plotAreaBorderWidth: 0,
                              //             tooltipBehavior:
                              //             TooltipBehavior(enable: true),
                              //             legend: Legend(
                              //                 isVisible: true,
                              //                 position: LegendPosition.top),
                              //             primaryXAxis: CategoryAxis(
                              //               isVisible: true,
                              //             ),
                              //             series: <ChartSeries>[
                              //               ColumnSeries<VwDAssetInsurStatus,
                              //                   String>(
                              //                 // onPointTap: (pointInteractionDetails) {
                              //                 //   tappedValue = pointInteractionDetails
                              //                 //       .dataPoints![pointInteractionDetails.pointIndex!].x;
                              //                 //   setState(() {
                              //                 //     tableName = 'By Division';
                              //                 //   });
                              //                 //   chartTappedDataTable(tappedValue);
                              //                 // },
                              //                 dataSource: assetInsuranceCount,
                              //                 xValueMapper:
                              //                     (VwDAssetInsurStatus data,
                              //                     _) =>
                              //                 data.montName,
                              //                 yValueMapper: (VwDAssetInsurStatus
                              //                 data,
                              //                     _) =>
                              //                     int.parse('${data.totalCnt}'),
                              //                 trackColor: Colors.transparent,
                              //                 name:
                              //                 'Showing Records For Next 4 Months',
                              //                 // color: trending23,
                              //                 borderRadius:
                              //                 const BorderRadius.only(
                              //                     topLeft:
                              //                     Radius.circular(20),
                              //                     topRight:
                              //                     Radius.circular(20)),
                              //                 gradient: const LinearGradient(
                              //                     colors:
                              //                     GradientColors.redLove),
                              //                 dataLabelSettings:
                              //                 const DataLabelSettings(
                              //                     isVisible: true,
                              //                     color: Colors.black,
                              //                     opacity: 0.8,
                              //                     labelAlignment:
                              //                     ChartDataLabelAlignment
                              //                         .outer),
                              //               ),
                              //             ]),
                              //       ),
                              //     ],
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ),
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
                                    color: white,
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
                                        inactiveBgColor: white,
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

  Widget mobileChartView() {
    double shimmerHeight = 300;
    double chartHeight = MediaQuery.of(context).size.height * 0.90;
    double chartWidth = MediaQuery.of(context).size.width * 0.97;
    const TextStyle columnStyle =
        TextStyle(color: white, fontSize: 12, fontWeight: FontWeight.w600);
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
                            : contributionChart(),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        flex: 2,
                        child: timer == true
                            ? MobileShimmer(shimmerHeight)
                            : complaintChart(),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        flex: 2,
                        child: timer == true
                            ? MobileShimmer(shimmerHeight)
                            : serviceChart(),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        flex: 2,
                        child: timer == true
                            ? MobileShimmer(shimmerHeight)
                            : incidentChart(),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        flex: 2,
                        child: timer == true
                            ? MobileShimmer(shimmerHeight)
                            : complaints2Chart(),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                          flex: 2,
                          child: timer == true
                              ? MobileShimmer(shimmerHeight)
                              : service2Chart()),
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                          flex: 2,
                          child: timer == true
                              ? MobileShimmer(shimmerHeight)
                              : incident2Chart()),
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                          flex: 2,
                          child: timer == true
                              ? MobileShimmer(shimmerHeight)
                              : preventiveChart()),
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                          flex: 2,
                          child: timer == true
                              ? MobileShimmer(shimmerHeight)
                              : preventiveChart()),
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                          flex: 2,
                          child: timer == true
                              ? MobileShimmer(shimmerHeight)
                              : breakdownChart1()),
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                          flex: 2,
                          child: timer == true
                              ? MobileShimmer(shimmerHeight)
                              : breakdownChart()),
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                          flex: 2,
                          child: timer == true
                              ? MobileShimmer(shimmerHeight)
                              : assetsChart()),
                    ],
                  ),
                ],
              ),
            ),
            SliverFillRemaining(
                child: Row(children: [
              Flexible(
                flex: 2,
                child: timer == true
                    ? MobileShimmer(shimmerHeight)
                    : ppmCompletionChart(),
              )
            ])),
          ]),
        ),
      ),
    );
  }

  Widget contributionChart() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: white,
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
                    child: Text(' Contribution', style: cartHeaderStyle),
                  ),
                  Icon(Icons.mail, color: secondaryColor),
                ],
              ),
            ),
            SizedBox(
              height: 250,
              child: SfCartesianChart(
                  plotAreaBorderWidth: 0,
                  tooltipBehavior: TooltipBehavior(enable: true),
                  legend:
                      Legend(isVisible: true, position: LegendPosition.right),
                  primaryXAxis: CategoryAxis(
                    isVisible: false,
                  ),
                  primaryYAxis: CategoryAxis(isVisible: false, interval: 3),
                  series: <ChartSeries>[
                    ColumnSeries<dynamic, String>(
                      // onPointTap: (pointInteractionDetails) {
                      //   var val;
                      //   val = pointInteractionDetails
                      //       .dataPoints![pointInteractionDetails.pointIndex!].x;
                      //   setState(() {
                      //     tableName = 'Status -Expired';
                      //     tappedValue = statusCount[0]['ExpiredCnt'];
                      //   });
                      //   // chartTappedDataTable();
                      // },
                      name: 'Complaints',
                      dataSource: contributionCount,
                      xValueMapper: (dynamic data, _) => 'Complaints',
                      yValueMapper: (dynamic data, _) =>
                          int.parse('${contributionCount[0]['CompCnt']}'),
                      trackColor: Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      gradient: const LinearGradient(
                          colors: GradientColors.plumPlate),
                      dataLabelSettings: const DataLabelSettings(
                          isVisible: true,
                          color: Colors.black,
                          opacity: 0.8,
                          labelAlignment: ChartDataLabelAlignment.outer),
                    ),
                    ColumnSeries<dynamic, String>(
                      // onPointTap: (pointInteractionDetails) {
                      //   var val;
                      //   val = pointInteractionDetails
                      //       .dataPoints![pointInteractionDetails.pointIndex!].x;
                      //   setState(() {
                      //     tableName = 'Status -Live';
                      //     tappedValue = statusCount[0]['LiveCnt'];
                      //   });
                      //   chartTappedDataTable();
                      // },
                      name: 'Service Request',
                      dataSource: contributionCount,
                      xValueMapper: (dynamic data, _) => 'Service Request',
                      yValueMapper: (dynamic data, _) =>
                          int.parse('${contributionCount[0]['SRCnt']}'),
                      trackColor: Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      gradient: const LinearGradient(
                          colors: GradientColors.happyMemories),
                      dataLabelSettings: const DataLabelSettings(
                          isVisible: true,
                          color: Colors.black,
                          opacity: 0.8,
                          labelAlignment: ChartDataLabelAlignment.outer),
                    ),
                    ColumnSeries<dynamic, String>(
                      // onPointTap: (pointInteractionDetails) {
                      //   var val;
                      //   val = pointInteractionDetails
                      //       .dataPoints![pointInteractionDetails.pointIndex!].x;
                      //   setState(() {
                      //     tableName = 'Status -Live';
                      //     tappedValue = statusCount[0]['LiveCnt'];
                      //   });
                      //   chartTappedDataTable();
                      // },
                      name: 'Incident',
                      dataSource: contributionCount,
                      xValueMapper: (dynamic data, _) => 'Incident',
                      yValueMapper: (dynamic data, _) =>
                          int.parse(' ${contributionCount[0]['INCCnt']}'),
                      trackColor: Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      gradient: const LinearGradient(
                          colors: GradientColors.aquaSplash),
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

  Widget complaintChart() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: white,
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
                    child: Text(' Complaints', style: cartHeaderStyle),
                  ),
                  Icon(Icons.mail, color: secondaryColor),
                ],
              ),
            ),
            SizedBox(
              height: 250,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Flexible(
                      flex: 1,
                      child: Row(
                        children: [
                          Flexible(
                            flex: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Flexible(
                                  flex: 1,
                                  child: Icon(Icons.task_alt,
                                      color: cardText,
                                      size: MediaQuery.of(context).size.width *
                                          0.03),
                                ),
                                Flexible(
                                  flex: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text('${complaintCount[0]['Comp']}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 20,
                                              color: trending26,
                                            )),
                                        const Text('Completed By Tech',
                                            overflow: TextOverflow.clip,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 9,
                                              color: cardText,
                                            )),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Flexible(
                                      flex: 1,
                                      child: SvgPicture.asset(
                                          "assets/images/process.svg",
                                          color: cardText)),
                                  Flexible(
                                    flex: 2,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text('${complaintCount[0]['Appr']}',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 20,
                                                color: trending26,
                                              )),
                                          const Text('In Approval Process',
                                              overflow: TextOverflow.clip,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 9,
                                                color: cardText,
                                              )),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )),
                  Flexible(
                    flex: 5,
                    child: SfCartesianChart(
                        plotAreaBorderWidth: 0,
                        tooltipBehavior: TooltipBehavior(enable: true),
                        legend: Legend(
                            isVisible: true, position: LegendPosition.right),
                        primaryXAxis: CategoryAxis(
                          isVisible: false,
                        ),
                        primaryYAxis: CategoryAxis(
                            majorGridLines:
                                const MajorGridLines(color: Colors.transparent),
                            isVisible: true,
                            interval: 3),
                        series: <ChartSeries>[
                          ColumnSeries<dynamic, String>(
                            // onPointTap: (pointInteractionDetails) {
                            //   var val;
                            //   val = pointInteractionDetails
                            //       .dataPoints![pointInteractionDetails.pointIndex!].x;
                            //   setState(() {
                            //     tableName = 'Status -Expired';
                            //     tappedValue = statusCount[0]['ExpiredCnt'];
                            //   });
                            //   // chartTappedDataTable();
                            // },
                            name: 'Total',
                            dataSource: complaintCount,
                            xValueMapper: (dynamic data, _) => 'Total',
                            yValueMapper: (dynamic data, _) =>
                                int.parse('${complaintCount[0]['BDMTot']}'),
                            trackColor: Colors.transparent,
                            borderRadius: BorderRadius.circular(2),
                            color: trending6,
                            dataLabelSettings: const DataLabelSettings(
                                isVisible: true,
                                color: Colors.black87,
                                opacity: 0.8,
                                labelAlignment: ChartDataLabelAlignment.outer),
                          ),
                          ColumnSeries<dynamic, String>(
                            // onPointTap: (pointInteractionDetails) {
                            //   var val;
                            //   val = pointInteractionDetails
                            //       .dataPoints![pointInteractionDetails.pointIndex!].x;
                            //   setState(() {
                            //     tableName = 'Status -Live';
                            //     tappedValue = statusCount[0]['LiveCnt'];
                            //   });
                            //   chartTappedDataTable();
                            // },
                            name: 'Open',
                            dataSource: complaintCount,
                            xValueMapper: (dynamic data, _) => 'Open',
                            yValueMapper: (dynamic data, _) =>
                                int.parse('${complaintCount[0]['BDMOpen']}'),
                            trackColor: Colors.transparent,
                            borderRadius: BorderRadius.circular(2),
                            gradient: const LinearGradient(
                                colors: GradientColors.mirage),
                            dataLabelSettings: const DataLabelSettings(
                                isVisible: true,
                                color: Colors.black87,
                                opacity: 0.8,
                                labelAlignment: ChartDataLabelAlignment.outer),
                          ),
                          ColumnSeries<dynamic, String>(
                            // onPointTap: (pointInteractionDetails) {
                            //   var val;
                            //   val = pointInteractionDetails
                            //       .dataPoints![pointInteractionDetails.pointIndex!].x;
                            //   setState(() {
                            //     tableName = 'Status -Live';
                            //     tappedValue = statusCount[0]['LiveCnt'];
                            //   });
                            //   chartTappedDataTable();
                            // },
                            name: 'Closed',
                            dataSource: complaintCount,
                            xValueMapper: (dynamic data, _) => 'Closed',
                            yValueMapper: (dynamic data, _) =>
                                int.parse(' ${complaintCount[0]['BDMClosed']}'),
                            trackColor: Colors.transparent,
                            borderRadius: BorderRadius.circular(2),
                            gradient: const LinearGradient(
                                colors: GradientColors.greatWhale),
                            dataLabelSettings: const DataLabelSettings(
                                isVisible: true,
                                color: Colors.black87,
                                opacity: 0.8,
                                labelAlignment: ChartDataLabelAlignment.outer),
                          ),
                        ]),
                  ),
                  Flexible(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        height: 15,
                        child: LiquidLinearProgressIndicator(
                          value: complaintCount[0]['BDMCompliance'] == ""
                              ? 0 / 100
                              : double.parse(
                                      '${complaintCount[0]['BDMCompliance']}') /
                                  100, // Defaults to 0.5.
                          valueColor: const AlwaysStoppedAnimation(trending25),
                          backgroundColor: Colors.grey.shade200,
                          borderRadius: 4.0,
                          borderWidth: 0,
                          borderColor: Colors.transparent,
                          direction: Axis.horizontal,
                          center: Text(
                              "Compliance ${complaintCount[0]['BDMCompliance']}%",
                              style: const TextStyle(
                                  fontSize: 8,
                                  fontWeight: FontWeight.w600,
                                  // color: double.parse(
                                  //             '${complaintCount[0]['BDMCompliance']}') >=
                                  //         50.00
                                  //     ? white
                                  //     : Colors.black
                                  color: Colors.black)),
                        ),
                      ),
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

  Widget serviceChart() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: white,
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
                    child: Text(' Service Request', style: cartHeaderStyle),
                  ),
                  Icon(Icons.mail, color: secondaryColor),
                ],
              ),
            ),
            SizedBox(
              height: 250,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Flexible(
                      flex: 1,
                      child: Row(
                        children: [
                          Flexible(
                            flex: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Flexible(
                                  flex: 1,
                                  child: Icon(Icons.task_alt,
                                      color: cardText,
                                      size: MediaQuery.of(context).size.width *
                                          0.03),
                                ),
                                Flexible(
                                  flex: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text('${serviceCount[0]['Comp']}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 20,
                                              color: trending26,
                                            )),
                                        const Text('Completed By Tech',
                                            overflow: TextOverflow.clip,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 9,
                                              color: cardText,
                                            )),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Flexible(
                                      flex: 1,
                                      child: SvgPicture.asset(
                                          "assets/images/process.svg",
                                          color: cardText)),
                                  Flexible(
                                    flex: 2,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text('${serviceCount[0]['Appr']}',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 20,
                                                color: trending26,
                                              )),
                                          const Text('In Approval Process',
                                              overflow: TextOverflow.clip,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 9,
                                                color: cardText,
                                              )),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )),
                  Flexible(
                    flex: 5,
                    child: SfCartesianChart(
                        plotAreaBorderWidth: 0,
                        tooltipBehavior: TooltipBehavior(enable: true),
                        legend: Legend(
                            isVisible: true, position: LegendPosition.right),
                        primaryXAxis: CategoryAxis(
                          isVisible: false,
                        ),
                        primaryYAxis: CategoryAxis(
                            isVisible: true,
                            majorGridLines:
                                const MajorGridLines(color: Colors.transparent),
                            interval: 3),
                        series: <ChartSeries>[
                          ColumnSeries<dynamic, String>(
                            // onPointTap: (pointInteractionDetails) {
                            //   var val;
                            //   val = pointInteractionDetails
                            //       .dataPoints![pointInteractionDetails.pointIndex!].x;
                            //   setState(() {
                            //     tableName = 'Status -Expired';
                            //     tappedValue = statusCount[0]['ExpiredCnt'];
                            //   });
                            //   // chartTappedDataTable();
                            // },
                            name: 'Total',
                            dataSource: serviceCount,
                            xValueMapper: (dynamic data, _) => 'Total',
                            yValueMapper: (dynamic data, _) =>
                                int.parse('${serviceCount[0]['BDMTot']}'),
                            trackColor: Colors.transparent,
                            borderRadius: BorderRadius.circular(2),
                            // gradient: const LinearGradient(
                            //     colors: GradientColors.morpheusDen),
                            color: trending6,
                            dataLabelSettings: const DataLabelSettings(
                                isVisible: true,
                                color: Colors.black87,
                                opacity: 0.8,
                                labelAlignment: ChartDataLabelAlignment.outer),
                          ),
                          ColumnSeries<dynamic, String>(
                            // onPointTap: (pointInteractionDetails) {
                            //   var val;
                            //   val = pointInteractionDetails
                            //       .dataPoints![pointInteractionDetails.pointIndex!].x;
                            //   setState(() {
                            //     tableName = 'Status -Live';
                            //     tappedValue = statusCount[0]['LiveCnt'];
                            //   });
                            //   chartTappedDataTable();
                            // },
                            name: 'Open',
                            dataSource: serviceCount,
                            xValueMapper: (dynamic data, _) => 'Open',
                            yValueMapper: (dynamic data, _) =>
                                int.parse('${serviceCount[0]['BDMOpen']}'),
                            trackColor: Colors.transparent,
                            borderRadius: BorderRadius.circular(2),
                            color: trending7,
                            // gradient: const LinearGradient(
                            //     colors: GradientColors.dustyGrass),
                            dataLabelSettings: const DataLabelSettings(
                                isVisible: true,
                                color: Colors.black87,
                                opacity: 0.8,
                                labelAlignment: ChartDataLabelAlignment.outer),
                          ),
                          ColumnSeries<dynamic, String>(
                            // onPointTap: (pointInteractionDetails) {
                            //   var val;
                            //   val = pointInteractionDetails
                            //       .dataPoints![pointInteractionDetails.pointIndex!].x;
                            //   setState(() {
                            //     tableName = 'Status -Live';
                            //     tappedValue = statusCount[0]['LiveCnt'];
                            //   });
                            //   chartTappedDataTable();
                            // },
                            name: 'Closed',
                            dataSource: serviceCount,
                            xValueMapper: (dynamic data, _) => 'Closed',
                            yValueMapper: (dynamic data, _) =>
                                int.parse(' ${serviceCount[0]['BDMClosed']}'),
                            trackColor: Colors.transparent,
                            borderRadius: BorderRadius.circular(2),
                            gradient: const LinearGradient(
                                colors: GradientColors.greatWhale),
                            dataLabelSettings: const DataLabelSettings(
                                isVisible: true,
                                color: Colors.black87,
                                opacity: 0.8,
                                labelAlignment: ChartDataLabelAlignment.outer),
                          ),
                        ]),
                  ),
                  Flexible(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        height: 15,
                        child: LiquidLinearProgressIndicator(
                          value: serviceCount[0]['BDMCompliance'] == ""
                              ? 0 / 100
                              : double.parse(
                                      '${serviceCount[0]['BDMCompliance']}') /
                                  100, // Defaults to 0.5.
                          valueColor: const AlwaysStoppedAnimation(trending25),
                          backgroundColor: Colors.grey.shade200,
                          borderRadius: 4.0,
                          borderWidth: 0,
                          borderColor: Colors.transparent,
                          direction: Axis.horizontal,
                          center: Text(
                              "Compliance ${serviceCount[0]['BDMCompliance']}%",
                              style: const TextStyle(
                                  fontSize: 8,
                                  fontWeight: FontWeight.w600,
                                  // color: double.parse(
                                  //             '${serviceCount[0]['BDMCompliance']}') >=
                                  //         50.00
                                  //     ? white
                                  //     : Colors.black
                                  color: Colors.black)),
                        ),
                      ),
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

  Widget incidentChart() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: white,
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
                    child: Text(' Incident', style: cartHeaderStyle),
                  ),
                  Icon(Icons.mail, color: secondaryColor),
                ],
              ),
            ),
            SizedBox(
              height: 250,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Flexible(
                      flex: 1,
                      child: Row(
                        children: [
                          Flexible(
                            flex: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Flexible(
                                  flex: 1,
                                  child: Icon(Icons.task_alt,
                                      color: cardText,
                                      size: MediaQuery.of(context).size.width *
                                          0.03),
                                ),
                                Flexible(
                                  flex: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text('${incidentCount[0]['Comp']}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 20,
                                              color: trending26,
                                            )),
                                        const Text('Completed By Tech',
                                            overflow: TextOverflow.clip,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 9,
                                              color: cardText,
                                            )),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Flexible(
                                      flex: 1,
                                      child: SvgPicture.asset(
                                          "assets/images/process.svg",
                                          color: cardText)),
                                  Flexible(
                                    flex: 2,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text('${incidentCount[0]['Appr']}',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 20,
                                                color: trending26,
                                              )),
                                          const Text('In Approval Process',
                                              overflow: TextOverflow.clip,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 9,
                                                color: cardText,
                                              )),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )),
                  Flexible(
                    flex: 5,
                    child: SfCartesianChart(
                        plotAreaBorderWidth: 0,
                        tooltipBehavior: TooltipBehavior(enable: true),
                        legend: Legend(
                            isVisible: true, position: LegendPosition.right),
                        primaryXAxis: CategoryAxis(
                          isVisible: false,
                        ),
                        primaryYAxis: CategoryAxis(
                            isVisible: true,
                            majorGridLines: const MajorGridLines(
                                color: Colors.transparent)),
                        series: <ChartSeries>[
                          ColumnSeries<dynamic, String>(
                            // onPointTap: (pointInteractionDetails) {
                            //   var val;
                            //   val = pointInteractionDetails
                            //       .dataPoints![pointInteractionDetails.pointIndex!].x;
                            //   setState(() {
                            //     tableName = 'Status -Expired';
                            //     tappedValue = statusCount[0]['ExpiredCnt'];
                            //   });
                            //   // chartTappedDataTable();
                            // },
                            name: 'Total',
                            dataSource: incidentCount,
                            xValueMapper: (dynamic data, _) => 'Total',
                            yValueMapper: (dynamic data, _) =>
                                int.parse('${incidentCount[0]['BDMTot']}'),
                            trackColor: Colors.transparent,
                            borderRadius: BorderRadius.circular(2),
                            color: trending6,
                            dataLabelSettings: const DataLabelSettings(
                                isVisible: true,
                                color: Colors.black87,
                                opacity: 0.8,
                                labelAlignment: ChartDataLabelAlignment.outer),
                          ),
                          ColumnSeries<dynamic, String>(
                            // onPointTap: (pointInteractionDetails) {
                            //   var val;
                            //   val = pointInteractionDetails
                            //       .dataPoints![pointInteractionDetails.pointIndex!].x;
                            //   setState(() {
                            //     tableName = 'Status -Live';
                            //     tappedValue = statusCount[0]['LiveCnt'];
                            //   });
                            //   chartTappedDataTable();
                            // },
                            name: 'Open',
                            dataSource: incidentCount,
                            xValueMapper: (dynamic data, _) => 'Open',
                            yValueMapper: (dynamic data, _) =>
                                int.parse('${incidentCount[0]['BDMOpen']}'),
                            trackColor: Colors.transparent,
                            borderRadius: BorderRadius.circular(2),
                            color: trending7,
                            // gradient: const LinearGradient(
                            //     colors: GradientColors.dustyGrass),
                            dataLabelSettings: const DataLabelSettings(
                                isVisible: true,
                                color: Colors.black87,
                                opacity: 0.8,
                                labelAlignment: ChartDataLabelAlignment.outer),
                          ),
                          ColumnSeries<dynamic, String>(
                            // onPointTap: (pointInteractionDetails) {
                            //   var val;
                            //   val = pointInteractionDetails
                            //       .dataPoints![pointInteractionDetails.pointIndex!].x;
                            //   setState(() {
                            //     tableName = 'Status -Live';
                            //     tappedValue = statusCount[0]['LiveCnt'];
                            //   });
                            //   chartTappedDataTable();
                            // },
                            name: 'Closed',
                            dataSource: incidentCount,
                            xValueMapper: (dynamic data, _) => 'Closed',
                            yValueMapper: (dynamic data, _) =>
                                int.parse(' ${incidentCount[0]['BDMClosed']}'),
                            trackColor: Colors.transparent,
                            borderRadius: BorderRadius.circular(2),
                            gradient: const LinearGradient(
                                colors: GradientColors.greatWhale),
                            dataLabelSettings: const DataLabelSettings(
                                isVisible: true,
                                color: Colors.black87,
                                opacity: 0.8,
                                labelAlignment: ChartDataLabelAlignment.outer),
                          ),
                        ]),
                  ),
                  Flexible(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        height: 15,
                        child: LiquidLinearProgressIndicator(
                          value: incidentCount[0]['BDMCompliance'] == ""
                              ? 0 / 100
                              : double.parse(
                                      '${incidentCount[0]['BDMCompliance']}') /
                                  100, // Defaults to 0.5.
                          valueColor: const AlwaysStoppedAnimation(trending25),
                          backgroundColor: Colors.grey.shade200,
                          borderRadius: 4.0,
                          borderWidth: 0,
                          borderColor: Colors.transparent,
                          direction: Axis.horizontal,
                          center: Text(
                              "Compliance ${incidentCount[0]['BDMCompliance']}%",
                              style: const TextStyle(
                                  fontSize: 8,
                                  fontWeight: FontWeight.w600,
                                  // color: double.parse(
                                  //             '${serviceCount[0]['BDMCompliance']}') >=
                                  //         50.00
                                  //     ? white
                                  //     : Colors.black
                                  color: Colors.black)),
                        ),
                      ),
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

  Widget complaints2Chart() {
    return Card(
      shape: cardBorder == 7
          ? RoundedRectangleBorder(
              side: const BorderSide(color: secondaryColor, width: 2.0),
              borderRadius: BorderRadius.circular(15),
            )
          : RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
      color: white,
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
                    child: Text(' Complaints', style: cartHeaderStyle),
                  ),
                  Icon(Icons.mail, color: secondaryColor),
                ],
              ),
            ),
            SizedBox(
              height: 220,
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: SfCartesianChart(
                        plotAreaBorderWidth: 0,
                        tooltipBehavior: TooltipBehavior(
                            enable: true,
                            tooltipPosition: TooltipPosition.pointer),
                        legend: Legend(
                            isVisible: false, position: LegendPosition.right),
                        primaryXAxis: CategoryAxis(
                            isVisible: true,
                            majorGridLines: const MajorGridLines(
                                color: Colors.transparent)),
                        primaryYAxis: CategoryAxis(
                            isVisible: false, minimum: 0, interval: 2),
                        series: <ChartSeries>[
                          ColumnSeries<dynamic, String>(
                            // onPointTap: (pointInteractionDetails) {
                            //   var val;
                            //   val = pointInteractionDetails
                            //       .dataPoints![pointInteractionDetails.pointIndex!]
                            //       .x;
                            //   setState(() {
                            //     tableName = 'Location Group';
                            //     tappedValue = val;
                            //   });
                            //   chartTappedDataTable();
                            // },
                            borderRadius: BorderRadius.circular(4),
                            color: trending8,
                            dataLabelSettings: const DataLabelSettings(
                                isVisible: true,
                                color: Colors.black87,
                                opacity: 0.8,
                                labelAlignment: ChartDataLabelAlignment.outer),
                            dataSource: complaint2Count,
                            xValueMapper: (dynamic data, _) => 'Response',
                            yValueMapper: (dynamic data, _) =>
                                int.parse('${complaint2Count[0]['AttOnTime']}'),
                            name: 'Response',
                          ),
                          ColumnSeries<dynamic, String>(
                              dataLabelSettings: const DataLabelSettings(
                                  isVisible: true,
                                  color: Colors.black87,
                                  opacity: 0.8,
                                  labelAlignment:
                                      ChartDataLabelAlignment.outer),
                              name: 'Resolution',
                              borderRadius: BorderRadius.circular(4),
                              color: trending4,
                              dataSource: complaint2Count,
                              xValueMapper: (dynamic data, _) => 'Resolution',
                              yValueMapper: (dynamic data, _) => int.parse(
                                  '${complaint2Count[0]['CompOnTime']}')),
                        ]),
                  ),
                  Flexible(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Flexible(
                                  flex: 1,
                                  child: Text('Response Target',
                                      overflow: TextOverflow.clip,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 9,
                                        color: cardText,
                                      )),
                                ),
                                Flexible(
                                  flex: 1,
                                  child: Text(
                                      '- ${complaint2Count[0]['CMTarget']}%',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                        color: trending26,
                                      )),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Flexible(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Flexible(
                                  flex: 1,
                                  child: Text('Resolution Target',
                                      overflow: TextOverflow.clip,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 9,
                                        color: cardText,
                                      )),
                                ),
                                Flexible(
                                  flex: 1,
                                  child: Text(
                                      '- ${complaint2Count[0]['BDMTarget']}%',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                        color: trending26,
                                      )),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
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

  Widget service2Chart() {
    return Card(
      shape: cardBorder == 7
          ? RoundedRectangleBorder(
              side: const BorderSide(color: secondaryColor, width: 2.0),
              borderRadius: BorderRadius.circular(15),
            )
          : RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
      color: white,
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
                    child: Text(' Service Request', style: cartHeaderStyle),
                  ),
                  Icon(Icons.mail, color: secondaryColor),
                ],
              ),
            ),
            SizedBox(
              height: 220,
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: SfCartesianChart(
                        plotAreaBorderWidth: 0,
                        tooltipBehavior: TooltipBehavior(
                          tooltipPosition: TooltipPosition.pointer,
                          enable: true,
                        ),
                        legend: Legend(
                            isVisible: false, position: LegendPosition.right),
                        primaryXAxis: CategoryAxis(
                            isVisible: true,
                            majorGridLines: const MajorGridLines(
                                color: Colors.transparent)),
                        primaryYAxis: CategoryAxis(
                            isVisible: false, minimum: 0, interval: 2),
                        series: <ChartSeries>[
                          ColumnSeries<dynamic, String>(
                            // onPointTap: (pointInteractionDetails) {
                            //   var val;
                            //   val = pointInteractionDetails
                            //       .dataPoints![pointInteractionDetails.pointIndex!]
                            //       .x;
                            //   setState(() {
                            //     tableName = 'Location Group';
                            //     tappedValue = val;
                            //   });
                            //   chartTappedDataTable();
                            // },
                            borderRadius: BorderRadius.circular(4),
                            color: trending8,
                            dataLabelSettings: const DataLabelSettings(
                                isVisible: true,
                                color: Colors.black87,
                                opacity: 0.8,
                                labelAlignment: ChartDataLabelAlignment.outer),
                            dataSource: service2Count,
                            xValueMapper: (dynamic data, _) => 'Response',
                            yValueMapper: (dynamic data, _) =>
                                int.parse('${service2Count[0]['AttOnTime']}'),
                            name: 'Response',
                          ),
                          ColumnSeries<dynamic, String>(
                              dataLabelSettings: const DataLabelSettings(
                                  isVisible: true,
                                  color: Colors.black87,
                                  opacity: 0.8,
                                  labelAlignment:
                                      ChartDataLabelAlignment.outer),
                              name: 'Resolution',
                              borderRadius: BorderRadius.circular(4),
                              color: trending4,
                              dataSource: service2Count,
                              xValueMapper: (dynamic data, _) => 'Resolution',
                              yValueMapper: (dynamic data, _) => int.parse(
                                  '${service2Count[0]['CompOnTime']}')),
                        ]),
                  ),
                  Flexible(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Flexible(
                                  flex: 1,
                                  child: Text('Response Target',
                                      overflow: TextOverflow.clip,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 9,
                                        color: cardText,
                                      )),
                                ),
                                Flexible(
                                  flex: 1,
                                  child:
                                      Text('- ${service2Count[0]['CMTarget']}%',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                            color: trending26,
                                          )),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Flexible(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Flexible(
                                  flex: 1,
                                  child: Text('Resolution Target',
                                      overflow: TextOverflow.clip,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 9,
                                        color: cardText,
                                      )),
                                ),
                                Flexible(
                                  flex: 1,
                                  child: Text(
                                      '- ${service2Count[0]['BDMTarget']}%',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                        color: trending26,
                                      )),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
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

  Widget incident2Chart() {
    return Card(
      shape: cardBorder == 7
          ? RoundedRectangleBorder(
              side: const BorderSide(color: secondaryColor, width: 2.0),
              borderRadius: BorderRadius.circular(15),
            )
          : RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
      color: white,
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
                    child: Text(' Incident', style: cartHeaderStyle),
                  ),
                  Icon(Icons.mail, color: secondaryColor),
                ],
              ),
            ),
            SizedBox(
              height: 220,
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: SfCartesianChart(
                        plotAreaBorderWidth: 0,
                        tooltipBehavior: TooltipBehavior(
                          tooltipPosition: TooltipPosition.pointer,
                          enable: true,
                        ),
                        legend: Legend(
                            isVisible: false, position: LegendPosition.bottom),
                        primaryXAxis: CategoryAxis(
                            isVisible: true,
                            majorGridLines: const MajorGridLines(
                                color: Colors.transparent)),
                        primaryYAxis: CategoryAxis(
                            isVisible: false, minimum: 0, interval: 2),
                        series: <ChartSeries>[
                          ColumnSeries<dynamic, String>(
                            // onPointTap: (pointInteractionDetails) {
                            //   var val;
                            //   val = pointInteractionDetails
                            //       .dataPoints![pointInteractionDetails.pointIndex!]
                            //       .x;
                            //   setState(() {
                            //     tableName = 'Location Group';
                            //     tappedValue = val;
                            //   });
                            //   chartTappedDataTable();
                            // },
                            borderRadius: BorderRadius.circular(4),
                            color: trending8,
                            dataLabelSettings: const DataLabelSettings(
                                isVisible: true,
                                color: Colors.black87,
                                opacity: 0.8,
                                labelAlignment: ChartDataLabelAlignment.outer),
                            dataSource: incident2Count,
                            xValueMapper: (dynamic data, _) => 'Response',
                            yValueMapper: (dynamic data, _) =>
                                int.parse('${incident2Count[0]['AttOnTime']}'),
                            name: 'Response',
                          ),
                          ColumnSeries<dynamic, String>(
                              dataLabelSettings: const DataLabelSettings(
                                  isVisible: true,
                                  color: Colors.black87,
                                  opacity: 0.8,
                                  labelAlignment:
                                      ChartDataLabelAlignment.outer),
                              name: 'Resolution',
                              borderRadius: BorderRadius.circular(4),
                              color: trending4,
                              dataSource: incident2Count,
                              xValueMapper: (dynamic data, _) => 'Resolution',
                              yValueMapper: (dynamic data, _) => int.parse(
                                  '${incident2Count[0]['CompOnTime']}')),
                        ]),
                  ),
                  Flexible(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Flexible(
                                  flex: 1,
                                  child: Text('Response Target',
                                      overflow: TextOverflow.clip,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 9,
                                        color: cardText,
                                      )),
                                ),
                                Flexible(
                                  flex: 1,
                                  child: Text(
                                      '- ${incident2Count[0]['CMTarget']}%',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                        color: trending26,
                                      )),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Flexible(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Flexible(
                                  flex: 1,
                                  child: Text('Resolution Target',
                                      overflow: TextOverflow.clip,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 9,
                                        color: cardText,
                                      )),
                                ),
                                Flexible(
                                  flex: 1,
                                  child: Text(
                                      '- ${incident2Count[0]['BDMTarget']}%',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                        color: trending26,
                                      )),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
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

  Widget preventiveChart() {
    return Card(
      shape: cardBorder == 7
          ? RoundedRectangleBorder(
              side: const BorderSide(color: secondaryColor, width: 2.0),
              borderRadius: BorderRadius.circular(15),
            )
          : RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
      color: white,
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
                    child:
                        Text(' Preventive Maintenance', style: cartHeaderStyle),
                  ),
                  Icon(Icons.mail, color: secondaryColor),
                ],
              ),
            ),
            SizedBox(
              height: 220,
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: SfCartesianChart(
                        plotAreaBorderWidth: 0,
                        tooltipBehavior: TooltipBehavior(
                            enable: true,
                            tooltipPosition: TooltipPosition.pointer),
                        legend: Legend(
                            isVisible: false, position: LegendPosition.bottom),
                        primaryXAxis: CategoryAxis(
                            isVisible: true,
                            majorGridLines: const MajorGridLines(
                                color: Colors.transparent)),
                        primaryYAxis: CategoryAxis(
                            isVisible: false, minimum: 0, interval: 2),
                        series: <ChartSeries>[
                          ColumnSeries<dynamic, String>(
                            // onPointTap: (pointInteractionDetails) {
                            //   var val;
                            //   val = pointInteractionDetails
                            //       .dataPoints![pointInteractionDetails.pointIndex!]
                            //       .x;
                            //   setState(() {
                            //     tableName = 'Location Group';
                            //     tappedValue = val;
                            //   });
                            //   chartTappedDataTable();
                            // },
                            borderRadius: BorderRadius.circular(4),
                            color: trending6,
                            dataLabelSettings: const DataLabelSettings(
                                isVisible: true,
                                color: Colors.black87,
                                opacity: 0.8,
                                labelAlignment: ChartDataLabelAlignment.outer),
                            dataSource: preventiveCount,
                            xValueMapper: (dynamic data, _) => 'Total',
                            yValueMapper: (dynamic data, _) =>
                                int.parse('${preventiveCount[0]['PPMTot']}'),
                          ),
                          ColumnSeries<dynamic, String>(
                              dataLabelSettings: const DataLabelSettings(
                                  isVisible: true,
                                  color: Colors.black87,
                                  opacity: 0.8,
                                  labelAlignment:
                                      ChartDataLabelAlignment.outer),
                              borderRadius: BorderRadius.circular(4),
                              color: trending7,
                              dataSource: preventiveCount,
                              xValueMapper: (dynamic data, _) => 'Open',
                              yValueMapper: (dynamic data, _) => int.parse(
                                  '${preventiveCount[0]['PPMOpen']}')),
                          ColumnSeries<dynamic, String>(
                              dataLabelSettings: const DataLabelSettings(
                                  isVisible: true,
                                  color: Colors.black87,
                                  opacity: 0.8,
                                  labelAlignment:
                                      ChartDataLabelAlignment.outer),
                              borderRadius: BorderRadius.circular(4),
                              gradient: const LinearGradient(
                                  colors: GradientColors.greatWhale),
                              dataSource: preventiveCount,
                              xValueMapper: (dynamic data, _) => 'Closed',
                              yValueMapper: (dynamic data, _) => int.parse(
                                  '${preventiveCount[0]['PPMClosed']}')),
                          ColumnSeries<dynamic, String>(
                              dataLabelSettings: const DataLabelSettings(
                                  isVisible: true,
                                  color: Colors.black87,
                                  opacity: 0.8,
                                  labelAlignment:
                                      ChartDataLabelAlignment.outer),
                              borderRadius: BorderRadius.circular(4),
                              color: trending2,
                              dataSource: preventiveCount,
                              xValueMapper: (dynamic data, _) => 'Withdrawn',
                              yValueMapper: (dynamic data, _) =>
                                  int.parse('${preventiveCount[0]['WD']}')),
                        ]),
                  ),
                  Flexible(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Flexible(
                                  flex: 1,
                                  child: Text('Target',
                                      overflow: TextOverflow.clip,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 9,
                                        color: cardText,
                                      )),
                                ),
                                Flexible(
                                  flex: 1,
                                  child: Text(
                                      '- ${preventiveCount[0]['PPMTarget']}%',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                        color: trending26,
                                      )),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Flexible(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Flexible(
                                  flex: 1,
                                  child: Text('Complaince',
                                      overflow: TextOverflow.clip,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 9,
                                        color: cardText,
                                      )),
                                ),
                                Flexible(
                                  flex: 1,
                                  child: Text(
                                      '- ${preventiveCount[0]['PPMAchieved']}%',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                        color: trending26,
                                      )),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
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

  Widget ppmCompletionChart() {
    return Card(
      shape: cardBorder == 7
          ? RoundedRectangleBorder(
              side: const BorderSide(color: secondaryColor, width: 2.0),
              borderRadius: BorderRadius.circular(15),
            )
          : RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
      color: white,
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
                    child: Text(' PPM Completion Against Man Hour',
                        style: cartHeaderStyle),
                  ),
                  Icon(Icons.mail, color: secondaryColor),
                ],
              ),
            ),
            SizedBox(
              height: 220,
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: SfCartesianChart(
                        plotAreaBorderWidth: 0,
                        tooltipBehavior: TooltipBehavior(
                          enable: true,
                          tooltipPosition: TooltipPosition.pointer,
                        ),
                        legend: Legend(
                            isVisible: false, position: LegendPosition.bottom),
                        primaryXAxis: CategoryAxis(
                          isVisible: true,
                          majorGridLines:
                              const MajorGridLines(color: Colors.transparent),
                        ),
                        primaryYAxis: CategoryAxis(
                            isVisible: false, minimum: 0, interval: 2),
                        series: <ChartSeries>[
                          ColumnSeries<dynamic, String>(
                              dataLabelSettings: const DataLabelSettings(
                                  isVisible: true,
                                  color: Colors.black87,
                                  opacity: 0.8,
                                  labelAlignment:
                                      ChartDataLabelAlignment.outer),
                              borderRadius: BorderRadius.circular(4),
                              gradient: const LinearGradient(
                                  colors: GradientColors.greatWhale),
                              dataSource: preventiveCount,
                              xValueMapper: (dynamic data, _) =>
                                  'WithIn SLA Duration Time',
                              yValueMapper: (dynamic data, _) => int.parse(
                                  '${preventiveCount[0]['PPMOnTime']}')),
                          ColumnSeries<dynamic, String>(
                              dataLabelSettings: const DataLabelSettings(
                                  isVisible: true,
                                  color: Colors.black87,
                                  opacity: 0.8,
                                  labelAlignment:
                                      ChartDataLabelAlignment.outer),
                              borderRadius: BorderRadius.circular(4),
                              color: trending2,
                              dataSource: preventiveCount,
                              xValueMapper: (dynamic data, _) =>
                                  'WithOut SLA Duration Time',
                              yValueMapper: (dynamic data, _) => int.parse(
                                  '${preventiveCount[0]['PPMNotOnTime']}')),
                        ]),
                  ),
                  Flexible(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Flexible(
                                  flex: 1,
                                  child: Text('Total',
                                      overflow: TextOverflow.clip,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 9,
                                        color: cardText,
                                      )),
                                ),
                                Flexible(
                                  flex: 1,
                                  child:
                                      Text('- ${preventiveCount[0]['PPMTot']}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                            color: trending26,
                                          )),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Flexible(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Flexible(
                                  flex: 1,
                                  child: Text('Closed',
                                      overflow: TextOverflow.clip,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 9,
                                        color: cardText,
                                      )),
                                ),
                                Flexible(
                                  flex: 1,
                                  child: Text(
                                      '- ${preventiveCount[0]['PPMClosed']}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                        color: trending26,
                                      )),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Flexible(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Flexible(
                                  flex: 1,
                                  child: Text('Compliance',
                                      overflow: TextOverflow.clip,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 9,
                                        color: cardText,
                                      )),
                                ),
                                Flexible(
                                  flex: 1,
                                  child:
                                      Text('- ${preventiveCount[0]['PPMPrc']}%',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                            color: trending26,
                                          )),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
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

  Widget breakdownChart1() {
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        color: white,
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
                      child: Text(' BreakDown Maintenance',
                          style: cartHeaderStyle),
                    ),
                    Icon(Icons.mail, color: secondaryColor),
                  ],
                ),
              ),
              SizedBox(
                height: 250,
                child: SfCartesianChart(
                    plotAreaBorderWidth: 0,
                    tooltipBehavior: TooltipBehavior(
                      enable: true,
                      tooltipPosition: TooltipPosition.pointer,
                    ),
                    legend: Legend(
                        isVisible: false, position: LegendPosition.bottom),
                    primaryXAxis: CategoryAxis(
                      isVisible: true,
                      majorGridLines:
                          const MajorGridLines(color: Colors.transparent),
                    ),
                    primaryYAxis:
                        CategoryAxis(isVisible: false, minimum: 0, interval: 2),
                    series: <ChartSeries>[
                      ColumnSeries<VwDKPIMonthDetCharts, String>(
                          dataLabelSettings: const DataLabelSettings(
                              isVisible: true,
                              color: Colors.black87,
                              opacity: 0.8,
                              labelAlignment: ChartDataLabelAlignment.outer),
                          borderRadius: BorderRadius.circular(4),
                          gradient: const LinearGradient(
                              colors: GradientColors.greatWhale),
                          dataSource: breakdownCount.sublist(0, 1),
                          xValueMapper: (VwDKPIMonthDetCharts data, _) => 'PPM',
                          yValueMapper: (VwDKPIMonthDetCharts data, _) =>
                              int.parse('${data.totPPMByDt}')),
                      ColumnSeries<VwDKPIMonthDetCharts, String>(
                          dataLabelSettings: const DataLabelSettings(
                              isVisible: true,
                              color: Colors.black87,
                              opacity: 0.8,
                              labelAlignment: ChartDataLabelAlignment.outer),
                          borderRadius: BorderRadius.circular(4),
                          color: trending2,
                          dataSource: breakdownCount.sublist(0, 1),
                          xValueMapper: (VwDKPIMonthDetCharts data, _) => 'BDM',
                          yValueMapper: (VwDKPIMonthDetCharts data, _) =>
                              int.parse('${data.totBDMByDt}')),
                    ]),
              ),
            ],
          ),
        ));
  }

  Widget breakdownChart() {
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        color: white,
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
                      child: Text(' BreakDown Maintenance',
                          style: cartHeaderStyle),
                    ),
                    Icon(Icons.mail, color: secondaryColor),
                  ],
                ),
              ),
              SizedBox(
                height: 250,
                child: SfCartesianChart(
                    plotAreaBorderWidth: 0,
                    tooltipBehavior: TooltipBehavior(
                        tooltipPosition: TooltipPosition.pointer, enable: true),
                    legend:
                        Legend(isVisible: true, position: LegendPosition.top),
                    primaryXAxis: CategoryAxis(
                      majorGridLines:
                          const MajorGridLines(color: Colors.transparent),
                      isVisible: true,
                      // minimum: 0,
                      interval: 1,
                    ),
                    primaryYAxis: NumericAxis(
                        isVisible: false, minimum: 0, interval: 0.5),
                    trackballBehavior: TrackballBehavior(
                      enable: true,
                      markerSettings: TrackballMarkerSettings(
                        markerVisibility: showMarker
                            ? TrackballVisibilityMode.visible
                            : TrackballVisibilityMode.hidden,
                        height: 10,
                        width: 10,
                        borderWidth: 1,
                      ),
                      hideDelay: duration * 1000,
                      activationMode: ActivationMode.singleTap,
                      tooltipDisplayMode: _mode,
                      tooltipSettings: InteractiveTooltip(
                          connectorLineColor: Colors.black87,
                          textStyle: const TextStyle(
                              fontSize: 8,
                              color: Colors.black87,
                              fontWeight: FontWeight.w600),
                          color: Colors.grey.shade100,
                          format: _mode != TrackballDisplayMode.groupAllPoints
                              ? 'series.name : point.y'
                              : null,
                          canShowMarker: canShowMarker),
                    ),
                    series: <ChartSeries>[
                      SplineSeries<VwDKPIMonthDetCharts, String>(
                        dataLabelSettings: const DataLabelSettings(
                            labelAlignment: ChartDataLabelAlignment.middle,
                            color: Colors.transparent,
                            textStyle: TextStyle(color: Colors.black),
                            isVisible: false),
                        dataSource: breakdownCount,
                        name: 'PPM',
                        opacity: 0.9,
                        dataLabelMapper: (VwDKPIMonthDetCharts data, _) =>
                            data.dt,
                        xValueMapper: (VwDKPIMonthDetCharts data, _) => data.dt,
                        yValueMapper: (VwDKPIMonthDetCharts data, _) =>
                            int.parse('${data.totalPPMWos}'),
                        color: red,
                        // color: const Color.fromRGBO(255, 225, 121, 1),
                        // gradient: const LinearGradient(
                        //     colors: GradientColors.orangePink),
                      ),
                      SplineSeries<VwDKPIMonthDetCharts, String>(
                        dataLabelSettings: const DataLabelSettings(
                            labelAlignment: ChartDataLabelAlignment.middle,
                            color: Colors.transparent,
                            textStyle: TextStyle(color: Colors.black),
                            isVisible: false),
                        color: trending7,
                        dataLabelMapper: (VwDKPIMonthDetCharts data, _) =>
                            data.dt,
                        dataSource: breakdownCount,
                        xValueMapper: (VwDKPIMonthDetCharts data, _) => data.dt,
                        yValueMapper: (VwDKPIMonthDetCharts data, _) =>
                            int.parse('${data.totalBDMWos}'),
                        name: 'BDM',
                        opacity: 0.7,
                        // gradient: const LinearGradient(
                        //     colors: GradientColors.juicyOrange),
                      )
                    ]),
              ),
            ],
          ),
        ));
  }

  Widget assetsChart() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: white,
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
                    child: Text(' Assets', style: cartHeaderStyle),
                  ),
                  Icon(Icons.mail, color: secondaryColor),
                ],
              ),
            ),
            SizedBox(
              height: 220,
              child: Column(
                children: [
                  Expanded(
                    flex: 2,
                    child: Row(
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
                              color: white,
                              elevation: 4,
                              shadowColor:
                                  Colors.grey.shade100.withOpacity(0.7),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Align(
                                      alignment: Alignment.topLeft,
                                      child: Text('Total Assets',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                            color: cardText,
                                          )),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child:
                                          Text('${assetCount[0]['AssetTot']}',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 32,
                                                color: trending5,
                                              )),
                                    ),
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
                              color: white,
                              elevation: 4,
                              shadowColor:
                                  Colors.grey.shade100.withOpacity(0.7),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Align(
                                      alignment: Alignment.topLeft,
                                      child: Text('Major Assets',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                            color: cardText,
                                          )),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: Text(
                                          '${assetCount[0]['MajorAssetCnt']}',
                                          style: const TextStyle(
                                              fontSize: 32,
                                              color: trending4,
                                              fontWeight: FontWeight.w500)),
                                    ),
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
                              color: white,
                              elevation: 4,
                              shadowColor:
                                  Colors.grey.shade100.withOpacity(0.7),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Align(
                                      alignment: Alignment.topLeft,
                                      child: Text('Condition Good',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                            color: cardText,
                                          )),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child:
                                          Text('${assetCount[0]['AssetGood']}',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 32,
                                                color: trending5,
                                              )),
                                    ),
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
                              color: white,
                              elevation: 4,
                              shadowColor:
                                  Colors.grey.shade100.withOpacity(0.7),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Align(
                                      alignment: Alignment.topLeft,
                                      child: Text('Condition Bad',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                            color: cardText,
                                          )),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: Text(
                                          '${assetCount[0]['AssetBad']}',
                                          style: const TextStyle(
                                              fontSize: 32,
                                              color: trending4,
                                              fontWeight: FontWeight.w500)),
                                    ),
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
                              color: white,
                              elevation: 4,
                              shadowColor:
                                  Colors.grey.shade100.withOpacity(0.7),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Align(
                                      alignment: Alignment.topLeft,
                                      child: Text('Status Online',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                            color: cardText,
                                          )),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: Text(
                                          '${assetCount[0]['AssetOnline']}',
                                          style: const TextStyle(
                                              fontSize: 32,
                                              color: trending4,
                                              fontWeight: FontWeight.w500)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Row(
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
                              color: white,
                              elevation: 4,
                              shadowColor:
                                  Colors.grey.shade100.withOpacity(0.7),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Align(
                                      alignment: Alignment.topLeft,
                                      child: Text('Status Offline',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: cardText,
                                          )),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: Text(
                                          '${assetCount[0]['AssetOffline']}',
                                          style: const TextStyle(
                                              fontSize: 32,
                                              color: cardText2,
                                              fontWeight: FontWeight.w600)),
                                    ),
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
                              color: white,
                              elevation: 4,
                              shadowColor:
                                  Colors.grey.shade100.withOpacity(0.7),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Align(
                                      alignment: Alignment.topLeft,
                                      child: Text('Currently Under BDM',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: cardText,
                                          )),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child:
                                          Text('${assetCount[0]['CBDAsset']}',
                                              style: const TextStyle(
                                                fontSize: 32,
                                                fontWeight: FontWeight.w600,
                                                color: red,
                                              )),
                                    ),
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
                              color: white,
                              elevation: 4,
                              shadowColor:
                                  Colors.grey.shade100.withOpacity(0.7),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Align(
                                      alignment: Alignment.topLeft,
                                      child: Text('BDM More Than Twice',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: cardText,
                                          )),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: Text(
                                          '${assetCount[0]['CBDAsset2']}',
                                          style: const TextStyle(
                                              fontSize: 32,
                                              color: cardText2,
                                              fontWeight: FontWeight.w600)),
                                    ),
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
                              color: white,
                              elevation: 4,
                              shadowColor:
                                  Colors.grey.shade100.withOpacity(0.7),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Align(
                                      alignment: Alignment.topLeft,
                                      child: Text('Defect Asset',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: cardText,
                                          )),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child:
                                          Text('${assetCount[0]['DefAsset']}',
                                              style: const TextStyle(
                                                fontSize: 32,
                                                fontWeight: FontWeight.w600,
                                                color: red,
                                              )),
                                    ),
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
                              color: white,
                              elevation: 4,
                              shadowColor:
                                  Colors.grey.shade100.withOpacity(0.7),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Align(
                                      alignment: Alignment.topLeft,
                                      child: Text('Critical Asset',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: cardText,
                                          )),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child:
                                          Text('${assetCount[0]['Critical']}',
                                              style: const TextStyle(
                                                fontSize: 32,
                                                fontWeight: FontWeight.w600,
                                                color: red,
                                              )),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
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
}

class VwDKPIMonthDetCharts {
  Null? frmdate;
  Null? todate;
  String? woDate;
  String? dt;
  String? totalPPMWos;
  String? totalPPMClsWos;
  String? depManHours;
  String? reqPPMManHours;
  String? utilPPMManHours;
  String? totalBDMWos;
  String? totalBDMClsWos;
  String? reqBDMManHours;
  String? utilBDMManHours;
  String? totPPMByDt;
  String? totBDMByDt;
  String? totPPMByDtPerc;
  String? totBDMByDtPerc;

  VwDKPIMonthDetCharts(
      {this.frmdate,
      this.todate,
      this.woDate,
      this.dt,
      this.totalPPMWos,
      this.totalPPMClsWos,
      this.depManHours,
      this.reqPPMManHours,
      this.utilPPMManHours,
      this.totalBDMWos,
      this.totalBDMClsWos,
      this.reqBDMManHours,
      this.utilBDMManHours,
      this.totPPMByDt,
      this.totBDMByDt,
      this.totPPMByDtPerc,
      this.totBDMByDtPerc});

  VwDKPIMonthDetCharts.fromJson(Map<String, dynamic> json) {
    frmdate = json['Frmdate'];
    todate = json['Todate'];
    woDate = json['WoDate'];
    dt = json['dt'];
    totalPPMWos = json['TotalPPMWos'];
    totalPPMClsWos = json['TotalPPMClsWos'];
    depManHours = json['DepManHours'];
    reqPPMManHours = json['ReqPPMManHours'];
    utilPPMManHours = json['UtilPPMManHours'];
    totalBDMWos = json['TotalBDMWos'];
    totalBDMClsWos = json['TotalBDMClsWos'];
    reqBDMManHours = json['ReqBDMManHours'];
    utilBDMManHours = json['UtilBDMManHours'];
    totPPMByDt = json['TotPPMByDt'];
    totBDMByDt = json['TotBDMByDt'];
    totPPMByDtPerc = json['TotPPMByDtPerc'];
    totBDMByDtPerc = json['TotBDMByDtPerc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Frmdate'] = frmdate;
    data['Todate'] = todate;
    data['WoDate'] = woDate;
    data['dt'] = dt;
    data['TotalPPMWos'] = totalPPMWos;
    data['TotalPPMClsWos'] = totalPPMClsWos;
    data['DepManHours'] = depManHours;
    data['ReqPPMManHours'] = reqPPMManHours;
    data['UtilPPMManHours'] = utilPPMManHours;
    data['TotalBDMWos'] = totalBDMWos;
    data['TotalBDMClsWos'] = totalBDMClsWos;
    data['ReqBDMManHours'] = reqBDMManHours;
    data['UtilBDMManHours'] = utilBDMManHours;
    data['TotPPMByDt'] = totPPMByDt;
    data['TotBDMByDt'] = totBDMByDt;
    data['TotPPMByDtPerc'] = totPPMByDtPerc;
    data['TotBDMByDtPerc'] = totBDMByDtPerc;
    return data;
  }
}
