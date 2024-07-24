import 'package:flutter/material.dart';

class OtherDetails extends StatefulWidget {
  const OtherDetails({super.key});

  @override
  State<OtherDetails> createState() => _OtherDetailsState();
}

class _OtherDetailsState extends State<OtherDetails> {

  bool checkbox1 = false;
  bool checkbox2 = false;
  bool checkbox3 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Set this to false to hide the default back button
        backgroundColor: Color(0xff780000),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
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
                            'Preferences',
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
                          'Contact Preferences',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text('Googly 11 may contact you by',style: TextStyle(fontSize: 11),),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: checkbox1,
                                onChanged: (value) {
                                  setState(() {
                                    checkbox1 = !checkbox1; // Toggle the value
                                  });
                                },
                              ),
                              Text('SMS'),
                            ],
                          ),
                          Row(
                            children: [
                              Checkbox(
                                value: checkbox2,
                                onChanged: (value) {
                                  setState(() {
                                    checkbox2 = !checkbox2; // Toggle the value
                                  });
                                },
                              ),
                              Text('Phone'),
                            ],
                          ),
                          Row(
                            children: [
                              Checkbox(
                                value: checkbox3,
                                onChanged: (value) {
                                  setState(() {
                                    checkbox3 = !checkbox3; // Toggle the value
                                  });
                                },
                              ),
                              Text('WhatsApp'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )


                ],
              ),
            ),
          ),
        )
    );
  }
}
