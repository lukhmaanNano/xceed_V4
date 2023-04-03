import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import '../../../Styles/CommonColor.dart';
import '../../../Styles/CommonTextStyle.dart';
import 'helpdeskDetailView.dart';

class HelpdeskListView extends StatefulWidget {
  List data = [];
  String tableName, tappedValue;
  HelpdeskListView(
      {Key? key,
      required this.data,
      required this.tappedValue,
      required this.tableName})
      : super(key: key);

  @override
  State<HelpdeskListView> createState() => _HelpdeskListViewState();
}

class _HelpdeskListViewState extends State<HelpdeskListView> {
  var ComplaintIDPK;
  final Duration delayed = const Duration(milliseconds: 300);
  @override
  void initState() {
    super.initState();
  }

  Future<void> helpDeskDetailView() async {
    Navigator.push(
      context,
      PageTransition(
          type: PageTransitionType.rightToLeftWithFade,
          child: HelpdeskTable(
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
                        label: Text('Complaint No',
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: headerStyle),
                      ),
                      DataColumn(
                        label: Text('Reference No',
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: headerStyle),
                      ),
                      DataColumn(
                        label: Text('Date&Time',
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
                        label: Text('Current Status',
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: headerStyle),
                      ),
                      DataColumn(
                        label: Text('Priority',
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: headerStyle),
                      ),
                    ],
                    rows: [
                      DataRow(cells: [
                        DataCell(
                          widget.data[index].complaintIDPK == null
                              ? const Center(
                                  child: Text('Loading...'),
                                )
                              : InkWell(
                                  onTap: () {
                                    setState(() {
                                      ComplaintIDPK = widget
                                          .data[index].complaintIDPK
                                          .toString();
                                    });
                                    helpDeskDetailView();
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
                          widget.data[index].complaintNo == null
                              ? const Text('', style: rowstyle)
                              : Text('${widget.data[index].complaintNo}',
                                  textAlign: TextAlign.center, style: rowstyle),
                        ),
                        DataCell(
                          widget.data[index].cCMStageID == null
                              ? const Text('', style: rowstyle)
                              : Text('${widget.data[index].cCMStageID}',
                                  textAlign: TextAlign.center, style: rowstyle),
                        ),
                        DataCell(
                          widget.data[index].complainedDate == null
                              ? const Text('', style: rowstyle)
                              : Text('${widget.data[index].complainedDate}',
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
                          widget.data[index].woStatus == null
                              ? const Text('', style: rowstyle)
                              : Text('${widget.data[index].woStatus}',
                                  textAlign: TextAlign.start, style: rowstyle),
                        ),
                        DataCell(
                          widget.data[index].priorityName == null
                              ? const Text('', style: rowstyle)
                              : Text('${widget.data[index].priorityName}',
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
