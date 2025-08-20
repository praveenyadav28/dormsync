// Your imports remain unchanged
import 'package:dorm_sync/model/admission.dart';
import 'package:dorm_sync/model/fees.dart';
import 'package:dorm_sync/model/fees_receive.dart';
import 'package:dorm_sync/model/voucher_model.dart';
import 'package:dorm_sync/ui/home/nodues/nodues_util.dart';
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

class NoDuesCheck extends StatefulWidget {
  const NoDuesCheck({super.key});

  @override
  State<NoDuesCheck> createState() => _NoDuesCheckState();
}

class _NoDuesCheckState extends State<NoDuesCheck> {
  List<AdmissionList> studentList = [];

  List<VoucherModel> voucherList = [];
  List<ReceivedListModel> feesReceiveList = [];
  List<FeesList> feesList = [];

  String? studentId;
  TextEditingController studentController = TextEditingController();
  TextEditingController studentIdController = TextEditingController();
  TextEditingController admissionDateController = TextEditingController();
  TextEditingController courseController = TextEditingController();
  TextEditingController fatherNameController = TextEditingController();

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

  List<CombinedTransaction> allTransactions = [];
  double totalCredit = 0;
  double totalDebit = 0;
  double finalBalance = 0;

  void combineAndCalculate() {
    allTransactions.clear();

    // Fees assigned = student has to pay = debit
    for (var entry in feesList) {
      final amount =
          double.tryParse(entry.totalRemaining?.toString() ?? "0") ?? 0;
      allTransactions.add(
        CombinedTransaction(
          source: 'Fees-Entry',
          date: entry.other3,
          description: 'Fees Assigned',
          amount: amount,
          effect: 'debit',
        ),
      );
    }

    // Fees received = student paid = credit
    for (var rec in feesReceiveList) {
      final amount = double.tryParse(rec.amount ?? "0") ?? 0;
      allTransactions.add(
        CombinedTransaction(
          source: 'Fees-Received',
          date: rec.date ?? '',
          description: 'Fees Paid',
          amount: amount,
          effect: 'credit',
        ),
      );
    }

    // Voucher processing
    for (var v in voucherList) {
      final amount = double.tryParse(v.amount ?? "0") ?? 0;
      final voucherType = v.voucherType?.toLowerCase();

      if (voucherType == "payment") {
        allTransactions.add(
          CombinedTransaction(
            source: 'Voucher-Payment',
            date: v.voucherDate ?? '',
            description: 'Refund to student',
            amount: amount,
            effect: 'debit',
          ),
        );
      } else if (voucherType == "receipt") {
        allTransactions.add(
          CombinedTransaction(
            source: 'Voucher-Receipt',
            date: v.voucherDate ?? '',
            description: 'Received from student',
            amount: amount,
            effect: 'credit',
          ),
        );
      } else if (voucherType == "journal") {
        final studentName = studentController.text.trim().toLowerCase();
        final accountHead = v.accountHead?.trim().toLowerCase();
        final paymentMode = v.paymentMode?.trim().toLowerCase();

        if (studentName == accountHead) {
          // Credit case
          allTransactions.add(
            CombinedTransaction(
              source: 'Voucher-Journal',
              date: v.voucherDate ?? '',
              description: 'Journal Credit',
              amount: amount,
              effect: 'credit',
            ),
          );
        } else if (studentName == paymentMode) {
          // Debit case
          allTransactions.add(
            CombinedTransaction(
              source: 'Voucher-Journal',
              date: v.voucherDate ?? '',
              description: 'Journal Debit',
              amount: amount,
              effect: 'debit',
            ),
          );
        }
      }
    }

    // Sort transactions by date
    allTransactions.sort((a, b) => (a.date ?? '').compareTo(b.date ?? ''));

    totalCredit = allTransactions
        .where((txn) => txn.effect == 'credit')
        .fold(0.0, (sum, txn) => sum + txn.amount);

    totalDebit = allTransactions
        .where((txn) => txn.effect == 'debit')
        .fold(0.0, (sum, txn) => sum + txn.amount);

    finalBalance = totalDebit - totalCredit;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Sizes.width * .02,
                vertical: Sizes.height * .01,
              ).copyWith(bottom: Sizes.height * .05),
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
                        const SizedBox(width: 30),
                        Text(
                          "No-Dues",
                          style: TextStyle(
                            color: AppColor.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
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
                      const Expanded(child: Divider()),
                      const Expanded(child: SizedBox()),
                      const Expanded(child: SizedBox()),
                    ],
                  ),
                  SizedBox(height: Sizes.height * .02),
                  addMasterOutside(
                    children: [
                      Row(
                        children: [
                          Image.asset(Images.studentName, height: 35),
                          const SizedBox(width: 5),
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
                              searchStyle: TextStyle(
                                color: AppColor.black,
                                fontWeight: FontWeight.w500,
                              ),
                              suggestionStyle: TextStyle(
                                color: AppColor.black,
                                fontWeight: FontWeight.w500,
                              ),
                              searchInputDecoration: InputDecoration(
                                border: const OutlineInputBorder(),
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
                                final s = selected.item!;
                                studentId = s.studentId;
                                studentController.text = s.studentName ?? '';
                                studentIdController.text = s.studentId ?? '';
                                admissionDateController.text =
                                    s.admissionDate != null
                                        ? DateFormat(
                                          'dd/MM/yyyy',
                                        ).format(s.admissionDate!)
                                        : '';
                                courseController.text = s.course ?? '';
                                fatherNameController.text = s.fatherName ?? '';
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
                  SizedBox(height: Sizes.height * 0.04),
                  Center(
                    child: DefaultButton(
                      text: "Save",
                      hight: 40,
                      width: 150,
                      onTap: () => getNoduesData(),
                    ),
                  ),
                ],
              ),
            ),

            Container(
              height: 35,
              width: double.infinity,
              color: AppColor.primary.withOpacity(0.6),
              alignment: Alignment.center,
              child: const Text(
                "No-Dues Details",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
              ),
            ),
            SizedBox(height: Sizes.height * .02),
            allTransactions.isEmpty
                ? const Center(child: Text("No transactions found"))
                : Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Sizes.width * .02,
                    vertical: Sizes.height * .01,
                  ),
                  child: Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: allTransactions.length,
                        itemBuilder: (context, index) {
                          final txn = allTransactions[index];
                          final isIncoming = txn.effect == 'credit';
                          final isEntry = txn.source == 'Fees-Entry';
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor:
                                  isIncoming
                                      ? Colors.green
                                      : isEntry
                                      ? AppColor.blue
                                      : Colors.red,
                              child: Icon(
                                isIncoming
                                    ? Icons.arrow_downward
                                    : Icons.arrow_upward,
                                color: Colors.white,
                              ),
                            ),
                            title: Text('${txn.source} - ${txn.description}'),
                            subtitle: Text('Date: ${txn.date ?? "N/A"}'),
                            trailing: Text(
                              '₹${txn.amount.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color:
                                    isIncoming
                                        ? Colors.green
                                        : isEntry
                                        ? AppColor.blue
                                        : Colors.red,
                              ),
                            ),
                          );
                        },
                      ),
                      const Divider(thickness: 2),
                      addMasterOutside3(
                        children: [
                          _summaryTile(
                            "Total Fees(Payment) : ₹${totalDebit.abs().toStringAsFixed(2)}",
                            AppColor.blue,
                          ),
                          _summaryTile(
                            "Total Credit : ₹${totalCredit.abs().toStringAsFixed(2)}",
                            Colors.green,
                          ),
                          _summaryTile(
                            'Final Balance : ₹${finalBalance.abs().toStringAsFixed(2)} ${finalBalance < 0 ? "Cr" : "Dr"}',
                            finalBalance <= 0 ? Colors.green : AppColor.red,
                          ),
                        ],
                        context: context,
                      ),
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
      studentList = admissionListFromJson(response['data']);
    }
  }

  Future getNoduesData() async {
    final response = await ApiService.fetchData(
      'alldata_fatch?hosteler_id=$studentId&hosteler_name=${studentController.text.toString()}&licence_no=${Preference.getString(PrefKeys.licenseNo)}&branch_id=${Preference.getint(PrefKeys.locationId)}',
    );

    if (response["status"] == true) {
      print(response);
      feesReceiveList = feesReceiveModelFromJson(
        response['data']['Fees-Received'],
      );
      feesList = feesListFromJson(response['data']['Fees-Entry']);
      voucherList = voucherModelFromJson(response['data']['Vouchers']);
      setState(() {
        combineAndCalculate();
      });
    } else {
      showCustomSnackbarError(context, response['message']);
    }
  }

  Widget _summaryTile(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: AppColor.white,
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}
