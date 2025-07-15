import 'dart:io';

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

class CreateVoucher extends StatefulWidget {
  const CreateVoucher({super.key});

  @override
  State<CreateVoucher> createState() => _CreateVoucherState();
}

class _CreateVoucherState extends State<CreateVoucher> {
  String? selectedVoucherType;
  List<LedgerList> ledgerList = [];
  List<StaffList> staffList = [];

  final TextEditingController voucherNumberController = TextEditingController();
  final TextEditingController prefixNameController = TextEditingController();
  TextEditingController voucherDatepicker = TextEditingController(
    text: DateFormat('dd/MM/yyyy').format(DateTime.now()),
  );
  final TextEditingController paymentModeController = TextEditingController();
  final TextEditingController accountHeadController = TextEditingController();
  final TextEditingController paidByController = TextEditingController();
  final TextEditingController studentInstallmentController =
      TextEditingController();
  final TextEditingController narrationController = TextEditingController();
  final TextEditingController remarkController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  final FocusNode paymentModeFocusNode = FocusNode();
  final FocusNode amountFocusNode = FocusNode();
  final FocusNode debitFocusNode = FocusNode();
  final FocusNode creditFocusNode = FocusNode();

  LedgerList? selectedPaymentLedger;
  LedgerList? selectedAccountHeadLedger;
  StaffList? selectedStaff;

  List<LedgerList> paymentModeLedgers = [];
  List<LedgerList> accountHeadLedgers = [];

  String _previousText = '';

  String? paymentBalance = '';
  String? accountHeadBalance = '';
  String? accountHeadType = '';

  List<String> voucherTypes = [
    'Receipt',
    'Expense',
    'Journal',
    'Contra',
    'Payment',
  ];

  String studentId = '';
  bool isChecked = false;

  @override
  void initState() {
    super.initState();
    getVoucherId().then((_) {
      setState(() {});
    });
    fetchInitialData();
  }

  Future<void> fetchInitialData() async {
    await getLedger();
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
  }

  void updateAccountHeadLedgers(String voucherType) {
    if (voucherType == "Receipt" ||
        voucherType == "Journal" ||
        voucherType == 'Payment') {
      accountHeadLedgers = ledgerList;
    } else if (voucherType == "Expense") {
      accountHeadLedgers =
          ledgerList
              .where((ledger) => ledger.ledgerGroup == "Expense")
              .toList();
    } else if (voucherType == "Contra") {
      accountHeadLedgers =
          ledgerList
              .where(
                (ledger) =>
                    ledger.ledgerGroup == "Bank Account" ||
                    ledger.ledgerGroup == "Cash In Hand",
              )
              .toList();
    }
    selectedAccountHeadLedger = null;
    accountHeadBalance = '';
    accountHeadType = '';
  }

  String getAmountLabel() {
    switch (selectedVoucherType) {
      case 'Receipt':
        return "Credit Amount";
      case 'Expense':
        return "Debit Amount";
      case 'Payment':
        return "Debit Amount";
      case 'Contra':
        return "Amount";
      case 'Journal':
        return "Amount";
      default:
        return "Amount";
    }
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
                    "Voucher Entry",
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
                Row(
                  children: [
                    Image.asset(Images.voucher, height: 30),
                    SizedBox(width: 5),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: selectedVoucherType,
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: AppColor.primary,
                        ),
                        hint: Text(
                          "--Voucher Type--",
                          style: TextStyle(
                            color: AppColor.black81,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            selectedVoucherType = value;
                            updateAccountHeadLedgers(value!);
                          });
                        },
                        items:
                            voucherTypes.map((voucherType) {
                              return DropdownMenuItem(
                                value: voucherType,
                                child: Text(
                                  voucherType,
                                  style: TextStyle(
                                    color: AppColor.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              );
                            }).toList(),
                        decoration: InputDecoration(
                          isDense: true,
                          border: UnderlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                CommonTextField(
                  controller: voucherNumberController,
                  image: Images.businessType,
                  hintText: 'Voucher No.*',
                ),
                CommonTextField(
                  image: Images.year,
                  onPressIcon: () async {
                    selectDate(context, voucherDatepicker).then((onValue) {
                      setState(() {});
                    });
                  },
                  controller: voucherDatepicker,
                  onChanged: (val) {
                    bool isValid = smartDateOnChanged(
                      value: val,
                      controller: voucherDatepicker,
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
                Container(),
                Row(
                  children: [
                    Image.asset(Images.reports),
                    SizedBox(width: 5),
                    Expanded(
                      child: SearchField<LedgerList>(
                        controller: accountHeadController,
                        hint: 'Account Head',
                        suggestionStyle: TextStyle(
                          color: AppColor.black,
                          fontWeight: FontWeight.w500,
                        ),
                        searchStyle: TextStyle(
                          color: AppColor.black,
                          fontWeight: FontWeight.w500,
                        ),
                        suggestions:
                            accountHeadLedgers
                                .map(
                                  (ledger) => SearchFieldListItem<LedgerList>(
                                    ledger.ledgerName ?? '',
                                    item: ledger,
                                  ),
                                )
                                .toList(),
                        onSuggestionTap: (val) {
                          setState(() {
                            accountHeadController.text = val.item!.ledgerName!;
                            studentId = val.item!.id.toString();
                            selectedAccountHeadLedger = val.item;
                            accountHeadBalance =
                                selectedAccountHeadLedger?.openingBalance ?? '';
                            accountHeadType =
                                selectedAccountHeadLedger?.other1 ?? '';
                          });
                          FocusScope.of(
                            context,
                          ).requestFocus(paymentModeFocusNode);
                        },
                        searchInputDecoration: InputDecoration(
                          suffixIcon: Text(
                            "$accountHeadType",
                            style: TextStyle(
                              color: AppColor.primary2,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              height: 2,
                            ),
                          ),
                          floatingLabelStyle: TextStyle(
                            color: AppColor.black,
                            fontWeight: FontWeight.w500,
                          ),
                          hintStyle: TextStyle(
                            color: AppColor.black81,
                            fontWeight: FontWeight.w500,
                          ),
                          isDense: true,
                          border: UnderlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                accountHeadBalance != null
                    ? Center(
                      child: Container(
                        height: 50,
                        margin: EdgeInsets.only(right: Sizes.width * .03),
                        width: double.infinity,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColor.grey,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          "Balance : ₹$accountHeadBalance",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    )
                    : Container(),
                Row(
                  children: [
                    Image.asset(Images.fees),
                    SizedBox(width: 5),
                    Expanded(
                      child: SearchField<LedgerList>(
                        controller: paymentModeController,

                        focusNode: paymentModeFocusNode,
                        hint: 'Payment Mode',
                        suggestionStyle: TextStyle(
                          color: AppColor.black,
                          fontWeight: FontWeight.w500,
                        ),
                        searchStyle: TextStyle(
                          color: AppColor.black,
                          fontWeight: FontWeight.w500,
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
                            selectedPaymentLedger = val.item;
                            paymentBalance =
                                selectedPaymentLedger?.openingBalance ?? '';
                          });
                          if (selectedVoucherType == 'Journal') {
                            FocusScope.of(context).requestFocus(debitFocusNode);
                          } else {
                            FocusScope.of(
                              context,
                            ).requestFocus(amountFocusNode);
                          }
                        },
                        searchInputDecoration: InputDecoration(
                          floatingLabelStyle: TextStyle(
                            color: AppColor.black,
                            fontWeight: FontWeight.w500,
                          ),
                          hintStyle: TextStyle(
                            color: AppColor.black81,
                            fontWeight: FontWeight.w500,
                          ),
                          isDense: true,
                          border: UnderlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                paymentBalance != null
                    ? Center(
                      child: Container(
                        height: 50,
                        margin: EdgeInsets.only(right: Sizes.width * .03),
                        width: double.infinity,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColor.grey,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          "Balance : ₹$paymentBalance",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    )
                    : Container(),
              ],
              context: context,
            ),
            addMasterOutside3(
              children: [
                CommonTextField(
                  focuesNode: amountFocusNode,
                  controller: amountController,
                  image: Images.openingBalance,
                  hintText: '${getAmountLabel()}*',
                ),
                CommonTextField(
                  controller: narrationController,
                  image: Images.information,
                  hintText: 'Narration',
                ),
                if (accountHeadType == 'STU')
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
                                border: UnderlineInputBorder(),
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
                    SizedBox(width: 5),
                    Expanded(
                      child: SearchField<StaffList>(
                        controller: paidByController,
                        hint: 'Paid By',
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
                            paidByController.text = val.item!.staffName!;
                          });
                        },
                        searchInputDecoration: InputDecoration(
                          floatingLabelStyle: TextStyle(
                            color: AppColor.black,
                            fontWeight: FontWeight.w500,
                          ),
                          hintStyle: TextStyle(
                            color: AppColor.black81,
                            fontWeight: FontWeight.w500,
                          ),
                          isDense: true,
                          border: UnderlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                CommonTextField(
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
                text: "Create",
                hight: 40,
                width: 150,
                onTap: () {
                  postVoucher([]);
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
      "ledger?licence_no=${Preference.getString(PrefKeys.licenseNo)}",
    );
    if (response["status"] == true) {
      ledgerList = ledgerListFromJson(response['data']);
    }
  }

  Future getStaff() async {
    var response = await ApiService.fetchData(
      "staff?licence_no=${Preference.getString(PrefKeys.licenseNo)}",
    );
    if (response["status"] == true) {
      staffList = staffListFromJson(response['data']);
    }
  }

  Future postVoucher(List<File> images) async {
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
      endpoint: 'voucher',
      fields: {
        'licence_no': Preference.getString(PrefKeys.licenseNo),
        'branch_id': Preference.getint(PrefKeys.locationId).toString(),
        'voucher_type': selectedVoucherType!,
        'voucher_date': voucherDatepicker.text.trim().toString(),
        'voucher_no': voucherNumberController.text.trim().toString(),
        'payment_mode': paymentModeController.text.toString(),
        'payment_balance': paymentBalance ?? '0',
        'account_head': accountHeadController.text.toString(),
        'account_balance': accountHeadBalance ?? '0',
        'amount': amountController.text.toString(),
        'narration': narrationController.text.toString(),
        'paid_by': paidByController.text.toString(),
        'remark': remarkController.text.trim().toString(),
        'other1': studentId,
        'other2': studentInstallmentController.text.toString(),
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
    var response = await ApiService.fetchData("next-vouchere-no");

    voucherNumberController.text = response['next-voucher-no'].toString();
  }
}
