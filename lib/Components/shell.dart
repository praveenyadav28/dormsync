import 'package:dorm_sync/Components/route_tracker.dart';
import 'package:dorm_sync/Components/section_navigator.dart';
import 'package:dorm_sync/ui/home/attendence/add_hostler.dart';
import 'package:dorm_sync/ui/home/attendence/hostler_attendence.dart';
import 'package:dorm_sync/ui/home/attendence/mess_attendence.dart';
import 'package:dorm_sync/ui/home/crm/file_info.dart';
import 'package:dorm_sync/ui/home/crm/follow_up.dart';
import 'package:dorm_sync/ui/home/crm/prospect.dart';
import 'package:dorm_sync/ui/home/crm/prospect_list.dart';
import 'package:dorm_sync/ui/home/dashboard/dashboard.dart';
import 'package:dorm_sync/ui/home/dashboard/installment.dart';
import 'package:dorm_sync/ui/home/fees/contro_expase.dart';
import 'package:dorm_sync/ui/home/fees/contro_list.dart';
import 'package:dorm_sync/ui/home/fees/fees.dart';
import 'package:dorm_sync/ui/home/fees/fees_list.dart';
import 'package:dorm_sync/ui/home/fees/fees_recieve.dart';
import 'package:dorm_sync/ui/home/fees/fees_recieve_list.dart';
import 'package:dorm_sync/ui/home/fees/meter_list.dart';
import 'package:dorm_sync/ui/home/fees/meter_reading.dart';
import 'package:dorm_sync/ui/home/hostelers/create_hostelers.dart';
import 'package:dorm_sync/ui/home/hostelers/hostelers_list.dart';
import 'package:dorm_sync/ui/home/Masters/branch/branch_list.dart';
import 'package:dorm_sync/ui/home/Masters/branch/branch_Master.dart';
import 'package:dorm_sync/ui/home/Masters/staff/staff_list.dart';
import 'package:dorm_sync/ui/home/Masters/staff/staff_Master.dart';
import 'package:dorm_sync/ui/home/leave/leave_add.dart';
import 'package:dorm_sync/ui/home/leave/leave_list.dart';
import 'package:dorm_sync/ui/home/masters/item/item_list.dart';
import 'package:dorm_sync/ui/home/masters/item/item_master.dart';
import 'package:dorm_sync/ui/home/masters/ledger/ledger_list.dart';
import 'package:dorm_sync/ui/home/masters/ledger/ledger_master.dart';
import 'package:dorm_sync/ui/home/masters/user/user_list.dart';
import 'package:dorm_sync/ui/home/masters/user/user_master.dart';
import 'package:dorm_sync/ui/home/nodues/nodues.dart';
import 'package:dorm_sync/ui/home/profile/profile.dart';
import 'package:dorm_sync/ui/home/reports/bank_report.dart';
import 'package:dorm_sync/ui/home/reports/ledger_report.dart';
import 'package:dorm_sync/ui/home/room/assign_room.dart';
import 'package:dorm_sync/ui/home/room/room_allotment.dart';
import 'package:dorm_sync/ui/home/student_status/activate_student.dart';
import 'package:dorm_sync/ui/home/student_status/activate_student_list.dart';
import 'package:dorm_sync/ui/home/student_status/deactivare_student_list.dart';
import 'package:dorm_sync/ui/home/student_status/deactivate_staudent.dart';
import 'package:dorm_sync/ui/home/visitor/add_visitor.dart';
import 'package:dorm_sync/ui/home/visitor/visitor_list.dart';
import 'package:dorm_sync/ui/home/voucher/create_voucher.dart';
import 'package:dorm_sync/ui/home/voucher/voucher_list.dart';
import 'package:dorm_sync/ui/onboarding/login.dart';
// import 'package:dorm_sync/ui/home/reports/expanse_report.dart';
import 'package:dorm_sync/ui/home/reports/fees_resport.dart';
import 'package:dorm_sync/ui/home/reports/leave_report.dart';
import 'package:dorm_sync/ui/home/reports/student_history.dart';
import 'package:dorm_sync/ui/onboarding/splash.dart';
import 'package:dorm_sync/ui/utilities/session.dart';
import 'package:dorm_sync/utils/api.dart';
import 'package:dorm_sync/utils/colors.dart';
import 'package:dorm_sync/utils/decoration.dart';
import 'package:dorm_sync/utils/images.dart';
import 'package:dorm_sync/utils/navigations.dart';
import 'package:dorm_sync/utils/prefence.dart';
import 'package:dorm_sync/utils/sizes.dart';
import 'package:dorm_sync/utils/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Shell extends StatefulWidget {
  const Shell({super.key});
  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  XFile? _image; // for picked image
  String? _profileUrl; // for API image URL
  final ImagePicker _picker = ImagePicker();
  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() => _image = image);

        final licenceNo = Preference.getString(PrefKeys.licenseNo);
        final branchId = Preference.getint(PrefKeys.locationId);

        // Upload using the universal uploader
        final uploaded = await ApiService.uploadFiles(
          endpoint: "profile",
          fields: {"licence_no": licenceNo, "branch_id": branchId.toString()},
          singleFiles: {"profile": image},
        );

        if (uploaded["status"] == true) {
          _loadProfile(); // refresh from API
        } else {
          debugPrint(
            "❌ Upload failed: ${uploaded["message"] ?? "Unknown error"}",
          );
        }
      }
    } catch (e) {
      debugPrint("❌ Error picking or uploading image: $e");
    }
  }

  Future<void> _loadProfile() async {
    try {
      final data = await ApiService.fetchData(
        "profile?licence_no=${Preference.getString(PrefKeys.licenseNo)}&branch_id=${Preference.getint(PrefKeys.locationId)}",
      );

      if (data['status'] == true &&
          data['data'] != null &&
          data['data'].isNotEmpty) {
        setState(() {
          _profileUrl = data['data'][0]["profile"];
        });
      }
    } catch (e) {
      debugPrint("❌ Error loading profile: $e");
    }
  }

  int _tab = 0;
  List<bool> _isHovering = List.filled(15, false); // One per menu item

  /// navigator keys (fixed)
  final _navKeys = List.generate(15, (_) => GlobalKey<NavigatorState>());

  /// route trackers will be created in initState so we can pass setState
  late final List<RouteTracker> _trackers;

  static const _titles = [
    'Dashboard',
    'Reports',
    'Hostelers',
    'Rooms',
    'Master',
    'Fees',
    'Guests',
    'Leave List',
    'Attendance',
    'Mess Attendance',
    'Vouchers',
    'CRM',
    'No Dues',
    "Utilities",
    'Log out',
  ];
  static final _icons = [
    Images.dashboard,
    Images.reports,
    Images.hostelers,
    Images.rooms,
    Images.masters,
    Images.fees,
    Images.guests,
    Images.leave,
    Images.attendance,
    Images.mess,
    Images.voucher,
    Images.crm,
    Images.nodues,
    Images.utilities,
    Images.logout,
  ];

  /// Route tables per tab
  final _routes = [
    {
      '/': (ctx) => const DashboardScreen(),
      '/installments': (ctx) => AllInstallmentsScreen(),
    },
    {
      '/student Report': (ctx) => const StudentHistoryList(),
      '/leave report': (ctx) => const LeaveReportList(),
      '/fees report': (ctx) => const FeesReportList(),
      '/ledger report': (ctx) => const LedgerReport(),
      '/bank report': (ctx) => const BankReport(),
    },
    {
      '/': (ctx) => const HostelersList(),
      '/admission form': (ctx) => CreateHostelers(),
    },
    {
      '/': (ctx) => const RoomAllotment(),
      '/assign Room': (ctx) => const AssignRoom(),
    },
    {
      '/branch Master': (ctx) => const BranchListScreen(),
      '/create branch': (ctx) => const CreateBranch(),
      '/staff Master': (ctx) => const StaffListScreen(),
      '/create Staff': (ctx) => const CreateStaff(),
      '/item Master': (ctx) => const ItemListScreen(),
      '/create Item': (ctx) => const CreateItem(),
      '/ledger Master': (ctx) => const LedgerListScreen(),
      '/create Ledger': (ctx) => const CreateLedger(),
      '/user Master': (ctx) => const UserListScreen(),
      '/create User': (ctx) => const CreateUser(),
    },
    {
      '/fees List': (ctx) => const FeesListScreen(),
      '/fees Entry': (ctx) => const FeesEntry(),
      '/fees Receive List': (ctx) => const FeesReceiveListScreen(),
      '/fees Receive': (ctx) => const FeesReceive(),
      '/meter Reading List': (ctx) => const MeterListScreen(),
      '/meter Reading': (ctx) => MeterReadingAdd(),
      '/hostler Expanse List': (ctx) => ContraExpanseListScreen(),
      '/hostler Expanse': (ctx) => CreateContraExpanse(),
    },
    {
      '/': (ctx) => const VisitorListScreen(),
      '/visitor Add': (ctx) => const VisitorAdd(),
    },
    {
      '/': (ctx) => const LeaveListScreen(),
      '/add Leave': (ctx) => const LeaveAdd(),
    },
    {
      '/': (ctx) => const HostlerAttendenceList(),
      '/add Hostler': (ctx) => const AddHostler(),
    },
    {
      '/': (ctx) => const MessAttendenceList(),
      '/add Hostler': (ctx) => const AddHostler(),
    },
    {
      '/': (ctx) => const VoucherListScreen(),
      '/create Voucher': (ctx) => const CreateVoucher(),
    },
    {
      '/': (ctx) => const ProspectListScreen(),
      '/create Prospect': (ctx) => const ProspectCRM(),
      '/view Prospect': (ctx) => const FileInfo(),
      '/follow Up': (ctx) => const FollowUpCRM(),
    },
    {'/': (ctx) => const NoDuesCheck()},
    {
      '/session': (ctx) => SessionScreen(),
      '/deactivated List': (ctx) => DeactivatedListScreen(),
      '/deactive Student': (ctx) => DeactivateStudent(),
      '/reactivated List': (ctx) => ReactivatedListScreen(),
      '/reactive Student': (ctx) => ReactivateStudent(),
    },
    {'/': (ctx) => const CompanyProfile()},
  ];

  @override
  @override
  void initState() {
    super.initState();
    _loadProfile();
    _trackers = List.generate(15, (_) => RouteTracker(() => setState(() {})));
  }

  bool hasAccess(String menu) {
    final rights = Preference.getString(PrefKeys.rights);
    if (rights.isEmpty) return false;

    final rightsList = rights.split(',').map((e) => e.trim()).toList();

    if (rightsList.contains("[All]")) return true; // ✅ super-admin
    return rightsList.contains(menu);
  }

  StyleText textstyles = StyleText();
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      toolbarHeight: 80,
      elevation: 0,
      automaticallyImplyLeading: false,
      actions: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 30),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(Images.logo, width: 170),
                  Text(
                    'Your Hostel’s Digital Partner',
                    style: textstyles
                        .merriweatherText(10, FontWeight.w600, AppColor.black)
                        .copyWith(fontStyle: FontStyle.italic),
                  ),
                ],
              ),
              SizedBox(width: Sizes.width * .07),
              InkWell(
                onTap: () {
                  setState(() {
                    _tab = 0;
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: _tab == 0 ? AppColor.primary : AppColor.transparent,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Dashboard",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w500,
                          color:
                              _tab == 0 ? AppColor.white : AppColor.lightblack,
                        ),
                      ),
                      SizedBox(width: 20),
                      _tab == 0
                          ? Image.asset(Images.dashboard, color: AppColor.white)
                          : Image.asset(Images.dashboard),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 30),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  onPressed: () {
                    pushNdRemove(SplashScreen());
                  },
                  icon: Icon(Icons.repeat, color: AppColor.primary),
                ),
              ),
              Spacer(),
              if (Preference.getString(PrefKeys.isPG) == "Hostel")
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: AppColor.white,
                        boxShadow: [
                          BoxShadow(
                            spreadRadius: 1,
                            color: AppColor.black81,
                            blurRadius: 4,
                          ),
                        ],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        Preference.getString(PrefKeys.sessionDate),
                        style: TextStyle(
                          color: AppColor.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              SizedBox(width: 30),
              Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4, right: 4),
                        child: CircleAvatar(
                          maxRadius: 26,
                          backgroundColor: AppColor.grey,
                          backgroundImage:
                              _image != null
                                  ? NetworkImage(
                                    _image!.path,
                                  ) // preview picked image
                                  : _profileUrl != null
                                  ? NetworkImage(_profileUrl!) // show API image
                                  : null,
                          child:
                              (_image == null && _profileUrl == null)
                                  ? Icon(
                                    Icons.camera_alt,
                                    color: AppColor.black81,
                                  )
                                  : null,
                        ),
                      ),
                      (_image == null && _profileUrl == null)
                          ? InkWell(
                            onTap: _pickImage,
                            child: Image.asset(Images.edittool, height: 18),
                          )
                          : Container(),
                    ],
                  ),
                  Text(
                    Preference.getString(PrefKeys.branchName),
                    style: TextStyle(fontSize: 12, color: AppColor.black),
                  ),
                ],
              ),
              SizedBox(width: 30),
            ],
          ),
        ),
      ],
      backgroundColor: AppColor.white,
    ),

    backgroundColor: AppColor.white,

    body: Row(
      children: [
        Container(
          width: 230,
          color: AppColor.white,
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: ListView.builder(
            itemCount: _titles.length,
            itemBuilder: (context, i) {
              final title = _titles[i];
              // skip Dashboard and Logout
              if (i != 0 && i != 14 && !hasAccess(title)) {
                return const SizedBox.shrink(); // hide menu if no access
              }

              final isSelected = _tab == i;
              final onHover = _isHovering[i];
              return MouseRegion(
                onEnter:
                    (_) => setState(
                      () => _isHovering[i] = _tab == i ? false : true,
                    ),
                onExit: (_) => setState(() => _isHovering[i] = false),
                child: InkWell(
                  // onTap:
                  //     () => setState(() {
                  //       _tab = i;
                  //       _isHovering[i] = false;
                  //     }),
                  onTap: () async {
                    if (i == 1) {
                      // Reports tab clicked — show popup
                      final selected = await showMenu<String>(
                        context: context,
                        position: RelativeRect.fromLTRB(0, 100, 0, 0),
                        items: [
                          if (hasAccess("Student Report"))
                            PopupMenuItem(
                              value: '/student Report',
                              child: Text('Student Report'),
                            ),
                          if (hasAccess("Leave Report"))
                            PopupMenuItem(
                              value: '/leave report',
                              child: Text('Leave Report'),
                            ),
                          if (hasAccess("Fees Report"))
                            PopupMenuItem(
                              value: '/fees report',
                              child: Text('Fees Report'),
                            ),
                          if (hasAccess("Ledger Report"))
                            PopupMenuItem(
                              value: '/ledger report',
                              child: Text('Ledger Report'),
                            ),
                          if (hasAccess("Bank Report"))
                            PopupMenuItem(
                              value: '/bank report',
                              child: Text('Bank Report'),
                            ),
                        ],
                      );

                      if (selected != null) {
                        setState(() => _tab = 1);
                        _navKeys[1].currentState?.pushReplacementNamed(
                          selected,
                        );
                      }
                    } else if (i == 4) {
                      // Masters
                      final selected = await showMenu<String>(
                        context: context,
                        position: RelativeRect.fromLTRB(0, 140, 0, 0),
                        items: [
                          if (Preference.getBool(PrefKeys.isMain) &&
                              hasAccess("Branch Master"))
                            PopupMenuItem(
                              value: '/branch Master',
                              child: Text('Branch Master'),
                            ),
                          if (hasAccess("Staff Master"))
                            PopupMenuItem(
                              value: '/staff Master',
                              child: Text('Staff Master'),
                            ),
                          if (hasAccess("Ledger Master"))
                            PopupMenuItem(
                              value: '/ledger Master',
                              child: Text('Ledger Master'),
                            ),
                          if (hasAccess("Item Master"))
                            PopupMenuItem(
                              value: '/item Master',
                              child: Text('Item Master'),
                            ),
                          if (hasAccess("User Master"))
                            PopupMenuItem(
                              value: '/user Master',
                              child: Text('User Master'),
                            ),
                        ],
                      );

                      if (selected != null) {
                        setState(() => _tab = 4);
                        _navKeys[4].currentState?.pushReplacementNamed(
                          selected,
                        );
                      }
                    } else if (i == 5) {
                      // Fees
                      final selected = await showMenu<String>(
                        context: context,
                        position: RelativeRect.fromLTRB(0, 240, 0, 0),
                        items: [
                          if (hasAccess("Fees Entry"))
                            PopupMenuItem(
                              value: '/fees List',
                              child: Text('Fees Entry'),
                            ),
                          if (hasAccess("Fees Receive"))
                            PopupMenuItem(
                              value: '/fees Receive List',
                              child: Text('Fees Receive'),
                            ),
                          PopupMenuItem(
                            value: '/meter Reading List',
                            child: Text('Meter Reading'),
                          ),
                          PopupMenuItem(
                            value: '/hostler Expanse List',
                            child: Text('Hoslter Expanse'),
                          ),
                        ],
                      );

                      if (selected != null) {
                        setState(() => _tab = 5);
                        _navKeys[5].currentState?.pushReplacementNamed(
                          selected,
                        );
                      }
                    } else if (i == 13) {
                      // Utilities
                      final selected = await showMenu<String>(
                        context: context,
                        position: RelativeRect.fromLTRB(
                          0,
                          Sizes.height * .9,
                          0,
                          100,
                        ),
                        items: [
                          if (hasAccess("Session") &&
                              Preference.getString(PrefKeys.isPG) == "Hostel")
                            PopupMenuItem(
                              value: '/session',
                              child: Text('Session'),
                            ),
                          if (hasAccess("Deactivate Student"))
                            PopupMenuItem(
                              value: '/deactivated List',
                              child: Text('Deactivate Student'),
                            ),
                          if (hasAccess("Re-activate Student"))
                            PopupMenuItem(
                              value: '/reactivated List',
                              child: Text('Re-activate Student'),
                            ),
                        ],
                      );

                      if (selected != null) {
                        setState(() => _tab = 13);
                        _navKeys[13].currentState?.pushReplacementNamed(
                          selected,
                        );
                      }
                    } else if (i == 14) {
                      logoutPrefData();
                      pushNdRemove(LoginScreen());
                    } else {
                      setState(() {
                        _tab = i;
                        _isHovering[i] = false;
                      });
                    }
                  },
                  child:
                      i == 0
                          ? Container()
                          : Container(
                            margin: EdgeInsets.symmetric(vertical: 4),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration:
                                onHover
                                    ? insideShadow()
                                    : BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      color:
                                          isSelected
                                              ? AppColor.primary
                                              : Colors.transparent,
                                    ),
                            child: Row(
                              children: [
                                Image.asset(
                                  _icons[i],
                                  height: 24,
                                  color:
                                      _titles[i] == "Log out"
                                          ? null
                                          : isSelected
                                          ? AppColor.white
                                          : AppColor.black81,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    _titles[i],
                                    style: textstyles.merriweatherText(
                                      16.5,
                                      FontWeight.w600,
                                      _titles[i] == "Log out"
                                          ? AppColor.red
                                          : isSelected
                                          ? AppColor.white
                                          : AppColor.black81,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                ),
              );
            },
          ),
        ),
        VerticalDivider(width: 1, color: AppColor.primary),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Divider(height: 1, color: AppColor.primary),
              Container(
                width: double.infinity,
                color: AppColor.background,
                child: _breadcrumb(),
              ),
              Expanded(
                child: IndexedStack(
                  index: _tab,
                  children: List.generate(
                    15,
                    (i) => SectionNavigator(
                      navigatorKey: _navKeys[i],
                      routes: _routes[i],
                      observer: _trackers[i],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  /// ----------- Breadcrumb ------------------------------------
  Widget _breadcrumb() {
    final stack = _trackers[_tab].stack;
    if (stack.isEmpty) return Text(_titles[_tab]);

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: Sizes.height * .02,
        horizontal: Sizes.width * .015,
      ),
      child: Wrap(
        spacing: 10,
        children: List.generate(stack.length, (i) {
          final isLast = i == stack.length - 1;
          final label = _routeLabel(stack[i]);
          return InkWell(
            onTap: () {
              _navKeys[_tab].currentState?.popUntil(
                (r) => r == stack[i],
              ); // pop to that route
              // setState will be called by RouteTracker automatically
            },
            child: Text(
              (label.isEmpty)
                  ? "$label/"
                  : label[0].toUpperCase() + label.substring(1) + "/",
              style: TextStyle(
                fontSize: 18,
                // fontWeight: !isLast ? FontWeight.w400 : FontWeight.w500,
                color: !isLast ? AppColor.black : AppColor.primary2,
              ),
            ),
          );
        }),
      ),
    );
  }

  String _routeLabel(Route r) {
    final name = r.settings.name ?? '';
    if (name.isEmpty || name == '/') return _titles[_tab];
    return name.split('/').last.replaceAll('-', ' ');
  }
}
