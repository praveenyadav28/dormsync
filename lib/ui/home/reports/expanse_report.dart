import 'package:dorm_sync/utils/buttons.dart';
import 'package:dorm_sync/utils/colors.dart';
import 'package:dorm_sync/utils/field_cover.dart';
import 'package:dorm_sync/utils/images.dart';
import 'package:dorm_sync/utils/reuse.dart';
import 'package:dorm_sync/utils/sizes.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExpansesReportList extends StatefulWidget {
  const ExpansesReportList({super.key});
  @override
  State<ExpansesReportList> createState() => _ExpansesReportListState();
}

class _ExpansesReportListState extends State<ExpansesReportList> {
  String? _selectedHostelerType;
  TextEditingController datepickarFrom = TextEditingController(
    text: DateFormat(
      'dd/MM/yyyy',
    ).format(DateTime.now().subtract(Duration(days: 60))),
  );
  TextEditingController datepickarto = TextEditingController(
    text: DateFormat(
      'dd/MM/yyyy',
    ).format(DateTime.now().add(Duration(days: 30))),
  );
  // Sample data for the table
  final List<Map<String, String>> _hostelerData = [
    {
      'Serial No.': '00123',
      'Voucher Date': '19-05-2024',
      'Particular': "",
      'Voucher No.': " ",
      'Expense By': 'David Smith',
      'Transaction Amt': "",
      "Narration": "",
    },
    {
      'Serial No.': '00124',
      'Voucher Date': '23-04-2023',
      'Particular': "",
      'Voucher No.': " ",
      'Expense By': 'Robert Johnson',
      'Transaction Amt': "",
      "Narration": "",
    },
    {
      'Serial No.': '00125',
      'Voucher Date': '19-05-2024',
      'Particular': "",
      'Voucher No.': " ",
      'Expense By': 'Michael Williams',
      'Transaction Amt': "",
      "Narration": "",
    },
    {
      'Serial No.': '00126',
      'Voucher Date': '28-07-2023',
      'Particular': "",
      'Voucher No.': " ",
      'Expense By': 'James Brown',
      'Transaction Amt': "",
      "Narration": "",
    },
    {
      'Serial No.': '00127',
      'Voucher Date': '01-05-2024',
      'Particular': "",
      'Voucher No.': " ",
      'Expense By': 'Thomas Davis',
      'Transaction Amt': "",
      "Narration": "",
    },
    {
      'Serial No.': '00128',
      'Voucher Date': '05-04-2025',
      'Particular': "",
      'Voucher No.': " ",
      'Expense By': 'Richard Wilson',
      'Transaction Amt': "",
      "Narration": "",
    },
    {
      'Serial No.': '00129',
      'Voucher Date': '04-05-2024',
      'Particular': "",
      'Voucher No.': " ",
      'Expense By': 'Jose Garcia',
      'Transaction Amt': "",
      "Narration": "",
    },
    {
      'Serial No.': '00130',
      'Voucher Date': '23-04-2023',
      'Particular': "",
      'Voucher No.': " ",
      'Expense By': 'Carlos Rodriguez',
      'Transaction Amt': "",
      "Narration": "",
    },
  ]; // Store the filter values
  int _pageSize = 10; // Initial page size
  int _currentPage = 1; // Current page

  List<Map<String, String>> get _pagedData {
    final startIndex = (_currentPage - 1) * _pageSize;
    final endIndex = startIndex + _pageSize;
    final filteredData = _hostelerData;
    if (startIndex > filteredData.length) {
      return [];
    }
    return filteredData.sublist(
      startIndex,
      endIndex > filteredData.length ? filteredData.length : endIndex,
    );
  } // Function to handle page change

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  } // Function to handle page size change

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
                    "Expense Report ",
                    style: TextStyle(
                      color: AppColor.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            addMasterOutside3(
              children: [
                DateRange(
                  datepickar1: datepickarFrom,
                  datepickar2: datepickarto,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    // Hosteler Type Dropdown
                    Text(
                      'Particular',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Center(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xffF3F3F3),
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xffD6D6D6),
                              blurRadius: 4,
                              spreadRadius: 3,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: DropdownButton<String>(
                          value: _selectedHostelerType,
                          isDense: true,
                          hint: const Text('--Select--'),
                          icon: Icon(Icons.keyboard_arrow_down),
                          underline: Container(),
                          items:
                              <String>[
                                'AC',
                                'Non AC',
                              ] // Add your actual options here
                              .map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedHostelerType = newValue;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
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
                    Spacer(),
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
                              // _searchQuery = value;
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
                0: FlexColumnWidth(.7),
                1: FlexColumnWidth(1),
                2: FlexColumnWidth(1),
                3: FlexColumnWidth(1),
                4: FlexColumnWidth(1),
                5: FlexColumnWidth(1),
                6: FlexColumnWidth(1),
                7: FlexColumnWidth(1),
              },
              border: TableBorder.all(color: Colors.grey),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                // Table Header Row
                TableRow(
                  decoration: BoxDecoration(color: Color(0xffE5FDDD)),
                  children: [
                    tableHeader('Sr No.'),
                    tableHeader('Voucher No.'),
                    tableHeader('Voucher Date'),
                    tableHeader('Particular'),
                    tableHeader('Narration'),
                    tableHeader('Expense By'),
                    tableHeader('Transaction Amt'),
                    tableHeader('Purpose'),
                  ],
                ),
                // Table Data Rows
                ..._pagedData.map((item) {
                  return TableRow(
                    decoration: BoxDecoration(color: AppColor.white),
                    children: [
                      tableBody(item['Serial No.'] ?? ''),
                      tableBody(item['Voucher No.'] ?? ''),
                      tableBody(item['Voucher Date'] ?? ''),
                      tableBody(item['Particular'] ?? ''),
                      tableBody(item['Narration'] ?? ''),
                      tableBody(item['Expense By'] ?? ''),
                      tableBody(item['Transaction Amt'] ?? ''),
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
                    'Page ${_currentPage} of ${(_hostelerData.length / _pageSize).ceil()}',
                  ), //display the current page and the total number of pages
                ),
                // Next Page Button
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed:
                      _currentPage < (_hostelerData.length / _pageSize).ceil()
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
