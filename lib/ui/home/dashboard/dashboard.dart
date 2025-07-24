import 'package:dorm_sync/model/fees.dart';
import 'package:dorm_sync/model/fees_receive.dart';
import 'package:dorm_sync/utils/api.dart';
import 'package:dorm_sync/utils/colors.dart';
import 'package:dorm_sync/utils/images.dart';
import 'package:dorm_sync/utils/prefence.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String activeHostlers = "0/0";
  String vacancyHostler = "0/0";
  String vacancyRoom = "0/0";
  int staffLength = 0;

  List<FeesList> feesList = [];
  List<ReceivedListModel> feesReceiveList = [];

  List<Map<String, dynamic>> flattenedInstallments = [];

  int totalAssigned = 0;
  int totalReceived = 0;

  @override
  void initState() {
    super.initState();
    getHostlersLength();
    getTotalVacancy();
    getRooms();
    getStaffLength();
    fetchDashboardData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // INFO BOXES
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 800;
                return GridView.count(
                  crossAxisCount: isWide ? 4 : 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: isWide ? 2.2 : 1.8,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildInfoBox(
                      "Rooms with Vacancy",
                      vacancyRoom,
                      Images.roomscount,
                      const Color(0xff90CFF1),
                    ),

                    _buildInfoBox(
                      "Hostler Vacancy",
                      vacancyHostler,
                      Images.roomVacancy,
                      const Color(0xffE7E893),
                    ),
                    _buildInfoBox(
                      "Active Hostlers",
                      activeHostlers,
                      Images.activeHostler,
                      const Color(0xffA8EAB0),
                    ),
                    _buildInfoBox(
                      "Staff Count",
                      staffLength.toString(),
                      Images.degination,
                      const Color.fromARGB(255, 237, 168, 224),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 30),

            Row(
              children: [
                // BAR CHART
                Expanded(
                  flex: 4,
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Text(
                            "Fees Report",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            color: AppColor.grey,
                            height: 1,
                            margin: EdgeInsets.symmetric(vertical: 6),
                          ),
                          SizedBox(
                            height: 290,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                  height: 200,
                                  width: 200,
                                  child: PieChart(
                                    PieChartData(
                                      sectionsSpace: 2,
                                      centerSpaceRadius: 60,
                                      sections: [
                                        PieChartSectionData(
                                          value: totalReceived.toDouble(),
                                          color: Colors.blue,
                                          title:
                                              (totalAssigned + totalReceived) ==
                                                      0
                                                  ? "0%"
                                                  : "${((totalReceived / (totalAssigned + totalReceived)) * 100).toInt()}%",
                                          titleStyle: TextStyle(
                                            color: AppColor.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          radius: 45,
                                        ),
                                        PieChartSectionData(
                                          value: totalAssigned.toDouble(),
                                          color: Colors.red,
                                          title:
                                              (totalAssigned + totalReceived) ==
                                                      0
                                                  ? "0%"
                                                  : "${((totalAssigned / (totalAssigned + totalReceived)) * 100).toInt()}%",
                                          titleStyle: TextStyle(
                                            color: AppColor.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          radius: 45,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                // Fees Info
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Spacer(flex: 4),
                                    Text(
                                      "Fees Asigned",
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    Text(
                                      "₹$totalAssigned",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Spacer(flex: 3),
                                    Text(
                                      "Received",
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      "₹$totalReceived",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Spacer(flex: 3),
                                    Text(
                                      "Outstanding",
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      "₹${totalAssigned - totalReceived}",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Spacer(flex: 4),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                if (flattenedInstallments.isNotEmpty) ...[
                  Expanded(
                    flex: 7,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(child: Container()),
                                Text(
                                  "Installment Report",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Navigator.pushNamed(
                                            context,
                                            '/installments',
                                          );
                                        },
                                        child: Icon(
                                          Icons.visibility,
                                          color: AppColor.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              width: double.infinity,
                              color: AppColor.grey,
                              height: 1,
                              margin: EdgeInsets.symmetric(vertical: 6),
                            ),

                            SizedBox(
                              height: 290,
                              child: SingleChildScrollView(
                                // scrollDirection: Axis.horizontal,
                                child: Stack(
                                  children: [
                                    DataTable(
                                      columns: const [
                                        DataColumn(label: Text("Hosteler")),
                                        DataColumn(label: Text("Father")),
                                        DataColumn(
                                          label: Text("Installment Date"),
                                        ),
                                        DataColumn(
                                          label: Text("Installment Price"),
                                        ),
                                      ],

                                      rows:
                                          flattenedInstallments.map((data) {
                                            return DataRow(
                                              cells: [
                                                DataCell(
                                                  Text(
                                                    data["hostelerName"] ?? '',
                                                  ),
                                                ),
                                                DataCell(
                                                  Text(
                                                    data["fatherName"] ?? '',
                                                  ),
                                                ),

                                                DataCell(
                                                  Text(
                                                    data["installmentDate"] ??
                                                        '',
                                                  ),
                                                ),
                                                DataCell(
                                                  Text(
                                                    "₹${data["installmentPrice"]?.toStringAsFixed(2) ?? '0.00'}",
                                                  ),
                                                ),
                                              ],
                                            );
                                          }).toList(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBox(String title, String value, String icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 8)],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColor.white,
            ),
            child: Image.asset(icon, height: 25),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: AppColor.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColor.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> getHostlersLength() async {
    var response = await ApiService.fetchData(
      "admissionform?licence_no=${Preference.getString(PrefKeys.licenseNo)}",
    );
    if (response["status"] == true) {
      final total = response["data"].length;
      final active =
          response["data"].where((s) => s['active_status'] == 1).length;
      setState(() {
        activeHostlers = "$active/$total";
      });
    }
  }

  Future<void> getStaffLength() async {
    var response = await ApiService.fetchData(
      "staff?licence_no=${Preference.getString(PrefKeys.licenseNo)}",
    );
    if (response["status"] == true) {
      setState(() {
        staffLength = response['data'].length;
      });
    }
  }

  Future<void> getTotalVacancy() async {
    var response = await ApiService.fetchData(
      "bade_occupants?licence_no=${Preference.getString(PrefKeys.licenseNo)}",
    );
    if (response["status"] == true) {
      setState(() {
        vacancyHostler =
            "${response['total_occupants']}/${response['total_beds']}";
      });
    }
  }

  Future<void> fetchDashboardData() async {
    final sessionId = Preference.getint(PrefKeys.sessionId);

    final feesResponse = await ApiService.fetchData(
      "fees_isactive?session_id=$sessionId",
    );
    final receiveResponse = await ApiService.fetchData(
      "fees_received?session_id=$sessionId",
    );
    if (feesResponse["status"] == true && receiveResponse["status"] == true) {
      feesList = feesListFromJson(feesResponse['data']);
      feesReceiveList = feesReceiveModelFromJson(receiveResponse['data']);

      totalAssigned = feesList.fold<int>(
        0,
        (sum, item) => sum + (item.totalRemaining ?? 0),
      );

      totalReceived = feesReceiveList.fold<int>(
        0,
        (sum, item) => sum + (int.tryParse(item.amount ?? "0") ?? 0),
      );

      // 👉 Generate flattened installments list
      flattenedInstallments = getFlattenedInstallments(feesList);

      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to load dashboard data")),
      );
    }
  }

  List<Map<String, dynamic>> getFlattenedInstallments(List<FeesList> feesList) {
    List<Map<String, dynamic>> flattened = [];

    for (var fee in feesList) {
      for (var installment in fee.installmentStructure ?? []) {
        DateTime? parsedDate;
        try {
          parsedDate = DateFormat("dd/MM/yyyy").parse(installment.date ?? "");
        } catch (_) {
          parsedDate = null;
        }

        // 👉 Skip if date is null or before today
        if (parsedDate == null || parsedDate.isBefore(DateTime.now())) {
          continue;
        }

        flattened.add({
          "hostelerName": fee.hostelerName,
          "fatherName": fee.fatherName,
          "totalRemaining": fee.totalRemaining,
          "installmentDate": installment.date,
          "installmentPrice": installment.price,
          "parsedDate": parsedDate,
        });
      }
    }

    // ✅ Sort by parsed date (ascending)
    flattened.sort((a, b) {
      final dateA = a["parsedDate"] as DateTime?;
      final dateB = b["parsedDate"] as DateTime?;
      if (dateA == null) return 1;
      if (dateB == null) return -1;
      return dateA.compareTo(dateB);
    });

    return flattened;
  }

  Future<void> getRooms() async {
    final response = await ApiService.fetchData('room');
    if (response["status"] == true) {
      setState(() {
        List<Map<String, dynamic>> rooms = List<Map<String, dynamic>>.from(
          response["data"],
        );

        List<Map<String, dynamic>> fullRoom =
            rooms
                .where((r) => r['occupancy_status'].toString().contains("Full"))
                .toList();
        vacancyRoom = "${rooms.length - fullRoom.length}/${rooms.length}";
      });
    }
  }
}
