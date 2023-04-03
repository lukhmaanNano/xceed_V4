import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:animate_do/animate_do.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:xceed/Styles/CommonColor.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:xceed/model/Ppm/ppmPerformance.dart';
import 'package:xceed/model/Ppm/ppmTrend.dart';
import '../../Styles/CommonTextStyle.dart';
import '../../Styles/responsive.dart';
import '../../Widgets/mobile/mobileEntry.dart';
import '../Login/login.dart';
import '../Ppm/ppmStatus.dart';
import '../Ppm/ppmSummary.dart';
import '../assets/assets.dart';
import '../contract/contract.dart';
import '../helpdesk/status.dart';
import '../helpdesk/trend.dart';
import '../helpdesk/summary.dart';
import '../helpdesk/performance.dart';
import '../kpi/kpi.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final fullScreenControll = ScreenshotController();
  TextEditingController mailIdController = TextEditingController();
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final passwordKey = GlobalKey<FormState>();
  bool menuState = true,
      singCardView = false,
      detailBackMenu = false,
      sideNav = true,
      fullscreen = false,
      helpDeskBtn = true,
      ppmBtn = false,
      assetBtn = false,
      contract = false,
      kpi = false,
      approval = false,
      employee = false,
      costControl = false,
      profileInfo = false,
      english = true,
      arab = false,
      menuTile1 = false,
      menuTile2 = false,
      helpStatus = true,
      helpTrend = false,
      helpSummary = false,
      helpPerformance = false,
      ppmStatus = false,
      ppmTrend = false,
      ppmSummary = false,
      ppmPerformance = false,
      isObscure0 = true,
      isObscure1 = true,
      isObscure2 = true;
  String? userName, currentDate, startDate, day = 'Today', pageName;
  late Uint8List _imageFile;
  int? sessionId, imgName, multipleCardsidentify;
  List<String> selectedItems = [];
  final List<String> items = [
    'Item1',
    'Item2',
    'Item3',
    'Item4',
  ];
  Object? value;

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
    local();
  }

  void refresh(bool getBool, String? getString, bool getBool1, int getInt) {
    setState(() {
      sideNav = getBool;
      pageName = getString;
      detailBackMenu = getBool1;
      multipleCardsidentify = getInt;
    });
  }

  void refresh1(bool getBool, bool getBool1, String getString) {
    setState(() {
      singCardView = true;
      sideNav = getBool;
      detailBackMenu = getBool1;
      pageName = getString;
    });
  }

  Future<void> local() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('UserName');
      sessionId = prefs.getInt('SessionId')!;
    });
  }

  void filter(BuildContext context) async {
    final result = await Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.rightToLeftWithFade,
            child: const MobileEntry()));
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
  }

  Future<void> logOutFunction() async {
    String ip = 'http://13.235.45.82:5020/';
    String URL = 'CommonCustomUpdate/';
    final url = Uri.parse('$ip$URL');
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    };
    final json = '{"data": {"SessionID": "$sessionId"}}';
    final response =
        await http.post(url, headers: headers, body: json.toString());
    if (response.statusCode == 400) {
      String Err = 'something went wrong!';
      toastMessageFunc(Err);
    } else {
      final datas = jsonDecode(response.body);
      var statusval = ('${datas['Output']['status']['code']}');
      if (statusval == "200") {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('SessionId');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Login()),
        );
      } else {
        final datas = jsonDecode(response.body);
        // String Error = ('${datas['Output']['status']['code']['message']}');
      }
    }
  }

  void toastMessageFunc(
    String message,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 1, milliseconds: 1000),
        behavior: SnackBarBehavior.floating,
        elevation: 6.0,
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, color: white),
            const SizedBox(
              width: 12,
            ),
            Text(
              message,
              style:
                  const TextStyle(letterSpacing: 1, fontSize: 12, color: white),
            ),
          ],
        )));
  }

  StatefulWidget routing() {
    switch (pageName) {
      case 'Helpdesk Status':
        {
          return HelpdeskStatus(singCardView: singCardView, getFunc: refresh);
        }
      case 'Helpdesk Trend':
        {
          return HelpdeskTrend(singCardView: singCardView, getFunc: refresh1);
        }
      case 'Helpdesk Summary':
        {
          return HelpdeskSummary(singCardView: singCardView, getFunc: refresh1);
        }
      case 'Helpdesk Performance':
        {
          return HelpdeskPerformance(
              singCardView: singCardView, getFunc: refresh1);
        }
      case 'PPM Status':
        {
          return PpmStatus(singCardView: singCardView, getFunc: refresh1);
        }
      case 'PPM Trend':
        {
          return PpmTrend(singCardView: singCardView, getFunc: refresh1);
        }
      case 'PPM Summary':
        {
          return PpmSummary(singCardView: singCardView, getFunc: refresh1);
        }
      case 'PPM Performance':
        {
          return PpmPerformance(singCardView: singCardView, getFunc: refresh1);
        }
      case 'Assets':
        {
          return AssetsMain(singCardView: singCardView, getFunc: refresh1);
        }
      case 'Contract':
        {
          return Contract(singCardView: singCardView, getFunc: refresh1);
        }
      case 'KPI':
        {
          return Kpi(singCardView: singCardView, getFunc: refresh1);
        }
      default:
        {
          return HelpdeskStatus(getFunc: refresh);
        }
    }
  }

  Widget menuRouting() {
    switch (pageName) {
      case 'Helpdesk Status':
        {
          return headerMenu();
        }
      case 'SLA-Response - Ontime':
        {
          return headerMenu();
        }
      case 'SLA-Response - Delayed':
        {
          return headerMenu();
        }
      case 'By Division - HVAC':
        {
          return headerMenu();
        }
      case 'By Division - HOP':
        {
          return headerMenu();
        }
      case 'By Division - ELE':
        {
          return headerMenu();
        }
      case 'Trend':
        {
          return headerMenu();
        }
      default:
        {
          return headerMenu();
        }
    }
  }

  void screenShotFunction() async {
    fullScreenControll
        .capture(delay: const Duration(milliseconds: 10))
        .then((capturedImage) async {
      setState(() {
        _imageFile = capturedImage!;
      });
      Random random = Random();
      int randomNumber = random.nextInt(100);
      setState(() {
        imgName = randomNumber;
      });
    }).catchError((onError) {
      print('error$onError');
    });
  }

  @override
  Widget build(BuildContext context) {
    double navOpenTabWidth = MediaQuery.of(context).size.width * 0.18;
    double navCloseTabWidth = 85;
    double headerCardHeight = 65;
    double menuIcon = 21;

    return Responsive(
      mobile: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.sort),
              onPressed: () => Scaffold.of(context).openDrawer(),
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon:
                  const Icon(Icons.filter_alt, color: secondaryColor, size: 22),
              onPressed: () {
                Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.rightToLeftWithFade,
                      child: const MobileEntry()),
                );
              },
            ), //IconButton
            Padding(
              padding: const EdgeInsets.only(left: 6.0, right: 7.0),
              child: Container(
                  height: 35,
                  width: 35,
                  decoration: const BoxDecoration(
                    color: secondaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    hoverColor: Colors.transparent,
                    splashColor: secondaryColor,
                    splashRadius: 25,
                    focusColor: Colors.transparent,
                    icon:
                        Icon(Icons.thumb_up_alt, color: white, size: menuIcon),
                    onPressed: () {},
                  )),
            ), //IconButton
          ],
          elevation: 0,
          iconTheme: const IconThemeData(color: secondaryColor),
          backgroundColor: lightShade,
          title: mobileFormName(),
        ),
        drawer: SafeArea(
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(25),
                bottomRight: Radius.circular(25)),
            child: Drawer(
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Column(
                  children: [
                    profileInfo == false
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                  height: 40,
                                  width: 40,
                                  decoration: const BoxDecoration(
                                    color: secondaryColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    hoverColor: buttonForeground,
                                    splashRadius: 25,
                                    onPressed: () {
                                      setState(() => menuState = true);
                                    },
                                    icon: const Icon(Icons.home,
                                        color: white, size: 25),
                                  )),
                              const SizedBox(width: 5),
                              const Text('INTEGRATED FACILITY',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: secondaryColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600)),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 8.0,
                                ),
                                child: IconButton(
                                    splashRadius: 20,
                                    hoverColor: buttonForeground,
                                    onPressed: () {
                                      setState(() {
                                        profileInfo = false;
                                      });
                                    },
                                    icon: const Icon(Icons.arrow_back,
                                        color: secondaryColor)),
                              ),
                              // const SizedBox(width: 40),
                              const Text('Profile',
                                  style: TextStyle(
                                      color: secondaryColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600)),
                              IconButton(
                                  splashRadius: 20,
                                  hoverColor: buttonForeground,
                                  onPressed: () {},
                                  icon: const Icon(Icons.edit,
                                      size: 15, color: secondaryColor)),
                            ],
                          ),
                    mobileSideMenu(),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: Screenshot(controller: fullScreenControll, child: routing()),
      ),
      desktop: Container(
        color: primaryColor,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
              visible: sideNav,
              child: SizedBox(
                // height: navTabHeight,
                width: menuState == true ? navCloseTabWidth : navOpenTabWidth,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 8.0, top: 8.0, bottom: 8.0, right: 3.0),
                  child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 4,
                      shadowColor: Colors.black12,
                      color: white,
                      // shadowColor: white,
                      child: InkWell(
                        hoverColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        splashColor: white,
                        onTap: () {
                          if (menuState == true) {
                            setState(() {
                              menuState = false;
                              profileInfo = false;
                            });
                          } else {
                            setState(() => menuState = true);
                          }
                        },
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: menuState == true
                                    ? Container(
                                        height: 35,
                                        width: 35,
                                        decoration: const BoxDecoration(
                                          color: buttonForeground,
                                          shape: BoxShape.circle,
                                        ),
                                        child: IconButton(
                                          hoverColor: buttonForeground,
                                          splashRadius: 20,
                                          onPressed: () {
                                            setState(() => menuState = false);
                                          },
                                          icon: const Icon(Icons.menu,
                                              color: secondaryColor, size: 19),
                                        ))
                                    : profileInfo == false
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Flexible(
                                                flex: 1,
                                                child: Container(
                                                    height: 40,
                                                    width: 40,
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: secondaryColor,
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: IconButton(
                                                      hoverColor:
                                                          buttonForeground,
                                                      splashRadius: 25,
                                                      onPressed: () {
                                                        setState(() =>
                                                            menuState = true);
                                                      },
                                                      icon: const Icon(
                                                          Icons.home,
                                                          color: white,
                                                          size: 25),
                                                    )),
                                              ),
                                              const SizedBox(width: 5),
                                              const Flexible(
                                                flex: 2,
                                                child: Text(
                                                    'INTEGRATED FACILITY',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        color: secondaryColor,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600)),
                                              ),
                                            ],
                                          )
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 8.0,
                                                ),
                                                child: IconButton(
                                                    splashRadius: 20,
                                                    hoverColor:
                                                        buttonForeground,
                                                    onPressed: () {
                                                      setState(() {
                                                        profileInfo = false;
                                                      });
                                                    },
                                                    icon: const Icon(
                                                        Icons.arrow_back,
                                                        color: secondaryColor)),
                                              ),
                                              const Text('Profile',
                                                  style: TextStyle(
                                                      color: secondaryColor,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600)),
                                              IconButton(
                                                  splashRadius: 20,
                                                  hoverColor: buttonForeground,
                                                  onPressed: () {},
                                                  icon: const Icon(Icons.edit,
                                                      size: 15,
                                                      color: secondaryColor)),
                                            ],
                                          )),
                            sideMenu(),
                          ],
                        ),
                      )),
                ),
              ),
            ),
            Flexible(
              flex: 12,
              child: Padding(
                padding: const EdgeInsets.only(right: 5.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: headerCardHeight,
                      // width: menuState == true
                      //     ? headerCardWidth
                      //     : openHeaderCardWidth,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 10.0, left: 5.0, right: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Visibility(
                                  visible: detailBackMenu,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: SizedBox(
                                      width: 30,
                                      child: Scaffold(
                                        backgroundColor: primaryColor,
                                        body: Center(
                                          child: IconButton(
                                              hoverColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onPressed: () => {
                                                    if (detailBackMenu == true)
                                                      {
                                                        if (multipleCardsidentify ==
                                                            1)
                                                          {
                                                            setState(() => {
                                                                  detailBackMenu =
                                                                      false,
                                                                  singCardView =
                                                                      false,
                                                                  sideNav =
                                                                      true,
                                                                  pageName =
                                                                      'Helpdesk Status',
                                                                  multipleCardsidentify =
                                                                      null,
                                                                }),
                                                          }
                                                        else
                                                          {
                                                            setState(() => {
                                                                  detailBackMenu =
                                                                      false,
                                                                  singCardView =
                                                                      false,
                                                                  sideNav =
                                                                      true,
                                                                }),
                                                          },
                                                        print(pageName),
                                                      }
                                                  },
                                              icon: const Icon(Icons.arrow_back,
                                                  size: 22,
                                                  color: secondaryColor)),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                formName(),
                              ],
                            ),
                            Visibility(
                              visible: sideNav,
                              child: SizedBox(
                                  width: 520,
                                  child: Align(
                                      alignment: Alignment.topRight,
                                      child: headerMenu())),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: Screenshot(
                          controller: fullScreenControll, child: routing()),
                    ),
                    // HelpdeskStatus(sideNav: sideNav, getFunc: refresh)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget sideMenu() {
    final menuCardWidth = MediaQuery.of(context).size.width * 0.15;
    final menuHeight = MediaQuery.of(context).size.height * 0.3;
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String username = stringToBase64.decode(userName.toString());
    double menuIcon = 19, splash = 20;
    var textStyle = TextStyle(
      color: helpDeskBtn == true ? white : secondaryColor,
      fontSize: 15,
    );
    var ppmtextStyle = TextStyle(
      color: ppmBtn == true ? white : secondaryColor,
      fontSize: 15,
    );
    return menuState == true
        ? Flexible(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 2,
                    child: ScrollConfiguration(
                      behavior: ScrollConfiguration.of(context)
                          .copyWith(scrollbars: false),
                      child: SingleChildScrollView(
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 15.0, bottom: 10.0),
                              child: Container(
                                  height: 35,
                                  width: 35,
                                  decoration: BoxDecoration(
                                    color: helpDeskBtn == true
                                        ? secondaryColor
                                        : buttonForeground,
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    hoverColor: buttonForeground,
                                    splashRadius: splash,
                                    icon: Icon(Icons.headset_mic,
                                        color: helpDeskBtn == true
                                            ? white
                                            : secondaryColor,
                                        size: menuIcon),
                                    onPressed: () {
                                      setState(() {
                                        helpDeskBtn = true;
                                        pageName = 'Helpdesk Status';
                                        ppmBtn = false;
                                        helpStatus = true;
                                        helpTrend = false;
                                        helpSummary = false;
                                        helpPerformance = false;
                                        ppmStatus = false;
                                        ppmTrend = false;
                                        ppmSummary = false;
                                        ppmPerformance = false;

                                        assetBtn = false;
                                        contract = false;
                                        kpi = false;
                                        approval = false;
                                        employee = false;
                                        costControl = false;
                                      });
                                    },
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Container(
                                  height: 35,
                                  width: 35,
                                  decoration: BoxDecoration(
                                    color: ppmBtn == true
                                        ? secondaryColor
                                        : buttonForeground,
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    hoverColor: buttonForeground,
                                    splashRadius: splash,
                                    icon: Icon(Icons.build,
                                        color: ppmBtn == true
                                            ? white
                                            : secondaryColor,
                                        size: menuIcon),
                                    onPressed: () {
                                      setState(() {
                                        pageName = 'PPM Status';
                                        helpDeskBtn = false;
                                        assetBtn = false;
                                        helpStatus = false;
                                        helpTrend = false;
                                        helpSummary = false;
                                        helpPerformance = false;
                                        ppmTrend = false;
                                        ppmSummary = false;
                                        ppmPerformance = false;
                                        contract = false;
                                        kpi = false;
                                        approval = false;
                                        employee = false;
                                        costControl = false;
                                        ppmBtn = true;
                                        ppmStatus = true;
                                      });
                                    },
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Container(
                                  height: 35,
                                  width: 35,
                                  decoration: BoxDecoration(
                                    color: assetBtn == true
                                        ? secondaryColor
                                        : buttonForeground,
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    hoverColor: buttonForeground,
                                    splashRadius: splash,
                                    icon: Icon(Icons.business,
                                        color: assetBtn == true
                                            ? white
                                            : secondaryColor,
                                        size: menuIcon),
                                    onPressed: () {
                                      setState(() {
                                        pageName = 'Assets';
                                        helpDeskBtn = false;
                                        ppmBtn = false;
                                        helpStatus = false;
                                        helpTrend = false;
                                        helpSummary = false;
                                        helpPerformance = false;
                                        ppmStatus = false;
                                        ppmTrend = false;
                                        ppmSummary = false;
                                        ppmPerformance = false;
                                        contract = false;
                                        assetBtn = true;
                                        kpi = false;
                                        approval = false;
                                        employee = false;
                                        costControl = false;
                                      });
                                    },
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Container(
                                  height: 35,
                                  width: 35,
                                  decoration: BoxDecoration(
                                    color: contract == true
                                        ? secondaryColor
                                        : buttonForeground,
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    hoverColor: buttonForeground,
                                    splashRadius: splash,
                                    icon: Icon(Icons.insert_drive_file,
                                        color: contract == true
                                            ? white
                                            : secondaryColor,
                                        size: menuIcon),
                                    onPressed: () {
                                      setState(() {
                                        pageName = 'Contract';
                                        helpDeskBtn = false;
                                        helpStatus = false;
                                        helpTrend = false;
                                        helpSummary = false;
                                        helpPerformance = false;
                                        ppmStatus = false;
                                        ppmTrend = false;
                                        ppmSummary = false;
                                        ppmPerformance = false;
                                        ppmBtn = false;
                                        assetBtn = false;
                                        kpi = false;
                                        approval = false;
                                        employee = false;
                                        costControl = false;
                                        contract = true;
                                      });
                                    },
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Container(
                                  height: 35,
                                  width: 35,
                                  decoration: BoxDecoration(
                                    color: kpi == true
                                        ? secondaryColor
                                        : buttonForeground,
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    hoverColor: buttonForeground,
                                    splashRadius: splash,
                                    icon: Icon(Icons.apartment,
                                        color: kpi == true
                                            ? white
                                            : secondaryColor,
                                        size: menuIcon),
                                    onPressed: () {
                                      setState(() {
                                        pageName = 'KPI';
                                        helpDeskBtn = false;
                                        ppmBtn = false;
                                        assetBtn = false;
                                        helpStatus = false;
                                        helpTrend = false;
                                        helpSummary = false;
                                        helpPerformance = false;
                                        ppmStatus = false;
                                        ppmTrend = false;
                                        ppmSummary = false;
                                        ppmPerformance = false;
                                        contract = false;
                                        kpi = true;
                                        approval = false;
                                        employee = false;
                                        costControl = false;
                                      });
                                    },
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Container(
                                  height: 35,
                                  width: 35,
                                  decoration: BoxDecoration(
                                    color: approval == true
                                        ? secondaryColor
                                        : buttonForeground,
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    hoverColor: buttonForeground,
                                    splashRadius: splash,
                                    icon: Icon(Icons.thumb_up_alt,
                                        color: approval == true
                                            ? white
                                            : secondaryColor,
                                        size: menuIcon),
                                    onPressed: () {
                                      setState(() {
                                        pageName = 'Approvals';
                                        helpDeskBtn = false;
                                        helpStatus = false;
                                        helpTrend = false;
                                        helpSummary = false;
                                        helpPerformance = false;
                                        ppmStatus = false;
                                        ppmTrend = false;
                                        ppmSummary = false;
                                        ppmPerformance = false;
                                        ppmBtn = false;
                                        assetBtn = false;
                                        kpi = false;
                                        employee = false;
                                        costControl = false;
                                        approval = true;
                                        contract = false;
                                      });
                                    },
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Container(
                                  height: 35,
                                  width: 35,
                                  decoration: BoxDecoration(
                                    color: employee == true
                                        ? secondaryColor
                                        : buttonForeground,
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    hoverColor: buttonForeground,
                                    splashRadius: splash,
                                    icon: Icon(Icons.person,
                                        color: employee == true
                                            ? white
                                            : secondaryColor,
                                        size: menuIcon),
                                    onPressed: () {
                                      setState(() {
                                        pageName = 'Employee';
                                        helpDeskBtn = false;
                                        helpStatus = false;
                                        helpTrend = false;
                                        helpSummary = false;
                                        helpPerformance = false;
                                        ppmStatus = false;
                                        ppmTrend = false;
                                        ppmSummary = false;
                                        ppmPerformance = false;
                                        ppmBtn = false;
                                        assetBtn = false;
                                        kpi = false;
                                        approval = false;
                                        employee = true;
                                        costControl = false;
                                        contract = false;
                                      });
                                    },
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Container(
                                  height: 35,
                                  width: 35,
                                  decoration: BoxDecoration(
                                    color: costControl == true
                                        ? secondaryColor
                                        : buttonForeground,
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    hoverColor: buttonForeground,
                                    splashRadius: splash,
                                    icon: Icon(Icons.monetization_on,
                                        color: costControl == true
                                            ? white
                                            : secondaryColor,
                                        size: menuIcon),
                                    onPressed: () {
                                      setState(() {
                                        pageName = 'Cost Control';
                                        helpDeskBtn = false;
                                        helpStatus = false;
                                        helpTrend = false;
                                        helpSummary = false;
                                        helpPerformance = false;
                                        ppmStatus = false;
                                        ppmTrend = false;
                                        ppmSummary = false;
                                        ppmPerformance = false;
                                        ppmBtn = false;
                                        assetBtn = false;
                                        kpi = false;
                                        approval = false;
                                        employee = false;
                                        costControl = true;
                                        contract = false;
                                      });
                                    },
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Container(
                            height: 35,
                            width: 35,
                            decoration: const BoxDecoration(
                              color: buttonForeground,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              hoverColor: buttonForeground,
                              splashRadius: splash,
                              icon: Icon(Icons.print,
                                  color: secondaryColor, size: menuIcon),
                              onPressed: () {},
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Container(
                            height: 35,
                            width: 35,
                            decoration: const BoxDecoration(
                              color: buttonForeground,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              hoverColor: buttonForeground,
                              splashRadius: splash,
                              icon: Icon(Icons.email,
                                  color: secondaryColor, size: menuIcon),
                              onPressed: () => {
                                screenShotFunction(),
                                Timer(const Duration(seconds: 1), () {
                                  mail();
                                })
                              },
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: InkWell(
                          hoverColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          onTap: () {
                            setState(() {
                              menuState = false;
                              profileInfo = true;
                            });
                          },
                          child: Column(
                            children: const [
                              Padding(
                                padding: EdgeInsets.only(bottom: 8.0),
                                child: CircleAvatar(
                                  child: Image(
                                      image: AssetImage(
                                          "assets/images/profile.png")),
                                ),
                              ),
                              Text('Me',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: secondaryColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        : profileInfo == false
            ? Flexible(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 2,
                      child: ScrollConfiguration(
                        behavior: ScrollConfiguration.of(context)
                            .copyWith(scrollbars: false),
                        child: SingleChildScrollView(
                            child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: menuCardWidth,
                                child: Card(
                                  borderOnForeground: false,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  color: helpDeskBtn == true
                                      ? secondaryColor
                                      : buttonForeground,
                                  elevation: 1,
                                  shadowColor: white,
                                  clipBehavior: Clip.antiAlias,
                                  child: Theme(
                                    data: ThemeData(
                                      dividerColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      unselectedWidgetColor:
                                          helpDeskBtn == false
                                              ? secondaryColor
                                              : buttonForeground,
                                    ),
                                    child: ExpansionTile(
                                      collapsedBackgroundColor:
                                          Colors.transparent,
                                      backgroundColor: Colors.transparent,
                                      collapsedIconColor: helpDeskBtn == true
                                          ? buttonForeground
                                          : secondaryColor,
                                      iconColor: helpDeskBtn == false
                                          ? secondaryColor
                                          : buttonForeground,
                                      leading: Icon(Icons.headset_mic,
                                          color: helpDeskBtn == true
                                              ? white
                                              : secondaryColor,
                                          size: 21),
                                      title: Text(
                                        'HelpDesk',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: helpDeskBtn == true
                                                ? white
                                                : secondaryColor,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13,
                                            letterSpacing: 1.1),
                                      ),
                                      children: <Widget>[
                                        ListTile(
                                            selected: helpStatus,
                                            selectedTileColor: secondaryCard1,
                                            leading: Icon(Icons.headset_mic,
                                                color: helpDeskBtn == true
                                                    ? white
                                                    : secondaryColor,
                                                size: 18),
                                            title: Text('Status',
                                                style: textStyle),
                                            onTap: () {
                                              setState(() {
                                                setState(() {
                                                  pageName = 'Helpdesk Status';
                                                  helpDeskBtn = true;
                                                  helpStatus = true;
                                                  helpTrend = false;
                                                  helpSummary = false;
                                                  helpPerformance = false;
                                                  ppmStatus = false;
                                                  ppmTrend = false;
                                                  ppmSummary = false;
                                                  ppmPerformance = false;
                                                  ppmBtn = false;
                                                  assetBtn = false;
                                                  kpi = false;
                                                  approval = false;
                                                  employee = false;
                                                  costControl = false;
                                                  contract = false;
                                                });
                                              });
                                            }),
                                        ListTile(
                                            selected: helpTrend,
                                            selectedTileColor: secondaryCard1,
                                            leading: Icon(Icons.trending_up,
                                                color: helpDeskBtn == true
                                                    ? white
                                                    : secondaryColor,
                                                size: 18),
                                            title:
                                                Text('Trend', style: textStyle),
                                            onTap: () {
                                              setState(() {
                                                setState(() {
                                                  pageName = 'Helpdesk Trend';
                                                  helpDeskBtn = true;
                                                  helpTrend = true;
                                                  helpStatus = false;
                                                  helpSummary = false;
                                                  helpPerformance = false;
                                                  ppmStatus = false;
                                                  ppmTrend = false;
                                                  ppmSummary = false;
                                                  ppmPerformance = false;
                                                  ppmBtn = false;
                                                  assetBtn = false;
                                                  kpi = false;
                                                  approval = false;
                                                  employee = false;
                                                  costControl = false;
                                                  contract = false;
                                                });
                                              });
                                            }),
                                        ListTile(
                                            selected: helpSummary,
                                            selectedTileColor: secondaryCard1,
                                            leading: Icon(Icons.description,
                                                color: helpDeskBtn == true
                                                    ? white
                                                    : secondaryColor,
                                                size: 18),
                                            title: Text('Summary',
                                                style: textStyle),
                                            onTap: () {
                                              setState(() {
                                                setState(() {
                                                  pageName = 'Helpdesk Summary';
                                                  helpTrend = false;
                                                  helpStatus = false;
                                                  helpSummary = true;
                                                  helpPerformance = false;
                                                  helpDeskBtn = true;
                                                  ppmStatus = false;
                                                  ppmTrend = false;
                                                  ppmSummary = false;
                                                  ppmPerformance = false;
                                                  ppmBtn = false;
                                                  assetBtn = false;
                                                  kpi = false;
                                                  approval = false;
                                                  employee = false;
                                                  costControl = false;
                                                  contract = false;
                                                });
                                              });
                                            }),
                                        ListTile(
                                            selected: helpPerformance,
                                            selectedTileColor: secondaryCard1,
                                            leading: Icon(Icons.network_check,
                                                color: helpDeskBtn == true
                                                    ? white
                                                    : secondaryColor,
                                                size: 18),
                                            title: Text('Performance',
                                                style: textStyle),
                                            onTap: () {
                                              setState(() {
                                                setState(() {
                                                  pageName =
                                                      'Helpdesk Performance';
                                                  helpTrend = false;
                                                  helpStatus = false;
                                                  helpSummary = false;
                                                  helpPerformance = true;
                                                  ppmStatus = false;
                                                  ppmTrend = false;
                                                  ppmSummary = false;
                                                  ppmPerformance = false;
                                                  helpDeskBtn = true;
                                                  ppmBtn = false;
                                                  assetBtn = false;
                                                  kpi = false;
                                                  approval = false;
                                                  employee = false;
                                                  costControl = false;
                                                  contract = false;
                                                });
                                              });
                                            }),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: menuCardWidth,
                                child: Card(
                                  borderOnForeground: false,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  color: ppmBtn == true
                                      ? secondaryColor
                                      : buttonForeground,
                                  elevation: 1,
                                  shadowColor: white,
                                  clipBehavior: Clip.antiAlias,
                                  child: Theme(
                                    data: ThemeData(
                                      dividerColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      unselectedWidgetColor: ppmBtn == false
                                          ? secondaryColor
                                          : buttonForeground,
                                    ),
                                    child: ExpansionTile(
                                      collapsedIconColor: ppmBtn == true
                                          ? buttonForeground
                                          : secondaryColor,
                                      iconColor: ppmBtn == false
                                          ? secondaryColor
                                          : buttonForeground,
                                      collapsedBackgroundColor:
                                          Colors.transparent,
                                      backgroundColor: Colors.transparent,
                                      leading: Icon(Icons.build,
                                          color: ppmBtn == true
                                              ? white
                                              : secondaryColor,
                                          size: 21),
                                      title: Text(
                                        'PPM',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: ppmBtn == true
                                                ? white
                                                : secondaryColor,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13,
                                            letterSpacing: 1.1),
                                      ),
                                      children: <Widget>[
                                        ListTile(
                                            selected: ppmStatus,
                                            selectedTileColor: secondaryCard1,
                                            leading: Icon(Icons.headset_mic,
                                                color: ppmBtn == true
                                                    ? white
                                                    : secondaryColor,
                                                size: 18),
                                            title: Text('PPM Status',
                                                overflow: TextOverflow.ellipsis,
                                                style: ppmtextStyle),
                                            onTap: () {
                                              setState(() {
                                                setState(() {
                                                  helpDeskBtn = false;
                                                  ppmStatus = true;
                                                  ppmTrend = false;
                                                  ppmSummary = false;
                                                  ppmPerformance = false;
                                                  helpTrend = false;
                                                  helpStatus = false;
                                                  helpSummary = false;
                                                  helpPerformance = false;
                                                  pageName = 'PPM Status';
                                                  ppmBtn = true;
                                                  assetBtn = false;
                                                  kpi = false;
                                                  approval = false;
                                                  employee = false;
                                                  costControl = false;
                                                  contract = false;
                                                });
                                              });
                                            }),
                                        ListTile(
                                            selected: ppmTrend,
                                            selectedTileColor: secondaryCard1,
                                            leading: Icon(Icons.trending_up,
                                                color: ppmBtn == true
                                                    ? white
                                                    : secondaryColor,
                                                size: 18),
                                            title: Text('PPM Trend',
                                                overflow: TextOverflow.ellipsis,
                                                style: ppmtextStyle),
                                            onTap: () {
                                              setState(() {
                                                setState(() {
                                                  helpDeskBtn = false;
                                                  ppmTrend = true;
                                                  ppmStatus = false;
                                                  ppmSummary = false;
                                                  ppmPerformance = false;
                                                  helpTrend = false;
                                                  helpStatus = false;
                                                  helpSummary = false;
                                                  helpPerformance = false;
                                                  pageName = 'PPM Trend';
                                                  ppmBtn = true;
                                                  assetBtn = false;
                                                  kpi = false;
                                                  approval = false;
                                                  employee = false;
                                                  costControl = false;
                                                  contract = false;
                                                });
                                              });
                                            }),
                                        ListTile(
                                            selected: ppmSummary,
                                            selectedTileColor: secondaryCard1,
                                            leading: Icon(Icons.description,
                                                color: ppmBtn == true
                                                    ? white
                                                    : secondaryColor,
                                                size: 18),
                                            title: Text('PPM Summary',
                                                overflow: TextOverflow.ellipsis,
                                                style: ppmtextStyle),
                                            onTap: () {
                                              setState(() {
                                                setState(() {
                                                  helpDeskBtn = false;
                                                  ppmStatus = false;
                                                  ppmTrend = false;
                                                  ppmSummary = true;
                                                  ppmPerformance = false;
                                                  helpTrend = false;
                                                  helpStatus = false;
                                                  helpSummary = false;
                                                  helpPerformance = false;
                                                  pageName = 'PPM Summary';
                                                  ppmBtn = true;
                                                  assetBtn = false;
                                                  kpi = false;
                                                  approval = false;
                                                  employee = false;
                                                  costControl = false;
                                                  contract = false;
                                                });
                                              });
                                            }),
                                        ListTile(
                                            selected: ppmPerformance,
                                            selectedTileColor: secondaryCard1,
                                            leading: Icon(Icons.network_check,
                                                color: ppmBtn == true
                                                    ? white
                                                    : secondaryColor,
                                                size: 18),
                                            title: Text('PPM Performance',
                                                overflow: TextOverflow.ellipsis,
                                                style: ppmtextStyle),
                                            onTap: () {
                                              setState(() {
                                                setState(() {
                                                  helpDeskBtn = false;
                                                  ppmPerformance = true;
                                                  ppmStatus = false;
                                                  ppmTrend = false;
                                                  ppmSummary = false;
                                                  helpTrend = false;
                                                  helpStatus = false;
                                                  helpSummary = false;
                                                  helpPerformance = false;
                                                  pageName = 'PPM Performance';
                                                  ppmBtn = true;
                                                  assetBtn = false;
                                                  kpi = false;
                                                  approval = false;
                                                  employee = false;
                                                  costControl = false;
                                                  contract = false;
                                                });
                                              });
                                            }),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 11.0, right: 11.0, top: 12.0),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    helpDeskBtn = false;
                                    ppmPerformance = false;
                                    ppmStatus = false;
                                    ppmTrend = false;
                                    ppmSummary = false;
                                    helpTrend = false;
                                    helpStatus = false;
                                    helpSummary = false;
                                    helpPerformance = false;
                                    ppmBtn = false;
                                    kpi = false;
                                    approval = false;
                                    employee = false;
                                    costControl = false;
                                    contract = false;
                                    pageName = 'Assets';
                                    assetBtn = true;
                                  });
                                },
                                child: Container(
                                    height: 45,
                                    width: menuCardWidth,
                                    decoration: BoxDecoration(
                                        color: assetBtn == true
                                            ? secondaryColor
                                            : buttonForeground,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: (Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 17.0, right: 25),
                                          child: Icon(Icons.business,
                                              color: assetBtn == true
                                                  ? buttonForeground
                                                  : secondaryColor,
                                              size: 21),
                                        ),
                                        Text('Assets',
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 13,
                                              letterSpacing: 1.1,
                                              fontWeight: FontWeight.w600,
                                              color: assetBtn == true
                                                  ? buttonForeground
                                                  : secondaryColor,
                                            ))
                                      ],
                                    ))),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 11.0, right: 11.0, top: 12.0),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    helpDeskBtn = false;
                                    ppmPerformance = false;
                                    ppmStatus = false;
                                    ppmTrend = false;
                                    ppmSummary = false;
                                    helpTrend = false;
                                    helpStatus = false;
                                    helpSummary = false;
                                    helpPerformance = false;
                                    ppmBtn = false;
                                    kpi = false;
                                    approval = false;
                                    employee = false;
                                    costControl = false;
                                    assetBtn = false;
                                    pageName = 'Contract';
                                    contract = true;
                                  });
                                },
                                child: Container(
                                    height: 45,
                                    width: menuCardWidth,
                                    decoration: BoxDecoration(
                                        color: contract == true
                                            ? secondaryColor
                                            : buttonForeground,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: (Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 17.0, right: 25),
                                          child: Icon(Icons.insert_drive_file,
                                              color: contract == true
                                                  ? buttonForeground
                                                  : secondaryColor,
                                              size: 21),
                                        ),
                                        Text('Contract',
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 13,
                                              letterSpacing: 1.1,
                                              fontWeight: FontWeight.w600,
                                              color: contract == true
                                                  ? buttonForeground
                                                  : secondaryColor,
                                            ))
                                      ],
                                    ))),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 11.0, right: 11.0, top: 12.0),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    helpDeskBtn = false;
                                    ppmPerformance = false;
                                    ppmStatus = false;
                                    ppmTrend = false;
                                    ppmSummary = false;
                                    helpTrend = false;
                                    helpStatus = false;
                                    helpSummary = false;
                                    helpPerformance = false;
                                    ppmBtn = false;
                                    approval = false;
                                    employee = false;
                                    costControl = false;
                                    assetBtn = false;
                                    contract = false;
                                    assetBtn = false;
                                    kpi = true;
                                    pageName = 'KPI';
                                  });
                                },
                                child: Container(
                                    height: 45,
                                    width: menuCardWidth,
                                    decoration: BoxDecoration(
                                        color: kpi == true
                                            ? secondaryColor
                                            : buttonForeground,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: (Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 17.0, right: 25),
                                          child: Icon(Icons.apartment,
                                              color: kpi == true
                                                  ? buttonForeground
                                                  : secondaryColor,
                                              size: 21),
                                        ),
                                        Text('KPI',
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 13,
                                              letterSpacing: 1.1,
                                              fontWeight: FontWeight.w600,
                                              color: kpi == true
                                                  ? buttonForeground
                                                  : secondaryColor,
                                            ))
                                      ],
                                    ))),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 11.0, right: 11.0, top: 12.0),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    helpDeskBtn = false;
                                    ppmPerformance = false;
                                    ppmStatus = false;
                                    ppmTrend = false;
                                    ppmSummary = false;
                                    helpTrend = false;
                                    helpStatus = false;
                                    helpSummary = false;
                                    helpPerformance = false;
                                    ppmBtn = false;
                                    kpi = false;
                                    assetBtn = false;
                                    employee = false;
                                    costControl = false;
                                    pageName = 'Approvals';
                                    approval = true;
                                  });
                                },
                                child: Container(
                                    height: 45,
                                    width: menuCardWidth,
                                    decoration: BoxDecoration(
                                        color: approval == true
                                            ? secondaryColor
                                            : buttonForeground,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: (Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 17.0, right: 25),
                                          child: Icon(Icons.thumb_up_alt,
                                              color: approval == true
                                                  ? buttonForeground
                                                  : secondaryColor,
                                              size: 21),
                                        ),
                                        Text('Approvals',
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 13,
                                              letterSpacing: 1.1,
                                              fontWeight: FontWeight.w600,
                                              color: approval == true
                                                  ? buttonForeground
                                                  : secondaryColor,
                                            ))
                                      ],
                                    ))),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 11.0, right: 11.0, top: 12.0),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    helpDeskBtn = false;
                                    ppmPerformance = false;
                                    ppmStatus = false;
                                    ppmTrend = false;
                                    ppmSummary = false;
                                    helpTrend = false;
                                    helpStatus = false;
                                    helpSummary = false;
                                    helpPerformance = false;
                                    ppmBtn = false;
                                    kpi = false;
                                    approval = false;
                                    assetBtn = false;
                                    costControl = false;
                                    pageName = 'Employee';
                                    employee = true;
                                  });
                                },
                                child: Container(
                                    height: 45,
                                    width: menuCardWidth,
                                    decoration: BoxDecoration(
                                        color: employee == true
                                            ? secondaryColor
                                            : buttonForeground,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: (Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 17.0, right: 25),
                                          child: Icon(Icons.person,
                                              color: employee == true
                                                  ? buttonForeground
                                                  : secondaryColor,
                                              size: 21),
                                        ),
                                        Text('Employee',
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 13,
                                              letterSpacing: 1.1,
                                              fontWeight: FontWeight.w600,
                                              color: employee == true
                                                  ? buttonForeground
                                                  : secondaryColor,
                                            ))
                                      ],
                                    ))),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 11.0, right: 11.0, top: 12.0),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    helpDeskBtn = false;
                                    ppmPerformance = false;
                                    ppmStatus = false;
                                    ppmTrend = false;
                                    ppmSummary = false;
                                    helpTrend = false;
                                    helpStatus = false;
                                    helpSummary = false;
                                    helpPerformance = false;
                                    ppmBtn = false;
                                    kpi = false;
                                    approval = false;
                                    employee = false;
                                    costControl = true;
                                    pageName = 'Cost Control';
                                    assetBtn = false;
                                  });
                                },
                                child: Container(
                                    height: 45,
                                    width: menuCardWidth,
                                    decoration: BoxDecoration(
                                        color: costControl == true
                                            ? secondaryColor
                                            : buttonForeground,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: (Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 17.0, right: 25),
                                          child: Icon(Icons.monetization_on,
                                              color: costControl == true
                                                  ? buttonForeground
                                                  : secondaryColor,
                                              size: 21),
                                        ),
                                        Text('Cost Control',
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 13,
                                              letterSpacing: 1.1,
                                              fontWeight: FontWeight.w600,
                                              color: costControl == true
                                                  ? buttonForeground
                                                  : secondaryColor,
                                            ))
                                      ],
                                    ))),
                              ),
                            ),
                          ],
                        )),
                      ),
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(11.0),
                          child: Container(
                              height: 45,
                              width: menuCardWidth,
                              decoration: BoxDecoration(
                                  color: buttonForeground,
                                  borderRadius: BorderRadius.circular(10)),
                              child: (Row(
                                children: const [
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: 17.0, right: 25),
                                    child: Icon(Icons.print,
                                        color: secondaryColor, size: 21),
                                  ),
                                  Text('Print',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 13,
                                        letterSpacing: 1.1,
                                        fontWeight: FontWeight.w600,
                                        color: secondaryColor,
                                      ))
                                ],
                              ))),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(11.0),
                          child: InkWell(
                            onTap: () => {
                              screenShotFunction(),
                              Timer(const Duration(seconds: 1), () {
                                mail();
                              })
                            },
                            child: Container(
                                height: 45,
                                width: menuCardWidth,
                                decoration: BoxDecoration(
                                    color: buttonForeground,
                                    borderRadius: BorderRadius.circular(10)),
                                child: (Row(
                                  children: const [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 17.0, right: 25),
                                      child: Icon(Icons.mail,
                                          color: secondaryColor, size: 21),
                                    ),
                                    Text('Email',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 13,
                                          letterSpacing: 1.1,
                                          fontWeight: FontWeight.w600,
                                          color: secondaryColor,
                                        ))
                                  ],
                                ))),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(11.0),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                menuState = false;
                                profileInfo = true;
                              });
                            },
                            child: Container(
                                height: 45,
                                width: menuCardWidth,
                                decoration: BoxDecoration(
                                    color: buttonForeground,
                                    borderRadius: BorderRadius.circular(10)),
                                child: (Row(
                                  children: const [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 17.0, right: 25),
                                      child: Icon(Icons.person,
                                          color: secondaryColor, size: 21),
                                    ),
                                    Text('Profile',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 13,
                                          letterSpacing: 1.1,
                                          fontWeight: FontWeight.w600,
                                          color: secondaryColor,
                                        ))
                                  ],
                                ))),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            : Flexible(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        const Center(
                          child: CircleAvatar(
                            radius: 30,
                            child: Image(
                                image:
                                    AssetImage("assets/images/profile1.png")),
                          ),
                        ),
                        Center(
                          child: Text(username,
                              style: const TextStyle(
                                  color: secondaryColor,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600)),
                        ),
                        const SizedBox(height: 10),
                        const Padding(
                          padding: EdgeInsets.only(left: 8.0, bottom: 8.0),
                          child: Text('Email',
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w600)),
                        ),
                        const Text('       Admin@nanosoftSolutions.in',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: secondaryColor)),
                        const SizedBox(height: 5),
                        const Divider(
                            indent: 20,
                            endIndent: 25,
                            thickness: 0.2,
                            color: Colors.grey),
                        const SizedBox(height: 5),
                        const Padding(
                          padding: EdgeInsets.only(left: 8.0, bottom: 8.0),
                          child: Text('Phone No',
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w600)),
                        ),
                        const Text('       0123456789',
                            style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: secondaryColor)),
                        const SizedBox(height: 5),
                        const Divider(
                            indent: 20,
                            endIndent: 25,
                            thickness: 0.2,
                            color: Colors.grey),
                        const SizedBox(height: 10),
                        const Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Text('Change language',
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w600)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: ListTile(
                            title: const Text('English',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: secondaryColor,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600)),
                            leading: const CircleAvatar(
                              radius: 12,
                              backgroundImage:
                                  AssetImage('assets/images/america.png'),
                            ),
                            trailing: Checkbox(
                                shape: const CircleBorder(),
                                fillColor:
                                    MaterialStateProperty.all(secondaryColor),
                                value: english,
                                onChanged: (bool? selected) {
                                  if (arab == true) {
                                    setState(() {
                                      arab = false;
                                      english = true;
                                    });
                                  }
                                }),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: ListTile(
                            title: const Text('Arabic',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: secondaryColor,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600)),
                            leading: const CircleAvatar(
                              radius: 12,
                              backgroundImage:
                                  AssetImage('assets/images/arab.png'),
                            ),
                            trailing: Checkbox(
                                shape: const CircleBorder(),
                                fillColor:
                                    MaterialStateProperty.all(secondaryColor),
                                value: arab,
                                onChanged: (bool? selected) {
                                  if (english == true) {
                                    setState(() {
                                      arab = true;
                                      english = false;
                                    });
                                  }
                                }),
                          ),
                        ),
                        const Divider(
                            indent: 20,
                            endIndent: 25,
                            thickness: 0.2,
                            color: Colors.grey),
                      ],
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: changePassword,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: const [
                                Icon(Icons.vpn_key, color: secondaryColor),
                                SizedBox(
                                  width: 5,
                                ),
                                Text('Change Password',
                                    style: TextStyle(
                                        color: secondaryColor,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: logOutFunction,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: const [
                                Icon(Icons.power_settings_new,
                                    color: secondaryColor),
                                SizedBox(
                                  width: 5,
                                ),
                                Text('Logout',
                                    style: TextStyle(
                                        color: secondaryColor,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ));
  }

  Widget mobileSideMenu() {
    final menuCardWidth = MediaQuery.of(context).size.width * 0.7;
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String username = stringToBase64.decode(userName.toString());
    var textStyle = TextStyle(
      color: helpDeskBtn == true ? white : secondaryColor,
      fontSize: 15,
    );
    var ppmtextStyle = TextStyle(
      color: ppmBtn == true ? white : secondaryColor,
      fontSize: 15,
    );
    return profileInfo == false
        ? Flexible(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 2,
                  child: SingleChildScrollView(
                      child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: menuCardWidth,
                          child: Card(
                            borderOnForeground: false,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            color: helpDeskBtn == true
                                ? secondaryColor
                                : buttonForeground,
                            elevation: 1,
                            shadowColor: white,
                            clipBehavior: Clip.antiAlias,
                            child: Theme(
                              data: ThemeData(
                                dividerColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                unselectedWidgetColor: helpDeskBtn == false
                                    ? secondaryColor
                                    : buttonForeground,
                              ),
                              child: ExpansionTile(
                                collapsedBackgroundColor: Colors.transparent,
                                backgroundColor: Colors.transparent,
                                collapsedIconColor: helpDeskBtn == true
                                    ? buttonForeground
                                    : secondaryColor,
                                iconColor: helpDeskBtn == false
                                    ? secondaryColor
                                    : buttonForeground,
                                leading: Icon(Icons.headset_mic,
                                    color: helpDeskBtn == true
                                        ? white
                                        : secondaryColor,
                                    size: 21),
                                title: Text(
                                  'HelpDesk',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: helpDeskBtn == true
                                          ? white
                                          : secondaryColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                      letterSpacing: 1.1),
                                ),
                                children: <Widget>[
                                  ListTile(
                                      selected: helpStatus,
                                      selectedTileColor: secondaryCard1,
                                      leading: Icon(Icons.headset_mic,
                                          color: helpDeskBtn == true
                                              ? white
                                              : secondaryColor,
                                          size: 18),
                                      title: Text('Status', style: textStyle),
                                      onTap: () {
                                        setState(() {
                                          setState(() {
                                            pageName = 'Helpdesk Status';
                                            helpDeskBtn = true;
                                            helpStatus = true;
                                            helpTrend = false;
                                            helpSummary = false;
                                            helpPerformance = false;
                                            ppmStatus = false;
                                            ppmTrend = false;
                                            ppmSummary = false;
                                            ppmPerformance = false;
                                            ppmBtn = false;
                                            assetBtn = false;
                                          });
                                        });
                                      }),
                                  ListTile(
                                      selected: helpTrend,
                                      selectedTileColor: secondaryCard1,
                                      leading: Icon(Icons.trending_up,
                                          color: helpDeskBtn == true
                                              ? white
                                              : secondaryColor,
                                          size: 18),
                                      title: Text('Trend', style: textStyle),
                                      onTap: () {
                                        setState(() {
                                          setState(() {
                                            pageName = 'Helpdesk Trend';
                                            helpDeskBtn = true;
                                            helpTrend = true;
                                            helpStatus = false;
                                            helpSummary = false;
                                            helpPerformance = false;
                                            ppmStatus = false;
                                            ppmTrend = false;
                                            ppmSummary = false;
                                            ppmPerformance = false;
                                            ppmBtn = false;
                                            assetBtn = false;
                                          });
                                        });
                                      }),
                                  ListTile(
                                      selected: helpSummary,
                                      selectedTileColor: secondaryCard1,
                                      leading: Icon(Icons.description,
                                          color: helpDeskBtn == true
                                              ? white
                                              : secondaryColor,
                                          size: 18),
                                      title: Text('Summary', style: textStyle),
                                      onTap: () {
                                        setState(() {
                                          setState(() {
                                            pageName = 'Helpdesk Summary';
                                            helpTrend = false;
                                            helpStatus = false;
                                            helpSummary = true;
                                            helpPerformance = false;
                                            helpDeskBtn = true;
                                            ppmStatus = false;
                                            ppmTrend = false;
                                            ppmSummary = false;
                                            ppmPerformance = false;
                                            ppmBtn = false;
                                            assetBtn = false;
                                          });
                                        });
                                      }),
                                  ListTile(
                                      selected: helpPerformance,
                                      selectedTileColor: secondaryCard1,
                                      leading: Icon(Icons.network_check,
                                          color: helpDeskBtn == true
                                              ? white
                                              : secondaryColor,
                                          size: 18),
                                      title:
                                          Text('Performance', style: textStyle),
                                      onTap: () {
                                        setState(() {
                                          setState(() {
                                            pageName = 'Helpdesk Performance';
                                            helpTrend = false;
                                            helpStatus = false;
                                            helpSummary = false;
                                            helpPerformance = true;
                                            ppmStatus = false;
                                            ppmTrend = false;
                                            ppmSummary = false;
                                            ppmPerformance = false;
                                            helpDeskBtn = true;
                                            ppmBtn = false;
                                            assetBtn = false;
                                          });
                                        });
                                      }),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: menuCardWidth,
                          child: Card(
                            borderOnForeground: false,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            color: ppmBtn == true
                                ? secondaryColor
                                : buttonForeground,
                            elevation: 1,
                            shadowColor: white,
                            clipBehavior: Clip.antiAlias,
                            child: Theme(
                              data: ThemeData(
                                dividerColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                unselectedWidgetColor: ppmBtn == false
                                    ? secondaryColor
                                    : buttonForeground,
                              ),
                              child: ExpansionTile(
                                collapsedIconColor: ppmBtn == true
                                    ? buttonForeground
                                    : secondaryColor,
                                iconColor: ppmBtn == false
                                    ? secondaryColor
                                    : buttonForeground,
                                collapsedBackgroundColor: Colors.transparent,
                                backgroundColor: Colors.transparent,
                                leading: Icon(Icons.build,
                                    color:
                                        ppmBtn == true ? white : secondaryColor,
                                    size: 21),
                                title: Text(
                                  'PPM',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: ppmBtn == true
                                          ? white
                                          : secondaryColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                      letterSpacing: 1.1),
                                ),
                                children: <Widget>[
                                  ListTile(
                                      selected: ppmStatus,
                                      selectedTileColor: secondaryCard1,
                                      leading: Icon(Icons.headset_mic,
                                          color: ppmBtn == true
                                              ? white
                                              : secondaryColor,
                                          size: 18),
                                      title: Text('PPM Status',
                                          overflow: TextOverflow.ellipsis,
                                          style: ppmtextStyle),
                                      onTap: () {
                                        setState(() {
                                          setState(() {
                                            helpDeskBtn = false;
                                            ppmStatus = true;
                                            ppmTrend = false;
                                            ppmSummary = false;
                                            ppmPerformance = false;
                                            helpTrend = false;
                                            helpStatus = false;
                                            helpSummary = false;
                                            helpPerformance = false;
                                            pageName = 'PPM Status';
                                            ppmBtn = true;
                                            assetBtn = false;
                                          });
                                        });
                                      }),
                                  ListTile(
                                      selected: ppmTrend,
                                      selectedTileColor: secondaryCard1,
                                      leading: Icon(Icons.trending_up,
                                          color: ppmBtn == true
                                              ? white
                                              : secondaryColor,
                                          size: 18),
                                      title: Text('PPM Trend',
                                          overflow: TextOverflow.ellipsis,
                                          style: ppmtextStyle),
                                      onTap: () {
                                        setState(() {
                                          setState(() {
                                            helpDeskBtn = false;
                                            ppmTrend = true;
                                            ppmStatus = false;
                                            ppmSummary = false;
                                            ppmPerformance = false;
                                            helpTrend = false;
                                            helpStatus = false;
                                            helpSummary = false;
                                            helpPerformance = false;
                                            pageName = 'PPM Trend';
                                            ppmBtn = true;
                                            assetBtn = false;
                                          });
                                        });
                                      }),
                                  ListTile(
                                      selected: ppmSummary,
                                      selectedTileColor: secondaryCard1,
                                      leading: Icon(Icons.description,
                                          color: ppmBtn == true
                                              ? white
                                              : secondaryColor,
                                          size: 18),
                                      title: Text('PPM Summary',
                                          overflow: TextOverflow.ellipsis,
                                          style: ppmtextStyle),
                                      onTap: () {
                                        setState(() {
                                          setState(() {
                                            helpDeskBtn = false;
                                            ppmStatus = false;
                                            ppmTrend = false;
                                            ppmSummary = true;
                                            ppmPerformance = false;
                                            helpTrend = false;
                                            helpStatus = false;
                                            helpSummary = false;
                                            helpPerformance = false;
                                            pageName = 'PPM Summary';
                                            ppmBtn = true;
                                            assetBtn = false;
                                          });
                                        });
                                      }),
                                  ListTile(
                                      selected: ppmPerformance,
                                      selectedTileColor: secondaryCard1,
                                      leading: Icon(Icons.network_check,
                                          color: ppmBtn == true
                                              ? white
                                              : secondaryColor,
                                          size: 18),
                                      title: Text('PPM Performance',
                                          overflow: TextOverflow.ellipsis,
                                          style: ppmtextStyle),
                                      onTap: () {
                                        setState(() {
                                          setState(() {
                                            helpDeskBtn = false;
                                            ppmPerformance = true;
                                            ppmStatus = false;
                                            ppmTrend = false;
                                            ppmSummary = false;
                                            helpTrend = false;
                                            helpStatus = false;
                                            helpSummary = false;
                                            helpPerformance = false;
                                            pageName = 'PPM Performance';
                                            ppmBtn = true;
                                            assetBtn = false;
                                          });
                                        });
                                      }),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 11.0, right: 11.0, top: 12.0),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              helpDeskBtn = false;
                              ppmPerformance = false;
                              ppmStatus = false;
                              ppmTrend = false;
                              ppmSummary = false;
                              helpTrend = false;
                              helpStatus = false;
                              helpSummary = false;
                              helpPerformance = false;
                              ppmBtn = false;
                              pageName = 'Assets';
                              assetBtn = true;
                            });
                          },
                          child: Container(
                              height: 45,
                              width: menuCardWidth,
                              decoration: BoxDecoration(
                                  color: assetBtn == true
                                      ? secondaryColor
                                      : buttonForeground,
                                  borderRadius: BorderRadius.circular(10)),
                              child: (Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 17.0, right: 25),
                                    child: Icon(Icons.business,
                                        color: assetBtn == true
                                            ? buttonForeground
                                            : secondaryColor,
                                        size: 21),
                                  ),
                                  Text('Assets',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 13,
                                        letterSpacing: 1.1,
                                        fontWeight: FontWeight.w600,
                                        color: assetBtn == true
                                            ? buttonForeground
                                            : secondaryColor,
                                      ))
                                ],
                              ))),
                        ),
                      ),
                    ],
                  )),
                ),
                Flexible(
                  flex: 1,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(11.0),
                        child: Container(
                            height: 45,
                            width: menuCardWidth,
                            decoration: BoxDecoration(
                                color: buttonForeground,
                                borderRadius: BorderRadius.circular(10)),
                            child: (Row(
                              children: const [
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: 17.0, right: 25),
                                  child: Icon(Icons.print,
                                      color: secondaryColor, size: 21),
                                ),
                                Text('Print',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 13,
                                      letterSpacing: 1.1,
                                      fontWeight: FontWeight.w600,
                                      color: secondaryColor,
                                    ))
                              ],
                            ))),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(11.0),
                        child: InkWell(
                          onTap: () => {
                            screenShotFunction(),
                            Timer(const Duration(seconds: 1), () {
                              mail();
                            })
                          },
                          child: Container(
                              height: 45,
                              width: menuCardWidth,
                              decoration: BoxDecoration(
                                  color: buttonForeground,
                                  borderRadius: BorderRadius.circular(10)),
                              child: (Row(
                                children: const [
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: 17.0, right: 25),
                                    child: Icon(Icons.mail,
                                        color: secondaryColor, size: 21),
                                  ),
                                  Text('Email',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 13,
                                        letterSpacing: 1.1,
                                        fontWeight: FontWeight.w600,
                                        color: secondaryColor,
                                      ))
                                ],
                              ))),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 11.0, left: 11.0, right: 11.0),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              menuState = false;
                              profileInfo = true;
                            });
                          },
                          child: Container(
                              height: 45,
                              width: menuCardWidth,
                              decoration: BoxDecoration(
                                  color: buttonForeground,
                                  borderRadius: BorderRadius.circular(10)),
                              child: (Row(
                                children: const [
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: 17.0, right: 25),
                                    child: Icon(Icons.person,
                                        color: secondaryColor, size: 21),
                                  ),
                                  Text('Profile',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 13,
                                        letterSpacing: 1.1,
                                        fontWeight: FontWeight.w600,
                                        color: secondaryColor,
                                      ))
                                ],
                              ))),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        : Flexible(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    const Center(
                      child: CircleAvatar(
                        radius: 30,
                        child: Image(
                            image: AssetImage("assets/images/profile1.png")),
                      ),
                    ),
                    Center(
                      child: Text(username,
                          style: const TextStyle(
                              color: secondaryColor,
                              fontSize: 13,
                              fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(height: 10),
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0, bottom: 8.0),
                      child: Text('Email',
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w600)),
                    ),
                    const Text('       Admin@nanosoftSolutions.in',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: secondaryColor)),
                    const SizedBox(height: 5),
                    const Divider(
                        indent: 20,
                        endIndent: 25,
                        thickness: 0.2,
                        color: Colors.grey),
                    const SizedBox(height: 5),
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0, bottom: 8.0),
                      child: Text('Phone No',
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w600)),
                    ),
                    const Text('       0123456789',
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: secondaryColor)),
                    const SizedBox(height: 5),
                    const Divider(
                        indent: 20,
                        endIndent: 25,
                        thickness: 0.2,
                        color: Colors.grey),
                    const SizedBox(height: 10),
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text('Change language',
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w600)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: ListTile(
                        title: const Text('English',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: secondaryColor,
                                fontSize: 13,
                                fontWeight: FontWeight.w600)),
                        leading: const CircleAvatar(
                          radius: 12,
                          backgroundImage:
                              AssetImage('assets/images/america.png'),
                        ),
                        trailing: Checkbox(
                            shape: const CircleBorder(),
                            fillColor:
                                MaterialStateProperty.all(secondaryColor),
                            value: english,
                            onChanged: (bool? selected) {
                              if (arab == true) {
                                setState(() {
                                  arab = false;
                                  english = true;
                                });
                              }
                            }),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: ListTile(
                        title: const Text('Arabic',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: secondaryColor,
                                fontSize: 13,
                                fontWeight: FontWeight.w600)),
                        leading: const CircleAvatar(
                          radius: 12,
                          backgroundImage: AssetImage('assets/images/arab.png'),
                        ),
                        trailing: Checkbox(
                            shape: const CircleBorder(),
                            fillColor:
                                MaterialStateProperty.all(secondaryColor),
                            value: arab,
                            onChanged: (bool? selected) {
                              if (english == true) {
                                setState(() {
                                  arab = true;
                                  english = false;
                                });
                              }
                            }),
                      ),
                    ),
                    const Divider(
                        indent: 20,
                        endIndent: 25,
                        thickness: 0.2,
                        color: Colors.grey),
                  ],
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: changePassword,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: const [
                            Icon(Icons.vpn_key, color: secondaryColor),
                            SizedBox(
                              width: 5,
                            ),
                            Text('Change Password',
                                style: TextStyle(
                                    color: secondaryColor,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: logOutFunction,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: const [
                            Icon(Icons.power_settings_new,
                                color: secondaryColor),
                            SizedBox(
                              width: 5,
                            ),
                            Text('Logout',
                                style: TextStyle(
                                    color: secondaryColor,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ));
  }

  Widget formName() {
    return DefaultTextStyle(
      style: const TextStyle(
          overflow: TextOverflow.ellipsis,
          color: secondaryColor,
          fontSize: 22,
          fontWeight: FontWeight.w800),
      child: Text('$pageName'),
    );
  }

  Widget mobileFormName() {
    return Text(
      '$pageName',
      style: const TextStyle(
          // overflow: TextOverflow.ellipsis,
          color: secondaryColor,
          fontSize: 18,
          fontWeight: FontWeight.w800),
    );
  }

  Widget headerMenu() {
    double toolHeight = 85;
    double toolWidth = 135;
    double menuIcon = 19;
    return SizedBox(
      height: toolHeight,
      width: toolWidth,
      child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 4,
          shadowColor: Colors.black12,
          color: white,
          // shadowColor: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: const Icon(Icons.filter_list,
                    color: secondaryColor, size: 23),
                onPressed: () {
                  filter(context);
                  // entry();
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Container(
                    height: 35,
                    width: 35,
                    decoration: const BoxDecoration(
                      color: secondaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      hoverColor: Colors.transparent,
                      splashColor: secondaryColor,
                      splashRadius: 25,
                      focusColor: Colors.transparent,
                      icon: Icon(Icons.thumb_up_alt,
                          color: white, size: menuIcon),
                      onPressed: () {},
                    )),
              ),
            ],
          )),
    );
  }

  Widget searchAndPrint(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return Align(
        alignment: Alignment.topRight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: SizedBox(
                height: 85,
                width: 280,
                child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 4,
                    shadowColor: Colors.black12,
                    color: white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Flexible(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: TextField(
                              cursorColor: secondaryColor,
                              onChanged: (value) {},
                              decoration: InputDecoration(
                                filled: true,
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                                labelText: 'Search',
                                labelStyle:
                                    const TextStyle(color: secondaryColor),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                                focusColor: secondaryColor,
                                fillColor: buttonForeground,
                                hoverColor: lightShade,
                                prefixIcon: const Icon(
                                  Icons.search,
                                  color: secondaryColor,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 10.0),
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          hoverColor: Colors.transparent,
                          splashColor: secondaryColor,
                          splashRadius: 25,
                          focusColor: Colors.transparent,
                          icon: const Icon(Icons.print,
                              color: secondaryColor, size: 23),
                          onPressed: () {},
                        ),
                        IconButton(
                          hoverColor: Colors.transparent,
                          splashColor: secondaryColor,
                          splashRadius: 25,
                          focusColor: Colors.transparent,
                          icon: const Icon(Icons.present_to_all,
                              color: secondaryColor, size: 23),
                          onPressed: () {},
                        ),
                      ],
                    )),
              ),
            ),
            SizedBox(
              height: 85,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 4,
                shadowColor: Colors.black12,
                child: ToggleSwitch(
                  cornerRadius: 15.0,
                  minWidth: 74.0,
                  animate: true,
                  animationDuration: 500,
                  dividerColor: secondaryColor,
                  // doubleTapDisable: true,
                  fontSize: 15,
                  initialLabelIndex: 0,
                  activeBgColor: const [buttonForeground],
                  activeFgColor: secondaryColor,
                  inactiveBgColor: white,
                  inactiveFgColor: secondaryColor,
                  totalSwitches: 2,
                  icons: const [Icons.view_agenda, Icons.auto_awesome_mosaic],
                  labels: const ['List', 'Card'],
                  onToggle: (index) {},
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Future entry() {
    double entryMenuHeight = MediaQuery.of(context).size.height * 0.4;
    double entryMenuWidth = MediaQuery.of(context).size.width * 0.5;
    double timerWidth = MediaQuery.of(context).size.width * 0.08;
    const TextStyle dropDownStyle = TextStyle(
        fontSize: 14, fontWeight: FontWeight.w600, color: secondaryColor);
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return ElasticIn(
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: SizedBox(
                height: entryMenuHeight,
                width: entryMenuWidth,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Flexible(
                            flex: 2,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding:
                                          EdgeInsets.only(left: 5.0, top: 8.0),
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
                                          color: buttonForeground,
                                          shadowColor: white,
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
                                                      fontWeight:
                                                          FontWeight.w600)),
                                              const Icon(
                                                  Icons.keyboard_arrow_down,
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
                                          child: const SizedBox(
                                            height: 15,
                                            width: 40,
                                            child: Text('Today',
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
                                          child: const SizedBox(
                                            height: 15,
                                            width: 40,
                                            child: Text('Yesterday',
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w600,
                                                    color: secondaryColor)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding:
                                          EdgeInsets.only(left: 5.0, top: 8.0),
                                      child: Text('year',
                                          style: TextStyle(
                                              color: secondaryColor,
                                              fontWeight: FontWeight.w600)),
                                    ),
                                    InkWell(
                                      onTap: () {},
                                      child: SizedBox(
                                        height: 40,
                                        width: timerWidth,
                                        child: Card(
                                          color: buttonForeground,
                                          shadowColor: white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(4.0),
                                          ),
                                          elevation: 3,
                                          clipBehavior: Clip.antiAlias,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: const [
                                              Text('2022',
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color: secondaryColor,
                                                      fontWeight:
                                                          FontWeight.w600)),
                                              Icon(Icons.keyboard_arrow_down,
                                                  color: secondaryColor)
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding:
                                          EdgeInsets.only(left: 5.0, top: 8.0),
                                      child: Text('From Date',
                                          style: TextStyle(
                                              color: secondaryColor,
                                              fontWeight: FontWeight.w600)),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        datePicker();
                                      },
                                      child: SizedBox(
                                        height: 40,
                                        width: timerWidth,
                                        child: Card(
                                          color: buttonForeground,
                                          shadowColor: white,
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
                                                      fontWeight:
                                                          FontWeight.w600)),
                                              const Icon(
                                                  Icons.keyboard_arrow_down,
                                                  color: secondaryColor)
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding:
                                          EdgeInsets.only(left: 5.0, top: 8.0),
                                      child: Text('To Date',
                                          style: TextStyle(
                                              color: secondaryColor,
                                              fontWeight: FontWeight.w600)),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        datePicker();
                                      },
                                      child: SizedBox(
                                        height: 40,
                                        width: timerWidth,
                                        child: Card(
                                          color: buttonForeground,
                                          shadowColor: white,
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
                                                      fontWeight:
                                                          FontWeight.w600)),
                                              const Icon(
                                                  Icons.keyboard_arrow_down,
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
                          Flexible(
                            flex: 1,
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  OutlinedButton.icon(
                                    style: OutlinedButton.styleFrom(
                                      minimumSize: const Size(110, 45),
                                      maximumSize: const Size(110, 45),
                                      side: const BorderSide(
                                          width: 1.5, color: secondaryColor),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(4.0),
                                      ),
                                      primary: secondaryColor,
                                    ),
                                    onPressed: () {},
                                    icon:
                                        const Icon(Icons.restart_alt, size: 18),
                                    label: const Text("Reset"),
                                  ),
                                  ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: const Size(110, 45),
                                      maximumSize: const Size(110, 45),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(4.0),
                                      ),
                                      primary: secondaryColor,
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context, false);
                                    },
                                    icon: const Icon(Icons.search, size: 18),
                                    label: const Text("Search"),
                                  ),
                                ]),
                          )
                        ],
                      ),
                    ),
                    const Divider(
                      thickness: 0.5,
                      indent: 20,
                      endIndent: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          DropdownButtonHideUnderline(
                            child: DropdownButton2(
                              isExpanded: true,
                              focusColor: Colors.transparent,
                              hint: const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Country',
                                  style: dropDownStyle,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              items: items.map((item) {
                                return DropdownMenuItem<String>(
                                  value: item,
                                  enabled: false,
                                  child: StatefulBuilder(
                                    builder: (context, menuSetState) {
                                      final _isSelected =
                                          selectedItems.contains(item);
                                      return InkWell(
                                        onTap: () {
                                          _isSelected
                                              ? selectedItems.remove(item)
                                              : selectedItems.add(item);
                                          setState(() {});
                                          menuSetState(() {});
                                        },
                                        child: Container(
                                          height: double.infinity,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16.0),
                                          child: Row(
                                            children: [
                                              _isSelected
                                                  ? const Icon(
                                                      color: secondaryColor,
                                                      Icons.check_box)
                                                  : const Icon(
                                                      color: secondaryColor,
                                                      Icons
                                                          .check_box_outline_blank),
                                              const SizedBox(width: 16),
                                              Text(
                                                item,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                  color: secondaryColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              }).toList(),
                              value: selectedItems.isEmpty
                                  ? null
                                  : selectedItems.last,
                              onChanged: (value) {},
                              icon: selectedItems.isEmpty
                                  ? const Icon(
                                      Icons.expand_more,
                                      color: secondaryColor,
                                    )
                                  : IconButton(
                                      hoverColor: Colors.transparent,
                                      splashColor: red,
                                      onPressed: () {
                                        setState(() {
                                          selectedItems.clear();
                                        });
                                      },
                                      color: red,
                                      icon: const Icon(Icons.clear),
                                    ),
                              iconSize: 19,
                              buttonHeight: selectedItems.isEmpty ? 40 : 40,
                              buttonWidth: 140,
                              dropdownMaxHeight: 200,
                              dropdownWidth: 180,
                              dropdownPadding: null,
                              dropdownDecoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: lightShade1,
                              ),
                              dropdownElevation: 8,
                              // itemHeight: 30,
                              buttonDecoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                      width: 2.0, color: secondaryColor),
                                ),
                              ),
                              selectedItemBuilder: (context) {
                                return items.map(
                                  (item) {
                                    return Column(
                                      children: [
                                        const Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text('Country',
                                                style: dropDownStyle)),
                                        Align(
                                          alignment: Alignment.bottomLeft,
                                          child: Text(
                                            selectedItems.join(', '),
                                            style: const TextStyle(
                                                fontSize: 14,
                                                overflow: TextOverflow.ellipsis,
                                                color: secondaryColor),
                                            maxLines: 1,
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ).toList();
                              },
                            ),
                          ),
                          DropdownButtonHideUnderline(
                            child: DropdownButton2(
                              isExpanded: true,
                              focusColor: Colors.transparent,
                              hint: const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Country',
                                  style: dropDownStyle,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              items: items.map((item) {
                                return DropdownMenuItem<String>(
                                  value: item,
                                  enabled: false,
                                  child: StatefulBuilder(
                                    builder: (context, menuSetState) {
                                      final _isSelected =
                                          selectedItems.contains(item);
                                      return InkWell(
                                        onTap: () {
                                          _isSelected
                                              ? selectedItems.remove(item)
                                              : selectedItems.add(item);
                                          setState(() {});
                                          menuSetState(() {});
                                        },
                                        child: Container(
                                          height: double.infinity,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16.0),
                                          child: Row(
                                            children: [
                                              _isSelected
                                                  ? const Icon(
                                                      color: secondaryColor,
                                                      Icons.check_box)
                                                  : const Icon(
                                                      color: secondaryColor,
                                                      Icons
                                                          .check_box_outline_blank),
                                              const SizedBox(width: 16),
                                              Text(
                                                item,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                  color: secondaryColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              }).toList(),
                              value: selectedItems.isEmpty
                                  ? null
                                  : selectedItems.last,
                              onChanged: (value) {},
                              icon: selectedItems.isEmpty
                                  ? const Icon(
                                      Icons.expand_more,
                                      color: secondaryColor,
                                    )
                                  : IconButton(
                                      hoverColor: Colors.transparent,
                                      splashColor: red,
                                      onPressed: () {
                                        setState(() {
                                          selectedItems.clear();
                                        });
                                      },
                                      color: red,
                                      icon: const Icon(Icons.clear),
                                    ),
                              iconSize: 19,
                              buttonHeight: selectedItems.isEmpty ? 40 : 40,
                              buttonWidth: 140,
                              dropdownMaxHeight: 200,
                              dropdownWidth: 180,
                              dropdownPadding: null,
                              dropdownDecoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: lightShade1,
                              ),
                              dropdownElevation: 8,
                              // itemHeight: 30,
                              buttonDecoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                      width: 2.0, color: secondaryColor),
                                ),
                              ),
                              selectedItemBuilder: (context) {
                                return items.map(
                                  (item) {
                                    return Column(
                                      children: [
                                        const Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text('Country',
                                                style: dropDownStyle)),
                                        Align(
                                          alignment: Alignment.bottomLeft,
                                          child: Text(
                                            selectedItems.join(', '),
                                            style: const TextStyle(
                                                fontSize: 14,
                                                overflow: TextOverflow.ellipsis,
                                                color: secondaryColor),
                                            maxLines: 1,
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ).toList();
                              },
                            ),
                          ),
                          DropdownButtonHideUnderline(
                            child: DropdownButton2(
                              isExpanded: true,
                              focusColor: Colors.transparent,
                              hint: const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Country',
                                  style: dropDownStyle,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              items: items.map((item) {
                                return DropdownMenuItem<String>(
                                  value: item,
                                  enabled: false,
                                  child: StatefulBuilder(
                                    builder: (context, menuSetState) {
                                      final _isSelected =
                                          selectedItems.contains(item);
                                      return InkWell(
                                        onTap: () {
                                          _isSelected
                                              ? selectedItems.remove(item)
                                              : selectedItems.add(item);
                                          setState(() {});
                                          menuSetState(() {});
                                        },
                                        child: Container(
                                          height: double.infinity,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16.0),
                                          child: Row(
                                            children: [
                                              _isSelected
                                                  ? const Icon(
                                                      color: secondaryColor,
                                                      Icons.check_box)
                                                  : const Icon(
                                                      color: secondaryColor,
                                                      Icons
                                                          .check_box_outline_blank),
                                              const SizedBox(width: 16),
                                              Text(
                                                item,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                  color: secondaryColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              }).toList(),
                              value: selectedItems.isEmpty
                                  ? null
                                  : selectedItems.last,
                              onChanged: (value) {},
                              icon: selectedItems.isEmpty
                                  ? const Icon(
                                      Icons.expand_more,
                                      color: secondaryColor,
                                    )
                                  : IconButton(
                                      hoverColor: Colors.transparent,
                                      splashColor: red,
                                      onPressed: () {
                                        setState(() {
                                          selectedItems.clear();
                                        });
                                      },
                                      color: red,
                                      icon: const Icon(Icons.clear),
                                    ),
                              iconSize: 19,
                              buttonHeight: selectedItems.isEmpty ? 40 : 40,
                              buttonWidth: 140,
                              dropdownMaxHeight: 200,
                              dropdownWidth: 180,
                              dropdownPadding: null,
                              dropdownDecoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: lightShade1,
                              ),
                              dropdownElevation: 8,
                              // itemHeight: 30,
                              buttonDecoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                      width: 2.0, color: secondaryColor),
                                ),
                              ),
                              selectedItemBuilder: (context) {
                                return items.map(
                                  (item) {
                                    return Column(
                                      children: [
                                        const Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text('Country',
                                                style: dropDownStyle)),
                                        Align(
                                          alignment: Alignment.bottomLeft,
                                          child: Text(
                                            selectedItems.join(', '),
                                            style: const TextStyle(
                                                fontSize: 14,
                                                overflow: TextOverflow.ellipsis,
                                                color: secondaryColor),
                                            maxLines: 1,
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ).toList();
                              },
                            ),
                          ),
                          DropdownButtonHideUnderline(
                            child: DropdownButton2(
                              isExpanded: true,
                              focusColor: Colors.transparent,
                              hint: const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Country',
                                  style: dropDownStyle,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              items: items.map((item) {
                                return DropdownMenuItem<String>(
                                  value: item,
                                  enabled: false,
                                  child: StatefulBuilder(
                                    builder: (context, menuSetState) {
                                      final _isSelected =
                                          selectedItems.contains(item);
                                      return InkWell(
                                        onTap: () {
                                          _isSelected
                                              ? selectedItems.remove(item)
                                              : selectedItems.add(item);
                                          setState(() {});
                                          menuSetState(() {});
                                        },
                                        child: Container(
                                          height: double.infinity,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16.0),
                                          child: Row(
                                            children: [
                                              _isSelected
                                                  ? const Icon(
                                                      color: secondaryColor,
                                                      Icons.check_box)
                                                  : const Icon(
                                                      color: secondaryColor,
                                                      Icons
                                                          .check_box_outline_blank),
                                              const SizedBox(width: 16),
                                              Text(
                                                item,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                  color: secondaryColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              }).toList(),
                              value: selectedItems.isEmpty
                                  ? null
                                  : selectedItems.last,
                              onChanged: (value) {},
                              icon: selectedItems.isEmpty
                                  ? const Icon(
                                      Icons.expand_more,
                                      color: secondaryColor,
                                    )
                                  : IconButton(
                                      hoverColor: Colors.transparent,
                                      splashColor: red,
                                      onPressed: () {
                                        setState(() {
                                          selectedItems.clear();
                                        });
                                      },
                                      color: red,
                                      icon: const Icon(Icons.clear),
                                    ),
                              iconSize: 19,
                              buttonHeight: selectedItems.isEmpty ? 40 : 40,
                              buttonWidth: 140,
                              dropdownMaxHeight: 200,
                              dropdownWidth: 180,
                              dropdownPadding: null,
                              dropdownDecoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: lightShade1,
                              ),
                              dropdownElevation: 8,
                              // itemHeight: 30,
                              buttonDecoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                      width: 2.0, color: secondaryColor),
                                ),
                              ),
                              selectedItemBuilder: (context) {
                                return items.map(
                                  (item) {
                                    return Column(
                                      children: [
                                        const Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text('Country',
                                                style: dropDownStyle)),
                                        Align(
                                          alignment: Alignment.bottomLeft,
                                          child: Text(
                                            selectedItems.join(', '),
                                            style: const TextStyle(
                                                fontSize: 14,
                                                overflow: TextOverflow.ellipsis,
                                                color: secondaryColor),
                                            maxLines: 1,
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ).toList();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          DropdownButtonHideUnderline(
                            child: DropdownButton2(
                              isExpanded: true,
                              focusColor: Colors.transparent,
                              hint: const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Country',
                                  style: dropDownStyle,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              items: items.map((item) {
                                return DropdownMenuItem<String>(
                                  value: item,
                                  enabled: false,
                                  child: StatefulBuilder(
                                    builder: (context, menuSetState) {
                                      final _isSelected =
                                          selectedItems.contains(item);
                                      return InkWell(
                                        onTap: () {
                                          _isSelected
                                              ? selectedItems.remove(item)
                                              : selectedItems.add(item);
                                          setState(() {});
                                          menuSetState(() {});
                                        },
                                        child: Container(
                                          height: double.infinity,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16.0),
                                          child: Row(
                                            children: [
                                              _isSelected
                                                  ? const Icon(
                                                      color: secondaryColor,
                                                      Icons.check_box)
                                                  : const Icon(
                                                      color: secondaryColor,
                                                      Icons
                                                          .check_box_outline_blank),
                                              const SizedBox(width: 16),
                                              Text(
                                                item,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                  color: secondaryColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              }).toList(),
                              value: selectedItems.isEmpty
                                  ? null
                                  : selectedItems.last,
                              onChanged: (value) {},
                              icon: selectedItems.isEmpty
                                  ? const Icon(
                                      Icons.expand_more,
                                      color: secondaryColor,
                                    )
                                  : IconButton(
                                      hoverColor: Colors.transparent,
                                      splashColor: red,
                                      onPressed: () {
                                        setState(() {
                                          selectedItems.clear();
                                        });
                                      },
                                      color: red,
                                      icon: const Icon(Icons.clear),
                                    ),
                              iconSize: 19,
                              buttonHeight: selectedItems.isEmpty ? 40 : 40,
                              buttonWidth: 140,
                              dropdownMaxHeight: 200,
                              dropdownWidth: 180,
                              dropdownPadding: null,
                              dropdownDecoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: lightShade1,
                              ),
                              dropdownElevation: 8,
                              // itemHeight: 30,
                              buttonDecoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                      width: 2.0, color: secondaryColor),
                                ),
                              ),
                              selectedItemBuilder: (context) {
                                return items.map(
                                  (item) {
                                    return Column(
                                      children: [
                                        const Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text('Country',
                                                style: dropDownStyle)),
                                        Align(
                                          alignment: Alignment.bottomLeft,
                                          child: Text(
                                            selectedItems.join(', '),
                                            style: const TextStyle(
                                                fontSize: 14,
                                                overflow: TextOverflow.ellipsis,
                                                color: secondaryColor),
                                            maxLines: 1,
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ).toList();
                              },
                            ),
                          ),
                          DropdownButtonHideUnderline(
                            child: DropdownButton2(
                              isExpanded: true,
                              focusColor: Colors.transparent,
                              hint: const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Country',
                                  style: dropDownStyle,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              items: items.map((item) {
                                return DropdownMenuItem<String>(
                                  value: item,
                                  enabled: false,
                                  child: StatefulBuilder(
                                    builder: (context, menuSetState) {
                                      final _isSelected =
                                          selectedItems.contains(item);
                                      return InkWell(
                                        onTap: () {
                                          _isSelected
                                              ? selectedItems.remove(item)
                                              : selectedItems.add(item);
                                          setState(() {});
                                          menuSetState(() {});
                                        },
                                        child: Container(
                                          height: double.infinity,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16.0),
                                          child: Row(
                                            children: [
                                              _isSelected
                                                  ? const Icon(
                                                      color: secondaryColor,
                                                      Icons.check_box)
                                                  : const Icon(
                                                      color: secondaryColor,
                                                      Icons
                                                          .check_box_outline_blank),
                                              const SizedBox(width: 16),
                                              Text(
                                                item,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                  color: secondaryColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              }).toList(),
                              value: selectedItems.isEmpty
                                  ? null
                                  : selectedItems.last,
                              onChanged: (value) {},
                              icon: selectedItems.isEmpty
                                  ? const Icon(
                                      Icons.expand_more,
                                      color: secondaryColor,
                                    )
                                  : IconButton(
                                      hoverColor: Colors.transparent,
                                      splashColor: red,
                                      onPressed: () {
                                        setState(() {
                                          selectedItems.clear();
                                        });
                                      },
                                      color: red,
                                      icon: const Icon(Icons.clear),
                                    ),
                              iconSize: 19,
                              buttonHeight: selectedItems.isEmpty ? 40 : 40,
                              buttonWidth: 140,
                              dropdownMaxHeight: 200,
                              dropdownWidth: 180,
                              dropdownPadding: null,
                              dropdownDecoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: lightShade1,
                              ),
                              dropdownElevation: 8,
                              // itemHeight: 30,
                              buttonDecoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                      width: 2.0, color: secondaryColor),
                                ),
                              ),
                              selectedItemBuilder: (context) {
                                return items.map(
                                  (item) {
                                    return Column(
                                      children: [
                                        const Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text('Country',
                                                style: dropDownStyle)),
                                        Align(
                                          alignment: Alignment.bottomLeft,
                                          child: Text(
                                            selectedItems.join(', '),
                                            style: const TextStyle(
                                                fontSize: 14,
                                                overflow: TextOverflow.ellipsis,
                                                color: secondaryColor),
                                            maxLines: 1,
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ).toList();
                              },
                            ),
                          ),
                          DropdownButtonHideUnderline(
                            child: DropdownButton2(
                              isExpanded: true,
                              focusColor: Colors.transparent,
                              hint: const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Country',
                                  style: dropDownStyle,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              items: items.map((item) {
                                return DropdownMenuItem<String>(
                                  value: item,
                                  enabled: false,
                                  child: StatefulBuilder(
                                    builder: (context, menuSetState) {
                                      final _isSelected =
                                          selectedItems.contains(item);
                                      return InkWell(
                                        onTap: () {
                                          _isSelected
                                              ? selectedItems.remove(item)
                                              : selectedItems.add(item);
                                          setState(() {});
                                          menuSetState(() {});
                                        },
                                        child: Container(
                                          height: double.infinity,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16.0),
                                          child: Row(
                                            children: [
                                              _isSelected
                                                  ? const Icon(
                                                      color: secondaryColor,
                                                      Icons.check_box)
                                                  : const Icon(
                                                      color: secondaryColor,
                                                      Icons
                                                          .check_box_outline_blank),
                                              const SizedBox(width: 16),
                                              Text(
                                                item,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                  color: secondaryColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              }).toList(),
                              value: selectedItems.isEmpty
                                  ? null
                                  : selectedItems.last,
                              onChanged: (value) {},
                              icon: selectedItems.isEmpty
                                  ? const Icon(
                                      Icons.expand_more,
                                      color: secondaryColor,
                                    )
                                  : IconButton(
                                      hoverColor: Colors.transparent,
                                      splashColor: red,
                                      onPressed: () {
                                        setState(() {
                                          selectedItems.clear();
                                        });
                                      },
                                      color: red,
                                      icon: const Icon(Icons.clear),
                                    ),
                              iconSize: 19,
                              buttonHeight: selectedItems.isEmpty ? 40 : 40,
                              buttonWidth: 140,
                              dropdownMaxHeight: 200,
                              dropdownWidth: 180,
                              dropdownPadding: null,
                              dropdownDecoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: lightShade1,
                              ),
                              dropdownElevation: 8,
                              // itemHeight: 30,
                              buttonDecoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                      width: 2.0, color: secondaryColor),
                                ),
                              ),
                              selectedItemBuilder: (context) {
                                return items.map(
                                  (item) {
                                    return Column(
                                      children: [
                                        const Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text('Country',
                                                style: dropDownStyle)),
                                        Align(
                                          alignment: Alignment.bottomLeft,
                                          child: Text(
                                            selectedItems.join(', '),
                                            style: const TextStyle(
                                                fontSize: 14,
                                                overflow: TextOverflow.ellipsis,
                                                color: secondaryColor),
                                            maxLines: 1,
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ).toList();
                              },
                            ),
                          ),
                          DropdownButtonHideUnderline(
                            child: DropdownButton2(
                              isExpanded: true,
                              focusColor: Colors.transparent,
                              hint: const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Country',
                                  style: dropDownStyle,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              items: items.map((item) {
                                return DropdownMenuItem<String>(
                                  value: item,
                                  enabled: false,
                                  child: StatefulBuilder(
                                    builder: (context, menuSetState) {
                                      final _isSelected =
                                          selectedItems.contains(item);
                                      return InkWell(
                                        onTap: () {
                                          _isSelected
                                              ? selectedItems.remove(item)
                                              : selectedItems.add(item);
                                          setState(() {});
                                          menuSetState(() {});
                                        },
                                        child: Container(
                                          height: double.infinity,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16.0),
                                          child: Row(
                                            children: [
                                              _isSelected
                                                  ? const Icon(
                                                      color: secondaryColor,
                                                      Icons.check_box)
                                                  : const Icon(
                                                      color: secondaryColor,
                                                      Icons
                                                          .check_box_outline_blank),
                                              const SizedBox(width: 16),
                                              Text(
                                                item,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                  color: secondaryColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              }).toList(),
                              value: selectedItems.isEmpty
                                  ? null
                                  : selectedItems.last,
                              onChanged: (value) {},
                              icon: selectedItems.isEmpty
                                  ? const Icon(
                                      Icons.expand_more,
                                      color: secondaryColor,
                                    )
                                  : IconButton(
                                      hoverColor: Colors.transparent,
                                      splashColor: red,
                                      onPressed: () {
                                        setState(() {
                                          selectedItems.clear();
                                        });
                                      },
                                      color: red,
                                      icon: const Icon(Icons.clear),
                                    ),
                              iconSize: 19,
                              buttonHeight: selectedItems.isEmpty ? 40 : 40,
                              buttonWidth: 140,
                              dropdownMaxHeight: 200,
                              dropdownWidth: 180,
                              dropdownPadding: null,
                              dropdownDecoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: lightShade1,
                              ),
                              dropdownElevation: 8,
                              // itemHeight: 30,
                              buttonDecoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                      width: 2.0, color: secondaryColor),
                                ),
                              ),
                              selectedItemBuilder: (context) {
                                return items.map(
                                  (item) {
                                    return Column(
                                      children: [
                                        const Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text('Country',
                                                style: dropDownStyle)),
                                        Align(
                                          alignment: Alignment.bottomLeft,
                                          child: Text(
                                            selectedItems.join(', '),
                                            style: const TextStyle(
                                                fontSize: 14,
                                                overflow: TextOverflow.ellipsis,
                                                color: secondaryColor),
                                            maxLines: 1,
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ).toList();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 15.0,
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2(
                          isExpanded: true,
                          focusColor: Colors.transparent,
                          hint: const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Country',
                              style: dropDownStyle,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          items: items.map((item) {
                            return DropdownMenuItem<String>(
                              value: item,
                              enabled: false,
                              child: StatefulBuilder(
                                builder: (context, menuSetState) {
                                  final _isSelected =
                                      selectedItems.contains(item);
                                  return InkWell(
                                    onTap: () {
                                      _isSelected
                                          ? selectedItems.remove(item)
                                          : selectedItems.add(item);
                                      setState(() {});
                                      menuSetState(() {});
                                    },
                                    child: Container(
                                      height: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      child: Row(
                                        children: [
                                          _isSelected
                                              ? const Icon(
                                                  color: secondaryColor,
                                                  Icons.check_box)
                                              : const Icon(
                                                  color: secondaryColor,
                                                  Icons
                                                      .check_box_outline_blank),
                                          const SizedBox(width: 16),
                                          Text(
                                            item,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: secondaryColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          }).toList(),
                          value:
                              selectedItems.isEmpty ? null : selectedItems.last,
                          onChanged: (value) {},
                          icon: selectedItems.isEmpty
                              ? const Icon(
                                  Icons.expand_more,
                                  color: secondaryColor,
                                )
                              : IconButton(
                                  hoverColor: Colors.transparent,
                                  splashColor: red,
                                  onPressed: () {
                                    setState(() {
                                      selectedItems.clear();
                                    });
                                  },
                                  color: red,
                                  icon: const Icon(Icons.clear),
                                ),
                          iconSize: 19,
                          buttonHeight: selectedItems.isEmpty ? 40 : 40,
                          buttonWidth: 140,
                          dropdownMaxHeight: 200,
                          dropdownWidth: 180,
                          dropdownPadding: null,
                          dropdownDecoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            color: lightShade1,
                          ),
                          dropdownElevation: 8,
                          // itemHeight: 30,
                          buttonDecoration: const BoxDecoration(
                            border: Border(
                              bottom:
                                  BorderSide(width: 2.0, color: secondaryColor),
                            ),
                          ),
                          selectedItemBuilder: (context) {
                            return items.map(
                              (item) {
                                return Column(
                                  children: [
                                    const Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text('Country',
                                            style: dropDownStyle)),
                                    Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Text(
                                        selectedItems.join(', '),
                                        style: const TextStyle(
                                            fontSize: 14,
                                            overflow: TextOverflow.ellipsis,
                                            color: secondaryColor),
                                        maxLines: 1,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ).toList();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }

  Future changePassword() {
    double passwordHeight = MediaQuery.of(context).size.height * 0.5;
    double passwordWidth = MediaQuery.of(context).size.width * 0.3;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return ElasticIn(
                child: Dialog(
                    elevation: 13,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: SizedBox(
                      height: passwordHeight,
                      width: passwordWidth,
                      child: Form(
                        key: passwordKey,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                  decoration: const BoxDecoration(
                                      color: secondaryColor,
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(10.0),
                                          topLeft: Radius.circular(10.0))),
                                  width: double.infinity,
                                  height: 40,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 20.0),
                                        child: Row(
                                          children: const [
                                            Icon(
                                              Icons.lock,
                                              color: white,
                                              size: 15,
                                            ),
                                            SizedBox(width: 10),
                                            Text('Change Password',
                                                style: TextStyle(
                                                    color: white,
                                                    fontSize: 13,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8.0),
                                        child: IconButton(
                                          hoverColor: primaryColor,
                                          splashRadius: 16,
                                          icon: const Icon(Icons.close_rounded,
                                              color: white, size: 15),
                                          onPressed: () {
                                            Navigator.pop(context, false);
                                          },
                                        ),
                                      ),
                                    ],
                                  )),
                              Flexible(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: TextFormField(
                                    validator: (String? value) {
                                      if (value != null && value.isEmpty) {
                                        return "Password should not be empty";
                                      } else {
                                        return null;
                                      }
                                    },
                                    cursorColor: secondaryColor,
                                    controller: oldPasswordController,
                                    obscureText: isObscure0,
                                    decoration: InputDecoration(
                                      fillColor: Colors.blue.shade50,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none,
                                      ),
                                      hoverColor: lightShade,
                                      filled: true,
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.auto,
                                      focusColor: secondaryColor,
                                      labelText: 'Old Password.',
                                      floatingLabelStyle: const TextStyle(
                                          fontSize: 13,
                                          height: 4,
                                          fontWeight: FontWeight.w600,
                                          color: secondaryColor),
                                      labelStyle: const TextStyle(
                                          color: secondaryColor),
                                      suffixIcon: IconButton(
                                        hoverColor: white,
                                        splashColor: white,
                                        icon: Icon(
                                          isObscure0
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                          color: secondaryColor,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            isObscure0 = !isObscure0;
                                          });
                                          setState(() {
                                            isObscure0;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0, right: 10.0, bottom: 10.0),
                                  child: TextFormField(
                                    validator: (String? value) {
                                      if (value != null && value.isEmpty) {
                                        return "New Password should not be empty";
                                      } else {
                                        return null;
                                      }
                                    },
                                    cursorColor: secondaryColor,
                                    controller: newPasswordController,
                                    obscureText: isObscure1,
                                    decoration: InputDecoration(
                                      fillColor: Colors.blue.shade50,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none,
                                      ),
                                      hoverColor: lightShade,
                                      filled: true,
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.auto,
                                      focusColor: secondaryColor,
                                      labelText: 'New Password.',
                                      floatingLabelStyle: const TextStyle(
                                          fontSize: 14,
                                          height: 4,
                                          fontWeight: FontWeight.w600,
                                          color: secondaryColor),
                                      labelStyle: const TextStyle(
                                          color: secondaryColor),
                                      suffixIcon: IconButton(
                                        hoverColor: white,
                                        splashColor: white,
                                        icon: Icon(
                                          isObscure1
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                          color: secondaryColor,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            isObscure1 = !isObscure1;
                                          });
                                          setState(() {
                                            isObscure1;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0, right: 10.0, bottom: 10.0),
                                  child: TextFormField(
                                    validator: (String? value) {
                                      if (value != null && value.isEmpty) {
                                        return "Confirm Password should not be empty";
                                      }
                                      if (value != newPasswordController.text) {
                                        return "Password  Doesn't Match";
                                      } else {
                                        return null;
                                      }
                                    },
                                    cursorColor: secondaryColor,
                                    controller: confirmPasswordController,
                                    obscureText: isObscure2,
                                    decoration: InputDecoration(
                                      fillColor: Colors.blue.shade50,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none,
                                      ),
                                      hoverColor: lightShade,
                                      filled: true,
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.auto,
                                      focusColor: secondaryColor,
                                      labelText: 'Confirm Password.',
                                      floatingLabelStyle: const TextStyle(
                                          fontSize: 14,
                                          height: 4,
                                          fontWeight: FontWeight.w600,
                                          color: secondaryColor),
                                      labelStyle: const TextStyle(
                                          color: secondaryColor),
                                      suffixIcon: IconButton(
                                        hoverColor: white,
                                        splashColor: white,
                                        icon: Icon(
                                          isObscure2
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                          color: secondaryColor,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            isObscure2 = !isObscure2;
                                          });
                                          setState(() {
                                            isObscure2;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        minimumSize: const Size(110, 45),
                                        backgroundColor: secondaryColor,
                                        maximumSize: const Size(110, 45),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                      ),
                                      onPressed: () {
                                        if (passwordKey.currentState!
                                            .validate()) {
                                          (oldPasswordController.text
                                              .toString());
                                          (newPasswordController.text
                                              .toString());
                                          (confirmPasswordController.text
                                              .toString());
                                          print(newPasswordController.text
                                              .toString());
                                          print(confirmPasswordController.text
                                              .toString());
                                        }
                                      },
                                      child: const Text("Submit"),
                                    ),
                                  ),
                                ),
                              )
                            ]),
                      ),
                    )));
          });
        });
  }

  Future mail() {
    double mailMenuHeight = MediaQuery.of(context).size.height * 0.8;
    double mailMenuWidth = MediaQuery.of(context).size.width * 0.5;
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return ElasticIn(
            child: Dialog(
              elevation: 13,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: SizedBox(
                height: mailMenuHeight,
                width: mailMenuWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        decoration: const BoxDecoration(
                            color: secondaryColor,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10.0),
                                topLeft: Radius.circular(10.0))),
                        width: double.infinity,
                        height: 40,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Row(
                                children: const [
                                  Icon(
                                    Icons.send_rounded,
                                    color: white,
                                    size: 15,
                                  ),
                                  SizedBox(width: 10),
                                  Text('Send Mail To',
                                      style: TextStyle(
                                          color: white,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 5.0),
                              child: IconButton(
                                hoverColor: primaryColor,
                                splashRadius: 16,
                                icon: const Icon(Icons.close_rounded,
                                    color: white, size: 15),
                                onPressed: () {
                                  Navigator.pop(context, false);
                                },
                              ),
                            ),
                          ],
                        )),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: mailId(),
                    ),
                    subject(),
                    Flexible(child: content()),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              attachment(context, _imageFile),
                              const SizedBox(height: 10),
                              Text('$pageName$imgName.jpeg',
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      color: secondaryColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                          sendMailBtn(),
                        ],
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(
                    //       left: 8.0, right: 8.0, bottom: 10.0),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //
                    //       sendMailBtn(),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }

  Widget mailId() {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.always,
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Email can not be empty';
          }
          if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
            return "Invalid Email Address";
          }
          return null;
        },
        cursorColor: secondaryColor,
        textAlignVertical: TextAlignVertical.bottom,
        controller: mailIdController,
        decoration: InputDecoration(
          fillColor: Colors.blue.shade50,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          hoverColor: lightShade,
          focusColor: secondaryColor,
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          filled: true,
          floatingLabelStyle: const TextStyle(
              fontSize: 14,
              height: 4,
              // fontWeight: FontWeight.w600,
              color: secondaryColor),
          labelStyle: const TextStyle(color: secondaryColor),
          labelText: 'From',
          suffixIcon: const Icon(Icons.email_rounded, color: secondaryColor),
        ),
      ),
    );
  }

  Widget subject() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Row(
              children: [
                const Text(
                  'Subject :',
                  style: TextStyle(color: secondaryColor, fontSize: 15),
                ),
                const SizedBox(width: 10),
                Text(
                  'Helpdesk charts',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700),
                )
              ],
            ),
          )),
    );
  }

  Widget content() {
    // var commonStyle = TextStyle(
    //     fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey.shade700);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Container(
            height: MediaQuery.of(context).size.height * 0.4,
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0, top: 8.0, bottom: 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Content',
                            style: TextStyle(
                              color: secondaryColor,
                              fontSize: 15,
                            )),
                        Text('Hi', style: commonStyle),
                        Text('Sharing HelpDesk Charts for your reference',
                            style: commonStyle),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text('From', style: commonStyle),
                                Text('To', style: commonStyle),
                                Text('Country', style: commonStyle),
                                Text('Customer', style: commonStyle),
                                Text('Contract', style: commonStyle),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(': $startDate', style: commonStyle),
                                Text(': $currentDate', style: commonStyle),
                                Text(': All', style: commonStyle),
                                Text(': All', style: commonStyle),
                                Text(': All', style: commonStyle),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(width: 30),
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text('LocationGroup', style: commonStyle),
                                Text('City', style: commonStyle),
                                Text('Location', style: commonStyle),
                                Text('Building', style: commonStyle),
                                Text('Floor', style: commonStyle),
                                Text('Spot', style: commonStyle),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(': All', style: commonStyle),
                                Text(': All', style: commonStyle),
                                Text(': All', style: commonStyle),
                                Text(': All', style: commonStyle),
                                Text(': All', style: commonStyle),
                                Text(': All', style: commonStyle),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }

  Widget attachment(BuildContext context, Uint8List capturedImage) {
    return Container(
      height: 60,
      width: 90,
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.memory(capturedImage),
      ),
    );
  }

  Widget sendMailBtn() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(110, 45),
        maximumSize: const Size(110, 45),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        primary: secondaryColor,
      ),
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          (mailIdController.text.toString());
          print(mailIdController.text.toString());
        }
      },
      child: const Text("Send"),
    );
  }
}
