import 'package:dorm_sync/model/admission.dart';
import 'package:dorm_sync/model/visitor.dart';
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

class VisitorAdd extends StatefulWidget {
  const VisitorAdd({super.key});

  @override
  State<VisitorAdd> createState() => _VisitorAddState();
}

class _VisitorAddState extends State<VisitorAdd> {
  List<AdmissionList> studentList = []; // Define this at the top of your widget

  String? studentId;
  TextEditingController studentController = TextEditingController();
  TextEditingController studentIdController = TextEditingController();
  TextEditingController admissionDateController = TextEditingController();
  TextEditingController courseController = TextEditingController();
  TextEditingController fatherNameController = TextEditingController();

  TextEditingController visitDatepicker = TextEditingController(
    text: DateFormat('dd/MM/yyyy').format(DateTime.now()),
  );
  TextEditingController visitTimepicker = TextEditingController();
  TextEditingController leaveDatepicker = TextEditingController(
    text: DateFormat('dd/MM/yyyy').format(DateTime.now()),
  );
  TextEditingController leaveTimepicker = TextEditingController();
  TextEditingController visitorNameController = TextEditingController();
  TextEditingController relationNameController = TextEditingController();
  TextEditingController contactNoController = TextEditingController();
  TextEditingController aadharNoController = TextEditingController();
  TextEditingController purposeController = TextEditingController();

  final FocusNode studentFocusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    getHostlers().then((_) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && visitorData == null) {
        visitorData = args as VisitorList;
        _fillVisitorData(); // fill data only after student list is ready
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

  void _fillVisitorData() {
    studentIdController.text = visitorData!.hostelerId ?? "";
    fatherNameController.text = visitorData!.fatherName ?? "";
    courseController.text = visitorData!.courseName ?? "";
    admissionDateController.text = visitorData!.admissionDate ?? "";
    relationNameController.text = visitorData!.relation ?? "";
    studentController.text = visitorData!.hostelerName ?? "";
    contactNoController.text = visitorData!.contact ?? "";
    visitorNameController.text = visitorData!.visitorName ?? "";
    purposeController.text = visitorData!.purposeOfVisit ?? "";
    aadharNoController.text = visitorData!.aadharNo ?? "";
    leaveDatepicker.text = visitorData!.dateOfLeave ?? "";
    visitDatepicker.text = visitorData!.visitingDate ?? "";
    visitTimepicker.text = visitorData!.other1 ?? "";
    leaveTimepicker.text = visitorData!.other2 ?? "";
  }

  TimeOfDay? _selectedVisitTime;
  TimeOfDay? _selectedLeaveTime;

  // Generic function to show the time picker and return the selected time
  Future<TimeOfDay?> _showTimePicker(
    BuildContext context,
    TimeOfDay? initialTime,
  ) async {
    return await showTimePicker(
      context: context,
      initialTime: initialTime ?? TimeOfDay.now(),
    );
  }

  // Function to update the Visit Time TextField
  void _updateVisitTimeTextField() {
    if (_selectedVisitTime != null) {
      visitTimepicker.text = _selectedVisitTime!.format(context);
    } else {
      visitTimepicker.text = ''; // Clear text if no time selected
    }
  }

  // Function to update the Leave Time TextField
  void _updateLeaveTimeTextField() {
    if (_selectedLeaveTime != null) {
      leaveTimepicker.text = _selectedLeaveTime!.format(context);
    } else {
      leaveTimepicker.text = ''; // Clear text if no time selected
    }
  }

  VisitorList? visitorData;
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
                          "Add Visitor",
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
                "Visitors Details",
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
                        controller: visitDatepicker,
                        titileText: "Visit Date",
                        onTap: () async {
                          _selectDate(context, visitDatepicker);
                        },
                      ),
                      TitleTextField(
                        image: Images.clock,
                        hintText: "--Time--",
                        controller: visitTimepicker,
                        titileText: "Visit Time",
                        onTap: () async {
                          final pickedTime = await _showTimePicker(
                            context,
                            _selectedVisitTime,
                          ); // Use _selectedVisitTime
                          if (pickedTime != null &&
                              pickedTime != _selectedVisitTime) {
                            setState(() {
                              _selectedVisitTime =
                                  pickedTime; // Update class variable
                              _updateVisitTimeTextField(); // Update controller text
                            });
                          }
                        },
                      ),
                      TitleTextField(
                        image: null,
                        controller: visitorNameController,
                        hintText: "--Name--",
                        titileText: "Visitor Name",
                      ),
                      TitleTextField(
                        image: null,
                        controller: relationNameController,
                        hintText: "--Relation--",
                        titileText: "Relation",
                      ),
                      TitleTextField(
                        image: null,
                        controller: contactNoController,
                        hintText: "--Number--",
                        titileText: "Contact",
                      ),

                      TitleTextField(
                        image: null,
                        controller: aadharNoController,
                        hintText: "--Aadhar--",
                        titileText: "Aadhar  No.",
                      ),
                      TitleTextField(
                        image: null,
                        controller: purposeController,
                        hintText: "Remark",
                        titileText: " Purpose of Visit",
                      ),
                      TitleTextField(
                        image: Images.year,
                        hintText: "--Date--",
                        controller: leaveDatepicker,
                        titileText: "Date of leave",
                        onTap: () async {
                          _selectDate(context, leaveDatepicker);
                        },
                      ),
                      TitleTextField(
                        image: Images.clock,
                        hintText: "--Time--",
                        controller: leaveTimepicker,
                        titileText: "Leave Time",
                        onTap: () async {
                          final pickedTime = await _showTimePicker(
                            context,
                            _selectedLeaveTime,
                          );
                          if (pickedTime != null &&
                              pickedTime != _selectedLeaveTime) {
                            setState(() {
                              _selectedLeaveTime =
                                  pickedTime; // Update class variable
                              _updateLeaveTimeTextField(); // Update controller text
                            });
                          }
                        },
                      ),
                    ],
                    context: context,
                  ),
                  SizedBox(height: Sizes.height * .05),
                  Center(
                    child: DefaultButton(
                      text: visitorData == null ? "Save" : 'Update',
                      hight: 40,
                      width: 150,
                      onTap: () {
                        visitorData != null
                            ? showDialog(
                              context: context,
                              builder:
                                  (dialogContext) => AlertDialog(
                                    title: const Text("Warning"),
                                    content: const Text(
                                      "Are you sure you want to update visitor details?",
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
                                          bool success = await updateVisitor();
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
                            : postVisitor();
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
      "admissionform?licence_no=${Preference.getString(PrefKeys.licenseNo)}",
    );
    if (response["status"] == true) {
      studentList =
          admissionListFromJson(
            response['data'],
          ).where((student) => student.activeStatus == "1").toList();
    }
  }

  Future postVisitor() async {
    final response = await ApiService.postData('visitor', {
      'licence_no': Preference.getString(PrefKeys.licenseNo),
      'branch_id': Preference.getint(PrefKeys.locationId).toString(),
      'hosteler_id': studentIdController.text.toString(),
      'hosteler_details': studentController.text.toString(),
      'hosteler_name': studentController.text.toString(),
      'admission_date': admissionDateController.text.toString(),
      'course_name': courseController.text.toString(),
      'father_name': fatherNameController.text.toString(),
      'visiting_date': visitDatepicker.text.toString(),
      'visitor_name': visitorNameController.text.trim().toString(),
      'relation': relationNameController.text.trim().toString(),
      'contact': contactNoController.text.trim().toString(),
      'aadhar_no': aadharNoController.text.trim().toString(),
      'purpose_of_visit': purposeController.text.trim().toString(),
      'date_of_leave': leaveDatepicker.text.trim().toString(),
      'other1': visitTimepicker.text.toString(),
      'other2': leaveTimepicker.text.toString(),
    });

    if (response["status"] == true) {
      showCustomSnackbarSuccess(context, response['message']);

      Navigator.pop(context, "New Data");
    } else {
      showCustomSnackbarError(context, response['message']);
    }
  }

  Future updateVisitor() async {
    final response = await ApiService.postData('visitor/${visitorData!.id}', {
      'licence_no': Preference.getString(PrefKeys.licenseNo),
      'branch_id': Preference.getint(PrefKeys.locationId).toString(),
      'hosteler_id': studentIdController.text.toString(),
      'hosteler_details': studentController.text.toString(),
      'hosteler_name': studentController.text.toString(),
      'admission_date': admissionDateController.text.toString(),
      'course_name': courseController.text.toString(),
      'father_name': fatherNameController.text.toString(),
      'visiting_date': visitDatepicker.text.toString(),
      'visitor_name': visitorNameController.text.trim().toString(),
      'relation': relationNameController.text.trim().toString(),
      'contact': contactNoController.text.trim().toString(),
      'aadhar_no': aadharNoController.text.trim().toString(),
      'purpose_of_visit': purposeController.text.trim().toString(),
      'date_of_leave': leaveDatepicker.text.toString(),
      'other1': visitTimepicker.text.toString(),
      'other2': leaveTimepicker.text.toString(),
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
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        controller.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }
}
