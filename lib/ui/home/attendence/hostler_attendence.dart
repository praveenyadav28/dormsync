import 'package:dorm_sync/model/attendencemodel.dart';
import 'package:dorm_sync/ui/home/attendence/dialog.dart';
import 'package:dorm_sync/utils/api.dart';
import 'package:dorm_sync/utils/buttons.dart';
import 'package:dorm_sync/utils/colors.dart';
import 'package:dorm_sync/utils/field_cover.dart';
import 'package:dorm_sync/utils/images.dart';
import 'package:dorm_sync/utils/prefence.dart';
import 'package:dorm_sync/utils/reuse.dart';
import 'package:dorm_sync/utils/sizes.dart';
import 'package:dorm_sync/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HostlerAttendenceList extends StatefulWidget {
  const HostlerAttendenceList({super.key});

  @override
  State<HostlerAttendenceList> createState() => _HostlerAttendenceListState();
}

class _HostlerAttendenceListState extends State<HostlerAttendenceList> {
  List<AttendenceModel> studentsList = [];
  final TextEditingController datepickarfrom = TextEditingController(
    text: DateFormat(
      'dd/MM/yyyy',
    ).format(DateTime.now().subtract(const Duration(days: 2))),
  );
  final TextEditingController datepickarto = TextEditingController(
    text: DateFormat(
      'dd/MM/yyyy',
    ).format(DateTime.now().add(const Duration(days: 2))),
  );
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  bool _showActiveHostelers = true;
  String _searchQuery = '';
  int _currentPage = 1;

  List<AttendenceModel> get _filteredData {
    if (_searchQuery.isEmpty) return studentsList;
    final query = _searchQuery.toLowerCase();
    return studentsList.where((item) {
      final itemMap = item.toJson();
      return itemMap.values.any(
        (value) => value?.toString().toLowerCase().contains(query) ?? false,
      );
    }).toList();
  }

  List<AttendenceModel> get _pagedData {
    final start = (_currentPage - 1) * 10;
    final end = start + 10;
    return _filteredData.sublist(
      start,
      end > _filteredData.length ? _filteredData.length : end,
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
              child: Row(
                children: [
                  SizedBox(width: 30),
                  Text(
                    "Hostel Attendance-List",
                    style: TextStyle(
                      color: AppColor.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () async {
                      var updatedData = await Navigator.of(
                        context,
                      ).pushNamed('/add Hostler', arguments: null);
                      if (updatedData == "New Data") {
                        getAttendenceStudentList(
                          _showActiveHostelers ? "1" : "2",
                        ).then((_) {
                          setState(() {});
                        });
                      }
                    },
                    child: Row(
                      children: [
                        Text(
                          "Add  ",
                          style: TextStyle(
                            color: AppColor.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        CircleAvatar(
                          minRadius: 14,
                          backgroundColor: AppColor.black.withValues(alpha: .1),
                          child: Icon(Icons.add, color: AppColor.white),
                        ),
                        SizedBox(width: 30),
                      ],
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
                      'Show Active-Hostelers',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    Checkbox(
                      activeColor: AppColor.primary,
                      value: _showActiveHostelers,
                      onChanged:
                          (value) => setState(
                            () => _showActiveHostelers = value ?? false,
                          ),
                    ),
                  ],
                ),
                Center(
                  child: DefaultButton(
                    text: "Save",
                    hight: 30,
                    width: 140,
                    onTap: () {
                      getAttendenceStudentList(
                        _showActiveHostelers ? "1" : "2",
                      ).then((_) {
                        setState(() {});
                      });
                      ;
                    },
                  ),
                ),
              ],
              context: context,
            ),

            Container(
              height: 40,
              decoration: BoxDecoration(
                color: AppColor.white,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  children: <Widget>[
                    Spacer(),
                    Spacer(),
                    Spacer(),
                   
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(3),
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              _searchQuery = value;
                              _currentPage = 1; // Reset to first page on search
                            });
                          },
                          decoration: const InputDecoration(
                            isDense: true,
                            hintText: 'Search',
                            hintStyle: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                            border: OutlineInputBorder(), // Remove border
                            prefixIcon: Icon(
                              Icons.search,
                              color: Colors.grey,
                            ), // Add search icon
                          ),
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Table(
              border: TableBorder.all(color: Colors.grey),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                // Table Header Row
                TableRow(
                  decoration: BoxDecoration(color: Color(0xffE5FDDD)),
                  children: [
                    tableHeader('Hosteler ID'),
                    tableHeader('Admission Date'),
                    tableHeader('Hosteler Name'),
                    tableHeader('Father Name'),
                    tableHeader('Biomax Id'),
                    tableHeader('Active Status'),
                    tableHeader('Action'),
                  ],
                ),
                // Table Data Rows
                ..._pagedData.map((item) {
                  return TableRow(
                    decoration: BoxDecoration(color: AppColor.white),
                    children: [
                      tableBody(item.hostelerId),
                      tableBody(item.admissionDate),
                      tableBody(item.hostelerName),
                      tableBody(item.fatherName),
                      tableBody(item.hostelBiomax),
                      tableBody(
                        item.activeStatus == "1" ? "Active" : "Inactive",
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              IconButton(
                                icon: Image.asset(height: 20, Images.view),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder:
                                        (_) => PunchLogDialog(
                                          student: item,
                                          fromDate: DateFormat(
                                            'yyyy/MM/dd',
                                          ).parse(
                                            DateFormat('yyyy/MM/dd').format(
                                              DateFormat(
                                                'dd/MM/yyyy',
                                              ).parse(datepickarfrom.text),
                                            ),
                                          ),
                                          toDate: DateFormat(
                                            'yyyy/MM/dd',
                                          ).parse(
                                            DateFormat('yyyy/MM/dd').format(
                                              DateFormat(
                                                'dd/MM/yyyy',
                                              ).parse(datepickarto.text),
                                            ),
                                          ),
                                          isMessAttendence: false,
                                        ),
                                  );
                                },
                              ),

                              IconButton(
                                icon: Image.asset(height: 20, Images.delete),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder:
                                        (dialogContext) => AlertDialog(
                                          title: const Text("Warning"),
                                          content: const Text(
                                            "Are you sure you want to delete this attendance entry?",
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
                                                backgroundColor: AppColor.red,
                                              ),
                                              onPressed: () {
                                                deleteHostler(item.id!).then((
                                                  value,
                                                ) {
                                                  getAttendenceStudentList(
                                                    _showActiveHostelers
                                                        ? "1"
                                                        : "2",
                                                  ).then((value) {
                                                    setState(() {
                                                      Navigator.of(
                                                        dialogContext,
                                                      ).pop();
                                                    });
                                                  });
                                                });
                                              },
                                              child: const Text("Delete"),
                                            ),
                                          ],
                                        ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ],
            ),
            SizedBox(height: Sizes.height * 0.02),
          ],
        ),
      ),
    );
  }

  Future getAttendenceStudentList(String activeStatus) async {
    var response = await ApiService.fetchData(
      "attendance?licence_no=${Preference.getString(PrefKeys.licenseNo)}&branch_id=${Preference.getint(PrefKeys.locationId)}",
    );
    if (response["status"] == true) {
      studentsList =
          attendenceListFromJson(
            response['data'],
          ).where((student) => student.activeStatus == activeStatus).toList();
    }
  }

  Future deleteHostler(int id) async {
    var response = await ApiService.deleteData("attendance/$id");
    if (response["status"] == true) {
      showCustomSnackbarSuccess(context, response['message']);
    } else {
      showCustomSnackbarError(context, response['message']);
    }
  }
}
