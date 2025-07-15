import 'package:dorm_sync/utils/buttons.dart';
import 'package:dorm_sync/utils/colors.dart';
import 'package:dorm_sync/utils/field_cover.dart';
import 'package:dorm_sync/utils/images.dart';
import 'package:dorm_sync/utils/reuse.dart';
import 'package:dorm_sync/utils/sizes.dart';
import 'package:dorm_sync/utils/textformfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FeesReportList extends StatefulWidget {
  const FeesReportList({super.key});
  @override
  State<FeesReportList> createState() => _FeesReportListState();
}

class _FeesReportListState extends State<FeesReportList> {
  String? _selectedHostelerType;
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
  // Sample data for the table
  final List<Map<String, String>> _hostelerData = [
    {
      'Hosteler ID': '00123',
      'Visit Date': '19-05-2024',
      'Hosteler Name': 'John Smith',
      'Visitor Name': 'John Smith',
      'Father Name': 'David Smith',
      'Contact Details': '96545214552',
      'Relation': "Mama",
      "Staying Time": "5 hours",
    },
    {
      'Hosteler ID': '00124',
      'Visit Date': '23-04-2023',
      'Hosteler Name': 'Alice Johnson',
      'Visitor Name': 'Alice Johnson',
      'Father Name': 'Robert Johnson',
      'Contact Details': '88545214552',
      'Relation': "Mama",
      "Staying Time": "5 hours",
    },
    {
      'Hosteler ID': '00125',
      'Visit Date': '19-05-2024',
      'Hosteler Name': 'Bob Williams',
      'Visitor Name': 'Bob Williams',
      'Father Name': 'Michael Williams',
      'Contact Details': '9998887777',
      'Relation': "Mama",
      "Staying Time": "5 hours",
    },
    {
      'Hosteler ID': '00126',
      'Visit Date': '28-07-2023',
      'Hosteler Name': 'Emily Brown',
      'Visitor Name': 'Emily Brown',
      'Father Name': 'James Brown',
      'Contact Details': '7412589630',
      'Relation': "Mama",
      "Staying Time": "5 hours",
    },
    {
      'Hosteler ID': '00127',
      'Visit Date': '01-05-2024',
      'Hosteler Name': 'Michael Davis',
      'Visitor Name': 'Michael Davis',
      'Father Name': 'Thomas Davis',
      'Contact Details': '8529637410',
      'Relation': "Mama",
      "Staying Time": "5 hours",
    },
    {
      'Hosteler ID': '00128',
      'Visit Date': '05-04-2025',
      'Hosteler Name': 'Jessica Wilson',
      'Visitor Name': 'Jessica Wilson',
      'Father Name': 'Richard Wilson',
      'Contact Details': '9638527410',
      'Relation': "Mama",
      "Staying Time": "5 hours",
    },
    {
      'Hosteler ID': '00129',
      'Visit Date': '04-05-2024',
      'Hosteler Name': 'David Garcia',
      'Visitor Name': 'David Garcia',
      'Father Name': 'Jose Garcia',
      'Contact Details': '7539514862',
      'Relation': "Mama",
      "Staying Time": "5 hours",
    },
    {
      'Hosteler ID': '00130',
      'Visit Date': '23-04-2023',
      'Hosteler Name': 'Linda Rodriguez',
      'Visitor Name': 'Linda Rodriguez',
      'Father Name': 'Carlos Rodriguez',
      'Contact Details': '8521479630',
      'Relation': "Mama",
      "Staying Time": "5 hours",
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
                    "Fees Report",
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
                  datepickar1: datepickarfrom,
                  datepickar2: datepickarto,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    // Hosteler Type Dropdown
                    Text(
                      'Hosteler Type',
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
                CommonTextField(
                  image: Images.hosteler,
                  hintText: "Hostler Name",
                ),
              ],
              context: context,
            ),
            addMasterOutside(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 3),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Color(0xffE6F77B),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    "Total Fees  ||  19,600",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 3),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Color(0xffA8EAB0),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    "Recieved  ||  19,600",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 3),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Color(0xffF6B1B1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    "Outstanding  ||  19,600",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
                  ),
                ),
              ],
              context: context,
            ),
            SizedBox(height: Sizes.height * 0.02),
            // Data Table
            Table(
              columnWidths: const {
                0: FlexColumnWidth(.6),
                1: FlexColumnWidth(.8),
                2: FlexColumnWidth(1),
                3: FlexColumnWidth(1),
                4: FlexColumnWidth(.6),
                5: FlexColumnWidth(.6),
                6: FlexColumnWidth(.6),
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
                // Table Header Row
                TableRow(
                  decoration: BoxDecoration(color: Color(0xffE5FDDD)),
                  children: [
                    tableHeader('H-ID'),
                    tableHeader('Adm. Date'),
                    tableHeader('Hosteler Name'),
                    tableHeader('Father Name'),
                    tableHeader('EMI\n<Total>'),
                    tableHeader('EMI\nRecieved'),
                    tableHeader('Floor'),
                    tableHeader('Type'),
                    tableHeader('Room'),
                    tableHeader('Fees'),
                    tableHeader('Recieved'),
                    tableHeader('Remaining'),
                    tableHeader('Action'),
                  ],
                ),
                // Table Data Rows
                ..._pagedData.map((item) {
                  return TableRow(
                    decoration: BoxDecoration(color: AppColor.white),
                    children: [
                      tableBody(item['Hosteler ID'] ?? ''),
                      tableBody(item['Hosteler Name'] ?? ''),
                      tableBody(item['Father Name'] ?? ''),
                      tableBody(""),
                      tableBody(""),
                      tableBody(""),
                      tableBody(""),
                      tableBody(''),
                      tableBody(''),
                      tableBody(''),
                      tableBody(''),
                      tableBody(''),
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
