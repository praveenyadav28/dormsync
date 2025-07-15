// ignore_for_file: must_be_immutable
import 'package:dorm_sync/utils/sizes.dart';
import 'package:flutter/material.dart';

Widget addMasterOutside({
  required List<Widget> children,
  required BuildContext context,
}) {
  return GridView.count(
    physics: const NeverScrollableScrollPhysics(),
    childAspectRatio:
        Sizes.width < 600
            ? Sizes.width >= 450
                ? 6
                : Sizes.width <= 450
                ? 4
                : 6
            : Sizes.width < 1100 && Sizes.width >= 600
            ? Sizes.width >= 800
                ? 3.2
                : 4
            : 4,
    shrinkWrap: true,
    crossAxisSpacing: Sizes.width * 0.04,
    mainAxisSpacing: Sizes.height * .02,
    crossAxisCount:
        Sizes.width < 600
            ? 1
            : Sizes.width < 1100 && Sizes.width >= 600
            ? Sizes.width >= 800
                ? 3
                : 2
            : 4,
    children: children,
  );
}

Widget addMasterOutside3({
  required List<Widget> children,
  required BuildContext context,
}) {
  return GridView.count(
    physics: const NeverScrollableScrollPhysics(),
    childAspectRatio:
        Sizes.width < 600
            ? Sizes.width >= 450
                ? 6
                : Sizes.width <= 450
                ? 4
                : 6
            : Sizes.width < 1100 && Sizes.width >= 600
            ? Sizes.width >= 800
                ? 3.2
                : 4
            : 4,
    shrinkWrap: true,
    crossAxisSpacing: Sizes.width * 0.04,

    mainAxisSpacing: Sizes.height * .02,
    crossAxisCount:
        Sizes.width < 600
            ? 1
            : Sizes.width < 1100 && Sizes.width >= 600
            ? Sizes.width >= 800
                ? 3
                : 2
            : 3,
    children: children,
  );
}

Widget addMasterOutside5({
  required List<Widget> children,
  required BuildContext context,
}) {
  return GridView.count(
    physics: const NeverScrollableScrollPhysics(),
    childAspectRatio:
        Sizes.width < 600
            ? Sizes.width >= 450
                ? 3.2
                : Sizes.width <= 450
                ? 2.2
                : 3.2
            : Sizes.width < 1100 && Sizes.width >= 600
            ? Sizes.width >= 800
                ? 2
                : 2.2
            : 2.2,
    shrinkWrap: true,
    crossAxisSpacing: Sizes.width * 0.04,

    mainAxisSpacing: Sizes.height * .02,
    crossAxisCount:
        Sizes.width < 600
            ? 1
            : Sizes.width < 1100 && Sizes.width >= 600
            ? Sizes.width >= 800
                ? 3
                : 2
            : 5,
    children: children,
  );
}
