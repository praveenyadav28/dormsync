import 'package:dorm_sync/utils/colors.dart';
import 'package:dorm_sync/utils/sizes.dart';
import 'package:flutter/material.dart';

class ButtonContainer extends StatelessWidget {
  ButtonContainer({required this.image, required this.text, super.key});
  String image;
  String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: Sizes.height * .02),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColor.primary2,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 2),
            blurRadius: 2,
            spreadRadius: 3,
            color: AppColor.grey,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            maxRadius: 16,
            backgroundColor: AppColor.white,
            child: Image.asset(image, height: 24),
          ),
          Text(
            "  $text  ",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: AppColor.black,
            ),
          ),
        ],
      ),
    );
  }
}
