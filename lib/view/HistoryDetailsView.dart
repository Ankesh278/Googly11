import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../App_Widgets/CustomText.dart';
import '../Model/TransactionHistoryModel/MatchTransactionDetails.dart';
import '../resourses/Image_Assets/image_assets.dart';

class HistoryDetailsView extends StatefulWidget {
  final dynamic price;
  final dynamic date;
  final dynamic transaction_Id;
  final dynamic status;
  final dynamic transaction_type;
  MatchTransactionInfo? transactionInfo;

  HistoryDetailsView({
    Key? key,
    required this.price,
    required this.date,
    required this.transaction_Id,
    required this.status,
    required this.transactionInfo,
    required this.transaction_type,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HistoryDetailsViewState();
}

class _HistoryDetailsViewState extends State<HistoryDetailsView> {
  int _currentStep = 0;
  static const platform = MethodChannel('clipboard');

  void _copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: widget.transaction_Id));
    final snackBar = SnackBar(
      content: Text('Transaction ID copied to clipboard'),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'All Details Transaction',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xff780000),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 70,
            color: Color(0xFFE9F2F5),
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("₹ ${widget.price}",
                          style: TextStyle(
                              color: _getStatusColor(widget.status),
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                      Text("${getNameByStatus(widget.status)} : ${widget.date}",
                          style: TextStyle(color: Colors.black, fontSize: 14)),
                    ],
                  ),
                  if (widget.transaction_type.toString() == "withdraw-amount")
                    CircleAvatar(
                      backgroundColor: Colors.grey[300],
                      child: Image.asset(
                        ImageAssets.banking,
                        height: 30,
                        width: 30,
                      ),
                    ),
                  if (widget.transaction_type.toString() == "deposits-contest")
                    CircleAvatar(
                      backgroundColor: Colors.grey[300],
                      child: Image.asset(ImageAssets.win),
                    ),
                  if (widget.transaction_type.toString() == "deposits-amount")
                    CircleAvatar(
                      backgroundColor: Colors.grey[300],
                      child: Image.asset(ImageAssets.withdrawal),
                    ),
                  if (widget.transaction_type.toString() == "deposits-bonus")
                    CircleAvatar(
                      backgroundColor: Colors.grey[300],
                      child: Image.asset(ImageAssets.bonusSummary),
                    ),
                  if (widget.transaction_type.toString() == "withdraw-contest")
                    CircleAvatar(
                      backgroundColor: Colors.grey[300],
                      child: Image.asset("assets/images/trophy.png"),
                    ),
                  if (widget.transaction_type.toString() == "withdraw-bonus")
                    CircleAvatar(
                      backgroundColor: Colors.grey[300],
                      child: Image.asset(ImageAssets.Logo_Googly11),
                    ),
                ],
              ),
            ),
          ),
          Container(
            height: 80,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("To",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: 15),
                  Text(widget.transaction_Id,
                      style: TextStyle(color: Colors.black, fontSize: 13)),
                ],
              ),
            ),
          ),
          Container(
            height: 80,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Transaction ID",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: 15,
                      ),
                      Text("${widget.transaction_Id}",
                          style: TextStyle(color: Colors.black, fontSize: 16)),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => _copyToClipboard(context),
                    child: Container(
                      height: 35,
                      width: 85,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black45, width: 1.5),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.copy, size: 17),
                          SizedBox(width: 10),
                          Text("COPY",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold))
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          if (widget.transaction_type == "withdraw-amount")
            Padding(
              padding: const EdgeInsets.all(15),
              child: Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  border: Border.all(color: Colors.grey, width: 1),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildStep("Request Raised", "${widget.date}",
                          _currentStep >= 0),
                      Divider(thickness: 2, color: Colors.grey),
                      _buildStep("Deposit Successful", "${widget.date}",
                          _currentStep >= 0),
                    ],
                  ),
                ),
              ),
            ),
          if (widget.transactionInfo != null)
            InkWell(
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) =>
                //         MyMatchesDetailsView(
                //           logo1: widget.logo1 != null ? widget.logo1 : '',
                //           logo2: widget.logo2 != null ?  widget.logo2 : '',
                //           text1:  widget.text1 != null ?  widget.text1.toString() : '',
                //           text2:  widget.text2 != null ? widget.text2.toString() : '',
                //           Match_id: event.matchId.toString(),
                //           Contest_Id: event.contestId,
                //           team1_id: widget.team1_id.toString(),
                //           team2_id: widget.team2_id.toString(),
                //           stats: widget.stats,
                //           winnings: event.winnings,
                //         ),
                //   ),
                // );
              },
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Card(
                  elevation: 20,
                  child: Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      height: size.height * 0.15,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white.withOpacity(0.6),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: size.height * 0.01),
                          Padding(
                            padding: const EdgeInsets.only(right: 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomPaddedText(
                                  text: widget.transactionInfo!.seriesName
                                      .toString(),
                                  style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.black),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: CustomPaddedText(
                                    text: widget.transactionInfo!.rank != null
                                        ? "Rank" +
                                            widget.transactionInfo!.rank
                                                .toString()
                                        : "0",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ),
                                CustomPaddedText(
                                  text: widget.transactionInfo!.state != null
                                      ? widget.transactionInfo!.state.toString()
                                      : "0",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Center(
                                        child: CircleAvatar(
                                          backgroundImage: MemoryImage(
                                              base64Decode(widget.transactionInfo!
                                                          .team1ImageUrl !=
                                                      null
                                                  ? widget.transactionInfo!
                                                      .team1ImageUrl
                                                      .toString()
                                                  : '/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDABALDA4MChAODQ4SERATGCgaGBYWGDEjJR0oOjM9PDkzODdASFxOQERXRTc4UG1RV19iZ2hnPk1xeXBkeFxlZ2P/2wBDARESEhgVGC8aGi9jQjhCY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2P/wgARCAAkADADASIAAhEBAxEB/8QAGQAAAgMBAAAAAAAAAAAAAAAAAAMBAgQF/8QAGAEBAQEBAQAAAAAAAAAAAAAAAAECAwT/2gAMAwEAAhADEAAAAe9JIrPMefbm1v3wKbzTVXIyNOjk9alyFLsBIB//xAAfEAACAgIBBQAAAAAAAAAAAAABAgARAxASEyEiI0P/2gAIAQEAAQUC0x4g5CDjJYbyNcU1E7jTETxrkkRk3nvr5XDT6KfZLlwABpcuf//EABcRAAMBAAAAAAAAAAAAAAAAAAASITD/2gAIAQMBAT8BFmH/xAAaEQADAAMBAAAAAAAAAAAAAAAAARECAxAg/9oACAECAQE/AR7LlELkRJ4//8QAIRAAAQMEAQUAAAAAAAAAAAAAAQARIQIQEiAiMUFRobH/2gAIAQEABj8Cs6HdORo2rZMoIUn0mpNwwfhI8hcTGI+rGonGeqogtEPI0NQElGL/AP/EAB0QAQADAQADAQEAAAAAAAAAAAEAETEhQVFhkRD/2gAIAQEAAT8hAo5KPUyQ1KhAeQlCAZEKeQw/lqmEoPtyLrHGGEuXHFpfiUAovKLlhRIeov2G/kcYYSzzR7bDksduHE4hwLFFrzyhf2Leiiv0P09xxl6l4AA0rzCjgd6zWEvU/9oADAMBAAIAAwAAABCCtFZOqCDz/8QAGREAAwEBAQAAAAAAAAAAAAAAAAERMRAg/9oACAEDAQE/EBRTQ95WN3fH/8QAGREAAwADAAAAAAAAAAAAAAAAAAERICEx/9oACAECAQE/EBFKHI1TVIJEiw//xAAhEAEAAgICAwADAQAAAAAAAAABABEhMVGhQWFxEIGR0f/aAAgBAQABPxBmJriep/ISEmxUUVBRdPMUDWBWXlhMTXE634AVvYnlhoSywcX+5tA5dNzrTrRNnWYB9vkABwNCw6T/AGOpJFhVe4C1HZa+cTrTrQFhVCxlQefXmqgWNWbipLMiDSeIkHbYSR/AUR1wKFYmRjIR1oACjUzaIuVqdj6Ty+4qQR6tvPUuhyHmoosGp//Z')),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 5),
                                        child: Center(
                                          child: Text(
                                              widget.transactionInfo!
                                                          .team1TeamSName !=
                                                      null
                                                  ? widget.transactionInfo!
                                                      .team1TeamSName
                                                      .toString()
                                                  : '',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: 14)),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: CustomPaddedText(
                                  text: widget.transactionInfo!.winnings != null
                                      ? "You won" +
                                          widget.transactionInfo!.winnings
                                              .toString()
                                      : "0",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green),
                                ),
                              ),
                              Expanded(
                                child: FractionallySizedBox(
                                  widthFactor: 1.0,
                                  // Adjust the width factor as needed
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 5),
                                          child: Center(
                                            child: Text(
                                              widget.transactionInfo!
                                                          .team2TeamSName !=
                                                      null
                                                  ? widget.transactionInfo!
                                                      .team2TeamSName
                                                      .toString()
                                                  : '',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14),
                                            ),
                                          ),
                                        ),
                                        Center(
                                          child: CircleAvatar(
                                            backgroundImage: MemoryImage(
                                                base64Decode(widget
                                                            .transactionInfo!
                                                            .team2ImageUrl !=
                                                        null
                                                    ? widget.transactionInfo!
                                                        .team2ImageUrl
                                                        .toString()
                                                    : '/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDABALDA4MChAODQ4SERATGCgaGBYWGDEjJR0oOjM9PDkzODdASFxOQERXRTc4UG1RV19iZ2hnPk1xeXBkeFxlZ2P/2wBDARESEhgVGC8aGi9jQjhCY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2P/wgARCAAkADADASIAAhEBAxEB/8QAGQAAAgMBAAAAAAAAAAAAAAAAAAMBAgQF/8QAGAEBAQEBAQAAAAAAAAAAAAAAAAECAwT/2gAMAwEAAhADEAAAAe9JIrPMefbm1v3wKbzTVXIyNOjk9alyFLsBIB//xAAfEAACAgIBBQAAAAAAAAAAAAABAgARAxASEyEiI0P/2gAIAQEAAQUC0x4g5CDjJYbyNcU1E7jTETxrkkRk3nvr5XDT6KfZLlwABpcuf//EABcRAAMBAAAAAAAAAAAAAAAAAAASITD/2gAIAQMBAT8BFmH/xAAaEQADAAMBAAAAAAAAAAAAAAAAARECAxAg/9oACAECAQE/AR7LlELkRJ4//8QAIRAAAQMEAQUAAAAAAAAAAAAAAQARIQIQEiAiMUFRobH/2gAIAQEABj8Cs6HdORo2rZMoIUn0mpNwwfhI8hcTGI+rGonGeqogtEPI0NQElGL/AP/EAB0QAQADAQADAQEAAAAAAAAAAAEAETEhQVFhkRD/2gAIAQEAAT8hAo5KPUyQ1KhAeQlCAZEKeQw/lqmEoPtyLrHGGEuXHFpfiUAovKLlhRIeov2G/kcYYSzzR7bDksduHE4hwLFFrzyhf2Leiiv0P09xxl6l4AA0rzCjgd6zWEvU/9oADAMBAAIAAwAAABCCtFZOqCDz/8QAGREAAwEBAQAAAAAAAAAAAAAAAAERMRAg/9oACAEDAQE/EBRTQ95WN3fH/8QAGREAAwADAAAAAAAAAAAAAAAAAAERICEx/9oACAECAQE/EBFKHI1TVIJEiw//xAAhEAEAAgICAwADAQAAAAAAAAABABEhMVGhQWFxEIGR0f/aAAgBAQABPxBmJriep/ISEmxUUVBRdPMUDWBWXlhMTXE634AVvYnlhoSywcX+5tA5dNzrTrRNnWYB9vkABwNCw6T/AGOpJFhVe4C1HZa+cTrTrQFhVCxlQefXmqgWNWbipLMiDSeIkHbYSR/AUR1wKFYmRjIR1oACjUzaIuVqdj6Ty+4qQR6tvPUuhyHmoosGp//Z')),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // SizedBox(height: 10,),
                          // Expanded(
                          //   child: Padding(
                          //     padding: const EdgeInsets.only(right: 10),
                          //     child: Align(
                          //       alignment: Alignment.centerRight,
                          //       child: CustomPaddedText(
                          //         text: "View Leaderboard",
                          //         style: TextStyle(
                          //             fontSize: 12,
                          //             fontWeight: FontWeight.bold,
                          //             color: Colors.black
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }

  Widget _buildStep(String title, String subTitle, bool isComplete) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(color: Colors.black, fontSize: 12),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  subTitle,
                  style: TextStyle(color: Colors.black, fontSize: 12),
                ),
                if (isComplete)
                  Icon(
                    Icons.check,
                    color: Colors.green,
                  ),
              ],
            ),
          ),
        ],
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

  String getNameByStatus(String status) {
    switch (status) {
      case "pending":
        return "Pending";
      case "canceled":
        return "Canceled";
      case "completed":
        return "Completed";
      default:
        return "Completed"; // Default color or any other color you prefer
    }
  }
}
