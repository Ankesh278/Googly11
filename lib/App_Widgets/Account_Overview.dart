import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../Model/AccountOverview/AccountOverViewResponse.dart';
import '../Model/AccountOverview/Data.dart';

class Account_Overview extends StatefulWidget {
  const Account_Overview({super.key});

  @override
  State<Account_Overview> createState() => _Account_OverviewState();
}

class _Account_OverviewState extends State<Account_Overview> {

  AccountOverviewData? accountOverviewData;
  String _token ='';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPrefrenceData();
  }

  Future<void> getPrefrenceData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token=prefs.getString("token");
    setState(() {
      _token=token!;
      fetchAccountOverviewResponse(_token);
    });
  }

  Future<AccountOverviewData?> fetchAccountOverviewResponse(String _token) async {
    final String apiUrl = 'https://admin.googly11.in/api/account-overview';
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $_token',
      },
    );
    print('Error: ${response.statusCode}');
    print('Account Overview Response::::::: ${response.body}');
    if (response.statusCode == 200) {
      AccountOverViewResponse wallelModelData=AccountOverViewResponse.fromJson(json.decode(response.body));
      if(wallelModelData.status== 1){
        setState(() {
          accountOverviewData=wallelModelData.data;
        });
        return wallelModelData.data;
      }else{

      }
      print('Response data: ${response.body}');
    } else if(response.statusCode == 401){
      AccountOverViewResponse wallelModelData=AccountOverViewResponse.fromJson(json.decode(response.body));
      if(wallelModelData.status==0){
        return wallelModelData.data;
      }
      print('Error: ${response.statusCode}');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Set this to false to hide the default back button
        backgroundColor: Color(0xff780000),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Add your back button functionality here
            Navigator.of(context).pop(); // This example assumes you want to navigate back
          },
        ),
      ),
        body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
              width: double.infinity,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10,bottom: 15),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.grey, // Set the color of the divider line
                              width: 1.0,         // Set the width of the divider line


                            ),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.0), // Adjust the vertical padding as needed
                          child: Text(
                            'Account Overview',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )

                  ),
                  Padding(
                    padding: const EdgeInsets.only(),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey, // Set the color of the divider line
                            width: 2.0,         // Set the width of the divider line
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(
                          'Cash Account',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                              'Deposit Balance :',
                              style: TextStyle(
                                  fontSize: 15),
                            ),
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Text(
                            '₹ ${accountOverviewData != null ? accountOverviewData!.totalDepositAmount.toString() : "0"}',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Withdrawable Balance :',
                          style: TextStyle(
                              fontSize: 15),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Text(
                            '₹ ${accountOverviewData != null ? accountOverviewData!.totalWithdrawalAmount.toString() : "0"}',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Winning Balance :',
                          style: TextStyle(
                              fontSize: 15),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Text(
                            '₹ ${accountOverviewData != null ? accountOverviewData!.totalWinningContest.toString() : "0"}',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15),
                          ),
                        )
                      ],
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(vertical: 15.0),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       Text(
                  //         'Tax Deducted :',
                  //         style: TextStyle(
                  //             fontSize: 15),
                  //       ),
                  //       Padding(
                  //         padding: const EdgeInsets.only(right: 20),
                  //         child: Text(
                  //           '₹ 0',
                  //           style: TextStyle(
                  //               color: Colors.black,
                  //               fontSize: 15),
                  //         ),
                  //       )
                  //     ],
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.only(),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey, // Set the color of the divider line
                            width: 2.0,         // Set the width of the divider line
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(
                          'Bonus Account',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.w500
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'All Bonus :',
                          style: TextStyle(
                              fontSize: 15),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Text(
                            '₹ ${accountOverviewData != null ? accountOverviewData!.totalDepositBonus.toString() : "0"}',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Released Bonus :',
                          style: TextStyle(
                              fontSize: 15),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Text(
                            '₹ ${accountOverviewData != null ? accountOverviewData!.totalWithdrawalBonus.toString() : "0"}',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
          ),
        ),
      )
    );
  }
}
