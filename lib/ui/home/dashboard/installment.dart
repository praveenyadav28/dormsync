import 'package:dorm_sync/model/fees.dart';
import 'package:dorm_sync/utils/api.dart';
import 'package:dorm_sync/utils/buttons.dart';
import 'package:dorm_sync/utils/colors.dart';
import 'package:dorm_sync/utils/field_cover.dart';
import 'package:dorm_sync/utils/prefence.dart';
import 'package:dorm_sync/utils/reuse.dart';
import 'package:dorm_sync/utils/sizes.dart';
import 'package:dorm_sync/utils/images.dart';
import 'package:dorm_sync/utils/textformfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AllInstallmentsScreen extends StatefulWidget {
  const AllInstallmentsScreen({Key? key}) : super(key: key);

  @override
  State<AllInstallmentsScreen> createState() => _AllInstallmentsScreenState();
}

class _AllInstallmentsScreenState extends State<AllInstallmentsScreen> {
  final TextEditingController fromDateController = TextEditingController(
    text: DateFormat('dd/MM/yyyy').format(DateTime.now()),
  );
  final TextEditingController toDateController = TextEditingController(
    text: DateFormat(
      'dd/MM/yyyy',
    ).format(DateTime.now().add(const Duration(days: 30))),
  );
  final TextEditingController searchController = TextEditingController();

  final DateFormat dateFormat = DateFormat('dd/MM/yyyy');

  List<Map<String, dynamic>> flattenedInstallments = [];
  List<Map<String, dynamic>> filteredInstallments = [];

  String _searchQuery = "";

  Future<void> fetchInstallments() async {
    final response = await ApiService.fetchData(
      "fees_isactive?session_id=${Preference.getint(PrefKeys.sessionId)}",
    );

    if (response['status'] == true) {
      final List<FeesList> feesList = feesListFromJson(response['data']);
      List<Map<String, dynamic>> flattened = [];

      for (final fee in feesList) {
        for (final installment in fee.installmentStructure ?? []) {
          DateTime? parsedDate;
          try {
            parsedDate = dateFormat.parse(installment.date ?? "");
          } catch (_) {}

          flattened.add({
            "hostelerName": fee.hostelerName,
            "fatherName": fee.fatherName,
            "totalRemaining": fee.totalRemaining,
            "installmentDate": installment.date,
            "installmentPrice": installment.price,
            "parsedDate": parsedDate,
          });
        }
      }

      setState(() {
        flattenedInstallments = flattened;
        applyFilters();
      });
    }
  }

  void applyFilters() {
    DateTime? from, to;
    try {
      from = dateFormat.parse(fromDateController.text);
      to = dateFormat.parse(toDateController.text);
    } catch (_) {
      return;
    }

    String query = _searchQuery.toLowerCase();

    final filtered =
        flattenedInstallments.where((item) {
            final date = item["parsedDate"] as DateTime?;
            final name = (item["hostelerName"] ?? "").toString().toLowerCase();
            final father = (item["fatherName"] ?? "").toString().toLowerCase();

            return date != null &&
                !date.isBefore(from!) &&
                !date.isAfter(to!) &&
                (name.contains(query) || father.contains(query));
          }).toList()
          ..sort(
            (a, b) => (a["parsedDate"] as DateTime).compareTo(
              b["parsedDate"] as DateTime,
            ),
          );

    setState(() {
      filteredInstallments = filtered;
    });
  }

  @override
  void dispose() {
    fromDateController.dispose();
    toDateController.dispose();
    searchController.dispose();
    super.dispose();
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
                    "Installment-Reminder",
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
            addMasterOutside3(
              children: [
                DateRange(
                  datepickar1: fromDateController,
                  datepickar2: toDateController,
                ),

                Center(
                  child: DefaultButton(
                    text: "Save",
                    hight: 30,
                    width: 140,
                    onTap: () async {
                      await fetchInstallments();
                    },
                  ),
                ),
                CommonTextField(
                  controller: searchController,
                  image: Images.hosteler,
                  hintText: "Search",
                  onChanged: (value) {
                    _searchQuery = value;
                    applyFilters();
                  },
                ),
              ],
              context: context,
            ),
            const SizedBox(height: 10),
            Table(
              columnWidths: const {
                0: FlexColumnWidth(1),
                1: FlexColumnWidth(1),
                2: FlexColumnWidth(1),
                3: FlexColumnWidth(1),
                4: FlexColumnWidth(1),
              },
              border: TableBorder.all(color: Colors.grey),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                TableRow(
                  decoration: const BoxDecoration(color: Color(0xffE5FDDD)),
                  children: [
                    tableHeader("Hosteler"),
                    tableHeader("Father"),
                    tableHeader("Installment Date"),
                    tableHeader("Installment Price"),
                    tableHeader("Fees Assigned"),
                  ],
                ),
                ...filteredInstallments.map((item) {
                  return TableRow(
                    decoration: const BoxDecoration(color: Colors.white),
                    children: [
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            item["hostelerName"] ?? "",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      tableBody(item["fatherName"] ?? ""),
                      tableBody(item["installmentDate"] ?? ""),
                      tableBody("${item["installmentPrice"] ?? 0}"),
                      tableBody("${item["totalRemaining"] ?? 0}"),
                    ],
                  );
                }).toList(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
