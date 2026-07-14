import 'package:country_picker/country_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:outc/loginflow/model/register_request_model.dart';
import 'package:outc/loginflow/privacypolicypage.dart';
import 'package:outc/loginflow/termsandconditionspage.dart';
import 'package:outc/widgets/colors/colors.dart';
import 'package:outc/widgets/components/toast.dart';
import 'package:outc/widgets/progressbar.dart';
import 'dart:developer';

class UserRegistration extends StatefulWidget {
  const UserRegistration({super.key});

  @override
  State<UserRegistration> createState() => _UserRegistrationState();
}

class _UserRegistrationState extends State<UserRegistration> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();

  late Registerrequest requestModelId;

  bool _passwordVisible = false;

  bool isApiCallProcess = false;
  bool valuecheck = false;
  double role = 2;

  Country selectedCountry = Country(
      phoneCode: "91",
      countryCode: "IN",
      e164Sc: 0,
      geographic: true,
      level: 1,
      name: "India",
      example: "India",
      displayName: "India",
      displayNameNoCountryCode: "IN",
      e164Key: "");

  final fullnameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    requestModelId = Registerrequest(
        Role: "2",
        FullName: "",
        Email: "",
        Mobile: "",
        DialingCode: "",
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

  void onListen() => setState(() {});

  Widget uiSetup(BuildContext context) {
    return Scaffold(
      body: (Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.lightBlue, Colours.grey],
            ),
          ),
          child: Container(
            margin: const EdgeInsets.only(right: 10, left: 10),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Center(
                    child: Container(
                      height: 150.0,
                      alignment: Alignment.topCenter,
                      child:
                          Center(child: Image.asset('images/anjmallogo.png')),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'User Registration',
                    style: GoogleFonts.poppins(
                        color: Colours.strongRed,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.none),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  signUpwithId(),
                ],
              ),
            ),
          ))),
    );
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
                controller: fullnameController,
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
                  hintText: "Enter your full name",
                  prefixIcon: Icon(
                    Icons.person,
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
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.name],
                // validator: (input) {},
                onChanged: (input) {
                  // setState(() {
                  //   requestModelId.UserName = input.toLowerCase();
                  // });
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
                  // setState(() {
                  //   requestModelId.FullName = input.toLowerCase();
                  // });
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
                  Radius.circular(10.0),
                ),
              ),
              child: TextFormField(
                controller: phoneController,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(10),
                ],

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
                  hintText: "Enter your phone number",
                  prefixIcon: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 12, 10, 15),
                    child: InkWell(
                      onTap: () {
                        showCountryPicker(
                            context: context,
                            countryListTheme: const CountryListThemeData(
                                bottomSheetHeight: 600),
                            onSelect: (value) {
                              setState(() {
                                selectedCountry = value;
                              });
                            });
                      },
                      child: Text(
                        "${selectedCountry.flagEmoji}+${selectedCountry.phoneCode}",
                      ),
                    ),
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
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.telephoneNumber],
                // validator: (input) {},
                onChanged: (input) {
                  // setState(() {
                  //   requestModelId.UserName = input.toLowerCase();
                  // });
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
                controller: passwordController,
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
                  hintText: "Enter your password",
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
            height: 20.0,
          ),
          Row(children: [
            Checkbox(
              value: valuecheck,
              side: BorderSide(color: Colors.grey.shade400, width: 1.5),
              checkColor: Colors.white,
              activeColor: valuecheck ? Colours.strongRed : Colors.grey,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3)),
              onChanged: (value) {
                setState(() {
                  valuecheck = value!;
                });
              },
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 12),
                child: RichText(
                  text: TextSpan(
                    text: 'I agree with ',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontFamily: 'poppins',
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.none,
                    ),
                    children: [
                      TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) {
                                return const TermsandConditions();
                              },
                            ));
                          },
                        text: 'Terms & conditions ',
                        style: TextStyle(
                          color: Colours.strongRed,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      const TextSpan(
                        text: ' and ',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 15),
                      ),
                      TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) {
                                return const PrivacyPolicy();
                              },
                            ));
                          },
                        text: 'Privacy Policy',
                        style: TextStyle(
                          fontSize: 15,
                          decoration: TextDecoration.none,
                          color: Colours.strongRed,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ]),
          const SizedBox(
            height: 30,
          ),
          Container(
            width: double.infinity,
            height: 48.0,
            margin: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(
                  valuecheck ? Colours.strongRed : Colours.grey,
                ),
              ),
              child: Text(
                "REGISTER",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
              onPressed: () {
                print(valuecheck);
                if (valuecheck == true) {
                  requestModelId.FullName = fullnameController.text.toString();
                  requestModelId.Password = passwordController.text.toString();
                  requestModelId.Email = emailController.text.toString();
                  requestModelId.Mobile = phoneController.text.toString();
                  requestModelId.DialingCode = selectedCountry.phoneCode;

                  print("Registration Data: $requestModelId");

                  inspect(requestModelId);
                } else {
                  const invalidsnackbar = SnackBar(
                    content: Text('Agree Terms and Conditions to Register'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(invalidsnackbar);
                }

                // setState(() {
                //   isApiCallProcess = true;
                // });
              },
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Container(
            margin: const EdgeInsets.only(right: 15, left: 15),
            child: Row(
              children: [
                Text(
                  "Already have an account ?",
                  style: TextStyle(
                    decoration: TextDecoration.none,
                    color: Colours.dardModerateBlue,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "LOGIN",
                    style: TextStyle(
                      color: Colours.strongRed,
                      decoration: TextDecoration.none,
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
