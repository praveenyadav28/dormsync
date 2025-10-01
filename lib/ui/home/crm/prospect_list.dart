import 'package:dorm_sync/ui/excel/prospect_excel.dart';
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

class ProspectListScreen extends StatefulWidget {
  const ProspectListScreen({super.key});

  @override
  State<ProspectListScreen> createState() => _ProspectListScreenState();
}

class _ProspectListScreenState extends State<ProspectListScreen> {
  int punchedToday = 0;
  int followupToday = 0;
  int followupTomorrow = 0;
  int weeklyLead = 0;
  List<ProspectList> prospectList = [];
  String _selectedStatus = 'In Process'; // default status

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

  List<Map<String, dynamic>> dataList = [];
  int hoveredIndex = -1;
  @override
  void initState() {
    getProspect().then((value) {
      setState(() {});
    });
    getallprospactGrid().then((value) {
      setState(() {
        updateDataList();
      });
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
                    "Prospect-List",
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
                      ).pushNamed('/create Prospect', arguments: null);
                      if (updatedData == "New Data") {
                        getallprospactGrid().then((value) {
                          setState(() {
                            updateDataList();
                          });
                        });
                        getProspect().then((value) {
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

            GridView.builder(
              shrinkWrap: true,
              itemCount: dataList.length,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount:
                    Sizes.width < 600
                        ? 2
                        : Sizes.width < 800
                        ? 3
                        : 4,
                crossAxisSpacing: Sizes.width * .03,
                childAspectRatio:
                    Sizes.width < 600
                        ? 1.3
                        : Sizes.width < 800
                        ? 1.3
                        : 1.5,
                mainAxisSpacing: Sizes.height * .02,
              ),
              itemBuilder:
                  (context, index) => InkWell(
                    onHover: (value) {
                      setState(() {
                        hoveredIndex = value ? index : -1;
                      });
                    },
                    onTap: () async {
                      var updatedData = await Navigator.of(context).pushNamed(
                        '/view Prospect',
                        arguments: {"dataType": index},
                      );
                      if (updatedData == "New Data") {
                        getallprospactGrid().then((value) {
                          setState(() {});
                        });
                      }
                    },
                    child: Card(
                      shadowColor: Colors.blueAccent,
                      elevation: index == hoveredIndex ? 15.0 : 4.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            flex: 4,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                              ),
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    offset: const Offset(2, 2),
                                    blurRadius: 4,
                                    color: AppColor.black.withValues(alpha: .2),
                                    inset: true,
                                  ),
                                ],
                                color: Color(0xffC1C1F7),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Expanded(
                                    child: Image.network(
                                      dataList[index]["icon"],
                                      height: 35,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      dataList[index]["users"],
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        color: AppColor.black,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Center(
                              child: Text(
                                dataList[index]["title"],
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColor.black81,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
            ),
            SizedBox(height: Sizes.height * .04),
            Row(
              children: [
                Radio<String>(
                  value: 'In Process',
                  groupValue: _selectedStatus,
                  onChanged: (value) {
                    setState(() {
                      _selectedStatus = value!;
                      _currentPage = 1;
                    });
                    getProspect(); // refresh based on new status
                  },
                ),
                const Text('In Process'),
                Radio<String>(
                  value: 'Lost',
                  groupValue: _selectedStatus,
                  onChanged: (value) {
                    setState(() {
                      _selectedStatus = value!;
                      _currentPage = 1;
                    });
                    getProspect();
                  },
                ),
                const Text('Lost'),
                Radio<String>(
                  value: 'Admitted',
                  groupValue: _selectedStatus,
                  onChanged: (value) {
                    setState(() {
                      _selectedStatus = value!;
                      _currentPage = 1;
                    });
                    getProspect();
                  },
                ),
                const Text('Admitted'),
              ],
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
                    Spacer(),

                    Container(
                      margin: EdgeInsets.symmetric(vertical: 3, horizontal: 8),
                      decoration: BoxDecoration(color: Color(0xffECFFE5)),
                      child: IconButton(
                        onPressed: () async {
                          await exportProspectsToExcel(_filteredData);
                        },
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
                                      setState(() {
                                        updateDataList();
                                      });
                                    });
                                    getProspect().then((value) {
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
                                                  getProspect().then((value) {
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
                                      setState(() {
                                        updateDataList();
                                      });
                                    });
                                    getProspect().then((value) {
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

  Future getProspect() async {
    var response = await ApiService.fetchData(
      "prospect?licence_no=${Preference.getString(PrefKeys.licenseNo)}&branch_id=${Preference.getint(PrefKeys.locationId)}",
    );
    if (response["status"] == true) {
      List<ProspectList> allProspects = prospectListFromJson(response['data']);
      prospectList =
          allProspects
              .where((prospect) => prospect.prospectStatus == _selectedStatus)
              .toList();
      setState(() {});
    }
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
    Map<String, dynamic> response =
        await ApiService.postData("createdAtReport", {
          "from_date": DateFormat('dd/MM/yyyy').format(DateTime.now()),
          "to_date": DateFormat('dd/MM/yyyy').format(DateTime.now()),
          "licence_no": Preference.getString(PrefKeys.licenseNo),
          "branch_id": Preference.getint(PrefKeys.locationId),
        });
    List<ProspectList> allProspectspunchedToday = prospectListFromJson(
      response['data'],
    );
    punchedToday =
        allProspectspunchedToday
            .where((prospect) => prospect.prospectStatus == "In Process")
            .toList()
            .length;
    Map<String, dynamic> responsetommarow =
        await ApiService.postData("report", {
          "from_date": DateFormat(
            'dd/MM/yyyy',
          ).format(DateTime.now().add(Duration(days: 1))),
          "to_date": DateFormat(
            'dd/MM/yyyy',
          ).format(DateTime.now().add(Duration(days: 1))),
          "licence_no": Preference.getString(PrefKeys.licenseNo),
          "branch_id": Preference.getint(PrefKeys.locationId),
        });
    List<ProspectList> allProspectsfollowupTomorrow = prospectListFromJson(
      responsetommarow['data'],
    );
    followupTomorrow =
        allProspectsfollowupTomorrow
            .where((prospect) => prospect.prospectStatus == "In Process")
            .toList()
            .length;

    Map<String, dynamic> responseToday = await ApiService.postData("report", {
      "from_date": DateFormat('dd/MM/yyyy').format(DateTime.now()),
      "to_date": DateFormat("dd/MM/yyyy").format(DateTime.now()),
      "licence_no": Preference.getString(PrefKeys.licenseNo),
      "branch_id": Preference.getint(PrefKeys.locationId),
    });
    List<ProspectList> allProspectsfollowupToday = prospectListFromJson(
      responseToday['data'],
    );
    followupToday =
        allProspectsfollowupToday
            .where((prospect) => prospect.prospectStatus == "In Process")
            .toList()
            .length;

    Map<String, dynamic> responseWeekly =
        await ApiService.postData("createdAtReport", {
          "from_date": DateFormat(
            "dd/MM/yyyy",
          ).format(DateTime.now().subtract(Duration(days: 7))),
          "to_date": DateFormat("dd/MM/yyyy").format(DateTime.now()),
          "licence_no": Preference.getString(PrefKeys.licenseNo),
          "branch_id": Preference.getint(PrefKeys.locationId),
        });
    List<ProspectList> allProspectsweeklyLead = prospectListFromJson(
      responseWeekly['data'],
    );
    weeklyLead =
        allProspectsweeklyLead
            .where((prospect) => prospect.prospectStatus == "In Process")
            .toList()
            .length;
  }

  void updateDataList() {
    dataList = [
      {
        "icon":
            "https://raw.githubusercontent.com/praveenyadav28/wms-images/refs/heads/main/icon/17806297%201.png",
        "title": "Enquery Punched Today",
        "users": "$punchedToday",
      },
      {
        "icon":
            "https://raw.githubusercontent.com/praveenyadav28/wms-images/refs/heads/main/icon/17806420%201.png",
        "title": "Tomorrow’s Follow-up",
        "users": "$followupTomorrow",
      },
      {
        "icon":
            "https://raw.githubusercontent.com/praveenyadav28/wms-images/refs/heads/main/icon/17806211%201.png",
        "title": "Today’s Follow-up",
        "users": "$followupToday",
      },
      {
        "icon":
            "https://raw.githubusercontent.com/praveenyadav28/wms-images/refs/heads/main/icon/17806386%201.png",
        "title": "Weekly Lead",
        "users": "$weeklyLead",
      },
    ];
  }
}
