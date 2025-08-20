import 'package:dorm_sync/model/admission.dart';
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
import 'package:searchfield/searchfield.dart';

class AssignRoom extends StatefulWidget {
  const AssignRoom({super.key});

  @override
  State<AssignRoom> createState() => _AssignRoomState();
}

class _AssignRoomState extends State<AssignRoom> {
  List<AdmissionList> studentList = [];

  String? studentId;
  TextEditingController studentController = TextEditingController();
  TextEditingController studentIdController = TextEditingController();
  TextEditingController admissionDateController = TextEditingController();
  TextEditingController courseController = TextEditingController();
  TextEditingController fatherNameController = TextEditingController();

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

  bool newHostler = false;
  int? updateId;

  final FocusNode studentFocusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    getHostlers().then((value) {
      setState(() {});
    });
    getBuildings();
    getFloors();
    getRooms();
    studentController.addListener(() {
      final input = studentController.text.trim().toLowerCase();

      final found = studentList.any(
        (student) => (student.studentName ?? '').trim().toLowerCase() == input,
      );

      if (!found) {
        courseController.clear();
        fatherNameController.clear();
        admissionDateController.clear();
        studentIdController.clear();
      }
    });
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
        child: Column(
          children: [
            Padding(
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
                          "Assigining Room",
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
                        'Hosteler Details  ',
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
                  addMasterOutside(
                    children: [
                      Row(
                        children: [
                          Image.asset(Images.studentName, height: 35),
                          SizedBox(width: 5),
                          Expanded(
                            child: SearchField<AdmissionList>(
                              focusNode: studentFocusNode,
                              suggestions:
                                  studentList
                                      .map(
                                        (e) =>
                                            SearchFieldListItem<AdmissionList>(
                                              e.studentName ?? '',
                                              item: e,
                                            ),
                                      )
                                      .toList(),
                              suggestionState: Suggestion.expand,
                              textInputAction: TextInputAction.next,
                              searchStyle: TextStyle(
                                color: AppColor.black,
                                fontWeight: FontWeight.w500,
                              ),
                              suggestionStyle: TextStyle(
                                color: AppColor.black,
                                fontWeight: FontWeight.w500,
                              ),
                              searchInputDecoration: InputDecoration(
                                border: OutlineInputBorder(),
                                filled: true,
                                fillColor: AppColor.white,
                                isDense: true,
                                hintStyle: TextStyle(
                                  color: AppColor.black81,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              controller: studentController,
                              hint: '--Hosteler Name--',
                              onSuggestionTap: (selected) async {
                                final selectedStudent = selected.item!;
                                studentId = selectedStudent.studentId;
                                studentController.text =
                                    selectedStudent.studentName ?? '';
                                studentIdController.text =
                                    selectedStudent.studentId ?? '';
                                admissionDateController.text =
                                    selectedStudent.admissionDate != null
                                        ? DateFormat(
                                          'dd/MM/yyyy',
                                        ).format(selectedStudent.admissionDate!)
                                        : '';
                                courseController.text =
                                    selectedStudent.course ?? '';
                                courseController.text =
                                    selectedStudent.course ?? '';
                                fatherNameController.text =
                                    selectedStudent.fatherName ?? '';

                                await getHostlersRoom(studentId).then((value) {
                                  setState(() {});
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      CommonTextFieldBorder(
                        readOnly: true,
                        controller: studentIdController,
                        image: Images.studentId,
                        hintText: '--Hosteler ID--',
                      ),
                      CommonTextFieldBorder(
                        readOnly: true,
                        controller: admissionDateController,
                        image: Images.year,
                        hintText: '--Admission Date--',
                      ),

                      Container(),
                      CommonTextFieldBorder(
                        readOnly: true,
                        controller: courseController,
                        image: Images.course,
                        hintText: '--Course Name--',
                      ),
                      CommonTextFieldBorder(
                        readOnly: true,
                        controller: fatherNameController,
                        image: Images.father,
                        hintText: '--Father Name--',
                      ),
                    ],
                    context: context,
                  ),
                ],
              ),
            ),

            Container(
              height: 35,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColor.primary.withValues(alpha: .6),
              ),
              alignment: Alignment.center,

              child: Text(
                "Room Details",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
              ),
            ),
            SizedBox(height: Sizes.height * .02),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: Sizes.width * .05,
                      vertical: Sizes.height * .01,
                    ),
                    child: Column(
                      children: [
                        RoomSelectionWidget(
                          buildings: buildings,
                          floors: floors,
                          rooms: rooms,
                          selectedBuildingId: selectedBuildingId,
                          selectedFloorId: selectedFloorId,
                          selectedRoomType: selectedRoomType,
                          selectedRoomId: selectedRoomId,
                          onBuildingChange: (val) {
                            setState(() {
                              selectedBuildingId = val;
                              selectedFloorId = null;
                              selectedRoomId = null;
                              selectedRoomType = null;
                            });
                          },
                          onFloorChange: (val) {
                            setState(() {
                              selectedFloorId = val;
                              selectedRoomId = null;
                              selectedRoomType = null;
                            });
                          },
                          onRoomTypeChange: (val) {
                            setState(() {
                              selectedRoomType = val;
                              selectedRoomId = null;
                            });
                          },
                          onRoomChange: (val) {
                            setState(() {
                              selectedRoomId = val;
                            });
                          },
                          onRoomDetailsSelected: (room) {
                            setState(() {
                              selectedRoomBeds = room['room_beds'];
                              selectedRoomNumber = room['room_no']?.toString();
                              selectedRoomOccupacy = room['current_occupants'];
                            });
                          },
                        ),
                        SizedBox(height: Sizes.height * .05),
                      ],
                    ),
                  ),
                ),

                Expanded(
                  flex: 3,
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    margin: const EdgeInsets.all(8.0),
                    child: Stack(
                      children: [
                        selectedRoomId == null
                            ? Container()
                            : Container(
                              margin: EdgeInsets.only(top: 40),
                              width: double.infinity,
                              height: 170,
                              padding: EdgeInsets.symmetric(
                                horizontal: Sizes.width * .02,
                                vertical: Sizes.height * .025,
                              ),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(12),
                                  bottomRight: Radius.circular(12),
                                ),
                              ),
                              child: Wrap(
                                runAlignment: WrapAlignment.spaceAround,
                                children: List.generate(
                                  selectedRoomBeds ?? 0,
                                  (index) => Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: Sizes.width * .03,
                                    ),
                                    child: Image.asset(
                                      Images.roomshow,
                                      height: 50,
                                      color:
                                          index + 1 <= selectedRoomOccupacy!
                                              ? AppColor.red
                                              : AppColor.primary,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                        selectedRoomId == null
                            ? Container()
                            : Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                vertical: 10.0,
                                horizontal: 20.0,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade600,
                                borderRadius: BorderRadius.circular(5),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColor.black81,
                                    spreadRadius: 1,
                                    blurRadius: 3,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Text(
                                'Room No.- $selectedRoomNumber',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColor.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Center(
              child: DefaultButton(
                text: newHostler ? "Save" : "Update",
                hight: 40,
                width: 150,
                onTap: () {
                  newHostler
                      ? postAssignRoom()
                      : showDialog(
                        context: context,
                        builder:
                            (dialogContext) => AlertDialog(
                              title: const Text("Warning"),
                              content: const Text(
                                "Room already assigned to this hostler. Are you sure you want to update hostler room?",
                              ),
                              actions: [
                                TextButton(
                                  onPressed:
                                      () => Navigator.of(dialogContext).pop(),
                                  child: const Text("Cancel"),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColor.primary,
                                  ),
                                  onPressed: () async {
                                    var success = await updateAssignRoom();
                                    Navigator.of(dialogContext).pop();
                                    if (success != null) {
                                      Navigator.of(context).pop("New Data");
                                    }
                                  },
                                  child: const Text("Update"),
                                ),
                              ],
                            ),
                      );
                },
              ),
            ),

            SizedBox(height: Sizes.height * .02),
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

  Future getHostlersRoom(String? id) async {
    var response = await ApiService.fetchData(
      "check-room-assignment/$id?licence_no=${Preference.getString(PrefKeys.licenseNo)}&branch_id=${Preference.getint(PrefKeys.locationId)}",
    );
    if (response["status"] == true) {
      selectedBuildingId = response['data']['building_id'];
      selectedFloorId = response['data']['floor_id'];
      selectedRoomType = response['data']['room_type'];
      selectedRoomId = response['data']['room_id'];
      updateId = response['data']['id'];
      newHostler = false;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        final room = rooms.firstWhere(
          (r) =>
              r['id'] == selectedRoomId &&
              r['building_id'] == selectedBuildingId &&
              r['floor_id'] == selectedFloorId &&
              r['room_type'] == selectedRoomType,
          orElse: () => {},
        );

        if (room.isNotEmpty) {
          setState(() {
            selectedRoomBeds = room['room_beds'];
            selectedRoomNumber = room['room_no']?.toString();
            selectedRoomOccupacy = room['current_occupants'];
          });
        }
      });
    } else {
      setState(() {
        newHostler = true;
        selectedBuildingId = null;
        selectedFloorId = null;
        selectedRoomType = null;
        selectedRoomId = null;
        selectedRoomBeds = null;
        selectedRoomNumber = null;
        selectedRoomOccupacy = null;
        updateId = null;
      });
    }
  }

  Future postAssignRoom() async {
    var response = await ApiService.postData('roomassign', {
      'licence_no': Preference.getString(PrefKeys.licenseNo),
      'branch_id': Preference.getint(PrefKeys.locationId).toString(),
      'hosteler_details': "",
      'hosteler_id': studentIdController.text.toString(),
      'hosteler_name': studentController.text.toString(),
      'admission_date': admissionDateController.text.toString(),
      'course_name': courseController.text.toString(),
      'father_name': fatherNameController.text.toString(),
      'building_id': selectedBuildingId,
      'floor_id': selectedFloorId,
      'room_type': selectedRoomType,
      'room_no': selectedRoomNumber,
      "room_id": selectedRoomId,
    });
    if (response["status"] == true) {
      showCustomSnackbarSuccess(context, response['message']);
      Navigator.pop(context, "New Data");
    } else {
      showCustomSnackbarError(context, response['message']);
    }
  }

  Future updateAssignRoom() async {
    var response = await ApiService.postData(
      'roomassign/$updateId?licence_no=${Preference.getString(PrefKeys.licenseNo)}',
      {
        'licence_no': Preference.getString(PrefKeys.licenseNo),
        'branch_id': Preference.getint(PrefKeys.locationId).toString(),
        'hosteler_details': "",
        'hosteler_id': studentIdController.text.toString(),
        'hosteler_name': studentController.text.toString(),
        'admission_date': admissionDateController.text.toString(),
        'course_name': courseController.text.toString(),
        'father_name': fatherNameController.text.toString(),
        'building_id': selectedBuildingId,
        'floor_id': selectedFloorId,
        'room_type': selectedRoomType,
        'room_no': selectedRoomNumber,
        "room_id": selectedRoomId,
        '_method': "PUT",
      },
    );

    if (response["status"] == true) {
      showCustomSnackbarSuccess(context, response['message']);
      return true;
    } else {
      showCustomSnackbarError(context, response['message']);
    }
  }
}
