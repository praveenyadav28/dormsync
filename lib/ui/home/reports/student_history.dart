import 'package:dorm_sync/utils/reuse.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dorm_sync/model/assign_report.dart';
import 'package:dorm_sync/utils/api.dart';
import 'package:dorm_sync/utils/buttons.dart';
import 'package:dorm_sync/utils/colors.dart';
import 'package:dorm_sync/utils/field_cover.dart';
import 'package:dorm_sync/utils/images.dart';
import 'package:dorm_sync/utils/sizes.dart';
import 'package:dorm_sync/utils/textformfield.dart';

class StudentHistoryList extends StatefulWidget {
  const StudentHistoryList({super.key});

  @override
  State<StudentHistoryList> createState() => _StudentHistoryListState();
}

class _StudentHistoryListState extends State<StudentHistoryList> {
  final TextEditingController datepickarfrom = TextEditingController(
    text: DateFormat(
      'dd/MM/yyyy',
    ).format(DateTime.now().subtract(const Duration(days: 150))),
  );
  final TextEditingController datepickarto = TextEditingController(
    text: DateFormat(
      'dd/MM/yyyy',
    ).format(DateTime.now().add(const Duration(days: 150))),
  );
  final TextEditingController searchController = TextEditingController();

  List<StudentReportList> studentReportList = [];
  List<Map<String, dynamic>> buildings = [];
  List<Map<String, dynamic>> floors = [];
  Map<int, String> floorMap = {};
  Map<int, String> buildingMap = {};

  bool _showExHostelers = false;
  bool _showExHostlerList = false;
  String _searchQuery = '';
  int _currentPage = 1;

  List<StudentReportList> get _filteredData {
    if (_searchQuery.isEmpty) return studentReportList;
    final query = _searchQuery.toLowerCase();
    return studentReportList.where((item) {
      final itemMap = item.toJson();
      return itemMap.values.any(
        (value) => value?.toString().toLowerCase().contains(query) ?? false,
      );
    }).toList();
  }

  List<StudentReportList> get _pagedData {
    final start = (_currentPage - 1) * 10;
    final end = start + 10;
    return _filteredData.sublist(
      start,
      end > _filteredData.length ? _filteredData.length : end,
    );
  }

  @override
  void initState() {
    searchController.addListener(_onSearchChanged);
    super.initState();
    getBuildings().then((_) {
      getFloors().then((_) {
        getStudentList().then((_) => setState(() {}));
      });
    });
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
    final response = await ApiService.fetchData('building');
    if (response["status"] == true) {
      buildings = List<Map<String, dynamic>>.from(response["data"]);
      buildingMap = {for (var b in buildings) b['id']: b['building']};
    }
  }

  Future<void> getFloors() async {
    final response = await ApiService.fetchData('floor');
    if (response["status"] == true) {
      floors = List<Map<String, dynamic>>.from(response["data"]);
      floorMap = {for (var f in floors) f['id']: f['floor']};
    }
  }

  Future<void> getStudentList() async {
    final response = await ApiService.fetchData(
      "student/assign?from_date=${datepickarfrom.text}&to_date=${datepickarto.text}",
    );
    if (response["status"] == true) {
      _showExHostlerList = true;
      studentReportList = studentReportListFromJson(response['data']);
    }
  }

  Future<void> getStudentDiactivateList() async {
    final response = await ApiService.fetchData(
      "active/status?from_date=${datepickarfrom.text}&to_date=${datepickarto.text}",
    );
    if (response["status"] == true) {
      _showExHostlerList = false;
      studentReportList = studentReportListFromJson(response['data']);
    }
  }

  void _onPageChanged(int page) => setState(() => _currentPage = page);

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
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
                  Text(
                    "     Student Report",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            addMasterOutside3(
              children: [
                DateRange(
                  datepickar1: datepickarfrom,
                  datepickar2: datepickarto,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Show Ex-Hostelers',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    Checkbox(
                      activeColor: AppColor.primary,
                      value: _showExHostelers,
                      onChanged:
                          (value) =>
                              setState(() => _showExHostelers = value ?? false),
                    ),
                  ],
                ),
                Center(
                  child: DefaultButton(
                    text: "Save",
                    hight: 30,
                    width: 140,
                    onTap: () {
                      _showExHostelers
                          ? getStudentDiactivateList().then(
                            (_) => setState(() {}),
                          )
                          : getStudentList().then((_) => setState(() {}));
                    },
                  ),
                ),
              ],
              context: context,
            ),
            Container(
              height: 40,
              margin: const EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                color: AppColor.white,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  children: [
                    const Text(
                      "Total Hostelers",
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    Container(
                      width: 1,
                      height: 36,
                      color: AppColor.black81,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                    ),
                    Text(
                      "${studentReportList.length}",
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const Spacer(),
                    Container(
                      padding: EdgeInsets.all(4),
                      width: Sizes.width * .18,
                      child: CommonTextFieldBorder(
                        controller: searchController,
                        image: Images.hosteler,
                        hintText: "Search",
                      ),
                    ),
                    IconButton(icon: Image.asset(Images.pdf), onPressed: () {}),
                    IconButton(
                      icon: Image.asset(Images.excel),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
            Table(
              columnWidths:
                  !_showExHostlerList
                      ? const {
                        0: FlexColumnWidth(.7),
                        1: FlexColumnWidth(.9),
                        2: FlexColumnWidth(1),
                        3: FlexColumnWidth(1),
                        4: FlexColumnWidth(1),
                      }
                      : const {
                        0: FlexColumnWidth(.7),
                        1: FlexColumnWidth(.9),
                        2: FlexColumnWidth(1),
                        3: FlexColumnWidth(1),
                        4: FlexColumnWidth(1),
                        5: FlexColumnWidth(.7),
                        6: FlexColumnWidth(.7),
                        7: FlexColumnWidth(.7),
                        8: FlexColumnWidth(.7),
                        9: FlexColumnWidth(1),
                      },
              border: TableBorder.all(color: Colors.grey),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                // Table Header Row
                TableRow(
                  decoration: BoxDecoration(color: Color(0xffE5FDDD)),
                  children:
                      !_showExHostlerList
                          ? [
                            tableHeader('H-ID'),
                            tableHeader('Admission Date'),
                            tableHeader('Hosteler Name'),
                            tableHeader('Father Name'),
                            tableHeader('Contact Details'),
                          ]
                          : [
                            tableHeader('H-ID'),
                            tableHeader('Admission Date'),
                            tableHeader('Hosteler Name'),
                            tableHeader('Father Name'),
                            tableHeader('Contact Details'),
                            tableHeader('Building'),
                            tableHeader('Floor'),
                            tableHeader('Type'),
                            tableHeader('Room'),
                          ],
                ),
                // Table Data Rows
                ..._pagedData.map((item) {
                  return TableRow(
                    decoration: BoxDecoration(color: AppColor.white),
                    children:
                        !_showExHostlerList
                            ? [
                              tableBody(item.studentId ?? ''),
                              tableBody(item.admissionDate ?? ""),
                              tableBody(item.studentName ?? ''),
                              tableBody(item.fatherName ?? ''),
                              tableBody(item.primaryContactNo ?? ''),
                            ]
                            : [
                              tableBody(item.studentId ?? ''),
                              tableBody(item.admissionDate ?? ""),
                              tableBody(item.studentName ?? ''),
                              tableBody(item.fatherName ?? ''),
                              tableBody(item.primaryContactNo ?? ''),
                              tableBody(buildingMap[item.buildingId] ?? ''),
                              tableBody(floorMap[item.floorId] ?? ''),
                              tableBody(item.roomType.toString()),
                              tableBody(item.roomNo.toString()),
                            ],
                  );
                }).toList(),
              ],
            ),
            const SizedBox(height: 12),
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
                  'Page $_currentPage of ${(studentReportList.length / 10).ceil()}',
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed:
                      _currentPage < (studentReportList.length / 10).ceil()
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
