import 'dart:io';
import 'package:dorm_sync/model/admission.dart';
import 'package:dorm_sync/model/fees.dart';
import 'package:dorm_sync/model/fees_receive.dart';
import 'package:dorm_sync/model/ledger.dart';
import 'package:dorm_sync/model/staff.dart';
import 'package:dorm_sync/utils/api.dart';
import 'package:dorm_sync/utils/buttons.dart';
import 'package:dorm_sync/utils/colors.dart';
import 'package:dorm_sync/utils/container.dart';
import 'package:dorm_sync/utils/date_change.dart';
import 'package:dorm_sync/utils/field_cover.dart';
import 'package:dorm_sync/utils/images.dart';
import 'package:dorm_sync/utils/prefence.dart';
import 'package:dorm_sync/utils/sizes.dart';
import 'package:dorm_sync/utils/snackbar.dart';
import 'package:dorm_sync/utils/textformfield.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:searchfield/searchfield.dart';

class FeesReceive extends StatefulWidget {
  const FeesReceive({super.key});

  @override
  State<FeesReceive> createState() => _FeesReceiveState();
}

class _FeesReceiveState extends State<FeesReceive> {
  List<AdmissionList> studentList = [];
  List<LedgerList> ledgerList = [];
  List<StaffList> staffList = [];
  List<FeesList> feesList = [];

  ReceivedListModel? feesReceiveData;

  final TextEditingController feesNumberController = TextEditingController();
  final TextEditingController prefixNameController = TextEditingController();
  TextEditingController feesDatepicker = TextEditingController(
    text: DateFormat('dd/MM/yyyy').format(DateTime.now()),
  );
  final TextEditingController paymentModeController = TextEditingController();
  final TextEditingController receiveByController = TextEditingController();
  final TextEditingController studentInstallmentController =
      TextEditingController(text: "0");
  final TextEditingController narrationController = TextEditingController();
  final TextEditingController remarkController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  TextEditingController studentController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController studentIdController = TextEditingController();
  TextEditingController admissionDateController = TextEditingController();
  TextEditingController fatherNameController = TextEditingController();

  TextEditingController totalFessController = TextEditingController();
  TextEditingController discountController = TextEditingController();
  TextEditingController finalAmountController = TextEditingController();
  TextEditingController totalEMIController = TextEditingController();
  TextEditingController nextEMIAmountController = TextEditingController();

  final FocusNode paymentModeFocusNode = FocusNode();
  final FocusNode amountFocusNode = FocusNode();

  LedgerList? selectedPaymentLedger;
  AdmissionList? selectedAccountHeadLedger;
  StaffList? selectedStaff;

  List<LedgerList> paymentModeLedgers = [];

  String _previousText = '';
  int? ledgerId;

  bool isChecked = false;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && feesReceiveData == null) {
        feesReceiveData = args as ReceivedListModel;

        feesNumberController.text = feesReceiveData!.feesNo.toString();
        feesDatepicker.text = feesReceiveData!.date ?? "";
        studentController.text = feesReceiveData!.hostelerName ?? "";
        studentIdController.text = feesReceiveData!.hostelerId ?? "";
        contactController.text = feesReceiveData!.contactNo ?? "";
        fatherNameController.text = feesReceiveData!.fatherName ?? "";
        admissionDateController.text = feesReceiveData!.admissionDate ?? "";
        totalFessController.text = feesReceiveData!.other1?.toString() ?? "0";
        discountController.text = feesReceiveData!.other2?.toString() ?? "0";
        finalAmountController.text = feesReceiveData!.other3?.toString() ?? "0";
        totalEMIController.text = feesReceiveData!.other4?.toString() ?? "0";
        nextEMIAmountController.text =
            feesReceiveData!.other5?.toString() ?? "0";
        amountController.text = feesReceiveData!.amount?.toString() ?? "0";
        paymentModeController.text =
            feesReceiveData!.ledgerName?.toString() ?? "0";
        ledgerId = int.tryParse(feesReceiveData!.ledgerId!) ?? 0;
        narrationController.text =
            feesReceiveData!.narration?.toString() ?? "0";
        receiveByController.text =
            feesReceiveData!.receiveBy?.toString() ?? "0";
        remarkController.text = feesReceiveData!.remark?.toString() ?? "0";
        isChecked = feesReceiveData!.isActive ?? false;
        studentInstallmentController.text =
            feesReceiveData!.installmentNo?.toString() ?? "0";
      } else {
        getVoucherId().then((_) {
          setState(() {});
        });
      }
    });

    super.initState();

    fetchInitialData();
  }

  Future<void> fetchInitialData() async {
    await getLedger();
    await getStudent();
    await getStaff();

    setState(() {
      paymentModeLedgers =
          ledgerList
              .where(
                (ledger) =>
                    ledger.ledgerGroup == "Bank Account" ||
                    ledger.ledgerGroup == "Cash In Hand",
              )
              .toList();
    });
    studentController.addListener(() {
      final input = studentController.text.trim().toLowerCase();
      final found = studentList.any(
        (student) => (student.studentName ?? '').trim().toLowerCase() == input,
      );
      if (!found) {
        fatherNameController.clear();
        admissionDateController.clear();
        contactController.clear();
        studentIdController.clear();
      }
    });
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
                    "Fees Receive",
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
            addMasterOutside(
              children: [
                CommonTextFieldBorder(
                  controller: feesNumberController,
                  image: Images.businessType,
                  hintText: 'Fees No.*',
                ),
                CommonTextFieldBorder(
                  image: Images.year,
                  hintText: "Fees Receive Date",
                  onPressIcon: () async {
                    selectDate(context, feesDatepicker).then((onValue) {
                      setState(() {});
                    });
                  },
                  controller: feesDatepicker,
                  onChanged: (val) {
                    bool isValid = smartDateOnChanged(
                      value: val,
                      controller: feesDatepicker,
                      previousText: _previousText,
                      updatePreviousText: (newText) => _previousText = newText,
                    );
                    if (isValid) {
                      setState(
                        () {},
                      ); // Only triggers when valid date is formed
                    }
                  },
                ),
              ],
              context: context,
            ),
            SizedBox(height: Sizes.height * .03),
            ButtonContainer(text: "Student Details", image: Images.studentId),
            SizedBox(height: Sizes.height * .03),
            addMasterOutside(
              children: [
                Row(
                  children: [
                    Image.asset(Images.studentName, height: 35),
                    SizedBox(width: 5),
                    Expanded(
                      child: SearchField<AdmissionList>(
                        readOnly: feesReceiveData != null ? true : false,
                        suggestions:
                            studentList
                                .map(
                                  (e) => SearchFieldListItem<AdmissionList>(
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
                          studentController.text =
                              selectedStudent.studentName ?? '';
                          studentIdController.text =
                              selectedStudent.studentId ?? '';
                          contactController.text =
                              selectedStudent.primaryContactNo ?? '';

                          admissionDateController.text =
                              selectedStudent.admissionDate != null
                                  ? DateFormat(
                                    'dd/MM/yyyy',
                                  ).format(selectedStudent.admissionDate!)
                                  : '';
                          fatherNameController.text =
                              selectedStudent.fatherName ?? '';
                          getFeesDetails(selectedStudent.studentId ?? "").then((
                            _,
                          ) {
                            setState(() {});
                            totalFessController.text =
                                feesList[0].totalAmount ?? "";
                            discountController.text =
                                feesList[0].discount.toString();
                            finalAmountController.text =
                                feesList[0].totalRemaining.toString();
                            totalEMIController.text =
                                "${feesList[0].emiTotal}/${feesList[0].emiRecived}";
                            nextEMIAmountController.text =
                                totalEMIController.text == "0/0" ||
                                        totalEMIController.text ==
                                            "${feesList[0].emiTotal}/${feesList[0].emiTotal}"
                                    ? "0"
                                    : feesList[0]
                                        .installmentStructure![feesList[0]
                                            .emiRecived!]
                                        .price
                                        .toString();
                          });
                        },
                      ),
                    ),
                  ],
                ),
                CommonTextFieldBorder(
                  readOnly: true,
                  controller: fatherNameController,
                  image: Images.father,
                  hintText: '--Father Name--',
                ),
                CommonTextFieldBorder(
                  readOnly: true,
                  controller: contactController,
                  image: Images.contactNo,
                  hintText: '--Contact No--',
                ),
                CommonTextFieldBorder(
                  readOnly: true,
                  controller: admissionDateController,
                  image: Images.year,
                  hintText: '--Admission Date--',
                ),
              ],
              context: context,
            ),
            SizedBox(height: Sizes.height * .03),
            addMasterOutside5(
              children: [
                TitleTextField(
                  image: null,
                  readOnly: true,
                  controller: totalFessController,
                  hintText: '--Total Fees--',
                  titileText: "Total Fees",
                ),
                TitleTextField(
                  image: null,
                  readOnly: true,
                  controller: discountController,
                  hintText: '--Discount--',
                  titileText: "Discount",
                ),
                TitleTextField(
                  image: null,
                  readOnly: true,
                  controller: finalAmountController,
                  hintText: '--Final Fees--',
                  titileText: "Final Fees",
                ),
                if (totalEMIController.text != "0/0")
                  TitleTextField(
                    image: null,
                    readOnly: true,
                    controller: totalEMIController,
                    hintText: '--EMI Status--',
                    titileText: "EMI Status",
                  ),
                if (totalEMIController.text != "0/0" ||
                    totalEMIController.text !=
                        "${feesList[0].emiTotal}/${feesList[0].emiTotal}")
                  TitleTextField(
                    image: null,
                    readOnly: true,
                    controller: nextEMIAmountController,
                    hintText: '--Next EMI Amount--',
                    titileText: "Next EMI Amount",
                  ),
              ],
              context: context,
            ),
            SizedBox(height: Sizes.height * 0.04),
            ButtonContainer(text: " Fees Details", image: Images.reports),
            addMasterOutside(
              children: [
                Row(
                  children: [
                    Image.asset(Images.fees),
                    SizedBox(width: 10),
                    Expanded(
                      child: SearchField<LedgerList>(
                        readOnly: feesReceiveData != null ? true : false,
                        controller: paymentModeController,
                        focusNode: paymentModeFocusNode,
                        hint: 'Payment Mode',
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
                        suggestions:
                            paymentModeLedgers
                                .map(
                                  (ledger) => SearchFieldListItem<LedgerList>(
                                    ledger.ledgerName ?? '',
                                    item: ledger,
                                  ),
                                )
                                .toList(),
                        onSuggestionTap: (val) {
                          setState(() {
                            paymentModeController.text = val.item!.ledgerName!;
                            ledgerId = val.item!.id!;
                            selectedPaymentLedger = val.item;
                          });
                        },
                      ),
                    ),
                  ],
                ),

                CommonTextFieldBorder(
                  focuesNode: amountFocusNode,
                  controller: amountController,
                  image: Images.openingBalance,
                  hintText: 'Receive Amount*',
                ),
                CommonTextFieldBorder(
                  controller: narrationController,
                  image: Images.information,
                  hintText: 'Narration',
                ),
                if (totalEMIController.text != "0/0" ||
                    totalEMIController.text !=
                        "${feesList[0].emiTotal}/${feesList[0].emiTotal}")
                  Row(
                    children: [
                      Checkbox(
                        value: isChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            isChecked = value!;
                          });
                        },
                      ),
                      SizedBox(width: 5),
                      !isChecked
                          ? Text("Paying Installment")
                          : Expanded(
                            child: TextFormField(
                              controller: studentInstallmentController,
                              style: TextStyle(
                                color: AppColor.black,
                                fontWeight: FontWeight.w500,
                              ),
                              decoration: InputDecoration(
                                isDense: true,
                                fillColor: AppColor.white,
                                filled: true,
                                border: OutlineInputBorder(),
                                hintText: "Installment Number",
                                hintStyle: TextStyle(
                                  color: AppColor.black.withValues(alpha: .81),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                    ],
                  ),
              ],
              context: context,
            ),
            SizedBox(height: Sizes.height * .02),
            ButtonContainer(
              text: " Transaction Executed By",
              image: Images.aadhar,
            ),
            addMasterOutside3(
              children: [
                Row(
                  children: [
                    Image.asset(Images.father),
                    SizedBox(width: 10),
                    Expanded(
                      child: SearchField<StaffList>(
                        controller: receiveByController,
                        hint: 'Receive By',
                        suggestionStyle: TextStyle(
                          color: AppColor.black,
                          fontWeight: FontWeight.w500,
                        ),
                        searchStyle: TextStyle(
                          color: AppColor.black,
                          fontWeight: FontWeight.w500,
                        ),
                        suggestions:
                            staffList
                                .map(
                                  (staff) => SearchFieldListItem<StaffList>(
                                    staff.staffName ?? '',
                                    item: staff,
                                  ),
                                )
                                .toList(),
                        onSuggestionTap: (val) {
                          setState(() {
                            selectedStaff = val.item;
                            receiveByController.text = val.item!.staffName!;
                          });
                        },
                        searchInputDecoration: InputDecoration(
                          floatingLabelStyle: TextStyle(
                            color: AppColor.black,
                            fontWeight: FontWeight.w500,
                          ),
                          fillColor: AppColor.white,
                          filled: true,
                          hintStyle: TextStyle(
                            color: AppColor.black81,
                            fontWeight: FontWeight.w500,
                          ),
                          isDense: true,
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                CommonTextFieldBorder(
                  controller: remarkController,
                  image: Images.information,
                  hintText: 'Remark',
                ),
              ],
              context: context,
            ),
            SizedBox(height: Sizes.height * 0.05),
            Center(
              child: DefaultButton(
                text: feesReceiveData == null ? "Create" : "Update",
                hight: 40,
                width: 150,
                onTap: () {
                  feesReceiveData == null
                      ? postFeesReceive([])
                      : updateFeesReceive([]);
                },
              ),
            ),
            SizedBox(height: Sizes.height * .04),
          ],
        ),
      ),
    );
  }

  Future getLedger() async {
    var response = await ApiService.fetchData(
      "ledger?licence_no=${Preference.getString(PrefKeys.licenseNo)}&branch_id=${Preference.getint(PrefKeys.locationId)}",
    );
    if (response["status"] == true) {
      ledgerList = ledgerListFromJson(response['data']);
    }
  }

  Future getStudent() async {
    var response = await ApiService.fetchData(
      "admissionform?licence_no=${Preference.getString(PrefKeys.licenseNo)}&branch_id=${Preference.getint(PrefKeys.locationId)}",
    );
    if (response["status"] == true) {
      studentList = admissionListFromJson(response['data']);
    }
  }

  Future getStaff() async {
    var response = await ApiService.fetchData(
      "staff?licence_no=${Preference.getString(PrefKeys.licenseNo)}&branch_id=${Preference.getint(PrefKeys.locationId)}",
    );
    if (response["status"] == true) {
      staffList = staffListFromJson(response['data']);
    }
  }

  Future postFeesReceive(List<File> images) async {
    List<http.MultipartFile> files = [];

    if (images.isNotEmpty) {
      for (File image in images) {
        final file = await http.MultipartFile.fromPath(
          'upload_file[]',
          image.path,
        );
        files.add(file);
      }
    }

    final response = await ApiService.uploadMultipleFiles(
      endpoint: 'fees_received',
      fields: {
        'licence_no': Preference.getString(PrefKeys.licenseNo),
        'branch_id': Preference.getint(PrefKeys.locationId).toString(),
        'hosteler_details': studentController.text.trim().toString(),
        'hosteler_id': studentIdController.text.trim().toString(),
        'admission_date': admissionDateController.text.trim().toString(),
        'hosteler_name': studentController.text.trim().toString(),
        'contact_no': contactController.text.trim().toString(),
        'father_name': fatherNameController.text.trim().toString(),
        'course': "",
        'fees_no': feesNumberController.text.trim().toString(),
        'entry_type': "Fees",
        'date': feesDatepicker.text.trim().toString(),
        'ledger_id': ledgerId.toString(),
        'ledger_name': paymentModeController.text.trim().toString(),
        'amount': amountController.text.trim().toString(),
        'narration': narrationController.text.trim().toString(),
        'receive_by': receiveByController.text.trim().toString(),
        'remark': remarkController.text.trim().toString(),
        'installment_no': studentInstallmentController.text.trim().toString(),
        'is_active': "${isChecked ? 1 : 0}",
        'other1': totalFessController.text.toString(),
        'other2': discountController.text.toString(),
        'other3': finalAmountController.text.toString(),
        'other4': totalEMIController.text.toString(),
        'other5': nextEMIAmountController.text.toString(),
      },
      files: files, // will be empty if no image is selected
    );

    if (response["status"] == true) {
      showCustomSnackbarSuccess(context, response['message']);
      Navigator.pop(context, "New Data");
    } else {
      showCustomSnackbarError(context, response['message']);
    }
  }

  Future updateFeesReceive(List<File> images) async {
    List<http.MultipartFile> files = [];

    if (images.isNotEmpty) {
      for (File image in images) {
        final file = await http.MultipartFile.fromPath(
          'upload_file[]',
          image.path,
        );
        files.add(file);
      }
    }

    final response = await ApiService.uploadMultipleFiles(
      endpoint: 'fees_received/${feesReceiveData!.id!}',
      fields: {
        'licence_no': Preference.getString(PrefKeys.licenseNo),
        'branch_id': Preference.getint(PrefKeys.locationId).toString(),
        'hosteler_details': studentController.text.trim().toString(),
        'hosteler_id': studentIdController.text.trim().toString(),
        'admission_date': admissionDateController.text.trim().toString(),
        'hosteler_name': studentController.text.trim().toString(),
        'contact_no': contactController.text.trim().toString(),
        'father_name': fatherNameController.text.trim().toString(),
        'course': "",
        'fees_no': feesNumberController.text.trim().toString(),
        'entry_type': "Fees",
        'date': feesDatepicker.text.trim().toString(),
        'ledger_id': ledgerId.toString(),
        'ledger_name': paymentModeController.text.trim().toString(),
        'amount': amountController.text.trim().toString(),
        'narration': narrationController.text.trim().toString(),
        'receive_by': receiveByController.text.trim().toString(),
        'remark': remarkController.text.trim().toString(),
        'installment_no': studentInstallmentController.text.trim().toString(),
        'is_active': "${isChecked ? 1 : 0}",
        'other1': totalFessController.text.toString(),
        'other2': discountController.text.toString(),
        'other3': finalAmountController.text.toString(),
        'other4': totalEMIController.text.toString(),
        'other5': nextEMIAmountController.text.toString(),
        '_method': 'PUT',
      },
      files: files, // will be empty if no image is selected
    );

    if (response["status"] == true) {
      showCustomSnackbarSuccess(context, response['message']);
      Navigator.pop(context, "New Data");
    } else {
      showCustomSnackbarError(context, response['message']);
    }
  }

  Future getVoucherId() async {
    var response = await ApiService.fetchData(
      "nextfees_no?licence_no=${Preference.getString(PrefKeys.licenseNo)}&branch_id=${Preference.getint(PrefKeys.locationId)}",
    );

    feesNumberController.text = response['next-fees_no'].toString();
  }

  Future getFeesDetails(String studentId) async {
    var response = await ApiService.fetchData(
      "fees_student?hosteler_id=$studentId&session_id=${Preference.getint(PrefKeys.sessionId)}&licence_no=${Preference.getString(PrefKeys.licenseNo)}&branch_id=${Preference.getint(PrefKeys.locationId)}",
    );
    if (response["status"] == true) {
      feesList = feesListFromJson(response['data']);
    }
  }
}
