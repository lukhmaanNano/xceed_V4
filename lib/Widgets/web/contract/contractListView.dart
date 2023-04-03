import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import '../../../Styles/CommonColor.dart';
import '../../../Styles/CommonTextStyle.dart';
import 'contractDetailView.dart';

class ContractListView extends StatefulWidget {
  List data = [];
  final String tableName;
  late int tappedValue;
  ContractListView(
      {Key? key,
      required this.data,
      required this.tappedValue,
      required this.tableName})
      : super(key: key);

  @override
  State<ContractListView> createState() => _ContractListViewState();
}

class _ContractListViewState extends State<ContractListView> {
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
          child: ContractDetailView(
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
                        label: Text('Code',
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: headerStyle),
                      ),
                      DataColumn(
                        label: Text('Name',
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: headerStyle),
                      ),
                      DataColumn(
                        label: Text('Contract Type',
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: headerStyle),
                      ),
                      DataColumn(
                        label: Text('Classification',
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: headerStyle),
                      ),
                      DataColumn(
                        label: Text('contractor',
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: headerStyle),
                      ),
                      DataColumn(
                        label: Text('Business Associate',
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: headerStyle),
                      ),
                    ],
                    rows: [
                      DataRow(cells: [
                        DataCell(
                          widget.data[index].contractIDPK == null
                              ? const Center(
                                  child: Text('Loading...'),
                                )
                              : InkWell(
                                  onTap: () {
                                    setState(() {
                                      ComplaintIDPK = widget
                                          .data[index].contractIDPK
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
                          widget.data[index].contractCode == null
                              ? const Text('', style: rowstyle)
                              : Text('${widget.data[index].contractCode}',
                                  textAlign: TextAlign.center, style: rowstyle),
                        ),
                        DataCell(
                          widget.data[index].contractName == null
                              ? const Text('', style: rowstyle)
                              : Text('${widget.data[index].contractName}',
                                  textAlign: TextAlign.center, style: rowstyle),
                        ),
                        DataCell(
                          widget.data[index].contractTypeName == null
                              ? const Text('', style: rowstyle)
                              : Text('${widget.data[index].contractTypeName}',
                                  textAlign: TextAlign.center, style: rowstyle),
                        ),
                        DataCell(
                          widget.data[index].classification == null
                              ? const Text('', style: rowstyle)
                              : SizedBox(
                                  width: 80,
                                  child: Text(
                                      '${widget.data[index].classification}',
                                      textAlign: TextAlign.start,
                                      style: rowstyle),
                                ),
                        ),
                        DataCell(
                          widget.data[index].contractor == null
                              ? const Text('', style: rowstyle)
                              : Text('${widget.data[index].contractor}',
                                  textAlign: TextAlign.start, style: rowstyle),
                        ),
                        DataCell(
                          widget.data[index].businessAssociate == null
                              ? const Text('', style: rowstyle)
                              : Text('${widget.data[index].businessAssociate}',
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
