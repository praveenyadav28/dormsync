import 'package:dorm_sync/model/leave.dart';
import 'package:dorm_sync/utils/api.dart';
import 'package:dorm_sync/utils/buttons.dart';
import 'package:dorm_sync/utils/colors.dart';
import 'package:dorm_sync/utils/field_cover.dart';
import 'package:dorm_sync/utils/images.dart';
import 'package:dorm_sync/utils/prefence.dart';
import 'package:dorm_sync/utils/reuse.dart';
import 'package:dorm_sync/utils/sizes.dart';
import 'package:dorm_sync/utils/textformfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LeaveReportList extends StatefulWidget {
  const LeaveReportList({super.key});
  @override
  State<LeaveReportList> createState() => _LeaveReportListState();
}

class _LeaveReportListState extends State<LeaveReportList> {
  TextEditingController datepickarfrom = TextEditingController(
    text: DateFormat(
      'dd/MM/yyyy',
    ).format(DateTime.now().subtract(Duration(days: 60))),
  );
  TextEditingController datepickarto = TextEditingController(
    text: DateFormat(
      'dd/MM/yyyy',
    ).format(DateTime.now().add(Duration(days: 30))),
  );
  List<LeaveList> leaveList = [];
  int _currentPage = 1; // Current page

  // Store the filter values
  String _searchQuery = '';

  // Function to filter the data
  List<LeaveList> get _filteredData {
    List<LeaveList> result = leaveList; // Initialize with unfiltered data
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();

      result =
          leaveList.where((item) {
            final Map<String, dynamic> itemMap = item.toJson();
            return itemMap.values.any((value) {
              return value?.toString().toLowerCase().contains(query) ?? false;
            });
          }).toList();
    }
    return result;
  }

  // Function to get paginated data
  List<LeaveList> get _pagedData {
    final startIndex = (_currentPage - 1) * 10;
    final endIndex = startIndex + 10;
    final filteredData = _filteredData;
    if (startIndex > filteredData.length) {
      return [];
    }
    return filteredData.sublist(
      startIndex,
      endIndex > filteredData.length ? filteredData.length : endIndex,
    );
  }

  // Function to handle page change
  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  @override
  void initState() {
    getLeaveList().then((value) {
      setState(() {});
    });
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
                    "Leave List",
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
                      ).pushNamed('/add Leave', arguments: null);
                      if (updatedData == "New Data") {
                        // getVisitor().then((value) {
                        //   setState(() {});
                        // });
                      }
                    },
                    child: Row(
                      children: [
                        Text(
                          "Create  ",
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
                CommonTextField(
                  image: Images.hosteler,
                  hintText: "Hostler Name",
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                      _currentPage = 1; // Reset to first page on search
                    });
                  },
                ),
                Center(
                  child: DefaultButton(
                    text: "Save",
                    hight: 30,
                    width: 140,
                    onTap: () {
                      getLeaveList().then((_) => setState(() {}));
                    },
                  ),
                ),
              ],
              context: context,
            ),
            Table(
              columnWidths: const {
                0: FlexColumnWidth(.7),
                1: FlexColumnWidth(1),
                2: FlexColumnWidth(1),
                3: FlexColumnWidth(1),
                4: FlexColumnWidth(1),
                5: FlexColumnWidth(1),
                6: FlexColumnWidth(1),
                7: FlexColumnWidth(1),
                8: FlexColumnWidth(.8),
              },
              border: TableBorder.all(color: Colors.grey),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                // Table Header Row
                TableRow(
                  decoration: BoxDecoration(color: Color(0xffE5FDDD)),
                  children: [
                    tableHeader('H-ID'),
                    tableHeader('Hosteler Name'),
                    tableHeader('Father Name'),
                    tableHeader('From'),
                    tableHeader('To'),
                    tableHeader('Accompained By'),
                    tableHeader('Contact Details'),
                    tableHeader('Destination'),
                    tableHeader('Purpose'),
                  ],
                ),
                // Table Data Rows
                ..._pagedData.map((item) {
                  return TableRow(
                    decoration: BoxDecoration(color: AppColor.white),
                    children: [
                      tableBody(item.hostelerId ?? ''),
                      tableBody(item.hostelerName ?? ''),
                      tableBody(item.fatherName ?? ''),
                      tableBody(item.fromDate ?? ''),
                      tableBody(item.toDate ?? ''),
                      tableBody(item.accompainedBy ?? ''),
                      tableBody(item.contact ?? ''),
                      tableBody(item.destination ?? ''),
                      TableCell(
                        child: IconButton(
                          icon: Image.asset(height: 20, Images.view),
                          onPressed: () {
                            // Handle delete action
                          },
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ],
            ),
            SizedBox(height: Sizes.height * 0.02),
            // Pagination Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Previous Page Button
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed:
                      _currentPage > 1
                          ? () => _onPageChanged(_currentPage - 1)
                          : null, // Disable if on first page
                ),
                // Current Page Text
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text(
                    'Page ${_currentPage} of ${(leaveList.length / 10).ceil()}',
                  ), //display the current page and the total number of pages
                ),
                // Next Page Button
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed:
                      _currentPage < (leaveList.length / 10).ceil()
                          ? () => _onPageChanged(_currentPage + 1)
                          : null, // Disable if on last page
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future getLeaveList() async {
    var response = await ApiService.fetchData(
      "createat/?from_date=${datepickarfrom.text}&to_date=${datepickarto.text}&licence_no=${Preference.getString(PrefKeys.licenseNo)}&branch_id=${Preference.getint(PrefKeys.locationId)}",
    );
    if (response["status"] == true) {
      leaveList = leaveListFromJson(response['data']);
    }
  }
}
