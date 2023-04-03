import 'dart:convert';
import 'package:animate_do/animate_do.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Styles/CommonColor.dart';
import '../../Styles/responsive.dart';
import '../dashboard/dashboard.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isObscure = true;

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
            const Icon(Icons.error, color: Colors.white),
            const SizedBox(
              width: 12,
            ),
            Text(
              message,
              style: const TextStyle(
                  letterSpacing: 1, fontSize: 12, color: Colors.white),
            ),
          ],
        )));
  }

  Future<void> login(String userName, password) async {
    final name = userName;
    final Password = password;
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String Username = stringToBase64.encode(name.toString());
    String Pass = stringToBase64.encode(Password.toString());
    String ip = 'http://207.180.211.5:5010/';
    String Api = 'UserLogin_API/';
    final url = Uri.parse('$ip$Api');
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    };
    final json =
        '{"data": {"username": "$Username","password": "$Pass","type": "Web","ServcerIP": "","AppCategoryID": "1","LoginType": "login"}}';

    final response =
        await http.post(url, headers: headers, body: json.toString());
    if (response.statusCode == 400) {
      String Err = 'something went wrong!';
      toastMessageFunc(Err);
    } else {
      final datas = jsonDecode(response.body);
      if (datas == 0) {
        String error = ('Invalid UserName are Password');
        toastMessageFunc(error);
      } else {
        final datas = jsonDecode(response.body);
        String statusval = ('${datas['Output']['status']['code']}');
        if (statusval == '400') {
          final datas = jsonDecode(response.body);
          var alreadyLoggedUserID = datas['Output']['error']['data'];
          String Error = ('${datas['Output']['error']['message']}');
          if (Error == 'User already logged in') {
            sessionAlert(alreadyLoggedUserID);
          } else {
            toastMessageFunc(Error);
          }
        } else {
          String name = ('${datas['Output']['data']['username']}');
          String password = ('${datas['Output']['data']['password']}');
          int UserID = (datas['Output']['data']['userid']);
          int UserGroupID = (datas['Output']['data']['UserGroupID']);
          int SessionId = (datas['Output']['data']['sessionid']);
          //-- Converting username password to base64 form api response
          Codec<String, String> stringToBase64 = utf8.fuse(base64);
          String username = stringToBase64.encode(name.toString());
          String pass = stringToBase64.encode(password.toString()); //--
          //--set local storage from encoded username password
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('UserName', username);
          await prefs.setString('Password', pass);
          await prefs.setInt('UserID', UserID);
          await prefs.setInt('UserGroupID', UserGroupID);
          await prefs.setInt('SessionId', SessionId); //--
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Dashboard()),
          );
        }
      }
    }
  }

  sessionAlert(alreadyLoggedUserID) {
    double passwordWidth = MediaQuery.of(context).size.width * 0.2;
    showDialog(
      context: context,
      builder: (ctx) => ElasticIn(
        child: Dialog(
          elevation: 13,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: SizedBox(
            height: 150,
            width: passwordWidth,
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
                                Icons.person_remove,
                                color: Colors.white,
                                size: 15,
                              ),
                              SizedBox(width: 10),
                              Text('Remove Session',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: IconButton(
                            hoverColor: primaryColor,
                            splashRadius: 16,
                            icon: const Icon(Icons.close_rounded,
                                color: Colors.white, size: 15),
                            onPressed: () {
                              Navigator.pop(context, false);
                            },
                          ),
                        ),
                      ],
                    )),
                const Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
                  child: Text("Do You Want Remove A Session",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: secondaryColor)),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () async {
                          Navigator.of(ctx).pop();
                        },
                        child: const Text("No",
                            style: TextStyle(color: secondaryColor)),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(90, 40),
                          maximumSize: const Size(90, 40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          primary: secondaryColor,
                        ),
                        onPressed: () {
                          removeSession(alreadyLoggedUserID);
                          Navigator.of(ctx).pop();
                        },
                        child: const Text("Yes"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  removeSession(alreadyLoggedUserID) async {
    String ip = 'http://13.235.45.82:5020/';
    String URL = 'NewCommonSelect_API/';
    final url = Uri.parse('$ip$URL');
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    };
    final json =
        '{"data": {"p1": $alreadyLoggedUserID,"p2": null,"p3": null,"p4": null,"p5": null,"p6": null,"p7": null,"p8": null,"p9": null,"p10": null,"PageIndex_int": 1,"PageSize_int": 10,"Type_varchar": "USERSESSIONREMOVE","UserGroupKey": null,"UserAccessKey": null}}';

    final response =
        await http.post(url, headers: headers, body: json.toString());

    if (response.statusCode == 400) {
      String Err = 'something went wrong!';
      toastMessageFunc(Err);
    } else {
      final datas = jsonDecode(response.body);
      successAlert();
    }
  }

  successAlert() {
    var snackBar = SnackBar(
        backgroundColor: Colors.white,
        content: Row(
          children: [
            SizedBox(
                height: 60,
                width: 100,
                child: Image.asset('assets/images/success1.gif')),
            const Text('Session Removed Successfully!',
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.w600)),
          ],
        ));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    // QuickAlert.show(
    //     context: context,
    //     type: QuickAlertType.success,
    //     customAsset: 'assets/images/success1.gif',
    //     autoCloseDuration: const Duration(seconds: 4),
    //     title: 'Successfully Session Removed',
    //     confirmBtnText: 'Okay');
  }

  @override
  Widget build(BuildContext context) {
    final logoHeight = MediaQuery.of(context).size.height * 0.15;
    final logoWidth = MediaQuery.of(context).size.width / 4.0;
    final mobileCard = MediaQuery.of(context).size.width * 0.9;
    final mobileCardHeight = MediaQuery.of(context).size.height * 0.6;

    return Responsive(
      mobile: Scaffold(
        body: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              // colorFilter: ColorFilter.mode(secondaryColor, BlendMode.color),
              image: AssetImage('assets/images/mobileLogin.png'),
              fit: BoxFit.cover,
            ),
            // color: Styles.scaffoldBackgroundColor,
            //     gradient: LinearGradient(
            //   begin: Alignment.topLeft,
            //   end: Alignment.bottomRight,
            //   colors: GradientColors.glassWater,
            // )
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: mobileCardHeight,
                width: mobileCard,
                child: Material(
                  color: Colors.transparent,
                  // shape: SuperellipseShape(
                  //     borderRadius: BorderRadius.circular(28.0)),
                  child: Column(
                    children: [
                      SizedBox(
                          width: logoWidth,
                          height: logoHeight,
                          child: Center(
                              child: Image.asset('assets/images/lognano.png'))),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: SizedBox(
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 16.0, right: 16.0),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  userName(),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  password(),
                                  forgotBtn(),
                                  const SizedBox(
                                    height: 50,
                                  ),
                                  loginBtn(),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      desktop: Scaffold(
        body: webView(),
      ),
    );
  }

  Widget webView() {
    double cardWidth = MediaQuery.of(context).size.width * 2.7;
    double cardHeight = MediaQuery.of(context).size.height * 1.20;
    double halfMediaWidth = MediaQuery.of(context).size.width / 1.6;
    double inputContainerWidth = MediaQuery.of(context).size.width * 0.3;
    double logoHeight = MediaQuery.of(context).size.height * 0.15;
    double logoWidth = MediaQuery.of(context).size.width / 4.0;
    double inputContainerHeight = MediaQuery.of(context).size.height * 0.50;
    return Container(
        color: Styles.scaffoldBackgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SizedBox(
            height: cardHeight,
            width: cardWidth,
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      height: cardHeight,
                      width: halfMediaWidth,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            bottomLeft: Radius.circular(10.0)),
                        child: FittedBox(
                          fit: BoxFit.fill,
                          child: Image.asset('assets/images/login.jpg'),
                        ),
                      )),
                  SizedBox(
                    width: inputContainerWidth,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 25),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                              width: logoWidth,
                              height: logoHeight,
                              child: Center(
                                  child: Image.asset(
                                      'assets/images/lognano.png'))),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Login',
                                style: TextStyle(
                                    color: secondaryColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600)),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(
                                left: 8.0, right: 8.0, bottom: 8.0),
                            child: Text(
                                'Welcome! Please fill username and password to login into your account',
                                overflow: TextOverflow.clip,
                                style: TextStyle(
                                    color: secondaryColor,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              // width: logoWidth,
                              height: inputContainerHeight,
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    userName(),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    password(),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    forgotBtn(),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    Align(
                                        alignment: Alignment.centerRight,
                                        child: loginBtn()),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Widget userName() {
    return TextFormField(
      // inputFormatters: [
      //   FilteringTextInputFormatter.allow(
      //     RegExp(r"[a-zA-Z]+|\s"),
      //   )
      // ],
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return "Username should not be empty";
        } else {
          return null;
        }
      },
      cursorColor: secondaryColor,
      controller: userNameController,
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
            fontWeight: FontWeight.w600,
            color: secondaryColor),
        labelStyle: const TextStyle(color: secondaryColor),
        labelText: 'User Name',
        suffixIcon: const Icon(Icons.person, color: secondaryColor),
      ),
    );
  }

  Widget password() {
    return TextFormField(
      validator: (String? value) {
        if (value != null && value.isEmpty) {
          return "Password should not be empty";
        } else {
          return null;
        }
      },
      onFieldSubmitted: (value) {
        print(value);
        if (_formKey.currentState!.validate()) {
          login(userNameController.text.toString(),
              passwordController.text.toString());
        }
      },
      cursorColor: secondaryColor,
      controller: passwordController,
      obscureText: _isObscure,
      decoration: InputDecoration(
        fillColor: Colors.blue.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        hoverColor: lightShade,
        filled: true,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        focusColor: secondaryColor,
        labelText: 'Password.',
        floatingLabelStyle: const TextStyle(
            fontSize: 14,
            height: 4,
            fontWeight: FontWeight.w600,
            color: secondaryColor),
        labelStyle: const TextStyle(color: secondaryColor),
        suffixIcon: IconButton(
          hoverColor: Colors.white,
          splashColor: Colors.white,
          icon: Icon(
            _isObscure ? Icons.visibility_off : Icons.visibility,
            color: secondaryColor,
          ),
          onPressed: () {
            setState(() {
              _isObscure = !_isObscure;
            });

            setState(() {
              _isObscure;
            });
          },
        ),
      ),
    );
  }

  Widget forgotBtn() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
          onPressed: () {},
          child: const Text('Forgot Password',
              style: TextStyle(
                  color: secondaryColor, fontWeight: FontWeight.w600))),
    );
  }

  Widget loginBtn() {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(110, 45),
        // maximumSize: const Size(110, 45),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        primary: secondaryColor,
      ),
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          login(userNameController.text.toString(),
              passwordController.text.toString());
        }
      },
      icon: const Icon(Icons.login, size: 18),
      label: const Text("Login"),
    );
  }
}
