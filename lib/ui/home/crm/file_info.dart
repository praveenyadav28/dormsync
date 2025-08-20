import 'package:dorm_sync/utils/buttons.dart';
import 'package:dorm_sync/utils/field_cover.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:dorm_sync/model/prospect.dart';
import 'package:dorm_sync/utils/api.dart';
import 'package:dorm_sync/utils/colors.dart';
import 'package:dorm_sync/utils/images.dart';
import 'package:dorm_sync/utils/prefence.dart';
import 'package:dorm_sync/utils/reuse.dart';
import 'package:dorm_sync/utils/sizes.dart';
import 'package:dorm_sync/utils/snackbar.dart';
import 'package:intl/intl.dart';

class FileInfo extends StatefulWidget {
  const FileInfo({super.key});

  @override
  State<FileInfo> createState() => _FileInfoState();
}

class _FileInfoState extends State<FileInfo> {
  Map<String, dynamic>? prospectData;
  TextEditingController dateFrom = TextEditingController(
    text: DateFormat('dd/MM/yyyy').format(DateTime.now()),
  );
  TextEditingController dateTo = TextEditingController(
    text: DateFormat('dd/MM/yyyy').format(DateTime.now()),
  );
  String reportType = "report";

  List<ProspectList> prospectList = [];

  // Store the filter values
  String _searchQuery = '';
  int _pageSize = 10; // Initial page size
  int _currentPage = 1; // Current page
  final List<int> _pageSizeOptions = [5, 10, 20, 50]; // Page size options

  // Function to filter the data
  List<ProspectList> get _filteredData {
    List<ProspectList> result = prospectList; // Initialize with unfiltered data
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();

      result =
          prospectList.where((item) {
            final Map<String, dynamic> itemMap = item.toJson();
            return itemMap.values.any((value) {
              return value?.toString().toLowerCase().contains(query) ?? false;
            });
          }).toList();
    }
    return result;
  }

  // Function to get paginated data
  List<ProspectList> get _pagedData {
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

  var indexStatus = 0;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && prospectData == null) {
        prospectData = args as Map<String, dynamic>;
        indexStatus = prospectData?["dataType"];
        dateFrom.text =
            (prospectData?["dataType"] == 0 || prospectData?["dataType"] == 2)
                ? DateFormat('dd/MM/yyyy').format(DateTime.now())
                : prospectData?["dataType"] == 1
                ? DateFormat(
                  'dd/MM/yyyy',
                ).format(DateTime.now().add(Duration(days: 1)))
                : DateFormat(
                  'dd/MM/yyyy',
                ).format(DateTime.now().subtract(Duration(days: 7)));
        dateTo.text =
            (prospectData?["dataType"] == 0 ||
                    prospectData?["dataType"] == 2 ||
                    prospectData?["dataType"] == 3)
                ? DateFormat('dd/MM/yyyy').format(DateTime.now())
                : DateFormat(
                  'dd/MM/yyyy',
                ).format(DateTime.now().add(Duration(days: 1)));
        reportType =
            (prospectData?["dataType"] == 1 || prospectData?["dataType"] == 2)
                ? "report"
                : "createdAtReport";
        getallprospactGrid().then((value) {
          setState(() {});
        });
      }
    });
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
                    indexStatus == 0
                        ? "Enquery Punched Today"
                        : indexStatus == 1
                        ? "Tomorrow’s Follow-up"
                        : indexStatus == 2
                        ? "Today’s Follow-up"
                        : indexStatus == 3
                        ? "Weekly Lead"
                        : reportType == "report"
                        ? "Scheduled Prospects"
                        : "Created Prospects",
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
                DateRange(datepickar1: dateFrom, datepickar2: dateTo),
                Center(
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                        _currentPage = 1; // Reset to first page on search
                      });
                    },
                    decoration: InputDecoration(
                      isDense: true,
                      filled: true,
                      fillColor: AppColor.white,
                      hintText: 'Search',
                      hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                      border: OutlineInputBorder(), // Remove border
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.grey,
                      ), // Add search icon
                    ),
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                  ),
                ),
                Center(
                  child: DefaultButton(
                    text: "Save",
                    hight: 40,
                    width: double.infinity,
                    onTap: () {
                      getallprospactGrid().then((value) {
                        setState(() {
                          indexStatus = 4;
                        });
                      });
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
                  ],
                ),
              ),
            ),
            // Data Table
            Table(
              border: TableBorder.all(color: Colors.grey),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                // Table Header Row
                TableRow(
                  decoration: BoxDecoration(color: Color(0xffE5FDDD)),
                  children: [
                    tableHeader('Student Name'),
                    tableHeader('Contact Details'),
                    tableHeader('Address'),
                    tableHeader('Appointment Date'),
                    tableHeader('Remark'),
                    tableHeader('Status'),
                    tableHeader('Action'),
                  ],
                ),
                // Table Data Rows
                ..._pagedData.map((item) {
                  return TableRow(
                    decoration: BoxDecoration(color: AppColor.white),

                    children: [
                      tableBody(item.studentName ?? ''),
                      tableBody("📞 ${item.contactNo}\n🏡 ${item.fContactNo}"),
                      tableBody(item.address ?? ''),
                      tableBody(item.nextAppointmentDate),
                      tableBody(item.remark ?? ''),
                      tableBody(item.prospectStatus ?? ''),
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
                                    '/create Prospect',
                                    arguments: item,
                                  );
                                  if (updatedData == "New Data") {
                                    getallprospactGrid().then((value) {
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
                                            "Are you sure you want to delete this prospect?",
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
                                                deleteProspect(item.id!).then((
                                                  value,
                                                ) {
                                                  getallprospactGrid().then((
                                                    value,
                                                  ) {
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
                              IconButton(
                                onPressed: () async {
                                  var updatedData = await Navigator.of(
                                    context,
                                  ).pushNamed('/follow Up', arguments: item);
                                  if (updatedData == "New Data") {
                                    getallprospactGrid().then((value) {
                                      setState(() {});
                                    });
                                  }
                                },
                                icon: Image.asset(height: 20, Images.view),
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

  Future deleteProspect(int id) async {
    var response = await ApiService.deleteData("prospect/$id");
    if (response["status"] == true) {
      showCustomSnackbarSuccess(context, response['message']);
    } else {
      showCustomSnackbarError(context, response['message']);
    }
  }

  Future getallprospactGrid() async {
    var response = await ApiService.postData(reportType, {
      "from_date": dateFrom.text,
      "to_date": dateTo.text,
      "licence_no": Preference.getString(PrefKeys.licenseNo),
      "branch_id": Preference.getint(PrefKeys.locationId),
    });
    if (response["status"] == true) {
      setState(() {
        prospectList =
            prospectListFromJson(response['data'])
                .where((prospect) => prospect.prospectStatus == "In Process")
                .toList();
      });
    }
  }
}
