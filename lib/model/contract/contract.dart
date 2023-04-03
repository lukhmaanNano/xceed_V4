import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_gradient_colors/flutter_gradient_colors.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:http/http.dart' as http;
import '../../Config.dart';
import '../../Styles/CommonColor.dart';
import '../../Styles/CommonTextStyle.dart';
import '../../Styles/responsive.dart';
import '../../Widgets/mobile/shimmer.dart';
import '../../Widgets/web/contract/contractCardView.dart';
import '../../Widgets/web/contract/contractListView.dart';
import '../../Widgets/web/shimmer.dart';

class Contract extends StatefulWidget {
  bool? sideNav, singCardView, detailBackMenu;
  String? pageName;
  final dynamic getFunc;
  Contract(
      {Key? key,
      this.sideNav,
      this.singCardView,
      this.getFunc,
      this.detailBackMenu,
      this.pageName})
      : super(key: key);

  @override
  State<Contract> createState() => _ContractState();
}

class _ContractState extends State<Contract> {
  final Duration delayed = const Duration(milliseconds: 300);
  bool menuState = true, timer = true, listCard = true;
  int tab = 0;
  String? userName, currentDate, startDate, day = 'Today', pageName;
  int? sessionId, barSeriesId, cardBorder = 0;
  var ComplaintIDPK, containerIndex;
  List<dynamic> displayChart = [];
  List<dynamic> contractCount = [], statusCount = [];
  List<VwDConContractMonthStatus> contractMonthData = [];
  List<VwDConContractType> contractTypeCount = [];
  List<VwDConContractType> contractCategoryCount = [];
  List<VwDConContractPopUpGrdDet> chartDataTable = [];
  var tappedValue, tableName;

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
    contractCountApi();
    contractMonthWiseApi();
    contractTypeApi();
    contractCategoryApi();
  }

  Future<void> local() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('UserName');
      sessionId = prefs.getInt('SessionId')!;
    });
  }

  Future<void> contractCountApi() async {
    String? ip = '/VwDConContractStatus/';
    const service = ApiConfig.service;
    final url = Uri.parse('$service$ip');
    final headers = {
      'Accept': 'application/json'
      // 'Content-Type': 'application/json'
    };
    const json =
        '{"data":{"CountryID_varchar":0,"CustomerID_varchar":0,"ContractID_varchar":0,"LocationGroupID_varchar":0,"LocalityID_varchar":0,"BuildingID_varchar":0,"CityID_varchar":0,"FloorID_varchar":0,"SpotID_varchar":0,"DivisionID_varchar":0,"DisciplineID_varchar":0,"ServiceTypeID_varchar":0,"FromDate_datetime":"2023-02-04","ToDate_datetime":"2023-03-06","LocUserID_int":"6","PortalUserID_bit":0}}';
    final response =
        await http.post(url, headers: headers, body: json.toString());
    if (response.statusCode == 400) {
      String err = 'something went wrong!';
    } else {
      final String jsonString = jsonEncode(response.body);
      var decodedJson = jsonDecode(jsonString);
      Map<String, dynamic> map = jsonDecode(decodedJson);
      var result = map['VwDConContractStatus']['countstatus'];
      var result1 = map['VwDConContractStatus']['Chartstatus'];
      setState(() {
        contractCount = result;
        statusCount = result1;
      });
      timerFunction();
    }
  }

  Future<void> contractMonthWiseApi() async {
    String? ip = '/VwDConContractMonthStatus/';
    const service = ApiConfig.service;
    final url = Uri.parse('$service$ip');
    final headers = {'Accept': 'application/json'};
    const json =
        '{"data":{"CountryID_varchar":0,"CustomerID_varchar":0,"ContractID_varchar":0,"LocationGroupID_varchar":0,"LocalityID_varchar":0,"BuildingID_varchar":0,"CityID_varchar":0,"FloorID_varchar":0,"SpotID_varchar":0,"DivisionID_varchar":0,"DisciplineID_varchar":0,"ServiceTypeID_varchar":0,"FromDate_datetime":"2023-02-04","ToDate_datetime":"2023-03-06","LocUserID_int":"6","PortalUserID_bit":0}}';
    final response =
        await http.post(url, headers: headers, body: json.toString());
    if (response.statusCode == 400) {
      String err = 'something went wrong!';
    } else {
      final String jsonString = jsonEncode(response.body);
      var decodedJson = jsonDecode(jsonString);
      Map<String, dynamic> map = jsonDecode(decodedJson);
      var result = map['VwDConContractMonthStatus'];
      for (Map<String, dynamic> i in result) {
        contractMonthData.add(VwDConContractMonthStatus.fromJson(i));
      }
      timerFunction();
    }
  }

  Future<void> contractTypeApi() async {
    String? ip = '/VwDConContractType/';
    const service = ApiConfig.service;
    final url = Uri.parse('$service$ip');
    final headers = {'Accept': 'application/json'};
    const json =
        '{"data":{"CountryID_varchar":0,"CustomerID_varchar":0,"ContractID_varchar":0,"LocationGroupID_varchar":0,"LocalityID_varchar":0,"BuildingID_varchar":0,"CityID_varchar":0,"FloorID_varchar":0,"SpotID_varchar":0,"DivisionID_varchar":0,"DisciplineID_varchar":0,"ServiceTypeID_varchar":0,"FromDate_datetime":"2023-02-04","ToDate_datetime":"2023-03-06","LocUserID_int":"6","PortalUserID_bit":0}}';
    final response =
        await http.post(url, headers: headers, body: json.toString());
    if (response.statusCode == 400) {
      String err = 'something went wrong!';
    } else {
      final String jsonString = jsonEncode(response.body);
      var decodedJson = jsonDecode(jsonString);
      Map<String, dynamic> map = jsonDecode(decodedJson);
      var result = map['VwDConContractType'];
      for (Map<String, dynamic> i in result) {
        contractTypeCount.add(VwDConContractType.fromJson(i));
      }
      timerFunction();
    }
  }

  Future<void> contractCategoryApi() async {
    String? ip = '/VwDConContractCategory/';
    const service = ApiConfig.service;
    final url = Uri.parse('$service$ip');
    final headers = {'Accept': 'application/json'};
    const json =
        '{"data":{"CountryID_varchar":0,"CustomerID_varchar":0,"ContractID_varchar":0,"LocationGroupID_varchar":0,"LocalityID_varchar":0,"BuildingID_varchar":0,"CityID_varchar":0,"FloorID_varchar":0,"SpotID_varchar":0,"DivisionID_varchar":0,"DisciplineID_varchar":0,"ServiceTypeID_varchar":0,"FromDate_datetime":"2023-02-04","ToDate_datetime":"2023-03-06","LocUserID_int":"6","PortalUserID_bit":0}}';
    final response =
        await http.post(url, headers: headers, body: json.toString());
    if (response.statusCode == 400) {
      String err = 'something went wrong!';
    } else {
      final String jsonString = jsonEncode(response.body);
      var decodedJson = jsonDecode(jsonString);
      Map<String, dynamic> map = jsonDecode(decodedJson);
      var result = map['VwDConContractCategory'];
      for (Map<String, dynamic> i in result) {
        contractCategoryCount.add(VwDConContractType.fromJson(i));
      }
      timerFunction();
    }
  }

  Future<void> chartTappedDataTable() async {
    cardBorder = 2;
    displayChartWidget();
    setState(() {
      displayChart.insert(0, displayChart.removeAt(1));
    });
    chartDataTable.clear();
    String? ip = '/VwDConContractPopUpGrdDet/';
    const service = ApiConfig.service;
    final url = Uri.parse('$service$ip');
    final headers = {'Accept': 'application/json'};
    final json =
        '{"data":{"CountryID_varchar":0,"CustomerID_varchar":0,"ContractID_varchar":0,"LocationGroupID_varchar":0,"LocalityID_varchar":0,"BuildingID_varchar":0,"CityID_varchar":0,"FloorID_varchar":0,"SpotID_varchar":0,"DivisionID_varchar":0,"DisciplineID_varchar":0,"ServiceTypeID_varchar":0,"FromDate_datetime":"2023-02-04","ToDate_datetime":"2023-03-06","LocUserID_int":"6","PortalUserID_bit":0,"HeaderID_int":5,"DataParam_varchar":"","PageIndex_int":1,"PageSize_int":10,"ResultCount_int":$tappedValue}}';
    final response =
        await http.post(url, headers: headers, body: json.toString());
    if (response.statusCode == 400) {
      String err = 'something went wrong!';
    } else {
      final String jsonString = jsonEncode(response.body);
      var decodedJson = jsonDecode(jsonString);
      Map<String, dynamic> map = jsonDecode(decodedJson);
      var result = map['VwDConContractPopUpGrdDet'];
      for (Map<String, dynamic> i in result) {
        chartDataTable.add(VwDConContractPopUpGrdDet.fromJson(i));
      }
      timerFunction();
    }
    setState(() {
      widget.singCardView = true;
      widget.detailBackMenu = true;
      widget.sideNav = false;
      widget.pageName = 'Contract';
    });

    widget.getFunc(
      widget.sideNav,
      widget.detailBackMenu,
      widget.pageName,
    );
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Flexible(
                        flex: 2,
                        child: timer == true
                            ? webShimmer(shimmerHeight)
                            : contractsChart(),
                      ),
                      Flexible(
                        flex: 2,
                        child: timer == true
                            ? webShimmer(shimmerHeight)
                            : statusChart(),
                      ),
                      Flexible(
                        flex: 4,
                        child: timer == true
                            ? webShimmer(shimmerHeight)
                            : contractEntryMonthWiseChart(),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        flex: 2,
                        child: timer == true
                            ? webShimmer(shimmerHeight)
                            : contractTypeChart(),
                      ),
                      Flexible(
                        flex: 2,
                        child: timer == true
                            ? webShimmer(shimmerHeight)
                            : contractCategoryChart(),
                      ),
                      Flexible(
                        flex: 4,
                        child: timer == true
                            ? webShimmer(shimmerHeight)
                            : contractExpiredChart(),
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
      child: ContractListView(
          data: chartDataTable, tappedValue: tappedValue, tableName: tableName),
    );
  }

  Widget cardView() {
    final scaleFactor = MediaQuery.of(context).textScaleFactor;
    return Flexible(
      flex: 2,
      child: ContractCardView(
          data: chartDataTable, tappedValue: tappedValue, tableName: tableName),
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
                            : contractsChart(),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        flex: 2,
                        child: timer == true
                            ? MobileShimmer(shimmerHeight)
                            : statusChart(),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        flex: 2,
                        child: timer == true
                            ? MobileShimmer(shimmerHeight)
                            : contractEntryMonthWiseChart(),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        flex: 2,
                        child: timer == true
                            ? MobileShimmer(shimmerHeight)
                            : contractTypeChart(),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        flex: 2,
                        child: timer == true
                            ? MobileShimmer(shimmerHeight)
                            : contractCategoryChart(),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                          flex: 2,
                          child: timer == true
                              ? MobileShimmer(shimmerHeight)
                              : contractExpiredChart()),
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
                    : contractsChart(),
              )
            ])),
          ]),
        ),
      ),
    );
  }

  Widget contractsChart() {
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
                    child: Text(' Contracts', style: cartHeaderStyle),
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
                              color: buttonForeground,
                              elevation: 2,
                              shadowColor:
                                  Colors.grey.shade100.withOpacity(0.7),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        '${contractCount[0]['TotalContracts']}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 26,
                                          color: trending5,
                                        )),
                                    const Text('Total Contract',
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
                              shadowColor:
                                  Colors.grey.shade100.withOpacity(0.7),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        '${contractCount[0]['TotalCustomers']}',
                                        style: const TextStyle(
                                            fontSize: 26,
                                            color: trending4,
                                            fontWeight: FontWeight.w600)),
                                    const Text('Business Associate',
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
                              color: buttonForeground,
                              elevation: 2,
                              shadowColor:
                                  Colors.grey.shade100.withOpacity(0.7),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('${contractCount[0]['RenewedCnt']}',
                                        style: const TextStyle(
                                            fontSize: 26,
                                            color: cardText2,
                                            fontWeight: FontWeight.w600)),
                                    const Text('Contract Renewed  ',
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
                              shadowColor:
                                  Colors.grey.shade100.withOpacity(0.7),
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
                                    Text('${contractCount[0]['LossCnt']}',
                                        style: const TextStyle(
                                          fontSize: 26,
                                          fontWeight: FontWeight.w600,
                                          color: red,
                                        )),
                                    const Text('Contract Lost',
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
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget statusChart() {
    return Card(
      shape: cardBorder == 2
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
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Flexible(
                      flex: 2, child: Text(' Status', style: cartHeaderStyle)),
                  Icon(Icons.mail, color: secondaryColor),
                ],
              ),
            ),
            SizedBox(
              height: 220,
              child: SfCartesianChart(
                  plotAreaBorderWidth: 0,
                  tooltipBehavior: TooltipBehavior(enable: true),
                  legend: Legend(isVisible: true, position: LegendPosition.top),
                  primaryXAxis: CategoryAxis(
                    isVisible: true,
                  ),
                  primaryYAxis: CategoryAxis(
                    isVisible: false,
                  ),
                  series: <ChartSeries>[
                    ColumnSeries<dynamic, String>(
                      onPointTap: (pointInteractionDetails) {
                        var val;
                        val = pointInteractionDetails
                            .dataPoints![pointInteractionDetails.pointIndex!].x;
                        setState(() {
                          tableName = 'Status -Expired';
                          tappedValue = statusCount[0]['ExpiredCnt'];
                        });
                        chartTappedDataTable();
                      },
                      name: 'Expired',
                      dataSource: statusCount,
                      xValueMapper: (dynamic data, _) => 'Expired',
                      yValueMapper: (dynamic data, _) =>
                          statusCount[0]['ExpiredCnt'],
                      trackColor: Colors.transparent,

                      // color: positiveText,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                      gradient: const LinearGradient(
                          colors: GradientColors.plumPlate),
                      dataLabelSettings: const DataLabelSettings(
                          isVisible: true,
                          color: Colors.black,
                          opacity: 0.8,
                          labelAlignment: ChartDataLabelAlignment.outer),
                    ),
                    ColumnSeries<dynamic, String>(
                      onPointTap: (pointInteractionDetails) {
                        var val;
                        val = pointInteractionDetails
                            .dataPoints![pointInteractionDetails.pointIndex!].x;
                        setState(() {
                          tableName = 'Status -Live';
                          tappedValue = statusCount[0]['LiveCnt'];
                        });
                        chartTappedDataTable();
                      },
                      name: 'Live',
                      dataSource: statusCount,
                      xValueMapper: (dynamic data, _) => 'Live',
                      yValueMapper: (dynamic data, _) =>
                          statusCount[0]['LiveCnt'],
                      trackColor: Colors.transparent,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                      gradient: const LinearGradient(
                          colors: GradientColors.happyMemories),
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

  Widget contractEntryMonthWiseChart() {
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
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Flexible(
                      flex: 2,
                      child: Text(' New Contract Entry- Month Wise',
                          style: cartHeaderStyle)),
                  Icon(Icons.mail, color: secondaryColor),
                ],
              ),
            ),
            SizedBox(
              height: 220,
              child: SfCartesianChart(
                  plotAreaBorderWidth: 0,
                  tooltipBehavior: TooltipBehavior(enable: true),
                  legend: Legend(isVisible: true, position: LegendPosition.top),
                  primaryXAxis: CategoryAxis(
                    isInversed: true,
                    interval: 0.8,
                    isVisible: true,
                  ),
                  primaryYAxis: CategoryAxis(
                    isVisible: false,
                  ),
                  series: <ChartSeries>[
                    ColumnSeries<VwDConContractMonthStatus, String>(
                      // onPointTap: (pointInteractionDetails) {
                      //   tappedValue = pointInteractionDetails
                      //       .dataPoints![pointInteractionDetails.pointIndex!].x;
                      //   setState(() {
                      //     tableName = 'By Division';
                      //   });
                      //   chartTappedDataTable(tappedValue);
                      // },
                      name: 'Showing records for last 12 months',
                      dataSource: contractMonthData.sublist(0, 12),
                      xValueMapper: (VwDConContractMonthStatus data, _) =>
                          data.monthNames,
                      yValueMapper: (VwDConContractMonthStatus data, _) =>
                          int.parse('${data.totalCnt}'),
                      trackColor: Colors.transparent,

                      // color: positiveText,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10)),
                      gradient: const LinearGradient(
                          colors: GradientColors.teenNotebook),
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

  Widget contractTypeChart() {
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
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Flexible(
                      flex: 2,
                      child: Text(' Contract Type', style: cartHeaderStyle)),
                  Icon(Icons.mail, color: secondaryColor),
                ],
              ),
            ),
            SizedBox(
              height: 220,
              child: SfCircularChart(
                  palette: const <Color>[
                    trending1,
                    trending20,
                    trending3,
                    trending19,
                    trending8,
                    trending17,
                  ],
                  tooltipBehavior: TooltipBehavior(enable: true),
                  legend: Legend(isVisible: true, position: LegendPosition.top),
                  series: <CircularSeries>[
                    PieSeries<VwDConContractType, String>(
                        explode: true,
                        dataLabelSettings: const DataLabelSettings(
                            isVisible: true,
                            color: grey1,
                            opacity: 0.8,
                            labelAlignment: ChartDataLabelAlignment.middle),
                        dataSource: contractTypeCount,
                        xValueMapper: (VwDConContractType data, _) =>
                            data.label,
                        yValueMapper: (VwDConContractType data, _) => data.y),
                  ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget contractCategoryChart() {
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
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Flexible(
                      flex: 2,
                      child:
                          Text(' Contract Category', style: cartHeaderStyle)),
                  Icon(Icons.mail, color: secondaryColor),
                ],
              ),
            ),
            SizedBox(
              height: 220,
              child: SfCircularChart(
                  palette: const <Color>[
                    trending1,
                    trending2,
                    trending20,
                    trending19,
                    trending8,
                    trending17,
                  ],
                  tooltipBehavior: TooltipBehavior(enable: true),
                  legend: Legend(isVisible: true, position: LegendPosition.top),
                  series: <CircularSeries>[
                    PieSeries<VwDConContractType, String>(
                        explode: true,
                        dataLabelSettings: const DataLabelSettings(
                            isVisible: true,
                            color: grey1,
                            opacity: 0.8,
                            labelAlignment: ChartDataLabelAlignment.middle),
                        dataSource: contractCategoryCount,
                        xValueMapper: (VwDConContractType data, _) =>
                            data.label,
                        yValueMapper: (VwDConContractType data, _) => data.y),
                  ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget contractExpiredChart() {
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
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Flexible(
                      flex: 2,
                      child: Text(' Contracts to be Expired',
                          style: cartHeaderStyle)),
                  Icon(Icons.mail, color: secondaryColor),
                ],
              ),
            ),
            SizedBox(
              height: 220,
              child: SfCartesianChart(
                  plotAreaBorderWidth: 0,
                  tooltipBehavior: TooltipBehavior(enable: true),
                  legend: Legend(isVisible: true, position: LegendPosition.top),
                  primaryXAxis: CategoryAxis(
                    // isInversed: true,
                    interval: 2.0,
                    isVisible: true,
                  ),
                  primaryYAxis: CategoryAxis(
                    isVisible: false,
                  ),
                  series: <ChartSeries>[
                    ColumnSeries<VwDConContractMonthStatus, String>(
                      // onPointTap: (pointInteractionDetails) {
                      //   tappedValue = pointInteractionDetails
                      //       .dataPoints![pointInteractionDetails.pointIndex!].x;
                      //   setState(() {
                      //     tableName = 'By Division';
                      //   });
                      //   chartTappedDataTable(tappedValue);
                      // },
                      name: 'Showing records for Next 6 months',
                      dataSource: contractMonthData.sublist(
                          contractMonthData.length - 6,
                          contractMonthData.length),
                      xValueMapper: (VwDConContractMonthStatus data, _) =>
                          data.monthNames,
                      yValueMapper: (VwDConContractMonthStatus data, _) =>
                          int.parse('${data.totalCnt}'),
                      trackColor: Colors.transparent,

                      // color: positiveText,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10)),
                      gradient:
                          const LinearGradient(colors: GradientColors.aqua),
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

  List<dynamic> displayChartWidget() {
    return displayChart = [
      {"id": 1, "func": contractsChart()},
      {"id": 2, "func": statusChart()},
      {"id": 3, "func": contractEntryMonthWiseChart()},
      {"id": 4, "func": contractTypeChart()},
      {"id": 5, "func": contractCategoryChart()},
      {"id": 6, "func": contractExpiredChart()}
    ];
  }
}

class VwDConContractMonthStatus {
  String? conMonth;
  String? conYear;
  String? totalCnt;
  String? stat;
  String? monthNames;

  VwDConContractMonthStatus(
      {this.conMonth, this.conYear, this.totalCnt, this.stat, this.monthNames});

  VwDConContractMonthStatus.fromJson(Map<String, dynamic> json) {
    conMonth = json['ConMonth'];
    conYear = json['ConYear'];
    totalCnt = json['TotalCnt'];
    stat = json['Stat'];
    monthNames = json['MonthNames'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ConMonth'] = conMonth;
    data['ConYear'] = conYear;
    data['TotalCnt'] = totalCnt;
    data['Stat'] = stat;
    data['MonthNames'] = monthNames;
    return data;
  }
}

class VwDConContractType {
  String? label;
  int? y;

  VwDConContractType({this.label, this.y});

  VwDConContractType.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    y = json['y'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['label'] = label;
    data['y'] = y;
    return data;
  }
}

class VwDConContractPopUpGrdDet {
  String? contractIDPK;
  String? contractCode;
  String? contractName;
  String? contractTypeName;
  String? classification;
  String? contractor;
  String? businessAssociate;
  String? startDate;
  String? endDate;
  String? annualReviewDate;
  String? stat;
  String? resultCount;

  VwDConContractPopUpGrdDet(
      {this.contractIDPK,
      this.contractCode,
      this.contractName,
      this.contractTypeName,
      this.classification,
      this.contractor,
      this.businessAssociate,
      this.startDate,
      this.endDate,
      this.annualReviewDate,
      this.stat,
      this.resultCount});

  VwDConContractPopUpGrdDet.fromJson(Map<String, dynamic> json) {
    contractIDPK = json['ContractIDPK'];
    contractCode = json['ContractCode'];
    contractName = json['ContractName'];
    contractTypeName = json['ContractTypeName'];
    classification = json['Classification'];
    contractor = json['Contractor'];
    businessAssociate = json['BusinessAssociate'];
    startDate = json['StartDate'];
    endDate = json['EndDate'];
    annualReviewDate = json['AnnualReviewDate'];
    stat = json['Stat'];
    resultCount = json['ResultCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ContractIDPK'] = contractIDPK;
    data['ContractCode'] = contractCode;
    data['ContractName'] = contractName;
    data['ContractTypeName'] = contractTypeName;
    data['Classification'] = classification;
    data['Contractor'] = contractor;
    data['BusinessAssociate'] = businessAssociate;
    data['StartDate'] = startDate;
    data['EndDate'] = endDate;
    data['AnnualReviewDate'] = annualReviewDate;
    data['Stat'] = stat;
    data['ResultCount'] = resultCount;
    return data;
  }
}
