import 'package:dorm_sync/Components/shell.dart';
import 'package:dorm_sync/model/branches.dart';
import 'package:dorm_sync/utils/api.dart';
import 'package:dorm_sync/utils/buttons.dart';
import 'package:dorm_sync/utils/colors.dart';
import 'package:dorm_sync/utils/images.dart';
import 'package:dorm_sync/utils/navigations.dart';
import 'package:dorm_sync/utils/prefence.dart';
import 'package:dorm_sync/utils/sizes.dart';
import 'package:dorm_sync/utils/snackbar.dart';
import 'package:dorm_sync/utils/textformfield.dart';
import 'package:dorm_sync/utils/textstyle.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool saveLogin = false; // Checkbox state
  StyleText textstyles = StyleText();
  TextEditingController licenceNoController = TextEditingController();
  TextEditingController userIdController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  BranchList? _selectedBranch;
  final List<BranchList> _branchList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: Sizes.height,
        width: Sizes.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xffD3D604).withValues(alpha: .35),
              Color(0xff3AB60C).withValues(alpha: .35),
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: Sizes.width * .04),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (Sizes.width > 850)
                Container(
                  height: Sizes.height,
                  width: Sizes.width * .45,
                  color: AppColor.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Dorm',
                            style: textstyles.merriweatherText(
                              30,
                              FontWeight.w500,
                              AppColor.primary2,
                            ),
                          ),
                          Text(
                            "Sync",
                            style: textstyles.merriweatherText(
                              30,
                              FontWeight.w500,
                              AppColor.primary,
                            ),
                          ),

                          Image.asset(Images.logoadd, height: 50),
                        ],
                      ),
                      SizedBox(height: Sizes.height * .03),
                      Image.asset(Images.loginMain, height: 400),
                      SizedBox(height: Sizes.height * .03),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'From Rooms to Reports  ',
                            style: textstyles
                                .merriweatherText(
                                  20,
                                  FontWeight.w700,
                                  AppColor.primary2,
                                )
                                .copyWith(fontStyle: FontStyle.italic),
                          ),
                          Image.asset(Images.sync, height: 30),
                          Text(
                            '  All in Sync',
                            style: textstyles
                                .merriweatherText(
                                  20,
                                  FontWeight.w700,
                                  AppColor.primary,
                                )
                                .copyWith(fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

              SizedBox(
                height: Sizes.height,
                width: Sizes.width < 850 ? Sizes.width * .9 : Sizes.width * .35,
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: Sizes.height * .02,
                      horizontal: Sizes.width * .04,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        SizedBox(height: Sizes.height * .03),
                        if (Sizes.width <= 850)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Dorm',
                                style: textstyles.merriweatherText(
                                  25,
                                  FontWeight.w500,
                                  AppColor.primary2,
                                ),
                              ),
                              Text(
                                "Sync",
                                style: textstyles.merriweatherText(
                                  25,
                                  FontWeight.w500,
                                  AppColor.primary,
                                ),
                              ),

                              Image.asset(Images.logoadd, height: 35),
                            ],
                          ),
                        SizedBox(height: Sizes.height * 0.06),
                        CommonTextField(
                          controller: licenceNoController,
                          image: Images.location,
                          hintText: "License Number",
                          suffixIcon: IconButton(
                            onPressed: () {
                              getBranchList().then((value) {
                                setState(() {});
                              });
                            },
                            icon: Icon(Icons.search),
                          ),
                        ),
                        SizedBox(height: Sizes.height * 0.03),
                        Row(
                          children: [
                            Image.asset(Images.town, height: 30),
                            SizedBox(width: 5),
                            Expanded(
                              child: DropdownButtonFormField<BranchList>(
                                value: _selectedBranch,
                                icon: Icon(
                                  Icons.keyboard_arrow_down,
                                  color: AppColor.primary,
                                ),
                                hint: Text(
                                  "--Select Branch--",
                                  style: TextStyle(
                                    color: AppColor.black81,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedBranch = value;
                                  });
                                },
                                items:
                                    _branchList.map((branch) {
                                      return DropdownMenuItem(
                                        value: branch,
                                        child: Text(
                                          branch.branchName ?? "",
                                          style: TextStyle(
                                            color: AppColor.black,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                decoration: InputDecoration(
                                  isDense: true,
                                  border: UnderlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 10,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: Sizes.height * 0.03),
                        CommonTextField(
                          controller: userIdController,
                          image: Images.user,
                          hintText: "User Id",
                        ),
                        SizedBox(height: Sizes.height * 0.03),
                        CommonTextField(
                          controller: passwordController,
                          image: Images.lock,
                          hintText: "Password",
                        ),
                        SizedBox(height: Sizes.height * 0.03),
                        Row(
                          children: [
                            SizedBox(width: 42),
                            Checkbox(
                              activeColor: AppColor.primary,
                              value: saveLogin,
                              side: BorderSide(color: AppColor.primary),
                              onChanged: (bool? value) {
                                setState(() {
                                  saveLogin = value!;
                                });
                              },
                            ),
                            Text(
                              "Remember me",
                              style: textstyles.merriweatherText(
                                15,
                                FontWeight.w600,
                                AppColor.lightblack,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: Sizes.height * 0.03),
                        DefaultButton(
                          onTap: () {
                            postLogin();
                            // pushTo(Shell());
                          },
                          hight: 50,
                          width: Sizes.width < 850 ? Sizes.width * .5 : 200,
                          text: 'Sign In',
                        ),
                        SizedBox(height: Sizes.height * 0.05),
                        Text(
                          "By Modern Software Technologies Pvt Ltd.",
                          textAlign: TextAlign.center,
                          style: textstyles.abhayaLibreText(
                            Sizes.width > 850 ? 19 : 17,
                            FontWeight.w800,
                            AppColor.lightblack,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future getBranchList() async {
    var response = await ApiService.fetchData(
      "branch?licence_no=${licenceNoController.text.trim()}",
    );
    if (response['status'] == true && response['branches'] != null) {
      final branches = response['branches'] as List;
      _branchList.clear();
      _selectedBranch = null;
      _branchList.addAll(branches.map((b) => BranchList.fromJson(b)));
      showCustomSnackbarSuccess(context, "Branch fetched successfully");
    } else {
      showCustomSnackbarError(context, "Unable to find branch");
    }
  }

  Future postLogin() async {
    var response = await ApiService.postData('tenant/login', {
      'licence_no': licenceNoController.text.trim().toString(),
      'branch_id': _selectedBranch?.id,
      'username': userIdController.text.trim().toString(),
      'password': passwordController.text.trim().toString(),
    });
    if (response["status"] == true) {
      Preference.setBool(PrefKeys.userstatus, saveLogin);
      Preference.setString(PrefKeys.token, response['token']);
      Preference.setString(
        PrefKeys.licenseNo,
        licenceNoController.text.trim().toString(),
      );
      Preference.setString(
        PrefKeys.coludIdHostel,
        response['branch']['other2'] ?? "",
      );
      Preference.setString(
        PrefKeys.coludIdMess,
        response['branch']['other1'] ?? "",
      );
      Preference.setInt(PrefKeys.locationId, response['user']['branch_id']);
      Preference.setInt(PrefKeys.branchLength, _branchList.length);
      showCustomSnackbarSuccess(context, response['message']);
      await fetchAndSaveActiveSessionId();
      pushNdRemove(Shell());
    } else {
      showCustomSnackbarError(context, response['message']);
    }
  }

  Future<void> fetchAndSaveActiveSessionId() async {
    var response = await ApiService.fetchData(
      "session?licence_no=${Preference.getString(PrefKeys.licenseNo)}&branch_id=${_selectedBranch!.id}",
    );
    if (response["status"] == true) {
      List sessions = response['data'];
      for (var session in sessions) {
        if (session['is_active'] == 1) {
          await Preference.setInt(PrefKeys.sessionId, session['id']);
          await Preference.setString(
            PrefKeys.sessionDate,
            "${session['session_start_date']} - ${session['session_end_date']}",
          );
          break;
        }
      }
    }
  }
}
