import 'package:flutter/material.dart';
import 'package:world11/resourses/Image_Assets/image_assets.dart';

class MaintanenceScreen extends StatefulWidget {
  final startTime, EndTime, description;
  MaintanenceScreen({super.key, this.description, this.EndTime, this.startTime});

  @override
  State<MaintanenceScreen> createState() => _MaintanenceScreenState();
}

class _MaintanenceScreenState extends State<MaintanenceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2e4e4),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Image.asset(
              ImageAssets.Mantenance,
              fit: BoxFit.fill, // Set BoxFit.cover for fullscreen
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 25,right: 25,top: 30),
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.teal,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Image.asset(
                            ImageAssets.Alert_logo,
                            height: 30,
                            width: 30,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Center(
                            child: Text(
                              "This app is on Maintenance !! \n Please Wait...",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 20),
                      child: Text(
                        "${widget.description}",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
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
  }
}
