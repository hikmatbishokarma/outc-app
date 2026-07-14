import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:outc/dashboard/dashboard.dart';
import 'package:outc/loginflow/model/login_request_model.dart';
import 'package:outc/services/api_services_list.dart';
import 'package:outc/widgets/colors/colors.dart';
import 'package:outc/widgets/components/toast.dart';
import 'package:outc/widgets/progressbar.dart';
import 'package:outc/widgets/sharedprefservices.dart';

class AgentLogin extends StatefulWidget {
  const AgentLogin({super.key});

  @override
  State<AgentLogin> createState() => _AgentLoginState();
}

class _AgentLoginState extends State<AgentLogin> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  late Loginrequestauth requestModelId;

  bool _passwordVisible = false;
  bool isApiCallProcess = false;
  bool valuetwo = false;
  double role = 2;

  final emailController = TextEditingController(
      text: kDebugMode ? /*"leadgen630-3@topproz.com" */ "jj@i2space.com" : "");
  final _userPasswordController =
      TextEditingController(text: kDebugMode ? "agent" : "");

  @override
  void initState() {
    super.initState();
    requestModelId = Loginrequestauth(
        Role: "5",
        UserName: "",
        Password: "",
        DeviceToken: "string",
        DeviceType: "mobile",
        FirBaseToken: "string");
  }

  @override
  Widget build(BuildContext context) {
    return ProgressBar(
      inAsyncCall: isApiCallProcess,
      opacity: 0.3,
      child: uiSetup(context),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    _userPasswordController.dispose();

    emailController.removeListener(onListen);

    super.dispose();
  }

  void onListen() => setState(() {});

  Widget uiSetup(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          margin: const EdgeInsets.only(right: 10, left: 10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 40,
                ),
                signUpwithId(),
              ],
            ),
          ),
        ));
  }

  Widget signUpwithId() {
    return Form(
      key: globalFormKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          Card(
            margin: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
              child: TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(10.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                      color: Colors.white,
                    ),
                  ),
                  focusedBorder: InputBorder.none,
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  hintText: "Enter your email address",
                  prefixIcon: Icon(
                    Icons.email_outlined,
                    color: Colours.strongRed,
                  ),
                  hintStyle: const TextStyle(
                    fontSize: 15.0,
                    color: Color(0xB3979797),
                    // fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                style: const TextStyle(
                  fontSize: 15.0,
                  color: Colors.black,
                  // fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                ),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.email],
                // validator: (input) {},
                onChanged: (input) {
                  setState(() {
                    requestModelId.UserName = input.toLowerCase();
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 15.0),
          Card(
            margin: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0),
                ),
              ),
              child: TextFormField(
                style: const TextStyle(
                  fontSize: 15.0,
                  color: Colors.black,
                  // fontFamily: 'Poppins',
                ),
                controller: _userPasswordController,
                obscureText: !_passwordVisible,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(10.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: const BorderSide(
                      color: Colors.white,
                    ),
                  ),
                  focusedBorder: InputBorder.none,
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  hintText: "Password",
                  prefixIcon: Icon(
                    Icons.lock_outline,
                    color: Colours.strongRed,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      // Based on passwordVisible state choose the icon
                      _passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: _passwordVisible
                          ? Colours.strongRed
                          : const Color(0xff979797),
                    ),
                    onPressed: () {
                      // Update the state i.e. toogle the state of passwordVisible variable
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  ),
                  hintStyle: const TextStyle(
                    fontSize: 15.0,
                    color: Color(0xB3979797),
                    // fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                maxLines: 1,
                onSaved: (input) => requestModelId.Password = input!,
              ),
            ),
          ),
          const SizedBox(
            height: 8.0,
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Checkbox(
                        value: valuetwo,
                        checkColor: Colors.white,
                        activeColor: Colours.strongRed,
                        shape: const CircleBorder(),
                        onChanged: (value) {
                          setState(() {
                            valuetwo = value!;
                          });

                          // print('checkboxvaluefrom shared: $valuetwo');
                        }),
                    Text(
                      "Remember me",
                      style: TextStyle(
                        fontSize: 14.0,
                        // decoration: TextDecoration.underline,
                        color: Colours.strongRed,
                        // fontFamily: 'Poppins',
                      ),
                      maxLines: 2,
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colours.dardModerateBlue,
                        // fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            height: 48.0,
            margin: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(
                  Colours.buttonColor,
                ),
              ),
              child: const Text(
                "LOGIN",
                style: TextStyle(
                  color: Colors.white,
                  // fontFamily: 'Poppins',
                  fontWeight: FontWeight.w800,
                ),
              ),
              onPressed: () {
                requestModelId.UserName = emailController.text.toString();

                requestModelId.Password =
                    _userPasswordController.text.toString();

                setState(() {
                  isApiCallProcess = true;
                });
                APIService apiService = APIService();
                apiService.partnerLoginauth(requestModelId).then((value) async {
                  print(requestModelId);
                  inspect(requestModelId);

                  if (value.status == 203) {
                    setState(() {
                      isApiCallProcess = false;
                    });
                  } else if (value.status == 401) {
                    setState(() {
                      isApiCallProcess = false;
                    });

                    showToast("Please Enter valid email or password");
                  } else if (value.status == 400) {
                    setState(() {
                      isApiCallProcess = false;
                    });

                    showToast("Invalid Password. Please try again");
                  } else if (value.status == 404) {
                    setState(() {
                      isApiCallProcess = false;
                    });

                    showToast("Invalid Email. Please try again");
                  } else if (value.status == 200 || value.status == 201) {
                    // print("login url is working perfect uday");

                    SharedPrefServices.setfirstname(
                        value.data?.userDetails?.firstName ?? "");
                    SharedPrefServices.setlastname(
                        value.data?.userDetails?.lastName ?? "");
                    SharedPrefServices.setphonenumber(
                        value.data?.userDetails?.mobile ?? "");
                    SharedPrefServices.setcustomerPwd(requestModelId.Password);

                    SharedPrefServices.setavatarfname(
                        "${value.data?.userDetails?.firstName ?? ""} ${value.data?.userDetails?.lastName ?? ""}");
                    SharedPrefServices.setjwtVerifiertoken(
                        value.accessToken ?? "");
                    SharedPrefServices.setcustomerId(
                        value.data?.userDetails?.userId.toString() ?? "");
                    SharedPrefServices.setwalletId(value
                            .data?.userDetails?.walletdetails?.agentWalletId
                            .toString() ??
                        "");

                    SharedPrefServices.setwalletblc(value
                            .data?.userDetails?.walletdetails?.amount
                            .toString() ??
                        "");
                    SharedPrefServices.setroleType("agent");

                    SharedPrefServices.setemail(
                        value.data?.userDetails?.email ?? "");
                    SharedPrefServices.setislogged("true");

                    SharedPrefServices.setcurrencycode("INR");
                    SharedPrefServices.setcurrencyAmount("1.00");

                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return Dashboard();
                        },
                      ),
                    );
                  } else {
                    setState(() {
                      isApiCallProcess = false;
                    });
                  }
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
