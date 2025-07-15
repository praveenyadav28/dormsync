import 'package:dorm_sync/utils/colors.dart';
import 'package:dorm_sync/utils/images.dart';
import 'package:dorm_sync/utils/reuse.dart';
import 'package:dorm_sync/utils/sizes.dart';
import 'package:flutter/material.dart';

class NoDuesList extends StatefulWidget {
  const NoDuesList({super.key});

  @override
  State<NoDuesList> createState() => _NoDuesListState();
}

class _NoDuesListState extends State<NoDuesList> {
  // StyleText textstyles = StyleText();
  // Sample data for the table
  final List<Map<String, String>> _hostelerData = [
    {
      'Hosteler ID': '00123',
      'Admission Date': '19-05-2024',
      'Hosteler Name': 'John Smith',
      'Father Name': 'David Smith',
      'Contact Details': '96545214552',
      'Address': '123 Main St',
    },
    {
      'Hosteler ID': '00124',
      'Admission Date': '23-04-2023',
      'Hosteler Name': 'Alice Johnson',
      'Father Name': 'Robert Johnson',
      'Contact Details': '88545214552',
      'Address': '456 Oak Ave',
    },
    {
      'Hosteler ID': '00125',
      'Admission Date': '19-05-2024',
      'Hosteler Name': 'Bob Williams',
      'Father Name': 'Michael Williams',
      'Contact Details': '9998887777',
      'Address': '789 Pine Ln',
    },
    {
      'Hosteler ID': '00126',
      'Admission Date': '28-07-2023',
      'Hosteler Name': 'Emily Brown',
      'Father Name': 'James Brown',
      'Contact Details': '7412589630',
      'Address': '101 Elm St',
    },
    {
      'Hosteler ID': '00127',
      'Admission Date': '01-05-2024',
      'Hosteler Name': 'Michael Davis',
      'Father Name': 'Thomas Davis',
      'Contact Details': '8529637410',
      'Address': '222 Oak St',
    },
    {
      'Hosteler ID': '00128',
      'Admission Date': '05-04-2025',
      'Hosteler Name': 'Jessica Wilson',
      'Father Name': 'Richard Wilson',
      'Contact Details': '9638527410',
      'Address': '333 Pine Ave',
    },
    {
      'Hosteler ID': '00129',
      'Admission Date': '04-05-2024',
      'Hosteler Name': 'David Garcia',
      'Father Name': 'Jose Garcia',
      'Contact Details': '7539514862',
      'Address': '444 Cedar St',
    },
    {
      'Hosteler ID': '00130',
      'Admission Date': '23-04-2023',
      'Hosteler Name': 'Linda Rodriguez',
      'Father Name': 'Carlos Rodriguez',
      'Contact Details': '8521479630',
      'Address': '555 Maple Ave',
    },
  ];

  // Store the filter values
  String _searchQuery = '';
  int _pageSize = 10; // Initial page size
  int _currentPage = 1; // Current page
  final List<int> _pageSizeOptions = [5, 10, 20, 50]; // Page size options

  // Function to filter the data
  List<Map<String, String>> get _filteredData {
    List<Map<String, String>> result = _hostelerData;

    if (_searchQuery.isNotEmpty) {
      result =
          _hostelerData.where((item) {
            return item.values.any(
              (value) =>
                  value.toLowerCase().contains(_searchQuery.toLowerCase()),
            );
          }).toList();
    }
    return result;
  }

  // Function to get paginated data
  List<Map<String, String>> get _pagedData {
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
                    "Nodues",
                    style: TextStyle(
                      color: AppColor.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    // onTap:
                    //     () =>
                    //         Navigator.of(context).pushNamed('/admission form'),
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
                0: FlexColumnWidth(.8),
                1: FlexColumnWidth(.8),
                2: FlexColumnWidth(1),
                3: FlexColumnWidth(1),
                4: FlexColumnWidth(1),
                5: FlexColumnWidth(1),
                6: FlexColumnWidth(1),
                7: FlexColumnWidth(1),
                8: FlexColumnWidth(1.3),
              },
              border: TableBorder.all(color: Colors.grey),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                // Table Header Row
                TableRow(
                  decoration: BoxDecoration(color: Color(0xffE5FDDD)),
                  children: [
                    tableHeader('H-ID'),
                    tableHeader('Adm.Date'),
                    tableHeader('Hosteler Name'),
                    tableHeader('Father Name'),
                    tableHeader('Leaving Date'),
                    tableHeader('Total Fees'),
                    tableHeader('Recieved'),
                    tableHeader('Balance'),
                    tableHeader('Action'),
                  ],
                ),
                // Table Data Rows
                ..._pagedData.map((item) {
                  return TableRow(
                    decoration: BoxDecoration(color: AppColor.white),

                    children: [
                      tableBody(item['Hosteler ID'] ?? ''),
                      tableBody(item['Admission Date'] ?? ''),
                      tableBody(item['Hosteler Name'] ?? ''),
                      tableBody(item['Father Name'] ?? ''),
                      tableBody(''),
                      tableBody(''),
                      tableBody(''),
                      tableBody(''),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              IconButton(
                                icon: Image.asset(height: 20, Images.edit),
                                onPressed: () {
                                  // Handle edit action
                                },
                              ),
                              IconButton(
                                icon: Image.asset(height: 20, Images.delete),
                                onPressed: () {
                                  // Handle delete action
                                },
                              ),
                              IconButton(
                                icon: Image.asset(height: 20, Images.view),

                                onPressed: () {
                                  // Handle delete action
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
}
