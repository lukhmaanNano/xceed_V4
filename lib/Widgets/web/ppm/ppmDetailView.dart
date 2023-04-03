import 'dart:async';
import 'dart:convert';
import 'package:data_table_2/data_table_2.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '../../../Config.dart';
import '../../../Styles/CommonColor.dart';
import '../../../Styles/CommonTextStyle.dart';
import '../../../Styles/responsive.dart';
import '../../../model/Ppm/ppmStatus.dart';
import '../shimmer.dart';

class PPMDetailView extends StatefulWidget {
  final String tappedValue, name, ComplaintIDPK;
  PPMDetailView(
      {Key? key,
      required this.tappedValue,
      required this.name,
      required this.ComplaintIDPK})
      : super(key: key);

  @override
  State<PPMDetailView> createState() => _PPMDetailViewState();
}

class _PPMDetailViewState extends State<PPMDetailView> {
  String? userName, currentDate, startDate, day = 'Today', pageName;
  bool timer = true, cardView = false;
  var ComplaintIDPK;
  final Duration delayed = const Duration(milliseconds: 100);
  final labels = ["PRIMARY INFO", "TECHNICIAN DETAILS"];
  int initialIndex = 0;
  List<VwDPPMPopUpGrdDet> chartdataTable1 = [];
  List<VwDPPMDetDBoard> cardData = [];
  List<VwDPPMCheckListDBoard> tableData = [];
  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd-MM-yyyy').format(now);
    final initialDate = now.subtract(const Duration(days: 30));
    String startDate = DateFormat('dd-MM-yyyy').format(initialDate);
    setState(() {
      startDate = startDate;
      currentDate = formattedDate;
      // pageName = 'Helpdesk Status';
      ComplaintIDPK = widget.ComplaintIDPK;
    });
    chartTappedDataApi();
    cardApi();
  }

  Future<void> chartTappedDataApi() async {
    String? ip = '/VwDPPMPopUpGrdDet/';
    const service = ApiConfig.service;
    final url = Uri.parse('$service$ip');
    final headers = {'Accept': 'application/json'};
    final json =
        '{"data":{"CountryID_varchar":0,"CustomerID_varchar":0,"ContractID_varchar":0,"LocationGroupID_varchar":0,"LocalityID_varchar":0,"BuildingID_varchar":0,"CityID_varchar":0,"FloorID_varchar":0,"SpotID_varchar":0,"DivisionID_varchar":0,"DisciplineID_varchar":0,"ServiceTypeID_varchar":0,"FromDate_datetime":"2023-01-30","ToDate_datetime":"2023-03-01","LocUserID_int":"6","PortalUserID_bit":0,"HeaderID_int":21,"DataParam_varchar":"${widget.tappedValue}","PageIndex_int":1,"PageSize_int":10,"ResultCount_int":null}}';
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
  }

  Future<void> cardApi() async {
    if (timer == false) {
      setState(() {
        timer = true;
      });
    }
    cardData.clear();
    var id = ComplaintIDPK ?? widget.ComplaintIDPK;
    String? ip = '/VwDPPMDetDBoard/';
    const service = ApiConfig.service;
    final url = Uri.parse('$service$ip');
    final headers = {'Accept': 'application/json'};
    final json = '{"data":{"CreationAssetIDPK_int":"$id"}}';
    final response =
        await http.post(url, headers: headers, body: json.toString());
    if (response.statusCode == 400) {
      String err = 'something went wrong!';
    } else {
      final String jsonString = jsonEncode(response.body);
      var decodedJson = jsonDecode(jsonString);
      Map<String, dynamic> map = jsonDecode(decodedJson);
      var result = map['VwDPPMDetDBoard'];
      for (Map<String, dynamic> i in result) {
        cardData.add(VwDPPMDetDBoard.fromJson(i));
      }
      timerFunction();
      tableApi();
    }
  }

  Future<void> tableApi() async {
    tableData.clear();
    var id = ComplaintIDPK ?? widget.ComplaintIDPK;
    String? ip = '/VwDPPMCheckListDBoard/';
    const service = ApiConfig.service;
    final url = Uri.parse('$service$ip');
    final headers = {
      'Accept': 'application/json'
      // 'Content-Type': 'application/json'
    };
    final json = '{"data":{"CreationAssetIDPK_int":"$id"}}';
    final response =
        await http.post(url, headers: headers, body: json.toString());
    if (response.statusCode == 400) {
      String err = 'something went wrong!';
    } else {
      final String jsonString = jsonEncode(response.body);
      var decodedJson = jsonDecode(jsonString);
      Map<String, dynamic> map = jsonDecode(decodedJson);
      var result = map['VwDPPMCheckListDBoard'];
      for (Map<String, dynamic> i in result) {
        tableData.add(VwDPPMCheckListDBoard.fromJson(i));
      }
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
      mobile: (const Text("Table")),
      desktop: detailView(),
    );
  }

  Widget detailView() {
    final scaleFactor = MediaQuery.of(context).textScaleFactor;
    return Scaffold(
      backgroundColor: primaryColor,
      body: Column(
        children: [
          SizedBox(
            height: 65,
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: formName(),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: headerMenu(),
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            flex: 2,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 1,
                  child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context)
                        .copyWith(scrollbars: false),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: chartdataTable1.isEmpty
                          ? webShimmer(double.infinity)
                          : GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                mainAxisExtent: 180,
                                crossAxisCount: 1,
                              ),
                              shrinkWrap: true,
                              itemCount: chartdataTable1.length,
                              itemBuilder: (Context, index) {
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.24,
                                        child: DelayedDisplay(
                                          delay: delayed,
                                          slidingCurve:
                                              Curves.fastLinearToSlowEaseIn,
                                          child: Scaffold(
                                            backgroundColor: primaryColor,
                                            body: InkWell(
                                              splashColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              onTap: () => {
                                                timerFunction(),
                                                setState(() {
                                                  ComplaintIDPK =
                                                      chartdataTable1[index]
                                                          .creationAssetIDPK
                                                          .toString();
                                                }),
                                                cardApi(),
                                              },
                                              child: timer == true
                                                  ? webShimmer(160)
                                                  : Card(
                                                      elevation: 4,
                                                      shadowColor:
                                                          Colors.black12,
                                                      shape: ComplaintIDPK ==
                                                              chartdataTable1[
                                                                      index]
                                                                  .creationAssetIDPK
                                                          ? RoundedRectangleBorder(
                                                              side: const BorderSide(
                                                                  color:
                                                                      secondaryColor,
                                                                  width: 2.0),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.0),
                                                            )
                                                          : RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.0),
                                                            ),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                              decoration:
                                                                  const BoxDecoration(
                                                                borderRadius: BorderRadius.only(
                                                                    topRight: Radius
                                                                        .circular(
                                                                            10),
                                                                    topLeft: Radius
                                                                        .circular(
                                                                            10)),
                                                                color:
                                                                    buttonForeground,
                                                              ),
                                                              height: 25,
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        6.0),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                      'WorkOrder No :${chartdataTable1[index].workOrder}',
                                                                      style: TextStyle(
                                                                          fontSize: 12 *
                                                                              scaleFactor,
                                                                          overflow: TextOverflow
                                                                              .ellipsis,
                                                                          color:
                                                                              secondaryColor,
                                                                          fontWeight:
                                                                              FontWeight.w600),
                                                                    ),
                                                                    Text(
                                                                      '${chartdataTable1[index].woDate}',
                                                                      style: TextStyle(
                                                                          fontSize: 10 *
                                                                              scaleFactor,
                                                                          overflow: TextOverflow
                                                                              .ellipsis,
                                                                          color:
                                                                              secondaryColor,
                                                                          fontWeight:
                                                                              FontWeight.w600),
                                                                    ),
                                                                  ],
                                                                ),
                                                              )),
                                                          Flexible(
                                                            flex: 2,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Flexible(
                                                                      flex: 1,
                                                                      child:
                                                                          SizedBox(
                                                                        width:
                                                                            100,
                                                                        child:
                                                                            Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: const [
                                                                            Text('Status',
                                                                                textAlign: TextAlign.start,
                                                                                style: cardHeader),
                                                                            Text('Stage Name',
                                                                                textAlign: TextAlign.start,
                                                                                style: cardHeader),
                                                                            Text('Tag No',
                                                                                textAlign: TextAlign.start,
                                                                                style: cardHeader),
                                                                            Text('Equipment Name',
                                                                                textAlign: TextAlign.start,
                                                                                style: cardHeader),
                                                                            Text('Frequency Name',
                                                                                textAlign: TextAlign.start,
                                                                                style: cardHeader),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Flexible(
                                                                      flex: 1,
                                                                      child:
                                                                          SizedBox(
                                                                        width:
                                                                            140,
                                                                        child:
                                                                            Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            chartdataTable1[index].woStatus == null
                                                                                ? const Text(':', style: cardBody)
                                                                                : Text(':${chartdataTable1[index].woStatus}', style: cardBody),
                                                                            chartdataTable1[index].stageName == null
                                                                                ? const Text(':', style: cardBody)
                                                                                : Text(':${chartdataTable1[index].stageName}', style: cardBody),
                                                                            chartdataTable1[index].assetTagNo == null
                                                                                ? const Text(':', style: cardBody)
                                                                                : Text(':${chartdataTable1[index].assetTagNo}', style: cardBody),
                                                                            chartdataTable1[index].equipmentName == null
                                                                                ? const Text(':', style: cardBody)
                                                                                : Text(':${chartdataTable1[index].equipmentName}', style: cardBody),
                                                                            chartdataTable1[index].frequency == null
                                                                                ? const Text(':', style: cardBody)
                                                                                : Text(':${chartdataTable1[index].frequency}', style: cardBody),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ]),
                                                            ),
                                                          ),
                                                        ],
                                                      )),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }),
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
                    child: initialIndex == 0
                        ? webCardComponent()
                        : webCardComponent1()),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget formName() {
    return Row(
      children: [
        IconButton(
          highlightColor: Colors.transparent,
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          icon: const Icon(Icons.arrow_back, color: secondaryColor),
          onPressed: () => {
            {Navigator.pop(context)}
          },
        ),
        const SizedBox(width: 15),
        DefaultTextStyle(
          style: const TextStyle(
              overflow: TextOverflow.ellipsis,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.bold,
              color: secondaryColor,
              fontSize: 17,
              height: 1.0),
          child: Text('${widget.name} - ${widget.tappedValue}'),
        ),
      ],
    );
  }

  Widget headerMenu() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: Colors.white,
      elevation: 4,
      shadowColor: Colors.black12,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 43,
          child: ToggleSwitch(
            cornerRadius: 10.0,
            minWidth: 149.0,
            minHeight: 65.0,
            animate: true,
            animationDuration: 500,
            dividerColor: secondaryColor,
            // doubleTapDisable: true,
            fontSize: 12,
            initialLabelIndex: initialIndex,
            activeBgColor: const [secondaryColor],
            activeFgColor: Colors.white,
            inactiveBgColor: buttonForeground,
            inactiveFgColor: secondaryColor,
            totalSwitches: 2,
            labels: labels,
            onToggle: (index) {
              setState(() {
                initialIndex = index!;
              });

              print(initialIndex);
            },
          ),
        ),
      ),
    );
  }

  Widget webCardComponent() {
    double chartHeight = MediaQuery.of(context).size.height * 0.87;
    return SingleChildScrollView(
      child: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Column(children: [
            SizedBox(
              height: 250,
              child: timer == true
                  ? webShimmer(150)
                  : Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      color: Colors.white,
                      elevation: 3,
                      shadowColor: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 12.0),
                            child:
                                Text('Primary Details', style: cartHeaderStyle),
                          ),
                          Flexible(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 8.0, right: 8.0, bottom: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                    flex: 1,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Flexible(
                                          flex: 1,
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: const [
                                                Text('WorkOrder No',
                                                    style: tableCardTextLeft),
                                                Text('Date',
                                                    style: tableCardTextLeft),
                                                Text('Status',
                                                    style: tableCardTextLeft),
                                                Text('Stage Name',
                                                    style: tableCardTextLeft),
                                                Text('Contract Code',
                                                    style: tableCardTextLeft),
                                                Text('Frequency Name',
                                                    style: tableCardTextLeft),
                                                Text('SLA Duration',
                                                    style: tableCardTextLeft),
                                              ]),
                                        ),
                                        Flexible(
                                          flex: 2,
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    cardData[0].workOrder !=
                                                            null
                                                        ? ':${cardData[0].workOrder}'
                                                        : '',
                                                    style: tableCardTextRight),
                                                Text(
                                                    cardData[0].woDate != null
                                                        ? ':${cardData[0].woDate}'
                                                        : '',
                                                    style: tableCardTextRight),
                                                Text(
                                                    cardData[0].woStatus != null
                                                        ? ':${cardData[0].woStatus}'
                                                        : '',
                                                    style: tableCardTextRight),
                                                Text(
                                                    cardData[0].stageName !=
                                                            null
                                                        ? ':${cardData[0].stageName}'
                                                        : '',
                                                    style: tableCardTextRight),
                                                Text(
                                                    cardData[0].contractCode !=
                                                            null
                                                        ? ':${cardData[0].contractCode}'
                                                        : '',
                                                    style: tableCardTextRight),
                                                Text(
                                                    cardData[0].frequencyName !=
                                                            null
                                                        ? ':${cardData[0].frequencyName}'
                                                        : '',
                                                    style: tableCardTextRight),
                                                Text(
                                                    cardData[0].sLADuration !=
                                                            null
                                                        ? ':${cardData[0].sLADuration}'
                                                        : '',
                                                    style: tableCardTextRight),
                                              ]),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Flexible(
                                          flex: 1,
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: const [
                                                Text('Actual Duration',
                                                    style: tableCardTextLeft),
                                                Text('Contract Name',
                                                    style: tableCardTextLeft),
                                                Text('Completed Date',
                                                    style: tableCardTextLeft),
                                                Text('ClosedVia',
                                                    style: tableCardTextLeft),
                                                Text('OverDue By (Days)',
                                                    style: tableCardTextLeft),
                                              ]),
                                        ),
                                        Flexible(
                                          flex: 2,
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    cardData[0].ageingInDays !=
                                                            null
                                                        ? ':${cardData[0].ageingInDays}'
                                                        : '',
                                                    style: tableCardTextRight),
                                                Text(
                                                    cardData[0].contractName !=
                                                            null
                                                        ? ':${cardData[0].contractName}'
                                                        : '',
                                                    style: tableCardTextRight),
                                                Text(
                                                    cardData[0].completedDate !=
                                                            null
                                                        ? ':${cardData[0].completedDate}'
                                                        : '',
                                                    style: tableCardTextRight),
                                                Text(
                                                    cardData[0].completedVia !=
                                                            null
                                                        ? ':${cardData[0].completedVia}'
                                                        : '',
                                                    style: tableCardTextRight),
                                                Text(
                                                    cardData[0].ageingInDays !=
                                                            null
                                                        ? ':${cardData[0].ageingInDays}'
                                                        : '',
                                                    style: tableCardTextRight),
                                              ]),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
            ),
            SizedBox(
              height: 140,
              child: timer == true
                  ? webShimmer(130)
                  : Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      color: Colors.white,
                      elevation: 3,
                      shadowColor: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 12.0),
                            child: Text('Location Details',
                                style: cartHeaderStyle),
                          ),
                          Flexible(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 8.0, right: 8.0, bottom: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                    flex: 1,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Flexible(
                                            flex: 1,
                                            child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: const [
                                                  Text('Region Name',
                                                      style: tableCardTextLeft),
                                                  Text('Location Name',
                                                      style: tableCardTextLeft),
                                                  Text('Locality Cod',
                                                      style: tableCardTextLeft),
                                                  Text('Wing Name',
                                                      style: tableCardTextLeft),
                                                ]),
                                          ),
                                          Flexible(
                                            flex: 2,
                                            child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      cardData[0].regionName !=
                                                              null
                                                          ? ':${cardData[0].regionName}'
                                                          : '',
                                                      style:
                                                          tableCardTextRight),
                                                  Text(
                                                      cardData[0].localityName !=
                                                              null
                                                          ? ':${cardData[0].localityName}'
                                                          : '',
                                                      style:
                                                          tableCardTextRight),
                                                  Text(
                                                      cardData[0].localityCode !=
                                                              null
                                                          ? ':${cardData[0].localityCode}'
                                                          : '',
                                                      style:
                                                          tableCardTextRight),
                                                ]),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Flexible(
                                          flex: 1,
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: const [
                                                Text('Floor Name',
                                                    style: tableCardTextLeft),
                                                Text('Location Group',
                                                    style: tableCardTextLeft),
                                                Text('Building Name',
                                                    style: tableCardTextLeft),
                                                Text('Spot Name',
                                                    style: tableCardTextLeft),
                                              ]),
                                        ),
                                        Flexible(
                                          flex: 2,
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    cardData[0].floorName !=
                                                            null
                                                        ? ':${cardData[0].floorName}'
                                                        : '',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: tableCardTextRight),
                                                Text(
                                                    cardData[0].groupName !=
                                                            null
                                                        ? ':${cardData[0].groupName}'
                                                        : '',
                                                    style: tableCardTextRight),
                                                Text(
                                                    cardData[0].buildingName !=
                                                            null
                                                        ? ':${cardData[0].buildingName}'
                                                        : '',
                                                    style: tableCardTextRight),
                                                Text(
                                                    cardData[0].spotName != null
                                                        ? ':${cardData[0].spotName}'
                                                        : '',
                                                    style: tableCardTextRight),
                                              ]),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
            ),
            SizedBox(
              height: 210,
              child: timer == true
                  ? webShimmer(130)
                  : Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      color: Colors.white,
                      elevation: 3,
                      shadowColor: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 12.0),
                            child:
                                Text('Asset Details', style: cartHeaderStyle),
                          ),
                          Flexible(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 8.0, right: 8.0, bottom: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                    flex: 1,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Flexible(
                                            flex: 1,
                                            child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: const [
                                                  Text('AssetTag No',
                                                      style: tableCardTextLeft),
                                                  Text('Barcode',
                                                      style: tableCardTextLeft),
                                                  Text('Asset Name',
                                                      style: tableCardTextLeft),
                                                  Text('EquipmentRef No',
                                                      style: tableCardTextLeft),
                                                  Text('Serial No.',
                                                      style: tableCardTextLeft),
                                                  Text('Tech Specification',
                                                      style: tableCardTextLeft),
                                                ]),
                                          ),
                                          Flexible(
                                            flex: 2,
                                            child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      cardData[0].assetTagNo !=
                                                              null
                                                          ? ':${cardData[0].assetTagNo}'
                                                          : '',
                                                      style:
                                                          tableCardTextRight),
                                                  Text(
                                                      cardData[0].barcode !=
                                                              null
                                                          ? ':${cardData[0].barcode}'
                                                          : '',
                                                      style:
                                                          tableCardTextRight),
                                                  Text(
                                                      cardData[0].assetName !=
                                                              null
                                                          ? ':${cardData[0].assetName}'
                                                          : '',
                                                      style:
                                                          tableCardTextRight),
                                                  Text(
                                                      cardData[0].equipmentRefNo !=
                                                              null
                                                          ? ':${cardData[0].equipmentRefNo}'
                                                          : '',
                                                      style:
                                                          tableCardTextRight),
                                                  Text(
                                                      cardData[0].supEndTime !=
                                                              null
                                                          ? ':${cardData[0].supEndTime}'
                                                          : '',
                                                      style:
                                                          tableCardTextRight),
                                                  Text(
                                                      cardData[0].supRemarks !=
                                                              null
                                                          ? ':${cardData[0].supRemarks}'
                                                          : '',
                                                      style:
                                                          tableCardTextRight),
                                                ]),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Flexible(
                                          flex: 1,
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: const [
                                                Text('Discipline Name',
                                                    style: tableCardTextLeft),
                                                Text('Make',
                                                    style: tableCardTextLeft),
                                                Text('Model',
                                                    style: tableCardTextLeft),
                                                Text('Priority',
                                                    style: tableCardTextLeft),
                                                Text('Service Area ',
                                                    style: tableCardTextLeft),
                                              ]),
                                        ),
                                        Flexible(
                                          flex: 2,
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    cardData[0].disciplineName !=
                                                            null
                                                        ? ':${cardData[0].disciplineName}'
                                                        : '',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: tableCardTextRight),
                                                Text(
                                                    cardData[0].makeName != null
                                                        ? ':${cardData[0].makeName}'
                                                        : '',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: tableCardTextRight),
                                                Text(
                                                    cardData[0].modelName !=
                                                            null
                                                        ? ':${cardData[0].modelName}'
                                                        : '',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: tableCardTextRight),
                                                Text(
                                                    cardData[0].priorityName !=
                                                            null
                                                        ? ':${cardData[0].priorityName}'
                                                        : '',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: tableCardTextRight),
                                                Text(
                                                    cardData[0].serviceArea !=
                                                            null
                                                        ? ':${cardData[0].serviceArea}'
                                                        : '',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: tableCardTextRight),
                                              ]),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
            ),
          ])),
    );
  }

  Widget webCardComponent1() {
    double chartHeight = MediaQuery.of(context).size.height * 0.87;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Column(
          children: [
            SizedBox(
              height: 130,
              child: timer == true
                  ? webShimmer(150)
                  : Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      color: Colors.white,
                      elevation: 3,
                      shadowColor: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 12.0),
                            child: Text('Technician Details',
                                style: cartHeaderStyle),
                          ),
                          Flexible(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 8.0, right: 8.0, bottom: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                    flex: 1,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Flexible(
                                          flex: 1,
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: const [
                                                Text('Technician Name',
                                                    style: tableCardTextLeft),
                                                Text('StartTime',
                                                    style: tableCardTextLeft),
                                                Text('EndTime',
                                                    style: tableCardTextLeft),
                                              ]),
                                        ),
                                        Flexible(
                                          flex: 2,
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    cardData[0].techName != null
                                                        ? ':${cardData[0].techName}'
                                                        : '',
                                                    style: tableCardTextRight),
                                                Text(
                                                    cardData[0].techStartTime !=
                                                            null
                                                        ? ':${cardData[0].techStartTime}'
                                                        : '',
                                                    style: tableCardTextRight),
                                                Text(
                                                    cardData[0].techEndTime !=
                                                            null
                                                        ? ':${cardData[0].techEndTime}'
                                                        : '',
                                                    style: tableCardTextRight),
                                              ]),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Flexible(
                                          flex: 1,
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: const [
                                                Text('TotalTime',
                                                    style: tableCardTextLeft),
                                                Text('Technician Remarks',
                                                    style: tableCardTextLeft),
                                              ]),
                                        ),
                                        Flexible(
                                          flex: 2,
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    cardData[0].techTotalTime !=
                                                            null
                                                        ? ':${cardData[0].techTotalTime}'
                                                        : '',
                                                    style: tableCardTextRight),
                                                Text(
                                                    cardData[0].techRemarks !=
                                                            null
                                                        ? ':${cardData[0].techRemarks}'
                                                        : '',
                                                    style: tableCardTextRight),
                                              ]),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
            SizedBox(
              height: 130,
              child: timer == true
                  ? webShimmer(150)
                  : Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      color: Colors.white,
                      elevation: 3,
                      shadowColor: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 12.0),
                            child: Text('Supervisor Details',
                                style: cartHeaderStyle),
                          ),
                          Flexible(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 8.0, right: 8.0, bottom: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                    flex: 1,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Flexible(
                                          flex: 1,
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: const [
                                                Text('Supervisor Name',
                                                    style: tableCardTextLeft),
                                                Text('StartTime',
                                                    style: tableCardTextLeft),
                                                Text('EndTime',
                                                    style: tableCardTextLeft),
                                              ]),
                                        ),
                                        Flexible(
                                          flex: 2,
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    cardData[0].supervisorName !=
                                                            null
                                                        ? ':${cardData[0].supervisorName}'
                                                        : '',
                                                    style: tableCardTextRight),
                                                Text(
                                                    cardData[0].supStartTime !=
                                                            null
                                                        ? ':${cardData[0].supStartTime}'
                                                        : '',
                                                    style: tableCardTextRight),
                                                Text(
                                                    cardData[0].supEndTime !=
                                                            null
                                                        ? ':${cardData[0].supEndTime}'
                                                        : '',
                                                    style: tableCardTextRight),
                                              ]),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Flexible(
                                          flex: 1,
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: const [
                                                Text('Total Duration',
                                                    style: tableCardTextLeft),
                                                Text('Supervisor Remarks',
                                                    style: tableCardTextLeft),
                                              ]),
                                        ),
                                        Flexible(
                                          flex: 2,
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    cardData[0].supTotalTime !=
                                                            null
                                                        ? ':${cardData[0].supTotalTime}'
                                                        : '',
                                                    style: tableCardTextRight),
                                                Text(
                                                    cardData[0].supRemarks !=
                                                            null
                                                        ? ':${cardData[0].supRemarks}'
                                                        : '',
                                                    style: tableCardTextRight),
                                              ]),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: 130,
                    child: timer == true
                        ? webShimmer(130)
                        : Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            color: Colors.white,
                            elevation: 3,
                            shadowColor: Colors.transparent,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 12.0, horizontal: 12.0),
                                  child: Text('Technician Signature',
                                      style: cartHeaderStyle),
                                ),
                                Flexible(
                                  flex: 2,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 8.0, right: 8.0, bottom: 8.0),
                                    child: SizedBox(),
                                  ),
                                )
                              ],
                            ),
                          ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: 130,
                    child: timer == true
                        ? webShimmer(130)
                        : Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            color: Colors.white,
                            elevation: 3,
                            shadowColor: Colors.transparent,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 12.0, horizontal: 12.0),
                                  child: Text('Supervisor Signature',
                                      style: cartHeaderStyle),
                                ),
                                Flexible(
                                  flex: 2,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 8.0, right: 8.0, bottom: 8.0),
                                    child: SizedBox(),
                                  ),
                                )
                              ],
                            ),
                          ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: 130,
                    child: timer == true
                        ? webShimmer(130)
                        : Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            color: Colors.white,
                            elevation: 3,
                            shadowColor: Colors.transparent,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 12.0, horizontal: 12.0),
                                  child: Text('PPM Image Details',
                                      style: cartHeaderStyle),
                                ),
                                Flexible(
                                  flex: 2,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 8.0, right: 8.0, bottom: 8.0),
                                    child: SizedBox(),
                                  ),
                                )
                              ],
                            ),
                          ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 250,
              child: timer == true
                  ? webShimmer(150)
                  : Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      color: Colors.white,
                      elevation: 3,
                      shadowColor: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 12.0),
                            child: Text('Checkpoints Details',
                                style: cartHeaderStyle),
                          ),
                          Flexible(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 8.0, right: 8.0, bottom: 8.0),
                              child: ClipRRect(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                child: DataTable2(
                                    columnSpacing: 10,
                                    dividerThickness: 0.3,
                                    headingRowHeight: 35,
                                    dataRowHeight: 30,
                                    headingRowColor:
                                        MaterialStateProperty.resolveWith(
                                            (states) => secondaryColor),
                                    decoration: const BoxDecoration(
                                        color: Colors.white),
                                    minWidth: 600,
                                    columns: const [
                                      DataColumn(
                                        label: Text(
                                          'Code',
                                          style: columnStyle,
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'CheckPoints',
                                          style: columnStyle,
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'Value',
                                          style: columnStyle,
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'Tech Status',
                                          style: columnStyle,
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'Tech Remarks',
                                          style: columnStyle,
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'Sup Status',
                                          style: columnStyle,
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'Sup Remarks',
                                          style: columnStyle,
                                        ),
                                      ),
                                    ],
                                    rows: tableData
                                        .map((data) => DataRow(cells: [
                                              DataCell(
                                                Text(
                                                  '${data.checkPointCode ?? data.checkPointCode}',
                                                  style: rowstyle,
                                                  textAlign: TextAlign.start,
                                                ),
                                              ),
                                              DataCell(
                                                Text(
                                                  '${data.checkPointName ?? data.checkPointName}',
                                                  style: rowstyle,
                                                  textAlign: TextAlign.start,
                                                ),
                                              ),
                                              DataCell(
                                                Text(
                                                  '${data.cValue ?? data.cValue}',
                                                  style: rowstyle,
                                                  textAlign: TextAlign.start,
                                                ),
                                              ),
                                              DataCell(
                                                Text(
                                                    '${data.techStat ?? data.techStat}',
                                                    style: rowstyle),
                                              ),
                                              DataCell(
                                                Text(
                                                    '${data.techRemarks ?? data.techRemarks}',
                                                    style: rowstyle),
                                              ),
                                              DataCell(
                                                Text(
                                                    '${data.supStat ?? data.supStat}',
                                                    style: rowstyle),
                                              ),
                                              DataCell(
                                                Text(
                                                    '${data.supRemarks ?? data.supRemarks}',
                                                    style: rowstyle),
                                              ),
                                            ]))
                                        .toList()),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class VwDPPMDetDBoard {
  String? creationAssetIDPK;
  String? workOrder;
  String? woDate;
  String? woStatus;
  String? stageName;
  String? contractCode;
  String? contractName;
  String? frequencyName;
  String? sLADuration;
  String? techTotalTime;
  String? completedDate;
  String? completedVia;
  String? ageingInDays;
  String? regionName;
  String? groupName;
  String? localityCode;
  String? localityName;
  String? buildingName;
  String? floorName;
  String? spotName;
  String? wingName;
  String? assetTagNo;
  String? barcode;
  String? assetName;
  String? equipmentRefNo;
  String? divisionName;
  String? disciplineName;
  String? makeName;
  String? modelName;
  String? priorityName;
  String? serviceArea;
  String? techSpechName;
  String? techName;
  String? techStartTime;
  String? techEndTime;
  String? techRemarks;
  String? supervisorName;
  String? supStartTime;
  String? supEndTime;
  String? supTotalTime;
  String? supRemarks;
  String? formID;
  String? contractID;
  String? localityID;
  String? hierarchyDetailsID;

  VwDPPMDetDBoard(
      {this.creationAssetIDPK,
      this.workOrder,
      this.woDate,
      this.woStatus,
      this.stageName,
      this.contractCode,
      this.contractName,
      this.frequencyName,
      this.sLADuration,
      this.techTotalTime,
      this.completedDate,
      this.completedVia,
      this.ageingInDays,
      this.regionName,
      this.groupName,
      this.localityCode,
      this.localityName,
      this.buildingName,
      this.floorName,
      this.spotName,
      this.wingName,
      this.assetTagNo,
      this.barcode,
      this.assetName,
      this.equipmentRefNo,
      this.divisionName,
      this.disciplineName,
      this.makeName,
      this.modelName,
      this.priorityName,
      this.serviceArea,
      this.techSpechName,
      this.techName,
      this.techStartTime,
      this.techEndTime,
      this.techRemarks,
      this.supervisorName,
      this.supStartTime,
      this.supEndTime,
      this.supTotalTime,
      this.supRemarks,
      this.formID,
      this.contractID,
      this.localityID,
      this.hierarchyDetailsID});

  VwDPPMDetDBoard.fromJson(Map<String, dynamic> json) {
    creationAssetIDPK = json['CreationAssetIDPK'];
    workOrder = json['WorkOrder'];
    woDate = json['WoDate'];
    woStatus = json['WoStatus'];
    stageName = json['StageName'];
    contractCode = json['ContractCode'];
    contractName = json['ContractName'];
    frequencyName = json['FrequencyName'];
    sLADuration = json['SLADuration'];
    techTotalTime = json['TechTotalTime'];
    completedDate = json['CompletedDate'];
    completedVia = json['CompletedVia'];
    ageingInDays = json['AgeingInDays'];
    regionName = json['RegionName'];
    groupName = json['GroupName'];
    localityCode = json['LocalityCode'];
    localityName = json['LocalityName'];
    buildingName = json['BuildingName'];
    floorName = json['FloorName'];
    spotName = json['SpotName'];
    wingName = json['WingName'];
    assetTagNo = json['AssetTagNo'];
    barcode = json['Barcode'];
    assetName = json['AssetName'];
    equipmentRefNo = json['EquipmentRefNo'];
    divisionName = json['DivisionName'];
    disciplineName = json['DisciplineName'];
    makeName = json['MakeName'];
    modelName = json['ModelName'];
    priorityName = json['PriorityName'];
    serviceArea = json['ServiceArea'];
    techSpechName = json['TechSpechName'];
    techName = json['TechName'];
    techStartTime = json['TechStartTime'];
    techEndTime = json['TechEndTime'];
    techRemarks = json['TechRemarks'];
    supervisorName = json['SupervisorName'];
    supStartTime = json['SupStartTime'];
    supEndTime = json['SupEndTime'];
    supTotalTime = json['SupTotalTime'];
    supRemarks = json['SupRemarks'];
    formID = json['FormID'];
    contractID = json['ContractID'];
    localityID = json['LocalityID'];
    hierarchyDetailsID = json['HierarchyDetailsID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['CreationAssetIDPK'] = creationAssetIDPK;
    data['WorkOrder'] = workOrder;
    data['WoDate'] = woDate;
    data['WoStatus'] = woStatus;
    data['StageName'] = stageName;
    data['ContractCode'] = contractCode;
    data['ContractName'] = contractName;
    data['FrequencyName'] = frequencyName;
    data['SLADuration'] = sLADuration;
    data['TechTotalTime'] = techTotalTime;
    data['CompletedDate'] = completedDate;
    data['CompletedVia'] = completedVia;
    data['AgeingInDays'] = ageingInDays;
    data['RegionName'] = regionName;
    data['GroupName'] = groupName;
    data['LocalityCode'] = localityCode;
    data['LocalityName'] = localityName;
    data['BuildingName'] = buildingName;
    data['FloorName'] = floorName;
    data['SpotName'] = spotName;
    data['WingName'] = wingName;
    data['AssetTagNo'] = assetTagNo;
    data['Barcode'] = barcode;
    data['AssetName'] = assetName;
    data['EquipmentRefNo'] = equipmentRefNo;
    data['DivisionName'] = divisionName;
    data['DisciplineName'] = disciplineName;
    data['MakeName'] = makeName;
    data['ModelName'] = modelName;
    data['PriorityName'] = priorityName;
    data['ServiceArea'] = serviceArea;
    data['TechSpechName'] = techSpechName;
    data['TechName'] = techName;
    data['TechStartTime'] = techStartTime;
    data['TechEndTime'] = techEndTime;
    data['TechRemarks'] = techRemarks;
    data['SupervisorName'] = supervisorName;
    data['SupStartTime'] = supStartTime;
    data['SupEndTime'] = supEndTime;
    data['SupTotalTime'] = supTotalTime;
    data['SupRemarks'] = supRemarks;
    data['FormID'] = formID;
    data['ContractID'] = contractID;
    data['LocalityID'] = localityID;
    data['HierarchyDetailsID'] = hierarchyDetailsID;
    return data;
  }
}

class VwDPPMCheckListDBoard {
  String? checkPointCode;
  String? checkPointName;
  String? cValue;
  String? techStat;
  String? techRemarks;
  String? supStat;
  String? supRemarks;

  VwDPPMCheckListDBoard(
      {this.checkPointCode,
      this.checkPointName,
      this.cValue,
      this.techStat,
      this.techRemarks,
      this.supStat,
      this.supRemarks});

  VwDPPMCheckListDBoard.fromJson(Map<String, dynamic> json) {
    checkPointCode = json['CheckPointCode'];
    checkPointName = json['CheckPointName'];
    cValue = json['CValue'];
    techStat = json['TechStat'];
    techRemarks = json['TechRemarks'];
    supStat = json['SupStat'];
    supRemarks = json['SupRemarks'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['CheckPointCode'] = checkPointCode;
    data['CheckPointName'] = checkPointName;
    data['CValue'] = cValue;
    data['TechStat'] = techStat;
    data['TechRemarks'] = techRemarks;
    data['SupStat'] = supStat;
    data['SupRemarks'] = supRemarks;
    return data;
  }
}
