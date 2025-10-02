import 'package:dorm_sync/model/admission.dart';
import 'package:dorm_sync/model/extra_expanse.dart';
import 'package:dorm_sync/utils/api.dart';
import 'package:dorm_sync/utils/buttons.dart';
import 'package:dorm_sync/utils/colors.dart';
import 'package:dorm_sync/utils/date_change.dart';
import 'package:dorm_sync/utils/field_cover.dart';
import 'package:dorm_sync/utils/images.dart';
import 'package:dorm_sync/utils/prefence.dart';
import 'package:dorm_sync/utils/sizes.dart';
import 'package:dorm_sync/utils/snackbar.dart';
import 'package:dorm_sync/utils/textformfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:searchfield/searchfield.dart';

class CreateContraExpanse extends StatefulWidget {
  const CreateContraExpanse({super.key});

  @override
  State<CreateContraExpanse> createState() => _CreateContraExpanseState();
}

class _CreateContraExpanseState extends State<CreateContraExpanse> {
  ExtraExpanseModel? voucherData;
  TextEditingController controDatepicker = TextEditingController(
    text: DateFormat('dd/MM/yyyy').format(DateTime.now()),
  );
  final TextEditingController remarkController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  String _previousText = '';
  List<AdmissionList> hostlersList = [];
  Map<int, bool> selectedHostlers = {}; // store selected checkboxes
  bool selectAll = false;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && voucherData == null) {
        voucherData = args as ExtraExpanseModel;

        controDatepicker.text = voucherData!.date ?? "";
        amountController.text = voucherData!.price?.toString() ?? "0";
        remarkController.text = voucherData!.remark?.toString() ?? "0";
        if (voucherData!.structure != null) {
          for (var s in voucherData!.structure!) {
            // assuming `s.studentId` exists
            selectedHostlers[int.parse(s.studentId!)] = true;
          }
        }
        setState(() {});
      }
    });
    getTotalActiveHostler();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: Sizes.width * .02,
          vertical: Sizes.height * .01,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------- Header ----------
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
                    "Hostler Expanse Entry",
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

            // ---------- Form ----------
            addMasterOutside(
              children: [
                CommonTextField(
                  image: Images.year,
                  onPressIcon: () async {
                    selectDate(context, controDatepicker).then((onValue) {
                      setState(() {});
                    });
                  },
                  controller: controDatepicker,
                  onChanged: (val) {
                    bool isValid = smartDateOnChanged(
                      value: val,
                      controller: controDatepicker,
                      previousText: _previousText,
                      updatePreviousText: (newText) => _previousText = newText,
                    );
                    if (isValid) setState(() {});
                  },
                ),
                CommonTextField(
                  controller: amountController,
                  image: Images.openingBalance,
                  hintText: 'Amount*',
                ),
                CommonTextField(
                  controller: remarkController,
                  image: Images.information,
                  hintText: 'Narration',
                ),
                Row(
                  children: [
                    Checkbox(
                      value: selectAll,
                      onChanged: (val) {
                        setState(() {
                          selectAll = val ?? false;
                          for (var h in hostlersList) {
                            selectedHostlers[h.id ?? 0] = selectAll;
                          }
                        });
                      },
                    ),
                    Text("Select All Students"),
                  ],
                ),
                if (!selectAll)
                  SearchField(
                    suggestions:
                        hostlersList
                            .map(
                              (h) => SearchFieldListItem(h.studentName ?? ""),
                            )
                            .toList(),
                    hint: 'Select Students',
                    onSuggestionTap: (item) {
                      final selectedStudent = hostlersList.firstWhere(
                        (h) => h.studentName == item.searchKey,
                        orElse:
                            () => AdmissionList(
                              id: 0,
                              studentName: item.searchKey,
                            ),
                      );
                      setState(() {
                        selectedHostlers[selectedStudent.id ?? 0] = true;
                      });
                    },
                  ),
              ],
              context: context,
            ),
            SizedBox(height: Sizes.height * .02),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children:
                    hostlersList
                        .where((h) => selectedHostlers[h.id ?? 0] == true)
                        .map(
                          (h) => Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: Chip(
                              label: Text(h.studentName ?? ""),
                              onDeleted: () {
                                setState(() {
                                  selectedHostlers[h.id ?? 0] = false;
                                });
                              },
                            ),
                          ),
                        )
                        .toList(),
              ),
            ),

            SizedBox(height: Sizes.height * .02),

            // ---------- Submit Button ----------
            Center(
              child: DefaultButton(
                text: voucherData == null ? "Create" : "Update",
                hight: 40,
                width: 150,
                onTap: () {
                  voucherData != null
                      ? updateExtraExpanse()
                      : postExtraExpanse();
                },
              ),
            ),
            SizedBox(height: Sizes.height * .04),
          ],
        ),
      ),
    );
  }

  // ---------------- API Calls ----------------

  Future postExtraExpanse() async {
    double totalAmount = double.tryParse(amountController.text) ?? 0;
    List<AdmissionList> selectedStudents =
        hostlersList.where((h) => selectedHostlers[h.id ?? 0] == true).toList();

    double perPerson =
        selectedStudents.isNotEmpty
            ? (totalAmount / selectedStudents.length)
            : 0;

    List<Map<String, dynamic>> structure =
        selectedStudents.map((s) {
          return {
            "name": s.studentName ?? "",
            "price": perPerson.toStringAsFixed(2),
            "course": s.course ?? "",
            "student_id": s.studentId ?? "",
            "father_name": s.fatherName ?? "",
          };
        }).toList();

    final response = await ApiService.postData('perstudent', {
      'licence_no': Preference.getString(PrefKeys.licenseNo),
      'branch_id': Preference.getint(PrefKeys.locationId).toString(),
      'date': controDatepicker.text.trim().toString(),
      'price': amountController.text.toString(),
      'remark': remarkController.text.trim().toString(),
      'per_person_price': perPerson.toStringAsFixed(2),
      'structure': structure,
    });

    if (response["status"] == true) {
      showCustomSnackbarSuccess(context, response['message']);
      Navigator.pop(context, "New Data");
    } else {
      showCustomSnackbarError(context, response['message']);
    }
  }

  Future updateExtraExpanse() async {
    // Same structure logic as post
    double totalAmount = double.tryParse(amountController.text) ?? 0;
    List<AdmissionList> selectedStudents =
        hostlersList.where((h) => selectedHostlers[h.id ?? 0] == true).toList();

    double perPerson =
        selectedStudents.isNotEmpty
            ? (totalAmount / selectedStudents.length)
            : 0;

    List<Map<String, dynamic>> structure =
        selectedStudents.map((s) {
          return {
            "name": s.studentName ?? "",
            "price": perPerson.toStringAsFixed(2),
            "course": s.course ?? "",
            "student_id": s.studentId ?? "",
            "father_name": s.fatherName ?? "",
          };
        }).toList();

    final response = await ApiService.postData(
      'perstudent/${voucherData!.id}?licence_no=${Preference.getString(PrefKeys.licenseNo)}',
      {
        'licence_no': Preference.getString(PrefKeys.licenseNo),
        'branch_id': Preference.getint(PrefKeys.locationId).toString(),
        'date': controDatepicker.text.trim().toString(),
        'price': amountController.text.toString(),
        'remark': remarkController.text.trim().toString(),
        'per_person_price': perPerson.toStringAsFixed(2),
        'structure': structure,
        '_method': "PUT",
      },
    );

    if (response["status"] == true) {
      showCustomSnackbarSuccess(context, response['message']);
      Navigator.pop(context, "New Data");
    } else {
      showCustomSnackbarError(context, response['message']);
    }
  }

  Future<void> getTotalActiveHostler() async {
    var response = await ApiService.fetchData(
      "admissionform?licence_no=${Preference.getString(PrefKeys.licenseNo)}&branch_id=${Preference.getint(PrefKeys.locationId)}",
    );
    if (response["status"] == true) {
      hostlersList = admissionListFromJson(
        response['data'].where((s) => s['active_status'] == 1).toList(),
      );
      setState(() {});
    }
  }
}
