import 'package:dorm_sync/model/meterreading_model.dart';
import 'package:dorm_sync/ui/excel/fees_entry_excel.dart';
import 'package:dorm_sync/utils/api.dart';
import 'package:dorm_sync/utils/colors.dart';
import 'package:dorm_sync/utils/field_cover.dart';
import 'package:dorm_sync/utils/images.dart';
import 'package:dorm_sync/utils/prefence.dart';
import 'package:dorm_sync/utils/reuse.dart';
import 'package:dorm_sync/utils/sizes.dart';
import 'package:dorm_sync/utils/snackbar.dart';
import 'package:dorm_sync/utils/textformfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MeterListScreen extends StatefulWidget {
  const MeterListScreen({super.key});

  @override
  State<MeterListScreen> createState() => _MeterListScreenState();
}

class _MeterListScreenState extends State<MeterListScreen> {
  List<MeterReadingModel> feesList = [];

  // Store the filter values
  String _searchQuery = '';
  int _pageSize = 10; // Initial page size
  int _currentPage = 1; // Current page
  final List<int> _pageSizeOptions = [5, 10, 20, 50]; // Page size options

  // Function to filter the data
  List<MeterReadingModel> get _filteredData {
    List<MeterReadingModel> result =
        feesList; // Initialize with unfiltered data
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();

      result =
          feesList.where((item) {
            final Map<String, dynamic> itemMap = item.toJson();
            return itemMap.values.any((value) {
              return value?.toString().toLowerCase().contains(query) ?? false;
            });
          }).toList();
    }
    return result;
  }

  final TextEditingController pricePerUnitController = TextEditingController();
  // Function to get paginated data
  List<MeterReadingModel> get _pagedData {
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
    getFeesList().then((value) {
      setState(() {});
    });
    pricePerUnitController.text = Preference.getString(PrefKeys.unitPrice);
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
                    "Fees-List",
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
                      ).pushNamed('/meter Reading', arguments: null);
                      if (updatedData == "New Data") {
                        getFeesList().then((value) {
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
            Align(
              alignment: Alignment.centerRight,
              child: addMasterOutside5(
                children: [
                  TitleTextField(
                    image: null,
                    controller: pricePerUnitController,
                    titileText: "Price per Unit",
                    hintText: "0.0",
                    onChanged: (value) {
                      Preference.setString(PrefKeys.unitPrice, value);
                    },
                  ),
                ],
                context: context,
              ),
            ),
            SizedBox(height: Sizes.height * .02),
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
                0: FlexColumnWidth(1), // Hosteler ID
                1: FlexColumnWidth(1), // Admission Date
                2: FlexColumnWidth(1), // Hosteler Name
                3: FlexColumnWidth(1), // Father Name
                4: FlexColumnWidth(3.5), // Contact Details
                5: FlexColumnWidth(1), // Address
              },
              border: TableBorder.all(color: Colors.grey),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                // Table Header Row
                TableRow(
                  decoration: BoxDecoration(color: Color(0xffE5FDDD)),
                  children: [
                    tableHeader('Room No.'),
                    tableHeader('Opening Reading'),
                    tableHeader('Closing Reading'),
                    tableHeader('Price'),
                    tableHeader('Student Structure'),
                    tableHeader('Action'),
                  ],
                ),
                // Table Data Rows
                ..._pagedData.map((item) {
                  return TableRow(
                    decoration: BoxDecoration(color: AppColor.white),
                    children: [
                      tableBody(item.room ?? ''),
                      tableBody(item.opningReding ?? ''),
                      tableBody(item.closingReding ?? ''),
                      tableBody(item.price.toString()),
                      tableBody(item.studentStructure.toString()),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              IconButton(
                                icon: Image.asset(height: 20, Images.delete),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder:
                                        (dialogContext) => AlertDialog(
                                          title: const Text("Warning"),
                                          content: const Text(
                                            "Are you sure you want to delete this meter reading?",
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
                                                  getFeesList().then((value) {
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

  Future getFeesList() async {
    var response = await ApiService.fetchData(
      "mitareding?session_id=${Preference.getint(PrefKeys.sessionId)}&licence_no=${Preference.getString(PrefKeys.licenseNo)}&branch_id=${Preference.getint(PrefKeys.locationId)}",
    );
    if (response["status"] == true) {
      feesList = meterReadingModelFromJson(response['data']);
    }
  }

  Future deleteHostler(String id) async {
    var response = await ApiService.deleteData("mitareding/$id");
    if (response["status"] == true) {
      showCustomSnackbarSuccess(context, response['message']);
    } else {
      showCustomSnackbarError(context, response['message']);
    }
  }
}
