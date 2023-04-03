import 'dart:async';
import 'dart:convert';
import 'package:delayed_display/delayed_display.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../Config.dart';
import '../../../Styles/CommonColor.dart';
import '../../../Styles/CommonTextStyle.dart';
import '../../../Styles/responsive.dart';
import '../../../model/assets/assets.dart';
import '../shimmer.dart';

class assetDetailView extends StatefulWidget {
  final String tappedValue, name, ComplaintIDPK;
  assetDetailView(
      {Key? key,
      required this.tappedValue,
      required this.name,
      required this.ComplaintIDPK})
      : super(key: key);

  @override
  State<assetDetailView> createState() => _assetDetailViewState();
}

class _assetDetailViewState extends State<assetDetailView> {
  String? userName, currentDate, startDate, day = 'Today', pageName;
  bool timer = true, cardView = false;
  var ComplaintIDPK;
  final Duration delayed = const Duration(milliseconds: 100);
  List<VwDAssetDetDBoard> cardData = [];
  List<VwDAssetPopUpGrdDet> chartdataTable1 = [];
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
    String? ip = '/VwDAssetPopUpGrdDet/';
    const service = ApiConfig.service;
    final url = Uri.parse('$service$ip');
    final headers = {'Accept': 'application/json'};
    final json =
        '{"data":{"CountryID_varchar":0,"CustomerID_varchar":0,"ContractID_varchar":0,"LocationGroupID_varchar":0,"LocalityID_varchar":0,"BuildingID_varchar":0,"CityID_varchar":0,"FloorID_varchar":0,"SpotID_varchar":0,"DivisionID_varchar":null,"DisciplineID_varchar":null,"ServiceTypeID_varchar":null,"FromDate_datetime":"2023-02-02","ToDate_datetime":"2023-03-06","LocUserID_int":"6","PortalUserID_bit":null,"HeaderID_int":16,"DataParam1_varchar":"${widget.tappedValue}","DataParam2_varchar":"","DataParam3_varchar":null,"PageIndex_int":1,"PageSize_int":10,"ResultCount_int":null}}';
    final response =
        await http.post(url, headers: headers, body: json.toString());
    if (response.statusCode == 400) {
      String err = 'something went wrong!';
    } else {
      final String jsonString = jsonEncode(response.body);
      var decodedJson = jsonDecode(jsonString);
      Map<String, dynamic> map = jsonDecode(decodedJson);
      var result = map['VwDAssetPopUpGrdDet'];
      for (Map<String, dynamic> i in result) {
        chartdataTable1.add(VwDAssetPopUpGrdDet.fromJson(i));
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
    String? ip = '/VwDAssetDetDBoard/';
    const service = ApiConfig.service;
    final url = Uri.parse('$service$ip');
    final headers = {'Accept': 'application/json'};
    final json = '{"data":{"AssetIDPK_int":"$id"}}';
    final response =
        await http.post(url, headers: headers, body: json.toString());
    if (response.statusCode == 400) {
      String err = 'something went wrong!';
    } else {
      final String jsonString = jsonEncode(response.body);
      var decodedJson = jsonDecode(jsonString);
      Map<String, dynamic> map = jsonDecode(decodedJson);
      var result = map['VwDAssetDetDBoard'];
      for (Map<String, dynamic> i in result) {
        cardData.add(VwDAssetDetDBoard.fromJson(i));
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
              child: Align(
                alignment: Alignment.centerLeft,
                child: formName(),
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
                                                          .assetIDPK
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
                                                                  .assetIDPK
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
                                                                      'Floor Name :${chartdataTable1[index].floorName}',
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
                                                                      '${chartdataTable1[index].resultCount}',
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
                                                                            85,
                                                                        child:
                                                                            Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: const [
                                                                            Text('Tag No',
                                                                                textAlign: TextAlign.start,
                                                                                style: cardHeader),
                                                                            Text('Asset Name',
                                                                                textAlign: TextAlign.start,
                                                                                style: cardHeader),
                                                                            Text('Ref No',
                                                                                textAlign: TextAlign.start,
                                                                                style: cardHeader),
                                                                            Text('Barcode',
                                                                                textAlign: TextAlign.start,
                                                                                style: cardHeader),
                                                                            Text('Location',
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
                                                                            chartdataTable1[index].assetTagNo == null
                                                                                ? const Text(':', style: cardBody)
                                                                                : Text(':${chartdataTable1[index].assetTagNo}', style: cardBody),
                                                                            chartdataTable1[index].equipmentName == null
                                                                                ? const Text(':', style: cardBody)
                                                                                : Text(':${chartdataTable1[index].equipmentName}', style: cardBody),
                                                                            chartdataTable1[index].equipmentRefNo == null
                                                                                ? const Text(':', style: cardBody)
                                                                                : Text(':${chartdataTable1[index].equipmentRefNo}', style: cardBody),
                                                                            chartdataTable1[index].barcode == null
                                                                                ? const Text(':', style: cardBody)
                                                                                : Text(':${chartdataTable1[index].barcode}', style: cardBody),
                                                                            chartdataTable1[index].localityName == null
                                                                                ? const Text(':', style: cardBody)
                                                                                : Text(':${chartdataTable1[index].localityName}', style: cardBody),
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
                Flexible(flex: 3, child: webCardComponent()),
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
                                                Text('Asset Name',
                                                    style: tableCardTextLeft),
                                                Text('RFID',
                                                    style: tableCardTextLeft),
                                                Text('Condition',
                                                    style: tableCardTextLeft),
                                                Text('Model',
                                                    style: tableCardTextLeft),
                                                Text('Type',
                                                    style: tableCardTextLeft),
                                                Text('Tag No',
                                                    style: tableCardTextLeft),
                                                Text('Division',
                                                    style: tableCardTextLeft),
                                                Text('Equipment Ref No',
                                                    style: tableCardTextLeft),
                                                Text('Priority',
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
                                                    cardData[0].equipmentName !=
                                                            null
                                                        ? ':${cardData[0].equipmentName}'
                                                        : '',
                                                    style: tableCardTextRight),
                                                Text(
                                                    cardData[0].rFID != null
                                                        ? ':${cardData[0].rFID}'
                                                        : '',
                                                    style: tableCardTextRight),
                                                Text(
                                                    cardData[0].conditionName !=
                                                            null
                                                        ? ':${cardData[0].conditionName}'
                                                        : '',
                                                    style: tableCardTextRight),
                                                Text(
                                                    cardData[0].modelName !=
                                                            null
                                                        ? ':${cardData[0].modelName}'
                                                        : '',
                                                    style: tableCardTextRight),
                                                Text(
                                                    cardData[0].assetTypeName !=
                                                            null
                                                        ? ':${cardData[0].assetTypeName}'
                                                        : '',
                                                    style: tableCardTextRight),
                                                Text(
                                                    cardData[0].assetTagNo !=
                                                            null
                                                        ? ':${cardData[0].assetTagNo}'
                                                        : '',
                                                    style: tableCardTextRight),
                                                Text(
                                                    cardData[0].divisionName !=
                                                            null
                                                        ? ':${cardData[0].divisionName}'
                                                        : '',
                                                    style: tableCardTextRight),
                                                Text(
                                                    cardData[0].equipmentRefNo !=
                                                            null
                                                        ? ':${cardData[0].equipmentRefNo}'
                                                        : '',
                                                    style: tableCardTextRight),
                                                Text(
                                                    cardData[0].priorityName !=
                                                            null
                                                        ? ':${cardData[0].priorityName}'
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
                                                Text('Status',
                                                    style: tableCardTextLeft),
                                                Text('Service Area',
                                                    style: tableCardTextLeft),
                                                Text('Asset Owner',
                                                    style: tableCardTextLeft),
                                                Text('Barcode',
                                                    style: tableCardTextLeft),
                                                Text('Discipline',
                                                    style: tableCardTextLeft),
                                                Text('Asset Item Code',
                                                    style: tableCardTextLeft),
                                                Text('Tech.Specification',
                                                    style: tableCardTextLeft),
                                                Text('Make',
                                                    style: tableCardTextLeft),
                                                Text('Serial No',
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
                                                    cardData[0].statusName !=
                                                            null
                                                        ? ':${cardData[0].statusName}'
                                                        : '',
                                                    style: tableCardTextRight),
                                                Text(
                                                    cardData[0].serviceAreaName !=
                                                            null
                                                        ? ':${cardData[0].serviceAreaName}'
                                                        : '',
                                                    style: tableCardTextRight),
                                                Text(
                                                    cardData[0].assetOwner !=
                                                            null
                                                        ? ':${cardData[0].assetOwner}'
                                                        : '',
                                                    style: tableCardTextRight),
                                                Text(
                                                    cardData[0].barcode != null
                                                        ? ':${cardData[0].barcode}'
                                                        : '',
                                                    style: tableCardTextRight),
                                                Text(
                                                    cardData[0].disciplineName !=
                                                            null
                                                        ? ':${cardData[0].disciplineName}'
                                                        : '',
                                                    style: tableCardTextRight),
                                                Text(
                                                    cardData[0].assetTypeName !=
                                                            null
                                                        ? ':${cardData[0].assetTypeName}'
                                                        : '',
                                                    style: tableCardTextRight),
                                                Text(
                                                    cardData[0].techSpechName !=
                                                            null
                                                        ? ':${cardData[0].techSpechName}'
                                                        : '',
                                                    style: tableCardTextRight),
                                                Text(
                                                    cardData[0].makeName != null
                                                        ? ':${cardData[0].makeName}'
                                                        : '',
                                                    style: tableCardTextRight),
                                                Text(
                                                    cardData[0].serialNo != null
                                                        ? ':${cardData[0].serialNo}'
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
                                                  Text('Contract',
                                                      style: tableCardTextLeft),
                                                  Text('Spot/Room',
                                                      style: tableCardTextLeft),
                                                  Text('Location (site)',
                                                      style: tableCardTextLeft),
                                                  Text('Wing',
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
                                                      cardData[0].contractName !=
                                                              null
                                                          ? ':${cardData[0].contractName}'
                                                          : '',
                                                      style:
                                                          tableCardTextRight),
                                                  Text(
                                                      cardData[0].spotName !=
                                                              null
                                                          ? ':${cardData[0].spotName}'
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
                                                      cardData[0].wingName !=
                                                              null
                                                          ? ':${cardData[0].wingName}'
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
                                                Text('Building',
                                                    style: tableCardTextLeft),
                                                Text('Region',
                                                    style: tableCardTextLeft),
                                                Text('Floor',
                                                    style: tableCardTextLeft),
                                                Text('Country',
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
                                                    cardData[0].buildingName !=
                                                            null
                                                        ? ':${cardData[0].buildingName}'
                                                        : '',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: tableCardTextRight),
                                                Text(
                                                    cardData[0].regionName !=
                                                            null
                                                        ? ':${cardData[0].regionName}'
                                                        : '',
                                                    style: tableCardTextRight),
                                                Text(
                                                    cardData[0].floorName !=
                                                            null
                                                        ? ':${cardData[0].floorName}'
                                                        : '',
                                                    style: tableCardTextRight),
                                                Text(
                                                    cardData[0].countryName !=
                                                            null
                                                        ? ':${cardData[0].countryName}'
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
              height: 250,
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
                            child: Text('Others', style: cartHeaderStyle),
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
                                                  Text('Purchase Date',
                                                      style: tableCardTextLeft),
                                                  Text('Scrap Value',
                                                      style: tableCardTextLeft),
                                                  Text('Longitude',
                                                      style: tableCardTextLeft),
                                                  Text('Installed Date',
                                                      style: tableCardTextLeft),
                                                  Text('Typical Life(InMonths)',
                                                      style: tableCardTextLeft),
                                                  Text('Enabled For PPM',
                                                      style: tableCardTextLeft),
                                                  Text('Enabled For Inspection',
                                                      style: tableCardTextLeft),
                                                  Text('Scrapped',
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
                                                      cardData[0].purDate !=
                                                              null
                                                          ? ':${cardData[0].purDate}'
                                                          : '',
                                                      style:
                                                          tableCardTextRight),
                                                  Text(
                                                      cardData[0].isScraped !=
                                                              null
                                                          ? ':${cardData[0].isScraped}'
                                                          : '',
                                                      style:
                                                          tableCardTextRight),
                                                  Text(
                                                      cardData[0].longitude !=
                                                              null
                                                          ? ':${cardData[0].longitude}'
                                                          : '',
                                                      style:
                                                          tableCardTextRight),
                                                  Text(
                                                      cardData[0].installedDate !=
                                                              null
                                                          ? ':${cardData[0].installedDate}'
                                                          : '',
                                                      style:
                                                          tableCardTextRight),
                                                  Text(
                                                      cardData[0].lifeInYear !=
                                                              null
                                                          ? ':${cardData[0].lifeInYear}'
                                                          : '',
                                                      style:
                                                          tableCardTextRight),
                                                  Row(
                                                    children: [
                                                      Text(':',
                                                          style:
                                                              tableCardTextRight),
                                                      Container(
                                                          height: 6,
                                                          width: 10,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              color: cardData[0]
                                                                          .isEnablePPM !=
                                                                      "0"
                                                                  ? secondaryColor
                                                                  : trending9)),
                                                      const SizedBox(width: 5),
                                                      Container(
                                                          height: 6,
                                                          width: 10,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              color: cardData[0]
                                                                          .isEnablePPM !=
                                                                      "0"
                                                                  ? secondaryColor
                                                                  : trending9)),
                                                      const SizedBox(width: 5),
                                                      Container(
                                                          height: 6,
                                                          width: 10,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              color: cardData[0]
                                                                          .isEnablePPM !=
                                                                      "0"
                                                                  ? secondaryColor
                                                                  : trending9))
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(':',
                                                          style:
                                                              tableCardTextRight),
                                                      Container(
                                                          height: 6,
                                                          width: 10,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              color: cardData[0]
                                                                          .isEnableDSM !=
                                                                      "0"
                                                                  ? secondaryColor
                                                                  : trending9)),
                                                      const SizedBox(width: 5),
                                                      Container(
                                                          height: 6,
                                                          width: 10,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              color: cardData[0]
                                                                          .isEnableDSM !=
                                                                      "0"
                                                                  ? secondaryColor
                                                                  : trending9)),
                                                      const SizedBox(width: 5),
                                                      Container(
                                                          height: 6,
                                                          width: 10,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              color: cardData[0]
                                                                          .isEnableDSM !=
                                                                      "0"
                                                                  ? secondaryColor
                                                                  : trending9))
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(':',
                                                          style:
                                                              tableCardTextRight),
                                                      Container(
                                                          height: 6,
                                                          width: 10,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              color: cardData[0]
                                                                          .isScraped !=
                                                                      "0"
                                                                  ? secondaryColor
                                                                  : trending9)),
                                                      const SizedBox(width: 5),
                                                      Container(
                                                          height: 6,
                                                          width: 10,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              color: cardData[0]
                                                                          .isScraped !=
                                                                      "0"
                                                                  ? secondaryColor
                                                                  : trending9)),
                                                      const SizedBox(width: 5),
                                                      Container(
                                                          height: 6,
                                                          width: 10,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              color: cardData[0]
                                                                          .isScraped !=
                                                                      "0"
                                                                  ? secondaryColor
                                                                  : trending9))
                                                    ],
                                                  )
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
                                                Text('Remarks',
                                                    style: tableCardTextLeft),
                                                Text('Purchase Value',
                                                    style: tableCardTextLeft),
                                                Text('Year Of Manufacture',
                                                    style: tableCardTextLeft),
                                                Text('Scrap Date',
                                                    style: tableCardTextLeft),
                                                Text('Latitude',
                                                    style: tableCardTextLeft),
                                                Text('Enabled For Helpdesk',
                                                    style: tableCardTextLeft),
                                                Text('Enabled For BMS',
                                                    style: tableCardTextLeft),
                                                Text('Snagged Asset',
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
                                                    cardData[0].lifeInYear !=
                                                            null
                                                        ? ':${cardData[0].lifeInYear}'
                                                        : '',
                                                    style: tableCardTextRight),
                                                Text(
                                                    cardData[0].purValue != null
                                                        ? ':${cardData[0].purValue}'
                                                        : '',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: tableCardTextRight),
                                                Text(
                                                    cardData[0].yearOfManuf !=
                                                            null
                                                        ? ':${cardData[0].yearOfManuf}'
                                                        : '',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: tableCardTextRight),
                                                Text(
                                                    cardData[0].scrapDate !=
                                                            null
                                                        ? ':${cardData[0].scrapDate}'
                                                        : '',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: tableCardTextRight),
                                                Text(
                                                    cardData[0].latitude != null
                                                        ? ':${cardData[0].latitude}'
                                                        : '',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: tableCardTextRight),
                                                Row(
                                                  children: [
                                                    Text(':',
                                                        style:
                                                            tableCardTextRight),
                                                    Container(
                                                        height: 6,
                                                        width: 10,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            color: cardData[0]
                                                                        .isEnableBDM !=
                                                                    "0"
                                                                ? secondaryColor
                                                                : trending9)),
                                                    const SizedBox(width: 5),
                                                    Container(
                                                        height: 6,
                                                        width: 10,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            color: cardData[0]
                                                                        .isEnableBDM !=
                                                                    "0"
                                                                ? secondaryColor
                                                                : trending9)),
                                                    const SizedBox(width: 5),
                                                    Container(
                                                        height: 6,
                                                        width: 10,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            color: cardData[0]
                                                                        .isEnableBDM !=
                                                                    "0"
                                                                ? secondaryColor
                                                                : trending9))
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Text(':',
                                                        style:
                                                            tableCardTextRight),
                                                    Container(
                                                        height: 6,
                                                        width: 10,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            color: cardData[0]
                                                                        .isEnableBMS !=
                                                                    "0"
                                                                ? secondaryColor
                                                                : trending9)),
                                                    const SizedBox(width: 5),
                                                    Container(
                                                        height: 6,
                                                        width: 10,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            color: cardData[0]
                                                                        .isEnableBMS !=
                                                                    "0"
                                                                ? secondaryColor
                                                                : trending9)),
                                                    const SizedBox(width: 5),
                                                    Container(
                                                        height: 6,
                                                        width: 10,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            color: cardData[0]
                                                                        .isEnableBMS !=
                                                                    "0"
                                                                ? secondaryColor
                                                                : trending9))
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Text(':',
                                                        style:
                                                            tableCardTextRight),
                                                    Container(
                                                        height: 6,
                                                        width: 10,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            color: cardData[0]
                                                                        .isSnagged !=
                                                                    "0"
                                                                ? secondaryColor
                                                                : trending9)),
                                                    const SizedBox(width: 5),
                                                    Container(
                                                        height: 6,
                                                        width: 10,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            color: cardData[0]
                                                                        .isSnagged !=
                                                                    "0"
                                                                ? secondaryColor
                                                                : trending9)),
                                                    const SizedBox(width: 5),
                                                    Container(
                                                        height: 6,
                                                        width: 10,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            color: cardData[0]
                                                                        .isSnagged !=
                                                                    "0"
                                                                ? secondaryColor
                                                                : trending9))
                                                  ],
                                                )
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
}

class VwDAssetDetDBoard {
  String? assetIDPK;
  String? assetTagNo;
  String? equipmentName;
  String? equipmentRefNo;
  String? barcode;
  String? serialNo;
  String? techSpechName;
  String? contractCode;
  String? contractName;
  String? assetTypeName;
  String? tradeGroupName;
  String? countryName;
  String? regionName;
  String? locationGroup;
  String? localityName;
  String? buildingName;
  String? floorName;
  String? spotName;
  String? wingName;
  String? divisionName;
  String? disciplineName;
  String? priorityName;
  String? statusName;
  String? conditionName;
  String? makeName;
  String? modelName;
  String? isEnablePPM;
  String? isEnableBDM;
  String? isEnableBMS;
  String? isEnableDSM;
  String? isHouseKeeping;
  String? majorAsset;
  String? assetOwner;
  String? isScraped;
  String? scrapDate;
  String? isSnagged;
  String? equipmentCost;
  String? purValue;
  String? yearOfManuf;
  String? lifeInYear;
  String? installedDate;
  String? purDate;
  String? rFID;
  String? latitude;
  String? longitude;
  String? serviceAreaName;

  VwDAssetDetDBoard(
      {this.assetIDPK,
      this.assetTagNo,
      this.equipmentName,
      this.equipmentRefNo,
      this.barcode,
      this.serialNo,
      this.techSpechName,
      this.contractCode,
      this.contractName,
      this.assetTypeName,
      this.tradeGroupName,
      this.countryName,
      this.regionName,
      this.locationGroup,
      this.localityName,
      this.buildingName,
      this.floorName,
      this.spotName,
      this.wingName,
      this.divisionName,
      this.disciplineName,
      this.priorityName,
      this.statusName,
      this.conditionName,
      this.makeName,
      this.modelName,
      this.isEnablePPM,
      this.isEnableBDM,
      this.isEnableBMS,
      this.isEnableDSM,
      this.isHouseKeeping,
      this.majorAsset,
      this.assetOwner,
      this.isScraped,
      this.scrapDate,
      this.isSnagged,
      this.equipmentCost,
      this.purValue,
      this.yearOfManuf,
      this.lifeInYear,
      this.installedDate,
      this.purDate,
      this.rFID,
      this.latitude,
      this.longitude,
      this.serviceAreaName});

  VwDAssetDetDBoard.fromJson(Map<String, dynamic> json) {
    assetIDPK = json['AssetIDPK'];
    assetTagNo = json['AssetTagNo'];
    equipmentName = json['EquipmentName'];
    equipmentRefNo = json['EquipmentRefNo'];
    barcode = json['Barcode'];
    serialNo = json['SerialNo'];
    techSpechName = json['TechSpechName'];
    contractCode = json['ContractCode'];
    contractName = json['ContractName'];
    assetTypeName = json['AssetTypeName'];
    tradeGroupName = json['TradeGroupName'];
    countryName = json['CountryName'];
    regionName = json['RegionName'];
    locationGroup = json['LocationGroup'];
    localityName = json['LocalityName'];
    buildingName = json['BuildingName'];
    floorName = json['FloorName'];
    spotName = json['SpotName'];
    wingName = json['WingName'];
    divisionName = json['DivisionName'];
    disciplineName = json['DisciplineName'];
    priorityName = json['PriorityName'];
    statusName = json['StatusName'];
    conditionName = json['ConditionName'];
    makeName = json['MakeName'];
    modelName = json['ModelName'];
    isEnablePPM = json['IsEnablePPM'];
    isEnableBDM = json['IsEnableBDM'];
    isEnableBMS = json['IsEnableBMS'];
    isEnableDSM = json['IsEnableDSM'];
    isHouseKeeping = json['IsHouseKeeping'];
    majorAsset = json['MajorAsset'];
    assetOwner = json['AssetOwner'];
    isScraped = json['IsScraped'];
    scrapDate = json['ScrapDate'];
    isSnagged = json['IsSnagged'];
    equipmentCost = json['EquipmentCost'];
    purValue = json['PurValue'];
    yearOfManuf = json['YearOfManuf'];
    lifeInYear = json['LifeInYear'];
    installedDate = json['InstalledDate'];
    purDate = json['PurDate'];
    rFID = json['RFID'];
    latitude = json['Latitude'];
    longitude = json['Longitude'];
    serviceAreaName = json['ServiceAreaName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['AssetIDPK'] = assetIDPK;
    data['AssetTagNo'] = assetTagNo;
    data['EquipmentName'] = equipmentName;
    data['EquipmentRefNo'] = equipmentRefNo;
    data['Barcode'] = barcode;
    data['SerialNo'] = serialNo;
    data['TechSpechName'] = techSpechName;
    data['ContractCode'] = contractCode;
    data['ContractName'] = contractName;
    data['AssetTypeName'] = assetTypeName;
    data['TradeGroupName'] = tradeGroupName;
    data['CountryName'] = countryName;
    data['RegionName'] = regionName;
    data['LocationGroup'] = locationGroup;
    data['LocalityName'] = localityName;
    data['BuildingName'] = buildingName;
    data['FloorName'] = floorName;
    data['SpotName'] = spotName;
    data['WingName'] = wingName;
    data['DivisionName'] = divisionName;
    data['DisciplineName'] = disciplineName;
    data['PriorityName'] = priorityName;
    data['StatusName'] = statusName;
    data['ConditionName'] = conditionName;
    data['MakeName'] = makeName;
    data['ModelName'] = modelName;
    data['IsEnablePPM'] = isEnablePPM;
    data['IsEnableBDM'] = isEnableBDM;
    data['IsEnableBMS'] = isEnableBMS;
    data['IsEnableDSM'] = isEnableDSM;
    data['IsHouseKeeping'] = isHouseKeeping;
    data['MajorAsset'] = majorAsset;
    data['AssetOwner'] = assetOwner;
    data['IsScraped'] = isScraped;
    data['ScrapDate'] = scrapDate;
    data['IsSnagged'] = isSnagged;
    data['EquipmentCost'] = equipmentCost;
    data['PurValue'] = purValue;
    data['YearOfManuf'] = yearOfManuf;
    data['LifeInYear'] = lifeInYear;
    data['InstalledDate'] = installedDate;
    data['PurDate'] = purDate;
    data['RFID'] = rFID;
    data['Latitude'] = latitude;
    data['Longitude'] = longitude;
    data['ServiceAreaName'] = serviceAreaName;
    return data;
  }
}
