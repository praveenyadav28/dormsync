import 'package:dorm_sync/model/admission.dart';
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

class AddHostler extends StatefulWidget {
  const AddHostler({super.key});

  @override
  State<AddHostler> createState() => _AddHostlerState();
}

class _AddHostlerState extends State<AddHostler> {
  List<AdmissionList> studentList = [];
  bool newHostler = true;
  int? updateId;
  String? studentId;
  TextEditingController studentController = TextEditingController();
  TextEditingController studentIdController = TextEditingController();
  TextEditingController admissionDateController = TextEditingController();
  TextEditingController courseController = TextEditingController();
  TextEditingController fatherNameController = TextEditingController();

  TextEditingController hostelBiomaxController = TextEditingController();
  TextEditingController messBiomaxController = TextEditingController();

  final FocusNode studentFocusNode = FocusNode();
  @override
  void initState() {
    super.initState();

    getHostlers().then((_) {
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
                          "Add Hostler",
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
                                await getAttendenceDetails(studentId).then((
                                  value,
                                ) {
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
                "Biomax Details",
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
                        image: null,
                        controller: hostelBiomaxController,
                        hintText: "--Hostel Biomax--",
                        titileText: "Hostel Biomax",
                      ),
                      TitleTextField(
                        image: null,
                        controller: messBiomaxController,
                        hintText: "--Mess Biomax--",
                        titileText: "Mess Biomax",
                      ),
                    ],
                    context: context,
                  ),
                  SizedBox(height: Sizes.height * .05),
                  Center(
                    child: DefaultButton(
                      text: newHostler ? "Save" : 'Update',
                      hight: 40,
                      width: 150,
                      onTap: () {
                        !newHostler
                            ? showDialog(
                              context: context,
                              builder:
                                  (dialogContext) => AlertDialog(
                                    title: const Text("Warning"),
                                    content: const Text(
                                      "Are you sure you want to update biomax details?",
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
                                              await updateAttendance();
                                          Navigator.of(dialogContext).pop();
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
                            : postAttendence();
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

  Future postAttendence() async {
    final response = await ApiService.postData('attendance', {
      'licence_no': Preference.getString(PrefKeys.licenseNo),
      'branch_id': Preference.getint(PrefKeys.locationId).toString(),
      'hosteler_id': studentIdController.text.toString(),
      'hosteler_details': studentController.text.toString(),
      'hosteler_name': studentController.text.toString(),
      'admission_date': admissionDateController.text.toString(),
      'course_name': courseController.text.toString(),
      'father_name': fatherNameController.text.toString(),
      'hostel_biomax': hostelBiomaxController.text.trim().toString(),
      'mess_biomax': messBiomaxController.text.trim().toString(),
      'active_status': 1,
    });

    if (response["status"] == true) {
      showCustomSnackbarSuccess(context, response['message']);

      Navigator.pop(context, "New Data");
    } else {
      showCustomSnackbarError(context, response['message']);
    }
  }

  Future updateAttendance() async {
    final response = await ApiService.postData('attendance/$updateId', {
      'licence_no': Preference.getString(PrefKeys.licenseNo),
      'branch_id': Preference.getint(PrefKeys.locationId).toString(),
      'hosteler_id': studentIdController.text.toString(),
      'hosteler_details': studentController.text.toString(),
      'hosteler_name': studentController.text.toString(),
      'admission_date': admissionDateController.text.toString(),
      'course_name': courseController.text.toString(),
      'father_name': fatherNameController.text.toString(),
      'hostel_biomax': hostelBiomaxController.text.trim().toString(),
      'mess_biomax': messBiomaxController.text.trim().toString(),
      'active_status': 1,
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

  Future getAttendenceDetails(String? id) async {
    var response = await ApiService.fetchData("mbiomax?hosteler_id=$id");
    if (response["status"] == true) {
      messBiomaxController.text = response['data'][0]['mess_biomax'];
      hostelBiomaxController.text = response['data'][0]['hostel_biomax'];
      updateId = response['data'][0]['id'];
      newHostler = false;
    } else {
      setState(() {
        newHostler = true;
        messBiomaxController.clear();
        hostelBiomaxController.clear();
        updateId = null;
      });
    }
  }
}
