import 'package:flutter/material.dart';
import 'package:vertical_tabs_flutter/vertical_tabs.dart';
import '../../Styles/CommonColor.dart';
import 'package:intl/intl.dart';

class MobileEntry extends StatefulWidget {
  const MobileEntry({Key? key}) : super(key: key);

  @override
  State<MobileEntry> createState() => _MobileEntryState();
}

class _MobileEntryState extends State<MobileEntry> {
  String? currentDate, startDate, day = 'Today';
  bool fromDate = true, val = false, today = false, yesterday = false;
  List singleSelectBox = [];
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd-MM-yyyy').format(now);
    final initialDate = now.subtract(const Duration(days: 30));
    String startdate = DateFormat('dd-MM-yyyy').format(initialDate);
    setState(() {
      startDate = startdate;
      currentDate = formattedDate;
    });
  }

  Future<void> datePicker() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: secondaryColor,
              onPrimary: buttonForeground,
              onSurface: secondaryColor,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: secondaryColor,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    String date = DateFormat('dd-MM-yyyy').format(pickedDate!);
    if (fromDate == true) {
      setState(() {
        startDate = date;
      });
      print('start,$startDate');
    } else {
      setState(() {
        currentDate = date;
      });
      print('currentDate,$currentDate');
    }
  }

  // Future<void> monthPicker() async {
  //   final selected = await showMonthYearPicker(
  //     context: context,
  //     initialDate: DateTime.now(),
  //     firstDate: DateTime(2019),
  //     lastDate: DateTime(2025),
  //   );
  //   print(selected);
  // }

  void singleCheckBox(bool selected, id) {
    if (selected == true) {
      setState(() {
        singleSelectBox.add(id);
      });
      print(singleSelectBox);
    } else {
      setState(() {
        singleSelectBox.remove(id);
      });
      print(singleSelectBox);
    }
  }

  final List items = [
    {'name': 'Item1', 'id': 1},
    {'name': 'Item2', 'id': 2},
    {'name': 'Item3', 'id': 3},
    {'name': 'Item4', 'id': 4},
    {'name': 'Item5', 'id': 5},
    {'name': 'Item6', 'id': 6},
    {'name': 'Item7', 'id': 7},
    {'name': 'Item8', 'id': 8},
    {'name': 'Item9', 'id': 9},
    {'name': 'Item10', 'id': 10}
  ];

  @override
  Widget build(BuildContext context) {
    double timerWidth = MediaQuery.of(context).size.width * 0.4;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: lightShade,
          toolbarHeight: 56,
          elevation: 0.0,
          iconTheme: const IconThemeData(color: secondaryColor),
          title: const Text('Filters',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
                color: secondaryColor,
                fontSize: 17,
                height: 1.0,
              )),
        ),
        body: Container(
          color: Colors.white,
          child: Column(
            children: [
              Expanded(
                flex: 8,
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context)
                      .copyWith(scrollbars: false),
                  child: VerticalTabs(
                    indicatorColor: secondaryColor,
                    selectedTabBackgroundColor: lightShade,
                    tabsWidth: 150,
                    // direction: TextDirection.ltr,
                    contentScrollAxis: Axis.vertical,
                    changePageDuration: const Duration(milliseconds: 500),
                    tabs: <Tab>[
                      Tab(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: const <Widget>[
                              Icon(Icons.calendar_month, color: secondaryColor),
                              SizedBox(width: 15),
                              Text('Calendar',
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: secondaryColor,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ),
                      Tab(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: const <Widget>[
                              Icon(Icons.flag, color: secondaryColor),
                              SizedBox(width: 15),
                              Text('Country',
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: secondaryColor,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ),
                      Tab(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: const <Widget>[
                              Icon(Icons.add_business, color: secondaryColor),
                              SizedBox(width: 15),
                              SizedBox(
                                width: 80,
                                child: Text('Business Associates',
                                    overflow: TextOverflow.fade,
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: secondaryColor,
                                        fontWeight: FontWeight.w600)),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Tab(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: const <Widget>[
                              Icon(Icons.handshake, color: secondaryColor),
                              SizedBox(width: 15),
                              Text('Contract',
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: secondaryColor,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ),
                      Tab(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: const <Widget>[
                              Icon(Icons.place, color: secondaryColor),
                              SizedBox(width: 15),
                              SizedBox(
                                width: 80,
                                child: Text('Location Group',
                                    overflow: TextOverflow.fade,
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: secondaryColor,
                                        fontWeight: FontWeight.w600)),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Tab(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: const <Widget>[
                              Icon(Icons.location_city, color: secondaryColor),
                              SizedBox(width: 15),
                              Text('City',
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: secondaryColor,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ),
                      Tab(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: const <Widget>[
                              Icon(Icons.my_location, color: secondaryColor),
                              SizedBox(width: 15),
                              Text('Location',
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: secondaryColor,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ),
                      Tab(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: const <Widget>[
                              Icon(Icons.apartment, color: secondaryColor),
                              SizedBox(width: 15),
                              Text('Building',
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: secondaryColor,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ),
                      Tab(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: const <Widget>[
                              Icon(Icons.corporate_fare, color: secondaryColor),
                              SizedBox(width: 15),
                              Text('Floor',
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: secondaryColor,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ),
                      Tab(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: const <Widget>[
                              Icon(Icons.pin_drop, color: secondaryColor),
                              SizedBox(width: 15),
                              Text('Spot',
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: secondaryColor,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ),
                    ],
                    contents: <Widget>[
                      Container(
                        color: Colors.white30,
                        child: Column(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(left: 5.0, top: 8.0),
                                  child: Text('Day',
                                      style: TextStyle(
                                          color: secondaryColor,
                                          fontWeight: FontWeight.w600)),
                                ),
                                PopupMenuButton(
                                  splashRadius: 0,
                                  position: PopupMenuPosition.under,
                                  elevation: 2,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(4.0),
                                    ),
                                  ),
                                  child: SizedBox(
                                    height: 40,
                                    width: timerWidth,
                                    child: Card(
                                      color: lightShade,
                                      shadowColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(4.0),
                                      ),
                                      elevation: 3,
                                      clipBehavior: Clip.antiAlias,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text('$day',
                                              style: const TextStyle(
                                                  fontSize: 13,
                                                  color: secondaryColor,
                                                  fontWeight: FontWeight.w600)),
                                          const Icon(Icons.keyboard_arrow_down,
                                              color: secondaryColor)
                                        ],
                                      ),
                                    ),
                                  ),
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                      onTap: () => {
                                        setState(() {
                                          day = 'Today';
                                        })
                                      },
                                      child: SizedBox(
                                        height: 15,
                                        width: timerWidth - 69,
                                        child: const Text('Today',
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                                color: secondaryColor)),
                                      ),
                                    ),
                                    PopupMenuItem(
                                      onTap: () => {
                                        setState(() {
                                          day = 'Yesterday';
                                        })
                                      },
                                      child: SizedBox(
                                        height: 15,
                                        width: timerWidth - 69,
                                        child: const Text('Yesterday',
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                                color: secondaryColor)),
                                      ),
                                    ),
                                  ],
                                ),
                                // InputChip(
                                //   checkmarkColor: Colors.white,
                                //   backgroundColor: lightShade,
                                //   selectedColor: secondaryColor,
                                //   selected: today,
                                //   label: Text('Today',
                                //       style: TextStyle(
                                //           fontSize: 13,
                                //           fontWeight: FontWeight.w600,
                                //           color: today == false
                                //               ? secondaryColor
                                //               : Colors.white)),
                                //   onPressed: () {
                                //     setState(() {
                                //       today = !today;
                                //     });
                                //     if (yesterday == true) {
                                //       setState(() {
                                //         yesterday = !yesterday;
                                //       });
                                //     }
                                //   },
                                // ),
                                // const SizedBox(
                                //   height: 10,
                                // ),
                                // InputChip(
                                //   checkmarkColor: Colors.white,
                                //   backgroundColor: lightShade,
                                //   selectedColor: secondaryColor,
                                //   selected: yesterday,
                                //   label: Text('Yesterday',
                                //       style: TextStyle(
                                //           fontSize: 13,
                                //           fontWeight: FontWeight.w600,
                                //           color: yesterday == false
                                //               ? secondaryColor
                                //               : Colors.white)),
                                //   onPressed: () {
                                //     setState(() {
                                //       yesterday = !yesterday;
                                //     });
                                //     if (today == true) {
                                //       setState(() {
                                //         today = !today;
                                //       });
                                //     }
                                //   },
                                // )
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(left: 5.0, top: 8.0),
                                  child: Text('From Date',
                                      style: TextStyle(
                                          color: secondaryColor,
                                          fontWeight: FontWeight.w600)),
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      fromDate = true;
                                    });
                                    datePicker();
                                  },
                                  child: SizedBox(
                                    height: 40,
                                    width: timerWidth,
                                    child: Card(
                                      color: lightShade,
                                      shadowColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(4.0),
                                      ),
                                      elevation: 3,
                                      clipBehavior: Clip.antiAlias,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text('$startDate',
                                              style: const TextStyle(
                                                  fontSize: 13,
                                                  color: secondaryColor,
                                                  fontWeight: FontWeight.w600)),
                                          const Icon(Icons.keyboard_arrow_down,
                                              color: secondaryColor)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(left: 5.0, top: 8.0),
                                  child: Text('To Date',
                                      style: TextStyle(
                                          color: secondaryColor,
                                          fontWeight: FontWeight.w600)),
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      fromDate = false;
                                    });
                                    datePicker();
                                  },
                                  child: SizedBox(
                                    height: 40,
                                    width: timerWidth,
                                    child: Card(
                                      color: lightShade,
                                      shadowColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(4.0),
                                      ),
                                      elevation: 3,
                                      clipBehavior: Clip.antiAlias,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text('$currentDate',
                                              style: const TextStyle(
                                                  fontSize: 13,
                                                  color: secondaryColor,
                                                  fontWeight: FontWeight.w600)),
                                          const Icon(Icons.keyboard_arrow_down,
                                              color: secondaryColor)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                          height: 40,
                          color: Colors.white,
                          child: ListView.builder(
                              itemCount: items.length,
                              // scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return Container(
                                  height: 52,
                                  width: 200,
                                  color: Colors.white,
                                  child: ListTile(
                                    leading: Checkbox(
                                      // shape: const CircleBorder(),
                                      fillColor: MaterialStateProperty.all(
                                          secondaryColor),
                                      value: singleSelectBox
                                          .contains(items[index]['id']),
                                      onChanged: (bool? selected) {
                                        setState(() {
                                          val = selected!;
                                        });
                                        singleCheckBox(val, items[index]['id']);
                                      },
                                    ),
                                    title: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      child: Text(
                                        '${items[index]['name']}',
                                        textAlign: TextAlign.start,
                                        style: const TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                );
                              })),
                      Container(
                          height: 40,
                          color: Colors.white,
                          child: ListView.builder(
                              itemCount: items.length,
                              // scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return Container(
                                  height: 52,
                                  width: 200,
                                  color: Colors.white,
                                  child: ListTile(
                                    leading: Checkbox(
                                      // shape: const CircleBorder(),
                                      fillColor: MaterialStateProperty.all(
                                          secondaryColor),
                                      value: singleSelectBox
                                          .contains(items[index]['id']),
                                      onChanged: (bool? selected) {
                                        setState(() {
                                          val = selected!;
                                        });
                                        singleCheckBox(val, items[index]['id']);
                                      },
                                    ),
                                    title: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      child: Text(
                                        '${items[index]['name']}',
                                        textAlign: TextAlign.start,
                                        style: const TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                );
                              })),
                      Container(
                          height: 40,
                          color: Colors.white,
                          child: ListView.builder(
                              itemCount: items.length,
                              // scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return Container(
                                  height: 52,
                                  width: 200,
                                  color: Colors.white,
                                  child: ListTile(
                                    leading: Checkbox(
                                      // shape: const CircleBorder(),
                                      fillColor: MaterialStateProperty.all(
                                          secondaryColor),
                                      value: singleSelectBox
                                          .contains(items[index]['id']),
                                      onChanged: (bool? selected) {
                                        setState(() {
                                          val = selected!;
                                        });
                                        singleCheckBox(val, items[index]['id']);
                                      },
                                    ),
                                    title: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      child: Text(
                                        '${items[index]['name']}',
                                        textAlign: TextAlign.start,
                                        style: const TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                );
                              })),
                      Container(
                          height: 40,
                          color: Colors.white,
                          child: ListView.builder(
                              itemCount: items.length,
                              // scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return Container(
                                  height: 52,
                                  width: 200,
                                  color: Colors.white,
                                  child: ListTile(
                                    leading: Checkbox(
                                      // shape: const CircleBorder(),
                                      fillColor: MaterialStateProperty.all(
                                          secondaryColor),
                                      value: singleSelectBox
                                          .contains(items[index]['id']),
                                      onChanged: (bool? selected) {
                                        setState(() {
                                          val = selected!;
                                        });
                                        singleCheckBox(val, items[index]['id']);
                                      },
                                    ),
                                    title: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      child: Text(
                                        '${items[index]['name']}',
                                        textAlign: TextAlign.start,
                                        style: const TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                );
                              })),
                      Container(
                          height: 40,
                          color: Colors.white,
                          child: ListView.builder(
                              itemCount: items.length,
                              // scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return Container(
                                  height: 52,
                                  width: 200,
                                  color: Colors.white,
                                  child: ListTile(
                                    leading: Checkbox(
                                      // shape: const CircleBorder(),
                                      fillColor: MaterialStateProperty.all(
                                          secondaryColor),
                                      value: singleSelectBox
                                          .contains(items[index]['id']),
                                      onChanged: (bool? selected) {
                                        setState(() {
                                          val = selected!;
                                        });
                                        singleCheckBox(val, items[index]['id']);
                                      },
                                    ),
                                    title: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      child: Text(
                                        '${items[index]['name']}',
                                        textAlign: TextAlign.start,
                                        style: const TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                );
                              })),
                      Container(
                          height: 40,
                          color: Colors.white,
                          child: ListView.builder(
                              itemCount: items.length,
                              // scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return Container(
                                  height: 52,
                                  width: 200,
                                  color: Colors.white,
                                  child: ListTile(
                                    leading: Checkbox(
                                      // shape: const CircleBorder(),
                                      fillColor: MaterialStateProperty.all(
                                          secondaryColor),
                                      value: singleSelectBox
                                          .contains(items[index]['id']),
                                      onChanged: (bool? selected) {
                                        setState(() {
                                          val = selected!;
                                        });
                                        singleCheckBox(val, items[index]['id']);
                                      },
                                    ),
                                    title: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      child: Text(
                                        '${items[index]['name']}',
                                        textAlign: TextAlign.start,
                                        style: const TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                );
                              })),
                      Container(
                          height: 40,
                          color: Colors.white,
                          child: ListView.builder(
                              itemCount: items.length,
                              // scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return Container(
                                  height: 52,
                                  width: 200,
                                  color: Colors.white,
                                  child: ListTile(
                                    leading: Checkbox(
                                      // shape: const CircleBorder(),
                                      fillColor: MaterialStateProperty.all(
                                          secondaryColor),
                                      value: singleSelectBox
                                          .contains(items[index]['id']),
                                      onChanged: (bool? selected) {
                                        setState(() {
                                          val = selected!;
                                        });
                                        singleCheckBox(val, items[index]['id']);
                                      },
                                    ),
                                    title: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      child: Text(
                                        '${items[index]['name']}',
                                        textAlign: TextAlign.start,
                                        style: const TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                );
                              })),
                      Container(
                          height: 40,
                          color: Colors.white,
                          child: ListView.builder(
                              itemCount: items.length,
                              // scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return Container(
                                  height: 52,
                                  width: 200,
                                  color: Colors.white,
                                  child: ListTile(
                                    leading: Checkbox(
                                      // shape: const CircleBorder(),
                                      fillColor: MaterialStateProperty.all(
                                          secondaryColor),
                                      value: singleSelectBox
                                          .contains(items[index]['id']),
                                      onChanged: (bool? selected) {
                                        setState(() {
                                          val = selected!;
                                        });
                                        singleCheckBox(val, items[index]['id']);
                                      },
                                    ),
                                    title: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      child: Text(
                                        '${items[index]['name']}',
                                        textAlign: TextAlign.start,
                                        style: const TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                );
                              })),
                      Container(
                          height: 40,
                          color: Colors.white,
                          child: ListView.builder(
                              itemCount: items.length,
                              // scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return Container(
                                  height: 52,
                                  width: 200,
                                  color: Colors.white,
                                  child: ListTile(
                                    leading: Checkbox(
                                      // shape: const CircleBorder(),
                                      fillColor: MaterialStateProperty.all(
                                          secondaryColor),
                                      value: singleSelectBox
                                          .contains(items[index]['id']),
                                      onChanged: (bool? selected) {
                                        setState(() {
                                          val = selected!;
                                        });
                                        singleCheckBox(val, items[index]['id']);
                                      },
                                    ),
                                    title: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      child: Text(
                                        '${items[index]['name']}',
                                        textAlign: TextAlign.start,
                                        style: const TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                );
                              })),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(110, 45),
                          maximumSize: const Size(110, 45),
                          side: const BorderSide(
                              width: 1.5, color: secondaryColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          primary: secondaryColor,
                        ),
                        onPressed: () {},
                        icon: const Icon(Icons.restart_alt, size: 18),
                        label: const Text("Reset"),
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(110, 45),
                          maximumSize: const Size(110, 45),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          primary: secondaryColor,
                        ),
                        onPressed: () {
                          Navigator.pop(context, startDate);
                        },
                        icon: const Icon(Icons.search, size: 18),
                        label: const Text("Search"),
                      ),
                    ]),
              )
            ],
          ),
        ));
  }
}
