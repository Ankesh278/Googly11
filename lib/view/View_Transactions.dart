import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:world11/Model/TransactionHistoryModel/Data.dart';
import 'package:world11/Model/TransactionHistoryModel/TransactionHistroryModel.dart';
import 'package:world11/bottom_navigation_bar/home_screen.dart';
import 'package:world11/resourses/Image_Assets/image_assets.dart';
import 'package:world11/view/Download_Invoice.dart';
import 'package:http/http.dart' as http;
import 'package:world11/view/HistoryDetailsView.dart';

class ViewTransactions extends StatefulWidget {
  const ViewTransactions({Key? key}) : super(key: key);
  @override
  State<ViewTransactions> createState() => _ViewTransactionsState();
}

class _ViewTransactionsState extends State<ViewTransactions> {
  String selectedOption = 'amount'; // Initial selected option
  String _token = '';
  Future<List<MainTransactionData>?>? dataList;
  List<MainTransactionData> allTransactionData = [];
  bool isLoading_More=false;
  int page =1;
  final ScrollController scrollController=ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_scrollListener);
    getPreferenceData();
  }

  Future<void> _scrollListener() async {
    if (isLoading_More) return;
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
      setState(() {
        isLoading_More = true;
      });

      print("Page:::::::::" + page.toString());
      page = page + 1;
      await fetchDataTransactions(page);
      setState(() {
        isLoading_More = false;
      });
    } else {
      print('Do not call');
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  final List<String> categories = [
    'amount',
    'bonus',
    'contest',
  ];
  List <String> selectedCategories = [];

  final Map<String, String> categoryDisplayText = {
    'amount': 'All Withdraw and Deposits Amount',
    'bonus': 'All Bonus Amount',
    'contest': 'All Contest Trans',
  };

  Future<void> getPreferenceData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    setState(() {
      _token = token!;
    });
    fetchData(selectedOption);
  }

  Future<void> fetchData(String selectedOption) async {
    try {
      final List<MainTransactionData>? data =
      await fetchDataTransactions(page);
      if (data != null && data.isNotEmpty) {
        setState(() {
          dataList = Future.value(data);
        });
      } else {
        setState(() {
          dataList = Future.value([]);
        });
        // Fluttertoast.showToast(
        //     msg: "No transaction history available", textColor: Colors.redAccent);
      }
    } catch (error) {
      print("Error fetching data: $error");
      Fluttertoast.showToast(
          msg: "Failed to fetch data", textColor: Colors.redAccent);
    }
  }

  Future<List<MainTransactionData>?> fetchDataTransactions(int page) async {
    final String apiUrl =
        'https://admin.googly11.in/api/get_all_transaction?&per_page=10&page=$page';
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $_token'
        },
      );
      print('API Response: ${response.body}');
      print('Error: ${response.statusCode}');
      if (response.statusCode == 200) {
        TransactionHistroryModel transactionHistroryModel =
        TransactionHistroryModel.fromJson(json.decode(response.body));
        print('API Response::::::: ${response.body}');
        print('Error:::::: ${response.statusCode}');
        if(transactionHistroryModel != null) {
          if (transactionHistroryModel.status == 1) {
            allTransactionData = allTransactionData + (transactionHistroryModel.transactionData?.data ?? []);
            return transactionHistroryModel.transactionData!.data;
          } else {
            return transactionHistroryModel.transactionData!.data;
          }
        }
      } else if (response.statusCode == 400) {
        TransactionHistroryModel transactionHistroryModel =
        TransactionHistroryModel.fromJson(json.decode(response.body));
        print('API Response::: ${response.body}');
        print('Error::: ${response.statusCode}');
        if (transactionHistroryModel.status == 1) {
          return transactionHistroryModel.transactionData!.data;
        } else {
          Fluttertoast.showToast(
              msg: "UnAuthenticated", textColor: Colors.redAccent);
          return transactionHistroryModel.transactionData!.data;
        }
      } else if (response.statusCode == 402) {
        TransactionHistroryModel transactionHistroryModel =
        TransactionHistroryModel.fromJson(json.decode(response.body));
        if (transactionHistroryModel.status == 1) {
          return transactionHistroryModel.transactionData!.data;
        } else {
          Fluttertoast.showToast(
              msg: "UnExpected Error", textColor: Colors.redAccent);
          return transactionHistroryModel.transactionData!.data;
        }
      }

    } catch (error) {
      print('Exception: $error');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Transaction',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xff780000),
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.white,),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => HomeScreen()));
          },
        ),
      ),
      body: Container(
        height: size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "My Transactions",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Download_Invoice()));
                    },
                    child: Text(
                      "Download invoice",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.blue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding:
              const EdgeInsets.only(left: 10, right: 10, top: 8),
              child: Divider(
                height: 1.5,
                color: Colors.grey,
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children:categories.map((player_winner) => Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: FilterChip(
                      elevation: 2,
                      label: Text(categoryDisplayText[player_winner] ?? player_winner),
                      selected: selectedCategories.contains(player_winner),
                      onSelected: (selected){
                        setState(() {
                          if(selected){
                            selectedCategories.add(player_winner)                                                                                                          ;
                          }else{
                            selectedCategories.remove(player_winner);
                          }
                        });
                      }),
                ),
                ).toList(),
              ),),
            Expanded(
              child: FutureBuilder<List<MainTransactionData>?>(
                future: dataList,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child:  SpinKitFadingCircle(
          color: Colors.redAccent,
          size: 50.0,
        ));
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No transaction history available'));
                  } else if(snapshot.connectionState == ConnectionState.done){
                    final filterProduct = allTransactionData.where((categories) {
                      return selectedCategories.isEmpty || selectedCategories.contains(categories.transactionCategory);
                    }).toList();
                    return ListView.separated(
                      controller : scrollController,
                      itemCount: isLoading_More ? filterProduct.length : filterProduct.length,
                      separatorBuilder: (context, index) => Divider(
                        height: 2,
                        color: Colors.grey,
                      ),
                      itemBuilder: (BuildContext context, int index) {

                        final event = filterProduct[index];
                        return InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                HistoryDetailsView(
                              price: event.amount, date: event.timestamp,
                                  transaction_Id: event.transactionReferenceId,
                                  status: event.status,transaction_type: event.transactionType,
                                  transactionInfo: event.matchTransactionInfo,
                                )));
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 10,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                if(event.transactionType.toString() == "withdraw-amount")
                                CircleAvatar(
                                  backgroundColor: Colors.grey[300],
                                  child: Image.asset(ImageAssets.banking,height: 30,width: 30,),
                                ),
                                // if(event.transactionType.toString() == "deposits-contest" )
                                // CircleAvatar(
                                //   backgroundColor: Colors.grey[300],
                                //   child: Image.asset(ImageAssets.win),
                                // ),
                                if(event.transactionType.toString() == "deposits-contest" )
                                  CircleAvatar(
                                    backgroundColor: Colors.grey[300],
                                    child:  Image.asset(
                                      event.status != "refund"  ? ImageAssets.win : ImageAssets.referecode
                                    ),
                                  ),
                                if(event.transactionType.toString() == "deposits-amount")
                                CircleAvatar(
                                  backgroundColor: Colors.grey[300],
                                  child: Image.asset(ImageAssets.wallet_Add),
                                ),
                                if(event.transactionType.toString() == "deposits-bonus")
                                  CircleAvatar(
                                    backgroundColor: Colors.grey[300],
                                    child: Image.asset(ImageAssets.bonusSummary),
                                  ),
                                if(event.transactionType.toString() == "withdraw-contest")
                                  CircleAvatar(
                                    backgroundColor: Colors.grey[300],
                                    child: Image.asset("assets/images/trophy.png"),
                                  ),
                                if(event.transactionType.toString() == "withdraw-bonus")
                                  CircleAvatar(
                                    backgroundColor: Colors.grey[300],
                                    child: Image.asset(ImageAssets.Logo_Googly11),
                                  ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if(event.transactionType.toString() == "withdraw-amount")
                                      Text(
                                        "Withdraw Amount",
                                        style: TextStyle(
                                          fontSize: 13.5,
                                          color: Colors.black,
                                        ),
                                      ),
                                      if(event.transactionType.toString() == "deposits-contest")
                                        Text(
                                          event.status != "refund"  ? "Winnings" : "Refund",
                                          style: TextStyle(
                                            fontSize: 13.5,
                                            color: Colors.black,
                                          ),
                                        ),
                                      if(event.transactionType.toString() == "deposits-amount")
                                        Text(
                                          Select_Name_By_Status(event.status) ,
                                          style: TextStyle(
                                            fontSize: 13.5,
                                            color: Colors.black,
                                          ),
                                        ),
                                      if(event.transactionType.toString() == "deposits-bonus")
                                        Text(
                                          "Bonus Cash" ,
                                          style: TextStyle(
                                            fontSize: 13.5,
                                            color: Colors.black,
                                          ),
                                        ),
                                      if(event.transactionType.toString() == "withdraw-contest")
                                      Text(
                                        "Contest Add" ,
                                        style: TextStyle(
                                          fontSize: 13.5,
                                          color: Colors.black,
                                        ),
                                      ),
                                      if(event.transactionType.toString() == "withdraw-bonus")
                                      Text(
                                        "Bonus Add" ,
                                        style: TextStyle(
                                          fontSize: 13.5,
                                          color: Colors.black,
                                        ),
                                      ),

                                      Text(
                                        event.timestamp,
                                        style: TextStyle(
                                          fontSize: 13.5,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      if (event.status == "pending")
                                        Padding(
                                          padding: const EdgeInsets.only(right: 15),
                                          child: Image.asset(
                                            'assets/images/pending.png',
                                            fit: BoxFit.cover,
                                            width: 20, // Adjust the width of the GIF as needed
                                            height: 20,
                                          ),
                                        ),

                                      if(event.transactionType.toString() == "deposits-contest")
                                        Text(
                                          "+" + event.amount,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.green,
                                          ),
                                        ),
                                      if(event.transactionType.toString() == "withdraw-amount")
                                        Text(
                                          SelectValueByWallet(event.status,event.amount),
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: _getStatusColor(event.status),
                                          ),
                                        ),
                                      if(event.transactionType.toString() == "deposits-amount")
                                        Text(
                                          Select_Contest_Value(event.status,event.amount),
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: _getStatusColor(event.status),
                                          ),
                                        ),
                                      if(event.transactionType.toString() == "deposits-bonus")
                                        Text(
                                         "+"+ event.amount,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: _getStatusColor(event.status),
                                          ),
                                        ),
                                      if(event.transactionType.toString() == "withdraw-contest")
                                        Text(
                                          "-"+event.amount,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.red,
                                          ),
                                        ),
                                      if(event.transactionType.toString() == "withdraw-bonus")
                                        Text(
                                          ""+event.amount,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                          ),
                                        ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                  else{
                    return Center(child: Text('No transaction history available'));
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
  Color _getStatusColor(String status) {
    switch (status) {
      case "pending":
        return Colors.amber;
      case "canceled":
        return Colors.red;
      case "completed":
        return Colors.green;
      default:
        return Colors.black; // Default color or any other color you prefer
    }
  }
  String Select_Name_By_Status(String status) {
    switch (status) {
      case "pending":
        return "Pending";
      case "canceled":
        return "Failed";
      case "completed":
        return "Wallet Add";
      default:
        return  "Pending"; // Default color or any other color you prefer
    }
  }
  String Select_Contest_Value(String status,String amount) {
    switch (status) {
      case "pending":
        return "${amount}";
      case "canceled":
        return " ${amount}";
      case "completed":
        return "+ ${amount}";
      default:
        return  "${amount}"; // Default color or any other color you prefer
    }
  }
  String SelectValueByWallet(String status,String amount) {
    switch (status) {
      case "pending":
        return "${amount}";
      case "canceled":
        return "- ${amount}";
      case "completed":
        return "+ ${amount}";
      default:
        return  "${amount}"; // Default color or any other color you prefer
    }
  }
}
