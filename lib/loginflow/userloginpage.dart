import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:outc/core/services/google_auth_service.dart';
import 'package:outc/core/services/login_crypto_service.dart';
import 'package:outc/dashboard/dashboard.dart';
import 'package:outc/loginflow/model/login_request_model.dart';
import 'package:outc/loginflow/model/login_response_model.dart';
import 'package:outc/loginflow/model/register_request_model.dart';
import 'package:outc/loginflow/userregistrationpage.dart';
import 'package:outc/services/api_services_list.dart';
import 'package:outc/services/app_constants.dart';
import 'package:outc/widgets/colors/colors.dart';
import 'package:outc/widgets/components/toast.dart';
import 'package:outc/widgets/progressbar.dart';
import 'package:outc/widgets/sharedprefservices.dart';
import 'package:page_transition/page_transition.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class UserLogin extends StatefulWidget {
  final bool isGateMode;
  const UserLogin({super.key, this.isGateMode = false});

  @override
  State<UserLogin> createState() => _UserLoginState();
}

class _UserLoginState extends State<UserLogin> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  late Loginrequestauth requestModelId;

  bool _passwordVisible = false;
  bool isApiCallProcess = false;
  bool valuetwo = false;
  double role = 2;

  final emailController = TextEditingController(
      text: kDebugMode
          ? /*"leadgen630-3@topproz.com" */ "familsd@i2space.com"
          : "");
  final _userPasswordController =
      TextEditingController(text: kDebugMode ? "agent" : "");

  @override
  void initState() {
    super.initState();
    requestModelId = Loginrequestauth(
        Role: "2",
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

  void _onLoginSuccess(Loginauth value, String password) {
    SharedPrefServices.setfirstname(value.data?.userDetails?.firstName ?? "");
    SharedPrefServices.setlastname(value.data?.userDetails?.lastName ?? "");
    SharedPrefServices.setphonenumber(value.data?.userDetails?.mobile ?? "");
    SharedPrefServices.setcustomerPwd(password);

    SharedPrefServices.setavatarfname(
        "${value.data?.userDetails?.firstName ?? ""} ${value.data?.userDetails?.lastName ?? ""}");
    SharedPrefServices.setjwtVerifiertoken(value.accessToken ?? "");
    SharedPrefServices.setcustomerId(
        value.data?.userDetails?.userId.toString() ?? "");
    SharedPrefServices.setwalletId(
        value.data?.userDetails?.walletdetails?.userWalletId.toString() ??
            "");
    SharedPrefServices.setwalletblc(
        value.data?.userDetails?.walletdetails?.amount.toString() ?? "");
    SharedPrefServices.setroleType("user");
    SharedPrefServices.setemail(value.data?.userDetails?.email ?? "");
    SharedPrefServices.setislogged("true");
    SharedPrefServices.setcurrencycode("INR");
    SharedPrefServices.setcurrencyAmount("1.00");

    if (widget.isGateMode) {
      Navigator.of(context).pop(true);
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => Dashboard(),
        ),
      );
    }
  }

  Future<void> _handleGoogleSignIn() async {
    final account = await GoogleAuthService.signIn();
    if (account == null) return; // user cancelled

    setState(() => isApiCallProcess = true);

    final googleRequest = Loginrequestauth(
      Role: "2",
      UserName: account.email,
      Password: "",
      DeviceToken: "string",
      DeviceType: "mobile",
      FirBaseToken: "string",
      isloginType: IsLoginType.google,
    );

    try {
      final value = await APIService().loginV2(googleRequest);

      if (value.status == 200 || value.status == 201) {
        setState(() => isApiCallProcess = false);
        _onLoginSuccess(value, "");
      } else if (value.status == 404 || value.status == 401) {
        // 404 = brand-new Google user. 401 "Please verify Your Mobile
        // Number" = account exists but was never verified (e.g. a prior
        // attempt registered it but crashed before verifyotp ran) — either
        // way, the response carries no UserID we can call verifyotp with
        // directly, and register() doesn't dedupe by email (confirmed: it
        // creates a fresh account every call, it doesn't return the
        // existing one). So both cases go through the same register ->
        // verify -> login path; the 401 case just leaves the earlier
        // unverified duplicate behind in the backend rather than reusing
        // it. Worth a cleanup/dedupe ask to the backend team, not fixable
        // from here.
        await _registerAndLoginWithGoogle(account);
      } else {
        setState(() => isApiCallProcess = false);
        showToast(value.message ?? "Google sign-in failed");
      }
    } catch (e) {
      setState(() => isApiCallProcess = false);
      showToast("Google sign-in failed");
    }
  }

  Future<void> _registerAndLoginWithGoogle(GoogleSignInAccount account) async {
    // Password left blank for Google registration, matching Google login's
    // own convention — the spec's registration example showed a non-blank
    // password value, which looks like a copy-paste from the standard
    // example rather than intentional; worth confirming if this 404s.
    final registerRequest = Registerrequest(
      Role: "2",
      FullName: account.displayName ?? account.email,
      Email: account.email,
      Mobile: "",
      DialingCode: "",
      Password: "",
      DeviceToken: "string",
      DeviceType: "mobile",
      FirBaseToken: "string",
      isloginType: IsLoginType.google,
    );

    final registerResponse = await APIService().register(registerRequest);
    if (!registerResponse.isSuccess || registerResponse.userId == null) {
      setState(() => isApiCallProcess = false);
      showToast(registerResponse.message ?? "Could not create your account");
      return;
    }

    final verifyResponse = await APIService().verifyOtp(
      VerifyOtpRequest(
        userId: registerResponse.userId!,
        otp: '',
        otpType: 2,
        isloginType: IsLoginType.google,
      ),
    );
    if (!verifyResponse.isSuccess) {
      setState(() => isApiCallProcess = false);
      showToast(verifyResponse.message ?? "Could not verify your account");
      return;
    }

    final loginRequest = Loginrequestauth(
      Role: "2",
      UserName: account.email,
      Password: "",
      DeviceToken: "string",
      DeviceType: "mobile",
      FirBaseToken: "string",
      isloginType: IsLoginType.google,
    );
    final value = await APIService().loginV2(loginRequest);
    setState(() => isApiCallProcess = false);

    if (value.status == 200 || value.status == 201) {
      _onLoginSuccess(value, "");
    } else {
      showToast(value.message ?? "Account created — please try signing in again");
    }
  }

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
                  hintText: "Enter Email or Phone Number",
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
                  Colours.orangeOutC,
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

                final rawPassword = _userPasswordController.text.toString();
                requestModelId.Password = LoginCryptoService.encryptPassword(
                  rawPassword,
                  AppConstant.loginSecretKey,
                );
                requestModelId.isloginType = IsLoginType.password;

                setState(() {
                  isApiCallProcess = true;
                });
                APIService apiService = APIService();
                apiService.loginV2(requestModelId).then((value) async {
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

                    showToast("Invalid Email or Phone Number. Please try again");
                  } else if (value.status == 200 || value.status == 201) {
                    _onLoginSuccess(value, rawPassword);
                  } else {
                    setState(() {
                      isApiCallProcess = false;
                    });
                  }
                });
              },
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            children: [
              const Expanded(child: Divider(color: Colors.white70)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  "Or Login/Signup With",
                  style: TextStyle(
                    color: Colours.dardModerateBlue,
                    fontSize: 12.0,
                    fontFamily: 'poppins',
                  ),
                ),
              ),
              const Expanded(child: Divider(color: Colors.white70)),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _handleGoogleSignIn,
                child: const CircleAvatar(
                  backgroundColor: Colors.white,
                  child: FaIcon(
                    FontAwesomeIcons.google,
                    color: Colors.red,
                    size: 18,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              GestureDetector(
                onTap: () => showToast("Coming soon"),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.email_outlined,
                    color: Colours.strongRed,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.rightToLeft,
                  child: const UserRegistration(),
                ),
              );
            },
            child: Text(
              "New User? Please Sign Up Here",
              style: TextStyle(
                color: Colours.dardModerateBlue,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
