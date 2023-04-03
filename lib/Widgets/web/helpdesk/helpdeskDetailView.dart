import 'dart:async';
import 'dart:convert';
import 'package:delayed_display/delayed_display.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '../../../Config.dart';
import '../../../Styles/CommonColor.dart';
import '../../../Styles/CommonTextStyle.dart';
import '../../../Styles/responsive.dart';
import '../shimmer.dart';

class HelpdeskTable extends StatefulWidget {
  final String tappedValue, name, ComplaintIDPK;

  const HelpdeskTable(
      {Key? key,
      required this.tappedValue,
      required this.name,
      required this.ComplaintIDPK})
      : super(key: key);

  @override
  State<HelpdeskTable> createState() => _HelpdeskTableState();
}

class _HelpdeskTableState extends State<HelpdeskTable> {
  String? userName, currentDate, startDate, day = 'Today', pageName;
  bool timer = true, cardView = false;
  var ComplaintIDPK;
  final Duration delayed = const Duration(milliseconds: 100);
  final labels = ["PRIMARY INFO", "ANALYSIS DETAILS", "EXECUTION DETAILS"];
  int initialIndex = 0;
  List<VwDHDPopUpGrdDet> chartdataTable1 = [];
  List<VwDHelpDeskDetDBoard> cardData = [];
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
      pageName = 'Helpdesk Status';
      ComplaintIDPK = widget.ComplaintIDPK;
    });
    chartTappedDataApi();
    cardApi();
  }

  Future<void> chartTappedDataApi() async {
    String? ip = '/VwDHDPopUpGrdDet/';
    const service = ApiConfig.service;
    final url = Uri.parse('$service$ip');
    final headers = {'Accept': 'application/json'};
    final json =
        '{"data":{"CountryID_varchar":0,"CustomerID_varchar":0,"ContractID_varchar":0,"LocationGroupID_varchar":0,"LocalityID_varchar":0,"BuildingID_varchar":0,"CityID_varchar":0,"FloorID_varchar":0,"SpotID_varchar":0,"DivisionID_varchar":0,"DisciplineID_varchar":0,"ServiceTypeID_varchar":0,"FromDate_datetime":"2022-10-09","ToDate_datetime":"2022-11-08","LocUserID_int":"6","PortalUserID_bit":0,"HeaderID_int":19,"DataParam_varchar":"${widget.tappedValue}","PageIndex_int":1,"PageSize_int":10,"ResultCount_int":null}}';
    final response =
        await http.post(url, headers: headers, body: json.toString());
    if (response.statusCode == 400) {
      String err = 'something went wrong!';
    } else {
      final String jsonString = jsonEncode(response.body);
      var decodedJson = jsonDecode(jsonString);
      Map<String, dynamic> map = jsonDecode(decodedJson);
      var result = map['VwDHDPopUpGrdDet'];
      for (Map<String, dynamic> i in result) {
        chartdataTable1.add(VwDHDPopUpGrdDet.fromJson(i));
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
    String? ip = '/VwDHelpDeskDetDBoard/';
    const service = ApiConfig.service;
    final url = Uri.parse('$service$ip');
    final headers = {'Accept': 'application/json'};
    final json = '{"data":{"ComplaintIDK_int":"$id"}}';
    final response =
        await http.post(url, headers: headers, body: json.toString());
    if (response.statusCode == 400) {
      String err = 'something went wrong!';
    } else {
      final String jsonString = jsonEncode(response.body);
      var decodedJson = jsonDecode(jsonString);
      Map<String, dynamic> map = jsonDecode(decodedJson);
      var result = map['VwDHelpDeskDetDBoard'];
      for (Map<String, dynamic> i in result) {
        cardData.add(VwDHelpDeskDetDBoard.fromJson(i));
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
                                                          .complaintIDPK
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
                                                                  .complaintIDPK
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
                                                                      'Compliant No :${chartdataTable1[index].complaintNo}',
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
                                                                      '${chartdataTable1[index].complainedDate}',
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
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: const [
                                                                          Text(
                                                                              'Reference No',
                                                                              overflow: TextOverflow.ellipsis,
                                                                              textAlign: TextAlign.center,
                                                                              style: cardHeader),
                                                                          Text(
                                                                              'Stage Name',
                                                                              overflow: TextOverflow.ellipsis,
                                                                              textAlign: TextAlign.center,
                                                                              style: cardHeader),
                                                                          Text(
                                                                              'Current Status',
                                                                              overflow: TextOverflow.ellipsis,
                                                                              textAlign: TextAlign.center,
                                                                              style: cardHeader),
                                                                          Text(
                                                                              'Priority',
                                                                              overflow: TextOverflow.ellipsis,
                                                                              textAlign: TextAlign.center,
                                                                              style: cardHeader),
                                                                          Text(
                                                                              'Nature Of Comlaint',
                                                                              overflow: TextOverflow.ellipsis,
                                                                              textAlign: TextAlign.center,
                                                                              style: cardHeader),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Flexible(
                                                                      flex: 1,
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          chartdataTable1[index].cCMStageID == null
                                                                              ? const Text(':', style: cardBody)
                                                                              : Text(':${chartdataTable1[index].cCMStageID}', style: cardBody),
                                                                          chartdataTable1[index].stageName == null
                                                                              ? const Text(':', style: cardBody)
                                                                              : Text(':${chartdataTable1[index].stageName}', style: cardBody),
                                                                          chartdataTable1[index].woStatus == null
                                                                              ? const Text(':', style: cardBody)
                                                                              : Text(':${chartdataTable1[index].woStatus}', style: cardBody),
                                                                          chartdataTable1[index].priorityName == null
                                                                              ? const Text(':', style: cardBody)
                                                                              : Text(':${chartdataTable1[index].priorityName}', style: cardBody),
                                                                          chartdataTable1[index].complaintNatureName == null
                                                                              ? const Text(':', style: cardBody)
                                                                              : Text(':${chartdataTable1[index].complaintNatureName}', style: cardBody),
                                                                        ],
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
                        : initialIndex == 1
                            ? webCardComponent1()
                            : webCardComponent2()),
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
            totalSwitches: 3,
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
                                                Text('Priority',
                                                    style: tableCardTextLeft),
                                                Text('Status',
                                                    style: tableCardTextLeft),
                                                Text('Ageing in Days',
                                                    style: tableCardTextLeft),
                                                Text('Date & Time',
                                                    style: tableCardTextLeft),
                                                Text('Preferred Date & Time',
                                                    style: tableCardTextLeft),
                                                Text('ETA Date & Time',
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
                                                    cardData[0].complaintNo !=
                                                            null
                                                        ? ':${cardData[0].complaintNo}'
                                                        : '',
                                                    style: tableCardTextRight),
                                                Text(
                                                    cardData[0].priorityName !=
                                                            null
                                                        ? ':${cardData[0].priorityName}'
                                                        : '',
                                                    style: tableCardTextRight),
                                                Text(
                                                    cardData[0].stat != null
                                                        ? ':${cardData[0].stat}'
                                                        : '',
                                                    style: tableCardTextRight),
                                                Text(
                                                    cardData[0].ageingInDays !=
                                                            null
                                                        ? ':${cardData[0].ageingInDays}'
                                                        : '',
                                                    style: tableCardTextRight),
                                                Text(
                                                    cardData[0].complainedDate !=
                                                            null
                                                        ? ':${cardData[0].complainedDate}'
                                                        : '',
                                                    style: tableCardTextRight),
                                                Text(
                                                    cardData[0].preferredTime !=
                                                            null
                                                        ? ':${cardData[0].preferredTime}'
                                                        : '',
                                                    style: tableCardTextRight),
                                                Text(
                                                    cardData[0].eTA != null
                                                        ? ':${cardData[0].eTA}'
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
                                                Text('Reference No.',
                                                    style: tableCardTextLeft),
                                                Text('Stage Name',
                                                    style: tableCardTextLeft),
                                                Text('WorkOrder Type',
                                                    style: tableCardTextLeft),
                                                Text('Completed Date',
                                                    style: tableCardTextLeft),
                                                Text('Mode Of Contact',
                                                    style: tableCardTextLeft),
                                                Text('Complaint Type',
                                                    style: tableCardTextLeft),
                                                Text('Service Type',
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
                                                const Text(':'),
                                                Text(
                                                    cardData[0].stageName !=
                                                            null
                                                        ? ':${cardData[0].stageName}'
                                                        : '',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: tableCardTextRight),
                                                Text(
                                                    cardData[0].compType != null
                                                        ? ':${cardData[0].compType}'
                                                        : '',
                                                    style: tableCardTextRight),
                                                Text(
                                                    cardData[0].completedTime !=
                                                            null
                                                        ? ':${cardData[0].completedTime}'
                                                        : '',
                                                    style: tableCardTextRight),
                                                Text(
                                                    cardData[0].complaintMode !=
                                                            null
                                                        ? ':${cardData[0].complaintMode}'
                                                        : '',
                                                    style: tableCardTextRight),
                                                Text(
                                                    cardData[0].complaintType !=
                                                            null
                                                        ? ':${cardData[0].complaintType}'
                                                        : '',
                                                    style: tableCardTextRight),
                                                Text(
                                                    cardData[0].serviceTypeName !=
                                                            null
                                                        ? ':${cardData[0].serviceTypeName}'
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
              height: 120,
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
                            child: Text('Complaint Details',
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
                                                  Text('Nature Of Complaint',
                                                      style: tableCardTextLeft),
                                                  Text('Description',
                                                      style: tableCardTextLeft),
                                                  Text('Discipline Name',
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
                                                  Text(':',
                                                      style:
                                                          tableCardTextRight),
                                                  Text(
                                                      cardData[0].complaintNatureName !=
                                                              null
                                                          ? ':${cardData[0].complaintNatureName}'
                                                          : '',
                                                      style:
                                                          tableCardTextRight),
                                                  Text(':',
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
                                                Text('Division Name',
                                                    style: tableCardTextLeft),
                                                Text('Response SLA',
                                                    style: tableCardTextLeft),
                                                Text('Resolve SLA',
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
                                                    cardData[0].divisionName !=
                                                            null
                                                        ? ':${cardData[0].divisionName}'
                                                        : '',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: tableCardTextRight),
                                                Text(
                                                    cardData[0].responseStat !=
                                                            null
                                                        ? ':${cardData[0].responseStat}'
                                                        : '',
                                                    style: tableCardTextRight),
                                                Text(
                                                    cardData[0].resolutionStat !=
                                                            null
                                                        ? ':${cardData[0].resolutionStat}'
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
              height: 120,
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
                            child: Text('Complainer Details',
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
                                                  Text('Complainer Name',
                                                      style: tableCardTextLeft),
                                                  Text('Email-ID',
                                                      style: tableCardTextLeft),
                                                  Text('Customer Name',
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
                                                      cardData[0].complainerName !=
                                                              null
                                                          ? ':${cardData[0].complainerName}'
                                                          : '',
                                                      style:
                                                          tableCardTextRight),
                                                  Text(
                                                      cardData[0].cCMOccupEmail !=
                                                              null
                                                          ? ':${cardData[0].cCMOccupEmail}'
                                                          : '',
                                                      style:
                                                          tableCardTextRight),
                                                  Text(
                                                      cardData[0].customerName !=
                                                              null
                                                          ? ':${cardData[0].customerName}'
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
                                                Text('Contact No',
                                                    style: tableCardTextLeft),
                                                Text('Address',
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
                                                    cardData[0].cCMOccupContactNo !=
                                                            null
                                                        ? ':${cardData[0].cCMOccupContactNo}'
                                                        : '',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: tableCardTextRight),
                                                Text(':',
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
                                                  Text('Contract Code',
                                                      style: tableCardTextLeft),
                                                  Text('Region Name',
                                                      style: tableCardTextLeft),
                                                  Text('Location Group',
                                                      style: tableCardTextLeft),
                                                  Text('Locality Code',
                                                      style: tableCardTextLeft),
                                                  Text('Locality Name',
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
                                                      cardData[0].contractCode !=
                                                              null
                                                          ? ':${cardData[0].contractCode}'
                                                          : '',
                                                      style:
                                                          tableCardTextRight),
                                                  Text(
                                                      cardData[0].regionName !=
                                                              null
                                                          ? ':${cardData[0].regionName}'
                                                          : '',
                                                      style:
                                                          tableCardTextRight),
                                                  Text(
                                                      cardData[0].locationGroup !=
                                                              null
                                                          ? ':${cardData[0].locationGroup}'
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
                                                  Text(
                                                      cardData[0].localityName !=
                                                              null
                                                          ? ':${cardData[0].localityName}'
                                                          : '',
                                                      overflow:
                                                          TextOverflow.ellipsis,
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
                                                Text('Contract Name',
                                                    style: tableCardTextLeft),
                                                Text('Spot Name',
                                                    style: tableCardTextLeft),
                                                Text('Wing Name',
                                                    style: tableCardTextLeft),
                                                Text('Building Name',
                                                    style: tableCardTextLeft),
                                                Text('Floor Name',
                                                    style: tableCardTextLeft)
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
                                                    cardData[0].contractName !=
                                                            null
                                                        ? ':${cardData[0].contractName}'
                                                        : '',
                                                    style: tableCardTextRight),
                                                const Text(':'),
                                                const Text(':'),
                                                Text(
                                                    cardData[0].buildingName !=
                                                            null
                                                        ? ':${cardData[0].buildingName}'
                                                        : '',
                                                    style: tableCardTextRight),
                                                Text(':',
                                                    style: tableCardTextRight)
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
              height: 120,
              child: timer == true
                  ? webShimmer(120)
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
                                                  Text('Equipment Name',
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
                                                  Text(':',
                                                      style:
                                                          tableCardTextRight),
                                                  Text(':',
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
                                                Text('Model Name',
                                                    style: tableCardTextLeft),
                                                Text('Make /Mrf',
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
                                                Text(':',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: tableCardTextRight),
                                                Text(':',
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
              height: 120,
              child: timer == true
                  ? webShimmer(120)
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
                            child: Text('SLA', style: cartHeaderStyle),
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
                                                Text('Response ByTime',
                                                    style: tableCardTextLeft),
                                                Text('CompleteBy Time',
                                                    style: tableCardTextLeft),
                                                Text('Responsed Time',
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
                                                    cardData[0].responseByTime !=
                                                            null
                                                        ? ':${cardData[0].responseByTime}'
                                                        : '',
                                                    style: tableCardTextRight),
                                                Text(
                                                    cardData[0].completeByTime !=
                                                            null
                                                        ? ':${cardData[0].completeByTime}'
                                                        : '',
                                                    style: tableCardTextRight),
                                                Text(
                                                    cardData[0].respondedTime !=
                                                            null
                                                        ? ':${cardData[0].respondedTime}'
                                                        : '',
                                                    overflow:
                                                        TextOverflow.ellipsis,
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
                                                Text('CompleteByTime',
                                                    style: tableCardTextLeft),
                                                Text('Attend By Time',
                                                    style: tableCardTextLeft),
                                                Text('Completed Time',
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
                                                    cardData[0].attendedTime !=
                                                            null
                                                        ? ':${cardData[0].attendedTime}'
                                                        : '',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: tableCardTextRight),
                                                Text(
                                                    cardData[0].attendByTime !=
                                                            null
                                                        ? ':${cardData[0].attendByTime}'
                                                        : '',
                                                    style: tableCardTextRight),
                                                Text(':',
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
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Column(
          children: [
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
                            child: Text('Analysis Details',
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
                                                Text('Observation',
                                                    style: tableCardTextLeft),
                                                Text('Root Cause',
                                                    style: tableCardTextLeft),
                                                Text('Technician Name',
                                                    style: tableCardTextLeft),
                                                Text(
                                                    'Technician Analysis Remarks',
                                                    style: tableCardTextLeft),
                                                Text('Start Date & Time',
                                                    style: tableCardTextLeft),
                                                Text('Total Duration',
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
                                                    cardData[0].description !=
                                                            null
                                                        ? ':${cardData[0].description}'
                                                        : '',
                                                    style: tableCardTextRight),
                                                Text(
                                                    cardData[0].rootCause !=
                                                            null
                                                        ? ':${cardData[0].rootCause}'
                                                        : '',
                                                    style: tableCardTextRight),
                                                Text(
                                                    cardData[0].analyzeTechnicianName !=
                                                            null
                                                        ? ':${cardData[0].analyzeTechnicianName}'
                                                        : '',
                                                    style: tableCardTextRight),
                                                Text(
                                                    cardData[0].bDMEmpRemarks !=
                                                            null
                                                        ? ':${cardData[0].bDMEmpRemarks}'
                                                        : '',
                                                    style: tableCardTextRight),
                                                Text(
                                                    cardData[0].cCMStartTime !=
                                                            null
                                                        ? ':${cardData[0].cCMStartTime}'
                                                        : '',
                                                    style: tableCardTextRight),
                                                Text(
                                                    cardData[0].cCMTotalTime !=
                                                            null
                                                        ? ':${cardData[0].cCMTotalTime}'
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
                                                Text('Contact No',
                                                    style: tableCardTextLeft),
                                                Text('Occupant Remarks',
                                                    style: tableCardTextLeft),
                                                Text('Intimate to Close',
                                                    style: tableCardTextLeft),
                                                Text('End Date & Time',
                                                    style: tableCardTextLeft),
                                                Text('Occupant Name',
                                                    style: tableCardTextLeft),
                                                Text('Email',
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
                                                    cardData[0].contactNo !=
                                                            null
                                                        ? ':${cardData[0].contactNo}'
                                                        : '',
                                                    style: tableCardTextRight),
                                                const Text(':'),
                                                Text(
                                                    cardData[0].isAnaliyseClosed !=
                                                            null
                                                        ? ':${cardData[0].isAnaliyseClosed}'
                                                        : '',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: tableCardTextRight),
                                                Text(
                                                    cardData[0].cCMEndTime !=
                                                            null
                                                        ? ':${cardData[0].cCMEndTime}'
                                                        : '',
                                                    style: tableCardTextRight),
                                                Text(
                                                    cardData[0].cCMOccupantName !=
                                                            null
                                                        ? ':${cardData[0].cCMOccupantName}'
                                                        : '',
                                                    style: tableCardTextRight),
                                                Text(
                                                    cardData[0].cCMOccupEmail !=
                                                            null
                                                        ? ':${cardData[0].cCMOccupEmail}'
                                                        : '',
                                                    style: tableCardTextRight)
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
                SizedBox(
                  height: 120,
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
                SizedBox(
                  height: 120,
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
                                child: Text('Occupant Signature',
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
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: 120,
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
                                  child: Text('Analysis Image',
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
          ],
        ),
      ),
    );
  }

  Widget webCardComponent2() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Column(
          children: [
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
                            child: Text('Execution Details',
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
                                                Text('Service CarriedOut',
                                                    style: tableCardTextLeft),
                                                Text('Corrective Action',
                                                    style: tableCardTextLeft),
                                                Text('Technician Name',
                                                    style: tableCardTextLeft),
                                                Text('Technician Execution',
                                                    style: tableCardTextLeft),
                                                Text('Remarks',
                                                    style: tableCardTextLeft),
                                                Text('Start Time',
                                                    style: tableCardTextLeft),
                                                Text('Total Time',
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
                                                    cardData[0].serviceCarriedOut !=
                                                            null
                                                        ? ':${cardData[0].serviceCarriedOut}'
                                                        : '',
                                                    style: tableCardTextRight),
                                                Text(
                                                    cardData[0].correctiveAction !=
                                                            null
                                                        ? ':${cardData[0].correctiveAction}'
                                                        : '',
                                                    style: tableCardTextRight),
                                                Text(
                                                    cardData[0].executionTechnicianName !=
                                                            null
                                                        ? ':${cardData[0].executionTechnicianName}'
                                                        : '',
                                                    style: tableCardTextRight),
                                                Text(
                                                    cardData[0].equipmentName !=
                                                            null
                                                        ? ':${cardData[0].equipmentName}'
                                                        : '',
                                                    style: tableCardTextRight),
                                                Text(
                                                    cardData[0].resolutionStat !=
                                                            null
                                                        ? ':${cardData[0].resolutionStat}'
                                                        : '',
                                                    style: tableCardTextRight),
                                                Text(
                                                    cardData[0].bDMStartTime !=
                                                            null
                                                        ? ':${cardData[0].bDMStartTime}'
                                                        : '',
                                                    style: tableCardTextRight),
                                                Text(
                                                    cardData[0].bDMTotalTime !=
                                                            null
                                                        ? ':${cardData[0].bDMTotalTime}'
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
                                                Text('Contact No',
                                                    style: tableCardTextLeft),
                                                Text('Occupant Remarks',
                                                    style: tableCardTextLeft),
                                                Text('End Time',
                                                    style: tableCardTextLeft),
                                                Text('Occupant Name',
                                                    style: tableCardTextLeft),
                                                Text('Email',
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
                                                    cardData[0].contactNo !=
                                                            null
                                                        ? ':${cardData[0].contactNo}'
                                                        : '',
                                                    style: tableCardTextRight),
                                                const Text(':'),
                                                Text(
                                                    cardData[0].occupantRemarks !=
                                                            null
                                                        ? ':${cardData[0].occupantRemarks}'
                                                        : '',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: tableCardTextRight),
                                                Text(
                                                    cardData[0].bDMEndTime !=
                                                            null
                                                        ? ':${cardData[0].bDMEndTime}'
                                                        : '',
                                                    style: tableCardTextRight),
                                                Text(
                                                    cardData[0].occupantName !=
                                                            null
                                                        ? ':${cardData[0].occupantName}'
                                                        : '',
                                                    style: tableCardTextRight),
                                                Text(
                                                    cardData[0].emailID != null
                                                        ? ':${cardData[0].emailID}'
                                                        : '',
                                                    style: tableCardTextRight)
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
                SizedBox(
                  height: 120,
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
                SizedBox(
                  height: 120,
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
                                child: Text('Occupant Signature',
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
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: 120,
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
                                  child: Text('Execution Image',
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
          ],
        ),
      ),
    );
  }
}

class VwDHDPopUpGrdDet {
  String? complaintIDPK;
  String? priorityIDPK;
  String? bDMBusinessFlowID;
  String? cCMStageID;
  String? cCMAllocatedEmpID;
  String? complaintNo;
  String? complainedDate;
  String? stageName;
  String? woStatus;
  String? complaintNatureName;
  String? divisionCode;
  String? divisionName;
  String? complainerName;
  String? contractCode;
  String? contractName;
  String? localityName;
  String? buildingCode;
  String? buildingName;
  String? floorName;
  String? spotName;
  String? descriptionn;
  String? priorityName;
  String? responseStat;
  String? resolutionStat;
  String? pendingByDays;
  String? maintenanceRemarks;
  String? eTADate;
  String? completedDate;
  String? compType;
  String? isServiceRequest;
  String? clientWoNo;
  String? resultCount;

  VwDHDPopUpGrdDet(
      {this.complaintIDPK,
      this.priorityIDPK,
      this.bDMBusinessFlowID,
      this.cCMStageID,
      this.cCMAllocatedEmpID,
      this.complaintNo,
      this.complainedDate,
      this.stageName,
      this.woStatus,
      this.complaintNatureName,
      this.divisionCode,
      this.divisionName,
      this.complainerName,
      this.contractCode,
      this.contractName,
      this.localityName,
      this.buildingCode,
      this.buildingName,
      this.floorName,
      this.spotName,
      this.descriptionn,
      this.priorityName,
      this.responseStat,
      this.resolutionStat,
      this.pendingByDays,
      this.maintenanceRemarks,
      this.eTADate,
      this.completedDate,
      this.compType,
      this.isServiceRequest,
      this.clientWoNo,
      this.resultCount});

  VwDHDPopUpGrdDet.fromJson(Map<String, dynamic> json) {
    complaintIDPK = json['ComplaintIDPK'];
    priorityIDPK = json['PriorityIDPK'];
    bDMBusinessFlowID = json['BDMBusinessFlowID'];
    cCMStageID = json['CCMStageID'];
    cCMAllocatedEmpID = json['CCMAllocatedEmpID'];
    complaintNo = json['ComplaintNo'];
    complainedDate = json['ComplainedDate'];
    stageName = json['StageName'];
    woStatus = json['WoStatus'];
    complaintNatureName = json['ComplaintNatureName'];
    divisionCode = json['DivisionCode'];
    divisionName = json['DivisionName'];
    complainerName = json['ComplainerName'];
    contractCode = json['ContractCode'];
    contractName = json['ContractName'];
    localityName = json['LocalityName'];
    buildingCode = json['BuildingCode'];
    buildingName = json['BuildingName'];
    floorName = json['FloorName'];
    spotName = json['SpotName'];
    descriptionn = json['Descriptionn'];
    priorityName = json['PriorityName'];
    responseStat = json['ResponseStat'];
    resolutionStat = json['ResolutionStat'];
    pendingByDays = json['PendingByDays'];
    maintenanceRemarks = json['MaintenanceRemarks'];
    eTADate = json['ETADate'];
    completedDate = json['CompletedDate'];
    compType = json['CompType'];
    isServiceRequest = json['IsServiceRequest'];
    clientWoNo = json['ClientWoNo'];
    resultCount = json['ResultCount'];
  }
}

class VwDHelpDeskDetDBoard {
  String? complaintIDPK;
  String? contractID;
  String? localityID;
  String? complaintNo;
  String? complainedDate;
  String? priorityName;
  String? stat;
  String? stageName;
  String? compType;
  String? serviceTypeName;
  String? complaintType;
  String? complaintMode;
  String? completedDate;
  String? ageingInDays;
  String? responseStat;
  String? resolutionStat;
  String? complaintNatureName;
  String? description;
  String? divisionName;
  String? disciplineName;
  String? eTA;
  String? preferredTime;
  String? contractCode;
  String? contractName;
  String? regionName;
  String? locationGroup;
  String? localityCode;
  String? localityName;
  String? buildingName;
  String? floorName;
  String? spotName;
  String? wingName;
  String? complainerName;
  String? contactNo;
  String? customerName;
  String? address1;
  String? emailID;
  String? assetTagNo;
  String? equipmentName;
  String? makeName;
  String? modelName;
  String? responseByTime;
  String? respondedTime;
  String? attendByTime;
  String? attendedTime;
  String? completeByTime;
  String? completedTime;
  String? observation;
  String? rootCause;
  String? analyzeTechnicianName;
  String? cCMEmpRemarks;
  String? isAnaliyseClosed;
  String? cCMStartTime;
  String? cCMEndTime;
  String? cCMTotalTime;
  String? cCMOccupantName;
  String? cCMOccupContactNo;
  String? cCMOccupEmail;
  String? cCMOccupantAddress;
  String? cCMOccupantRemarks;
  String? serviceCarriedOut;
  String? correctiveAction;
  String? executionTechnicianName;
  String? bDMEmpRemarks;
  String? bDMStartTime;
  String? bDMEndTime;
  String? bDMTotalTime;
  String? occupantName;
  String? occupantAddress;
  String? occupantRemarks;
  String? clientWoNo;

  VwDHelpDeskDetDBoard(
      {this.complaintIDPK,
      this.contractID,
      this.localityID,
      this.complaintNo,
      this.complainedDate,
      this.priorityName,
      this.stat,
      this.stageName,
      this.compType,
      this.serviceTypeName,
      this.complaintType,
      this.complaintMode,
      this.completedDate,
      this.ageingInDays,
      this.responseStat,
      this.resolutionStat,
      this.complaintNatureName,
      this.description,
      this.divisionName,
      this.disciplineName,
      this.eTA,
      this.preferredTime,
      this.contractCode,
      this.contractName,
      this.regionName,
      this.locationGroup,
      this.localityCode,
      this.localityName,
      this.buildingName,
      this.floorName,
      this.spotName,
      this.wingName,
      this.complainerName,
      this.contactNo,
      this.customerName,
      this.address1,
      this.emailID,
      this.assetTagNo,
      this.equipmentName,
      this.makeName,
      this.modelName,
      this.responseByTime,
      this.respondedTime,
      this.attendByTime,
      this.attendedTime,
      this.completeByTime,
      this.completedTime,
      this.observation,
      this.rootCause,
      this.analyzeTechnicianName,
      this.cCMEmpRemarks,
      this.isAnaliyseClosed,
      this.cCMStartTime,
      this.cCMEndTime,
      this.cCMTotalTime,
      this.cCMOccupantName,
      this.cCMOccupContactNo,
      this.cCMOccupEmail,
      this.cCMOccupantAddress,
      this.cCMOccupantRemarks,
      this.serviceCarriedOut,
      this.correctiveAction,
      this.executionTechnicianName,
      this.bDMEmpRemarks,
      this.bDMStartTime,
      this.bDMEndTime,
      this.bDMTotalTime,
      this.occupantName,
      this.occupantAddress,
      this.occupantRemarks,
      this.clientWoNo});

  VwDHelpDeskDetDBoard.fromJson(Map<String, dynamic> json) {
    complaintIDPK = json['ComplaintIDPK'];
    contractID = json['ContractID'];
    localityID = json['LocalityID'];
    complaintNo = json['ComplaintNo'];
    complainedDate = json['ComplainedDate'];
    priorityName = json['PriorityName'];
    stat = json['Stat'];
    stageName = json['StageName'];
    compType = json['CompType'];
    serviceTypeName = json['ServiceTypeName'];
    complaintType = json['ComplaintType'];
    complaintMode = json['ComplaintMode'];
    completedDate = json['CompletedDate'];
    ageingInDays = json['AgeingInDays'];
    responseStat = json['ResponseStat'];
    resolutionStat = json['ResolutionStat'];
    complaintNatureName = json['ComplaintNatureName'];
    description = json['Description'];
    divisionName = json['DivisionName'];
    disciplineName = json['DisciplineName'];
    eTA = json['ETA'];
    preferredTime = json['PreferredTime'];
    contractCode = json['ContractCode'];
    contractName = json['ContractName'];
    regionName = json['RegionName'];
    locationGroup = json['LocationGroup'];
    localityCode = json['LocalityCode'];
    localityName = json['LocalityName'];
    buildingName = json['BuildingName'];
    floorName = json['FloorName'];
    spotName = json['SpotName'];
    wingName = json['WingName'];
    complainerName = json['ComplainerName'];
    contactNo = json['ContactNo'];
    customerName = json['CustomerName'];
    address1 = json['Address1'];
    emailID = json['EmailID'];
    assetTagNo = json['AssetTagNo'];
    equipmentName = json['EquipmentName'];
    makeName = json['MakeName'];
    modelName = json['ModelName'];
    responseByTime = json['ResponseByTime'];
    respondedTime = json['RespondedTime'];
    attendByTime = json['AttendByTime'];
    attendedTime = json['AttendedTime'];
    completeByTime = json['CompleteByTime'];
    completedTime = json['CompletedTime'];
    observation = json['Observation'];
    rootCause = json['RootCause'];
    analyzeTechnicianName = json['AnalyzeTechnicianName'];
    cCMEmpRemarks = json['CCMEmpRemarks'];
    isAnaliyseClosed = json['IsAnaliyseClosed'];
    cCMStartTime = json['CCMStartTime'];
    cCMEndTime = json['CCMEndTime'];
    cCMTotalTime = json['CCMTotalTime'];
    cCMOccupantName = json['CCMOccupantName'];
    cCMOccupContactNo = json['CCMOccupContactNo'];
    cCMOccupEmail = json['CCMOccupEmail'];
    cCMOccupantAddress = json['CCMOccupantAddress'];
    cCMOccupantRemarks = json['CCMOccupantRemarks'];
    serviceCarriedOut = json['ServiceCarriedOut'];
    correctiveAction = json['CorrectiveAction'];
    executionTechnicianName = json['ExecutionTechnicianName'];
    bDMEmpRemarks = json['BDMEmpRemarks'];
    bDMStartTime = json['BDMStartTime'];
    bDMEndTime = json['BDMEndTime'];
    bDMTotalTime = json['BDMTotalTime'];
    occupantName = json['OccupantName'];
    occupantAddress = json['OccupantAddress'];
    occupantRemarks = json['OccupantRemarks'];
    clientWoNo = json['ClientWoNo'];
  }
}
