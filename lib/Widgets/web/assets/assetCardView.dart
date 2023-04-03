import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import '../../../Styles/CommonColor.dart';
import '../../../Styles/CommonTextStyle.dart';
import 'assetDetailView.dart';

class assetCardView extends StatefulWidget {
  List data = [];
  final String tappedValue, tableName;
  assetCardView(
      {Key? key,
      required this.data,
      required this.tappedValue,
      required this.tableName})
      : super(key: key);

  @override
  State<assetCardView> createState() => _assetCardViewState();
}

class _assetCardViewState extends State<assetCardView> {
  var ComplaintIDPK;
  final Duration delayed = const Duration(milliseconds: 300);

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
                          ComplaintIDPK = widget.data[index].assetIDPK;
                        }),
                        detailViewFunc(),
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
                                          'Floor Name :${widget.data[index].floorName}',
                                          style: TextStyle(
                                              fontSize: 12 * scaleFactor,
                                              overflow: TextOverflow.ellipsis,
                                              color: secondaryColor,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Text(
                                          '${widget.data[index].resultCount}',
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
                                              Text('Tag No',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.center,
                                                  style: cardHeader),
                                              Text('Asset Name',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.center,
                                                  style: cardHeader),
                                              Text('Ref No',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.center,
                                                  style: cardHeader),
                                              Text('Barcode',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.center,
                                                  style: cardHeader),
                                              Text('Location',
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
                                              widget.data[index].assetTagNo ==
                                                      null
                                                  ? const Text(':',
                                                      style: cardBody)
                                                  : Text(
                                                      ':${widget.data[index].assetTagNo}',
                                                      style: cardBody),
                                              widget.data[index]
                                                          .equipmentName ==
                                                      null
                                                  ? const Text(':',
                                                      style: cardBody)
                                                  : Text(
                                                      ':${widget.data[index].equipmentName}',
                                                      style: cardBody),
                                              widget.data[index]
                                                          .equipmentRefNo ==
                                                      null
                                                  ? const Text(':',
                                                      style: cardBody)
                                                  : Text(
                                                      ':${widget.data[index].equipmentRefNo}',
                                                      style: cardBody),
                                              widget.data[index].barcode == null
                                                  ? const Text(':',
                                                      style: cardBody)
                                                  : Text(
                                                      ':${widget.data[index].barcode}',
                                                      style: cardBody),
                                              widget.data[index].localityName ==
                                                      null
                                                  ? const Text(':',
                                                      style: cardBody)
                                                  : Text(
                                                      ':${widget.data[index].localityName}',
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
