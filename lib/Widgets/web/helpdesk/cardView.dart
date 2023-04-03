import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import '../../../Styles/CommonColor.dart';
import '../../../Styles/CommonTextStyle.dart';
import 'helpdeskDetailView.dart';

class HelpdeskCardView extends StatefulWidget {
  List data = [];
  final String tappedValue, tableName;
  HelpdeskCardView(
      {Key? key,
      required this.data,
      required this.tappedValue,
      required this.tableName})
      : super(key: key);

  @override
  State<HelpdeskCardView> createState() => _HelpdeskCardViewState();
}

class _HelpdeskCardViewState extends State<HelpdeskCardView> {
  var ComplaintIDPK;
  final Duration delayed = const Duration(milliseconds: 300);

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
    final scaleFactor = MediaQuery.of(context).textScaleFactor;
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisExtent: MediaQuery.of(context).size.height * 0.26,
          mainAxisSpacing: 11,
          crossAxisCount: 3,
        ),
        shrinkWrap: true,
        itemCount: widget.data.length,
        itemBuilder: (Context, index) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.24,
                child: DelayedDisplay(
                  delay: delayed,
                  slidingCurve: Curves.fastLinearToSlowEaseIn,
                  child: Scaffold(
                    backgroundColor: primaryColor,
                    body: InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      onTap: () => {
                        setState(() {
                          ComplaintIDPK =
                              widget.data[index].complaintIDPK.toString();
                        }),
                        helpDeskDetailView(),
                      },
                      child: Card(
                          elevation: 4,
                          shadowColor: Colors.black12,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(10),
                                        topLeft: Radius.circular(10)),
                                    color: buttonForeground,
                                  ),
                                  height: 30,
                                  child: Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Compliant No :${widget.data[index].complaintNo}',
                                          style: TextStyle(
                                              fontSize: 12 * scaleFactor,
                                              overflow: TextOverflow.ellipsis,
                                              color: secondaryColor,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Text(
                                          '${widget.data[index].complainedDate}',
                                          style: TextStyle(
                                              fontSize: 10 * scaleFactor,
                                              overflow: TextOverflow.ellipsis,
                                              color: secondaryColor,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                  )),
                              Flexible(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Flexible(
                                          flex: 1,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: const [
                                              Text('Reference No',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.center,
                                                  style: cardHeader),
                                              Text('Stage Name',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.center,
                                                  style: cardHeader),
                                              Text('Current Status',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.center,
                                                  style: cardHeader),
                                              Text('Priority',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.center,
                                                  style: cardHeader),
                                              Text('Nature Of Comlaint',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.center,
                                                  style: cardHeader),
                                            ],
                                          ),
                                        ),
                                        Flexible(
                                          flex: 1,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              widget.data[index].cCMStageID ==
                                                      null
                                                  ? const Text(':',
                                                      style: cardBody)
                                                  : Text(
                                                      ':${widget.data[index].cCMStageID}',
                                                      style: cardBody),
                                              widget.data[index].stageName ==
                                                      null
                                                  ? const Text(':',
                                                      style: cardBody)
                                                  : Text(
                                                      ':${widget.data[index].stageName}',
                                                      style: cardBody),
                                              widget.data[index].woStatus ==
                                                      null
                                                  ? const Text(':',
                                                      style: cardBody)
                                                  : Text(
                                                      ':${widget.data[index].woStatus}',
                                                      style: cardBody),
                                              widget.data[index].priorityName ==
                                                      null
                                                  ? const Text(':',
                                                      style: cardBody)
                                                  : Text(
                                                      ':${widget.data[index].priorityName}',
                                                      style: cardBody),
                                              widget.data[index]
                                                          .complaintNatureName ==
                                                      null
                                                  ? const Text(':',
                                                      style: cardBody)
                                                  : Text(
                                                      ':${widget.data[index].complaintNatureName}',
                                                      style: cardBody),
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
            ],
          );
        });
  }
}
