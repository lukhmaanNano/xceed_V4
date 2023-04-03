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
import '../../../model/contract/contract.dart';
import '../shimmer.dart';

class ContractDetailView extends StatefulWidget {
  final String name, ComplaintIDPK;
  int tappedValue;
  ContractDetailView(
      {Key? key,
      required this.tappedValue,
      required this.name,
      required this.ComplaintIDPK})
      : super(key: key);

  @override
  State<ContractDetailView> createState() => _ContractDetailViewState();
}

class _ContractDetailViewState extends State<ContractDetailView> {
  String? userName, currentDate, startDate, day = 'Today', pageName;
  bool timer = true, cardView = false;
  var ComplaintIDPK;
  final labels = [
    "PRIMARY INFO",
    "TYPE OF SERVICE",
    "CONFIG LOCATION/BUILDING",
    "ASSETS DETAILS"
  ];
  int initialIndex = 0, headerId = 1;
  final Duration delayed = const Duration(milliseconds: 100);
  List<VwDConContractPopUpGrdDet> chartDataTable = [];
  List<VwDConContractDetails> cardData = [];
  List<VwDConContractDetails1> tableData1 = [];
  List<VwDConContractDetails3> tableData3 = [];

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
      ComplaintIDPK = widget.ComplaintIDPK;
    });
    chartTappedDataApi();
    cardApi();
  }

  Future<void> chartTappedDataApi() async {
    chartDataTable.clear();
    String? ip = '/VwDConContractPopUpGrdDet/';
    const service = ApiConfig.service;
    final url = Uri.parse('$service$ip');
    final headers = {'Accept': 'application/json'};
    final json =
        '{"data":{"CountryID_varchar":0,"CustomerID_varchar":0,"ContractID_varchar":0,"LocationGroupID_varchar":0,"LocalityID_varchar":0,"BuildingID_varchar":0,"CityID_varchar":0,"FloorID_varchar":0,"SpotID_varchar":0,"DivisionID_varchar":0,"DisciplineID_varchar":0,"ServiceTypeID_varchar":0,"FromDate_datetime":"2023-02-04","ToDate_datetime":"2023-03-06","LocUserID_int":"6","PortalUserID_bit":0,"HeaderID_int":5,"DataParam_varchar":"","PageIndex_int":1,"PageSize_int":10,"ResultCount_int":${widget.tappedValue}}}';
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
  }

  Future<void> cardApi() async {
    if (timer == false) {
      setState(() {
        timer = true;
      });
    }
    if (initialIndex == 0) {
      setState(() {
        headerId = 1;
      });
    } else if (initialIndex == 1) {
      setState(() {
        headerId = 2;
      });
    } else if (initialIndex == 2) {
      setState(() {
        headerId = 3;
      });
    } else {
      setState(() {
        headerId = 4;
      });
    }
    cardData.clear();
    tableData1.clear();
    tableData3.clear();
    var id = ComplaintIDPK ?? widget.ComplaintIDPK;
    String? ip = '/VwDConContractDetails/';
    const service = ApiConfig.service;
    final url = Uri.parse('$service$ip');
    final headers = {'Accept': 'application/json'};
    final json =
        '{"data":{"ContractID_varchar":"$id","HeaderID_int":$headerId,"PageIndex_int":1,"PageSize_int":10}}';
    final response =
        await http.post(url, headers: headers, body: json.toString());
    if (response.statusCode == 400) {
      String err = 'something went wrong!';
    } else {
      final String jsonString = jsonEncode(response.body);
      var decodedJson = jsonDecode(jsonString);
      Map<String, dynamic> map = jsonDecode(decodedJson);
      var result = map['VwDConContractDetails'];
      if (headerId == 1) {
        for (Map<String, dynamic> i in result) {
          cardData.add(VwDConContractDetails.fromJson(i));
        }
      } else if (headerId == 2) {
        for (Map<String, dynamic> i in result) {
          tableData1.add(VwDConContractDetails1.fromJson(i));
        }
      } else if (headerId == 4) {
        for (Map<String, dynamic> i in result) {
          tableData3.add(VwDConContractDetails3.fromJson(i));
        }
      } else {
        if (result.isNotEmpty) {
          print('NotEmpty');
        } else {
          print('Empty');
        }
      }

      timerFunction();
      // tableApi();
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
                      child: chartDataTable.isEmpty
                          ? webShimmer(double.infinity)
                          : GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                mainAxisExtent: 180,
                                crossAxisCount: 1,
                              ),
                              shrinkWrap: true,
                              itemCount: chartDataTable.length,
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
                                                      chartDataTable[index]
                                                          .contractIDPK
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
                                                              chartDataTable[
                                                                      index]
                                                                  .contractIDPK
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
                                                                      'Code :${chartDataTable[index].contractCode}',
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
                                                                      '${chartDataTable[index].startDate}',
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
                                                                            75,
                                                                        child:
                                                                            Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: const [
                                                                            Text('Name',
                                                                                textAlign: TextAlign.start,
                                                                                style: cardHeader),
                                                                            Text('Contract Type',
                                                                                textAlign: TextAlign.start,
                                                                                style: cardHeader),
                                                                            Text('Classification',
                                                                                textAlign: TextAlign.start,
                                                                                style: cardHeader),
                                                                            Text('Contractor',
                                                                                textAlign: TextAlign.start,
                                                                                style: cardHeader),
                                                                            Text('Business Associate',
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
                                                                            chartDataTable[index].contractName == null
                                                                                ? const Text(':', style: cardBody)
                                                                                : Text(':${chartDataTable[index].contractName}', style: cardBody),
                                                                            chartDataTable[index].contractTypeName == null
                                                                                ? const Text(':', style: cardBody)
                                                                                : Text(':${chartDataTable[index].contractTypeName}', style: cardBody),
                                                                            chartDataTable[index].classification == null
                                                                                ? const Text(':', style: cardBody)
                                                                                : Text(':${chartDataTable[index].classification}', style: cardBody),
                                                                            chartDataTable[index].contractor == null
                                                                                ? const Text(':', style: cardBody)
                                                                                : Text(':${chartDataTable[index].contractor}', style: cardBody),
                                                                            chartDataTable[index].businessAssociate == null
                                                                                ? const Text(':', style: cardBody)
                                                                                : Text(':${chartDataTable[index].businessAssociate}', style: cardBody),
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
                        : initialIndex == 1
                            ? webCardComponent1()
                            : initialIndex == 2
                                ? webCardComponent2()
                                : webCardComponent3()),
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
          child: Text(widget.name),
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
            totalSwitches: 4,
            labels: labels,
            onToggle: (index) {
              setState(() {
                initialIndex = index!;
              });
              cardApi();
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
                                                Text('Code',
                                                    style: tableCardTextLeft),
                                                Text('Business Associate',
                                                    style: tableCardTextLeft),
                                                Text('Contract Type',
                                                    style: tableCardTextLeft),
                                                Text('Signed by',
                                                    style: tableCardTextLeft),
                                                Text('Name',
                                                    style: tableCardTextLeft),
                                                Text('Classification',
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
                                                    cardData[0].contractCode !=
                                                            null
                                                        ? ':${cardData[0].contractCode}'
                                                        : '',
                                                    style: tableCardTextRight),
                                                Text(
                                                    cardData[0].businessAssociate !=
                                                            null
                                                        ? ':${cardData[0].businessAssociate}'
                                                        : '',
                                                    style: tableCardTextRight),
                                                Text(
                                                    cardData[0].contractTypeName !=
                                                            null
                                                        ? ':${cardData[0].contractTypeName}'
                                                        : '',
                                                    style: tableCardTextRight),
                                                Text(
                                                    cardData[0].signedBy != null
                                                        ? ':${cardData[0].signedBy}'
                                                        : '',
                                                    style: tableCardTextRight),
                                                Text(
                                                    cardData[0].contractName !=
                                                            null
                                                        ? ':${cardData[0].contractName}'
                                                        : '',
                                                    style: tableCardTextRight),
                                                Text(
                                                    cardData[0].classification !=
                                                            null
                                                        ? ':${cardData[0].classification}'
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
                                                Text('Parent Contract',
                                                    style: tableCardTextLeft),
                                                Text('CompletedVia',
                                                    style: tableCardTextLeft),
                                                Text('Contractor /Asset',
                                                    style: tableCardTextLeft),
                                                Text('Owner',
                                                    style: tableCardTextLeft),
                                                Text('Status',
                                                    style: tableCardTextLeft),
                                                Text('Acknowledged by',
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
                                                    cardData[0].losedComment !=
                                                            null
                                                        ? ':${cardData[0].losedComment}'
                                                        : '',
                                                    style: tableCardTextRight),
                                                Text(
                                                    cardData[0].contractName !=
                                                            null
                                                        ? ':${cardData[0].contractName}'
                                                        : '',
                                                    style: tableCardTextRight),
                                                Text(
                                                    cardData[0].contractor !=
                                                            null
                                                        ? ':${cardData[0].contractor}'
                                                        : '',
                                                    style: tableCardTextRight),
                                                Text(
                                                    cardData[0].acknowledgedBy !=
                                                            null
                                                        ? ':${cardData[0].acknowledgedBy}'
                                                        : '',
                                                    style: tableCardTextRight),
                                                Text(
                                                    cardData[0].stat != null
                                                        ? ':${cardData[0].stat}'
                                                        : '',
                                                    style: tableCardTextRight),
                                                Text(
                                                    cardData[0].acknowledgedBy !=
                                                            null
                                                        ? ':${cardData[0].acknowledgedBy}'
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
                                                  Text('Contract Start Date',
                                                      style: tableCardTextLeft),
                                                  Text('Extended Upto',
                                                      style: tableCardTextLeft),
                                                  Text('Lost Date',
                                                      style: tableCardTextLeft),
                                                  Text('Contract End Date',
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
                                                      cardData[0].startDate !=
                                                              null
                                                          ? ':${cardData[0].startDate}'
                                                          : '',
                                                      style:
                                                          tableCardTextRight),
                                                  Text(
                                                      cardData[0].extendedDate !=
                                                              null
                                                          ? ':${cardData[0].extendedDate}'
                                                          : '',
                                                      style:
                                                          tableCardTextRight),
                                                  Text(
                                                      cardData[0].lostDate !=
                                                              null
                                                          ? ':${cardData[0].lostDate}'
                                                          : '',
                                                      style:
                                                          tableCardTextRight),
                                                  Text(
                                                      cardData[0].endDate !=
                                                              null
                                                          ? ':${cardData[0].endDate}'
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
                                                Text('Contract Value',
                                                    style: tableCardTextLeft),
                                                Text('Lost Comment',
                                                    style: tableCardTextLeft),
                                                Text('Annual Review Date',
                                                    style: tableCardTextLeft),
                                                Text('Extended Value',
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
                                                    cardData[0].contractValue !=
                                                            null
                                                        ? ':${cardData[0].contractValue}'
                                                        : '',
                                                    style: tableCardTextRight),
                                                Text(
                                                    cardData[0].losedComment !=
                                                            null
                                                        ? ':${cardData[0].losedComment}'
                                                        : '',
                                                    style: tableCardTextRight),
                                                Text(
                                                    cardData[0].annualReviewDate !=
                                                            null
                                                        ? ':${cardData[0].annualReviewDate}'
                                                        : '',
                                                    style: tableCardTextRight),
                                                Text(
                                                    cardData[0].annualReviewDate !=
                                                            null
                                                        ? ':${cardData[0].annualReviewDate}'
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
          ])),
    );
  }

  Widget webCardComponent1() {
    double chartHeight = MediaQuery.of(context).size.height * 0.88;
    return SizedBox(
      height: chartHeight,
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
                    padding:
                        EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
                    child: Text('Type of Services', style: cartHeaderStyle),
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
                            headingRowColor: MaterialStateProperty.resolveWith(
                                (states) => secondaryColor),
                            decoration:
                                const BoxDecoration(color: Colors.white),
                            minWidth: 600,
                            columns: const [
                              DataColumn(
                                label: Text(
                                  'Service Type',
                                  style: columnStyle,
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Start Date',
                                  style: columnStyle,
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'End Date',
                                  style: columnStyle,
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Price',
                                  style: columnStyle,
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'No.Of Employee',
                                  style: columnStyle,
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Status',
                                  style: columnStyle,
                                ),
                              ),
                            ],
                            rows: tableData1
                                .map((data) => DataRow(cells: [
                                      DataCell(
                                        Text(
                                          '${data.serviceTypeName ?? data.serviceTypeName}',
                                          style: rowstyle,
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          '${data.startDt ?? data.startDt}',
                                          style: rowstyle,
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          '${data.endDt ?? data.endDt}',
                                          style: rowstyle,
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                      DataCell(
                                        Text('${data.price ?? data.price}',
                                            style: rowstyle),
                                      ),
                                      DataCell(
                                        Text(
                                            '${data.noofEmployee ?? data.noofEmployee}',
                                            style: rowstyle),
                                      ),
                                      DataCell(
                                        Text('${data.stat ?? data.stat}',
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
    );
  }

  Widget webCardComponent2() {
    return Text('hlo2');
  }

  Widget webCardComponent3() {
    double chartHeight = MediaQuery.of(context).size.height * 0.88;
    return SizedBox(
      height: chartHeight,
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
                    padding:
                        EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
                    child: Text('Assets Details', style: cartHeaderStyle),
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
                            headingRowColor: MaterialStateProperty.resolveWith(
                                (states) => secondaryColor),
                            decoration:
                                const BoxDecoration(color: Colors.white),
                            minWidth: 600,
                            columns: const [
                              DataColumn(
                                label: Text(
                                  'Location',
                                  style: columnStyle,
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Tag No',
                                  style: columnStyle,
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Barcode',
                                  style: columnStyle,
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Asset Name',
                                  style: columnStyle,
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Building',
                                  style: columnStyle,
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Floor',
                                  style: columnStyle,
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Condition',
                                  style: columnStyle,
                                ),
                              ),
                            ],
                            rows: tableData3
                                .sublist(0, 20)
                                .map((data) => DataRow(cells: [
                                      DataCell(
                                        Text(
                                          '${data.localityName ?? data.localityName}',
                                          style: rowstyle,
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          '${data.assetTagNo ?? data.assetTagNo}',
                                          style: rowstyle,
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          '${data.barcode ?? data.barcode}',
                                          style: rowstyle,
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                            '${data.disciplineName ?? data.disciplineName}',
                                            style: rowstyle),
                                      ),
                                      DataCell(
                                        Text(
                                            '${data.buildingName ?? data.buildingName}',
                                            style: rowstyle),
                                      ),
                                      DataCell(
                                        Text(
                                            '${data.loorName ?? data.loorName}',
                                            style: rowstyle),
                                      ),
                                      DataCell(
                                        Text(
                                            '${data.resultCount ?? data.resultCount}',
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
    );
  }
}

class VwDConContractDetails {
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
  String? contractValue;
  String? extendedDate;
  String? acknowledgedBy;
  String? signedBy;
  String? lostDate;
  String? losedComment;

  VwDConContractDetails(
      {this.contractCode,
      this.contractName,
      this.contractTypeName,
      this.classification,
      this.contractor,
      this.businessAssociate,
      this.startDate,
      this.endDate,
      this.annualReviewDate,
      this.stat,
      this.contractValue,
      this.extendedDate,
      this.acknowledgedBy,
      this.signedBy,
      this.lostDate,
      this.losedComment});

  VwDConContractDetails.fromJson(Map<String, dynamic> json) {
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
    contractValue = json['ContractValue'];
    extendedDate = json['ExtendedDate'];
    acknowledgedBy = json['AcknowledgedBy'];
    signedBy = json['SignedBy'];
    lostDate = json['LostDate'];
    losedComment = json['LosedComment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
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
    data['ContractValue'] = contractValue;
    data['ExtendedDate'] = extendedDate;
    data['AcknowledgedBy'] = acknowledgedBy;
    data['SignedBy'] = signedBy;
    data['LostDate'] = lostDate;
    data['LosedComment'] = losedComment;
    return data;
  }
}

class VwDConContractDetails1 {
  String? serviceTypeName;
  String? startDt;
  String? endDt;
  String? price;
  String? noofEmployee;
  String? stat;

  VwDConContractDetails1(
      {this.serviceTypeName,
      this.startDt,
      this.endDt,
      this.price,
      this.noofEmployee,
      this.stat});

  VwDConContractDetails1.fromJson(Map<String, dynamic> json) {
    serviceTypeName = json['ServiceTypeName'];
    startDt = json['StartDt'];
    endDt = json['EndDt'];
    price = json['Price'];
    noofEmployee = json['NoofEmployee'];
    stat = json['Stat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ServiceTypeName'] = serviceTypeName;
    data['StartDt'] = startDt;
    data['EndDt'] = endDt;
    data['Price'] = price;
    data['NoofEmployee'] = noofEmployee;
    data['Stat'] = stat;
    return data;
  }
}

class VwDConContractDetails3 {
  String? assetIDPK;
  String? assetTagNo;
  String? equipmentName;
  String? equipmentRefNo;
  String? localityName;
  String? buildingName;
  String? loorName;
  String? spotName;
  String? divisionName;
  String? disciplineName;
  String? barcode;
  String? resultCount;

  VwDConContractDetails3(
      {this.assetIDPK,
      this.assetTagNo,
      this.equipmentName,
      this.equipmentRefNo,
      this.localityName,
      this.buildingName,
      this.loorName,
      this.spotName,
      this.divisionName,
      this.disciplineName,
      this.barcode,
      this.resultCount});

  VwDConContractDetails3.fromJson(Map<String, dynamic> json) {
    assetIDPK = json['AssetIDPK'];
    assetTagNo = json['AssetTagNo'];
    equipmentName = json['EquipmentName'];
    equipmentRefNo = json['EquipmentRefNo'];
    localityName = json['LocalityName'];
    buildingName = json['BuildingName'];
    loorName = json['loorName'];
    spotName = json['SpotName'];
    divisionName = json['DivisionName'];
    disciplineName = json['DisciplineName'];
    barcode = json['Barcode'];
    resultCount = json['ResultCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['AssetIDPK'] = assetIDPK;
    data['AssetTagNo'] = assetTagNo;
    data['EquipmentName'] = equipmentName;
    data['EquipmentRefNo'] = equipmentRefNo;
    data['LocalityName'] = localityName;
    data['BuildingName'] = buildingName;
    data['loorName'] = loorName;
    data['SpotName'] = spotName;
    data['DivisionName'] = divisionName;
    data['DisciplineName'] = disciplineName;
    data['Barcode'] = barcode;
    data['ResultCount'] = resultCount;
    return data;
  }
}
