import 'package:dorm_sync/utils/colors.dart';
import 'package:dorm_sync/utils/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DefaultButton extends StatelessWidget {
  const DefaultButton({
    required this.text,
    required this.hight,
    required this.width,
    required this.onTap,
    super.key,
  });

  final double hight;
  final double width;
  final Function()? onTap;
  final String text;

  @override
  Widget build(BuildContext context) {
    StyleText textstyles = StyleText();
    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setState) {
        return GestureDetector(
          onTap: onTap,
          child: Container(
            height: hight,
            width: width,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColor.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              text,
              style: textstyles.merriweatherText(
                18,
                FontWeight.w700,
                AppColor.white,
              ),
            ),
          ),
        );
      },
    );
  }
}

class CustomButton extends StatelessWidget {
  const CustomButton({
    required this.child,
    required this.hight,
    required this.width,
    required this.onTap,
    super.key,
  });

  final double hight;
  final double width;
  final Function()? onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setState) {
        return GestureDetector(
          onTap: onTap,
          child: Container(
            height: hight,
            width: width,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColor.primary,
              borderRadius: BorderRadius.circular(15),
            ),
            child: child,
          ),
        );
      },
    );
  }
}

class DateRange extends StatelessWidget {
  DateRange({super.key, required this.datepickar1, required this.datepickar2});
  TextEditingController datepickar1;
  TextEditingController datepickar2;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 14),
        decoration: BoxDecoration(
          color: Color(0xffF3F3F3),
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: Color(0xffD6D6D6),
              blurRadius: 4,
              spreadRadius: 3,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: InkWell(
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2500),
                  ).then((selectedDate) {
                    if (selectedDate != null) {
                      datepickar1.text = DateFormat(
                        'dd/MM/yyyy',
                      ).format(selectedDate);
                    }
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("From"),
                    Text(
                      "${datepickar1.text} 🗓",
                      style: TextStyle(decoration: TextDecoration.underline),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(width: 15),
            Expanded(
              child: InkWell(
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2500),
                  ).then((selectedDate) {
                    if (selectedDate != null) {
                      datepickar2.text = DateFormat(
                        'dd/MM/yyyy',
                      ).format(selectedDate);
                    }
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("To"),
                    Text(
                      "${datepickar2.text} 🗓",
                      style: TextStyle(decoration: TextDecoration.underline),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
