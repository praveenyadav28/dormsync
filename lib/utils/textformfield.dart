import 'package:dorm_sync/utils/colors.dart';
import 'package:flutter/material.dart';

class CommonTextField extends StatelessWidget {
  CommonTextField({
    required this.image,
    this.hintText,
    this.controller,
    this.onChanged,
    this.onPressIcon,
    this.onTap,
    this.readOnly,
    this.focuesNode,
    this.suffixIcon,
    super.key,
  });
  String image;
  String? hintText;
  TextEditingController? controller;
  bool? readOnly;
  void Function(String)? onChanged;
  void Function()? onPressIcon;
  void Function()? onTap;
  FocusNode? focuesNode;
  Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(onTap: onPressIcon, child: Image.asset(image, height: 30)),
        SizedBox(width: 5),
        Expanded(
          child: TextFormField(
            focusNode: focuesNode,
            controller: controller,
            onChanged: onChanged,
            onTap: onTap,
            readOnly: readOnly ?? false,
            style: TextStyle(
              color: AppColor.black,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              isDense: true,
              border: UnderlineInputBorder(),
              hintText: hintText ?? "",
              suffixIcon: suffixIcon,
              hintStyle: TextStyle(
                color: AppColor.black.withValues(alpha: .81),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CommonTextFieldBorder extends StatelessWidget {
  CommonTextFieldBorder({
    required this.image,
    this.hintText,
    this.controller,
    this.readOnly,
    this.onTap,
    this.onChanged,
    this.onPressIcon,
    this.focuesNode,
    super.key,
  });
  String image;
  String? hintText;

  void Function(String)? onChanged;
  TextEditingController? controller;
  bool? readOnly;
  void Function()? onTap;
  void Function()? onPressIcon;

  FocusNode? focuesNode;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(onTap: onPressIcon, child: Image.asset(image, height: 35)),
        SizedBox(width: 5),
        Expanded(
          child: TextFormField(
            focusNode: focuesNode,
            controller: controller,
            onTap: onTap,
            readOnly: readOnly ?? false,
            style: TextStyle(
              color: AppColor.black,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            onChanged: onChanged,
            decoration: InputDecoration(
              isDense: true,

              fillColor: AppColor.white,
              filled: readOnly == true ? false : true,
              border: OutlineInputBorder(),
              hintText: hintText ?? "",
              hintStyle: TextStyle(
                color: AppColor.black81,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class TitleTextField extends StatelessWidget {
  TitleTextField({
    required this.image,
    this.titileText,
    this.hintText,
    this.controller,
    super.key,
    this.onTap,
    this.onPressIcon,
    this.onChanged,
    this.onSaved,
    this.readOnly,
  });
  var image;
  String? titileText;
  String? hintText;
  TextEditingController? controller;
  void Function()? onTap;
  void Function()? onPressIcon;
  void Function(String)? onChanged;
  void Function(String?)? onSaved;
  bool? readOnly;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          titileText ?? "",
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 7),
        Row(
          children: [
            image == null
                ? SizedBox(width: 0)
                : InkWell(
                  onTap: onPressIcon,
                  child: Image.asset(image, height: 26),
                ),
            SizedBox(width: image == null ? 0 : 5),
            Expanded(
              child: TextFormField(
                onFieldSubmitted: onSaved,
                onTap: onTap,
                readOnly: readOnly ?? false,
                onChanged: onChanged,
                controller: controller,
                style: TextStyle(
                  color: AppColor.black,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  isDense: true,
                  filled: true,
                  fillColor:
                      readOnly == true ? AppColor.transparent : AppColor.white,
                  border: OutlineInputBorder(),
                  hintText: hintText ?? "",
                  hintStyle: TextStyle(
                    color: AppColor.black81,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
