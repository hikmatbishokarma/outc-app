import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:outc/core/theme/design_tokens.dart';
import 'package:outc/dashboard/dashboard.dart';
import 'package:outc/loginflow/model/login_request_model.dart';
import 'package:outc/services/api_services_list.dart';
import 'package:outc/widgets/components/toast.dart';
import 'package:outc/widgets/progressbar.dart';
import 'package:outc/widgets/sharedprefservices.dart';

class AgentLogin extends StatefulWidget {
  final bool isGateMode;
  const AgentLogin({super.key, this.isGateMode = false});

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

  InputDecoration _fieldDecoration({
    required String hint,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      filled: true,
      fillColor: AppColors.subtleBackground,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: const BorderSide(color: AppColors.secondary, width: 1.5),
      ),
      hintText: hint,
      prefixIcon: Icon(icon, color: AppColors.secondary, size: 20),
      suffixIcon: suffixIcon,
      hintStyle: const TextStyle(fontSize: 14.0, color: AppColors.hintText),
    );
  }

  Widget signUpwithId() {
    return Form(
      key: globalFormKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          TextFormField(
            controller: emailController,
            decoration: _fieldDecoration(
              hint: "Enter your email address",
              icon: Icons.email_outlined,
            ),
            style: const TextStyle(fontSize: 14.0, color: AppColors.textPrimary),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.email],
            onChanged: (input) {
              setState(() {
                requestModelId.UserName = input.toLowerCase();
              });
            },
          ),
          const SizedBox(height: 14.0),
          TextFormField(
            style: const TextStyle(fontSize: 14.0, color: AppColors.textPrimary),
            controller: _userPasswordController,
            obscureText: !_passwordVisible,
            decoration: _fieldDecoration(
              hint: "Password",
              icon: Icons.lock_outline,
              suffixIcon: IconButton(
                icon: Icon(
                  _passwordVisible ? Icons.visibility : Icons.visibility_off,
                  color: _passwordVisible ? AppColors.secondary : AppColors.surfaceGrey,
                ),
                onPressed: () {
                  setState(() {
                    _passwordVisible = !_passwordVisible;
                  });
                },
              ),
            ),
            maxLines: 1,
            onSaved: (input) => requestModelId.Password = input!,
          ),
          const SizedBox(
            height: 4.0,
          ),
          Container(
            margin: const EdgeInsets.only(top: 8.0, bottom: 18.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Checkbox(
                        value: valuetwo,
                        checkColor: Colors.white,
                        activeColor: AppColors.primary,
                        shape: const CircleBorder(),
                        onChanged: (value) {
                          setState(() {
                            valuetwo = value!;
                          });
                        }),
                    const Text(
                      "Remember me",
                      style: TextStyle(
                        fontSize: 13.0,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {},
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(
                        fontSize: 13.0,
                        color: AppColors.secondary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: 48.0,
            child: ElevatedButton(
              style: ButtonStyle(
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                ),
                backgroundColor: WidgetStateProperty.all<Color>(
                  AppColors.primary,
                ),
              ),
              child: const Text(
                "LOGIN",
                style: TextStyle(
                  color: Colors.white,
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

                    if (widget.isGateMode) {
                      Navigator.of(context).pop(true);
                    } else {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return Dashboard();
                          },
                        ),
                      );
                    }
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
