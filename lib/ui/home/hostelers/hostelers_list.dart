import 'package:dorm_sync/model/admission.dart';
import 'package:dorm_sync/utils/api.dart';
import 'package:dorm_sync/utils/colors.dart';
import 'package:dorm_sync/utils/images.dart';
import 'package:dorm_sync/utils/prefence.dart';
import 'package:dorm_sync/utils/reuse.dart';
import 'package:dorm_sync/utils/sizes.dart';
import 'package:dorm_sync/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HostelersList extends StatefulWidget {
  const HostelersList({super.key});

  @override
  State<HostelersList> createState() => _HostelersListState();
}

class _HostelersListState extends State<HostelersList> {
  List<AdmissionList> hostlersList = [];

  // Store the filter values
  String _searchQuery = '';
  int _pageSize = 10; // Initial page size
  int _currentPage = 1; // Current page
  final List<int> _pageSizeOptions = [5, 10, 20, 50]; // Page size options

  // Function to filter the data
  List<AdmissionList> get _filteredData {
    List<AdmissionList> result =
        hostlersList; // Initialize with unfiltered data
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();

      result =
          hostlersList.where((item) {
            final Map<String, dynamic> itemMap = item.toJson();
            return itemMap.values.any((value) {
              return value?.toString().toLowerCase().contains(query) ?? false;
            });
          }).toList();
    }
    return result;
  }

  // Function to get paginated data
  List<AdmissionList> get _pagedData {
    final startIndex = (_currentPage - 1) * _pageSize;
    final endIndex = startIndex + _pageSize;
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

  // Function to handle page size change
  void _onPageSizeChanged(int size) {
    setState(() {
      _pageSize = size;
      _currentPage = 1; // Reset to first page when page size changes
    });
  }

  @override
  void initState() {
    getHostlers().then((value) {
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
                    "Hostelers-List",
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
                      ).pushNamed('/admission form', arguments: null);
                      if (updatedData == "New Data") {
                        getHostlers().then((value) {
                          setState(() {});
                        });
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
                    // Page Size Dropdown
                    Text("Show "),
                    Container(
                      margin: EdgeInsets.all(5),
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: AppColor.white,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 3,
                            color: AppColor.grey,
                            spreadRadius: 2,
                            offset: Offset(0, 4),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(4),
                      ),

                      child: DropdownButton<int>(
                        value: _pageSize,
                        onChanged: (int? newValue) {
                          if (newValue != null) {
                            // null check
                            _onPageSizeChanged(newValue);
                          }
                        },
                        items:
                            _pageSizeOptions.map<DropdownMenuItem<int>>((
                              int value,
                            ) {
                              return DropdownMenuItem<int>(
                                value: value,
                                child: Text(value.toString()),
                              );
                            }).toList(),
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: AppColor.lightblack,
                        ),
                        underline: Container(), // Remove underline
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.grey,
                        ), // Custom icon
                      ),
                    ),
                    Text(" enteries"),
                    const SizedBox(width: 8),
                    Spacer(),
                    Spacer(),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 3, horizontal: 8),
                      decoration: BoxDecoration(color: Color(0xffECFFE5)),
                      child: IconButton(
                        onPressed: () {},
                        icon: Image.asset(Images.pdf),
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.symmetric(vertical: 3, horizontal: 8),
                      decoration: BoxDecoration(color: Color(0xffECFFE5)),
                      child: IconButton(
                        onPressed: () {},
                        icon: Image.asset(Images.excel),
                      ),
                    ),
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
            // Data Table
            Table(
              columnWidths: const {
                0: FlexColumnWidth(1.5), // Hosteler ID
                1: FlexColumnWidth(1.5), // Admission Date
                2: FlexColumnWidth(2), // Hosteler Name
                3: FlexColumnWidth(2), // Father Name
                4: FlexColumnWidth(2), // Contact Details
                5: FlexColumnWidth(3), // Address
                6: FlexColumnWidth(2), // Action
              },
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
                    tableHeader('Contact Details'),
                    tableHeader('Address'),
                    tableHeader('Action'),
                  ],
                ),
                // Table Data Rows
                ..._pagedData.map((item) {
                  return TableRow(
                    decoration: BoxDecoration(color: AppColor.white),

                    children: [
                      tableBody(item.studentId ?? ''),
                      tableBody(
                        DateFormat(
                          'dd/MM/yyyy',
                        ).format(item.admissionDate ?? DateTime.now()),
                      ),
                      tableBody(item.studentName ?? ''),
                      tableBody(item.fatherName ?? ''),
                      tableBody(
                        "📞 ${item.primaryContactNo}\n🏡 ${item.parentContect}",
                      ),
                      tableBody(item.permanentAddress ?? ''),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              IconButton(
                                icon: Image.asset(height: 20, Images.edit),
                                onPressed: () async {
                                  var updatedData = await Navigator.of(
                                    context,
                                  ).pushNamed(
                                    '/admission form',
                                    arguments: item,
                                  );
                                  if (updatedData == "New Data") {
                                    getHostlers().then((value) {
                                      setState(() {});
                                    });
                                  }
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
                                            "Are you sure you want to delete this hostler?",
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
                                                  getHostlers().then((value) {
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
                    'Page ${_currentPage} of ${(_filteredData.length / _pageSize).ceil()}',
                  ), //display the current page and the total number of pages
                ),
                // Next Page Button
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed:
                      _currentPage < (_filteredData.length / _pageSize).ceil()
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

  Future getHostlers() async {
    var response = await ApiService.fetchData(
      "isactive?session_id=${Preference.getint(PrefKeys.sessionId)}&licence_no=${Preference.getString(PrefKeys.licenseNo)}&branch_id=${Preference.getint(PrefKeys.locationId)}",
    );
    if (response["status"] == true) {
      hostlersList = admissionListFromJson(response['data']);
    }
  }

  Future deleteHostler(int id) async {
    var response = await ApiService.deleteData("admissionform/$id");
    if (response["status"] == true) {
      showCustomSnackbarSuccess(context, response['message']);
    } else {
      showCustomSnackbarError(context, response['message']);
    }
  }
}
