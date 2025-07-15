// ignore_for_file: library_private_types_in_public_api

import 'dart:async';

import 'package:dorm_sync/Components/shell.dart';
import 'package:dorm_sync/ui/onboarding/login.dart';
import 'package:dorm_sync/utils/colors.dart';
import 'package:dorm_sync/utils/images.dart';
import 'package:dorm_sync/utils/navigations.dart';
import 'package:dorm_sync/utils/prefence.dart';
import 'package:dorm_sync/utils/sizes.dart';
import 'package:dorm_sync/utils/textstyle.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  StyleText textstyles = StyleText();

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      Preference.getBool(PrefKeys.userstatus) == false
          ? pushNdRemove(const LoginScreen())
          : pushNdRemove(const Shell());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: Sizes.height,
        width: Sizes.width,
        alignment: Alignment.center,
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(Images.loginMain, height: Sizes.height * .2),
            ),

            SizedBox(height: Sizes.height * 0.02),
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
          ],
        ),
      ),
    );
  }
}
