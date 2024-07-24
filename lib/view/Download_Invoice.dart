import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Download_Invoice extends StatefulWidget {
  const Download_Invoice({super.key});

  @override
  State<Download_Invoice> createState() => _Download_InvoiceState();
}

class _Download_InvoiceState extends State<Download_Invoice> {
  DateTime selectedDate = DateTime.now();
  DateTime selectedDate2 = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate2,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate2) {
      setState(() {
        selectedDate2 = picked;
      });
    }
  }

  Future<void> generateInvoice() async {
    final difference = selectedDate2.difference(selectedDate).inDays;
    if (difference <= 7) {
      Fluttertoast.showToast(
          msg: "Generating PDF and showing transaction details",
          textColor: Colors.white,
          backgroundColor: Colors.black);
    } else {
      Fluttertoast.showToast(
          msg: "Please select a date range within 7 days",
          textColor: Colors.white,
          backgroundColor: Colors.black);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Download invoice',
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
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 15),
              child: Text(
                "Download invoice",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 8),
              child: Divider(
                height: 1.5,
                color: Colors.grey,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 100, left: 10, right: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Enter date to download GST invoice ",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "(Maximum 7 days at a time )",
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "Start Date",
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w400),
                        ),
                        GestureDetector(
                          onTap: () => _selectDate(context),
                          child: Container(
                            height: 40,
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(width: 1, color: Colors.grey),
                            ),
                            child: Center(
                              child: Text(
                                '${selectedDate.month}/${selectedDate.day}/${selectedDate.year}',
                                style: TextStyle(fontSize: 14, color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                        Text(
                          "End Date",
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w400),
                        ),
                        GestureDetector(
                          onTap: () => selectDate(context),
                          child: Container(
                            height: 40,
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(width: 1, color: Colors.grey),
                            ),
                            child: Center(
                              child: Text(
                                '${selectedDate2.month}/${selectedDate2.day}/${selectedDate2.year}',
                                style: TextStyle(fontSize: 14, color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      generateInvoice();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Container(
                        height: 40,
                        width: 350,
                        decoration: BoxDecoration(
                            color: Colors.cyan, borderRadius: BorderRadius.circular(12)),
                        child: Center(
                          child: Text(
                            "SUBMIT",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
