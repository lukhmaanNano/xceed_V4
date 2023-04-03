import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;
import '../../../Config.dart';
import '../../../Styles/CommonColor.dart';
import '../../../Styles/CommonTextStyle.dart';
import '../status.dart';

class SlaResponse extends StatefulWidget {
  const SlaResponse({Key? key}) : super(key: key);

  @override
  State<SlaResponse> createState() => _SlaResponseState();
}

class _SlaResponseState extends State<SlaResponse> {
  late String tappedValue, tabelName;
  List<HDResponse> slaResponse = [];
  int? barSeriesId;

  @override
  void initState() {
    super.initState();
    helpdeskSlaResponseApi();
  }

  Future<void> helpdeskSlaResponseApi() async {
    String? ip = 'XceedRest/VwDHelpDeskSLAResponseCount/';
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
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
                  legend: Legend(isVisible: true),
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
                            tabelName = 'SLA-Response';
                          });
                          if (tappedValue == 'Ontime') {
                            barSeriesId = 16;
                          } else {
                            barSeriesId = 15;
                          }
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
}
