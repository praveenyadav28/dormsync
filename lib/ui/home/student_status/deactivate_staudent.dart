import 'package:dorm_sync/model/assign_report.dart';
import 'package:dorm_sync/model/deactivated.dart';
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

class DeactivateStudent extends StatefulWidget {
  const DeactivateStudent({super.key});

  @override
  State<DeactivateStudent> createState() => _DeactivateStudentState();
}

class _DeactivateStudentState extends State<DeactivateStudent> {
  List<StudentReportList> studentList = [];
  String? studentId;
  TextEditingController studentController = TextEditingController();
  TextEditingController studentIdController = TextEditingController();
  TextEditingController admissionDateController = TextEditingController();
  TextEditingController contactNoController = TextEditingController();
  TextEditingController fatherNameController = TextEditingController();

  TextEditingController reasonController = TextEditingController();
  TextEditingController leaveDatePicker = TextEditingController(
    text: DateFormat('dd/MM/yyyy').format(DateTime.now()),
  );

  int? deleteId;

  final FocusNode studentFocusNode = FocusNode();
  @override
  void initState() {
    super.initState();

    getHostlers().then((_) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && deactivateData == null) {
        deactivateData = args as DeactivatedList;
        _fillDeactivateData(); // fill data only after student list is ready
      }

      studentController.addListener(() {
        final input = studentController.text.trim().toLowerCase();
        final found = studentList.any(
          (student) =>
              (student.studentName ?? '').trim().toLowerCase() == input,
        );

        if (!found) {
          contactNoController.clear();
          fatherNameController.clear();
          admissionDateController.clear();
          studentIdController.clear();
        }
      });

      setState(() {});
    });
  }

  void _fillDeactivateData() {
    studentId = deactivateData!.hostelerId ?? "";
    studentIdController.text = deactivateData!.hostelerId ?? "";
    fatherNameController.text = deactivateData!.fatherName ?? "";
    contactNoController.text = deactivateData!.contactNo ?? "";
    admissionDateController.text = deactivateData!.admissionDate ?? "";
    studentController.text = deactivateData!.hostelerName ?? "";
    reasonController.text = deactivateData!.reason ?? "";
    leaveDatePicker.text = deactivateData!.leaveDate ?? "";
  }

  DeactivatedList? deactivateData;
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
                          "Deactivate Student",
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
                            child: SearchField<StudentReportList>(
                              focusNode: studentFocusNode,
                              suggestions:
                                  studentList
                                      .map(
                                        (e) => SearchFieldListItem<
                                          StudentReportList
                                        >(e.studentName ?? '', item: e),
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
                                    selectedStudent.admissionDate ?? '';
                                contactNoController.text =
                                    selectedStudent.primaryContactNo ?? '';
                                deleteId = selectedStudent.id;
                                fatherNameController.text =
                                    selectedStudent.fatherName ?? '';
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
                        controller: contactNoController,
                        image: Images.course,
                        hintText: '--Conatct No--',
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
                "Deactivate Details",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Sizes.width * .02,
                vertical: Sizes.height * .01,
              ),
              child: Column(
                children: [
                  addMasterOutside5(
                    children: [
                      TitleTextField(
                        image: Images.year,
                        hintText: "--Date--",
                        controller: leaveDatePicker,
                        titileText: "",
                        onTap: () async {
                          _selectDate(context, leaveDatePicker);
                        },
                      ),

                      TitleTextField(
                        image: null,
                        controller: reasonController,
                        hintText: "Reason",
                        titileText: " Reason of Leave Hostel",
                      ),
                    ],
                    context: context,
                  ),
                  SizedBox(height: Sizes.height * .05),
                  Center(
                    child: DefaultButton(
                      text: deactivateData == null ? "Save" : 'Update',
                      hight: 40,
                      width: 150,
                      onTap: () {
                        deactivateData != null
                            ? showDialog(
                              context: context,
                              builder:
                                  (dialogContext) => AlertDialog(
                                    title: const Text("Warning"),
                                    content: const Text(
                                      "Are you sure you want to update details?",
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed:
                                            () =>
                                                Navigator.of(
                                                  dialogContext,
                                                ).pop(),
                                        child: const Text("Cancel"),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColor.primary,
                                        ),
                                        onPressed: () async {
                                          bool success =
                                              await updateDeactivateStudent();
                                          Navigator.of(dialogContext).pop();
                                          if (success) {
                                            Navigator.of(
                                              context,
                                            ).pop("New Data");
                                          }
                                        },
                                        child: const Text("Update"),
                                      ),
                                    ],
                                  ),
                            )
                            : postDeactivateStudent();
                      },
                    ),
                  ),
                  SizedBox(height: Sizes.height * .04),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getHostlers() async {
    final response = await ApiService.fetchData(
      "student/assign?from_date=01/01/1900&to_date=01/01/2200",
    );
    if (response["status"] == true) {
      studentList = studentReportListFromJson(response['data']);
    }
  }

  Future<void> deleteAssignedRoom(int id) async {
    final response = await ApiService.deleteData("roomassign/$id");
    if (response["status"] == true) {
      showCustomSnackbarSuccess(context, response['message']);
    } else {
      showCustomSnackbarError(context, response['message']);
    }
  }

  Future postDeactivateStudent() async {
    final response = await ApiService.postData('dectivate', {
      'licence_no': Preference.getString(PrefKeys.licenseNo),
      'branch_id': Preference.getint(PrefKeys.locationId).toString(),
      'hosteler_id': studentIdController.text.toString(),
      'hosteler_details': studentController.text.toString(),
      'hosteler_name': studentController.text.toString(),
      'admission_date': admissionDateController.text.toString(),
      'contact_no': contactNoController.text.toString(),
      'father_name': fatherNameController.text.toString(),
      'reason': reasonController.text.toString(),
      'leave_date': leaveDatePicker.text.toString(),
      'active_status': 1,
    });
    if (response["status"] == true) {
      showCustomSnackbarSuccess(context, response['message']);
      deleteAssignedRoom(deleteId!);
      Navigator.pop(context, "New Data");
    } else {
      showCustomSnackbarError(context, response['message']);
    }
  }

  Future updateDeactivateStudent() async {
    final response =
        await ApiService.postData('dectivate/${deactivateData!.id}', {
          'licence_no': Preference.getString(PrefKeys.licenseNo),
          'branch_id': Preference.getint(PrefKeys.locationId).toString(),
          'hosteler_id': studentIdController.text.toString(),
          'hosteler_details': studentController.text.toString(),
          'hosteler_name': studentController.text.toString(),
          'admission_date': admissionDateController.text.toString(),
          'contact_no': contactNoController.text.toString(),
          'father_name': fatherNameController.text.toString(),
          'reason': reasonController.text.toString(),
          'leave_date': leaveDatePicker.text.toString(),
          '_method': "PUT",
        });

    if (response["status"] == true) {
      showCustomSnackbarSuccess(context, response['message']);
      return true;
    } else {
      showCustomSnackbarError(context, response['message']);
      return false;
    }
  }

  Future<void> _selectDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000), // Start date
      lastDate: DateTime(2101), // End date
    );

    if (picked != null) {
      setState(() {
        controller.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }
}
