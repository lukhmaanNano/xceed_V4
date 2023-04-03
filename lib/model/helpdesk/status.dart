import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gradient_colors/flutter_gradient_colors.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:xceed/Styles/CommonColor.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../../Config.dart';
import '../../Styles/CommonTextStyle.dart';
import '../../Styles/responsive.dart';
import '../../Widgets/mobile/shimmer.dart';
import '../../Widgets/web/helpdesk/cardView.dart';
import '../../Widgets/web/helpdesk/listView.dart';
import '../../Widgets/web/shimmer.dart';

class HelpdeskStatus extends StatefulWidget {
  bool? sideNav, singCardView, detailBackMenu;
  String? pageName;
  final dynamic getFunc;
  HelpdeskStatus(
      {Key? key,
      this.sideNav,
      this.singCardView,
      this.getFunc,
      this.detailBackMenu,
      this.pageName})
      : super(key: key);

  @override
  State<HelpdeskStatus> createState() => _HelpdeskStatusState();
}

class _HelpdeskStatusState extends State<HelpdeskStatus> {
  final _horizontalScrollController = ScrollController();
  final Duration delayed = const Duration(milliseconds: 300);
  bool menuState = true, timer = true, listCard = true;
  int tab = 0;
  String? userName, currentDate, startDate, day = 'Today', pageName;
  int? sessionId, barSeriesId, cardBorder = 0;
  List<dynamic> displayChart = [];
  List<VwDHelpDeskStatusCount> count = [];
  List<VwDHDPopUpGrdDet> chartdataTable = [];
  List<VwDHDPopUpGrdDet> chartdataTable1 = [];
  List<HdByPriority> priority = [];
  List<HDResponse> slaResponse = [];
  List<HDResponse> slaResolve = [];
  List<Building> byBuilding = [];
  List<Analysis> rootCause = [];
  List<Pending> reason = [];
  List<VwDHDStatusServiceTypeWiseCount> servicetotal = [];
  List<VwDHDStatusComplaintTypeWiseCount> complainType = [];
  List<VwDHDStatusOvuerDueDays> overdue = [];
  List<VwDHDStatusStageWiseCount> stage = [];
  List<Total> values = [];
  List<Closed> values1 = [];
  List<Open> values2 = [];
  List<Total> wo1 = [];
  List<Closed> wo2 = [];
  List<Open> wo3 = [];
  List<_SalesData> data = [
    _SalesData('Jan', 35),
    _SalesData('Feb', 28),
    _SalesData('Mar', 34),
    _SalesData('Apr', 32),
    _SalesData('May', 40)
  ];
  List<_ChartData> val = [
    _ChartData('CHN', 12),
    _ChartData('GER', 15),
    _ChartData('RUS', 30),
    _ChartData('BRZ', 6.4),
    _ChartData('IND', 14)
  ];
  final List<secondData> SecondData = [
    secondData('David', 25),
    secondData('Steve', 38),
    secondData('Jack', 34),
    secondData('Others', 52)
  ];
  final List<ChartData> chartData = [
    ChartData('John', 10),
    ChartData('David', 9),
    ChartData('Brit', 10),
  ];
  final List<fourthData> data1 = [
    fourthData('CHN', 12),
    fourthData('GER', 15),
    fourthData('RUS', 30),
    fourthData('BRZ', 6.4),
    fourthData('IND', 14)
  ];
  final List<fourthData> data2 = [
    fourthData('CHN', 15),
    fourthData('GER', 10),
    fourthData('RUS', 12),
    fourthData('BRZ', 4.4),
    fourthData('IND', 28)
  ];
  late String tappedValue, tableName;
  var ComplaintIDPK, containerIndex;

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
      pageName = 'Helpdesk Status';
    });
    divisionApi();
    helpdeskStatusCountApi();
    helpdeskWoTypeApi();
    helpdeskSlaResponseApi();
    helpdeskSlaResolveApi();
    buildingApi();
    rootCauseApi();
    reasonApi();
    serviceTypeWiseCount();
    complaintType();
    processStage();
    local();
  }

  @override
  void dispose() {
    print('Dispose used');
    super.dispose();
  }

  Future<void> local() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('UserName');
      sessionId = prefs.getInt('SessionId')!;
    });
  }

  Future<void> helpdeskStatusCountApi() async {
    String? ip = '/VwDHelpDeskStatusCount/';
    const service = ApiConfig.service;
    final url = Uri.parse('$service$ip');
    final headers = {
      'Accept': 'application/json'
      // 'Content-Type': 'application/json'
    };
    const json =
        '{"data":{"CountryID_varchar":0,"CustomerID_varchar":0,"ContractID_varchar":0,"LocationGroupID_varchar":0,"LocalityID_varchar":0,"BuildingID_varchar":0,"CityID_varchar":0,"FloorID_varchar":0,"SpotID_varchar":0,"DivisionID_varchar":0,"DisciplineID_varchar":0,"ServiceTypeID_varchar":0,"FromDate_datetime":"2022-10-02","ToDate_datetime":"2022-11-01","LocUserID_int":"6","PortalUserID_bit":0}}';
    final response =
        await http.post(url, headers: headers, body: json.toString());
    if (response.statusCode == 400) {
      String err = 'something went wrong!';
    } else {
      final String jsonString = jsonEncode(response.body);
      var decodedJson = jsonDecode(jsonString);
      Map<String, dynamic> map = jsonDecode(decodedJson);
      var result = map['VwDHelpDeskStatusCount'];

      for (Map<String, dynamic> i in result) {
        count.add(VwDHelpDeskStatusCount.fromJson(i));
      }
      timerFunction();
    }
  }

  Future<void> helpdeskPriorityApi() async {
    String? ip = '/VwDHelpDeskPriorityWiseCount/';
    const service = ApiConfig.service;
    final url = Uri.parse('$service$ip');
    final headers = {'Accept': 'application/json'};
    const json =
        '{"data":{"CountryID_varchar":0,"CustomerID_varchar":0,"ContractID_varchar":0,"LocationGroupID_varchar":0,"LocalityID_varchar":0,"BuildingID_varchar":0,"CityID_varchar":0,"FloorID_varchar":0,"SpotID_varchar":0,"DivisionID_varchar":0,"DisciplineID_varchar":0,"ServiceTypeID_varchar":0,"FromDate_datetime":"2022-10-03","ToDate_datetime":"2022-11-02","LocUserID_int":"6","PortalUserID_bit":0}}';
    final response =
        await http.post(url, headers: headers, body: json.toString());
    if (response.statusCode == 400) {
      String err = 'something went wrong!';
    } else {
      final String jsonString = jsonEncode(response.body);
      var decodedJson = jsonDecode(jsonString);
      Map<String, dynamic> map = jsonDecode(decodedJson);
      var result = map['HdByPriority'];

      if (result.isNotEmpty) {
        for (Map<String, dynamic> i in result) {
          priority.add(HdByPriority.fromJson(i));
        }
        timerFunction();
      }
    }
  }

  Future<void> helpdeskSlaResponseApi() async {
    String? ip = '/VwDHelpDeskSLAResponseCount/';
    const service = ApiConfig.service;
    final url = Uri.parse('$service$ip');
    final headers = {'Accept': 'application/json'};
    const json =
        '{"data":{"CountryID_varchar":0,"CustomerID_varchar":0,"ContractID_varchar":0,"LocationGroupID_varchar":0,"LocalityID_varchar":0,"BuildingID_varchar":0,"CityID_varchar":0,"FloorID_varchar":0,"SpotID_varchar":0,"DivisionID_varchar":0,"DisciplineID_varchar":0,"ServiceTypeID_varchar":0,"FromDate_datetime":"2022-10-03","ToDate_datetime":"2022-11-02","LocUserID_int":"6","PortalUserID_bit":0}}';
    final response =
        await http.post(url, headers: headers, body: json.toString());
    if (response.statusCode == 400) {
      String err = 'something went wrong!';
    } else {
      final String jsonString = jsonEncode(response.body);
      var decodedJson = jsonDecode(jsonString);
      Map<String, dynamic> map = jsonDecode(decodedJson);
      var result = map['HDResponse']['chart'];
      for (Map<String, dynamic> i in result) {
        slaResponse.add(HDResponse.fromJson(i));
      }
      timerFunction();
    }
  }

  Future<void> helpdeskSlaResolveApi() async {
    String? ip = '/VwDHelpDeskSLAResolveCount/';
    const service = ApiConfig.service;
    final url = Uri.parse('$service$ip');
    final headers = {'Accept': 'application/json'};
    const json =
        '{"data":{"CountryID_varchar":0,"CustomerID_varchar":0,"ContractID_varchar":0,"LocationGroupID_varchar":0,"LocalityID_varchar":0,"BuildingID_varchar":0,"CityID_varchar":0,"FloorID_varchar":0,"SpotID_varchar":0,"DivisionID_varchar":0,"DisciplineID_varchar":0,"ServiceTypeID_varchar":0,"FromDate_datetime":"2019-10-01","ToDate_datetime":"2019-10-31","LocUserID_int":"6","PortalUserID_bit":0}}';
    final response =
        await http.post(url, headers: headers, body: json.toString());
    if (response.statusCode == 400) {
      String err = 'something went wrong!';
    } else {
      final String jsonString = jsonEncode(response.body);
      var decodedJson = jsonDecode(jsonString);
      Map<String, dynamic> map = jsonDecode(decodedJson);
      var result = map['HdResolve']['chart'];
      for (Map<String, dynamic> i in result) {
        slaResolve.add(HDResponse.fromJson(i));
      }
      timerFunction();
    }
  }

  Future<void> helpdeskOverdueApi() async {
    String? ip = '/VwDHelpDeskPriorityWiseCount/';
    const service = ApiConfig.service;
    final url = Uri.parse('$service$ip');
    final headers = {'Accept': 'application/json'};
    const json =
        '{"data":{"CountryID_varchar":0,"CustomerID_varchar":0,"ContractID_varchar":0,"LocationGroupID_varchar":0,"LocalityID_varchar":0,"BuildingID_varchar":0,"CityID_varchar":0,"FloorID_varchar":0,"SpotID_varchar":0,"DivisionID_varchar":0,"DisciplineID_varchar":0,"ServiceTypeID_varchar":0,"FromDate_datetime":"2022-10-03","ToDate_datetime":"2022-11-02","LocUserID_int":"6","PortalUserID_bit":0}}';
    final response =
        await http.post(url, headers: headers, body: json.toString());
    if (response.statusCode == 400) {
      String err = 'something went wrong!';
    } else {
      final String jsonString = jsonEncode(response.body);
      var decodedJson = jsonDecode(jsonString);
      Map<String, dynamic> map = jsonDecode(decodedJson);
      var result = map['VwDHDStatusOvuerDueDays'][0];
      for (Map<String, dynamic> i in result) {
        overdue.add(VwDHDStatusOvuerDueDays.fromJson(i));
      }
      timerFunction();
    }
  }

  Future<void> divisionApi() async {
    String? ip = '/VwDHDStatusDivisionWiseCount/';
    const service = ApiConfig.service;
    final url = Uri.parse('$service$ip');
    final headers = {
      'Accept': 'application/json'
      // 'Content-Type': 'application/json'
    };
    const json =
        '{"data":{"CountryID_varchar":0,"CustomerID_varchar":0,"ContractID_varchar":0,"LocationGroupID_varchar":0,"LocalityID_varchar":0,"BuildingID_varchar":0,"CityID_varchar":0,"FloorID_varchar":0,"SpotID_varchar":0,"DivisionID_varchar":0,"DisciplineID_varchar":0,"ServiceTypeID_varchar":0,"FromDate_datetime":"2022-10-09","ToDate_datetime":"2022-11-08","LocUserID_int":"6","PortalUserID_bit":0}}';
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
        values.add(Total.fromJson(i));
      }
      for (Map<String, dynamic> i in result1) {
        values1.add(Closed.fromJson(i));
      }
      for (Map<String, dynamic> i in result2) {
        values2.add(Open.fromJson(i));
      }
      timerFunction();
    }
  }

  Future<void> buildingApi() async {
    String? ip = '/VwDHelpDeskBuildingWiseCount/';
    const service = ApiConfig.service;
    final url = Uri.parse('$service$ip');
    final headers = {
      'Accept': 'application/json'
      // 'Content-Type': 'application/json'
    };
    const json =
        '{"data":{"CountryID_varchar":0,"CustomerID_varchar":0,"ContractID_varchar":0,"LocationGroupID_varchar":0,"LocalityID_varchar":0,"BuildingID_varchar":0,"CityID_varchar":0,"FloorID_varchar":0,"SpotID_varchar":0,"DivisionID_varchar":0,"DisciplineID_varchar":0,"ServiceTypeID_varchar":0,"FromDate_datetime":"2020-01-01","ToDate_datetime":"2022-11-05","LocUserID_int":"6","PortalUserID_bit":0}}';
    final response =
        await http.post(url, headers: headers, body: json.toString());
    if (response.statusCode == 400) {
      String err = 'something went wrong!';
    } else {
      final String jsonString = jsonEncode(response.body);
      var decodedJson = jsonDecode(jsonString);
      Map<String, dynamic> map = jsonDecode(decodedJson);
      var result = map['VwDHelpDeskBuildingWiseCount'];
      for (Map<String, dynamic> i in result) {
        byBuilding.add(Building.fromJson(i));
      }
      timerFunction();
    }
  }

  Future<void> rootCauseApi() async {
    String? ip = '/VwDHelpDeskRootCauseAnalysisCount/';
    const service = ApiConfig.service;
    final url = Uri.parse('$service$ip');
    final headers = {
      'Accept': 'application/json'
      // 'Content-Type': 'application/json'
    };
    const json =
        '{"data":{"CountryID_varchar":0,"CustomerID_varchar":0,"ContractID_varchar":0,"LocationGroupID_varchar":0,"LocalityID_varchar":0,"BuildingID_varchar":0,"CityID_varchar":0,"FloorID_varchar":0,"SpotID_varchar":0,"DivisionID_varchar":0,"DisciplineID_varchar":0,"ServiceTypeID_varchar":0,"FromDate_datetime":"2020-01-01","ToDate_datetime":"2022-11-05","LocUserID_int":"6","PortalUserID_bit":0}}';
    final response =
        await http.post(url, headers: headers, body: json.toString());
    if (response.statusCode == 400) {
      String err = 'something went wrong!';
    } else {
      final String jsonString = jsonEncode(response.body);
      var decodedJson = jsonDecode(jsonString);
      Map<String, dynamic> map = jsonDecode(decodedJson);
      var result = map['HdRootCause'];
      for (Map<String, dynamic> i in result) {
        rootCause.add(Analysis.fromJson(i));
      }
      timerFunction();
    }
  }

  Future<void> reasonApi() async {
    String? ip = '/VwDHelpDeskReasonForPendingCount/';
    const service = ApiConfig.service;
    final url = Uri.parse('$service$ip');
    final headers = {'Accept': 'application/json'};
    const json =
        '{"data":{"CountryID_varchar":0,"CustomerID_varchar":0,"ContractID_varchar":0,"LocationGroupID_varchar":0,"LocalityID_varchar":0,"BuildingID_varchar":0,"CityID_varchar":0,"FloorID_varchar":0,"SpotID_varchar":0,"DivisionID_varchar":0,"DisciplineID_varchar":0,"ServiceTypeID_varchar":0,"FromDate_datetime":"2020-01-01","ToDate_datetime":"2022-11-05","LocUserID_int":"6","PortalUserID_bit":0}}';
    final response =
        await http.post(url, headers: headers, body: json.toString());
    if (response.statusCode == 400) {
      String err = 'something went wrong!';
    } else {
      final String jsonString = jsonEncode(response.body);
      var decodedJson = jsonDecode(jsonString);
      Map<String, dynamic> map = jsonDecode(decodedJson);
      var result = map['VwDHelpDeskReasonForPendingCount'];
      for (Map<String, dynamic> i in result) {
        reason.add(Pending.fromJson(i));
      }
      timerFunction();
    }
  }

  Future<void> helpdeskWoTypeApi() async {
    String? ip = '/VwDHDStatusWoTypeWiseCount/';
    const service = ApiConfig.service;
    final url = Uri.parse('$service$ip');
    final headers = {'Accept': 'application/json'};
    const json =
        '{"data":{"CountryID_varchar":0,"CustomerID_varchar":0,"ContractID_varchar":0,"LocationGroupID_varchar":0,"LocalityID_varchar":0,"BuildingID_varchar":0,"CityID_varchar":0,"FloorID_varchar":0,"SpotID_varchar":0,"DivisionID_varchar":0,"DisciplineID_varchar":0,"ServiceTypeID_varchar":0,"FromDate_datetime":"2020-01-01","ToDate_datetime":"2022-11-07","LocUserID_int":"6","PortalUserID_bit":0}}';
    final response =
        await http.post(url, headers: headers, body: json.toString());
    if (response.statusCode == 400) {
      String err = 'something went wrong!';
    } else {
      final String jsonString = jsonEncode(response.body);
      var decodedJson = jsonDecode(jsonString);
      Map<String, dynamic> map = jsonDecode(decodedJson);
      var result = map['ByWOType']['Total'];
      var result1 = map['ByWOType']['Closed'];
      var result2 = map['ByWOType']['Open'];
      for (Map<String, dynamic> i in result) {
        wo1.add(Total.fromJson(i));
      }
      for (Map<String, dynamic> i in result1) {
        wo2.add(Closed.fromJson(i));
      }
      for (Map<String, dynamic> i in result2) {
        wo3.add(Open.fromJson(i));
      }
      timerFunction();
    }
  }

  Future<void> serviceTypeWiseCount() async {
    String? ip = '/VwDHDStatusServiceTypeWiseCount/';
    const service = ApiConfig.service;
    final url = Uri.parse('$service$ip');
    final headers = {'Accept': 'application/json'};
    const json =
        '{"data":{"CountryID_varchar":0,"CustomerID_varchar":0,"ContractID_varchar":0,"LocationGroupID_varchar":0,"LocalityID_varchar":0,"BuildingID_varchar":0,"CityID_varchar":0,"FloorID_varchar":0,"SpotID_varchar":0,"DivisionID_varchar":0,"DisciplineID_varchar":0,"ServiceTypeID_varchar":0,"FromDate_datetime":"2023-01-23","ToDate_datetime":"2023-02-22","LocUserID_int":"6","PortalUserID_bit":0}}';
    final response =
        await http.post(url, headers: headers, body: json.toString());
    if (response.statusCode == 400) {
      String err = 'something went wrong!';
    } else {
      final String jsonString = jsonEncode(response.body);
      var decodedJson = jsonDecode(jsonString);
      Map<String, dynamic> map = jsonDecode(decodedJson);
      var result = map['VwDHDStatusServiceTypeWiseCount'];
      for (Map<String, dynamic> i in result) {
        servicetotal.add(VwDHDStatusServiceTypeWiseCount.fromJson(i));
      }

      timerFunction();
    }
  }

  Future<void> complaintType() async {
    String? ip = '/VwDHDStatusComplaintTypeWiseCount/';
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
      var result = map['VwDHDStatusComplaintTypeWiseCount'];
      for (Map<String, dynamic> i in result) {
        complainType.add(VwDHDStatusComplaintTypeWiseCount.fromJson(i));
      }

      timerFunction();
    }
  }

  Future<void> processStage() async {
    String? ip = '/VwDHDStatusStageWiseCount/';
    const service = ApiConfig.service;
    final url = Uri.parse('$service$ip');
    final headers = {'Accept': 'application/json'};
    const json =
        '{"data":{"CountryID_varchar":0,"CustomerID_varchar":0,"ContractID_varchar":0,"LocationGroupID_varchar":0,"LocalityID_varchar":0,"BuildingID_varchar":0,"CityID_varchar":0,"FloorID_varchar":0,"SpotID_varchar":0,"DivisionID_varchar":0,"DisciplineID_varchar":0,"ServiceTypeID_varchar":0,"FromDate_datetime":"2023-01-25","ToDate_datetime":"2023-02-24","LocUserID_int":"6","PortalUserID_bit":0}}';
    final response =
        await http.post(url, headers: headers, body: json.toString());
    if (response.statusCode == 400) {
      String err = 'something went wrong!';
    } else {
      final String jsonString = jsonEncode(response.body);
      var decodedJson = jsonDecode(jsonString);
      Map<String, dynamic> map = jsonDecode(decodedJson);
      var result = map['VwDHDStatusStageWiseCount'];
      for (Map<String, dynamic> i in result) {
        stage.add(VwDHDStatusStageWiseCount.fromJson(i));
      }

      timerFunction();
    }
  }

  Future<void> chartTappedDataTable(tappedValue) async {
    cardBorder = 1;
    displayChartWidget();
    setState(() {
      displayChart.insert(0, displayChart.removeAt(6));
    });
    chartdataTable1.clear();
    String? ip = '/VwDHDPopUpGrdDet/';
    const service = ApiConfig.service;
    final url = Uri.parse('$service$ip');
    final headers = {'Accept': 'application/json'};
    final json =
        '{"data":{"CountryID_varchar":0,"CustomerID_varchar":0,"ContractID_varchar":0,"LocationGroupID_varchar":0,"LocalityID_varchar":0,"BuildingID_varchar":0,"CityID_varchar":0,"FloorID_varchar":0,"SpotID_varchar":0,"DivisionID_varchar":0,"DisciplineID_varchar":0,"ServiceTypeID_varchar":0,"FromDate_datetime":"2022-10-09","ToDate_datetime":"2022-11-08","LocUserID_int":"6","PortalUserID_bit":0,"HeaderID_int":19,"DataParam_varchar":"$tappedValue","PageIndex_int":1,"PageSize_int":10,"ResultCount_int":null}}';
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
    setState(() {
      widget.singCardView = true;
      widget.detailBackMenu = true;
      widget.sideNav = false;
      widget.pageName = '$tableName - $tappedValue';
    });
    widget.getFunc(widget.sideNav, widget.pageName, widget.detailBackMenu, 1);
  }

  Future<void> chartTappedDataTable1() async {
    cardBorder = 2;
    displayChartWidget();
    setState(() {
      displayChart.insert(0, displayChart.removeAt(7));
    });
    chartdataTable1.clear();
    String? ip = '/VwDHDPopUpGrdDet/';
    const service = ApiConfig.service;
    final url = Uri.parse('$service$ip');
    final headers = {'Accept': 'application/json'};
    final json =
        '{"data":{"CountryID_varchar":0,"CustomerID_varchar":0,"ContractID_varchar":0,"LocationGroupID_varchar":0,"LocalityID_varchar":0,"BuildingID_varchar":0,"CityID_varchar":0,"FloorID_varchar":0,"SpotID_varchar":0,"DivisionID_varchar":0,"DisciplineID_varchar":0,"ServiceTypeID_varchar":0,"FromDate_datetime":"2022-10-11","ToDate_datetime":"2022-11-10","LocUserID_int":"6","PortalUserID_bit":0,"HeaderID_int":$barSeriesId,"DataParam_varchar":"","PageIndex_int":1,"PageSize_int":10,"ResultCount_int":null}}';
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
    setState(() {
      widget.singCardView = true;
      widget.detailBackMenu = true;
      widget.sideNav = false;
      widget.pageName = '$tableName - $tappedValue';
    });
    widget.getFunc(widget.sideNav, widget.pageName, widget.detailBackMenu, 1);
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
                            : helpdeskStatusChart(),
                      ),
                      Flexible(
                        flex: 2,
                        child: timer == true
                            ? webShimmer(shimmerHeight)
                            : woTypeChart(),
                      ),
                      Flexible(
                        flex: 2,
                        child: overDueChart(),
                      ),
                      Flexible(
                        flex: 2,
                        child: timer == true
                            ? webShimmer(shimmerHeight)
                            : byComplaintChart(),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        flex: 2,
                        child: timer == true
                            ? webShimmer(shimmerHeight)
                            : slaChart(),
                      ),
                      Flexible(
                        flex: 2,
                        child: approvalChart(),
                      ),
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
                            : slaResponseChart(),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        flex: 2,
                        child: timer == true
                            ? webShimmer(220)
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
                                                                    .totalCnt ==
                                                                null
                                                            ? const Text(
                                                                '',
                                                                style: rowstyle)
                                                            : Text(
                                                                '${tabelJson.totalCnt}',
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
                                                                      .closedCnt ==
                                                                  null
                                                              ? const Text(
                                                                  '',
                                                                  style:
                                                                      rowstyle)
                                                              : Text(
                                                                  '${tabelJson.closedCnt}',
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
                      ),
                      Flexible(
                        flex: 2,
                        child: timer == true
                            ? webShimmer(220)
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
                                            Text('Root Cause Analysis',
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
                                              0: FlexColumnWidth(2),
                                              1: FlexColumnWidth(1),
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
                                                      child: Text('Root Cause',
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: columnStyle),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      child: Text('Count',
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: columnStyle),
                                                    ),
                                                  ]),
                                              for (var tabelJson
                                                  in rootCause.sublist(0, 5))
                                                TableRow(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: tabelJson
                                                                  .label ==
                                                              null
                                                          ? const Text('',
                                                              style: rowstyle)
                                                          : Text(
                                                              '${tabelJson.label}',
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
                                                        child: tabelJson.y ==
                                                                null
                                                            ? const Text('',
                                                                style: rowstyle)
                                                            : Text(
                                                                '${tabelJson.y}',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style:
                                                                    rowstyle),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                            ]),
                                      ),
                                    ],
                                  ),
                                ),
                                // SfCartesianChart(
                                //     plotAreaBorderWidth: 0,
                                //     tooltipBehavior: TooltipBehavior(enable: true),
                                //     title: ChartTitle(
                                //         text: 'HelpDesk Month Wise Status',
                                //         textStyle: const TextStyle(
                                //             overflow: TextOverflow.ellipsis,
                                //             fontSize: 12,
                                //             color: secondaryColor,
                                //             fontWeight: FontWeight.w700)),
                                //     legend: Legend(
                                //       isVisible: true,
                                //     ),
                                //     primaryXAxis: CategoryAxis(
                                //       isVisible: false,
                                //     ),
                                //     primaryYAxis: NumericAxis(
                                //         minimum: 0, maximum: 40, interval: 10),
                                //     series: <ChartSeries<_ChartData, String>>[
                                //       ColumnSeries<_ChartData, String>(
                                //           dataLabelSettings: const DataLabelSettings(
                                //               labelAlignment:
                                //                   ChartDataLabelAlignment.middle,
                                //               color: Colors.black,
                                //               isVisible: true),
                                //           borderRadius: const BorderRadius.only(
                                //               topLeft: Radius.circular(25),
                                //               topRight: Radius.circular(25)),
                                //           dataSource: val,
                                //           xValueMapper: (_ChartData data, _) => data.x,
                                //           yValueMapper: (_ChartData data, _) => data.y,
                                //           name: 'Gold',
                                //           gradient: const LinearGradient(
                                //               colors: GradientColors.nightSky),
                                //           color: secondaryColor)
                                //     ]),
                              ),
                      ),
                      Flexible(
                        flex: 2,
                        child: timer == true
                            ? webShimmer(220)
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
                                            Text('Reason For Pending',
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
                                              0: FlexColumnWidth(2),
                                              1: FlexColumnWidth(1),
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
                                                      child: Text('Reason',
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: columnStyle),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      child: Text('Count',
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: columnStyle),
                                                    ),
                                                  ]),
                                              for (var tabelJson in reason)
                                                TableRow(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: tabelJson.cCMResonName ==
                                                              null
                                                          ? const Text('',
                                                              style: rowstyle)
                                                          : Text(
                                                              '${tabelJson.cCMResonName}',
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
                                                                    .rCCount ==
                                                                null
                                                            ? const Text(
                                                                '',
                                                                style: rowstyle)
                                                            : Text(
                                                                '${tabelJson.rCCount}',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style:
                                                                    rowstyle),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                            ]),
                                      ),
                                    ],
                                  ),
                                ),
                                // SfCartesianChart(
                                //     plotAreaBorderWidth: 0,
                                //     title: ChartTitle(
                                //         text: 'HelpDesk Trend',
                                //         textStyle: const TextStyle(
                                //             overflow: TextOverflow.ellipsis,
                                //             fontSize: 12,
                                //             color: secondaryColor,
                                //             fontWeight: FontWeight.w600)),
                                //     legend: Legend(
                                //       isVisible: true,
                                //     ),
                                //     primaryXAxis: CategoryAxis(
                                //       isVisible: false,
                                //     ),
                                //     primaryYAxis: NumericAxis(
                                //         minimum: 0, maximum: 40, interval: 10),
                                //     tooltipBehavior: TooltipBehavior(enable: true),
                                //     series: <ChartSeries>[
                                //       BubbleSeries<_ChartData, String>(
                                //         dataLabelSettings: const DataLabelSettings(
                                //             color: Colors.black, isVisible: true),
                                //         dataSource: val,
                                //         xValueMapper: (_ChartData data, _) => data.x,
                                //         yValueMapper: (_ChartData data, _) => data.y,
                                //         name: 'Gold',
                                //         gradient: const LinearGradient(
                                //             colors: GradientColors.juicyOrange),
                                //       ),
                                //       BubbleSeries<fourthData, String>(
                                //         dataLabelSettings: const DataLabelSettings(
                                //             color: Colors.black, isVisible: true),
                                //         dataSource: data2,
                                //         xValueMapper: (fourthData data, _) => data.x,
                                //         yValueMapper: (fourthData data, _) => data.y,
                                //         name: 'Gold2',
                                //         gradient: const LinearGradient(
                                //             colors: GradientColors.purpleLove),
                                //       )
                                //     ]),
                              ),
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
                child: Card(
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
                                child: Text(' By Service Type',
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
                                isVisible: false,
                                // name:
                                //     '${(VwDHDStatusServiceTypeWiseCount data, _) => data.serviceTypeName}',
                              ),
                              primaryYAxis: NumericAxis(
                                  minimum: 0, maximum: 40, interval: 10),
                              series: <ChartSeries>[
                                AreaSeries<VwDHDStatusServiceTypeWiseCount,
                                    dynamic>(
                                  dataLabelSettings: const DataLabelSettings(
                                      labelAlignment:
                                          ChartDataLabelAlignment.middle,
                                      color: Colors.black,
                                      isVisible: true),
                                  dataSource: servicetotal,
                                  name: 'Total',
                                  xAxisName:
                                      '${(VwDHDStatusServiceTypeWiseCount data, _) => data.serviceTypeCode}',
                                  xValueMapper:
                                      (VwDHDStatusServiceTypeWiseCount data,
                                              _) =>
                                          data.serviceTypeName,
                                  yValueMapper:
                                      (VwDHDStatusServiceTypeWiseCount data,
                                              _) =>
                                          int.parse('${data.total}'),
                                  gradient: const LinearGradient(
                                      colors: GradientColors.orangePink),
                                ),
                                AreaSeries<VwDHDStatusServiceTypeWiseCount,
                                    String>(
                                  dataLabelSettings: const DataLabelSettings(
                                      labelAlignment:
                                          ChartDataLabelAlignment.middle,
                                      color: Colors.black,
                                      isVisible: true),
                                  dataSource: servicetotal,
                                  xValueMapper:
                                      (VwDHDStatusServiceTypeWiseCount data,
                                              _) =>
                                          data.serviceTypeName,
                                  yValueMapper:
                                      (VwDHDStatusServiceTypeWiseCount data,
                                              _) =>
                                          int.parse('${data.openCnt}'),
                                  name: 'Open',
                                  gradient: const LinearGradient(
                                      colors: GradientColors.juicyOrange),
                                ),
                                AreaSeries<VwDHDStatusServiceTypeWiseCount,
                                    String>(
                                  dataLabelSettings: const DataLabelSettings(
                                      labelAlignment:
                                          ChartDataLabelAlignment.middle,
                                      color: Colors.black,
                                      isVisible: true),
                                  dataSource: servicetotal,
                                  xValueMapper:
                                      (VwDHDStatusServiceTypeWiseCount data,
                                              _) =>
                                          data.serviceTypeName,
                                  yValueMapper:
                                      (VwDHDStatusServiceTypeWiseCount data,
                                              _) =>
                                          int.parse('${data.closed}'),
                                  name: 'Close',
                                  gradient: const LinearGradient(
                                      colors: GradientColors.indigo),
                                )
                              ]),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 2,
                child: Card(
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
                                child: Text(
                                    ' Level of Completion-Process Stage',
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
                              tooltipBehavior: TooltipBehavior(
                                enable: true,
                              ),
                              legend: Legend(isVisible: true),
                              primaryYAxis:
                                  NumericAxis(minimum: 1, maximum: 10),
                              primaryXAxis: CategoryAxis(isVisible: true),
                              series: <ChartSeries>[
                                StackedBarSeries<VwDHDStatusStageWiseCount,
                                        String>(
                                    dataLabelSettings: const DataLabelSettings(
                                        labelAlignment:
                                            ChartDataLabelAlignment.middle,
                                        textStyle: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600),
                                        isVisible: true,
                                        color: trending14,
                                        showCumulativeValues: true),
                                    borderRadius: const BorderRadius.only(
                                        bottomLeft: Radius.circular(15),
                                        bottomRight: Radius.circular(15),
                                        topRight: Radius.circular(15),
                                        topLeft: Radius.circular(15)),
                                    color: trending12,
                                    name: 'Stages',
                                    dataSource: stage,
                                    xValueMapper:
                                        (VwDHDStatusStageWiseCount data, _) =>
                                            data.label,
                                    yValueMapper:
                                        (VwDHDStatusStageWiseCount data, _) =>
                                            int.parse('${data.y}')),
                                // StackedBarSeries<ChartData, String>(
                                //     dataLabelSettings: const DataLabelSettings(
                                //         labelAlignment:
                                //             ChartDataLabelAlignment.middle,
                                //         textStyle: TextStyle(
                                //             fontSize: 18,
                                //             fontWeight: FontWeight.w600),
                                //         isVisible: true,
                                //         showCumulativeValues: true),
                                //     name: 'Gold1',
                                //     color: trending13,
                                //     dataSource: chartData,
                                //     xValueMapper: (ChartData data, _) => data.x,
                                //     yValueMapper: (ChartData data, _) =>
                                //         data.y),
                                // StackedBarSeries<ChartData, String>(
                                //     dataLabelSettings: const DataLabelSettings(
                                //         labelAlignment:
                                //             ChartDataLabelAlignment.middle,
                                //         textStyle: TextStyle(
                                //             fontSize: 18,
                                //             fontWeight: FontWeight.w600),
                                //         isVisible: true,
                                //         showCumulativeValues: true),
                                //     name: 'Gold2',
                                //     color: trending14,
                                //     dataSource: chartData,
                                //     xValueMapper: (ChartData data, _) => data.x,
                                //     yValueMapper: (ChartData data, _) =>
                                //         data.y),
                                // StackedBarSeries<ChartData, String>(
                                //     dataLabelSettings: const DataLabelSettings(
                                //         labelAlignment:
                                //             ChartDataLabelAlignment.middle,
                                //         textStyle: TextStyle(
                                //             fontSize: 18,
                                //             fontWeight: FontWeight.w600),
                                //         isVisible: true,
                                //         showCumulativeValues: true),
                                //     name: 'Gold3',
                                //     borderRadius: const BorderRadius.only(
                                //         topRight: Radius.circular(15),
                                //         bottomRight: Radius.circular(15)),
                                //     color: trending15,
                                //     dataSource: chartData,
                                //     xValueMapper: (ChartData data, _) => data.x,
                                //     yValueMapper: (ChartData data, _) => data.y)
                              ]),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 2,
                child: Card(
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
                                  child: Text(
                                      ' HelpDesk Month Wise Performance Status',
                                      style: cartHeaderStyle),
                                ),
                                Icon(Icons.mail, color: secondaryColor),
                              ],
                            ),
                          ),
                          Flexible(
                            flex: 2,
                            child: SfCartesianChart(
                                tooltipBehavior: TooltipBehavior(enable: true),
                                plotAreaBorderWidth: 0,
                                legend: Legend(
                                  isVisible: true,
                                ),
                                primaryXAxis: CategoryAxis(
                                  isVisible: false,
                                ),
                                series: <ChartSeries>[
                                  StackedColumn100Series<ChartData, String>(
                                      borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(15),
                                          bottomRight: Radius.circular(15)),
                                      // gradient: const LinearGradient(
                                      //     colors: GradientColors.freshMilk),
                                      color: trending9,
                                      dataSource: chartData,
                                      name: 'Gold',
                                      xValueMapper: (ChartData data, _) =>
                                          data.x,
                                      yValueMapper: (ChartData data, _) =>
                                          data.y),
                                  StackedColumn100Series<ChartData, String>(
                                      // gradient: const LinearGradient(
                                      //     colors: GradientColors.warmFlame),
                                      color: trending10,
                                      dataSource: chartData,
                                      name: 'Gold1',
                                      xValueMapper: (ChartData data, _) =>
                                          data.x,
                                      yValueMapper: (ChartData data, _) =>
                                          data.y),
                                  StackedColumn100Series<ChartData, String>(
                                      // gradient: const LinearGradient(
                                      //     colors: GradientColors.gentleCare),
                                      color: trending11,
                                      name: 'Gold2',
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(15),
                                          topRight: Radius.circular(15)),
                                      dataSource: chartData,
                                      xValueMapper: (ChartData data, _) =>
                                          data.x,
                                      yValueMapper: (ChartData data, _) =>
                                          data.y)
                                ]),
                          ),
                        ],
                      ),
                    )),
              )
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
                        // Row(children: [
                        //   Flexible(
                        //     flex: 2,
                        //     child: timer == true
                        //         ? webShimmer(shimmerHeight)
                        //         : woTypeChart(),
                        //   )
                        // ]),
                        // Row(children: [
                        //   Flexible(
                        //     flex: 2,
                        //     child: overDueChart(),
                        //   )
                        // ]),
                        // Row(children: [
                        //   Flexible(
                        //     flex: 2,
                        //     child: byComplaintChart(),
                        //   )
                        // ]),
                        // Row(children: [
                        //   Flexible(
                        //     flex: 2,
                        //     child: timer == true
                        //         ? webShimmer(shimmerHeight)
                        //         : slaChart(),
                        //   )
                        // ]),
                        // Row(children: [
                        //   Flexible(
                        //     flex: 2,
                        //     child: approvalChart(),
                        //   )
                        // ]),
                        // Row(children: [
                        //   Flexible(
                        //     flex: 2,
                        //     child: timer == true
                        //         ? webShimmer(shimmerHeight)
                        //         : divisionChart(),
                        //   )
                        // ]),
                        // Row(children: [
                        //   Flexible(
                        //     flex: 2,
                        //     child: timer == true
                        //         ? webShimmer(shimmerHeight)
                        //         : slaResponseChart(),
                        //   )
                        // ]),
                        // Row(children: [
                        //   Flexible(
                        //     flex: 2,
                        //     child: timer == true
                        //         ? webShimmer(220)
                        //         : byBuildingTable(),
                        //   )
                        // ]),
                        // Row(children: [
                        //   Flexible(
                        //     flex: 2,
                        //     child: timer == true
                        //         ? webShimmer(220)
                        //         : rootCauseTable(),
                        //   )
                        // ]),
                        // Row(children: [
                        //   Flexible(
                        //     flex: 2,
                        //     child: timer == true
                        //         ? webShimmer(220)
                        //         : reasonForPendingTable(),
                        //   )
                        // ]),
                        // Row(children: [
                        //   Flexible(
                        //     flex: 2,
                        //     child: timer == true
                        //         ? webShimmer(220)
                        //         : byServiceTypeChart(),
                        //   )
                        // ]),
                        // Row(children: [
                        //   Flexible(
                        //     flex: 2,
                        //     child: timer == true
                        //         ? webShimmer(220)
                        //         : levelOfCompletionChart(),
                        //   )
                        // ]),
                        // Row(children: [
                        //   Flexible(
                        //     flex: 2,
                        //     child: timer == true
                        //         ? webShimmer(220)
                        //         : helpDeskMonthWiseChart(),
                        //   )
                        // ]),
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
      child: HelpdeskListView(
          data: chartdataTable1,
          tappedValue: tappedValue,
          tableName: tableName),
    );
  }

  Widget cardView() {
    final scaleFactor = MediaQuery.of(context).textScaleFactor;
    return Flexible(
      flex: 2,
      child: HelpdeskCardView(
          data: chartdataTable1,
          tappedValue: tappedValue,
          tableName: tableName),
    );
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
                            : helpdeskStatusChart(),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        flex: 2,
                        child: timer == true
                            ? MobileShimmer(shimmerHeight)
                            : woTypeChart(),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        flex: 2,
                        child: overDueChart(),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        flex: 2,
                        child: byComplaintChart(),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        flex: 2,
                        child: timer == true
                            ? MobileShimmer(shimmerHeight)
                            : slaChart(),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(flex: 2, child: approvalChart()),
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
                        child: Card(
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
                                          child: Text(' By Service Type',
                                              style: cartHeaderStyle)),
                                      Icon(Icons.mail, color: secondaryColor),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 260,
                                  child: SfCartesianChart(
                                      plotAreaBorderWidth: 0,
                                      tooltipBehavior:
                                          TooltipBehavior(enable: true),
                                      legend: Legend(isVisible: true),
                                      primaryXAxis: CategoryAxis(
                                        isVisible: false,
                                      ),
                                      primaryYAxis: NumericAxis(
                                          minimum: 0,
                                          maximum: 40,
                                          interval: 10),
                                      series: <ChartSeries>[
                                        AreaSeries<fourthData, String>(
                                          dataLabelSettings:
                                              const DataLabelSettings(
                                                  labelAlignment:
                                                      ChartDataLabelAlignment
                                                          .middle,
                                                  color: Colors.black,
                                                  isVisible: true),
                                          dataSource: data1,
                                          name: 'Gold',
                                          xValueMapper: (fourthData data, _) =>
                                              data.x,
                                          yValueMapper: (fourthData data, _) =>
                                              data.y,
                                          gradient: const LinearGradient(
                                              colors:
                                                  GradientColors.orangePink),
                                        ),
                                        AreaSeries<fourthData, String>(
                                          dataSource: data2,
                                          xValueMapper: (fourthData data, _) =>
                                              data.x,
                                          yValueMapper: (fourthData data, _) =>
                                              data.y,
                                          name: 'Gold',
                                          gradient: const LinearGradient(
                                              colors:
                                                  GradientColors.juicyOrange),
                                        )
                                      ]),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(children: [
                    Flexible(
                      flex: 2,
                      child: Card(
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
                                              ' HelpDesk Month Wise Performance Status',
                                              style: cartHeaderStyle)),
                                      Icon(Icons.mail, color: secondaryColor),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 260,
                                  child: SfCartesianChart(
                                      tooltipBehavior:
                                          TooltipBehavior(enable: true),
                                      plotAreaBorderWidth: 0,
                                      legend: Legend(
                                        isVisible: true,
                                      ),
                                      primaryXAxis: CategoryAxis(
                                        isVisible: false,
                                      ),
                                      series: <ChartSeries>[
                                        StackedColumn100Series<ChartData,
                                                String>(
                                            borderRadius:
                                                const BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(15),
                                                    bottomRight:
                                                        Radius.circular(15)),
                                            // gradient: const LinearGradient(
                                            //     colors: GradientColors.freshMilk),
                                            color: trending9,
                                            dataSource: chartData,
                                            name: 'Gold',
                                            xValueMapper: (ChartData data, _) =>
                                                data.x,
                                            yValueMapper: (ChartData data, _) =>
                                                data.y),
                                        StackedColumn100Series<ChartData,
                                                String>(
                                            // gradient: const LinearGradient(
                                            //     colors: GradientColors.warmFlame),
                                            color: trending10,
                                            dataSource: chartData,
                                            name: 'Gold1',
                                            xValueMapper: (ChartData data, _) =>
                                                data.x,
                                            yValueMapper: (ChartData data, _) =>
                                                data.y),
                                        StackedColumn100Series<ChartData,
                                                String>(
                                            // gradient: const LinearGradient(
                                            //     colors: GradientColors.gentleCare),
                                            color: trending11,
                                            name: 'Gold2',
                                            borderRadius:
                                                const BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(15),
                                                    topRight:
                                                        Radius.circular(15)),
                                            dataSource: chartData,
                                            xValueMapper: (ChartData data, _) =>
                                                data.x,
                                            yValueMapper: (ChartData data, _) =>
                                                data.y)
                                      ]),
                                ),
                              ],
                            ),
                          )),
                    )
                  ]),
                  Row(
                    children: [
                      Flexible(
                        flex: 2,
                        child: timer == true
                            ? MobileShimmer(shimmerHeight)
                            : slaResponseChart(),
                      )
                    ],
                  ),
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
                                elevation: 3,
                                shadowColor: Colors.transparent,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                                          Radius.circular(8.0),
                                                      topRight:
                                                          Radius.circular(8.0),
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
                                                    child: tabelJson
                                                                .buildingName ==
                                                            null
                                                        ? const Text('',
                                                            style: rowstyle)
                                                        : Text('${tabelJson.buildingName}',
                                                            textAlign:
                                                                TextAlign.start,
                                                            style: rowstyle),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Center(
                                                      child: tabelJson
                                                                  .totalCnt ==
                                                              null
                                                          ? const Text(
                                                              '',
                                                              style: rowstyle)
                                                          : Text(
                                                              '${tabelJson.totalCnt}',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: rowstyle),
                                                    ),
                                                  ),
                                                  Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Center(
                                                        child: tabelJson
                                                                    .openCnt ==
                                                                null
                                                            ? const Text(
                                                                '',
                                                                style: rowstyle)
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
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Center(
                                                        child: tabelJson
                                                                    .closedCnt ==
                                                                null
                                                            ? const Text(
                                                                '',
                                                                style: rowstyle)
                                                            : Text(
                                                                '${tabelJson.closedCnt}',
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
                      )
                    ],
                  ),
                  Row(children: [
                    Flexible(
                      flex: 2,
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: const [
                                        Text('Root Cause Analysis',
                                            style: cartHeaderStyle),
                                        Icon(Icons.mail, color: secondaryColor),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, right: 8.0, bottom: 8.0),
                                    child: Table(
                                        columnWidths: const {
                                          0: FlexColumnWidth(2),
                                          1: FlexColumnWidth(1),
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
                                                        Radius.circular(8.0),
                                                    topRight:
                                                        Radius.circular(8.0),
                                                  ),
                                                  color: secondaryColor),
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Text('Root Cause',
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: columnStyle),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Text('Count',
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: columnStyle),
                                                ),
                                              ]),
                                          for (var tabelJson
                                              in rootCause.sublist(0, 5))
                                            TableRow(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: tabelJson.label == null
                                                      ? const Text('',
                                                          style: rowstyle)
                                                      : Text(
                                                          '${tabelJson.label}',
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: rowstyle),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Center(
                                                    child: tabelJson.y == null
                                                        ? const Text('',
                                                            style: rowstyle)
                                                        : Text('${tabelJson.y}',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: rowstyle),
                                                  ),
                                                ),
                                              ],
                                            )
                                        ]),
                                  ),
                                ],
                              ),
                              // SfCartesianChart(
                              //     plotAreaBorderWidth: 0,
                              //     tooltipBehavior: TooltipBehavior(enable: true),
                              //     title: ChartTitle(
                              //         text: 'HelpDesk Month Wise Status',
                              //         textStyle: const TextStyle(
                              //             overflow: TextOverflow.ellipsis,
                              //             fontSize: 12,
                              //             color: secondaryColor,
                              //             fontWeight: FontWeight.w700)),
                              //     legend: Legend(
                              //       isVisible: true,
                              //     ),
                              //     primaryXAxis: CategoryAxis(
                              //       isVisible: false,
                              //     ),
                              //     primaryYAxis: NumericAxis(
                              //         minimum: 0, maximum: 40, interval: 10),
                              //     series: <ChartSeries<_ChartData, String>>[
                              //       ColumnSeries<_ChartData, String>(
                              //           dataLabelSettings: const DataLabelSettings(
                              //               labelAlignment:
                              //                   ChartDataLabelAlignment.middle,
                              //               color: Colors.black,
                              //               isVisible: true),
                              //           borderRadius: const BorderRadius.only(
                              //               topLeft: Radius.circular(25),
                              //               topRight: Radius.circular(25)),
                              //           dataSource: val,
                              //           xValueMapper: (_ChartData data, _) => data.x,
                              //           yValueMapper: (_ChartData data, _) => data.y,
                              //           name: 'Gold',
                              //           gradient: const LinearGradient(
                              //               colors: GradientColors.nightSky),
                              //           color: secondaryColor)
                              //     ]),
                            ),
                    ),
                  ]),
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
                                elevation: 3,
                                shadowColor: Colors.transparent,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: const [
                                          Text('Reason For Pending',
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
                                            0: FlexColumnWidth(2),
                                            1: FlexColumnWidth(1),
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
                                                          Radius.circular(8.0),
                                                      topRight:
                                                          Radius.circular(8.0),
                                                    ),
                                                    color: secondaryColor),
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: Text('Reason',
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: columnStyle),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: Text('Count',
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: columnStyle),
                                                  ),
                                                ]),
                                            for (var tabelJson in reason)
                                              TableRow(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: tabelJson
                                                                .cCMResonName ==
                                                            null
                                                        ? const Text('',
                                                            style: rowstyle)
                                                        : Text('${tabelJson.cCMResonName}',
                                                            textAlign:
                                                                TextAlign.start,
                                                            style: rowstyle),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Center(
                                                      child: tabelJson
                                                                  .rCCount ==
                                                              null
                                                          ? const Text('',
                                                              style: rowstyle)
                                                          : Text(
                                                              '${tabelJson.rCCount}',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: rowstyle),
                                                    ),
                                                  ),
                                                ],
                                              )
                                          ]),
                                    ),
                                  ],
                                ),
                                // SfCartesianChart(
                                //     plotAreaBorderWidth: 0,
                                //     title: ChartTitle(
                                //         text: 'HelpDesk Trend',
                                //         textStyle: const TextStyle(
                                //             overflow: TextOverflow.ellipsis,
                                //             fontSize: 12,
                                //             color: secondaryColor,
                                //             fontWeight: FontWeight.w600)),
                                //     legend: Legend(
                                //       isVisible: true,
                                //     ),
                                //     primaryXAxis: CategoryAxis(
                                //       isVisible: false,
                                //     ),
                                //     primaryYAxis: NumericAxis(
                                //         minimum: 0, maximum: 40, interval: 10),
                                //     tooltipBehavior: TooltipBehavior(enable: true),
                                //     series: <ChartSeries>[
                                //       BubbleSeries<_ChartData, String>(
                                //         dataLabelSettings: const DataLabelSettings(
                                //             color: Colors.black, isVisible: true),
                                //         dataSource: val,
                                //         xValueMapper: (_ChartData data, _) => data.x,
                                //         yValueMapper: (_ChartData data, _) => data.y,
                                //         name: 'Gold',
                                //         gradient: const LinearGradient(
                                //             colors: GradientColors.juicyOrange),
                                //       ),
                                //       BubbleSeries<fourthData, String>(
                                //         dataLabelSettings: const DataLabelSettings(
                                //             color: Colors.black, isVisible: true),
                                //         dataSource: data2,
                                //         xValueMapper: (fourthData data, _) => data.x,
                                //         yValueMapper: (fourthData data, _) => data.y,
                                //         name: 'Gold2',
                                //         gradient: const LinearGradient(
                                //             colors: GradientColors.purpleLove),
                                //       )
                                //     ]),
                              ),
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
                child: Card(
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
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Flexible(
                                  flex: 2,
                                  child: Text(
                                      ' Level of Completion-Process Stage',
                                      style: cartHeaderStyle)),
                              Icon(Icons.mail, color: secondaryColor),
                            ],
                          ),
                        ),
                        Flexible(
                          flex: 2,
                          child: SfCartesianChart(
                              plotAreaBorderWidth: 0,
                              tooltipBehavior: TooltipBehavior(
                                enable: true,
                              ),
                              legend: Legend(isVisible: true),
                              primaryXAxis: CategoryAxis(isVisible: false),
                              series: <ChartSeries>[
                                StackedBarSeries<ChartData, String>(
                                    dataLabelSettings: const DataLabelSettings(
                                        labelAlignment:
                                            ChartDataLabelAlignment.middle,
                                        textStyle: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600),
                                        isVisible: true,
                                        showCumulativeValues: true),
                                    borderRadius: const BorderRadius.only(
                                        bottomLeft: Radius.circular(15),
                                        topLeft: Radius.circular(15)),
                                    color: trending12,
                                    name: 'Gold',
                                    dataSource: chartData,
                                    xValueMapper: (ChartData data, _) => data.x,
                                    yValueMapper: (ChartData data, _) =>
                                        data.y),
                                StackedBarSeries<ChartData, String>(
                                    dataLabelSettings: const DataLabelSettings(
                                        labelAlignment:
                                            ChartDataLabelAlignment.middle,
                                        textStyle: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600),
                                        isVisible: true,
                                        showCumulativeValues: true),
                                    name: 'Gold1',
                                    color: trending13,
                                    dataSource: chartData,
                                    xValueMapper: (ChartData data, _) => data.x,
                                    yValueMapper: (ChartData data, _) =>
                                        data.y),
                                StackedBarSeries<ChartData, String>(
                                    dataLabelSettings: const DataLabelSettings(
                                        labelAlignment:
                                            ChartDataLabelAlignment.middle,
                                        textStyle: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600),
                                        isVisible: true,
                                        showCumulativeValues: true),
                                    name: 'Gold2',
                                    color: trending14,
                                    dataSource: chartData,
                                    xValueMapper: (ChartData data, _) => data.x,
                                    yValueMapper: (ChartData data, _) =>
                                        data.y),
                                StackedBarSeries<ChartData, String>(
                                    dataLabelSettings: const DataLabelSettings(
                                        labelAlignment:
                                            ChartDataLabelAlignment.middle,
                                        textStyle: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600),
                                        isVisible: true,
                                        showCumulativeValues: true),
                                    name: 'Gold3',
                                    borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(15),
                                        bottomRight: Radius.circular(15)),
                                    color: trending15,
                                    dataSource: chartData,
                                    xValueMapper: (ChartData data, _) => data.x,
                                    yValueMapper: (ChartData data, _) => data.y)
                              ]),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ])),
          ]),
        ),
      ),
    );
  }

  Widget helpdeskStatusChart() {
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
                    child: Text(' Help Desk Status', style: cartHeaderStyle),
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
                            Text('${count[0].totalCnt}',
                                style: const TextStyle(
                                    fontSize: 26,
                                    color: cardText1,
                                    fontWeight: FontWeight.w600)),
                            const Text('Total Ticket Registered',
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
                                  Text('${count[0].overDueCnt}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 26,
                                        color: trending5,
                                      )),
                                  const Text('Over Due',
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
                                  Text('${count[0].unAssignCnt}',
                                      style: const TextStyle(
                                          fontSize: 26,
                                          color: trending4,
                                          fontWeight: FontWeight.w600)),
                                  const Text('UnAssigned',
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
                                  Text('${count[0].openCnt}',
                                      style: const TextStyle(
                                          fontSize: 26,
                                          color: cardText2,
                                          fontWeight: FontWeight.w600)),
                                  const Text('Open Ticket  ',
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
                                  Text('${count[0].closedCnt}',
                                      style: TextStyle(
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

  Widget woTypeChart() {
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
                      child: Text(' Helpdesk Status-By W/O Type',
                          style: cartHeaderStyle)),
                  Icon(Icons.mail, color: secondaryColor),
                ],
              ),
            ),
            SizedBox(
              height: 260,
              child: SfCartesianChart(
                  plotAreaBorderWidth: 0,
                  tooltipBehavior: TooltipBehavior(enable: true),
                  legend: Legend(isVisible: true, position: LegendPosition.top),
                  primaryXAxis: CategoryAxis(isVisible: false),
                  primaryYAxis: NumericAxis(
                    minimum: 0,
                    maximum: 400,
                    interval: 100,
                  ),
                  series: <ChartSeries>[
                    BarSeries<Total, String>(
                      dataLabelSettings: const DataLabelSettings(
                          isVisible: true,
                          color: Colors.black,
                          opacity: 0.8,
                          labelAlignment: ChartDataLabelAlignment.outer),
                      name: 'Total',
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(50),
                      ),
                      color: const Color(0xFF6247aa),
                      // gradient: const LinearGradient(
                      //     colors: GradientColors.purpleLove),
                      dataSource: wo1,
                      xValueMapper: (Total data, _) => data.label,
                      yValueMapper: (Total data, _) => data.y,
                    ),
                    BarSeries<Closed, String>(
                      dataLabelSettings: const DataLabelSettings(
                          isVisible: true,
                          color: Colors.black,
                          opacity: 0.8,
                          labelAlignment: ChartDataLabelAlignment.outer),
                      name: 'Closed',
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(50),
                      ),
                      color: const Color(0xFFa06cd5),
                      // gradient: const LinearGradient(
                      //     colors: GradientColors.bigMango),
                      dataSource: wo2,
                      xValueMapper: (Closed data, _) => data.label,
                      yValueMapper: (Closed data, _) => data.y,
                    ),
                    BarSeries<Open, String>(
                      dataLabelSettings: const DataLabelSettings(
                          isVisible: true,
                          color: Colors.black,
                          opacity: 0.8,
                          labelAlignment: ChartDataLabelAlignment.outer),
                      name: 'Open',
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(50),
                      ),
                      color: const Color(0xFFd2b7e5),
                      dataSource: wo3,
                      xValueMapper: (Open data, _) => data.label,
                      yValueMapper: (Open data, _) => data.y,
                    )
                  ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget overDueChart() {
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
                      child: Text(' Overdue Tickets', style: cartHeaderStyle)),
                  Icon(Icons.mail, color: secondaryColor),
                ],
              ),
            ),
            SizedBox(
              height: 260,
              child: SfPyramidChart(
                  palette: const <Color>[
                    trending1,
                    trending2,
                    trending3,
                    trending4,
                  ],
                  legend: Legend(isVisible: true),
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: PyramidSeries<secondData, String>(
                      name: 'Employee',
                      gapRatio: 0.12,
                      explode: true,
                      dataSource: SecondData,
                      dataLabelSettings: const DataLabelSettings(
                          isVisible: true,
                          color: Colors.black,
                          opacity: 0.8,
                          labelAlignment: ChartDataLabelAlignment.outer),
                      xValueMapper: (secondData data, _) => data.x,
                      yValueMapper: (secondData data, _) => data.y)),
            ),
          ],
        ),
      ),
    );
  }

  Widget byComplaintChart() {
    return Card(
      shape: cardBorder == 4
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
                    child: Text(' By Complaint Type',
                        overflow: TextOverflow.ellipsis,
                        style: cartHeaderStyle),
                  ),
                  Icon(Icons.mail, color: secondaryColor),
                ],
              ),
            ),
            SizedBox(
              height: 260,
              child: SfCartesianChart(
                  plotAreaBorderWidth: 0,
                  tooltipBehavior: TooltipBehavior(enable: true),
                  legend: Legend(isVisible: true, position: LegendPosition.top),
                  primaryXAxis: CategoryAxis(
                    isVisible: true,
                  ),
                  series: <ChartSeries>[
                    ColumnSeries<VwDHDStatusComplaintTypeWiseCount, String>(
                      // onPointTap: (pointInteractionDetails) {
                      //   tappedValue = pointInteractionDetails
                      //       .dataPoints![pointInteractionDetails.pointIndex!].x;
                      //   setState(() {
                      //     tableName = 'By Division';
                      //   });
                      //   chartTappedDataTable(tappedValue);
                      // },
                      dataSource: complainType,
                      xValueMapper:
                          (VwDHDStatusComplaintTypeWiseCount data, _) =>
                              data.complaintType,
                      yValueMapper:
                          (VwDHDStatusComplaintTypeWiseCount data, _) =>
                              int.parse('${data.total}'),
                      trackColor: Colors.transparent,
                      name: 'Total',
                      color: trending18,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                      // gradient: const LinearGradient(
                      //     colors: GradientColors.sharpBlues),
                      dataLabelSettings: const DataLabelSettings(
                          isVisible: true,
                          color: Colors.black,
                          opacity: 0.8,
                          labelAlignment: ChartDataLabelAlignment.outer),
                    ),
                    ColumnSeries<VwDHDStatusComplaintTypeWiseCount, String>(
                      // onPointTap: (pointInteractionDetails) {
                      //   tappedValue = pointInteractionDetails
                      //       .dataPoints![pointInteractionDetails.pointIndex!].x;
                      //   setState(() {
                      //     tableName = 'By Division';
                      //   });
                      //   chartTappedDataTable(tappedValue);
                      // },
                      dataSource: complainType,
                      xValueMapper:
                          (VwDHDStatusComplaintTypeWiseCount data, _) =>
                              data.complaintType,
                      yValueMapper:
                          (VwDHDStatusComplaintTypeWiseCount data, _) =>
                              int.parse('${data.openCnt}'),
                      trackColor: Colors.transparent,
                      name: 'Closed',
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                      color: trending19,
                      // gradient: const LinearGradient(
                      //     colors: GradientColors.eternalConstance),
                      dataLabelSettings: const DataLabelSettings(
                          isVisible: true,
                          color: Colors.black,
                          opacity: 0.8,
                          labelAlignment: ChartDataLabelAlignment.outer),
                    ),
                    ColumnSeries<VwDHDStatusComplaintTypeWiseCount, String>(
                      // onPointTap: (pointInteractionDetails) {
                      //   tappedValue = pointInteractionDetails
                      //       .dataPoints![pointInteractionDetails.pointIndex!].x;
                      //   setState(() {
                      //     tableName = 'By Division';
                      //   });
                      //   chartTappedDataTable(tappedValue);
                      // },
                      dataSource: complainType,
                      xValueMapper:
                          (VwDHDStatusComplaintTypeWiseCount data, _) =>
                              data.complaintType,
                      yValueMapper:
                          (VwDHDStatusComplaintTypeWiseCount data, _) =>
                              int.parse('${data.closed}'),
                      trackColor: Colors.transparent,
                      name: 'Open',
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                      color: trending20,
                      // gradient: const LinearGradient(
                      //     colors: GradientColors.colorfulPeach),
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
      ),
    );
  }

  Widget slaChart() {
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
                    child: Text(' SLA-Resolve', style: cartHeaderStyle),
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
                  legend: Legend(isVisible: true, position: LegendPosition.top),
                  series: <CircularSeries>[
                    RadialBarSeries<HDResponse, String>(
                        dataLabelSettings: const DataLabelSettings(
                            textStyle: TextStyle(color: Colors.white),
                            color: Colors.black,
                            isVisible: true),
                        onPointTap: (pointInteractionDetails) {
                          tappedValue = pointInteractionDetails
                              .dataPoints![pointInteractionDetails.pointIndex!]
                              .x
                              .toString();
                        },
                        gap: '6',
                        dataSource: slaResolve,
                        xValueMapper: (HDResponse data, _) => data.label,
                        yValueMapper: (HDResponse data, _) => data.y,
                        cornerStyle: CornerStyle.bothCurve),
                  ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget approvalChart() {
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
                    child: Text(' Approval Status', style: cartHeaderStyle),
                  ),
                  Icon(Icons.mail, color: secondaryColor),
                ],
              ),
            ),
            SizedBox(
              height: 260,
              child: SfCartesianChart(
                  primaryXAxis: CategoryAxis(
                    isVisible: false,
                  ),
                  legend: Legend(isVisible: true, position: LegendPosition.top),
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: <ChartSeries>[
                    LineSeries<_SalesData, String>(
                      dataSource: data,
                      xValueMapper: (_SalesData sales, _) => sales.year,
                      yValueMapper: (_SalesData sales, _) => sales.sales,
                      name: 'Sales',
                      dataLabelSettings: const DataLabelSettings(
                          isVisible: true,
                          color: Colors.black,
                          opacity: 0.8,
                          labelAlignment: ChartDataLabelAlignment.outer),
                    ),
                    LineSeries<_ChartData, String>(
                      dataLabelSettings: const DataLabelSettings(
                          isVisible: true,
                          color: Colors.black,
                          opacity: 0.8,
                          labelAlignment: ChartDataLabelAlignment.outer),
                      dataSource: val,
                      xValueMapper: (_ChartData sales, _) => sales.x,
                      yValueMapper: (_ChartData sales, _) => sales.y,
                      name: 'Sales1',
                      color: trending3,
                    )
                  ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget divisionChart() {
    return Card(
      shape: cardBorder == 1
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
                  legend: Legend(isVisible: true, position: LegendPosition.top),
                  primaryXAxis: CategoryAxis(isVisible: true),
                  series: <ChartSeries>[
                    ColumnSeries<Total, String>(
                      onPointTap: (pointInteractionDetails) {
                        tappedValue = pointInteractionDetails
                            .dataPoints![pointInteractionDetails.pointIndex!].x;
                        setState(() {
                          tableName = 'By Division';
                        });
                        chartTappedDataTable(tappedValue);
                      },
                      dataSource: values,
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
                          color: Colors.black,
                          opacity: 0.8,
                          labelAlignment: ChartDataLabelAlignment.outer),
                    ),
                    ColumnSeries<Closed, String>(
                      onPointTap: (pointInteractionDetails) {
                        tappedValue = pointInteractionDetails
                            .dataPoints![pointInteractionDetails.pointIndex!].x;
                        setState(() {
                          tableName = 'By Division';
                        });
                        chartTappedDataTable(tappedValue);
                      },
                      dataSource: values1,
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
                          color: Colors.black,
                          opacity: 0.8,
                          labelAlignment: ChartDataLabelAlignment.outer),
                    ),
                    ColumnSeries<Open, String>(
                      onPointTap: (pointInteractionDetails) {
                        tappedValue = pointInteractionDetails
                            .dataPoints![pointInteractionDetails.pointIndex!].x;
                        setState(() {
                          tableName = 'By Division';
                        });
                        chartTappedDataTable(tappedValue);
                      },
                      dataSource: values2,
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
                          color: Colors.black,
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

  Widget slaResponseChart() {
    return Card(
      shape: cardBorder == 2
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
                    child: Text(' SLA-Response', style: cartHeaderStyle),
                  ),
                  Icon(Icons.mail, color: secondaryColor),
                ],
              ),
            ),
            SizedBox(
              height: 260,
              child: SfCircularChart(
                  palette: const <Color>[
                    trending16,
                    trending17,
                    trending7,
                  ],
                  tooltipBehavior: TooltipBehavior(
                    enable: true,
                  ),
                  legend: Legend(isVisible: true, position: LegendPosition.top),
                  series: <CircularSeries>[
                    DoughnutSeries<HDResponse, String>(
                        dataLabelSettings: const DataLabelSettings(
                            isVisible: true,
                            color: Colors.black,
                            opacity: 0.8,
                            labelAlignment: ChartDataLabelAlignment.outer),
                        onPointTap: (pointInteractionDetails) {
                          tappedValue = pointInteractionDetails
                              .dataPoints![pointInteractionDetails.pointIndex!]
                              .x
                              .toString();
                          setState(() {
                            tableName = 'SLA-Response';
                          });
                          if (tappedValue == 'Ontime') {
                            barSeriesId = 16;
                          } else {
                            barSeriesId = 15;
                          }
                          chartTappedDataTable1();
                        },
                        innerRadius: '50',
                        explode: false,
                        dataSource: slaResponse,
                        xValueMapper: (HDResponse data, _) => data.label,
                        yValueMapper: (HDResponse data, _) => data.y,
                        cornerStyle: CornerStyle.bothCurve)
                  ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget byBuildingTable() {
    return Card(
      shape: RoundedRectangleBorder(
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
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
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
                          child: tabelJson.buildingName == null
                              ? const Text('', style: rowstyle)
                              : Text('${tabelJson.buildingName}',
                                  textAlign: TextAlign.start, style: rowstyle),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: tabelJson.totalCnt == null
                                ? const Text('', style: rowstyle)
                                : Text('${tabelJson.totalCnt}',
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
                              child: tabelJson.closedCnt == null
                                  ? const Text('', style: rowstyle)
                                  : Text('${tabelJson.closedCnt}',
                                      textAlign: TextAlign.center,
                                      style: rowstyle),
                            ))
                      ],
                    )
                ]),
          ),
        ],
      ),
    );
  }

  Widget byServiceTypeChart() {
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
                      child: Text(' By Service Type', style: cartHeaderStyle),
                    ),
                    Icon(Icons.mail, color: secondaryColor),
                  ],
                ),
              ),
              SizedBox(
                height: 260,
                child: SfCartesianChart(
                    plotAreaBorderWidth: 0,
                    tooltipBehavior: TooltipBehavior(enable: true),
                    legend:
                        Legend(isVisible: true, position: LegendPosition.top),
                    primaryXAxis: CategoryAxis(
                      isVisible: false,
                    ),
                    primaryYAxis:
                        NumericAxis(minimum: 0, maximum: 40, interval: 10),
                    series: <ChartSeries>[
                      AreaSeries<fourthData, String>(
                        dataLabelSettings: const DataLabelSettings(
                            labelAlignment: ChartDataLabelAlignment.middle,
                            color: Colors.black,
                            isVisible: true),
                        dataSource: data1,
                        name: 'Gold',
                        xValueMapper: (fourthData data, _) => data.x,
                        yValueMapper: (fourthData data, _) => data.y,
                        gradient: const LinearGradient(
                            colors: GradientColors.orangePink),
                      ),
                      AreaSeries<fourthData, String>(
                        dataSource: data2,
                        xValueMapper: (fourthData data, _) => data.x,
                        yValueMapper: (fourthData data, _) => data.y,
                        name: 'Gold',
                        gradient: const LinearGradient(
                            colors: GradientColors.juicyOrange),
                      )
                    ]),
              ),
            ],
          ),
        ));
  }

  Widget levelOfCompletionChart() {
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
                    child: Text(' Level of Completion-Process Stage',
                        style: cartHeaderStyle),
                  ),
                  Icon(Icons.mail, color: secondaryColor),
                ],
              ),
            ),
            SizedBox(
              height: 260,
              child: SfCartesianChart(
                  plotAreaBorderWidth: 0,
                  tooltipBehavior: TooltipBehavior(
                    enable: true,
                  ),
                  legend: Legend(isVisible: true, position: LegendPosition.top),
                  primaryXAxis: CategoryAxis(isVisible: false),
                  series: <ChartSeries>[
                    StackedBarSeries<VwDHDStatusStageWiseCount, String>(
                        dataLabelSettings: const DataLabelSettings(
                            labelAlignment: ChartDataLabelAlignment.middle,
                            textStyle: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                            isVisible: true,
                            showCumulativeValues: true),
                        borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(15),
                            topLeft: Radius.circular(15)),
                        color: trending12,
                        name: 'Gold',
                        dataSource: stage,
                        xValueMapper: (VwDHDStatusStageWiseCount data, _) =>
                            data.label,
                        yValueMapper: (VwDHDStatusStageWiseCount data, _) =>
                            int.parse(' ${data.y}')),
                    // StackedBarSeries<VwDHDStatusStageWiseCount, String>(
                    //     dataLabelSettings: const DataLabelSettings(
                    //         labelAlignment: ChartDataLabelAlignment.middle,
                    //         textStyle: TextStyle(
                    //             fontSize: 18, fontWeight: FontWeight.w600),
                    //         isVisible: true,
                    //         showCumulativeValues: true),
                    //     name: 'Gold1',
                    //     color: trending13,
                    //     dataSource: stage,
                    //     xValueMapper: (VwDHDStatusStageWiseCount data, _) =>
                    //         data.x,
                    //     yValueMapper: (VwDHDStatusStageWiseCount data, _) =>
                    //         data.y),
                    // StackedBarSeries<ChartData, String>(
                    //     dataLabelSettings: const DataLabelSettings(
                    //         labelAlignment: ChartDataLabelAlignment.middle,
                    //         textStyle: TextStyle(
                    //             fontSize: 18, fontWeight: FontWeight.w600),
                    //         isVisible: true,
                    //         showCumulativeValues: true),
                    //     name: 'Gold2',
                    //     color: trending14,
                    //     dataSource: chartData,
                    //     xValueMapper: (ChartData data, _) => data.x,
                    //     yValueMapper: (ChartData data, _) => data.y),
                    // StackedBarSeries<ChartData, String>(
                    //     dataLabelSettings: const DataLabelSettings(
                    //         labelAlignment: ChartDataLabelAlignment.middle,
                    //         textStyle: TextStyle(
                    //             fontSize: 18, fontWeight: FontWeight.w600),
                    //         isVisible: true,
                    //         showCumulativeValues: true),
                    //     name: 'Gold3',
                    //     borderRadius: const BorderRadius.only(
                    //         topRight: Radius.circular(15),
                    //         bottomRight: Radius.circular(15)),
                    //     color: trending15,
                    //     dataSource: chartData,
                    //     xValueMapper: (ChartData data, _) => data.x,
                    //     yValueMapper: (ChartData data, _) => data.y)
                  ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget helpDeskMonthWiseChart() {
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
                      child: Text(' HelpDesk Month Wise Performance Status',
                          style: cartHeaderStyle),
                    ),
                    Icon(Icons.mail, color: secondaryColor),
                  ],
                ),
              ),
              SizedBox(
                height: 260,
                child: SfCartesianChart(
                    tooltipBehavior: TooltipBehavior(enable: true),
                    plotAreaBorderWidth: 0,
                    legend:
                        Legend(isVisible: true, position: LegendPosition.top),
                    primaryXAxis: CategoryAxis(
                      isVisible: false,
                    ),
                    series: <ChartSeries>[
                      StackedColumn100Series<ChartData, String>(
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(15),
                              bottomRight: Radius.circular(15)),
                          // gradient: const LinearGradient(
                          //     colors: GradientColors.freshMilk),
                          color: trending9,
                          dataSource: chartData,
                          name: 'Gold',
                          xValueMapper: (ChartData data, _) => data.x,
                          yValueMapper: (ChartData data, _) => data.y),
                      StackedColumn100Series<ChartData, String>(
                          // gradient: const LinearGradient(
                          //     colors: GradientColors.warmFlame),
                          color: trending10,
                          dataSource: chartData,
                          name: 'Gold1',
                          xValueMapper: (ChartData data, _) => data.x,
                          yValueMapper: (ChartData data, _) => data.y),
                      StackedColumn100Series<ChartData, String>(
                          // gradient: const LinearGradient(
                          //     colors: GradientColors.gentleCare),
                          color: trending11,
                          name: 'Gold2',
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15)),
                          dataSource: chartData,
                          xValueMapper: (ChartData data, _) => data.x,
                          yValueMapper: (ChartData data, _) => data.y)
                    ]),
              ),
            ],
          ),
        ));
  }

  Widget rootCauseTable() {
    return Card(
      shape: RoundedRectangleBorder(
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
                Text('Root Cause Analysis', style: cartHeaderStyle),
                Icon(Icons.mail, color: secondaryColor),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
            child: Table(
                columnWidths: const {
                  0: FlexColumnWidth(2),
                  1: FlexColumnWidth(1),
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
                          child: Text('Root Cause',
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.start,
                              style: columnStyle),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Count',
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: columnStyle),
                        ),
                      ]),
                  for (var tabelJson in rootCause.sublist(0, 5))
                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: tabelJson.label == null
                              ? const Text('', style: rowstyle)
                              : Text('${tabelJson.label}',
                                  textAlign: TextAlign.start, style: rowstyle),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: tabelJson.y == null
                                ? const Text('', style: rowstyle)
                                : Text('${tabelJson.y}',
                                    textAlign: TextAlign.center,
                                    style: rowstyle),
                          ),
                        ),
                      ],
                    )
                ]),
          ),
        ],
      ),
    );
  }

  Widget reasonForPendingTable() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: Colors.white,
      elevation: 4,
      shadowColor: Colors.black12,
      child: SizedBox(
        height: 220,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Reason For Pending', style: cartHeaderStyle),
                  Icon(Icons.mail, color: secondaryColor),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
              child: Table(
                  columnWidths: const {
                    0: FlexColumnWidth(2),
                    1: FlexColumnWidth(1),
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
                            child: Text('Reason',
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.start,
                                style: columnStyle),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Count',
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: columnStyle),
                          ),
                        ]),
                    for (var tabelJson in reason)
                      TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: tabelJson.cCMResonName == null
                                ? const Text('', style: rowstyle)
                                : Text('${tabelJson.cCMResonName}',
                                    textAlign: TextAlign.start,
                                    style: rowstyle),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: tabelJson.rCCount == null
                                  ? const Text('', style: rowstyle)
                                  : Text('${tabelJson.rCCount}',
                                      textAlign: TextAlign.center,
                                      style: rowstyle),
                            ),
                          ),
                        ],
                      )
                  ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget tableComponent() {
    double headerTable = MediaQuery.of(context).size.height * 0.38;
    return SizedBox(
      height: headerTable,
      child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          color: Colors.white,
          elevation: 3,
          shadowColor: Colors.transparent,
          child: Padding(
            padding:
                const EdgeInsets.only(left: 14.0, right: 14.0, bottom: 14.0),
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                dragDevices: {
                  PointerDeviceKind.mouse,
                  PointerDeviceKind.touch,
                },
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    highlightColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    icon: const Icon(Icons.close, color: secondaryColor),
                    onPressed: () => {},
                  ),
                  Flexible(
                    flex: 2,
                    child: SingleChildScrollView(
                      controller: _horizontalScrollController,
                      scrollDirection: Axis.horizontal,
                      child: Listener(
                        onPointerSignal: (event) {
                          if (event is PointerScrollEvent) {
                            final offset = event.scrollDelta.dy;
                            _horizontalScrollController.jumpTo(
                                _horizontalScrollController.offset + offset);
                          }
                        },
                        child: ClipRRect(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                          child: DataTable(
                              headingRowHeight: 35,
                              dataRowHeight: 30,
                              headingRowColor:
                                  MaterialStateProperty.resolveWith(
                                      (states) => secondaryColor),
                              decoration:
                                  const BoxDecoration(color: Colors.white),
                              columns: const [
                                DataColumn(
                                  label: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('Action',
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: columnStyle),
                                  ),
                                ),
                                DataColumn(
                                  label: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('Complaint No',
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: columnStyle),
                                  ),
                                ),
                                DataColumn(
                                  label: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('Reference No',
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: columnStyle),
                                  ),
                                ),
                                DataColumn(
                                  label: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('Date&Time',
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: columnStyle),
                                  ),
                                ),
                                DataColumn(
                                  label: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('Stage Name',
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: columnStyle),
                                  ),
                                ),
                                DataColumn(
                                  label: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('Current Status',
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: columnStyle),
                                  ),
                                ),
                                DataColumn(
                                  label: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('Pending Status',
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: columnStyle),
                                  ),
                                ),
                                DataColumn(
                                  label: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('Priority',
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: columnStyle),
                                  ),
                                ),
                                DataColumn(
                                  label: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('Nature of Complaint',
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: columnStyle),
                                  ),
                                ),
                                DataColumn(
                                  label: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('Description',
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: columnStyle),
                                  ),
                                ),
                                DataColumn(
                                  label: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('Complaint Type',
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: columnStyle),
                                  ),
                                ),
                                DataColumn(
                                  label: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('Division Name',
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: columnStyle),
                                  ),
                                ),
                                DataColumn(
                                  label: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('Complainer Name',
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: columnStyle),
                                  ),
                                ),
                                DataColumn(
                                  label: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('Contract Code',
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: columnStyle),
                                  ),
                                ),
                                DataColumn(
                                  label: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('Contract Name',
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: columnStyle),
                                  ),
                                ),
                                DataColumn(
                                  label: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('Locality Name',
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: columnStyle),
                                  ),
                                ),
                                DataColumn(
                                  label: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('Building Name',
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: columnStyle),
                                  ),
                                ),
                                DataColumn(
                                  label: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('Floor Name',
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: columnStyle),
                                  ),
                                ),
                                DataColumn(
                                  label: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('Spot Name',
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: columnStyle),
                                  ),
                                ),
                                DataColumn(
                                  label: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('Response SLA',
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: columnStyle),
                                  ),
                                ),
                                DataColumn(
                                  label: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('Resolve SLA',
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: columnStyle),
                                  ),
                                ),
                                DataColumn(
                                  label: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('Completed Date',
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: columnStyle),
                                  ),
                                ),
                              ],
                              rows: chartdataTable1
                                  .map((data) => DataRow(cells: [
                                        DataCell(
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: data.complaintIDPK == null
                                                ? const Center(
                                                    child: Text('Loading...'),
                                                  )
                                                : InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        ComplaintIDPK = data
                                                            .complaintIDPK
                                                            .toString();
                                                        // cardView = true;
                                                      });
                                                    },
                                                    hoverColor:
                                                        Colors.transparent,
                                                    highlightColor:
                                                        Colors.transparent,
                                                    splashColor:
                                                        Colors.transparent,
                                                    focusColor:
                                                        Colors.transparent,
                                                    child: const Icon(
                                                        Icons.remove_red_eye,
                                                        size: 14,
                                                        color: secondaryColor),
                                                  ),
                                          ),
                                        ),
                                        DataCell(
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: data.complaintNo == null
                                                ? const Text('',
                                                    style: rowstyle)
                                                : Text('${data.complaintNo}',
                                                    textAlign: TextAlign.center,
                                                    style: rowstyle),
                                          ),
                                        ),
                                        DataCell(
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: data.cCMStageID == null
                                                ? const Text('',
                                                    style: rowstyle)
                                                : Text('${data.cCMStageID}',
                                                    textAlign: TextAlign.center,
                                                    style: rowstyle),
                                          ),
                                        ),
                                        DataCell(
                                          Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: data.complainedDate == null
                                                  ? const Text('',
                                                      style: rowstyle)
                                                  : Text(
                                                      '${data.complainedDate}',
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: rowstyle)),
                                        ),
                                        DataCell(
                                          Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: data.stageName == null
                                                  ? const Text('',
                                                      style: rowstyle)
                                                  : Text('${data.stageName}',
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: rowstyle)),
                                        ),
                                        DataCell(
                                          Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: data.woStatus == null
                                                  ? const Text('',
                                                      style: rowstyle)
                                                  : Text('${data.woStatus}',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: rowstyle)),
                                        ),
                                        DataCell(
                                          Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: data.pendingByDays == null
                                                  ? const Text('',
                                                      style: rowstyle)
                                                  : Text(
                                                      '${data.pendingByDays}',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: rowstyle)),
                                        ),
                                        DataCell(
                                          Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: data.priorityName == null
                                                  ? const Text('',
                                                      style: rowstyle)
                                                  : Text('${data.priorityName}',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: rowstyle)),
                                        ),
                                        DataCell(
                                          Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: data.complaintNatureName ==
                                                      null
                                                  ? const Text('',
                                                      style: rowstyle)
                                                  : Text(
                                                      '${data.complaintNatureName}',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: rowstyle)),
                                        ),
                                        DataCell(
                                          Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: data.descriptionn == null
                                                  ? const Text('',
                                                      style: rowstyle)
                                                  : Text('${data.descriptionn}',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: rowstyle)),
                                        ),
                                        DataCell(
                                          Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: data.compType == null
                                                  ? const Text('',
                                                      style: rowstyle)
                                                  : Text('${data.compType}',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: rowstyle)),
                                        ),
                                        DataCell(
                                          Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: data.divisionName == null
                                                  ? const Text('',
                                                      style: rowstyle)
                                                  : Text('${data.divisionName}',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: rowstyle)),
                                        ),
                                        DataCell(
                                          Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: data.complainerName == null
                                                  ? const Text('',
                                                      style: rowstyle)
                                                  : Text(
                                                      '${data.complainerName}',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: rowstyle)),
                                        ),
                                        DataCell(
                                          Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: data.contractCode == null
                                                  ? const Text('',
                                                      style: rowstyle)
                                                  : Text('${data.contractCode}',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: rowstyle)),
                                        ),
                                        DataCell(
                                          Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: data.contractName == null
                                                  ? const Text('',
                                                      style: rowstyle)
                                                  : Text('${data.contractName}',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: rowstyle)),
                                        ),
                                        DataCell(
                                          Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: data.localityName == null
                                                  ? const Text('',
                                                      style: rowstyle)
                                                  : Text('${data.localityName}',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: rowstyle)),
                                        ),
                                        DataCell(
                                          Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: data.buildingName == null
                                                  ? const Text('',
                                                      style: rowstyle)
                                                  : Text('${data.buildingName}',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: rowstyle)),
                                        ),
                                        DataCell(
                                          Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: data.floorName == null
                                                  ? const Text('',
                                                      style: rowstyle)
                                                  : Text('${data.floorName}',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: rowstyle)),
                                        ),
                                        DataCell(
                                          Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: data.spotName == null
                                                  ? const Text('',
                                                      style: rowstyle)
                                                  : Text('${data.spotName}',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: rowstyle)),
                                        ),
                                        DataCell(
                                          Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: data.responseStat == null
                                                  ? const Text('',
                                                      style: rowstyle)
                                                  : Text('${data.responseStat}',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: rowstyle)),
                                        ),
                                        DataCell(
                                          Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: data.resolutionStat == null
                                                  ? const Text('',
                                                      style: rowstyle)
                                                  : Text(
                                                      '${data.resolutionStat}',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: rowstyle)),
                                        ),
                                        DataCell(
                                          Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: data.completedDate == null
                                                  ? const Text('',
                                                      style: rowstyle)
                                                  : Text(
                                                      '${data.completedDate}',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: rowstyle)),
                                        ),
                                      ]))
                                  .toList()),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  List<dynamic> displayChartWidget() {
    return displayChart = [
      {"id": 1, "func": helpdeskStatusChart()},
      {"id": 2, "func": woTypeChart()},
      {"id": 3, "func": overDueChart()},
      {"id": 4, "func": byComplaintChart()},
      {"id": 5, "func": slaChart()},
      {"id": 6, "func": approvalChart()},
      {"id": 7, "func": divisionChart()},
      {"id": 8, "func": slaResponseChart()},
      {"id": 9, "func": byBuildingTable()},
      {"id": 10, "func": byServiceTypeChart()},
      {"id": 11, "func": levelOfCompletionChart()},
      {"id": 12, "func": helpDeskMonthWiseChart()},
      {"id": 13, "func": rootCauseTable()}
    ];
  }
}

class _SalesData {
  _SalesData(this.year, this.sales);

  final String year;
  final double sales;
}

class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final double y;
}

class secondData {
  secondData(this.x, this.y);
  final String x;
  final double y;
}

class thirdData {
  thirdData(this.x, this.high, this.low);
  final String x;
  final double high;
  final double low;
}

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final double? y;
}

class fourthData {
  fourthData(this.x, this.y);

  final String x;
  final double y;
}

class VwDHelpDeskStatusCount {
  String? totalCnt;
  String? openCnt;
  String? closedCnt;
  String? unAssignCnt;
  String? overDueCnt;

  VwDHelpDeskStatusCount(
      {this.totalCnt,
      this.openCnt,
      this.closedCnt,
      this.unAssignCnt,
      this.overDueCnt});

  VwDHelpDeskStatusCount.fromJson(Map<String, dynamic> json) {
    totalCnt = json['TotalCnt'];
    openCnt = json['OpenCnt'];
    closedCnt = json['ClosedCnt'];
    unAssignCnt = json['UnAssignCnt'];
    overDueCnt = json['OverDueCnt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['TotalCnt'] = totalCnt;
    data['OpenCnt'] = openCnt;
    data['ClosedCnt'] = closedCnt;
    data['UnAssignCnt'] = unAssignCnt;
    data['OverDueCnt'] = overDueCnt;
    return data;
  }
}

class HdByPriority {
  String? label;
  String? y;
  String? perc;

  HdByPriority({this.label, this.y, this.perc});

  HdByPriority.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    y = json['y'];
    perc = json['Perc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['label'] = label;
    data['y'] = y;
    data['Perc'] = perc;
    return data;
  }
}

class VwDHDStatusOvuerDueDays {
  String? y;
  String? label;

  VwDHDStatusOvuerDueDays({this.y, this.label});

  VwDHDStatusOvuerDueDays.fromJson(Map<String, dynamic> json) {
    y = json['y'];
    label = json['label'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['y'] = y;
    data['label'] = label;
    return data;
  }
}

class HDResponse {
  String? label;
  int? y;

  HDResponse({this.label, this.y});

  HDResponse.fromJson(Map<String, dynamic> json) {
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

class Building {
  String? totalCnt;
  String? openCnt;
  String? closedCnt;
  String? buildingName;

  Building({this.totalCnt, this.openCnt, this.closedCnt, this.buildingName});

  Building.fromJson(Map<String, dynamic> json) {
    totalCnt = json['TotalCnt'];
    openCnt = json['OpenCnt'];
    closedCnt = json['ClosedCnt'];
    buildingName = json['BuildingName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['TotalCnt'] = totalCnt;
    data['OpenCnt'] = openCnt;
    data['ClosedCnt'] = closedCnt;
    data['BuildingName'] = buildingName;
    return data;
  }
}

class Analysis {
  String? label;
  int? y;

  Analysis({this.label, this.y});

  Analysis.fromJson(Map<String, dynamic> json) {
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

class Pending {
  String? cCMResonName;
  String? rCCount;

  Pending({this.cCMResonName, this.rCCount});

  Pending.fromJson(Map<String, dynamic> json) {
    cCMResonName = json['CCMResonName'];
    rCCount = json['RCCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['CCMResonName'] = cCMResonName;
    data['RCCount'] = rCCount;
    return data;
  }
}

class VwDHDStatusServiceTypeWiseCount {
  String? serviceTypeID;
  String? serviceTypeCode;
  String? serviceTypeName;
  String? closed;
  String? openCnt;
  String? total;
  String? achieved;

  VwDHDStatusServiceTypeWiseCount(
      {this.serviceTypeID,
      this.serviceTypeCode,
      this.serviceTypeName,
      this.closed,
      this.openCnt,
      this.total,
      this.achieved});

  VwDHDStatusServiceTypeWiseCount.fromJson(Map<String, dynamic> json) {
    serviceTypeID = json['ServiceTypeID'];
    serviceTypeCode = json['ServiceTypeCode'];
    serviceTypeName = json['ServiceTypeName'];
    closed = json['Closed'];
    openCnt = json['OpenCnt'];
    total = json['Total'];
    achieved = json['Achieved'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ServiceTypeID'] = this.serviceTypeID;
    data['ServiceTypeCode'] = this.serviceTypeCode;
    data['ServiceTypeName'] = this.serviceTypeName;
    data['Closed'] = this.closed;
    data['OpenCnt'] = this.openCnt;
    data['Total'] = this.total;
    data['Achieved'] = this.achieved;
    return data;
  }
}

class VwDHDStatusComplaintTypeWiseCount {
  String? total;
  String? openCnt;
  String? closed;
  String? complaintType;
  String? perc;

  VwDHDStatusComplaintTypeWiseCount(
      {this.total, this.openCnt, this.closed, this.complaintType, this.perc});

  VwDHDStatusComplaintTypeWiseCount.fromJson(Map<String, dynamic> json) {
    total = json['Total'];
    openCnt = json['OpenCnt'];
    closed = json['Closed'];
    complaintType = json['ComplaintType'];
    perc = json['Perc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Total'] = this.total;
    data['OpenCnt'] = this.openCnt;
    data['Closed'] = this.closed;
    data['ComplaintType'] = this.complaintType;
    data['Perc'] = this.perc;
    return data;
  }
}

class VwDHDStatusStageWiseCount {
  String? y;
  String? label;

  VwDHDStatusStageWiseCount({this.y, this.label});

  VwDHDStatusStageWiseCount.fromJson(Map<String, dynamic> json) {
    y = json['y'];
    label = json['label'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['y'] = y;
    data['label'] = label;
    return data;
  }
}

class Total {
  int? y;
  String? label;

  Total({this.y, this.label});

  Total.fromJson(Map<String, dynamic> json) {
    y = json['y'];
    label = json['label'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['y'] = y;
    data['label'] = label;
    return data;
  }
}

class Closed {
  int? y;
  String? label;

  Closed({this.y, this.label});

  Closed.fromJson(Map<String, dynamic> json) {
    y = json['y'];
    label = json['label'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['y'] = y;
    data['label'] = label;
    return data;
  }
}

class Open {
  int? y;
  String? label;

  Open({this.y, this.label});

  Open.fromJson(Map<String, dynamic> json) {
    y = json['y'];
    label = json['label'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['y'] = y;
    data['label'] = label;
    return data;
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ComplaintIDPK'] = complaintIDPK;
    data['PriorityIDPK'] = priorityIDPK;
    data['BDMBusinessFlowID'] = bDMBusinessFlowID;
    data['CCMStageID'] = cCMStageID;
    data['CCMAllocatedEmpID'] = cCMAllocatedEmpID;
    data['ComplaintNo'] = complaintNo;
    data['ComplainedDate'] = complainedDate;
    data['StageName'] = stageName;
    data['WoStatus'] = woStatus;
    data['ComplaintNatureName'] = complaintNatureName;
    data['DivisionCode'] = divisionCode;
    data['DivisionName'] = divisionName;
    data['ComplainerName'] = complainerName;
    data['ContractCode'] = contractCode;
    data['ContractName'] = contractName;
    data['LocalityName'] = localityName;
    data['BuildingCode'] = buildingCode;
    data['BuildingName'] = buildingName;
    data['FloorName'] = floorName;
    data['SpotName'] = spotName;
    data['Descriptionn'] = descriptionn;
    data['PriorityName'] = priorityName;
    data['ResponseStat'] = responseStat;
    data['ResolutionStat'] = resolutionStat;
    data['PendingByDays'] = pendingByDays;
    data['MaintenanceRemarks'] = maintenanceRemarks;
    data['ETADate'] = eTADate;
    data['CompletedDate'] = completedDate;
    data['CompType'] = compType;
    data['IsServiceRequest'] = isServiceRequest;
    data['ClientWoNo'] = clientWoNo;
    data['ResultCount'] = resultCount;
    return data;
  }
}
