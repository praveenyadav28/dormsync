import 'dart:convert';

import 'package:dorm_sync/model/admission.dart';
import 'package:dorm_sync/model/fees.dart';
import 'package:dorm_sync/ui/home/room/room_utils.dart';
import 'package:dorm_sync/utils/api.dart';
import 'package:dorm_sync/utils/buttons.dart';
import 'package:dorm_sync/utils/colors.dart';
import 'package:dorm_sync/utils/field_cover.dart';
import 'package:dorm_sync/utils/images.dart';
import 'package:dorm_sync/utils/prefence.dart';
import 'package:dorm_sync/utils/sizes.dart';
import 'package:dorm_sync/utils/snackbar.dart';
import 'package:dorm_sync/utils/textformfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MeterReadingAdd extends StatefulWidget {
  const MeterReadingAdd({super.key});

  @override
  State<MeterReadingAdd> createState() => _MeterReadingAddState();
}

class _MeterReadingAddState extends State<MeterReadingAdd> {
  List<Map<String, dynamic>> buildings = [];
  List<Map<String, dynamic>> floors = [];
  List<Map<String, dynamic>> rooms = [];

  int? selectedBuildingId;
  int? selectedFloorId;
  String? selectedRoomType;
  int? selectedRoomId;
  String? selectedRoomNumber;
  int? selectedRoomBeds;
  int? selectedRoomOccupacy;

  List<Map<String, dynamic>> filteredFloors = [];
  List<Map<String, dynamic>> filteredRooms = [];

  FeesList? feesData;

  final TextEditingController _openingReadingController =
      TextEditingController();
  final TextEditingController _closingReadingController =
      TextEditingController();
  final TextEditingController _pricePerUnitController = TextEditingController();
  final TextEditingController _totalAmtController = TextEditingController();

  List<AdmissionList> studentList = [];
  List<AdmissionList> studentListInRoom = [];
  Map<String, TextEditingController> studentFeeControllers = {};

  /// 🧮 Calculate Total and divide among students
  void calculateTotalAmount() {
    final opening = double.tryParse(_openingReadingController.text) ?? 0;
    final closing = double.tryParse(_closingReadingController.text) ?? 0;
    final price = double.tryParse(_pricePerUnitController.text) ?? 0;

    final total = (closing - opening) * price;
    _totalAmtController.text = total.toStringAsFixed(2);

    if (studentListInRoom.isNotEmpty) {
      final share = total / studentListInRoom.length;
      for (var s in studentListInRoom) {
        studentFeeControllers[s.studentId]?.text = share.toStringAsFixed(2);
      }
    }
  }

  @override
  void initState() {
    _pricePerUnitController.text = Preference.getString(PrefKeys.unitPrice);
    getBuildings();
    getFloors();
    getRooms();

    Future.delayed(Duration.zero, () {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && feesData == null) {
        feesData = args as FeesList;

        _totalAmtController.text = feesData!.totalAmount ?? "";
      }
    });
    getHostlers().then((value) {
      setState(() {});
    });

    super.initState();
  }

  Future<void> getBuildings() async {
    final response = await ApiService.fetchData(
      'building?licence_no=${Preference.getString(PrefKeys.licenseNo)}&branch_id=${Preference.getint(PrefKeys.locationId)}',
    );
    if (response["status"] == true) {
      setState(() {
        buildings = List<Map<String, dynamic>>.from(response["data"]);
      });
    }
  }

  Future<void> getFloors() async {
    final response = await ApiService.fetchData(
      'floor?licence_no=${Preference.getString(PrefKeys.licenseNo)}&branch_id=${Preference.getint(PrefKeys.locationId)}',
    );
    if (response["status"] == true) {
      setState(() {
        floors = List<Map<String, dynamic>>.from(response["data"]);
      });
    }
  }

  Future<void> getRooms() async {
    final response = await ApiService.fetchData(
      'room?licence_no=${Preference.getString(PrefKeys.licenseNo)}&branch_id=${Preference.getint(PrefKeys.locationId)}',
    );
    if (response["status"] == true) {
      setState(() {
        rooms = List<Map<String, dynamic>>.from(response["data"]);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: Sizes.width * .02,
          right: Sizes.width * .02,
          bottom: Sizes.height * .05,
          top: Sizes.height * .01,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: Sizes.height * .04),
              height: 40,
              decoration: BoxDecoration(
                color: AppColor.primary,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  SizedBox(width: 30),
                  Text(
                    "Meter Reading Entry",
                    style: TextStyle(
                      color: AppColor.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Row(
                      children: [
                        Text(
                          "Back to List  ",
                          style: TextStyle(
                            color: AppColor.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Image.asset(Images.back),
                        SizedBox(width: 30),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Room Details  ',
                  style: TextStyle(
                    color: AppColor.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 17,
                  ),
                ),
                Expanded(child: Divider(color: AppColor.black)),
                Expanded(child: Container()),
                Expanded(child: Container()),
              ],
            ),
            SizedBox(height: Sizes.height * .02),

            // Row(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     Expanded(
            //       flex: 4,
            //       child: Padding(
            //         padding: EdgeInsets.symmetric(
            //           horizontal: Sizes.width * .05,
            //           vertical: Sizes.height * .01,
            //         ),
            //         child: Column(
            //           children: [
            //             RoomSelectionWidget(
            //               buildings: buildings,
            //               floors: floors,
            //               rooms: rooms,
            //               selectedBuildingId: selectedBuildingId,
            //               selectedFloorId: selectedFloorId,
            //               selectedRoomType: selectedRoomType,
            //               selectedRoomId: selectedRoomId,
            //               onBuildingChange: (val) {
            //                 setState(() {
            //                   selectedBuildingId = val;
            //                   selectedFloorId = null;
            //                   selectedRoomId = null;
            //                   selectedRoomType = null;
            //                 });
            //               },
            //               onFloorChange: (val) {
            //                 setState(() {
            //                   selectedFloorId = val;
            //                   selectedRoomId = null;
            //                   selectedRoomType = null;
            //                 });
            //               },
            //               onRoomTypeChange: (val) {
            //                 setState(() {
            //                   selectedRoomType = val;
            //                   selectedRoomId = null;
            //                 });
            //               },
            //               onRoomChange: (val) {
            //                 setState(() {
            //                   selectedRoomId = val;
            //                 });
            //               },
            //               onRoomDetailsSelected: (room) {
            //                 setState(() {
            //                   selectedRoomBeds = room['room_beds'];
            //                   selectedRoomNumber = room['room_no']?.toString();
            //                   selectedRoomOccupacy = room['current_occupants'];
            //                   List<String> getHostelerIds(
            //                     dynamic hostelerIdRaw,
            //                   ) {
            //                     if (hostelerIdRaw is String) {
            //                       // Decode string → List
            //                       return List<String>.from(
            //                         jsonDecode(hostelerIdRaw),
            //                       );
            //                     } else if (hostelerIdRaw is List) {
            //                       // Already a List
            //                       return hostelerIdRaw.cast<String>();
            //                     } else {
            //                       return [];
            //                     }
            //                   }

            //                   // Usage
            //                   final hostelerIds = getHostelerIds(
            //                     room['hosteler_id'],
            //                   );

            //                   studentListInRoom =
            //                       studentList
            //                           .where(
            //                             (s) =>
            //                                 hostelerIds.contains(s.studentId),
            //                           )
            //                           .toList();
            //                 });
            //               },
            //             ),
            //             SizedBox(height: Sizes.height * .05),
            //           ],
            //         ),
            //       ),
            //     ),

            //     Expanded(
            //       flex: 3,
            //       child: Card(
            //         elevation: 8,
            //         shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(6),
            //         ),
            //         margin: const EdgeInsets.all(8.0),
            //         child: Stack(
            //           children: [
            //             selectedRoomId == null
            //                 ? Container()
            //                 : Container(
            //                   margin: EdgeInsets.only(top: 40),
            //                   width: double.infinity,
            //                   height: 170,
            //                   padding: EdgeInsets.symmetric(
            //                     horizontal: Sizes.width * .02,
            //                     vertical: Sizes.height * .025,
            //                   ),
            //                   decoration: const BoxDecoration(
            //                     color: Colors.white,
            //                     borderRadius: BorderRadius.only(
            //                       bottomLeft: Radius.circular(12),
            //                       bottomRight: Radius.circular(12),
            //                     ),
            //                   ),
            //                   child: Wrap(
            //                     runAlignment: WrapAlignment.spaceAround,
            //                     children: List.generate(
            //                       selectedRoomBeds ?? 0,
            //                       (index) => Padding(
            //                         padding: EdgeInsets.symmetric(
            //                           horizontal: Sizes.width * .03,
            //                         ),
            //                         child: Image.asset(
            //                           Images.roomshow,
            //                           height: 50,
            //                           color:
            //                               index + 1 <= selectedRoomOccupacy!
            //                                   ? AppColor.red
            //                                   : AppColor.primary,
            //                         ),
            //                       ),
            //                     ),
            //                   ),
            //                 ),

            //             selectedRoomId == null
            //                 ? Container()
            //                 : Container(
            //                   width: double.infinity,
            //                   padding: const EdgeInsets.symmetric(
            //                     vertical: 10.0,
            //                     horizontal: 20.0,
            //                   ),
            //                   decoration: BoxDecoration(
            //                     color: Colors.blue.shade600,
            //                     borderRadius: BorderRadius.circular(5),
            //                     boxShadow: [
            //                       BoxShadow(
            //                         color: AppColor.black81,
            //                         spreadRadius: 1,
            //                         blurRadius: 3,
            //                         offset: const Offset(0, 2),
            //                       ),
            //                     ],
            //                   ),
            //                   child: Text(
            //                     'Room No.- $selectedRoomNumber',
            //                     textAlign: TextAlign.center,
            //                     style: TextStyle(
            //                       color: AppColor.black,
            //                       fontSize: 20,
            //                       fontWeight: FontWeight.bold,
            //                     ),
            //                   ),
            //                 ),
            //           ],
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            // SizedBox(height: Sizes.height * .02),
            // addMasterOutside5(
            //   children: [
            //     TitleTextField(
            //       image: null,
            //       controller: _openingReadingController,
            //       titileText: "Opening Reading",
            //       hintText: "0.0",
            //       onChanged: (_) => calculateTotalAmount(),
            //     ),
            //     TitleTextField(
            //       image: null,
            //       controller: _closingReadingController,
            //       titileText: "Closing Reading",
            //       hintText: "0.0",
            //       onChanged: (_) => calculateTotalAmount(),
            //     ),
            //     TitleTextField(
            //       image: null,
            //       readOnly: true,
            //       controller: _pricePerUnitController,
            //       titileText: "Price per Unit",
            //       hintText: "0.0",
            //     ),
            //     TitleTextField(
            //       image: null,
            //       readOnly: true,
            //       controller: _totalAmtController,
            //       titileText: "Total Price",
            //       hintText: "0.0",
            //     ),
            //   ],
            //   context: context,
            // ),
            // SizedBox(height: Sizes.height * .03),
            // addMasterOutside5(
            //   children: [
            //     ...studentListInRoom.map((s) {
            //       studentFeeControllers.putIfAbsent(
            //         s.studentId ?? "",
            //         () => TextEditingController(),
            //       );
            //       return TitleTextField(
            //         image: null,
            //         controller: studentFeeControllers[s.studentId],
            //         titileText: s.studentName ?? "Student",
            //         hintText: "0.0",
            //       );
            //     }).toList(),
            //   ],
            //   context: context,
            // ),
            Center(
              child: DefaultButton(
                text: "Save",
                hight: 40,
                width: 150,
                onTap: () {
                  postMitareding();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future getHostlers() async {
    var response = await ApiService.fetchData(
      "admissionform?licence_no=${Preference.getString(PrefKeys.licenseNo)}&branch_id=${Preference.getint(PrefKeys.locationId)}",
    );
    if (response["status"] == true) {
      studentList = admissionListFromJson(response['data']);
    }
  }

  Future postMitareding() async {
    final studentsData =
        studentListInRoom.map((s) {
          return {
            "student_id": s.studentId,
            "name": s.studentName,
            "fees":
                double.tryParse(
                  studentFeeControllers[s.studentId]?.text ?? "0",
                ) ??
                0,
          };
        }).toList();
    var response = await ApiService.postData("mitareding", {
      'licence_no': Preference.getString(PrefKeys.licenseNo),
      'branch_id': Preference.getint(PrefKeys.locationId).toString(),
      "building": selectedBuildingId.toString(),
      "floor": selectedFloorId.toString(),
      "room": selectedRoomNumber ?? "",
      "opning_reding": _openingReadingController.text,
      "closing_reding": _closingReadingController.text,
      "unit": _pricePerUnitController.text,
      "price": _totalAmtController.text,
      "student_structure": studentsData,
    });

    if (response["status"] == true) {
      // Assuming showCustomSnackbarSuccess and showCustomSnackbarError are defined
      showCustomSnackbarSuccess(context, response['message']);
      Navigator.pop(context, "New Data");
    } else {
      showCustomSnackbarError(context, response['message']);
    }
  }
}
