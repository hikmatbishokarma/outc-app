import 'package:avatars/avatars.dart';
import 'package:flutter/material.dart';
import 'package:outc/dashboard/dashboard.dart';
import 'package:outc/loginflow/multiloginpage.dart';
import 'package:outc/partnerSidemenu/models/password_update_model.dart';
import 'package:outc/services/api_services_list.dart';
import 'package:outc/sidemenu/sidemenu.dart';
import 'package:outc/widgets/colors/colors.dart';
import 'package:outc/widgets/progressbar.dart';
import 'package:outc/widgets/sharedprefservices.dart';
import 'package:page_transition/page_transition.dart';

class Changepasswordprofile extends StatefulWidget {
  const Changepasswordprofile({super.key});

  @override
  _Changepasswordprofile createState() => _Changepasswordprofile();
}

class _Changepasswordprofile extends State<Changepasswordprofile> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();

  final _oldpasswordcontroller = TextEditingController();
  final _passwprdonecontroller = TextEditingController();
  final _passwprdtwocontroller = TextEditingController();

  bool _passwordVisibleone = false;
  bool _passwordVisibletwo = false;
  bool isApiCallProcess = false;
  String validoldpwd = "";

  late Passwordupdaterequestmodel requestmodel;

  @override
  void initState() {
    super.initState();
    requestmodel = Passwordupdaterequestmodel(
      newPassword: '',
      oldPassword: '',
    );

    setState(() {
      if (_oldpasswordcontroller.text.isEmpty) {
        validoldpwd = "";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ProgressBar(
      inAsyncCall: isApiCallProcess,
      opacity: 0.3,
      child: uiSetup(context),
    );
  }

  Widget uiSetup(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: false,
      drawer: const SideMenu(),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "AnjMal",
          style: TextStyle(
            fontSize: 22.0,
            fontFamily: 'poppins',
            color: Colours.strongRed,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.grey,
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: Avatar(
            backgroundColor: Colours.strongRed,
            placeholderColors: [Colours.strongRed],
            useCache: true,

            onTap: () {
              scaffoldKey.currentState!.openDrawer();
            },
            name: SharedPrefServices.getfirstname()!.toUpperCase(),
            textStyle: const TextStyle(
              fontSize: 15.0,
              fontFamily: 'poppins',
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
            // Fallback if no image source is available
          ),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: IconButton(
              color: Colours.strongRed,
              icon: Icon(
                Icons.wallet,
                size: 28,
                color: Colours.strongRed,
              ),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: SizedBox(
                          height: 74,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              const Text(
                                "My Wallet Balance",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black,
                                  fontFamily: 'Poppins',
                                  // fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "INR ${SharedPrefServices.getwalletblc()}",
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colours.strongRed,
                                  fontFamily: 'Poppins',
                                  // fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              },
            ),
          ),
          IconButton(
            color: Colours.strongRed,
            icon: const ImageIcon(
              AssetImage(
                "images/notifybell.png",
              ),
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          getheadercontainer(),
          const SizedBox(
            height: 15.0,
          ),
          Container(
            alignment: Alignment.center,
            width: double.infinity,
            margin: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: Wrap(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      const SizedBox(height: 20.0),
                      Card(
                        margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(15.0),
                            ),
                          ),
                          child: TextFormField(
                            style: const TextStyle(
                              fontSize: 14.0,
                              color: Colors.black,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                            ),
                            controller: _oldpasswordcontroller,
                            // obscureText: !_passwordVisibleold,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(10.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: const BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                              focusedBorder: InputBorder.none,
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.white,
                                ),
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              hintText: "Old Password",
                              suffixIcon: validoldpwd == "true"
                                  ? const Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                    )
                                  : validoldpwd == "false"
                                      ? const Icon(
                                          Icons.cancel_rounded,
                                          color: Colors.red,
                                        )
                                      : null,
                              hintStyle: const TextStyle(
                                fontSize: 14.0,
                                color: Color(0xB3979797),
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            keyboardType: TextInputType.name,
                            maxLines: 1,
                            validator: (input) => input!.length <= 5
                                ? "Atleast six charecters"
                                : null,
                            onChanged: (input) {
                              if (_oldpasswordcontroller.text
                                      .trim()
                                      .toString() ==
                                  SharedPrefServices.getcustomerPwd()
                                      .toString()) {
                                setState(() {
                                  validoldpwd = "true";
                                });
                              } else {
                                setState(() {
                                  validoldpwd = "false";
                                });
                              }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Card(
                        margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(15.0),
                            ),
                          ),
                          child: TextFormField(
                            style: const TextStyle(
                              fontSize: 14.0,
                              color: Colors.black,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                            ),
                            controller: _passwprdonecontroller,
                            obscureText: !_passwordVisibleone,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(10.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: const BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                              focusedBorder: InputBorder.none,
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.white,
                                ),
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              hintText: "New Password",
                              // prefixIcon: Icon(
                              //   Icons.lock_outline,
                              //   color: Colors.black,
                              // ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  // Based on passwordVisible state choose the icon
                                  _passwordVisibleone
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.black,
                                ),
                                onPressed: () {
                                  // Update the state i.e. toogle the state of passwordVisible variable
                                  setState(() {
                                    _passwordVisibleone = !_passwordVisibleone;
                                  });
                                },
                              ),
                              hintStyle: const TextStyle(
                                fontSize: 14.0,
                                color: Color(0xB3979797),
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            keyboardType: TextInputType.name,
                            maxLines: 1,
                            validator: (input) => input!.length <= 5
                                ? "Atleast six charecters"
                                : null,
                            // todo
                            // onSaved: (input) =>
                            //     SharedPrefServices.setpasswordone(input!),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Card(
                        margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(15.0),
                            ),
                          ),
                          child: TextFormField(
                            style: const TextStyle(
                              fontSize: 14.0,
                              color: Colors.black,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                            ),
                            controller: _passwprdtwocontroller,
                            obscureText: !_passwordVisibletwo,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(10.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: const BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                              focusedBorder: InputBorder.none,
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.white,
                                ),
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              hintText: "Verify Password",
                              // prefixIcon: Icon(
                              //   Icons.lock_outline,
                              //   color: Colors.black,
                              // ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  // Based on passwordVisible state choose the icon
                                  _passwordVisibletwo
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.black,
                                ),
                                onPressed: () {
                                  // Update the state i.e. toogle the state of passwordVisible variable
                                  setState(() {
                                    _passwordVisibletwo = !_passwordVisibletwo;
                                  });
                                },
                              ),
                              hintStyle: const TextStyle(
                                fontSize: 14.0,
                                color: Color(0xB3979797),
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            keyboardType: TextInputType.name,
                            maxLines: 1,
                            validator: (input) =>
                                input == _passwprdonecontroller.text
                                    ? "Atleast six charecters"
                                    : null,
                          ),
                        ),
                      ),
                      const SizedBox(height: 100.0),
                      Container(
                        width: double.infinity,
                        height: 48.0,
                        margin: const EdgeInsets.only(left: 37.0, right: 37.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: Colours.strongRed,
                          ),
                          child: const Text(
                            "CHANGE PASSWORD",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () async {
                            if (_oldpasswordcontroller.text.toString() ==
                                SharedPrefServices.getcustomerPwd()) {
                              if (_passwprdonecontroller.text
                                      .toString()
                                      .trim() ==
                                  _passwprdtwocontroller.text
                                      .toString()
                                      .trim()) {
                                setState(() {
                                  isApiCallProcess = true;

                                  requestmodel.oldPassword =
                                      SharedPrefServices.getcustomerPwd()
                                          .toString();
                                  requestmodel.newPassword =
                                      _passwprdonecontroller.text
                                          .toString()
                                          .trim();
                                });
                                // inspect(requestmodel);
                                updatepassword();
                              } else {
                                setState(() {
                                  isApiCallProcess = false;
                                });
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                            title: const Text(
                                              'New Password and Verify Password mismatch. Please try again.',
                                              style: TextStyle(
                                                fontSize: 15.0,
                                                color: Colors.black,
                                                fontFamily: 'Poppins',
                                              ),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context, false);
                                                },
                                                child: Text(
                                                  'OK',
                                                  style: TextStyle(
                                                    fontSize: 15.0,
                                                    color: Colours.strongRed,
                                                    fontFamily: 'Poppins',
                                                  ),
                                                ),
                                              ),
                                              // TextButton(
                                              //   onPressed: () {
                                              //     Navigator.pop(context, true);
                                              //   },
                                              //   child: const Text('Yes'),
                                              // ),
                                            ]));
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'New Password and Verify Password mismatch. Please try again!')));
                              }
                            } else {
                              setState(() {
                                isApiCallProcess = false;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Old Password is not matching! Please try again')));
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 30.0),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool validateAndSave() {
    final form = globalFormKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void updatepassword() {
    APIService apiService = APIService();
    apiService.updatePartnerPassword(requestmodel).then((value) async {
      setState(() {
        // isApiCallProcess = false;
      });
      if (value.status == 400) {
        setState(() {
          isApiCallProcess = false;
        });
        const invalidsnackbar = SnackBar(
          content: Text('Error. Please try again later'),
        );
        ScaffoldMessenger.of(context).showSnackBar(invalidsnackbar);
      } else if (value.status == 200) {
        setState(() {
          isApiCallProcess = false;
        });
        const snackbar = SnackBar(
          content: Text('Password Updated Successfully'),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackbar);

        SharedPrefServices.clearUserFromSharedPrefs();

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => const MultiLoginScreen(),
          ),
          (route) => false,
        );
      }
    });
  }

  getheadercontainer() {
    return Container(
      margin: const EdgeInsets.only(left: 10.0, right: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.arrow_back_ios_new_outlined,
                color: Color(0xff393939),
                size: 20,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.leftToRight,
                  child: Dashboard(),
                ),
              );
            },
          ),
          const Text(
            "Change Password",
            style: TextStyle(
              fontFamily: 'poppins',
              fontSize: 16.0,
              color: Colors.black,
            ),
          ),
          const Icon(
            Icons.abc,
            color: Colors.transparent,
          )
        ],
      ),
    );
  }
}
