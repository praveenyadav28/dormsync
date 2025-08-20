import 'package:dorm_sync/model/fees_report.dart';
import 'package:dorm_sync/utils/api.dart';
import 'package:dorm_sync/utils/colors.dart';
import 'package:dorm_sync/utils/field_cover.dart';
import 'package:dorm_sync/utils/images.dart';
import 'package:dorm_sync/utils/prefence.dart';
import 'package:dorm_sync/utils/reuse.dart';
import 'package:dorm_sync/utils/sizes.dart';
import 'package:dorm_sync/utils/textformfield.dart';
import 'package:flutter/material.dart';

class FeesReportList extends StatefulWidget {
  const FeesReportList({super.key});

  @override
  State<FeesReportList> createState() => _FeesReportListState();
}

class _FeesReportListState extends State<FeesReportList> {
  final TextEditingController searchController = TextEditingController();

  List<FeesReportModel> studentReportList = [];
  List<Map<String, dynamic>> buildings = [];
  List<Map<String, dynamic>> floors = [];
  Map<int, String> floorMap = {};
  Map<int, String> buildingMap = {};
  double totalFees = 0;
  double totalReceived = 0;
  double totalOutstanding = 0;
  String _searchQuery = '';
  int _currentPage = 1;
  static const int _rowsPerPage = 10;

  List<FeesReportModel> get _filteredData {
    if (_searchQuery.isEmpty) return studentReportList;
    final query = _searchQuery.toLowerCase();
    return studentReportList.where((item) {
      return item.toJson().values.any(
        (value) => value?.toString().toLowerCase().contains(query) ?? false,
      );
    }).toList();
  }

  List<FeesReportModel> get _pagedData {
    final start = (_currentPage - 1) * _rowsPerPage;
    final end = start + _rowsPerPage;
    return _filteredData.sublist(start, end.clamp(0, _filteredData.length));
  }

  @override
  void initState() {
    super.initState();
    searchController.addListener(_onSearchChanged);
    _initializeData();
  }

  Future<void> _initializeData() async {
    await Future.wait([getBuildings(), getFloors()]);
    await getStudentList();
    setState(() {});
  }

  void _onSearchChanged() {
    final val = searchController.text;
    if (_searchQuery != val) {
      setState(() {
        _searchQuery = val;
        _currentPage = 1;
      });
    }
  }

  Future<void> getBuildings() async {
    final response = await ApiService.fetchData(
      'building?licence_no=${Preference.getString(PrefKeys.licenseNo)}&branch_id=${Preference.getint(PrefKeys.locationId)}',
    );
    if (response["status"] == true) {
      buildings = List<Map<String, dynamic>>.from(response["data"]);
      buildingMap = {for (var b in buildings) b['id']: b['building']};
    }
  }

  Future<void> getFloors() async {
    final response = await ApiService.fetchData(
      'floor?licence_no=${Preference.getString(PrefKeys.licenseNo)}&branch_id=${Preference.getint(PrefKeys.locationId)}',
    );
    if (response["status"] == true) {
      floors = List<Map<String, dynamic>>.from(response["data"]);
      floorMap = {for (var f in floors) f['id']: f['floor']};
    }
  }

  Future<void> getStudentList() async {
    final response = await ApiService.fetchData(
      "getCombinedData/${Preference.getString(PrefKeys.licenseNo)}/${Preference.getint(PrefKeys.locationId)}/${Preference.getint(PrefKeys.sessionId)}?licence_no=${Preference.getString(PrefKeys.licenseNo)}&branch_id=${Preference.getint(PrefKeys.locationId)}",
    );
    if (response["status"] == true) {
      studentReportList = feesReportModelFromJson(response['data']);

      totalFees = 0;
      totalReceived = 0;

      for (var item in studentReportList) {
        totalFees += item.totalRemaining ?? 0;
        totalReceived += item.studentReceivedAmount ?? 0;
      }

      totalOutstanding = totalFees - totalReceived;
    }
  }

  void _onPageChanged(int page) => setState(() => _currentPage = page);

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  Widget _summaryCard(String text, Color bgColor) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
      ),
    );
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
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 30),
              child: Text(
                "Fees Report",
                style: TextStyle(
                  color: AppColor.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            addMasterOutside(
              children: [
                _summaryCard(
                  "Total Fees  ||  ₹${totalFees.toStringAsFixed(2)}",
                  const Color(0xffE6F77B),
                ),
                _summaryCard(
                  "Received  ||  ₹${totalReceived.toStringAsFixed(2)}",
                  const Color(0xffA8EAB0),
                ),
                _summaryCard(
                  "Outstanding  ||  ₹${totalOutstanding.toStringAsFixed(2)}",
                  const Color(0xffF6B1B1),
                ),

                CommonTextField(
                  controller: searchController,
                  image: Images.hosteler,
                  hintText: "Hostler Name",
                ),
              ],
              context: context,
            ),
            const SizedBox(height: 10),
            Table(
              columnWidths: const {
                0: FlexColumnWidth(.6),
                1: FlexColumnWidth(1),
                2: FlexColumnWidth(1),
                3: FlexColumnWidth(1),
                4: FlexColumnWidth(.7),
                5: FlexColumnWidth(.7),
                6: FlexColumnWidth(.8),
                7: FlexColumnWidth(.6),
                8: FlexColumnWidth(.6),
                9: FlexColumnWidth(.6),
                10: FlexColumnWidth(.7),
                11: FlexColumnWidth(.7),
                12: FlexColumnWidth(.8),
              },
              border: TableBorder.all(color: Colors.grey),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                TableRow(
                  decoration: const BoxDecoration(color: Color(0xffE5FDDD)),
                  children: [
                    tableHeader('H-ID'),
                    tableHeader('Adm. Date'),
                    tableHeader('Hosteler Name'),
                    tableHeader('Father Name'),
                    tableHeader('EMI\n<Total>'),
                    tableHeader('EMI\nReceived'),
                    tableHeader('Building'),
                    tableHeader('Floor'),
                    tableHeader('Type'),
                    tableHeader('Room'),
                    tableHeader('Fees'),
                    tableHeader('Received'),
                    tableHeader('Remaining'),
                    tableHeader('Action'),
                  ],
                ),
                ..._pagedData.map((item) {
                  return TableRow(
                    decoration: BoxDecoration(color: AppColor.white),
                    children: [
                      tableBody(item.hostelerId ?? ''),
                      tableBody(item.admissionDate ?? ''),
                      tableBody(item.hostelerName ?? ''),
                      tableBody(item.fatherName ?? ''),
                      tableBody(item.emiTotal?.toString() ?? ''),
                      tableBody(item.emiRecived?.toString() ?? ''),
                      tableBody(buildingMap[item.buildingId] ?? '-'),
                      tableBody(floorMap[item.floorId] ?? '-'),
                      tableBody(item.roomType ?? '-'),
                      tableBody(item.roomNo ?? '-'),
                      tableBody(item.totalRemaining?.toString() ?? '0'),
                      tableBody(item.studentReceivedAmount?.toString() ?? '0'),
                      tableBody(
                        "${(item.totalRemaining ?? 0) - (item.studentReceivedAmount ?? 0)}",
                      ),
                      TableCell(
                        child: IconButton(
                          icon: Image.asset(height: 20, Images.view),
                          onPressed: () {
                            // View details
                          },
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed:
                      _currentPage > 1
                          ? () => _onPageChanged(_currentPage - 1)
                          : null,
                ),
                Text(
                  'Page $_currentPage of ${(_filteredData.length / _rowsPerPage).ceil()}',
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed:
                      _currentPage <
                              (_filteredData.length / _rowsPerPage).ceil()
                          ? () => _onPageChanged(_currentPage + 1)
                          : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
