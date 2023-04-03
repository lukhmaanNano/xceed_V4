import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import '../../../Styles/CommonColor.dart';
import '../../../Styles/CommonTextStyle.dart';
import 'assetDetailView.dart';

class assetListView extends StatefulWidget {
  List data = [];
  final String tappedValue, tableName;
  assetListView(
      {Key? key,
      required this.data,
      required this.tappedValue,
      required this.tableName})
      : super(key: key);

  @override
  State<assetListView> createState() => _assetListViewState();
}

class _assetListViewState extends State<assetListView> {
  var ComplaintIDPK;
  final Duration delayed = const Duration(milliseconds: 300);
  @override
  void initState() {
    super.initState();
  }

  Future<void> detailViewFunc() async {
    Navigator.push(
      context,
      PageTransition(
          type: PageTransitionType.rightToLeftWithFade,
          child: assetDetailView(
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
                        label: Text('Tag No',
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: headerStyle),
                      ),
                      DataColumn(
                        label: Text('Asset Name',
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: headerStyle),
                      ),
                      DataColumn(
                        label: Text('Ref No',
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: headerStyle),
                      ),
                      DataColumn(
                        label: Text('Barcode',
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: headerStyle),
                      ),
                      DataColumn(
                        label: Text('Location',
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: headerStyle),
                      ),
                      DataColumn(
                        label: Text('Building',
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: headerStyle),
                      ),
                    ],
                    rows: [
                      DataRow(cells: [
                        DataCell(
                          widget.data[index].assetIDPK == null
                              ? const Center(
                                  child: Text('Loading...'),
                                )
                              : InkWell(
                                  onTap: () {
                                    setState(() {
                                      ComplaintIDPK = widget
                                          .data[index].assetIDPK
                                          .toString();
                                    });
                                    detailViewFunc();
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
                          widget.data[index].assetTagNo == null
                              ? const Text('', style: rowstyle)
                              : Text('${widget.data[index].assetTagNo}',
                                  textAlign: TextAlign.center, style: rowstyle),
                        ),
                        DataCell(
                          widget.data[index].equipmentName == null
                              ? const Text('', style: rowstyle)
                              : Text('${widget.data[index].equipmentName}',
                                  textAlign: TextAlign.center, style: rowstyle),
                        ),
                        DataCell(
                          widget.data[index].equipmentRefNo == null
                              ? const Text('', style: rowstyle)
                              : Text('${widget.data[index].equipmentRefNo}',
                                  textAlign: TextAlign.center, style: rowstyle),
                        ),
                        DataCell(
                          widget.data[index].barcode == null
                              ? const Text('', style: rowstyle)
                              : SizedBox(
                                  width: 80,
                                  child: Text('${widget.data[index].barcode}',
                                      textAlign: TextAlign.start,
                                      style: rowstyle),
                                ),
                        ),
                        DataCell(
                          widget.data[index].localityName == null
                              ? const Text('', style: rowstyle)
                              : Text('${widget.data[index].localityName}',
                                  textAlign: TextAlign.start, style: rowstyle),
                        ),
                        DataCell(
                          widget.data[index].buildingName == null
                              ? const Text('', style: rowstyle)
                              : Text('${widget.data[index].buildingName}',
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
