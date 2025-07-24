import 'dart:io';

import 'package:dorm_sync/model/fees_receive.dart';
import 'package:dorm_sync/model/ledger.dart';
import 'package:dorm_sync/model/staff.dart';
import 'package:dorm_sync/model/voucher_model.dart';
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
  VoucherModel? voucherData;

  String? selectedVoucherType;
  List<LedgerList> ledgerListSearch = [];
  List<StaffList> staffList = [];

  final TextEditingController voucherNumberController = TextEditingController();
  final TextEditingController prefixNameController = TextEditingController();
  TextEditingController voucherDatepicker = TextEditingController(
    text: DateFormat('dd/MM/yyyy').format(DateTime.now()),
  );
  final TextEditingController paymentModeController = TextEditingController();
  final TextEditingController accountHeadController = TextEditingController();
  final TextEditingController paidByController = TextEditingController();
  final TextEditingController narrationController = TextEditingController();
  final TextEditingController remarkController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  final FocusNode paymentModeFocusNode = FocusNode();
  final FocusNode amountFocusNode = FocusNode();
  final FocusNode debitFocusNode = FocusNode();
  final FocusNode creditFocusNode = FocusNode();

  LedgerList? selectedPaymentLedger;
  LedgerList? selectedLedgerLedger;
  StaffList? selectedStaff;

  List<LedgerList> paymentModeLedgers = [];
  List<LedgerList> accountHeadLedgers = [];

  String _previousText = '';

  String? accountHeadType = '';

  double? accountHeadBalance;
  double? payModeBalance;

  int? payLedgerId;
  int? accLedgerId;

  List<String> voucherTypes = [
    'Receipt',
    'Expense',
    'Journal',
    'Contra',
    'Payment',
  ];

  bool isChecked = false;
  //Ledger Balance
  LedgerList? selectedLedger;
  List<ReceivedListModel> feesReceiveList = [];
  List<VoucherModel> voucherList = [];

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && voucherData == null) {
        voucherData = args as VoucherModel;

        selectedVoucherType = voucherData!.voucherType;
        voucherNumberController.text = voucherData!.voucherNo.toString();
        voucherDatepicker.text = voucherData!.voucherDate ?? "";
        accountHeadController.text = voucherData!.accountHead ?? "";
        accountHeadBalance = double.parse(voucherData!.accountBalance ?? "0");
        paymentModeController.text = voucherData!.paymentMode ?? "";
        payModeBalance = double.parse(
          voucherData!.paymentBalance?.toString() ?? "0",
        );
        amountController.text = voucherData!.amount?.toString() ?? "0";
        narrationController.text = voucherData!.narration?.toString() ?? "0";
        paidByController.text = voucherData!.paidBy?.toString() ?? "0";
        remarkController.text = voucherData!.remark?.toString() ?? "0";
        payLedgerId = int.tryParse(voucherData!.payLedgerId!);
        accLedgerId = int.tryParse(voucherData!.accLedgerId!);
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
    await getStaff();

    setState(() {
      paymentModeLedgers =
          ledgerListSearch
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
      accountHeadLedgers = ledgerListSearch;
    } else if (voucherType == "Expense") {
      accountHeadLedgers =
          ledgerListSearch
              .where((ledger) => ledger.ledgerGroup == "Expense")
              .toList();
    } else if (voucherType == "Contra") {
      accountHeadLedgers =
          ledgerListSearch
              .where(
                (ledger) =>
                    ledger.ledgerGroup == "Bank Account" ||
                    ledger.ledgerGroup == "Cash In Hand",
              )
              .toList();
    }
    selectedLedgerLedger = null;
    accountHeadBalance = 0;
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
                            accLedgerId = val.item!.id;
                            selectedLedgerLedger = val.item;
                            accountHeadType =
                                selectedLedgerLedger?.other1 ?? '';
                          });
                          if (accountHeadType != "STU") {
                            geLedgerData(true);
                          } else {
                            accountHeadBalance = 0;
                          }
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
                accountHeadBalance != null && accountHeadType != "STU"
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
                          "Balance : ₹${accountHeadBalance!.toStringAsFixed(2)}",
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
                            payLedgerId = val.item!.id;
                            geLedgerData(false);
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
                payModeBalance != null
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
                          "Balance : ₹${payModeBalance!.toStringAsFixed(2)}",
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
                text: voucherData == null ? "Create" : "Update",
                hight: 40,
                width: 150,
                onTap: () {
                  voucherData != null ? updateVoucher([]) : postVoucher([]);
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
      ledgerListSearch = ledgerListFromJson(response['data']);
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
        'pay_ladger_id': payLedgerId.toString(),
        'acc_ladger_id': accLedgerId.toString(),
        'payment_mode': paymentModeController.text.toString(),
        'payment_balance': payModeBalance.toString(),
        'account_head': accountHeadController.text.toString(),
        'account_balance': accountHeadBalance.toString(),
        'amount': amountController.text.toString(),
        'narration': narrationController.text.toString(),
        'paid_by': paidByController.text.toString(),
        'remark': remarkController.text.trim().toString(),
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

  Future updateVoucher(List<File> images) async {
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
      endpoint: 'voucher/${voucherData!.id}',
      fields: {
        'licence_no': Preference.getString(PrefKeys.licenseNo),
        'branch_id': Preference.getint(PrefKeys.locationId).toString(),
        'voucher_type': selectedVoucherType!,
        'voucher_date': voucherDatepicker.text.trim().toString(),
        'voucher_no': voucherNumberController.text.trim().toString(),
        'pay_ladger_id': payLedgerId.toString(),
        'acc_ladger_id': accLedgerId.toString(),
        'payment_mode': paymentModeController.text.toString(),
        'payment_balance': payModeBalance.toString(),
        'account_head': accountHeadController.text.toString(),
        'account_balance': accountHeadBalance.toString(),
        'amount': amountController.text.toString(),
        'narration': narrationController.text.toString(),
        'paid_by': paidByController.text.toString(),
        'remark': remarkController.text.trim().toString(),
        '_method': "PUT",
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

  Future geLedgerData(bool isAccountHead) async {
    final response = await ApiService.fetchData(
      'ledger_id_name?ledger_id=${isAccountHead ? accLedgerId : payLedgerId}&ledger_name=${isAccountHead ? accountHeadController.text.trim() : paymentModeController.text.trim()}',
    );

    if (response["status"] == true) {
      feesReceiveList = feesReceiveModelFromJson(
        response['data']['Fees-Received'],
      );
      selectedLedger = ledgerListFromJson(response['data']['Ledger'])[0];
      voucherList = voucherModelFromJson(response['data']['vouchere']);

      calculateLedgerReport(isAccountHead);
    } else {
      showCustomSnackbarError(context, response['message']);
    }
  }

  void calculateLedgerReport(bool isAccountHead) {
    double currentRunningBalance =
        double.tryParse(selectedLedger?.openingBalance ?? '0') ?? 0;

    if ((selectedLedger?.openingType ?? '').toUpperCase() == 'CR') {
      currentRunningBalance = -currentRunningBalance;
    }

    List<Map<String, dynamic>> allTransactions = [];

    for (var item in feesReceiveList) {
      allTransactions.add({
        'date': item.date ?? '',
        'amount': double.tryParse(item.amount ?? '0') ?? 0,
        'role': 'Add',
      });
    }

    for (var item in voucherList) {
      double amount = double.tryParse(item.amount ?? '0') ?? 0;
      String? type = item.voucherType;
      String role = '';

      bool isAccountHeadMatch =
          (item.accountHead ?? '').trim().toLowerCase() ==
              (selectedLedger?.ledgerName ?? '').trim().toLowerCase() &&
          (item.accLedgerId ?? '') == (selectedLedger?.id ?? '').toString();

      bool isPaymentModeMatch =
          (item.paymentMode ?? '').trim().toLowerCase() ==
              (selectedLedger?.ledgerName ?? '').trim().toLowerCase() &&
          (item.payLedgerId ?? '') == (selectedLedger?.id ?? '').toString();

      if (isAccountHeadMatch) {
        role =
            ['Expense', 'Payment', 'Contra'].contains(type)
                ? 'Add'
                : 'Subtract';
      } else if (isPaymentModeMatch) {
        role =
            ['Expense', 'Payment', 'Contra'].contains(type)
                ? 'Subtract'
                : 'Add';
      } else {
        continue;
      }

      allTransactions.add({
        'date': item.voucherDate ?? '',
        'amount': amount,
        'role': role,
      });
    }

    allTransactions.sort(
      (a, b) => parseDate(a['date']).compareTo(parseDate(b['date'])),
    );

    for (var item in allTransactions) {
      DateTime transactionDate = parseDate(item['date']);
      if (!transactionDate.isAfter(DateTime.now())) {
        double amount = item['amount'];
        if (item['role'] == 'Add') {
          currentRunningBalance += amount;
        } else if (item['role'] == 'Subtract') {
          currentRunningBalance -= amount;
        }
      }
    }

    if (isAccountHead) {
      accountHeadBalance = currentRunningBalance;
    } else {
      payModeBalance = currentRunningBalance;
    }

    setState(() {});
  }

  DateTime parseDate(String dateStr) {
    try {
      return DateFormat('dd/MM/yyyy').parse(dateStr);
    } catch (_) {
      return DateTime.tryParse(dateStr) ?? DateTime.now();
    }
  }
}
