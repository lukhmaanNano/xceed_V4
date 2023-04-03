import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:xceed/Widgets/web/ppm/ppmDetailView.dart';
import '../../../Styles/CommonColor.dart';
import '../../../Styles/CommonTextStyle.dart';

class PPMListView extends StatefulWidget {
  List data = [];
  final String tappedValue, tableName;
  PPMListView(
      {Key? key,
      required this.data,
      required this.tappedValue,
      required this.tableName})
      : super(key: key);

  @override
  State<PPMListView> createState() => _PPMListViewState();
}

class _PPMListViewState extends State<PPMListView> {
  var ComplaintIDPK;
  final Duration delayed = const Duration(milliseconds: 300);
  @override
  void initState() {
    super.initState();
  }

  Future<void> ppmDetailView() async {
    Navigator.push(
      context,
      PageTransition(
          type: PageTransitionType.rightToLeftWithFade,
          child: PPMDetailView(
            tappedValue: widget.tappedValue,
            name: widget.tableName,
            ComplaintIDPK: ComplaintIDPK,
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.data.length,
        itemBuilder: (BuildContext context, index) {
          return DelayedDisplay(
            delay: delayed,
            slidingCurve: Curves.fastLinearToSlowEaseIn,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: Colors.white,
              elevation: 4,
              shadowColor: Colors.black12,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                ),
                child: DataTable(
                    headingRowHeight: 30,
                    dataRowHeight: 30,
                    headingRowColor: MaterialStateProperty.resolveWith(
                        (states) => buttonForeground),
                    columns: const [
                      DataColumn(
                        label: Text('Action',
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: headerStyle),
                      ),
                      DataColumn(
                        label: Text('WorkOrder No',
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: headerStyle),
                      ),
                      DataColumn(
                        label: Text('Date',
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: headerStyle),
                      ),
                      DataColumn(
                        label: Text('Status',
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: headerStyle),
                      ),
                      DataColumn(
                        label: Text('Stage Name',
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: headerStyle),
                      ),
                      DataColumn(
                        label: Text('Tag No',
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: headerStyle),
                      ),
                      DataColumn(
                        label: Text('Equipment Name',
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: headerStyle),
                      ),
                    ],
                    rows: [
                      DataRow(cells: [
                        DataCell(
                          widget.data[index].creationAssetIDPK == null
                              ? const Center(
                                  child: Text('Loading...'),
                                )
                              : InkWell(
                                  onTap: () {
                                    setState(() {
                                      ComplaintIDPK = widget
                                          .data[index].creationAssetIDPK
                                          .toString();
                                    });
                                    ppmDetailView();
                                  },
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  child: const Icon(Icons.remove_red_eye,
                                      size: 14, color: secondaryColor),
                                ),
                        ),
                        DataCell(
                          widget.data[index].workOrder == null
                              ? const Text('', style: rowstyle)
                              : Text('${widget.data[index].workOrder}',
                                  textAlign: TextAlign.center, style: rowstyle),
                        ),
                        DataCell(
                          widget.data[index].woDate == null
                              ? const Text('', style: rowstyle)
                              : Text('${widget.data[index].woDate}',
                                  textAlign: TextAlign.center, style: rowstyle),
                        ),
                        DataCell(
                          widget.data[index].woStatus == null
                              ? const Text('', style: rowstyle)
                              : Text('${widget.data[index].woStatus}',
                                  textAlign: TextAlign.center, style: rowstyle),
                        ),
                        DataCell(
                          widget.data[index].stageName == null
                              ? const Text('', style: rowstyle)
                              : SizedBox(
                                  width: 80,
                                  child: Text('${widget.data[index].stageName}',
                                      textAlign: TextAlign.start,
                                      style: rowstyle),
                                ),
                        ),
                        DataCell(
                          widget.data[index].assetTagNo == null
                              ? const Text('', style: rowstyle)
                              : Text('${widget.data[index].assetTagNo}',
                                  textAlign: TextAlign.start, style: rowstyle),
                        ),
                        DataCell(
                          widget.data[index].equipmentName == null
                              ? const Text('', style: rowstyle)
                              : Text('${widget.data[index].equipmentName}',
                                  textAlign: TextAlign.center, style: rowstyle),
                        ),
                      ])
                    ]),
              ),
            ),
          );
        });
  }
}
