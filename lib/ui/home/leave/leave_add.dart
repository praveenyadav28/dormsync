import 'package:dorm_sync/model/admission.dart';
import 'package:dorm_sync/model/leave.dart';
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

class LeaveAdd extends StatefulWidget {
  const LeaveAdd({super.key});

  @override
  State<LeaveAdd> createState() => _LeaveAddState();
}

class _LeaveAddState extends State<LeaveAdd> {
  List<AdmissionList> studentList = []; // Define this at the top of your widget

  String? studentId;
  TextEditingController studentController = TextEditingController();
  TextEditingController studentIdController = TextEditingController();
  TextEditingController admissionDateController = TextEditingController();
  TextEditingController courseController = TextEditingController();
  TextEditingController fatherNameController = TextEditingController();

  TextEditingController fromDatePicker = TextEditingController(
    text: DateFormat('dd/MM/yyyy').format(DateTime.now()),
  );
  TextEditingController toDatepicker = TextEditingController(
    text: DateFormat('dd/MM/yyyy').format(DateTime.now()),
  );
  TextEditingController accompainedByController = TextEditingController();
  TextEditingController relationNameController = TextEditingController();
  TextEditingController contactNoController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  TextEditingController aadharNoController = TextEditingController();
  TextEditingController purposeController = TextEditingController();

  final FocusNode studentFocusNode = FocusNode();
  @override
  void initState() {
    super.initState();

    getHostlers().then((_) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && leaveData == null) {
        leaveData = args as LeaveList;
        _fillleaveData(); // fill data only after student list is ready
      }

      // Setup listener after data is set
      studentController.addListener(() {
        final input = studentController.text.trim().toLowerCase();
        final found = studentList.any(
          (student) =>
              (student.studentName ?? '').trim().toLowerCase() == input,
        );

        if (!found) {
          courseController.clear();
          fatherNameController.clear();
          admissionDateController.clear();
          studentIdController.clear();
        }
      });

      setState(() {});
    });
  }

  void _fillleaveData() {
    studentIdController.text = leaveData!.hostelerId ?? "";
    fatherNameController.text = leaveData!.fatherName ?? "";
    courseController.text = leaveData!.courseName ?? "";
    admissionDateController.text = leaveData!.admissionDate ?? "";
    relationNameController.text = leaveData!.relation ?? "";
    studentController.text = leaveData!.hostelerName ?? "";
    contactNoController.text = leaveData!.contact ?? "";
    destinationController.text = leaveData!.destination ?? "";
    accompainedByController.text = leaveData!.accompainedBy ?? "";
    purposeController.text = leaveData!.purposeOfLeave ?? "";
    aadharNoController.text = leaveData!.aadharNo ?? "";
    toDatepicker.text = leaveData!.toDate ?? "";
    fromDatePicker.text = leaveData!.fromDate ?? "";
  }

  LeaveList? leaveData;
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
                          "Add Leave",
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
                "Leave Details",
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
                        controller: fromDatePicker,
                        titileText: "",
                        onTap: () async {
                          _selectDate(context, fromDatePicker);
                        },
                      ),
                      TitleTextField(
                        image: Images.to,
                        hintText: "--Date--",
                        controller: toDatepicker,
                        titileText: "",
                        onTap: () async {
                          _selectDate(context, toDatepicker);
                        },
                      ),
                      TitleTextField(
                        image: null,
                        controller: accompainedByController,
                        hintText: "--Name--",
                        titileText: "Accompained By",
                      ),
                      TitleTextField(
                        image: null,
                        controller: relationNameController,
                        hintText: "--Relation--",
                        titileText: "Relation",
                      ),

                      TitleTextField(
                        image: null,
                        controller: aadharNoController,
                        hintText: "--Aadhar--",
                        titileText: "Aadhar  No.",
                      ),
                      TitleTextField(
                        image: null,
                        controller: contactNoController,
                        hintText: "--Number--",
                        titileText: "Contact",
                      ),
                      TitleTextField(
                        image: null,
                        controller: destinationController,
                        hintText: "--Name--",
                        titileText: "Destination",
                      ),
                      TitleTextField(
                        image: null,
                        controller: purposeController,
                        hintText: "Remark",
                        titileText: " Purpose of Leave",
                      ),
                    ],
                    context: context,
                  ),
                  SizedBox(height: Sizes.height * .05),
                  Center(
                    child: DefaultButton(
                      text: leaveData == null ? "Save" : 'Update',
                      hight: 40,
                      width: 150,
                      onTap: () {
                        leaveData != null
                            ? showDialog(
                              context: context,
                              builder:
                                  (dialogContext) => AlertDialog(
                                    title: const Text("Warning"),
                                    content: const Text(
                                      "Are you sure you want to update leave details?",
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
                                              await updateLeaveApplication();
                                          Navigator.of(
                                            dialogContext,
                                          ).pop(); // ✅ Close dialog
                                          if (success) {
                                            Navigator.of(
                                              context,
                                            ).pop("New Data"); // ✅ Pop screen
                                          }
                                        },
                                        child: const Text("Update"),
                                      ),
                                    ],
                                  ),
                            )
                            : postLeaveApplication();
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

  Future getHostlers() async {
    var response = await ApiService.fetchData(
      "admissionform?licence_no=${Preference.getString(PrefKeys.licenseNo)}&branch_id=${Preference.getint(PrefKeys.locationId)}",
    );
    if (response["status"] == true) {
      studentList =
          admissionListFromJson(
            response['data'],
          ).where((student) => student.activeStatus == "1").toList();
    }
  }

  Future postLeaveApplication() async {
    final response = await ApiService.postData('leave', {
      'licence_no': Preference.getString(PrefKeys.licenseNo),
      'branch_id': Preference.getint(PrefKeys.locationId).toString(),
      'hosteler_id': studentIdController.text.toString(),
      'hosteler_details': studentController.text.toString(),
      'hosteler_name': studentController.text.toString(),
      'admission_date': admissionDateController.text.toString(),
      'course_name': courseController.text.toString(),
      'father_name': fatherNameController.text.toString(),
      'relation': relationNameController.text.trim().toString(),
      'contact': contactNoController.text.trim().toString(),
      'aadhar_no': aadharNoController.text.trim().toString(),
      'from_date': fromDatePicker.text.toString(),
      'to_date': toDatepicker.text.trim().toString(),
      'accompained_by': accompainedByController.text.trim().toString(),
      'destination': destinationController.text.trim().toString(),
      'purpose_of_leave': purposeController.text.trim().toString(),
    });

    if (response["status"] == true) {
      showCustomSnackbarSuccess(context, response['message']);

      Navigator.pop(context, "New Data");
    } else {
      showCustomSnackbarError(context, response['message']);
    }
  }

  Future updateLeaveApplication() async {
    final response = await ApiService.postData('leave/${leaveData!.id}', {
      'licence_no': Preference.getString(PrefKeys.licenseNo),
      'branch_id': Preference.getint(PrefKeys.locationId).toString(),
      'hosteler_id': studentIdController.text.toString(),
      'hosteler_details': studentController.text.toString(),
      'hosteler_name': studentController.text.toString(),
      'admission_date': admissionDateController.text.toString(),
      'course_name': courseController.text.toString(),
      'father_name': fatherNameController.text.toString(),
      'relation': relationNameController.text.trim().toString(),
      'contact': contactNoController.text.trim().toString(),
      'aadhar_no': aadharNoController.text.trim().toString(),
      'from_date': fromDatePicker.text.toString(),
      'to_date': toDatepicker.text.trim().toString(),
      'accompained_by': accompainedByController.text.trim().toString(),
      'destination': destinationController.text.trim().toString(),
      'purpose_of_leave': purposeController.text.trim().toString(),
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
