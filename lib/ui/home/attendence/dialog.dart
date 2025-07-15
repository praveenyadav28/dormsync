import 'package:dorm_sync/model/attendencemodel.dart';
import 'package:dorm_sync/ui/home/attendence/api.dart';
import 'package:dorm_sync/utils/colors.dart';
import 'package:dorm_sync/utils/prefence.dart';
import 'package:dorm_sync/utils/sizes.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PunchLogDialog extends StatefulWidget {
  final AttendenceModel student;
  final DateTime fromDate;
  final DateTime toDate;
  final bool isMessAttendence;

  const PunchLogDialog({
    required this.student,
    required this.fromDate,
    required this.toDate,
    required this.isMessAttendence,
  });

  @override
  State<PunchLogDialog> createState() => _PunchLogDialogState();
}

class _PunchLogDialogState extends State<PunchLogDialog> {
  List<DeviceLog> logs = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _fetchLogs();
  }

  Future<void> _fetchLogs() async {
    setState(() => loading = true);
    final allLogs = await ApiSalary().fetchLogs(
      DateFormat('yyyy-MM-dd').format(widget.fromDate),
      DateFormat('yyyy-MM-dd').format(widget.toDate),
    );

    final filtered =
        widget.isMessAttendence
            ? allLogs
                .where(
                  (log) =>
                      log.biomaxId.trim() ==
                          widget.student.messBiomax?.trim() &&
                      log.serialNumber.trim() ==
                          Preference.getString(PrefKeys.coludIdMess).trim(),
                )
                .toList()
            : allLogs
                .where(
                  (log) =>
                      log.biomaxId.trim() ==
                          widget.student.hostelBiomax?.trim() &&
                      log.serialNumber.trim() ==
                          Preference.getString(PrefKeys.coludIdHostel).trim(),
                )
                .toList();

    filtered.sort((a, b) => a.punchTime.compareTo(b.punchTime));

    setState(() {
      logs = filtered;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final grouped = <String, List<DeviceLog>>{};
    for (var log in logs) {
      final dateKey = DateFormat('yyyy/MM/dd').format(log.punchTime);
      grouped.putIfAbsent(dateKey, () => []).add(log);
    }

    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${widget.isMessAttendence ? "Mess" : "Hostel"} Punch Logs: ${widget.student.hostelerName}",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 6),
            Text(
              "From: ${DateFormat('dd/MM/yyyy').format(widget.fromDate)}  →  To: ${DateFormat('dd/MM/yyyy').format(widget.toDate)}",
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
            const SizedBox(height: 14),
            Expanded(
              child:
                  loading
                      ? Center(child: CircularProgressIndicator())
                      : grouped.isEmpty
                      ? Center(child: Text("No logs found"))
                      : SingleChildScrollView(
                        child: SizedBox(
                          width: Sizes.width,
                          child: Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            spacing: 14,
                            runSpacing: 14,
                            children: () {
                              final items =
                                  grouped.entries.map((entry) {
                                    return Container(
                                      width: Sizes.width * .2 - 56,
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: AppColor.primary.withOpacity(
                                          0.4,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            "📅 ${entry.key}",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15,
                                              color: AppColor.black,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Container(
                                            width: double.infinity,
                                            margin: const EdgeInsets.symmetric(
                                              vertical: 3,
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: Wrap(
                                              alignment:
                                                  WrapAlignment.spaceAround,
                                              children: [
                                                ...entry.value.asMap().entries.map((
                                                  e,
                                                ) {
                                                  final log = e.value;
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 4,
                                                          vertical: 4,
                                                        ),
                                                    child: Text(
                                                      DateFormat(
                                                        'hh:mm a',
                                                      ).format(log.punchTime),
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 13,
                                                        color: AppColor.black,
                                                      ),
                                                    ),
                                                  );
                                                }),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList();

                              // Add dummy widgets if the last row has < 5 items
                              int remainder = items.length % 5;
                              if (remainder != 0) {
                                int dummyCount = 5 - remainder;
                                for (int i = 0; i < dummyCount; i++) {
                                  items.add(
                                    Container(
                                      width: Sizes.width * .2 - 56,
                                      height: 0,
                                      color: Colors.transparent,
                                    ),
                                  );
                                }
                              }
                              return items;
                            }(),
                          ),
                        ),
                      ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(Icons.close),
                label: Text("Close"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
