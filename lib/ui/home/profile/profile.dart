import 'package:dorm_sync/utils/colors.dart';
import 'package:dorm_sync/utils/field_cover.dart';
import 'package:dorm_sync/utils/images.dart';
import 'package:dorm_sync/utils/sizes.dart';
import 'package:dorm_sync/utils/textformfield.dart';
import 'package:flutter/material.dart';

class CompanyProfile extends StatefulWidget {
  const CompanyProfile({super.key});

  @override
  State<CompanyProfile> createState() => _CompanyProfileState();
}

class _CompanyProfileState extends State<CompanyProfile> {
  String? _selectedstate;
  final List<String> _stateList = [];

  String? _selectedcity;
  final List<String> _cityList = [];

  int selectedStatus = 0;

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Basic Company Details  ',
                  style: TextStyle(
                    color: AppColor.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 17,
                  ),
                ),
                Expanded(child: Divider(color: AppColor.black)),
                Expanded(child: Container()),
              ],
            ),
            SizedBox(height: Sizes.height * 0.04),
            addMasterOutside(
              children: [
                CommonTextField(
                  image: Images.business,
                  hintText: 'Business Name*',
                ),

                Row(
                  children: [
                    Image.asset(Images.businessType),
                    SizedBox(width: 5),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedstate,
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: AppColor.primary,
                        ),
                        hint: Text(
                          "Type of Business*",
                          style: TextStyle(
                            color: AppColor.black81,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _selectedstate = value;
                          });
                        },
                        items:
                            _stateList.map((state) {
                              return DropdownMenuItem(
                                value: state,
                                child: Text(
                                  state,
                                  style: TextStyle(
                                    color: AppColor.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              );
                            }).toList(),
                        decoration: InputDecoration(
                          isDense: true,
                          border: UnderlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                CommonTextField(image: Images.owner, hintText: 'Owner Name*'),
                CommonTextField(image: Images.mail, hintText: 'xyz@gamil.com'),
                CommonTextField(
                  image: Images.contactNo,
                  hintText: '98*******23',
                ),
                CommonTextField(image: Images.telephone, hintText: '101****3'),
              ],
              context: context,
            ),
            SizedBox(height: Sizes.height * 0.06),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Business Address  ',
                  style: TextStyle(
                    color: AppColor.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 17,
                  ),
                ),
                Expanded(child: Divider(color: AppColor.black)),
                Expanded(child: Container()),
              ],
            ),
            SizedBox(height: Sizes.height * 0.04),
            addMasterOutside(
              children: [
                CommonTextField(
                  image: Images.location,
                  hintText: 'Address (Area and Street)',
                ),
                CommonTextField(
                  image: Images.location,
                  hintText: 'Address Line-2',
                ),
                CommonTextField(image: Images.pincode, hintText: 'Pin Code*'),
                CommonTextField(image: Images.std, hintText: 'STD Code'),

                Row(
                  children: [
                    Image.asset(Images.state),
                    SizedBox(width: 5),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedstate,
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: AppColor.primary,
                        ),
                        hint: Text(
                          "--Select State--",
                          style: TextStyle(
                            color: AppColor.black81,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _selectedstate = value;
                          });
                        },
                        items:
                            _stateList.map((state) {
                              return DropdownMenuItem(
                                value: state,
                                child: Text(
                                  state,
                                  style: TextStyle(
                                    color: AppColor.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              );
                            }).toList(),
                        decoration: InputDecoration(
                          isDense: true,
                          border: UnderlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Image.asset(Images.selectCity),
                    SizedBox(width: 5),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedcity,
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: AppColor.primary,
                        ),
                        hint: Text(
                          "--Select City--",
                          style: TextStyle(
                            color: AppColor.black81,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _selectedcity = value;
                          });
                        },
                        items:
                            _cityList.map((city) {
                              return DropdownMenuItem(
                                value: city,
                                child: Text(
                                  city,
                                  style: TextStyle(
                                    color: AppColor.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              );
                            }).toList(),
                        decoration: InputDecoration(
                          isDense: true,
                          border: UnderlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                CommonTextField(
                  image: Images.town,
                  hintText: 'City/Town/Village',
                ),
              ],
              context: context,
            ),
            SizedBox(height: Sizes.height * 0.06),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Other Business Info  ',
                  style: TextStyle(
                    color: AppColor.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 17,
                  ),
                ),
                Expanded(child: Divider(color: AppColor.black)),
                Expanded(child: Container()),
              ],
            ),
            SizedBox(height: Sizes.height * 0.04),
            addMasterOutside(
              children: [
                CommonTextField(
                  image: Images.information,
                  hintText: 'Information-1',
                ),
                CommonTextField(
                  image: Images.information,
                  hintText: 'Information-2',
                ),
                CommonTextField(
                  image: Images.information,
                  hintText: 'Information-3',
                ),
              ],
              context: context,
            ),

            SizedBox(height: Sizes.height * .04),
          ],
        ),
      ),
    );
  }
}
