import 'package:farmhand/constant.dart';
import 'package:farmhand/pages/extensions/loginExt.dart';
import 'package:farmhand/widgets/common_gagets.dart';
import 'package:farmhand/widgets/common_scaffold.dart';
import 'package:flutter/material.dart';

class FormLogin extends StatefulWidget {
  @override
  FormLoginState createState() => FormLoginState();
}

class FormLoginState extends State<FormLogin> {
  bool makeChangeUser = true;
  bool makeChangePass = true;
  FocusNode makeFocus;
  FocusScopeNode currentFocus;
  TextEditingController userNameCtrl = TextEditingController();
  TextEditingController passWordCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    currentFocus = FocusScope.of(context);
    var overAllPadding = 8.0;
    var commonHeight = 10.0;
    return GestureDetector(
      onTap: () {
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
          setState(() {
            if (userNameCtrl.text.isNotEmpty) {
              makeChangeUser = false;
            } else {
              makeChangeUser = true;
            }
            if (passWordCtrl.text.isNotEmpty) {
              makeChangePass = false;
            } else {
              makeChangePass = true;
            }
          });
        }
      },
      child: CommonScaffoldLogin(
        bodyin: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overscroll) {
            overscroll.disallowGlow();
            return null;
          },
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                overAllPadding * 5, 0, overAllPadding * 5, 0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: commonHeight * 5,
                  ),
                  Image.asset(
                    "assets/logo.png",
                    height: imagein * (heightin * widthin) * 1.2,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(
                    height: commonHeight * 2,
                  ),
                  Image.asset(
                    "assets/login_text.png",
                    height: imagein * (heightin * widthin) / 4,
                  ),
                  SizedBox(
                    height: commonHeight,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                          overAllPadding, 0, 0, overAllPadding + 2),
                      child: makeChangeUser ? SizedBox() : Text("Username"),
                    ),
                  ),
                  CommonTextField(
                    controllerIn: userNameCtrl,
                    focusNodeIn: makeFocus,
                    hintTextIn: makeChangeUser ? "Username" : null,
                    onTapIn: () {
                      setState(() {
                        makeChangeUser = false;
                      });
                    },
                  ),
                  SizedBox(
                    height: commonHeight,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                          overAllPadding, 0, 0, overAllPadding + 2),
                      child: makeChangePass ? SizedBox() : Text("Password"),
                    ),
                  ),
                  CommonTextField(
                    obscureTextIn: true,
                    controllerIn: passWordCtrl,
                    focusNodeIn: makeFocus,
                    hintTextIn: makeChangePass ? "Password" : null,
                    onTapIn: () {
                      setState(() {
                        makeChangePass = false;
                      });
                    },
                  ),
                  SizedBox(
                    height: commonHeight,
                  ),
                  CommonButtonIn(
                    onPressedIn: () {
                      loginUsingCredentials(
                          userNameCtrl.text.trim(), passWordCtrl.text.trim());
                    },
                    colorIn: Color(0xfff5c43d),
                    shapeBorderIn: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    childIn: Text("Login"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
