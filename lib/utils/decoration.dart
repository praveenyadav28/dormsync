import 'package:dorm_sync/utils/colors.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';

insideShadow() {
  return BoxDecoration(
    color: Color(0xffEEEEEE),
    border: Border.all(color: AppColor.background),
    boxShadow: [
      BoxShadow(
        offset: const Offset(2, 2),
        blurRadius: 4,
        color: AppColor.black.withValues(alpha: 0.3),
        inset: true,
      ),
    ],
    borderRadius: BorderRadius.circular(4),
  );
}
