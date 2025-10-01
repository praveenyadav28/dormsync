import 'package:dorm_sync/model/fees_receive.dart';
import 'package:dorm_sync/model/ledger.dart';
import 'package:dorm_sync/model/voucher_model.dart';
import 'package:dorm_sync/ui/excel/bank_report_excel.dart';
import 'package:dorm_sync/utils/colors.dart';
import 'package:dorm_sync/utils/field_cover.dart';
import 'package:dorm_sync/utils/images.dart';
import 'package:dorm_sync/utils/sizes.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LedgerReportScreen extends StatefulWidget {
  final LedgerList ledger;
  final List<ReceivedListModel> feesReceiveList;
  final List<VoucherModel> voucherList;
  final DateTime fromDate;
  final DateTime toDate;

  const LedgerReportScreen({
    super.key,
    required this.ledger,
    required this.feesReceiveList,
    required this.voucherList,
    required this.fromDate,
    required this.toDate,
  });

  @override
  State<LedgerReportScreen> createState() => _LedgerReportScreenState();
}

class _LedgerReportScreenState extends State<LedgerReportScreen> {
  late double openingBalanceBeforeStartDate;
  late double finalBalance;
  late double totalReceivedInRange;
  late double totalDebitedInRange;

  List<Map<String, dynamic>> reportList = [];
  DateFormat dateFormat = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
    calculateLedgerReport();
  }

  @override
  void didUpdateWidget(covariant LedgerReportScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.ledger.id != oldWidget.ledger.id ||
        widget.fromDate != oldWidget.fromDate ||
        widget.toDate != oldWidget.toDate ||
        widget.voucherList != oldWidget.voucherList ||
        widget.feesReceiveList != oldWidget.feesReceiveList) {
      calculateLedgerReport();
    }
  }

  DateTime parseDate(String dateStr) {
    try {
      return dateFormat.parse(dateStr);
    } catch (_) {
      return DateTime.tryParse(dateStr) ?? DateTime.now();
    }
  }

  void calculateLedgerReport() {
    totalReceivedInRange = 0.0;
    totalDebitedInRange = 0.0;

    double currentRunningBalance =
        double.tryParse(widget.ledger.openingBalance ?? '0') ?? 0;
    if ((widget.ledger.openingType ?? '').toUpperCase() == 'CR') {
      currentRunningBalance = -currentRunningBalance;
    }

    List<Map<String, dynamic>> allTransactions = [];

    for (var item in widget.feesReceiveList) {
      allTransactions.add({
        'date': item.date ?? '',
        'type': 'Fees Received',
        'name': item.hostelerName ?? '',
        'amount': double.tryParse(item.amount ?? '0') ?? 0,
        'role': 'Add',
        'paymentMode': item.ledgerName,
        'isFees': true,
      });
    }

    for (var item in widget.voucherList) {
      double amount = double.tryParse(item.amount ?? '0') ?? 0;
      String? type = item.voucherType;
      // String role = '';
      String action = '';
      String paymentMode = item.paymentMode ?? '-';

      bool isAccountHead =
          (item.accountHead ?? '').trim().toLowerCase() ==
              (widget.ledger.ledgerName ?? '').trim().toLowerCase() &&
          (item.accLedgerId ?? '') == (widget.ledger.id ?? '').toString();

      bool isPaymentMode =
          (item.paymentMode ?? '').trim().toLowerCase() ==
              (widget.ledger.ledgerName ?? '').trim().toLowerCase() &&
          (item.payLedgerId ?? '') == (widget.ledger.id ?? '').toString();

      if (isAccountHead) {
        // role = 'Account Head';
        // Cr: receiving money
        action = ['Expense', 'Payment'].contains(type) ? 'Add' : 'Subtract';
      } else if (isPaymentMode) {
        // role = 'Payment Mode';
        // Dr: paying out money
        action = ['Expense', 'Payment'].contains(type) ? 'Subtract' : 'Add';
      } else {
        continue; // skip unrelated
      }

      allTransactions.add({
        'date': item.voucherDate ?? '',
        'type': '$type Voucher',
        'name': item.accountHead ?? '',
        'amount': amount,
        'role': action,
        'paymentMode': paymentMode,
        'isFees': false,
      });
    }

    allTransactions.sort(
      (a, b) => parseDate(a['date']).compareTo(parseDate(b['date'])),
    );

    for (var item in allTransactions) {
      DateTime transactionDate = parseDate(item['date']);
      if (transactionDate.isBefore(widget.fromDate)) {
        double amount = item['amount'];
        if (item['role'] == 'Add') {
          currentRunningBalance += amount;
        } else if (item['role'] == 'Subtract') {
          currentRunningBalance -= amount;
        }
      } else {
        break;
      }
    }

    openingBalanceBeforeStartDate = currentRunningBalance;
    reportList = [];

    for (var item in allTransactions) {
      DateTime transactionDate = parseDate(item['date']);
      if (!transactionDate.isBefore(widget.fromDate) &&
          !transactionDate.isAfter(widget.toDate)) {
        double amount = item['amount'];
        String currentAction = item['role'];

        if (currentAction == 'Add') {
          currentRunningBalance += amount;
          totalReceivedInRange += amount;
        } else if (currentAction == 'Subtract') {
          currentRunningBalance -= amount;
          totalDebitedInRange += amount;
        }

        reportList.add({
          'date': item['date'],
          'type': item['type'],
          'name': item['name'],
          'amount': amount,
          'role': currentAction,
          'balance': currentRunningBalance,
          'paymentMode': item['paymentMode'],
        });
      }
    }

    finalBalance = currentRunningBalance;
    setState(() {});
  }

  Color getAmountColor(String role) {
    return role == 'Add' ? AppColor.primary : AppColor.red;
  }

  Widget tableHeader(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget tableBody(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 8),
      child: Text(text, textAlign: TextAlign.center),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Sizes.width * 0.015,
        vertical: Sizes.height * 0.025,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          addMasterOutside3(
            children: [
              _balanceTile(
                'Opening Balance',
                openingBalanceBeforeStartDate.abs(),
                openingBalanceBeforeStartDate < 0 ? 'Cr' : 'Dr',
              ),
            ],
            context: context,
          ),
          const SizedBox(height: 16),
          reportList.isEmpty
              ? const Center(child: Text('No transactions in this date range.'))
              : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _headerSection(),
                  const SizedBox(height: 10),
                  _buildTable(),
                ],
              ),
          const SizedBox(height: 20),
          addMasterOutside3(
            children: [
              _summaryTile(
                'Total Received',
                totalReceivedInRange,
                AppColor.primary,
              ),
              _summaryTile('Total Debited', totalDebitedInRange, AppColor.red),
              _balanceTile(
                'Closing Balance',
                finalBalance.abs(),
                finalBalance < 0 ? 'Cr' : 'Dr',
              ),
            ],
            context: context,
          ),
        ],
      ),
    );
  }

  Widget _headerSection() {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          const Text(
            "Transactions:",
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          VerticalDivider(color: AppColor.black81),
          Text(
            "${dateFormat.format(widget.fromDate)} - ${dateFormat.format(widget.toDate)}",
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          const Spacer(),
          IconButton(
            icon: Image.asset(Images.excel),
            onPressed: () async {
              await exportLedgerReportToExcel(reportList);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTable() {
    return Table(
      border: TableBorder.all(color: Colors.grey),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      columnWidths: const {
        0: FlexColumnWidth(1.5),
        1: FlexColumnWidth(1.2),
        2: FlexColumnWidth(2),
        3: FlexColumnWidth(1.5),
        4: FlexColumnWidth(1.5),
        5: FlexColumnWidth(1.2),
      },
      children: [
        TableRow(
          decoration: const BoxDecoration(color: Color(0xffE5FDDD)),
          children: [
            tableHeader('T-Type'),
            tableHeader('T-Date'),
            tableHeader('T-With'),
            tableHeader('Amount'),
            tableHeader('Balance'),
            tableHeader('B-Type'),
          ],
        ),
        ...reportList.map((item) {
          return TableRow(
            decoration: const BoxDecoration(color: Colors.white),
            children: [
              tableBody(item['type']),
              tableBody(item['date']),
              tableBody(item['name']),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 13,
                ),
                child: Text(
                  item['amount'].toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: getAmountColor(item['role'])),
                ),
              ),
              tableBody("₹ ${item['balance'].abs().toStringAsFixed(1)}"),
              tableBody(item['balance'] < 0 ? 'Cr' : 'Dr'),
            ],
          );
        }).toList(),
      ],
    );
  }

  Widget _balanceTile(String label, double amount, String type) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: AppColor.grey,
      ),
      alignment: Alignment.center,
      child: Text(
        '$label : ₹${amount.toStringAsFixed(2)} $type',
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _summaryTile(String label, double amount, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: AppColor.grey,
      ),
      alignment: Alignment.center,
      child: Text(
        '$label : ₹${amount.toStringAsFixed(2)}',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}
