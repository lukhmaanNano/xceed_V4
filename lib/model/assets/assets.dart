import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_gradient_colors/flutter_gradient_colors.dart';
import 'package:hovering/hovering.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '../../Config.dart';
import '../../Styles/CommonColor.dart';
import '../../Styles/CommonTextStyle.dart';
import '../../Styles/responsive.dart';
import '../../Widgets/mobile/shimmer.dart';
import '../../Widgets/web/assets/assetCardView.dart';
import '../../Widgets/web/assets/assetListView.dart';
import '../../Widgets/web/shimmer.dart';

class AssetsMain extends StatefulWidget {
  bool? sideNav, singCardView, detailBackMenu;
  String? pageName;
  final dynamic getFunc;
  AssetsMain(
      {Key? key,
      this.sideNav,
      this.singCardView,
      this.getFunc,
      this.detailBackMenu,
      this.pageName})
      : super(key: key);

  @override
  State<AssetsMain> createState() => _AssetsMainState();
}

class _AssetsMainState extends State<AssetsMain> {
  final _horizontalScrollController = ScrollController();
  final Duration delayed = const Duration(milliseconds: 300);
  bool menuState = true, timer = true, listCard = true;
  int tab = 0;
  String? userName, currentDate, startDate, day = 'Today', pageName;
  int? sessionId, barSeriesId, cardBorder = 0;
  var ComplaintIDPK, containerIndex;
  List<dynamic> displayChart = [];
  List<VwDAssetStatus> count = [];
  List<VwDAssetDivisionWisePerc> divisionCount = [];
  List<VwDAssetDisciplineWisePerc> disciplineCount = [];
  List<VwDAssetPPMStatus> assetPpmCount = [];
  List<VwDAssetBDMStatus> assetBdmCount = [];
  List<VwDAssetInspStatus> assetInspectionCount = [];
  List<VwDAssetBMSStatus> assetBmsCount = [];
  List<VwDAssetLocationGroupWiseCount> locationGroupCount = [];
  List<VwDAssetLocationWiseCount> locationWiseCount = [];
  List<VwDAssetBuildingWiseCount> buildingWiseCount = [];
  List<VwDAssetWarrStatus> assetWarrantyCount = [];
  List<VwDAssetAMCStatus> assetAMCCount = [];
  List<VwDAssetInsurStatus> assetInsuranceCount = [];
  List<VwDAssetByYearStatus> assetInstalledCount = [];
  List<VwDAssetAgeingStatus> assetAgeingCount = [];
  List<VwDAssetPopUpGrdDet> chartDataTable = [];
  late String tappedValue, tableName;

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
    assetCountApi();
    local();
    disciplineWiseApi();
    divisionWiseApi();
    assetInPpmApi();
    assetOccuredInBdmApi();
    assetInspectionApi();
    assetInBmsApi();
    locationGroupWiseApi();
    locationWiseApi();
    buildingWiseApi();
    assetWarrantyApi();
    assetAMCApi();
    assetInsuranceApi();
    assetInstalledApi();
    assetAgeingApi();
  }

  Future<void> local() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('UserName');
      sessionId = prefs.getInt('SessionId')!;
    });
  }

  Future<void> assetCountApi() async {
    String? ip = '/VwDAssetStatus/';
    const service = ApiConfig.service;
    final url = Uri.parse('$service$ip');
    final headers = {
      'Accept': 'application/json'
      // 'Content-Type': 'application/json'
    };
    const json =
        '{"data":{"CountryID_varchar":0,"CustomerID_varchar":0,"ContractID_varchar":0,"LocationGroupID_varchar":0,"LocalityID_varchar":0,"BuildingID_varchar":0,"CityID_varchar":0,"FloorID_varchar":0,"SpotID_varchar":0,"DivisionID_varchar":0,"DisciplineID_varchar":0,"ServiceTypeID_varchar":0,"FromDate_datetime":"2023-01-31","ToDate_datetime":"2023-03-02","LocUserID_int":"6","PortalUserID_bit":0}}';
    final response =
        await http.post(url, headers: headers, body: json.toString());
    if (response.statusCode == 400) {
      String err = 'something went wrong!';
    } else {
      final String jsonString = jsonEncode(response.body);
      var decodedJson = jsonDecode(jsonString);
      Map<String, dynamic> map = jsonDecode(decodedJson);
      var result = map['VwDAssetStatus'];
      for (Map<String, dynamic> i in result) {
        count.add(VwDAssetStatus.fromJson(i));
      }
      timerFunction();
    }
    divisionWiseApi();
  }

  Future<void> divisionWiseApi() async {
    String? ip = '/VwDAssetDivisionWisePerc/';
    const service = ApiConfig.service;
    final url = Uri.parse('$service$ip');
    final headers = {'Accept': 'application/json'};
    const json =
        '{"data":{"CountryID_varchar":0,"CustomerID_varchar":0,"ContractID_varchar":0,"LocationGroupID_varchar":0,"LocalityID_varchar":0,"BuildingID_varchar":0,"CityID_varchar":0,"FloorID_varchar":0,"SpotID_varchar":0,"DivisionID_varchar":0,"DisciplineID_varchar":0,"ServiceTypeID_varchar":0,"FromDate_datetime":"2023-01-31","ToDate_datetime":"2023-03-02","LocUserID_int":"6","PortalUserID_bit":0}}';
    final response =
        await http.post(url, headers: headers, body: json.toString());
    if (response.statusCode == 400) {
      String err = 'something went wrong!';
    } else {
      final String jsonString = jsonEncode(response.body);
      var decodedJson = jsonDecode(jsonString);
      Map<String, dynamic> map = jsonDecode(decodedJson);
      var result = map['VwDAssetDivisionWisePerc'];
      for (Map<String, dynamic> i in result) {
        divisionCount.add(VwDAssetDivisionWisePerc.fromJson(i));
      }
      timerFunction();
    }
  }

  Future<void> disciplineWiseApi() async {
    String? ip = '/VwDAssetDisciplineWisePerc/';
    const service = ApiConfig.service;
    final url = Uri.parse('$service$ip');
    final headers = {'Accept': 'application/json'};
    const json =
        '{"data":{"CountryID_varchar":0,"CustomerID_varchar":0,"ContractID_varchar":0,"LocationGroupID_varchar":0,"LocalityID_varchar":0,"BuildingID_varchar":0,"CityID_varchar":0,"FloorID_varchar":0,"SpotID_varchar":0,"DivisionID_varchar":0,"DisciplineID_varchar":0,"ServiceTypeID_varchar":0,"FromDate_datetime":"2023-01-31","ToDate_datetime":"2023-03-02","LocUserID_int":"6","PortalUserID_bit":0}}';
    final response =
        await http.post(url, headers: headers, body: json.toString());
    if (response.statusCode == 400) {
      String err = 'something went wrong!';
    } else {
      final String jsonString = jsonEncode(response.body);
      var decodedJson = jsonDecode(jsonString);
      Map<String, dynamic> map = jsonDecode(decodedJson);
      var result = map['VwDAssetDisciplineWisePerc'];
      for (Map<String, dynamic> i in result) {
        disciplineCount.add(VwDAssetDisciplineWisePerc.fromJson(i));
      }
      timerFunction();
    }
  }

  Future<void> assetInPpmApi() async {
    String? ip = '/VwDAssetPPMStatus/';
    const service = ApiConfig.service;
    final url = Uri.parse('$service$ip');
    final headers = {'Accept': 'application/json'};
    const json =
        '{"data":{"CountryID_varchar":0,"CustomerID_varchar":0,"ContractID_varchar":0,"LocationGroupID_varchar":0,"LocalityID_varchar":0,"BuildingID_varchar":0,"CityID_varchar":0,"FloorID_varchar":0,"SpotID_varchar":0,"DivisionID_varchar":0,"DisciplineID_varchar":0,"ServiceTypeID_varchar":0,"FromDate_datetime":"2023-02-01","ToDate_datetime":"2023-03-03","LocUserID_int":"6","PortalUserID_bit":0}}';
    final response =
        await http.post(url, headers: headers, body: json.toString());
    if (response.statusCode == 400) {
      String err = 'something went wrong!';
    } else {
      final String jsonString = jsonEncode(response.body);
      var decodedJson = jsonDecode(jsonString);
      Map<String, dynamic> map = jsonDecode(decodedJson);
      var result = map['VwDAssetPPMStatus'];
      for (Map<String, dynamic> i in result) {
        assetPpmCount.add(VwDAssetPPMStatus.fromJson(i));
      }
      timerFunction();
    }
  }

  Future<void> assetOccuredInBdmApi() async {
    String? ip = '/VwDAssetBDMStatus/';
    const service = ApiConfig.service;
    final url = Uri.parse('$service$ip');
    final headers = {'Accept': 'application/json'};
    const json =
        '{"data":{"CountryID_varchar":0,"CustomerID_varchar":0,"ContractID_varchar":0,"LocationGroupID_varchar":0,"LocalityID_varchar":0,"BuildingID_varchar":0,"CityID_varchar":0,"FloorID_varchar":0,"SpotID_varchar":0,"DivisionID_varchar":0,"DisciplineID_varchar":0,"ServiceTypeID_varchar":0,"FromDate_datetime":"2023-02-01","ToDate_datetime":"2023-03-03","LocUserID_int":"6","PortalUserID_bit":0}}';
    final response =
        await http.post(url, headers: headers, body: json.toString());
    if (response.statusCode == 400) {
      String err = 'something went wrong!';
    } else {
      final String jsonString = jsonEncode(response.body);
      var decodedJson = jsonDecode(jsonString);
      Map<String, dynamic> map = jsonDecode(decodedJson);
      var result = map['VwDAssetBDMStatus'];
      for (Map<String, dynamic> i in result) {
        assetBdmCount.add(VwDAssetBDMStatus.fromJson(i));
      }
      timerFunction();
    }
  }

  Future<void> assetInspectionApi() async {
    String? ip = '/VwDAssetInspStatus/';
    const service = ApiConfig.service;
    final url = Uri.parse('$service$ip');
    final headers = {'Accept': 'application/json'};
    const json =
        '{"data":{"CountryID_varchar":0,"CustomerID_varchar":0,"ContractID_varchar":0,"LocationGroupID_varchar":0,"LocalityID_varchar":0,"BuildingID_varchar":0,"CityID_varchar":0,"FloorID_varchar":0,"SpotID_varchar":0,"DivisionID_varchar":0,"DisciplineID_varchar":0,"ServiceTypeID_varchar":0,"FromDate_datetime":"2023-02-01","ToDate_datetime":"2023-03-03","LocUserID_int":"6","PortalUserID_bit":0}}';
    final response =
        await http.post(url, headers: headers, body: json.toString());
    if (response.statusCode == 400) {
      String err = 'something went wrong!';
    } else {
      final String jsonString = jsonEncode(response.body);
      var decodedJson = jsonDecode(jsonString);
      Map<String, dynamic> map = jsonDecode(decodedJson);
      var result = map['VwDAssetInspStatus'];
      for (Map<String, dynamic> i in result) {
        assetInspectionCount.add(VwDAssetInspStatus.fromJson(i));
      }
      timerFunction();
    }
  }

  Future<void> assetInBmsApi() async {
    String? ip = '/VwDAssetBMSStatus/';
    const service = ApiConfig.service;
    final url = Uri.parse('$service$ip');
    final headers = {'Accept': 'application/json'};
    const json =
        '{"data":{"CountryID_varchar":0,"CustomerID_varchar":0,"ContractID_varchar":0,"LocationGroupID_varchar":0,"LocalityID_varchar":0,"BuildingID_varchar":0,"CityID_varchar":0,"FloorID_varchar":0,"SpotID_varchar":0,"DivisionID_varchar":0,"DisciplineID_varchar":0,"ServiceTypeID_varchar":0,"FromDate_datetime":"2023-02-01","ToDate_datetime":"2023-03-03","LocUserID_int":"6","PortalUserID_bit":0}}';
    final response =
        await http.post(url, headers: headers, body: json.toString());
    if (response.statusCode == 400) {
      String err = 'something went wrong!';
    } else {
      final String jsonString = jsonEncode(response.body);
      var decodedJson = jsonDecode(jsonString);
      Map<String, dynamic> map = jsonDecode(decodedJson);
      var result = map['VwDAssetBMSStatus'];
      for (Map<String, dynamic> i in result) {
        assetBmsCount.add(VwDAssetBMSStatus.fromJson(i));
      }
      timerFunction();
    }
  }

  Future<void> locationGroupWiseApi() async {
    String? ip = '/VwDAssetLocationGroupWiseCount/';
    const service = ApiConfig.service;
    final url = Uri.parse('$service$ip');
    final headers = {'Accept': 'application/json'};
    const json =
        '{"data":{"CountryID_varchar":0,"CustomerID_varchar":0,"ContractID_varchar":0,"LocationGroupID_varchar":0,"LocalityID_varchar":0,"BuildingID_varchar":0,"CityID_varchar":0,"FloorID_varchar":0,"SpotID_varchar":0,"DivisionID_varchar":0,"DisciplineID_varchar":0,"ServiceTypeID_varchar":0,"FromDate_datetime":"2023-02-01","ToDate_datetime":"2023-03-03","LocUserID_int":"6","PortalUserID_bit":0}}';
    final response =
        await http.post(url, headers: headers, body: json.toString());
    if (response.statusCode == 400) {
      String err = 'something went wrong!';
    } else {
      final String jsonString = jsonEncode(response.body);
      var decodedJson = jsonDecode(jsonString);
      Map<String, dynamic> map = jsonDecode(decodedJson);
      var result = map['VwDAssetLocationGroupWiseCount'];
      for (Map<String, dynamic> i in result) {
        locationGroupCount.add(VwDAssetLocationGroupWiseCount.fromJson(i));
      }
      locationGroupCount
          .sort((a, b) => int.parse(a.y!).compareTo(int.parse(b.y!)));
      timerFunction();
    }
  }

  Future<void> locationWiseApi() async {
    String? ip = '/VwDAssetLocationWiseCount/';
    const service = ApiConfig.service;
    final url = Uri.parse('$service$ip');
    final headers = {'Accept': 'application/json'};
    const json =
        '{"data":{"CountryID_varchar":0,"CustomerID_varchar":0,"ContractID_varchar":0,"LocationGroupID_varchar":0,"LocalityID_varchar":0,"BuildingID_varchar":0,"CityID_varchar":0,"FloorID_varchar":0,"SpotID_varchar":0,"DivisionID_varchar":0,"DisciplineID_varchar":0,"ServiceTypeID_varchar":0,"FromDate_datetime":"2023-02-01","ToDate_datetime":"2023-03-03","LocUserID_int":"6","PortalUserID_bit":0}}';
    final response =
        await http.post(url, headers: headers, body: json.toString());
    if (response.statusCode == 400) {
      String err = 'something went wrong!';
    } else {
      final String jsonString = jsonEncode(response.body);
      var decodedJson = jsonDecode(jsonString);
      Map<String, dynamic> map = jsonDecode(decodedJson);
      var result = map['VwDAssetLocationWiseCount'];
      for (Map<String, dynamic> i in result) {
        locationWiseCount.add(VwDAssetLocationWiseCount.fromJson(i));
      }
      locationWiseCount
          .sort((a, b) => int.parse(a.y!).compareTo(int.parse(b.y!)));

      timerFunction();
    }
  }

  Future<void> buildingWiseApi() async {
    String? ip = '/VwDAssetBuildingWiseCount/';
    const service = ApiConfig.service;
    final url = Uri.parse('$service$ip');
    final headers = {'Accept': 'application/json'};
    const json =
        '{"data":{"CountryID_varchar":0,"CustomerID_varchar":0,"ContractID_varchar":0,"LocationGroupID_varchar":0,"LocalityID_varchar":0,"BuildingID_varchar":0,"CityID_varchar":0,"FloorID_varchar":0,"SpotID_varchar":0,"DivisionID_varchar":0,"DisciplineID_varchar":0,"ServiceTypeID_varchar":0,"FromDate_datetime":"2015-03-01","ToDate_datetime":"2023-03-03","LocUserID_int":"6","PortalUserID_bit":0}}';
    final response =
        await http.post(url, headers: headers, body: json.toString());
    if (response.statusCode == 400) {
      String err = 'something went wrong!';
    } else {
      final String jsonString = jsonEncode(response.body);
      var decodedJson = jsonDecode(jsonString);
      Map<String, dynamic> map = jsonDecode(decodedJson);
      var result = map['VwDAssetBuildingWiseCount'];
      for (Map<String, dynamic> i in result) {
        buildingWiseCount.add(VwDAssetBuildingWiseCount.fromJson(i));
      }
      buildingWiseCount
          .sort((a, b) => int.parse(a.y!).compareTo(int.parse(b.y!)));

      timerFunction();
    }
  }

  Future<void> assetWarrantyApi() async {
    String? ip = '/VwDAssetWarrStatus/';
    const service = ApiConfig.service;
    final url = Uri.parse('$service$ip');
    final headers = {'Accept': 'application/json'};
    const json =
        '{"data":{"CountryID_varchar":0,"CustomerID_varchar":0,"ContractID_varchar":0,"LocationGroupID_varchar":0,"LocalityID_varchar":0,"BuildingID_varchar":0,"CityID_varchar":0,"FloorID_varchar":0,"SpotID_varchar":0,"DivisionID_varchar":0,"DisciplineID_varchar":0,"ServiceTypeID_varchar":0,"FromDate_datetime":"2023-02-02","ToDate_datetime":"2023-03-04","LocUserID_int":"6","PortalUserID_bit":0}}';
    final response =
        await http.post(url, headers: headers, body: json.toString());
    if (response.statusCode == 400) {
      String err = 'something went wrong!';
    } else {
      final String jsonString = jsonEncode(response.body);
      var decodedJson = jsonDecode(jsonString);
      Map<String, dynamic> map = jsonDecode(decodedJson);
      var result = map['VwDAssetWarrStatus'];
      for (Map<String, dynamic> i in result) {
        assetWarrantyCount.add(VwDAssetWarrStatus.fromJson(i));
      }
      timerFunction();
    }
  }

  Future<void> assetAMCApi() async {
    String? ip = '/VwDAssetAMCStatus/';
    const service = ApiConfig.service;
    final url = Uri.parse('$service$ip');
    final headers = {'Accept': 'application/json'};
    const json =
        '{"data":{"CountryID_varchar":0,"CustomerID_varchar":0,"ContractID_varchar":0,"LocationGroupID_varchar":0,"LocalityID_varchar":0,"BuildingID_varchar":0,"CityID_varchar":0,"FloorID_varchar":0,"SpotID_varchar":0,"DivisionID_varchar":0,"DisciplineID_varchar":0,"ServiceTypeID_varchar":0,"FromDate_datetime":"2023-02-02","ToDate_datetime":"2023-03-04","LocUserID_int":"6","PortalUserID_bit":0}}';
    final response =
        await http.post(url, headers: headers, body: json.toString());
    if (response.statusCode == 400) {
      String err = 'something went wrong!';
    } else {
      final String jsonString = jsonEncode(response.body);
      var decodedJson = jsonDecode(jsonString);
      Map<String, dynamic> map = jsonDecode(decodedJson);
      var result = map['VwDAssetAMCStatus'];
      for (Map<String, dynamic> i in result) {
        assetAMCCount.add(VwDAssetAMCStatus.fromJson(i));
      }
      timerFunction();
    }
  }

  Future<void> assetInsuranceApi() async {
    String? ip = '/VwDAssetInsurStatus/';
    const service = ApiConfig.service;
    final url = Uri.parse('$service$ip');
    final headers = {'Accept': 'application/json'};
    const json =
        '{"data":{"CountryID_varchar":0,"CustomerID_varchar":0,"ContractID_varchar":0,"LocationGroupID_varchar":0,"LocalityID_varchar":0,"BuildingID_varchar":0,"CityID_varchar":0,"FloorID_varchar":0,"SpotID_varchar":0,"DivisionID_varchar":0,"DisciplineID_varchar":0,"ServiceTypeID_varchar":0,"FromDate_datetime":"2023-02-02","ToDate_datetime":"2023-03-04","LocUserID_int":"6","PortalUserID_bit":0}}';
    final response =
        await http.post(url, headers: headers, body: json.toString());
    if (response.statusCode == 400) {
      String err = 'something went wrong!';
    } else {
      final String jsonString = jsonEncode(response.body);
      var decodedJson = jsonDecode(jsonString);
      Map<String, dynamic> map = jsonDecode(decodedJson);
      var result = map['VwDAssetInsurStatus'];
      for (Map<String, dynamic> i in result) {
        assetInsuranceCount.add(VwDAssetInsurStatus.fromJson(i));
      }
      timerFunction();
    }
  }

  Future<void> assetInstalledApi() async {
    String? ip = '/VwDAssetByYearStatus/';
    const service = ApiConfig.service;
    final url = Uri.parse('$service$ip');
    final headers = {'Accept': 'application/json'};
    const json =
        '{"data":{"CountryID_varchar":0,"CustomerID_varchar":0,"ContractID_varchar":0,"LocationGroupID_varchar":0,"LocalityID_varchar":0,"BuildingID_varchar":0,"CityID_varchar":0,"FloorID_varchar":0,"SpotID_varchar":0,"DivisionID_varchar":0,"DisciplineID_varchar":0,"ServiceTypeID_varchar":0,"FromDate_datetime":"2023-02-02","ToDate_datetime":"2023-03-04","LocUserID_int":"6","PortalUserID_bit":0}}';
    final response =
        await http.post(url, headers: headers, body: json.toString());
    if (response.statusCode == 400) {
      String err = 'something went wrong!';
    } else {
      final String jsonString = jsonEncode(response.body);
      var decodedJson = jsonDecode(jsonString);
      Map<String, dynamic> map = jsonDecode(decodedJson);
      var result = map['VwDAssetByYearStatus'];
      for (Map<String, dynamic> i in result) {
        assetInstalledCount.add(VwDAssetByYearStatus.fromJson(i));
      }
      timerFunction();
    }
  }

  Future<void> assetAgeingApi() async {
    String? ip = '/VwDAssetAgeingStatus/';
    const service = ApiConfig.service;
    final url = Uri.parse('$service$ip');
    final headers = {'Accept': 'application/json'};
    const json =
        '{"data":{"CountryID_varchar":0,"CustomerID_varchar":0,"ContractID_varchar":0,"LocationGroupID_varchar":0,"LocalityID_varchar":0,"BuildingID_varchar":0,"CityID_varchar":0,"FloorID_varchar":0,"SpotID_varchar":0,"DivisionID_varchar":0,"DisciplineID_varchar":0,"ServiceTypeID_varchar":0,"FromDate_datetime":"2023-02-02","ToDate_datetime":"2023-03-04","LocUserID_int":"6","PortalUserID_bit":0}}';
    final response =
        await http.post(url, headers: headers, body: json.toString());
    if (response.statusCode == 400) {
      String err = 'something went wrong!';
    } else {
      final String jsonString = jsonEncode(response.body);
      var decodedJson = jsonDecode(jsonString);
      Map<String, dynamic> map = jsonDecode(decodedJson);
      var result = map['VwDAssetAgeingStatus'];
      for (Map<String, dynamic> i in result) {
        assetAgeingCount.add(VwDAssetAgeingStatus.fromJson(i));
      }
      timerFunction();
    }
  }

  Future<void> chartTappedDataTable() async {
    cardBorder = 7;
    displayChartWidget();
    setState(() {
      displayChart.insert(0, displayChart.removeAt(7));
    });
    chartDataTable.clear();
    String? ip = '/VwDAssetPopUpGrdDet/';
    const service = ApiConfig.service;
    final url = Uri.parse('$service$ip');
    final headers = {'Accept': 'application/json'};
    final json =
        '{"data":{"CountryID_varchar":0,"CustomerID_varchar":0,"ContractID_varchar":0,"LocationGroupID_varchar":0,"LocalityID_varchar":0,"BuildingID_varchar":0,"CityID_varchar":0,"FloorID_varchar":0,"SpotID_varchar":0,"DivisionID_varchar":null,"DisciplineID_varchar":null,"ServiceTypeID_varchar":null,"FromDate_datetime":"2023-02-02","ToDate_datetime":"2023-03-06","LocUserID_int":"6","PortalUserID_bit":null,"HeaderID_int":16,"DataParam1_varchar":"$tappedValue","DataParam2_varchar":"","DataParam3_varchar":null,"PageIndex_int":1,"PageSize_int":10,"ResultCount_int":null}}';
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
        chartDataTable.add(VwDAssetPopUpGrdDet.fromJson(i));
      }
      timerFunction();
    }
    setState(() {
      widget.singCardView = true;
      widget.detailBackMenu = true;
      widget.sideNav = false;
      widget.pageName = 'Assets';
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
                            : assetCountChart(),
                      ),
                      Flexible(
                        flex: 2,
                        child: timer == true
                            ? webShimmer(shimmerHeight)
                            : divisionWiseChart(),
                      ),
                      Flexible(
                        flex: 2,
                        child: timer == true
                            ? webShimmer(shimmerHeight)
                            : disciplineWiseChart(),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        flex: 2,
                        child: timer == true
                            ? webShimmer(shimmerHeight)
                            : assetsInPPMChart(),
                      ),
                      Flexible(
                        flex: 2,
                        child: timer == true
                            ? webShimmer(shimmerHeight)
                            : assetsOccuredInBDMChart(),
                      ),
                      Flexible(
                        flex: 2,
                        child: timer == true
                            ? webShimmer(shimmerHeight)
                            : assetsInspectionChart(),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        flex: 2,
                        child: timer == true
                            ? webShimmer(shimmerHeight)
                            : assetsBmsChart(),
                      ),
                      Flexible(
                        flex: 2,
                        child: timer == true
                            ? webShimmer(shimmerHeight)
                            : locationGroupWiseChart(),
                      ),
                      Flexible(
                        flex: 2,
                        child: timer == true
                            ? webShimmer(shimmerHeight)
                            : locationWiseChart(),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        flex: 2,
                        child: timer == true
                            ? webShimmer(shimmerHeight)
                            : buildingWiseChart(),
                      ),
                      Flexible(
                        flex: 2,
                        child: timer == true
                            ? webShimmer(shimmerHeight)
                            : byAssetWarrantyExpiryChart(),
                      ),
                      Flexible(
                        flex: 2,
                        child: timer == true
                            ? webShimmer(shimmerHeight)
                            : byAssetAMCExpiryChart(),
                      ),
                      // Flexible(
                      //   flex: 2,
                      //   child: timer == true
                      //       ? webShimmer(shimmerHeight)
                      //       : locationWiseChart(),
                      // )
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
                        color: Colors.white,
                        elevation: 4,
                        shadowColor: Colors.black12,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Flexible(
                                      flex: 2,
                                      child: Text(' By Asset Insurance Expiry',
                                          overflow: TextOverflow.ellipsis,
                                          style: cartHeaderStyle),
                                    ),
                                    Icon(Icons.mail, color: secondaryColor),
                                  ],
                                ),
                              ),
                              Flexible(
                                flex: 2,
                                // height: 220,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Flexible(
                                      flex: 1,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Flexible(
                                            flex: 1,
                                            child: HoverAnimatedContainer(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color:
                                                        grey1, // red as border color
                                                  ),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(10)),
                                                  color: Colors.white,
                                                ),
                                                hoverDecoration:
                                                    const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10)),
                                                  color: trending21,
                                                ),
                                                width: 130,
                                                height: 60,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: const [
                                                      Flexible(
                                                        flex: 1,
                                                        child: Text('1 (0.02%)',
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 13,
                                                              color: trending5,
                                                            )),
                                                      ),
                                                      Flexible(
                                                        flex: 2,
                                                        child: Text(
                                                            'Assets Insurance In Active',
                                                            style: TextStyle(
                                                                fontSize: 10,
                                                                color:
                                                                    buttonBackground)),
                                                      ),
                                                    ],
                                                  ),
                                                )),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Flexible(
                                            flex: 1,
                                            child: HoverAnimatedContainer(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color:
                                                        grey1, // red as border color
                                                  ),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(10)),
                                                  color: Colors.white,
                                                ),
                                                hoverDecoration:
                                                    const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10)),
                                                  color: trending21,
                                                ),
                                                width: 130,
                                                height: 60,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: const [
                                                      Flexible(
                                                        flex: 1,
                                                        child: Text('0 (0%)',
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 13,
                                                              color: trending6,
                                                            )),
                                                      ),
                                                      Flexible(
                                                        flex: 2,
                                                        child: Text(
                                                            'Assets Insurance Expired',
                                                            style: TextStyle(
                                                                fontSize: 10,
                                                                color:
                                                                    buttonBackground)),
                                                      ),
                                                    ],
                                                  ),
                                                )),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Flexible(
                                            flex: 1,
                                            child: HoverAnimatedContainer(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color:
                                                        grey1, // red as border color
                                                  ),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(10)),
                                                  color: Colors.white,
                                                ),
                                                hoverDecoration:
                                                    const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10)),
                                                  color: trending21,
                                                ),
                                                width: 130,
                                                height: 60,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: const [
                                                      Flexible(
                                                        flex: 1,
                                                        child: Text(
                                                            '6336 (99.98%)',
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 13,
                                                              color: trending7,
                                                            )),
                                                      ),
                                                      Flexible(
                                                        flex: 2,
                                                        child: Text(
                                                            'Assets Not Insured',
                                                            style: TextStyle(
                                                                fontSize: 10,
                                                                color:
                                                                    buttonBackground)),
                                                      ),
                                                    ],
                                                  ),
                                                )),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Flexible(
                                      flex: 4,
                                      child: SfCartesianChart(
                                          plotAreaBorderWidth: 0,
                                          tooltipBehavior:
                                              TooltipBehavior(enable: true),
                                          legend: Legend(
                                              isVisible: true,
                                              position: LegendPosition.top),
                                          primaryXAxis: CategoryAxis(
                                            isVisible: true,
                                          ),
                                          series: <ChartSeries>[
                                            ColumnSeries<VwDAssetInsurStatus,
                                                String>(
                                              // onPointTap: (pointInteractionDetails) {
                                              //   tappedValue = pointInteractionDetails
                                              //       .dataPoints![pointInteractionDetails.pointIndex!].x;
                                              //   setState(() {
                                              //     tableName = 'By Division';
                                              //   });
                                              //   chartTappedDataTable(tappedValue);
                                              // },
                                              dataSource: assetInsuranceCount,
                                              xValueMapper:
                                                  (VwDAssetInsurStatus data,
                                                          _) =>
                                                      data.montName,
                                              yValueMapper: (VwDAssetInsurStatus
                                                          data,
                                                      _) =>
                                                  int.parse('${data.totalCnt}'),
                                              trackColor: Colors.transparent,
                                              name:
                                                  'Showing Records For Next 4 Months',
                                              // color: trending23,
                                              borderRadius:
                                                  const BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(20),
                                                      topRight:
                                                          Radius.circular(20)),
                                              gradient: const LinearGradient(
                                                  colors:
                                                      GradientColors.redLove),
                                              dataLabelSettings:
                                                  const DataLabelSettings(
                                                      isVisible: true,
                                                      color: Colors.black,
                                                      opacity: 0.8,
                                                      labelAlignment:
                                                          ChartDataLabelAlignment
                                                              .outer),
                                            ),
                                          ]),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
              ),
              Flexible(
                flex: 2,
                child: timer == true
                    ? webShimmer(shimmerHeight)
                    : Card(
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
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Flexible(
                                      flex: 2,
                                      child: Text(' Assets Installed By year',
                                          overflow: TextOverflow.ellipsis,
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
                                    tooltipBehavior:
                                        TooltipBehavior(enable: true),
                                    legend: Legend(
                                        isVisible: true,
                                        position: LegendPosition.top),
                                    primaryXAxis: CategoryAxis(
                                      isVisible: true,
                                    ),
                                    primaryYAxis: CategoryAxis(
                                      isVisible: false,
                                    ),
                                    series: <ChartSeries>[
                                      ColumnSeries<VwDAssetByYearStatus,
                                          String>(
                                        // onPointTap: (pointInteractionDetails) {
                                        //   tappedValue = pointInteractionDetails
                                        //       .dataPoints![pointInteractionDetails.pointIndex!].x;
                                        //   setState(() {
                                        //     tableName = 'By Division';
                                        //   });
                                        //   chartTappedDataTable(tappedValue);
                                        // },
                                        dataSource: assetInstalledCount,
                                        xValueMapper:
                                            (VwDAssetByYearStatus data, _) =>
                                                data.assetPurYear,
                                        yValueMapper:
                                            (VwDAssetByYearStatus data, _) =>
                                                int.parse('${data.totalAsset}'),
                                        trackColor: Colors.transparent,
                                        name: 'By Year',
                                        //color: trending24,
                                        borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            topRight: Radius.circular(20)),
                                        gradient: const LinearGradient(
                                            colors:
                                                GradientColors.happyMemories),
                                        dataLabelSettings:
                                            const DataLabelSettings(
                                                isVisible: true,
                                                color: Colors.black,
                                                opacity: 0.8,
                                                labelAlignment:
                                                    ChartDataLabelAlignment
                                                        .outer),
                                      ),
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
                    ? webShimmer(shimmerHeight)
                    : assetAgeingChart(),
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
      child: assetListView(
          data: chartDataTable, tappedValue: tappedValue, tableName: tableName),
    );
  }

  Widget cardView() {
    final scaleFactor = MediaQuery.of(context).textScaleFactor;
    return Flexible(
      flex: 2,
      child: assetCardView(
          data: chartDataTable, tappedValue: tappedValue, tableName: tableName),
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
                            : assetCountChart(),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        flex: 2,
                        child: timer == true
                            ? MobileShimmer(shimmerHeight)
                            : divisionWiseChart(),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        flex: 2,
                        child: timer == true
                            ? MobileShimmer(shimmerHeight)
                            : disciplineWiseChart(),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        flex: 2,
                        child: timer == true
                            ? MobileShimmer(shimmerHeight)
                            : assetsInPPMChart(),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        flex: 2,
                        child: timer == true
                            ? MobileShimmer(shimmerHeight)
                            : assetsOccuredInBDMChart(),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                          flex: 2,
                          child: timer == true
                              ? MobileShimmer(shimmerHeight)
                              : assetsInspectionChart()),
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        flex: 2,
                        child: timer == true
                            ? MobileShimmer(shimmerHeight)
                            : assetsBmsChart(),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        flex: 2,
                        child: timer == true
                            ? MobileShimmer(shimmerHeight)
                            : locationGroupWiseChart(),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        flex: 2,
                        child: timer == true
                            ? MobileShimmer(shimmerHeight)
                            : locationWiseChart(),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        flex: 2,
                        child: timer == true
                            ? MobileShimmer(shimmerHeight)
                            : buildingWiseChart(),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        flex: 2,
                        child: timer == true
                            ? MobileShimmer(shimmerHeight)
                            : byAssetWarrantyExpiryChart(),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        flex: 2,
                        child: timer == true
                            ? MobileShimmer(shimmerHeight)
                            : byAssetAMCExpiryChart(),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        flex: 2,
                        child: timer == true
                            ? MobileShimmer(shimmerHeight)
                            : byAssetInsuranceExpiryChart(),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        flex: 2,
                        child: timer == true
                            ? MobileShimmer(shimmerHeight)
                            : byAssetInstalledChart(),
                      )
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
                    : assetAgeingChart(),
              )
            ])),
          ]),
        ),
      ),
    );
  }

  Widget assetCountChart() {
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
                                    Text('${count[0].totalAsset}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 26,
                                          color: trending5,
                                        )),
                                    const Text('Total Assets',
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
                                    Text('${count[0].totalVal}',
                                        style: const TextStyle(
                                            fontSize: 26,
                                            color: trending4,
                                            fontWeight: FontWeight.w600)),
                                    const Text('Total Assets Value',
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
                                    Text('${count[0].scrappedCnt}',
                                        style: const TextStyle(
                                            fontSize: 26,
                                            color: cardText2,
                                            fontWeight: FontWeight.w600)),
                                    const Text('Scrapped Assets  ',
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
                                    Text('${count[0].transCnt}',
                                        style: const TextStyle(
                                          fontSize: 26,
                                          fontWeight: FontWeight.w600,
                                          color: red,
                                        )),
                                    const Text('Asset Transfer',
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

  Widget divisionWiseChart() {
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
                      child: Text(' Division Wise', style: cartHeaderStyle)),
                  Icon(Icons.mail, color: secondaryColor),
                ],
              ),
            ),
            SizedBox(
              height: 220,
              child: SfCircularChart(
                  palette: const <Color>[
                    trending10,
                    trending17,
                    trending3,
                    trending6,
                    trending20,
                  ],
                  tooltipBehavior: TooltipBehavior(enable: true),
                  legend: Legend(isVisible: true, position: LegendPosition.top),
                  series: <CircularSeries>[
                    PieSeries<VwDAssetDivisionWisePerc, String>(
                        explode: true,
                        dataLabelSettings: const DataLabelSettings(
                            isVisible: true,
                            color: grey1,
                            opacity: 0.8,
                            labelAlignment: ChartDataLabelAlignment.middle),
                        dataSource: divisionCount.sublist(0, 5),
                        dataLabelMapper: (VwDAssetDivisionWisePerc data, _) =>
                            data.divPerc,
                        xValueMapper: (VwDAssetDivisionWisePerc data, _) =>
                            data.label,
                        yValueMapper: (VwDAssetDivisionWisePerc data, _) =>
                            int.parse('${data.y}')),
                  ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget disciplineWiseChart() {
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
                      child: Text(' Discipline Wise', style: cartHeaderStyle)),
                  Icon(Icons.mail, color: secondaryColor),
                ],
              ),
            ),
            SizedBox(
              height: 220,
              child: SfCircularChart(
                  palette: const <Color>[
                    trending7,
                    trending2,
                    trending4,
                    trending18,
                    trending9,
                  ],
                  tooltipBehavior: TooltipBehavior(enable: true),
                  legend: Legend(isVisible: true, position: LegendPosition.top),
                  series: <CircularSeries>[
                    PieSeries<VwDAssetDisciplineWisePerc, String>(
                        explode: true,
                        dataLabelSettings: const DataLabelSettings(
                            isVisible: true,
                            color: grey1,
                            opacity: 0.8,
                            labelAlignment: ChartDataLabelAlignment.middle),
                        dataSource: disciplineCount.sublist(0, 5),
                        dataLabelMapper: (VwDAssetDisciplineWisePerc data, _) =>
                            data.disPerc,
                        xValueMapper: (VwDAssetDisciplineWisePerc data, _) =>
                            data.label,
                        yValueMapper: (VwDAssetDisciplineWisePerc data, _) =>
                            int.parse('${data.y}'))
                  ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget assetsInPPMChart() {
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
                      child: Text(' Assets In PPM', style: cartHeaderStyle),
                    ),
                    Icon(Icons.mail, color: secondaryColor),
                  ],
                ),
              ),
              SizedBox(
                  height: 220,
                  child: CircularPercentIndicator(
                    animationDuration: 2000,
                    animation: true,
                    radius: 60.0,
                    lineWidth: 18,
                    percent: double.parse('${assetPpmCount[0].pPMPerc}') / 100,
                    center: Text(
                        "${assetPpmCount[0].pPMPerc}% ${assetPpmCount[0].totalPPMAsset}",
                        style: cartHeaderStyle),
                    progressColor: trending3,
                    footer: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                          "Number Of Defect Asset ${assetPpmCount[0].defectAssetsCnt}",
                          style: commonStyle),
                    ),
                  )),
            ],
          ),
        ));
  }

  Widget assetsOccuredInBDMChart() {
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
                      child:
                          Text('Asset Occured in BDM', style: cartHeaderStyle),
                    ),
                    Icon(Icons.mail, color: secondaryColor),
                  ],
                ),
              ),
              SizedBox(
                  height: 220,
                  child: CircularPercentIndicator(
                    animationDuration: 2000,
                    animation: true,
                    radius: 60.0,
                    lineWidth: 18,
                    percent: double.parse('${assetBdmCount[0].bDMPerc}') / 100,
                    center: Text(
                        "${assetBdmCount[0].bDMPerc}% ${assetBdmCount[0].totalBDMAsset}",
                        style: cartHeaderStyle),
                    progressColor: trending6,
                    footer: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                          "Current Asset in BDM ${assetBdmCount[0].currentlyInBDMCnt}",
                          style: commonStyle),
                    ),
                  )),
            ],
          ),
        ));
  }

  Widget assetsInspectionChart() {
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
                      child:
                          Text('Asset In Inspection', style: cartHeaderStyle),
                    ),
                    Icon(Icons.mail, color: secondaryColor),
                  ],
                ),
              ),
              SizedBox(
                  height: 220,
                  child: CircularPercentIndicator(
                    animationDuration: 2000,
                    animation: true,
                    radius: 60.0,
                    lineWidth: 18,
                    percent:
                        double.parse('${assetInspectionCount[0].inspPerc}') /
                            100,
                    center: Text(
                        "${assetInspectionCount[0].inspPerc}% ${assetInspectionCount[0].totalDSMAsset}",
                        style: cartHeaderStyle),
                    progressColor: trending1,
                    footer: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                          "No Of Critical Asset ${assetInspectionCount[0].criticalAssetsCnt}",
                          style: commonStyle),
                    ),
                  )),
            ],
          ),
        ));
  }

  Widget assetsBmsChart() {
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
                      child: Text('Asset In BMS', style: cartHeaderStyle),
                    ),
                    Icon(Icons.mail, color: secondaryColor),
                  ],
                ),
              ),
              SizedBox(
                  height: 220,
                  child: CircularPercentIndicator(
                    animationDuration: 2000,
                    animation: true,
                    radius: 60.0,
                    lineWidth: 18,
                    percent: double.parse('${assetBmsCount[0].bMSPerc}') / 100,
                    center: Text(
                        "${assetBmsCount[0].bMSPerc}% ${assetBmsCount[0].totalAsset}",
                        style: cartHeaderStyle),
                    progressColor: trending8,
                    footer: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                          "No Of Assets In BMS ${assetBmsCount[0].totalBMSAsset}",
                          style: commonStyle),
                    ),
                  )),
            ],
          ),
        ));
  }

  Widget locationGroupWiseChart() {
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
                    child: Text(' Location Group Wise', style: cartHeaderStyle),
                  ),
                  Icon(Icons.mail, color: secondaryColor),
                ],
              ),
            ),
            SizedBox(
              height: 220,
              child: SfCartesianChart(
                  plotAreaBorderWidth: 0,
                  tooltipBehavior: TooltipBehavior(
                    enable: true,
                  ),
                  legend: Legend(isVisible: true, position: LegendPosition.top),
                  primaryXAxis: CategoryAxis(isVisible: true),
                  primaryYAxis: CategoryAxis(isVisible: false),
                  series: <ChartSeries>[
                    StackedBarSeries<VwDAssetLocationGroupWiseCount, String>(
                        onPointTap: (pointInteractionDetails) {
                          var val;
                          val = pointInteractionDetails
                              .dataPoints![pointInteractionDetails.pointIndex!]
                              .x;
                          setState(() {
                            tableName = 'Location Group';
                            tappedValue = val;
                          });
                          chartTappedDataTable();
                        },
                        dataLabelSettings: const DataLabelSettings(
                            labelAlignment: ChartDataLabelAlignment.outer,
                            textStyle: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w600),
                            isVisible: true,
                            showCumulativeValues: true),
                        name: 'Top 5 Records',
                        borderRadius: BorderRadius.circular(2),
                        color: trending8,
                        dataSource: locationGroupCount.sublist(
                            locationGroupCount.length - 5,
                            locationGroupCount.length),
                        xValueMapper:
                            (VwDAssetLocationGroupWiseCount data, _) =>
                                data.label,
                        yValueMapper:
                            (VwDAssetLocationGroupWiseCount data, _) =>
                                int.parse(' ${data.y}')),
                  ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget locationWiseChart() {
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
                    child: Text(' Location Wise', style: cartHeaderStyle),
                  ),
                  Icon(Icons.mail, color: secondaryColor),
                ],
              ),
            ),
            SizedBox(
              height: 220,
              child: SfCartesianChart(
                  plotAreaBorderWidth: 0,
                  tooltipBehavior: TooltipBehavior(
                    enable: true,
                  ),
                  legend: Legend(isVisible: true, position: LegendPosition.top),
                  primaryXAxis: CategoryAxis(isVisible: true),
                  primaryYAxis: CategoryAxis(isVisible: false),
                  series: <ChartSeries>[
                    StackedBarSeries<VwDAssetLocationWiseCount, String>(
                        dataLabelSettings: const DataLabelSettings(
                            labelAlignment: ChartDataLabelAlignment.middle,
                            textStyle: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w600),
                            isVisible: true,
                            showCumulativeValues: true),
                        name: 'Top 5 Records',
                        borderRadius: BorderRadius.circular(2),
                        color: trending3,
                        dataSource: locationWiseCount.sublist(
                            locationWiseCount.length - 5,
                            locationWiseCount.length),
                        xValueMapper: (VwDAssetLocationWiseCount data, _) =>
                            data.label,
                        yValueMapper: (VwDAssetLocationWiseCount data, _) =>
                            int.parse(' ${data.y}')),
                  ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildingWiseChart() {
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
                    child: Text(' Building Wise', style: cartHeaderStyle),
                  ),
                  Icon(Icons.mail, color: secondaryColor),
                ],
              ),
            ),
            SizedBox(
              height: 220,
              child: SfCartesianChart(
                  plotAreaBorderWidth: 0,
                  tooltipBehavior: TooltipBehavior(
                    enable: true,
                  ),
                  legend: Legend(isVisible: true, position: LegendPosition.top),
                  primaryXAxis: CategoryAxis(isVisible: true),
                  primaryYAxis: CategoryAxis(isVisible: false),
                  series: <ChartSeries>[
                    StackedBarSeries<VwDAssetBuildingWiseCount, String>(
                        dataLabelSettings: const DataLabelSettings(
                            labelAlignment: ChartDataLabelAlignment.middle,
                            textStyle: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w600),
                            isVisible: true,
                            showCumulativeValues: true),
                        name: 'Top 5 Records',
                        borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(15),
                            topLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                            topRight: Radius.circular(15)),
                        color: trending10,
                        dataSource: buildingWiseCount.sublist(
                            buildingWiseCount.length - 5,
                            buildingWiseCount.length),
                        xValueMapper: (VwDAssetBuildingWiseCount data, _) =>
                            data.label,
                        yValueMapper: (VwDAssetBuildingWiseCount data, _) =>
                            int.parse(' ${data.y}')),
                  ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget byAssetWarrantyExpiryChart() {
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
                    child: Text(' By Asset Warranty Expiry',
                        overflow: TextOverflow.ellipsis,
                        style: cartHeaderStyle),
                  ),
                  Icon(Icons.mail, color: secondaryColor),
                ],
              ),
            ),
            SizedBox(
              height: 220,
              child: Column(
                children: [
                  Flexible(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Flexible(
                          flex: 1,
                          child: HoverAnimatedContainer(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: grey1, // red as border color
                                ),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                color: Colors.white,
                              ),
                              hoverDecoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                color: trending21,
                              ),
                              width: 130,
                              height: 60,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text('1 (0.02%)',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                          color: trending5,
                                        )),
                                    Text('Assets In Warranty',
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: buttonBackground)),
                                  ],
                                ),
                              )),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Flexible(
                          flex: 1,
                          child: HoverAnimatedContainer(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: grey1, // red as border color
                                ),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                color: Colors.white,
                              ),
                              hoverDecoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                color: trending21,
                              ),
                              width: 130,
                              height: 60,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Flexible(
                                      flex: 1,
                                      child: Text('0 (0%)',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13,
                                            color: trending6,
                                          )),
                                    ),
                                    Flexible(
                                      flex: 2,
                                      child: Text('Assets Warranty Expired',
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: buttonBackground)),
                                    ),
                                  ],
                                ),
                              )),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Flexible(
                          flex: 1,
                          child: HoverAnimatedContainer(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: grey1, // red as border color
                                ),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                color: Colors.white,
                              ),
                              hoverDecoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                color: trending21,
                              ),
                              width: 130,
                              height: 60,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Flexible(
                                      flex: 1,
                                      child: Text('6336 (99.98%)',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13,
                                            color: trending7,
                                          )),
                                    ),
                                    Flexible(
                                      flex: 2,
                                      child: Text('Assets Not In Warranty',
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: buttonBackground)),
                                    ),
                                  ],
                                ),
                              )),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: SfCartesianChart(
                        plotAreaBorderWidth: 0,
                        tooltipBehavior: TooltipBehavior(enable: true),
                        legend: Legend(
                            isVisible: true, position: LegendPosition.top),
                        primaryXAxis: CategoryAxis(
                          isVisible: true,
                        ),
                        series: <ChartSeries>[
                          ColumnSeries<VwDAssetWarrStatus, String>(
                            // onPointTap: (pointInteractionDetails) {
                            //   tappedValue = pointInteractionDetails
                            //       .dataPoints![pointInteractionDetails.pointIndex!].x;
                            //   setState(() {
                            //     tableName = 'By Division';
                            //   });
                            //   chartTappedDataTable(tappedValue);
                            // },
                            dataSource: assetWarrantyCount,
                            xValueMapper: (VwDAssetWarrStatus data, _) =>
                                data.montName,
                            yValueMapper: (VwDAssetWarrStatus data, _) =>
                                int.parse('${data.totalCnt}'),
                            trackColor: Colors.transparent,
                            name: 'Showing Records For Next 4 Months',
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

  Widget byAssetAMCExpiryChart() {
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
                    child: Text(' By Asset AMC Expiry',
                        overflow: TextOverflow.ellipsis,
                        style: cartHeaderStyle),
                  ),
                  Icon(Icons.mail, color: secondaryColor),
                ],
              ),
            ),
            SizedBox(
              height: 220,
              child: Column(
                children: [
                  Flexible(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Flexible(
                          flex: 1,
                          child: HoverAnimatedContainer(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: grey1, // red as border color
                                ),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                color: Colors.white,
                              ),
                              hoverDecoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                color: trending21,
                              ),
                              width: 130,
                              height: 60,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Flexible(
                                      flex: 1,
                                      child: Text('1 (0.02%)',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13,
                                            color: trending5,
                                          )),
                                    ),
                                    Flexible(
                                      flex: 2,
                                      child: Text('Assets In AMC',
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: buttonBackground)),
                                    ),
                                  ],
                                ),
                              )),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Flexible(
                          flex: 1,
                          child: HoverAnimatedContainer(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: grey1, // red as border color
                                ),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                color: Colors.white,
                              ),
                              hoverDecoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                color: trending21,
                              ),
                              width: 130,
                              height: 60,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Flexible(
                                      flex: 1,
                                      child: Text('0 (0%)',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13,
                                            color: trending6,
                                          )),
                                    ),
                                    Flexible(
                                      flex: 2,
                                      child: Text('Assets AMC Expired',
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: buttonBackground)),
                                    ),
                                  ],
                                ),
                              )),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Flexible(
                          flex: 1,
                          child: HoverAnimatedContainer(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: grey1, // red as border color
                                ),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                color: Colors.white,
                              ),
                              hoverDecoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                color: trending21,
                              ),
                              width: 130,
                              height: 60,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Flexible(
                                      flex: 1,
                                      child: Text('6336 (99.98%)',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13,
                                            color: trending7,
                                          )),
                                    ),
                                    Flexible(
                                      flex: 2,
                                      child: Text('Assets Not In AMC',
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: buttonBackground)),
                                    ),
                                  ],
                                ),
                              )),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: SfCartesianChart(
                        plotAreaBorderWidth: 0,
                        tooltipBehavior: TooltipBehavior(enable: true),
                        legend: Legend(
                            isVisible: true, position: LegendPosition.top),
                        primaryXAxis: CategoryAxis(
                          isVisible: true,
                        ),
                        series: <ChartSeries>[
                          ColumnSeries<VwDAssetAMCStatus, String>(
                            // onPointTap: (pointInteractionDetails) {
                            //   tappedValue = pointInteractionDetails
                            //       .dataPoints![pointInteractionDetails.pointIndex!].x;
                            //   setState(() {
                            //     tableName = 'By Division';
                            //   });
                            //   chartTappedDataTable(tappedValue);
                            // },
                            dataSource: assetAMCCount,
                            xValueMapper: (VwDAssetAMCStatus data, _) =>
                                data.montName,
                            yValueMapper: (VwDAssetAMCStatus data, _) =>
                                int.parse('${data.totalCnt}'),
                            trackColor: Colors.transparent,
                            name: 'Showing Records For Next 4 Months',
                            color: trending22,
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

  Widget byAssetInsuranceExpiryChart() {
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
                    child: Text(' By Asset Insurance Expiry',
                        overflow: TextOverflow.ellipsis,
                        style: cartHeaderStyle),
                  ),
                  Icon(Icons.mail, color: secondaryColor),
                ],
              ),
            ),
            SizedBox(
              height: 220,
              child: Column(
                children: [
                  Flexible(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Flexible(
                          flex: 1,
                          child: HoverAnimatedContainer(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: grey1, // red as border color
                                ),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                color: Colors.white,
                              ),
                              hoverDecoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                color: trending21,
                              ),
                              width: 130,
                              height: 60,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Flexible(
                                      flex: 1,
                                      child: Text('1 (0.02%)',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13,
                                            color: trending5,
                                          )),
                                    ),
                                    Flexible(
                                      flex: 2,
                                      child: Text('Assets Insurance In Active',
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: buttonBackground)),
                                    ),
                                  ],
                                ),
                              )),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Flexible(
                          flex: 1,
                          child: HoverAnimatedContainer(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: grey1, // red as border color
                                ),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                color: Colors.white,
                              ),
                              hoverDecoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                color: trending21,
                              ),
                              width: 130,
                              height: 60,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Flexible(
                                      flex: 1,
                                      child: Text('0 (0%)',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13,
                                            color: trending6,
                                          )),
                                    ),
                                    Flexible(
                                      flex: 2,
                                      child: Text('Assets Insurance Expired',
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: buttonBackground)),
                                    ),
                                  ],
                                ),
                              )),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Flexible(
                          flex: 1,
                          child: HoverAnimatedContainer(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: grey1, // red as border color
                                ),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                color: Colors.white,
                              ),
                              hoverDecoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                color: trending21,
                              ),
                              width: 130,
                              height: 60,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Flexible(
                                      flex: 1,
                                      child: Text('6336 (99.98%)',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13,
                                            color: trending7,
                                          )),
                                    ),
                                    Flexible(
                                      flex: 2,
                                      child: Text('Assets Not Insured',
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: buttonBackground)),
                                    ),
                                  ],
                                ),
                              )),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: SfCartesianChart(
                        plotAreaBorderWidth: 0,
                        tooltipBehavior: TooltipBehavior(enable: true),
                        legend: Legend(
                            isVisible: true, position: LegendPosition.top),
                        primaryXAxis: CategoryAxis(
                          isVisible: true,
                        ),
                        series: <ChartSeries>[
                          ColumnSeries<VwDAssetInsurStatus, String>(
                            // onPointTap: (pointInteractionDetails) {
                            //   tappedValue = pointInteractionDetails
                            //       .dataPoints![pointInteractionDetails.pointIndex!].x;
                            //   setState(() {
                            //     tableName = 'By Division';
                            //   });
                            //   chartTappedDataTable(tappedValue);
                            // },
                            dataSource: assetInsuranceCount,
                            xValueMapper: (VwDAssetInsurStatus data, _) =>
                                data.montName,
                            yValueMapper: (VwDAssetInsurStatus data, _) =>
                                int.parse('${data.totalCnt}'),
                            trackColor: Colors.transparent,
                            name: 'Showing Records For Next 4 Months',
                            // color: trending23,
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20)),
                            gradient: const LinearGradient(
                                colors: GradientColors.redLove),
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
          ],
        ),
      ),
    );
  }

  Widget byAssetInstalledChart() {
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
                    child: Text(' Assets Installed By year',
                        overflow: TextOverflow.ellipsis,
                        style: cartHeaderStyle),
                  ),
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
                    ColumnSeries<VwDAssetByYearStatus, String>(
                      // onPointTap: (pointInteractionDetails) {
                      //   tappedValue = pointInteractionDetails
                      //       .dataPoints![pointInteractionDetails.pointIndex!].x;
                      //   setState(() {
                      //     tableName = 'By Division';
                      //   });
                      //   chartTappedDataTable(tappedValue);
                      // },
                      dataSource: assetInstalledCount,
                      xValueMapper: (VwDAssetByYearStatus data, _) =>
                          data.assetPurYear,
                      yValueMapper: (VwDAssetByYearStatus data, _) =>
                          int.parse('${data.totalAsset}'),
                      trackColor: Colors.transparent,
                      name: 'By Year',
                      // color: trending24,
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

  Widget assetAgeingChart() {
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
                    child: Text(' Assets Ageing',
                        overflow: TextOverflow.ellipsis,
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
                  legend: Legend(isVisible: true, position: LegendPosition.top),
                  primaryXAxis: CategoryAxis(
                    isVisible: true,
                  ),
                  primaryYAxis: CategoryAxis(
                    isVisible: false,
                  ),
                  series: <ChartSeries>[
                    ColumnSeries<VwDAssetAgeingStatus, String>(
                      // onPointTap: (pointInteractionDetails) {
                      //   tappedValue = pointInteractionDetails
                      //       .dataPoints![pointInteractionDetails.pointIndex!].x;
                      //   setState(() {
                      //     tableName = 'By Division';
                      //   });
                      //   chartTappedDataTable(tappedValue);
                      // },
                      dataSource: assetAgeingCount,
                      xValueMapper: (VwDAssetAgeingStatus data, _) =>
                          data.assetYears,
                      yValueMapper: (VwDAssetAgeingStatus data, _) =>
                          int.parse('${data.totalAsset}'),
                      trackColor: Colors.transparent,
                      name: 'By Year',
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
                  ]),
            ),
          ],
        ),
      ),
    );
  }

  List<dynamic> displayChartWidget() {
    return displayChart = [
      {"id": 1, "func": assetCountChart()},
      {"id": 2, "func": divisionWiseChart()},
      {"id": 3, "func": disciplineWiseChart()},
      {"id": 4, "func": assetsInPPMChart()},
      {"id": 5, "func": assetsOccuredInBDMChart()},
      {"id": 6, "func": assetsInspectionChart()},
      {"id": 7, "func": assetsBmsChart()},
      {"id": 8, "func": locationGroupWiseChart()},
      {"id": 9, "func": locationWiseChart()},
      {"id": 10, "func": buildingWiseChart()},
      {"id": 11, "func": byAssetWarrantyExpiryChart()},
      {"id": 12, "func": byAssetAMCExpiryChart()},
      {"id": 13, "func": byAssetInsuranceExpiryChart()},
      {"id": 14, "func": byAssetInstalledChart()},
      {"id": 15, "func": assetAgeingChart()}
    ];
  }
}

class VwDAssetStatus {
  String? totalAsset;
  String? totalVal;
  String? scrappedCnt;
  String? snaggedCnt;
  String? assignedtoEmp;
  String? pPMEnabled;
  String? bDMEnabled;
  String? dSMEnabled;
  String? bMSEnabled;
  String? highCnt;
  String? lowCnt;
  String? mediumCnt;
  String? goodCnt;
  String? badCnt;
  String? transCnt;

  VwDAssetStatus(
      {this.totalAsset,
      this.totalVal,
      this.scrappedCnt,
      this.snaggedCnt,
      this.assignedtoEmp,
      this.pPMEnabled,
      this.bDMEnabled,
      this.dSMEnabled,
      this.bMSEnabled,
      this.highCnt,
      this.lowCnt,
      this.mediumCnt,
      this.goodCnt,
      this.badCnt,
      this.transCnt});

  VwDAssetStatus.fromJson(Map<String, dynamic> json) {
    totalAsset = json['TotalAsset'];
    totalVal = json['TotalVal'];
    scrappedCnt = json['ScrappedCnt'];
    snaggedCnt = json['SnaggedCnt'];
    assignedtoEmp = json['AssignedtoEmp'];
    pPMEnabled = json['PPMEnabled'];
    bDMEnabled = json['BDMEnabled'];
    dSMEnabled = json['DSMEnabled'];
    bMSEnabled = json['BMSEnabled'];
    highCnt = json['HighCnt'];
    lowCnt = json['LowCnt'];
    mediumCnt = json['MediumCnt'];
    goodCnt = json['GoodCnt'];
    badCnt = json['BadCnt'];
    transCnt = json['TransCnt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['TotalAsset'] = totalAsset;
    data['TotalVal'] = totalVal;
    data['ScrappedCnt'] = scrappedCnt;
    data['SnaggedCnt'] = snaggedCnt;
    data['AssignedtoEmp'] = assignedtoEmp;
    data['PPMEnabled'] = pPMEnabled;
    data['BDMEnabled'] = bDMEnabled;
    data['DSMEnabled'] = dSMEnabled;
    data['BMSEnabled'] = bMSEnabled;
    data['HighCnt'] = highCnt;
    data['LowCnt'] = lowCnt;
    data['MediumCnt'] = mediumCnt;
    data['GoodCnt'] = goodCnt;
    data['BadCnt'] = badCnt;
    data['TransCnt'] = transCnt;
    return data;
  }
}

class VwDAssetDivisionWisePerc {
  String? label;
  String? y;
  String? divPerc;

  VwDAssetDivisionWisePerc({this.label, this.y, this.divPerc});

  VwDAssetDivisionWisePerc.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    y = json['y'];
    divPerc = json['DivPerc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['label'] = label;
    data['y'] = y;
    data['DivPerc'] = divPerc;
    return data;
  }
}

class VwDAssetDisciplineWisePerc {
  String? label;
  String? y;
  String? disPerc;

  VwDAssetDisciplineWisePerc({this.label, this.y, this.disPerc});

  VwDAssetDisciplineWisePerc.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    y = json['y'];
    disPerc = json['DisPerc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['label'] = label;
    data['y'] = y;
    data['DisPerc'] = disPerc;
    return data;
  }
}

class VwDAssetPPMStatus {
  String? totalAsset;
  String? totalPPMAsset;
  String? defectAssetsCnt;
  String? pPMPerc;
  String? pPMTodayPerc;
  String? woForDay;

  VwDAssetPPMStatus(
      {this.totalAsset,
      this.totalPPMAsset,
      this.defectAssetsCnt,
      this.pPMPerc,
      this.pPMTodayPerc,
      this.woForDay});

  VwDAssetPPMStatus.fromJson(Map<String, dynamic> json) {
    totalAsset = json['TotalAsset'];
    totalPPMAsset = json['TotalPPMAsset'];
    defectAssetsCnt = json['DefectAssetsCnt'];
    pPMPerc = json['PPMPerc'];
    pPMTodayPerc = json['PPMTodayPerc'];
    woForDay = json['WoForDay'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['TotalAsset'] = totalAsset;
    data['TotalPPMAsset'] = totalPPMAsset;
    data['DefectAssetsCnt'] = defectAssetsCnt;
    data['PPMPerc'] = pPMPerc;
    data['PPMTodayPerc'] = pPMTodayPerc;
    data['WoForDay'] = woForDay;
    return data;
  }
}

class VwDAssetBDMStatus {
  String? totalAsset;
  String? totalBDMAsset;
  String? currentlyInBDMCnt;
  String? bDMPerc;
  String? bDMTodayPerc;
  String? woForDay;

  VwDAssetBDMStatus(
      {this.totalAsset,
      this.totalBDMAsset,
      this.currentlyInBDMCnt,
      this.bDMPerc,
      this.bDMTodayPerc,
      this.woForDay});

  VwDAssetBDMStatus.fromJson(Map<String, dynamic> json) {
    totalAsset = json['TotalAsset'];
    totalBDMAsset = json['TotalBDMAsset'];
    currentlyInBDMCnt = json['CurrentlyInBDMCnt'];
    bDMPerc = json['BDMPerc'];
    bDMTodayPerc = json['BDMTodayPerc'];
    woForDay = json['WoForDay'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['TotalAsset'] = totalAsset;
    data['TotalBDMAsset'] = totalBDMAsset;
    data['CurrentlyInBDMCnt'] = currentlyInBDMCnt;
    data['BDMPerc'] = bDMPerc;
    data['BDMTodayPerc'] = bDMTodayPerc;
    data['WoForDay'] = woForDay;
    return data;
  }
}

class VwDAssetInspStatus {
  String? totalAsset;
  String? totalDSMAsset;
  String? criticalAssetsCnt;
  String? inspPerc;
  String? woForDayPerc;
  String? woForDay;

  VwDAssetInspStatus(
      {this.totalAsset,
      this.totalDSMAsset,
      this.criticalAssetsCnt,
      this.inspPerc,
      this.woForDayPerc,
      this.woForDay});

  VwDAssetInspStatus.fromJson(Map<String, dynamic> json) {
    totalAsset = json['TotalAsset'];
    totalDSMAsset = json['TotalDSMAsset'];
    criticalAssetsCnt = json['CriticalAssetsCnt'];
    inspPerc = json['InspPerc'];
    woForDayPerc = json['WoForDayPerc'];
    woForDay = json['WoForDay'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['TotalAsset'] = totalAsset;
    data['TotalDSMAsset'] = totalDSMAsset;
    data['CriticalAssetsCnt'] = criticalAssetsCnt;
    data['InspPerc'] = inspPerc;
    data['WoForDayPerc'] = woForDayPerc;
    data['WoForDay'] = woForDay;
    return data;
  }
}

class VwDAssetBMSStatus {
  String? totalAsset;
  String? totalBMSAsset;
  String? bMSPerc;

  VwDAssetBMSStatus({this.totalAsset, this.totalBMSAsset, this.bMSPerc});

  VwDAssetBMSStatus.fromJson(Map<String, dynamic> json) {
    totalAsset = json['TotalAsset'];
    totalBMSAsset = json['TotalBMSAsset'];
    bMSPerc = json['BMSPerc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['TotalAsset'] = totalAsset;
    data['TotalBMSAsset'] = totalBMSAsset;
    data['BMSPerc'] = bMSPerc;
    return data;
  }
}

class VwDAssetLocationGroupWiseCount {
  String? label;
  String? y;

  VwDAssetLocationGroupWiseCount({this.label, this.y});

  VwDAssetLocationGroupWiseCount.fromJson(Map<String, dynamic> json) {
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

class VwDAssetLocationWiseCount {
  String? label;
  String? y;

  VwDAssetLocationWiseCount({this.label, this.y});

  VwDAssetLocationWiseCount.fromJson(Map<String, dynamic> json) {
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

class VwDAssetBuildingWiseCount {
  String? label;
  String? y;

  VwDAssetBuildingWiseCount({this.label, this.y});

  VwDAssetBuildingWiseCount.fromJson(Map<String, dynamic> json) {
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

class VwDAssetWarrStatus {
  String? totalCnt;
  String? montName;
  String? underWarr;
  String? underWarrExp;
  String? overAllAsset;
  String? underNotWarr;
  String? warrMonth;
  String? warrYear;

  VwDAssetWarrStatus(
      {this.totalCnt,
      this.montName,
      this.underWarr,
      this.underWarrExp,
      this.overAllAsset,
      this.underNotWarr,
      this.warrMonth,
      this.warrYear});

  VwDAssetWarrStatus.fromJson(Map<String, dynamic> json) {
    totalCnt = json['TotalCnt'];
    montName = json['MontName'];
    underWarr = json['UnderWarr'];
    underWarrExp = json['UnderWarrExp'];
    overAllAsset = json['OverAllAsset'];
    underNotWarr = json['UnderNotWarr'];
    warrMonth = json['WarrMonth'];
    warrYear = json['WarrYear'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['TotalCnt'] = totalCnt;
    data['MontName'] = montName;
    data['UnderWarr'] = underWarr;
    data['UnderWarrExp'] = underWarrExp;
    data['OverAllAsset'] = overAllAsset;
    data['UnderNotWarr'] = underNotWarr;
    data['WarrMonth'] = warrMonth;
    data['WarrYear'] = warrYear;
    return data;
  }
}

class VwDAssetAMCStatus {
  String? totalCnt;
  String? montName;
  String? underAMC;
  String? underAMCExp;
  String? overAllAsset;
  String? underNotAMC;
  String? aMCMonth;
  String? aMCYear;

  VwDAssetAMCStatus(
      {this.totalCnt,
      this.montName,
      this.underAMC,
      this.underAMCExp,
      this.overAllAsset,
      this.underNotAMC,
      this.aMCMonth,
      this.aMCYear});

  VwDAssetAMCStatus.fromJson(Map<String, dynamic> json) {
    totalCnt = json['TotalCnt'];
    montName = json['MontName'];
    underAMC = json['UnderAMC'];
    underAMCExp = json['UnderAMCExp'];
    overAllAsset = json['OverAllAsset'];
    underNotAMC = json['UnderNotAMC'];
    aMCMonth = json['AMCMonth'];
    aMCYear = json['AMCYear'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['TotalCnt'] = totalCnt;
    data['MontName'] = montName;
    data['UnderAMC'] = underAMC;
    data['UnderAMCExp'] = underAMCExp;
    data['OverAllAsset'] = overAllAsset;
    data['UnderNotAMC'] = underNotAMC;
    data['AMCMonth'] = aMCMonth;
    data['AMCYear'] = aMCYear;
    return data;
  }
}

class VwDAssetInsurStatus {
  String? totalCnt;
  String? montName;
  String? underInc;
  String? underIncExp;
  String? overAllAsset;
  String? underNotInc;
  String? incMonth;
  String? incYear;

  VwDAssetInsurStatus(
      {this.totalCnt,
      this.montName,
      this.underInc,
      this.underIncExp,
      this.overAllAsset,
      this.underNotInc,
      this.incMonth,
      this.incYear});

  VwDAssetInsurStatus.fromJson(Map<String, dynamic> json) {
    totalCnt = json['TotalCnt'];
    montName = json['MontName'];
    underInc = json['UnderInc'];
    underIncExp = json['UnderIncExp'];
    overAllAsset = json['OverAllAsset'];
    underNotInc = json['UnderNotInc'];
    incMonth = json['IncMonth'];
    incYear = json['IncYear'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['TotalCnt'] = totalCnt;
    data['MontName'] = montName;
    data['UnderInc'] = underInc;
    data['UnderIncExp'] = underIncExp;
    data['OverAllAsset'] = overAllAsset;
    data['UnderNotInc'] = underNotInc;
    data['IncMonth'] = incMonth;
    data['IncYear'] = incYear;
    return data;
  }
}

class VwDAssetByYearStatus {
  String? totalAsset;
  String? assetPurYear;

  VwDAssetByYearStatus({this.totalAsset, this.assetPurYear});

  VwDAssetByYearStatus.fromJson(Map<String, dynamic> json) {
    totalAsset = json['TotalAsset'];
    assetPurYear = json['AssetPurYear'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['TotalAsset'] = totalAsset;
    data['AssetPurYear'] = assetPurYear;
    return data;
  }
}

class VwDAssetAgeingStatus {
  String? totalAsset;
  String? assetYears;

  VwDAssetAgeingStatus({this.totalAsset, this.assetYears});

  VwDAssetAgeingStatus.fromJson(Map<String, dynamic> json) {
    totalAsset = json['TotalAsset'];
    assetYears = json['AssetYears'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['TotalAsset'] = totalAsset;
    data['AssetYears'] = assetYears;
    return data;
  }
}

class VwDAssetPopUpGrdDet {
  String? assetIDPK;
  String? assetTagNo;
  String? equipmentName;
  String? equipmentRefNo;
  String? localityName;
  String? buildingName;
  String? floorName;
  String? spotName;
  String? divisionName;
  String? disciplineName;
  String? barcode;
  String? resultCount;

  VwDAssetPopUpGrdDet(
      {this.assetIDPK,
      this.assetTagNo,
      this.equipmentName,
      this.equipmentRefNo,
      this.localityName,
      this.buildingName,
      this.floorName,
      this.spotName,
      this.divisionName,
      this.disciplineName,
      this.barcode,
      this.resultCount});

  VwDAssetPopUpGrdDet.fromJson(Map<String, dynamic> json) {
    assetIDPK = json['AssetIDPK'];
    assetTagNo = json['AssetTagNo'];
    equipmentName = json['EquipmentName'];
    equipmentRefNo = json['EquipmentRefNo'];
    localityName = json['LocalityName'];
    buildingName = json['BuildingName'];
    floorName = json['FloorName'];
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
    data['FloorName'] = floorName;
    data['SpotName'] = spotName;
    data['DivisionName'] = divisionName;
    data['DisciplineName'] = disciplineName;
    data['Barcode'] = barcode;
    data['ResultCount'] = resultCount;
    return data;
  }
}
