import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upgrader/upgrader.dart';
import 'package:world11/ApiCallProviderClass/API_Call_Class.dart';
import 'package:world11/App_Widgets/My%20Info%20&%20Settings.dart';
import 'package:world11/Model/BannerModel/BannersModel.dart';
import 'package:world11/Model/BannerModel/Info.dart';
import 'package:world11/Model/BonesModelCelebration/BonesResponse.dart';
import 'package:world11/Model/NewCricketApiModel/NewDataClass.dart';
import 'package:world11/Model/Upcoming_New_Model/Data.dart';
import 'package:world11/Model/UserInfoUpdate/UserInfoUpdate.dart';
import 'package:world11/Notification_Service/Notification_Service_Class.dart';
import 'package:world11/bottom_navigation_bar/account.dart';
import 'package:world11/bottom_navigation_bar/more.dart';
import 'package:world11/view/Add%20Cash%20In%20Wallet.dart';
import 'package:world11/view/AfterWinningContestView.dart';
import 'package:world11/view/Fantasy_Point_System.dart';
import 'package:world11/view/TransactionEnquiry.dart';
import 'package:world11/view/View_Transactions.dart';
import 'package:world11/view/Web%20View%20Screen.dart';
import 'package:world11/view/create_your_team/Completed_match_contest.dart';
import 'package:world11/view/create_your_team/LiveMatch_contest.dart';
import 'package:world11/view/loginView/google_signin_api.dart';
import '../App_Widgets/CustomText.dart';
import '../App_Widgets/row_custom.dart';
import '../Model/MyMatchesList/MatchInfo.dart';
import '../Model/MyMatchesList/MyMatchesResponse.dart';
import '../Model/NewCricketApiModel/NewApiCricketClass.dart';
import '../Model/ReferAndEarnModel/ReferAndEarn.dart';
import '../Model/Upcoming_New_Model/Upcoming_New_Api_Response.dart';
import '../Model/UserAllData/GetUserAllData.dart';
import '../resourses/Image_Assets/image_assets.dart';
import '../view/Add Email Address.dart';
import '../view/Feedback_Design.dart';
import '../view/create_your_team/create_contest.dart';
import '../view/loginView/login_view.dart';
import 'package:package_info_plus/package_info_plus.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  TextEditingController referral_controller = TextEditingController();



  //int _currentIndex = 0;
  // List<Map<String, String>> _info = [
  //   {"image": "image1.png"},
  //   {"image": "image2.png"},
  //   {"image": "image3.png"},
  // ];

  late AnimationController _animationController;
  late Animation<double> _swingAnimation;
  late Timer _timer;





  bool isDownloading = false;
  String? _email;
  String? _userName;
  String? ReffralCodeStatus;
  String _token = '';
  String? _userPhoto;
  String _EmailStatus = '';
  String? news_Live;
  String? news_Title;
  String? news_dis;
  bool isLoading_More = false;
  bool reffral_code_loading = false;
  bool isLoading_More_Data = false;
  int last_Page = 0;
  Future<List<UpcomingMatch_Recents_Data>?>? future;
  Future<List<UpcomingMatch_Recents_Data>?>? _future;
  Future<List<NewDataClass>?>? future_data;
  final ScrollController scrollController = ScrollController();
  final ScrollController scrollController_recent = ScrollController();
  int page = 1;
  int page_recent = 1;
  List<UpcomingMatch_Recents_Data>? allUpcomingMatches = [];
  List<UpcomingMatch_Recents_Data>? allUpcomingMatches_recent =
      []; // Replace this with your actual list
  Future<List<MatchInfo>?>? My_Match_Data;
  bool isCardVisible = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  PageController _pageController = PageController();
  int _data_index = 0;
  Notification_Services notification_services = Notification_Services();
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
    installerStore: 'Unknown',
  );

  static const platform = MethodChannel('com.example.app/update');
  ReceivePort receivePort = ReceivePort();
  double progress = 0;
  double? progresss;

  @override
  void initState() {


    _animationController = AnimationController(
        duration: Duration(seconds: 4),
        vsync: this,);



    _swingAnimation = Tween(begin: -0.1, end: 0.1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _animationController.forward();
      }
    });
    _animationController.forward();
    _timer = Timer.periodic(Duration(seconds: 6), (timer) {
      if (mounted) {
        _animationController.forward();
      }
    });





    _initPackageInfo();
    fetchUserTeam();
    IsolateNameServer.registerPortWithName(
        receivePort.sendPort, 'downloadingAPK');
    receivePort.listen((message) {
      setState(() {
        progress = message;
        print("progress" + progress.toString());
      });
    });

    FlutterDownloader.registerCallback(downLoadCallBack);
    FlutterDownloader.registerCallback((id, status, progress) {
      if (status == DownloadTaskStatus.running) {
        double downloadProgress = progress / 100;
        print('Download Progress: $downloadProgress');
      }
    });
    notification_services.requestNotificationPermission();
    notification_services.firebaseInit(context);
    // notification_services.isTokenRefresh();
    notification_services.getDeviceToken().then((value) {
      print("device_Id:::::::::" + value);
    });

    _tabController = TabController(length: 3, vsync: this);
    scrollController.addListener(_scrollListener);
    scrollController_recent.addListener(_scrollListener_recent);
    getPrefrenceData();
    fetchData();
    future = fetchUpcomingMatches("upcoming", page);
    _future = fetchUpcomingMatches_recent("recent", page_recent);
    future_data = fetchUpcomingMatcheLiveData('live');
    super.initState();
  }
















  void downLoadCallBack(id, status, progress) {
    SendPort? sendPort = IsolateNameServer.lookupPortByName("downloadingAPK");
    sendPort!.send(progress);
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
    print("version:::" + _packageInfo.version);
    print("version:::" + _packageInfo.appName);
    print("version:::" + _packageInfo.buildNumber);
    print("version:::" + _packageInfo.buildSignature);
    print("version:::" + _packageInfo.packageName);
  }

  Future<void> _scrollListener() async {
    if (isLoading_More) return;
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      setState(() {
        isLoading_More = true;
      });
      print("Page:::::::::" + page.toString());
      print("Last_Page:::::::::" + last_Page.toString());
      page = page + 1;
      await fetchUpcomingMatches('upcoming', page);
      setState(() {
        isLoading_More = false;
      });
    } else {
      print('Do not call');
    }
  }

  Future<void> _scrollListener_recent() async {
    if (isLoading_More_Data) return;
    if (scrollController_recent.position.pixels ==
        scrollController_recent.position.maxScrollExtent) {
      setState(() {
        isLoading_More_Data = true;
      });

      print("Page:::::::::" + page_recent.toString());
      print("Last_Page:::::::::" + last_Page.toString());
      page_recent = page_recent + 1;
      await fetchUpcomingMatches_recent('recent', page_recent);
      setState(() {
        isLoading_More_Data = false;
      });
    } else {
      print('Do not call');
    }
  }

  Future<void> fetchMoreData() async {
    try {
      page++;
      print("page::::::::" + page.toString());
      List<UpcomingMatch_Recents_Data>? nextPageData =
          await fetchUpcomingMatches('upcoming', page);

      // Check if there is more data
      if (nextPageData != null && nextPageData.isNotEmpty) {
        // Add the new data to the existing data list
        setState(() {
          allUpcomingMatches?.addAll(nextPageData);
        });
      } else {
        // No more data available
        print('No more data available');
      }
    } catch (error) {
      print('Error fetching more data: $error');
    }
  }

  void getPrefrenceData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString("email_user");
    String? userName = prefs.getString("UserName");
    String? userPhoto = prefs.getString("user_photo");
    String? token = prefs.getString("token");
    setState(() {
      _email = email;
      _userName = userName;
      _userPhoto = userPhoto;
      _token = token!;
      fetchUserAllData(token.toString());
      // fetchMyCompleteMatchData(_token);
      My_Match_Data = getListTopWinningContest(token);
    });
    print("email" + _email.toString());
    print("user_id" + _userName.toString());
  }

  @override
  void dispose() {
    scrollController.dispose();
    scrollController_recent.dispose();
    _tabController.dispose();
    super.dispose();

    _animationController.dispose();
    _timer?.cancel();
  }

  Future<void> fetchUserTeam() async {
    final ApiProvider apiProvider =
        Provider.of<ApiProvider>(context, listen: false);
    apiProvider.refferalStatus = '0';
  }

  int _currentIndex = 0;
  List<Info>? bannerInfo = [];
  List<Info> _info = [];
  List<MatchInfo> _match_Data_Complete = [];

  List<String> imagePaths = [
    'assets/images/ba1.jpg',
    'assets/images/ba2.png',
    'assets/images/banner_image.jpg',
  ];

  Future<List<Info>?> fetchSliderData() async {
    final response = await http
        .get(Uri.parse('https://admin.googly11.in/api/banner-slider'));
    if (response.statusCode == 200) {
      BannersModel bannersModel =
          BannersModel.fromJson(json.decode(response.body));
      bannerInfo = bannersModel.info;
      return bannerInfo;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> fetchData() async {
    try {
      List<Info>? data = await fetchSliderData();
      if (data != null && data.isNotEmpty) {
        setState(() {
          _info = data;
        });
      }
    } catch (error) {
      print('Error fetching data: $error');
      // Handle the error as needed
    }
  }

  Future<void> fetchMyCompleteMatchData(String token) async {
    try {
      List<MatchInfo>? data = await getListTopWinningContest(token);
      if (data != null && data.isNotEmpty) {
        setState(() {
          _match_Data_Complete = data;
          print(
              "data_FDau:::::::::::" + _match_Data_Complete.length.toString());
        });
      }
    } catch (error) {
      print('Error fetching data: $error');
      // Handle the error as needed
    }
  }

  Future<List<UpcomingMatch_Recents_Data>?> fetchUpcomingMatches(
      String type, int current_page) async {
    final String apiUrl =
        'https://admin.googly11.in/api/matchesDataInDatabaseGet?type=$type&page=$current_page';
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Accept': 'application/json',
          // Add any additional headers here if needed
        },
      );
      print("PPPPPPPP::::::::" + response.toString());
      print("PPPPPPPP::::::::" + response.body);
      if (response.statusCode == 200) {
        UpcomingNewApiResponse upcomingMatch =
            UpcomingNewApiResponse.fromJson(jsonDecode(response.body));
        if (upcomingMatch.status == 1) {
          if (upcomingMatch.allData != null && upcomingMatch.allData != "") {
            setState(() {
              allUpcomingMatches =
                  (allUpcomingMatches! + upcomingMatch.allData!.data!);
              last_Page = upcomingMatch.allData!.lastPage;
              print("last_Page_Dataaaaa:::::" + last_Page.toString());
            });
          } else {
            print("No Data::::");
          }

          return allUpcomingMatches;
        }
        return upcomingMatch.allData!.data;
      } else if (response.statusCode == 400) {
        UpcomingNewApiResponse upcomingMatch =
            UpcomingNewApiResponse.fromJson(jsonDecode(response.body));
        if (upcomingMatch.status == 0) {
          return upcomingMatch.allData!.data;
        }
      } else {
        throw Exception(
            'Failed to load data. Status Code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
    return null;
  }

  Future<List<UpcomingMatch_Recents_Data>?> fetchUpcomingMatches_recent(
      String type, int current_page) async {
    final String apiUrl =
        'https://admin.googly11.in/api/matchesDataInDatabaseGet?type=$type&page=$current_page';
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Accept': 'application/json',
        },
      );
      print("PPPPPPPP::::::::" + response.toString());
      print("PPPPPPPP::::::::" + response.body);
      if (response.statusCode == 200) {
        UpcomingNewApiResponse upcomingMatch =
            UpcomingNewApiResponse.fromJson(jsonDecode(response.body));
        if (upcomingMatch.status == 1) {
          if (upcomingMatch.allData != null && upcomingMatch.allData != "") {
            setState(() {
              allUpcomingMatches_recent =
                  (allUpcomingMatches_recent! + upcomingMatch.allData!.data!);
              last_Page = upcomingMatch.allData!.lastPage;
              //  print("last_Page_Dataaaaa:::::"+last_Page.toString());
            });
          } else {
            print("No Data::::");
          }
          return allUpcomingMatches_recent;
        }
        return allUpcomingMatches_recent;
      } else if (response.statusCode == 400) {
        UpcomingNewApiResponse upcomingMatch =
            UpcomingNewApiResponse.fromJson(jsonDecode(response.body));
        if (upcomingMatch.status == 0) {
          return upcomingMatch.allData!.data;
        }
      } else {
        throw Exception(
            'Failed to load data. Status Code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
    return null;
  }

  Future<List<MatchInfo>?> getListTopWinningContest(String token) async {
    final url =
        'https://admin.googly11.in/api/get_list_top_winning_contest_test';
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      // print('Status Code:MatchData ${response.statusCode}');
      // print('Response::::::::::::::::::::2364 ${response.body}');

      if (response.statusCode == 200) {
        MyMatchesResponse matchesResponse =
            MyMatchesResponse.fromJson(json.decode(response.body));
        if (matchesResponse.status == 1) {
          setState(() {
            _match_Data_Complete = matchesResponse.matchInfo!;
          });
          return _match_Data_Complete;
        } else {
          setState(() {
            _match_Data_Complete = matchesResponse.matchInfo!;
          });
          return _match_Data_Complete;
        }
      } else if (response.statusCode == 400) {
        MyMatchesResponse matchesResponse =
            MyMatchesResponse.fromJson(json.decode(response.body));
        if (matchesResponse.status == 1) {
          setState(() {
            _match_Data_Complete = matchesResponse.matchInfo!;
          });
          return _match_Data_Complete;
        } else {
          setState(() {
            _match_Data_Complete = matchesResponse.matchInfo!;
          });
          return _match_Data_Complete;
        }
      }
    } catch (error) {
      // Handle network errors or other exceptions
      print('Error: $error');
    }
    return null;
  }

  Future<List<NewDataClass>?> fetchUpcomingMatcheLiveData(String type) async {
    final String apiUrl =
        'https://admin.googly11.in/api/matches_live?type=$type';
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Accept': 'application/json',
          // Add any additional headers here if needed
        },
      );
      // print("PPPPPPPP:::::::::::::::::" + response.toString());
      // print("PPPPPPPP:::::::::::::::::::::::::::::::::::" + response.body);
      if (response.statusCode == 200) {
        List<NewDataClass>? upcomingMatches =
            Autogenerated.fromJson(jsonDecode(response.body)).data;
        return upcomingMatches;
      } else if (response.statusCode == 400) {
        Autogenerated upcomingMatch =
            Autogenerated.fromJson(jsonDecode(response.body));
        if (upcomingMatch.status == 0) {
          return upcomingMatch.data;
        }
      } else {
        throw Exception(
            'Failed to load data. Status Code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
    return null;
  }

  Future<void> fetchUserAllData(String token) async {
    final ApiProvider apiProvider =
        Provider.of<ApiProvider>(context, listen: false);
    var apiUrl = 'https://admin.googly11.in/api/user';

    // Request headers
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      var response = await http.get(
        Uri.parse(apiUrl),
        headers: headers,
      );

      if (response.statusCode == 200) {
        GetUserAllData userAllData =
            GetUserAllData.fromJson(jsonDecode(response.body));
        if (userAllData.status == 1) {
          setState(() {
            _userName = userAllData.user!.userName;
            ReffralCodeStatus = userAllData.user!.reffran_code_use.toString();
            apiProvider.refferalStatus =
                userAllData.user!.reffran_code_use.toString();
            _userPhoto = userAllData.user!.userKyc!.userImage;
            _EmailStatus = userAllData.user!.email_status.toString();
            news_Live = userAllData.user!.news_is_live.toString();
            news_Title = userAllData.user!.news_title.toString();
            news_dis = userAllData.user!.news_dis.toString();
          });
          if (userAllData.user!.welcome_bones == 0) {
            fetch_Data_For_Celebration(token);
          } else {
            // print("Welcome_bones::::::::::::" + userAllData.user!.welcome_bones.toString());
          }

          if (userAllData.user!.email_status == 0) {
            Future.delayed(Duration(minutes: 1), () {
              show_Email_dialog(token);
            });
          } else {
            // print("Email_status::::::::::::" + userAllData.user!.email_status.toString());
          }
          int userAppVersion = int.parse(
              userAllData.user!.appVersion.toString().replaceAll('.', ''));
          int packageVersion =
              int.parse(_packageInfo.version.toString().replaceAll('.', ''));
          print("versionDataa user::" +
              userAppVersion.toString() +
              ":::" +
              packageVersion.toString());
          if (userAppVersion > packageVersion) {
            // show_Update_dialog(context,
            //     _packageInfo.version,
            //     userAllData.user!.appVersion.toString(),
            //     userAllData.user!.appUrl.toString());
          } else {
            // Do something else if the user's app version is not greater than the package version
          }

          if (userAllData.user!.maintenance.toString() == "on") {
            // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MaintanenceScreen(description:userAllData.user!.m_dis,EndTime: userAllData.user!.m_end_time, startTime: userAllData.user!.m_start_time,)),
            //        (route) => false);
          }
          // print('API call successful');
          // print('Response: $responseData');
        }
      } else if (response.statusCode == 401) {
        Fluttertoast.showToast(msg: "Token not found", textColor: Colors.red);
        // print('API call failed with status ${response.statusCode}');
        // print('Response: ${response.body}');
      } else if (response.statusCode == 400) {
        Fluttertoast.showToast(msg: "User not found", textColor: Colors.red);
      }
    } catch (e) {
      // Handle exceptions
      print('Error making API call: $e');
    }
  }

  Future<void> fetch_Data_For_Celebration(String token) async {
    final url = 'https://admin.googly11.in/api/user_signup_bonus';
    final headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };

    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      BonesResponse bonesResponse =
          BonesResponse.fromJson(json.decode(response.body));
      if (bonesResponse.status == 1) {
        showOtpDialog(_token, bonesResponse.amount.toString());
      } else {
        // Fluttertoast.showToast(msg: bonesResponse.message.toString(),textColor: Colors.white,backgroundColor: Colors.black);
      }
    } else {
      // If the server did not return a 200 OK response, throw an exception.
      throw Exception('Failed to load data');
    }
  }

  Future<void> showOtpDialog(String token, String Price) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: AlertDialogClass(Price),
        );
      },
    );
  }

  Future<void> show_Email_dialog(String token) async {
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          // Use StatefulBuilder to manage the state
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Update your email'),
              content: Container(
                height: 100,
                width: 200,
                child: Column(
                  children: [
                    ListTile(
                      title: Text('Click on OK button and update your email'),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddEmailAddress()));
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      },
    );
  }



  Future<void> show_Update_dialog(
      BuildContext context, String old_version, String newVersion, String apk_Url) async {
    double progresss = 0.0; // Initial download progress
    bool isInstalling = false;

    return showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismiss by tapping outside
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return WillPopScope(
              onWillPop: () async => false, // Prevent dismiss by back button
              child: AlertDialog(
            shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft:Radius.circular(40.0),bottomRight:Radius.circular(40.0)),

            ),backgroundColor: Colors.black45.withOpacity(0.6),
                title: Row(
                  children: [
                    Image(
                      image: AssetImage(ImageAssets.googly_Logo),
                      height: 40,
                      width: 40,
                    ),
                    SizedBox(width: 10),
                    Text('Update App?',style: TextStyle(color: Colors.white,fontSize: 24,fontWeight: FontWeight.bold),),
                  ],

                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      title: Text(
                        'A new version of Googly11 is available! Version $newVersion is now available - you have $old_version',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      subtitle: Text('Would you like to update it now?',
                          style: TextStyle(fontSize: 13,color: Colors.white)),
                    ),
                    //SizedBox(height: 20),
                    Lottie.asset(
                      'assets/animations/newanimie.json',
                      width: 100,
                      height: 100,
                      fit: BoxFit.fill,
                    ),
                    SizedBox(height: 0),
                    progresss > 0
                        ? Column(
                      children: [
                        LinearProgressIndicator(value: progresss,backgroundColor: Colors.white,color: Colors.green,),
                       // SizedBox(height: 10),
                        Text(
                          '${(progresss * 100).toStringAsFixed(0)}%',
                          style: TextStyle(fontSize: 14,color: Colors.white),
                        ),
                      ],
                    )
                        : Container(),
                    isInstalling
                        ? Column(
                      children: [
                        LinearProgressIndicator(),
                        SizedBox(height: 10),
                        Text(
                          'Installing...',
                          style: TextStyle(fontSize: 18,color: Colors.white),
                        ),
                      ],
                    )
                        : Container(),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: (progresss > 0 || isInstalling)
                        ? null
                        : () async {
                      setState(() {
                        progresss = 0.01; // To show the progress bar immediately
                      });
                      downloadAndInstallApk(context);

                      // final directory = await getExternalStorageDirectory();
                      // final taskId = await FlutterDownloader.enqueue(
                      //     url: apk_Url,
                      //     savedDir: directory!.path,
                      //     fileName: 'new_version.apk',
                      //     showNotification: true,
                      //     openFileFromNotification: true,);
                      //
                      //
                      // FlutterDownloader.registerCallback((id, status, progress) {
                      //   if (taskId == id && status == DownloadTaskStatus.complete) {
                      //     installApk('${directory.path}/new_version.apk');
                      //   }
                      // });



                      // FileDownloader.downloadFile(url: apk_Url,
                      //   onProgress: (version, progress) {
                      //     setState(() {
                      //       progresss = progress / 100.0;
                      //     });
                      //   },
                      //   onDownloadCompleted: (filePath) async {
                      //     print("Downloaded file path: $filePath");
                      //     setState(() {
                      //       progresss = 0.0;
                      //       isInstalling=true;
                      //     });
                      //
                      //
                      //     final AndroidIntent intent = AndroidIntent(
                      //       action: 'action_view',
                      //       data: Uri.file(filePath).toString(),
                      //       type: 'application/vnd.android.package-archive',
                      //       flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
                      //     );
                      //     await intent.launch();
                      //     await AndroidPackageInstaller.installApk(apkFilePath: filePath);
                      //
                      //     setState(() {
                      //       isInstalling = false;
                      //     });
                      //     Navigator.of(context).pop(); // Close the dialog
                      //   },
                      // );
                    },
                    child: Text(
                      'UPDATE NOW',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }


  void downloadCallback(String id, DownloadTaskStatus status, int progress) async {
    if (status == DownloadTaskStatus.complete) {
      final directory = await getExternalStorageDirectory();
      final filePath = '${directory?.path}/new_version.apk';
      // await InAppUpdate.performImmediateUpdate();
    }
  }

  // Future<void> installApk(String filePath) async {
  //   try {
  //     await InstallPlugin.installApk(filePath, appId: 'com.googly11.fantasy');
  //   } catch (e) {
  //     print('Failed to install APK: $e');
  //   }
  // }

  Future<void> downloadAndInstallApk(BuildContext context) async {
    final directory = await getExternalStorageDirectory();
    final taskId = await FlutterDownloader.enqueue(
      url: 'https://admin.googly11.in/uploads/applications/googly11APK1719482983.apk',
      savedDir: directory!.path,
      fileName: 'new_version.apk',
      showNotification: true,
      openFileFromNotification: true,

    );
  }


  String formatMillisecondsSinceEpoch(String millisecondsSinceEpoch) {
    // Convert the string to integer
    int milliseconds = int.parse(millisecondsSinceEpoch);

    // Convert milliseconds since epoch to DateTime
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(milliseconds);
    // Format the DateTime object
    String formattedDate = DateFormat('dd MMM yyyy').format(dateTime);
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final ApiProvider apiProvider =
        Provider.of<ApiProvider>(context, listen: false);
    return UpgradeAlert(
      showLater: false,
      dialogStyle: UpgradeDialogStyle.cupertino,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: CustomAppBar(
          child: AppBar(
            centerTitle: true,
            leading: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.menu,
                    size: 35,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    _scaffoldKey.currentState?.openDrawer();
                  },
                ),
                // Image.asset("cancel.png",height: 20,width: 20,)                // SizedBox(width: 0,),
                // CircleAvatar(
                //   radius: 20, // Set the radius of the profile photo
                //   backgroundImage: _userPhoto != null && Uri.parse(_userPhoto!).isAbsolute
                //       ? NetworkImage(_userPhoto!) // Load profile photo from network
                //       : AssetImage(ImageAssets.user) as ImageProvider,
                //   backgroundColor: Colors.transparent,
                //   //foregroundImageFit: BoxFit.cover,
                //   // Load default asset if no network image
                // ),
              ],
            ),
            title: Text(
              'message'.tr,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            automaticallyImplyLeading: false,
            backgroundColor: Color(0xff780000),
            iconTheme: IconThemeData(color: Colors.black),
            actions: [
              if (apiProvider.refferal == "0")
                InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      // isScrollControlled: true, // Set this to true to make the bottom sheet full height
                      builder: (BuildContext context) {
                        return YourWidgetName(
                          token: _token,
                          apiProvider: apiProvider,
                        );
                      },
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Icon(
                            Icons.person_add,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddCashInWallet()));
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white, // Set the border color
                        width: 1.5, // Set the border width
                      ),
                      borderRadius: BorderRadius.circular(
                          12.0), // Set the border radius if you want rounded corners
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding:
                              EdgeInsets.all(8.0), // Add padding to the text
                          child: Text(
                            "Add Cash".tr,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(width: 3),
                        Image(
                          image: AssetImage(ImageAssets.wallet64),
                          height: 20,
                          width: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        drawer: SafeArea(
          child: Drawer(
            shadowColor: Colors.white,
            backgroundColor: Colors.white,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Account()));
                    },
                    child: Container(
                      height: 80,
                      width: double.infinity,
                      decoration: BoxDecoration(color: Colors.black),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 25,
                                  backgroundImage: _userPhoto != null &&
                                          Uri.parse(_userPhoto.toString())
                                              .isAbsolute
                                      ? NetworkImage(_userPhoto.toString())
                                      : AssetImage(ImageAssets.user)
                                          as ImageProvider,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CustomPaddedText(
                                      text: _userName.toString(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        CustomPaddedText(
                                          text: 'Skill'.tr,
                                          style: TextStyle(color: Colors.pink),
                                        ),
                                        Icon(
                                          Icons.lock,
                                          color: Colors.redAccent,
                                          size: 15,
                                        ),
                                        Container(
                                          height: 25,
                                          width: 1,
                                          color: Colors.white,
                                        ),
                                        Image(
                                          image: AssetImage(ImageAssets.win),
                                          height: size.height * 0.03,
                                        ),
                                        CustomPaddedText(
                                            text: '0',
                                            style:
                                                TextStyle(color: Colors.white)),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Icon(
                                  Icons.keyboard_arrow_right,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyInfo_Setting()));
                    },
                    child: CustomRow(
                      image: Image(
                        image: AssetImage(ImageAssets.Setting_Logo),
                        width: 25,
                        height: 25,
                      ),
                      text: 'MY_INFO_setting'.tr,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FantasyPointSystem()));
                    },
                    child: CustomRow(
                      image: Image(
                        image: AssetImage(ImageAssets.Fantacy_Points),
                        width: 25,
                        height: 25,
                      ),
                      text: 'Fantasy Point'.tr,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WebViewScreen(
                                    appBarName: "Terms And Conditions",
                                    url: "https://googly11.in/Term&condition",
                                  )));
                    },
                    child: CustomRow(
                      image: Image(
                        image: AssetImage(ImageAssets.terms_Condition),
                        width: 25,
                        height: 25,
                      ),
                      text: 'Terms'.tr,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WebViewScreen(
                                appBarName: "Privacy and Policy",
                                url: "https://googly11.in/privacypolicy",
                              )));
                    },
                    child: CustomRow(
                      image: Image(
                        image: AssetImage(ImageAssets.privacypolicy),
                        width: 25,
                        height: 25,
                      ),
                      text: 'Privacy and Policy',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WebViewScreen(
                                appBarName: "PAYMENT TERMS AND REFUND POLICIES",
                                url: "https://googly11.in/paymentterm",
                              )));
                    },
                    child: CustomRow(
                      image: Image(
                        image: AssetImage(ImageAssets.paymentrefund),
                        width: 25,
                        height: 25,
                      ),
                      text: 'Payment and refund policies',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ViewTransactions()));
                    },
                    child: CustomRow(
                      image: Image(
                        image: AssetImage(ImageAssets.mobile_transaction),
                        width: 25,
                        height: 25,
                      ),
                      text: 'Transactions'.tr,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TransactionEnquiry()));
                    },
                    child: CustomRow(
                      image: Image(
                        image: AssetImage(ImageAssets.transaction_enquiry),
                        width: 25,
                        height: 25,
                      ),
                      text: 'Transactions Enquiry',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => More()));
                    },
                    child: CustomRow(
                      image: Image(
                        image: AssetImage(ImageAssets.share),
                        width: 25,
                        height: 25,
                      ),
                      text: 'ReferEarn'.tr,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WebViewScreen(
                                    appBarName: "How to play",
                                    url: "https://googly11.in/paymentterm",
                                  )));
                    },
                    child: CustomRow(
                      image: Image(
                        image: AssetImage(ImageAssets.game64),
                        width: 25,
                        height: 25,
                      ),
                      text: 'Howtoplay'.tr,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WebViewScreen(
                                    appBarName: "Service and leadership",
                                    url: "https://googly11.in/cricket",
                                  )));
                    },
                    child: CustomRow(
                      image: Image(
                        image: AssetImage(ImageAssets.star50),
                        width: 25,
                        height: 25,
                      ),
                      text: 'Services and leadership'.tr,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Fluttertoast.showToast(
                          msg: "This Functionality is Coming soon",
                          backgroundColor: Colors.red,
                          textColor: Colors.white);
                    },
                    child: CustomRow(
                      image: Image(
                        image: AssetImage(ImageAssets.tv),
                        width: 25,
                        height: 25,
                      ),
                      text: 'Watch LIVE'.tr,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(

                              builder: (context) => WebViewScreen(
                                    appBarName: "About Us",
                                    url: "https://googly11.in/about",
                                  )));
                    },
                    child: CustomRow(
                      image: Image(
                        image: AssetImage(ImageAssets.about_us),
                        width: 25,
                        height: 25,
                      ),
                      text: 'About Us'.tr,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WebViewScreen(
                                    appBarName: "Contact Us",
                                    url: "https://googly11.in/contact",
                                  )));
                    },
                    child: CustomRow(
                      image: Image(
                        image: AssetImage(ImageAssets.contact_us),
                        width: 25,
                        height: 25,
                      ),
                      text: 'Contact Us'.tr,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FeedBackDesign()));
                    },
                    child: CustomRow(
                      image: Image(
                        image: AssetImage(ImageAssets.feedback),
                        width: 25,
                        height: 25,
                      ),
                      text: 'Feedback'.tr,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      _showAlertDialog(context, _token);
                    },
                    child: CustomRow(
                      iconData: Icon(Icons.login_outlined),
                      text: 'LOGOUT'.tr,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        backgroundColor: Color(0xfff2e4e4),
        body:Column(
          children: [
            // SizedBox(
            //   height: 5,
            // ),
            _info != null
                ? (_info.isNotEmpty
                ? buildCarousel()
                : SpinKitFadingCircle(
              color: Colors.redAccent,
              size: 50.0,
            ))
                : SpinKitFadingCircle(
              color: Colors.redAccent,
              size: 50.0,
            ),//"${news_Title}",
            SizedBox(
              height: 5,
            ),
            if (news_Live == "1")
              Visibility(
                visible: isCardVisible, // Control the visibility of the card
                child: Container(
                  width: double.infinity,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 10,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF2C3E50), Color(0xFF4CA1AF)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: (){
                              setState(() {
                                isCardVisible=false;
                              });
                            },
                            child: Align(child: Icon(Icons.cancel),
                              alignment: Alignment.topRight,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 14),
                            child: Text(
                              "${news_Title}",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            margin: EdgeInsets.only(left: 14,bottom: 8),
                            child: Text(
                              "${news_dis}",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                ),
              ),
            SizedBox(
              height: 0,
            ),
            if (_match_Data_Complete.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "My last matches",
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    )),
              ),
            if (_match_Data_Complete.isNotEmpty)
              Column(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      height: size.height * 0.13,
                      width: size.width,
                      child: PageView.builder(
                        controller: _pageController,
                        scrollDirection: Axis.horizontal,
                        itemCount: _match_Data_Complete.length,
                        itemBuilder: (context, index) {
                          final event = _match_Data_Complete[index];
                          print("match_Data_Length12" +
                              _match_Data_Complete.length.toString());
                          return InkWell(
                            onTap: () {
                              if (event.state == "Complete") {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        AfterWinningContestView(
                                          logo1: event.team1ImageUrl != null
                                              ? event.team1ImageUrl
                                              : '',
                                          logo2: event.team2ImageUrl != null
                                              ? event.team2ImageUrl
                                              : '',
                                          text1: event.team1TeamSName != null
                                              ? event.team1TeamSName.toString()
                                              : '',
                                          text2: event.team2TeamSName != null
                                              ? event.team2TeamSName.toString()
                                              : '',
                                          Match_id: event.matchId.toString(),
                                          Contest_Id: event.contest_id,
                                          team1_id: event.team1Id.toString(),
                                          team2_id: event.team2Id.toString(),
                                          stats: event.state,
                                          winnings: event.winnings,
                                        ),
                                  ),
                                );
                              } else if (event.state == "In Progress") {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LiveMatch_contests(
                                      logo1: event.team1ImageUrl,
                                      logo2: event.team2ImageUrl,
                                      text1: event.team1TeamSName,
                                      text2: event.team2TeamSName,
                                      status: event.state.toString(),
                                      Match_id: event.matchId.toString(),
                                      team1_id: event.team1Id,
                                      team2_id: event.team2Id,
                                    ),
                                  ),
                                );
                              } else if (event.state == "under_review") {
                                Fluttertoast.showToast(
                                    msg:
                                    "Winning price will send in 15 minuets",
                                    fontSize: 14,
                                    backgroundColor: Colors.black,
                                    textColor: Colors.white);
                              } else if (event.state == "Toss") {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CreateContest(
                                      logo1: event.team1ImageUrl != null
                                          ? event.team1ImageUrl
                                          : '',
                                      logo2: event.team2ImageUrl != null
                                          ? event.team2ImageUrl
                                          : '',
                                      text1: event.team1TeamSName != null
                                          ? event.team1TeamSName.toString()
                                          : '',
                                      text2: event.team2TeamSName != null
                                          ? event.team1TeamSName.toString()
                                          : '',
                                      time_hours: event.start_date.toString(),
                                      match_id: event.matchId.toString(),
                                      team1_Id: event.team1Id.toString(),
                                      team2_Id: event.team2Id.toString(),
                                      Average_Score: '',
                                      HighestScore: '',
                                    ),
                                  ),
                                );
                              }
                            },
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: 8, right: 8, top: 4, bottom: 5),
                              child: Container(
                                  height: size.height * 0.13,
                                  width: size.width,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.white,
                                  ),
                                  // Center the contents of the container
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10),
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                children: [
                                                  Center(
                                                    child: CircleAvatar(
                                                      backgroundImage:
                                                      MemoryImage(
                                                          base64Decode(event
                                                              .team1ImageUrl
                                                              .toString())),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                    const EdgeInsets.only(
                                                        left: 5),
                                                    child: Center(
                                                      child: Text(
                                                          event.team1TeamSName !=
                                                              null
                                                              ? event
                                                              .team1TeamSName
                                                              .toString()
                                                              : '',
                                                          style: TextStyle(
                                                              color:
                                                              Colors.black,
                                                              fontWeight:
                                                              FontWeight
                                                                  .w800,
                                                              fontSize: 14)),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                  event.state
                                                      .toString()
                                                      .toLowerCase() ==
                                                      "in progress"
                                                      ? "Live"
                                                      : event.state
                                                      .toString()
                                                      .toLowerCase() ==
                                                      "under_review"
                                                      ? "Under Review"
                                                      : event.state
                                                      .toString(),
                                                  style: TextStyle(
                                                      color: event.state
                                                          .toString() ==
                                                          "In Progress"
                                                          ? Colors.red
                                                          : Colors.green,
                                                      fontWeight:
                                                      FontWeight.w800,
                                                      fontSize: 12)),
                                              if (event.state == "Complete")
                                                Center(
                                                    child: Text(
                                                      "${formatMillisecondsSinceEpoch(event.start_date != null ? event.start_date.toString() : '454875')}",
                                                      style: TextStyle(
                                                          color: Colors.red,
                                                          fontWeight:
                                                          FontWeight.bold,
                                                          fontSize: 13),
                                                    )
                                                  // MyMatchNewData(
                                                  //   time:
                                                  //   event.start_date != null ? event.start_date.toString() : '454875' ,
                                                  // ),
                                                ),
                                              if (event.state == "Toss")
                                                Center(
                                                  child: CountdownTimerWidget(
                                                    time:
                                                    event.start_date != null
                                                        ? event.start_date!
                                                        : '454875',
                                                  ),
                                                ),
                                            ],
                                          ),
                                          Expanded(
                                            child: FractionallySizedBox(
                                              widthFactor:
                                              1.0, // Adjust the width factor as needed
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 10),
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                      const EdgeInsets.only(
                                                          right: 5),
                                                      child: Center(
                                                        child: Text(
                                                          event.team2TeamSName !=
                                                              null
                                                              ? event
                                                              .team2TeamSName
                                                              .toString()
                                                              : '',
                                                          style: TextStyle(
                                                              color:
                                                              Colors.black,
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold,
                                                              fontSize: 14),
                                                        ),
                                                      ),
                                                    ),
                                                    Center(
                                                      child: CircleAvatar(
                                                        backgroundImage: MemoryImage(
                                                            base64Decode(event
                                                                .team2ImageUrl
                                                                .toString())),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 5, right: 5, top: 5),
                                        child: Container(
                                          height: size.height * 0.04,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(10),
                                              bottomLeft: Radius.circular(10),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  // _showDetailsPopup(context,"First Prize = ${widget.first_Prize != null ? widget.first_Prize : "1 Rs"}");
                                                },
                                                child: Padding(
                                                  padding:
                                                  const EdgeInsets.only(
                                                      left: 5),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        "${event.tolatCreatTeams.toString()} Teams",
                                                        style: TextStyle(
                                                          color: Colors.black54,
                                                          fontSize: 13,
                                                          fontWeight:
                                                          FontWeight.w600,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  // double result = double.parse(widget.user_participant.toString()) * double.parse(widget.winnerCriteria.toString())  / 100;
                                                  // print("result"+result.toString());
                                                  // double newData=double.parse(widget.user_participant.toString())-result;
                                                  // _showDetailsPopup(context, "$newData teams win the contest");
                                                },
                                                child: Row(
                                                  children: [
                                                    CustomPaddedText(
                                                      text:
                                                      "${event.totalJoinContest.toString()} Contest",
                                                      // " 2 Contest",
                                                      style: TextStyle(
                                                        color: Colors.black54,
                                                        fontSize: 13,
                                                        fontWeight:
                                                        FontWeight.w600,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              if (event.is_lineupOut == "1" &&
                                                  event.state == "Toss")
                                                Icon(
                                                  Icons.label_outline,
                                                  color: Colors.green,
                                                  size: 20,
                                                ),
                                              if (event.is_lineupOut == "1" &&
                                                  event.state == "Toss")
                                                CustomPaddedText(
                                                  text: event.is_lineupOut ==
                                                      "1" &&
                                                      event.state == "Toss"
                                                      ? "Lineups Out"
                                                      : '',
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                      FontWeight.w800,
                                                      color: Colors.green),
                                                ),
                                              if (event.state == "Complete")
                                                InkWell(
                                                  onTap: () {
                                                    // _showDetailsPopup(context,"Guaranteed to take place regardless of spots filled");
                                                  },
                                                  child: Padding(
                                                    padding:
                                                    const EdgeInsets.only(
                                                        right: 5),
                                                    child: Row(
                                                      children: [
                                                        event.winnings
                                                            .toString()
                                                            .isNotEmpty &&
                                                            event.winnings
                                                                .toString() !=
                                                                "0"
                                                            ? Text(
                                                          " You won Rs ${event.winnings}",
                                                          style: TextStyle(
                                                              fontSize:
                                                              11,
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold,
                                                              color: event.winnings.toString().isNotEmpty &&
                                                                  event.winnings.toString() ==
                                                                      "0"
                                                                  ? Colors
                                                                  .black
                                                                  : Colors
                                                                  .green),
                                                        )
                                                            : Text(
                                                          "No winnings",
                                                          style: TextStyle(
                                                              fontSize:
                                                              11,
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold,
                                                              color: event.winnings.toString().isNotEmpty &&
                                                                  event.winnings.toString() ==
                                                                      "0"
                                                                  ? Colors
                                                                  .black
                                                                  : Colors
                                                                  .green),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                            ),
                          );
                        },
                        onPageChanged: (index) {
                          setState(() {
                            _data_index = index;
                          });
                        },
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _match_Data_Complete.map((item) {
                        int index = _match_Data_Complete.indexOf(item);
                        return Container(
                          width: 5.0,
                          height: 4.0,
                          margin: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 2.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: index == _data_index
                                ? Colors.black
                                : Colors.grey,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            // SizedBox(
            //   height: 5,
            // ),
            Expanded(
              child: Column(
                children: [
                  DefaultTabController(
                    length: 3, // Set the length to the number of tabs
                    child: Expanded(
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            height: size.height * 0.04,
                            color: Colors.white,
                            child: TabBar(
                              labelStyle: TextStyle(
                                fontSize: 12
                              ),
                              indicatorSize: TabBarIndicatorSize.tab,
                              labelColor: Colors.white,
                              indicatorColor: Colors.transparent,
                              controller: _tabController,
                              unselectedLabelColor: Colors.black,
                              indicator: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFF880E4F),
                                    Color(0xFF2F33D0)
                                  ], // Replace with your gradient colors
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(
                                    20), // Adjust the border radius as needed
                              ),
                              tabs: [
                                Tab(text: 'UPCOMING'.tr),
                                Tab(text: 'LIVE'.tr),
                                Tab(text: 'COMPLETED'.tr),
                              ],
                            ),
                          ),
                         // SizedBox(height: size.height * 0.01),
                          Expanded(
                            child: TabBarView(
                              controller: _tabController,
                              children: [
                                //Upcoming Match tab view
                                FutureBuilder<List<UpcomingMatch_Recents_Data>?>(
                                  future: future,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                          child: SpinKitFadingCircle(
                                            color: Colors.redAccent,
                                            size: 50.0,
                                          ));
                                    } else if (snapshot.hasError) {
                                      return Text('No Internet');
                                    } else if (!snapshot.hasData) {
                                      return RefreshIndicator(
                                          color: Colors.red,
                                          backgroundColor: Colors.white,
                                          onRefresh: () async {
                                            await Future.delayed(
                                              const Duration(seconds: 2),
                                            );
                                            setState(() {
                                              allUpcomingMatches = [];
                                              page = 1;
                                              future = fetchUpcomingMatches(
                                                  "upcoming", 1);
                                            });
                                          },
                                          child: Container(
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  height: 60,
                                                ),
                                                Container(
                                                  height: 150,
                                                  width: double.infinity,
                                                  child: Image.asset(
                                                    ImageAssets
                                                        .no_events_available,
                                                    fit: BoxFit.contain,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 25,
                                                ),
                                                Text(
                                                  "No Upcoming match available",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ));
                                    } else {
                                      return RefreshIndicator(
                                        color: Colors.red,
                                        backgroundColor: Colors.white,
                                        onRefresh: () async {
                                          await Future.delayed(
                                            const Duration(seconds: 2),
                                          );
                                          setState(() {
                                            allUpcomingMatches = [];
                                            page = 1;
                                            future = fetchUpcomingMatches(
                                                "upcoming", 1);
                                            print("page::::" + page.toString());
                                          });
                                        },
                                        child: ListView.builder(
                                          controller: scrollController,
                                          itemCount: isLoading_More
                                              ? allUpcomingMatches!.length
                                              : allUpcomingMatches!.length,
                                          itemBuilder: (context, index) {
                                            final event =
                                            allUpcomingMatches![index];
                                            DateTime currentTime =
                                            DateTime.now();
                                            DateTime eventTime = DateTime
                                                .fromMillisecondsSinceEpoch(
                                                int.parse(
                                                    event.startDate != null
                                                        ? event.startDate
                                                        : '445754'));
                                            Duration timeDifference = eventTime
                                                .difference(currentTime);
                                            if (timeDifference.inSeconds > 0) {
                                              if (index <
                                                  allUpcomingMatches!.length) {
                                                return InkWell(
                                                  onTap: () {
                                                    if (timeDifference
                                                        .inHours <=
                                                        72) {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              CreateContest(
                                                                logo1: event.firstTeam !=
                                                                    null
                                                                    ? event
                                                                    .firstTeam!
                                                                    .imageData
                                                                    : '',
                                                                logo2: event.secondTeam !=
                                                                    null
                                                                    ? event
                                                                    .secondTeam!
                                                                    .imageData
                                                                    : '',
                                                                text1: event.firstTeam !=
                                                                    null
                                                                    ? event
                                                                    .firstTeam!
                                                                    .teamSName
                                                                    .toString()
                                                                    : '',
                                                                text2: event.secondTeam !=
                                                                    null
                                                                    ? event
                                                                    .secondTeam!
                                                                    .teamSName
                                                                    .toString()
                                                                    : '',
                                                                time_hours: event
                                                                    .startDate
                                                                    .toString(),
                                                                match_id: event
                                                                    .matchId
                                                                    .toString(),
                                                                team1_Id: event
                                                                    .team1Id
                                                                    .toString(),
                                                                team2_Id: event
                                                                    .team2Id
                                                                    .toString(),
                                                                Average_Score: event
                                                                    .venueFieldDetails !=
                                                                    null &&
                                                                    event
                                                                        .venueFieldDetails!
                                                                        .ground
                                                                        .isNotEmpty
                                                                    ? event
                                                                    .venueFieldDetails!
                                                                    .ground
                                                                    : '',
                                                                HighestScore: event
                                                                    .venueFieldDetails !=
                                                                    null &&
                                                                    event
                                                                        .venueFieldDetails!
                                                                        .city
                                                                        .isNotEmpty
                                                                    ? event
                                                                    .venueFieldDetails!
                                                                    .city
                                                                    : '',
                                                              ),
                                                        ),
                                                      );
                                                    } else {
                                                      Fluttertoast.showToast(
                                                          msg:
                                                          "Contest for this match will open soon!",
                                                          fontSize: 15,
                                                          textColor:
                                                          Colors.white,
                                                          backgroundColor:
                                                          Colors.black);
                                                    }
                                                  },
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 10,
                                                        right: 10,
                                                        top: 5,
                                                        bottom: 5),
                                                    child: Container(
                                                        height:
                                                        size.height * 0.14,
                                                        width: size.width * 0.8,
                                                        decoration:
                                                        BoxDecoration(
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(10),
                                                          color: timeDifference
                                                              .inHours <=
                                                              72
                                                              ? Colors.white
                                                              : Colors.grey
                                                              .withOpacity(
                                                              0.15), // Event is not clickable, use transparent gray background
                                                        ),
                                                        // Center the contents of the container
                                                        child: Column(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 10,
                                                                  right:
                                                                  10),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    event.seriesName !=
                                                                        null
                                                                        ? event
                                                                        .seriesName
                                                                        : '' + "," + event.matchFormat !=
                                                                        null
                                                                        ? event.matchFormat
                                                                        : '',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                        10),
                                                                  ),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                    crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                    children: [
                                                                      if (event
                                                                          .lineOut ==
                                                                          "1")
                                                                        Icon(
                                                                          Icons
                                                                              .label_outline,
                                                                          color:
                                                                          Colors.green,
                                                                          size:
                                                                          20,
                                                                        ),
                                                                      CustomPaddedText(
                                                                        text: event.lineOut ==
                                                                            "1"
                                                                            ? "Lineups Out"
                                                                            : '',
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                            13,
                                                                            fontWeight:
                                                                            FontWeight.w800,
                                                                            color: Colors.green),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                              children: [
                                                                Expanded(
                                                                  child:
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                        10),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                      children: [
                                                                        Center(
                                                                          child:
                                                                          CircleAvatar(
                                                                            backgroundImage: MemoryImage(base64Decode(event.firstTeam != null
                                                                                ? event.firstTeam!.imageData
                                                                                : '/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDABALDA4MChAODQ4SERATGCgaGBYWGDEjJR0oOjM9PDkzODdASFxOQERXRTc4UG1RV19iZ2hnPk1xeXBkeFxlZ2P/2wBDARESEhgVGC8aGi9jQjhCY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2P/wgARCAAkADADASIAAhEBAxEB/8QAGQAAAgMBAAAAAAAAAAAAAAAAAAMBAgQF/8QAGAEBAQEBAQAAAAAAAAAAAAAAAAECAwT/2gAMAwEAAhADEAAAAe9JIrPMefbm1v3wKbzTVXIyNOjk9alyFLsBIB//xAAfEAACAgIBBQAAAAAAAAAAAAABAgARAxASEyEiI0P/2gAIAQEAAQUC0x4g5CDjJYbyNcU1E7jTETxrkkRk3nvr5XDT6KfZLlwABpcuf//EABcRAAMBAAAAAAAAAAAAAAAAAAASITD/2gAIAQMBAT8BFmH/xAAaEQADAAMBAAAAAAAAAAAAAAAAARECAxAg/9oACAECAQE/AR7LlELkRJ4//8QAIRAAAQMEAQUAAAAAAAAAAAAAAQARIQIQEiAiMUFRobH/2gAIAQEABj8Cs6HdORo2rZMoIUn0mpNwwfhI8hcTGI+rGonGeqogtEPI0NQElGL/AP/EAB0QAQADAQADAQEAAAAAAAAAAAEAETEhQVFhkRD/2gAIAQEAAT8hAo5KPUyQ1KhAeQlCAZEKeQw/lqmEoPtyLrHGGEuXHFpfiUAovKLlhRIeov2G/kcYYSzzR7bDksduHE4hwLFFrzyhf2Leiiv0P09xxl6l4AA0rzCjgd6zWEvU/9oADAMBAAIAAwAAABCCtFZOqCDz/8QAGREAAwEBAQAAAAAAAAAAAAAAAAERMRAg/9oACAEDAQE/EBRTQ95WN3fH/8QAGREAAwADAAAAAAAAAAAAAAAAAAERICEx/9oACAECAQE/EBFKHI1TVIJEiw//xAAhEAEAAgICAwADAQAAAAAAAAABABEhMVGhQWFxEIGR0f/aAAgBAQABPxBmJriep/ISEmxUUVBRdPMUDWBWXlhMTXE634AVvYnlhoSywcX+5tA5dNzrTrRNnWYB9vkABwNCw6T/AGOpJFhVe4C1HZa+cTrTrQFhVCxlQefXmqgWNWbipLMiDSeIkHbYSR/AUR1wKFYmRjIR1oACjUzaIuVqdj6Ty+4qQR6tvPUuhyHmoosGp//Z')),
                                                                          ),
                                                                        ),
                                                                        Padding(
                                                                          padding: const EdgeInsets
                                                                              .only(
                                                                              left: 5),
                                                                          child:
                                                                          Center(
                                                                            child:
                                                                            Text(event.firstTeam != null ? event.firstTeam!.teamSName : '', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontSize: 14)),
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                                Text(
                                                                    event.state !=
                                                                        null
                                                                        ? event
                                                                        .state
                                                                        : '?',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .green,
                                                                        fontWeight:
                                                                        FontWeight
                                                                            .w800,
                                                                        fontSize:
                                                                        12)),
                                                                Expanded(
                                                                  child:
                                                                  FractionallySizedBox(
                                                                    widthFactor:
                                                                    1.0,
                                                                    // Adjust the width factor as needed
                                                                    child:
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                          .only(
                                                                          right:
                                                                          10),
                                                                      child:
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                        MainAxisAlignment.end,
                                                                        children: [
                                                                          Padding(
                                                                            padding:
                                                                            const EdgeInsets.only(right: 5),
                                                                            child:
                                                                            Center(
                                                                              child: Text(
                                                                                event.secondTeam != null ? event.secondTeam!.teamSName : '',
                                                                                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Center(
                                                                            child:
                                                                            CircleAvatar(
                                                                              backgroundImage: MemoryImage(base64Decode(event.secondTeam != null ? event.secondTeam!.imageData : '/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDABALDA4MChAODQ4SERATGCgaGBYWGDEjJR0oOjM9PDkzODdASFxOQERXRTc4UG1RV19iZ2hnPk1xeXBkeFxlZ2P/2wBDARESEhgVGC8aGi9jQjhCY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2P/wgARCAAkADADASIAAhEBAxEB/8QAGQAAAgMBAAAAAAAAAAAAAAAAAAMBAgQF/8QAGAEBAQEBAQAAAAAAAAAAAAAAAAECAwT/2gAMAwEAAhADEAAAAe9JIrPMefbm1v3wKbzTVXIyNOjk9alyFLsBIB//xAAfEAACAgIBBQAAAAAAAAAAAAABAgARAxASEyEiI0P/2gAIAQEAAQUC0x4g5CDjJYbyNcU1E7jTETxrkkRk3nvr5XDT6KfZLlwABpcuf//EABcRAAMBAAAAAAAAAAAAAAAAAAASITD/2gAIAQMBAT8BFmH/xAAaEQADAAMBAAAAAAAAAAAAAAAAARECAxAg/9oACAECAQE/AR7LlELkRJ4//8QAIRAAAQMEAQUAAAAAAAAAAAAAAQARIQIQEiAiMUFRobH/2gAIAQEABj8Cs6HdORo2rZMoIUn0mpNwwfhI8hcTGI+rGonGeqogtEPI0NQElGL/AP/EAB0QAQADAQADAQEAAAAAAAAAAAEAETEhQVFhkRD/2gAIAQEAAT8hAo5KPUyQ1KhAeQlCAZEKeQw/lqmEoPtyLrHGGEuXHFpfiUAovKLlhRIeov2G/kcYYSzzR7bDksduHE4hwLFFrzyhf2Leiiv0P09xxl6l4AA0rzCjgd6zWEvU/9oADAMBAAIAAwAAABCCtFZOqCDz/8QAGREAAwEBAQAAAAAAAAAAAAAAAAERMRAg/9oACAEDAQE/EBRTQ95WN3fH/8QAGREAAwADAAAAAAAAAAAAAAAAAAERICEx/9oACAECAQE/EBFKHI1TVIJEiw//xAAhEAEAAgICAwADAQAAAAAAAAABABEhMVGhQWFxEIGR0f/aAAgBAQABPxBmJriep/ISEmxUUVBRdPMUDWBWXlhMTXE634AVvYnlhoSywcX+5tA5dNzrTrRNnWYB9vkABwNCw6T/AGOpJFhVe4C1HZa+cTrTrQFhVCxlQefXmqgWNWbipLMiDSeIkHbYSR/AUR1wKFYmRjIR1oACjUzaIuVqdj6Ty+4qQR6tvPUuhyHmoosGp//Z')),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Center(
                                                              child:
                                                              CountdownTimerWidget(
                                                                time: event.startDate !=
                                                                    null
                                                                    ? event
                                                                    .startDate
                                                                    : '454875',
                                                              ),
                                                            ),
                                                          ],
                                                        )),
                                                  ),
                                                );
                                              } else {
                                                return Center(
                                                  child: SpinKitFadingCircle(
                                                    color: Colors.redAccent,
                                                    size: 50.0,
                                                  ),
                                                );
                                              }
                                            } else {
                                              // Start time has ended, do not include this item in the list
                                              return SizedBox.shrink();
                                            }
                                          },
                                        ),
                                      );
                                    }
                                  },
                                ),
                                //Live Match tab view
                                FutureBuilder<List<NewDataClass>?>(
                                  future: future_data,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                          child: SpinKitFadingCircle(
                                            color: Colors.redAccent,
                                            size: 50.0,
                                          ));
                                    } else if (snapshot.hasError) {
                                      return Text('No Internet');
                                    } else if (!snapshot.hasData) {
                                      return RefreshIndicator(
                                          color: Colors.red,
                                          backgroundColor: Colors.white,
                                          onRefresh: () async {
                                            await Future.delayed(
                                              const Duration(seconds: 2),
                                            );
                                            setState(() {
                                              future_data =
                                                  fetchUpcomingMatcheLiveData(
                                                      'live');
                                            });
                                          },
                                          child:Flexible(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  height: 138,
                                                  width: double.infinity,
                                                  child: Image.asset(
                                                    ImageAssets.no_events_available,
                                                    fit: BoxFit.contain,
                                                  ),
                                                ),
                                                Spacer(),
                                                Text(
                                                  "No live match available",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                                SizedBox(height: 25),
                                              ],
                                            ),
                                          ));
                                    } else {
                                      return RefreshIndicator(
                                        color: Colors.red,
                                        backgroundColor: Colors.white,
                                        onRefresh: () async {
                                          await Future.delayed(
                                            const Duration(seconds: 2),
                                          );
                                          setState(() {
                                            future_data =
                                                fetchUpcomingMatcheLiveData(
                                                    'live');
                                          });
                                        },
                                        child: ListView.builder(
                                          itemCount: snapshot.data!.length,
                                          itemBuilder: (context, index) {
                                            final event = snapshot.data![index];
                                            // if (event.matchInfo!.state == 'Complete') {
                                            //   return SizedBox.shrink();
                                            // }
                                            return InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        LiveMatch_contests(
                                                          logo1: event.matchInfo!
                                                              .team1!.imageId,
                                                          logo2: event.matchInfo!
                                                              .team2!.imageId,
                                                          text1: event.matchInfo!
                                                              .team1!.teamSName,
                                                          text2: event.matchInfo!
                                                              .team2!.teamSName,
                                                          status: event
                                                              .matchInfo!.state
                                                              .toString(),
                                                          Match_id: event
                                                              .matchInfo!.matchId
                                                              .toString(),
                                                          team1_id: event.matchInfo!
                                                              .team1!.teamId,
                                                          team2_id: event.matchInfo!
                                                              .team2!.teamId,
                                                        ),
                                                  ),
                                                );
                                              },
                                              child: Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Container(
                                                    height: size.height * 0.12,
                                                    width: size.width * 0.8,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          15),
                                                      color: Colors.white,
                                                    ),
                                                    // Center the contents of the container
                                                    child: Column(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .center,
                                                      children: [
                                                        Text(
                                                          event.matchInfo!
                                                              .seriesName! +
                                                              "," +
                                                              event.matchInfo!
                                                                  .matchFormat!,
                                                          style: TextStyle(
                                                              fontSize: 10),
                                                        ),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          children: [
                                                            Flexible(
                                                              flex: 1,
                                                              child: Padding(
                                                                padding: const EdgeInsets.only(left: 10),
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  children: [
                                                                    Center(
                                                                      child: CircleAvatar(
                                                                        backgroundImage: MemoryImage(base64Decode(
                                                                            event.matchInfo!.team1!.imageId!)),
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets.only(left: 3),
                                                                      child: Center(
                                                                          child: Text(
                                                                            event.matchInfo!.team1 != null
                                                                                ? limitWords(event.matchInfo!.team1!.teamSName!, 3)
                                                                                : '',
                                                                            style: TextStyle(
                                                                              color: Colors.black,
                                                                              fontWeight: FontWeight.w800,
                                                                              fontSize: 14,
                                                                            ),
                                                                            overflow: TextOverflow.ellipsis,
                                                                            maxLines: 1,
                                                                          )
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            Text(
                                                              event.matchInfo!.state!,
                                                              style: TextStyle(
                                                                  color: Colors.green,
                                                                  fontWeight: FontWeight.w800,
                                                                  fontSize: 10),
                                                              overflow: TextOverflow.ellipsis,
                                                            ),
                                                            Flexible(
                                                              flex: 1,
                                                              child: FractionallySizedBox(
                                                                widthFactor: 1.0, // Adjust the width factor as needed
                                                                child: Padding(
                                                                  padding: const EdgeInsets.only(right: 8),
                                                                  child: Row(
                                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                                    children: [
                                                                      Container(
                                                                        child: Padding(
                                                                          padding: const EdgeInsets.only(right: 3),
                                                                          child: Center(
                                                                            child: Text(
                                                                              event.matchInfo!.team2 != null
                                                                                  ? limitWords(event.matchInfo!.team2!.teamSName!, 3)
                                                                                  : '',
                                                                              style: TextStyle(
                                                                                  color: Colors.black,
                                                                                  fontWeight: FontWeight.bold,
                                                                                  fontSize: 14),
                                                                              overflow: TextOverflow.ellipsis,
                                                                              maxLines: 1,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Center(
                                                                        child: CircleAvatar(
                                                                          backgroundImage: MemoryImage(
                                                                              base64Decode(event.matchInfo!.team2!.imageId!)),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),

                                                        Center(
                                                          child: Text(
                                                            event.matchInfo!
                                                                .status!,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                                fontSize: 10),
                                                          ),
                                                          // child: CountdownTimerWidget(time: event.startDate,),
                                                          // child:  getTimeData(event.matchInfo!.startDate),
                                                        ),
                                                      ],
                                                    )),
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    }
                                  },
                                ),
                                //Completed Match tab view
                                FutureBuilder<List<UpcomingMatch_Recents_Data>?>(
                                  future: _future,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                        child: SpinKitFadingCircle(
                                          color: Colors.redAccent,
                                          size: 50.0,
                                        ),
                                      );
                                    } else if (snapshot.hasError) {
                                      return Text('No Internet');
                                    } else if (!snapshot.hasData) {
                                      return RefreshIndicator(
                                          color: Colors.red,
                                          backgroundColor: Colors.white,
                                          onRefresh: () async {
                                            await Future.delayed(
                                              const Duration(seconds: 2),
                                            );

                                            setState(() {
                                              page_recent = 1;
                                              allUpcomingMatches_recent = [];
                                              _future =
                                                  fetchUpcomingMatches_recent(
                                                      "recent", 1);
                                            });
                                          },
                                          child: Center(
                                              child:
                                              Text('No events available')));
                                    } else {
                                      return RefreshIndicator(
                                        color: Colors.red,
                                        backgroundColor: Colors.white,
                                        onRefresh: () async {
                                          await Future.delayed(
                                            const Duration(seconds: 2),
                                          );
                                          setState(() {
                                            page_recent = 1;
                                            allUpcomingMatches_recent = [];
                                            _future =
                                                fetchUpcomingMatches_recent(
                                                    "recent", 1);
                                          });
                                        },
                                        child: ListView.builder(
                                          controller: scrollController_recent,
                                          itemCount: isLoading_More_Data
                                              ? allUpcomingMatches_recent!
                                              .length
                                              : allUpcomingMatches_recent!
                                              .length,
                                          itemBuilder: (context, index) {
                                            final event =
                                            allUpcomingMatches_recent![
                                            index];
                                            return InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          CompleteMatch_contest(
                                                            text1: event
                                                                .firstTeam!
                                                                .teamSName,
                                                            logo1: event
                                                                .firstTeam!
                                                                .imageData,
                                                            logo2: event
                                                                .secondTeam!
                                                                .imageData,
                                                            text2: event
                                                                .secondTeam!
                                                                .teamSName,
                                                            stats: event.state,
                                                            Match_id: event
                                                                .matchId
                                                                .toString(),
                                                            team1_id:
                                                            event.team1Id,
                                                            team2_id:
                                                            event.team2Id,
                                                          )),
                                                );
                                              },
                                              child: Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Container(
                                                    height: size.height * 0.12,
                                                    width: size.width * 0.8,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          15),
                                                      color: Colors.white,
                                                    ),
                                                    // Center the contents of the container
                                                    child: Column(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .center,
                                                      children: [
                                                        Text(
                                                          event.seriesName +
                                                              "," +
                                                              event.matchFormat,
                                                          style: TextStyle(
                                                              fontSize: 10),
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                          children: [
                                                            Expanded(
                                                              child: Padding(
                                                                padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left:
                                                                    10),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                                  children: [
                                                                    Center(
                                                                      child:
                                                                      CircleAvatar(
                                                                        backgroundImage: event.firstTeam?.imageData != null
                                                                            ? MemoryImage(base64Decode(event.firstTeam!.imageData!)) as ImageProvider<Object>?
                                                                            : AssetImage('assets/images/circle_red.png') as ImageProvider<Object>?,
                                                                      )
                                                                      ,
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                          .only(
                                                                          left:
                                                                          5),
                                                                      child:
                                                                      Center(
                                                                        child: Text(
                                                                            event.firstTeam != null
                                                                                ? event.firstTeam!.teamSName
                                                                                : '',
                                                                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontSize: 14)),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            Text(event.state,
                                                                style: TextStyle(
                                                                    color: event.state.toString() ==
                                                                        "Abandon"
                                                                        ? Colors
                                                                        .red
                                                                        : Colors
                                                                        .green,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w800,
                                                                    fontSize:
                                                                    12)),
                                                            Expanded(
                                                              child:
                                                              FractionallySizedBox(
                                                                widthFactor:
                                                                1.0, // Adjust the width factor as needed
                                                                child: Padding(
                                                                  padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      right:
                                                                      10),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .end,
                                                                    children: [
                                                                      Padding(
                                                                        padding: const EdgeInsets
                                                                            .only(
                                                                            right:
                                                                            5),
                                                                        child:
                                                                        Center(
                                                                          child:
                                                                          Text(
                                                                            event.secondTeam != null
                                                                                ? event.secondTeam!.teamSName
                                                                                : '',
                                                                            style: TextStyle(
                                                                                color: Colors.black,
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 14),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Center(
                                                                        child:
                                                                        CircleAvatar(
                                                                          backgroundImage: event.secondTeam?.imageData != null
                                                                              ? MemoryImage(base64Decode(event.secondTeam!.imageData!)) as ImageProvider<Object>?
                                                                              : AssetImage('assets/images/circle_red.png') as ImageProvider<Object>?,
                                                                        )
                                                                        ,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Center(
                                                          child: Text(
                                                            event.status,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                                fontSize: 10),
                                                          ),
                                                        ),
                                                      ],
                                                    )),
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        )
      ),
    );
  }

  Widget buildCarousel() {
    return Stack(
      children: [
        CarouselSlider(
          items: _info.map((item) {
            return ClipRRect(
              child: AnimatedBuilder(
                animation: _swingAnimation,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _swingAnimation.value,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(

                        width: 390,
                        height: 90,
                        child: Image.network(
                          "https://admin.googly11.in/public/setting/${item.image}",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }).toList(),
          options: CarouselOptions(
            viewportFraction: 1,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 5),
            height: 120,
            aspectRatio: 16 / 9,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),
      ],
    );
  }

  // Widget buildCarousel() {
  //   return Stack(
  //     children: [
  //       CarouselSlider(
  //         items: _info.map((item) {
  //           return ClipRRect(
  //            // borderRadius: BorderRadius.circular(12),
  //             child: Container(
  //               width: 390,
  //               height: 90,
  //               child: Image.network(
  //                 "https://admin.googly11.in/public/setting/${item.image}",
  //                 fit: BoxFit.cover,
  //               ),
  //             ),
  //           );
  //         }).toList(),
  //         options: CarouselOptions(
  //           viewportFraction: 1,
  //           autoPlay: true,
  //           autoPlayInterval: Duration(seconds: 5),
  //           height: 120,
  //           aspectRatio: 16 / 9,
  //           onPageChanged: (index, reason) {
  //             setState(() {
  //               _currentIndex = index;
  //             });
  //           },
  //         ),
  //       ),
  //       // Align(
  //       //   alignment: Alignment.bottomCenter,
  //       //   child: Row(
  //       //     mainAxisAlignment: MainAxisAlignment.center,
  //       //     children: _info.map((item) {
  //       //       int index = _info.indexOf(item);
  //       //       return Container(
  //       //         width: 8.0,
  //       //         height: 8.0,
  //       //         margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
  //       //         decoration: BoxDecoration(
  //       //           shape: BoxShape.circle,
  //       //           color: _currentIndex == index ? Colors.blue : Colors.grey,
  //       //         ),
  //       //       );
  //       //     }).toList(),
  //       //   ),
  //       // ),
  //     ],
  //   );
  // }

  String limitWords(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    } else {
      return text.substring(0, maxLength) + '...';
    }
  }

  
}

Future<void> logout(String token) async {
  final String apiUrl = 'https://admin.googly11.in/api/logout';

  final Map<String, String> headers = {
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
  };

  try {
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: headers,
    );
    print('Logout failed. Status code: ${response.statusCode}');
    print('Response body: ${response.body}');
    if (response.statusCode == 200) {
      UserInfoUpdate update =
          UserInfoUpdate.fromJson(jsonDecode(response.body));
      if (update.status == 1) {
        Fluttertoast.showToast(
            msg: "Logout successfully",
            textColor: Colors.white,
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Colors.red);
      } else {
        Fluttertoast.showToast(
            msg: "Something went wrong",
            textColor: Colors.white,
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Colors.red);
      }
      print('Logout successful');
    } else if (response.statusCode == 401) {
      Fluttertoast.showToast(
          msg: "Unauthenticated",
          textColor: Colors.white,
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red);
      print('Logout failed. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  } catch (error) {
    // Handle network or other errors
    print('Error during logout request: $error');
  }
}

void _showAlertDialog(BuildContext context, String token) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.blueGrey[50],
        title: Text("LOGOUT".tr,
            style: TextStyle(
                color: Colors.blueAccent, fontWeight: FontWeight.bold)),
        content: Text(
          "Are logout".tr,
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.green),
            onPressed: () async {
              Navigator.pop(context);
            },
            child: Text("NO".tr),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
            onPressed: () async {
              var user = await LoginAPi.signOut;
              logout(token);
              final SharedPreferences sp =
                  await SharedPreferences.getInstance();
              sp.remove("email_user");
              sp.remove("user_photo");
              sp.remove("user_name");
              sp.remove("token");
              sp.remove("mobile_number");
              sp.remove("invite_code");
              sp.remove("UserName");
              sp.remove("Local_value");
              sp.clear();

              String userName = sp.getString("user_name").toString();
              String userPhoto = sp.getString("user_photo").toString();
              print("user_name:::::" + userName + "::::::" + userPhoto);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginView()),
                (route) => false,
              );
              if (user == null) {
                print('logout');
              }
            },
            child: Text("YES".tr),
          ),
        ],
      );
    },
  );
}

class CountdownTimerWidget extends StatefulWidget {
  final String time;

  CountdownTimerWidget({required this.time});

  @override
  _CountdownTimerWidgetState createState() => _CountdownTimerWidgetState();
}

class _CountdownTimerWidgetState extends State<CountdownTimerWidget> {
  late Timer _timer;
  late Duration _remainingTime;

  @override
  void initState() {
    super.initState();

    // Parse the provided time string to get the target time
    DateTime targetTime =
        DateTime.fromMillisecondsSinceEpoch(int.parse(widget.time));

    // Calculate the remaining time
    _remainingTime = targetTime.difference(DateTime.now());

    // Start a timer to update the UI every second
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        // Check if the remaining time is greater than 0
        if (_remainingTime.inSeconds > 0) {
          _remainingTime = targetTime.difference(DateTime.now());
        } else {
          timer.cancel();
          _remainingTime = Duration(seconds: 0);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    String formattedTime = _formatDuration(_remainingTime);

    return Text(
      formattedTime,
      style: TextStyle(
          color: Colors.red, fontSize: 11, fontWeight: FontWeight.w600),
    );
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    if (duration.inDays > 0) {
      // Format the date along with the time
      DateTime targetDate = DateTime.now().add(duration);
      String formattedDate = DateFormat('dd MMM yyyy').format(targetDate);
      return '$formattedDate';
    } else if (duration.inHours > 0) {
      return '${duration.inHours}h : ${(duration.inMinutes % 60).toString().padLeft(2, '0')}m : ${(duration.inSeconds % 60).toString().padLeft(2, '0')}s';
    } else {
      return '${duration.inMinutes}m : ${(duration.inSeconds % 60).toString().padLeft(2, '0')}s';
    }
  }
}

class MyMatchNewData extends StatefulWidget {
  final String time;

  MyMatchNewData({required this.time});

  @override
  _MyMatchNewData createState() => _MyMatchNewData();
}

class _MyMatchNewData extends State<MyMatchNewData> {
  late Timer _timer;
  late Duration _remainingTime;

  @override
  void initState() {
    super.initState();

    // Parse the provided time string to get the target time
    print("time::::::" + widget.time);
    DateTime targetTime =
        DateTime.fromMillisecondsSinceEpoch(int.parse(widget.time));

    // Calculate the remaining time
    _remainingTime = targetTime.difference(DateTime.now());

    // Start a timer to update the UI every second
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        // Check if the remaining time is greater than 0
        if (_remainingTime.inSeconds > 0) {
          _remainingTime = targetTime.difference(DateTime.now());
        } else {
          timer.cancel();
          _remainingTime = Duration(seconds: 0);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    String formattedTime = _formatDuration(_remainingTime);

    return Text(
      formattedTime,
      style: TextStyle(
          color: Colors.red, fontSize: 11, fontWeight: FontWeight.w600),
    );
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    if (duration.inDays > 0) {
      // Format the date along with the time
      DateTime targetDate = DateTime.now().add(duration);
      String formattedDate = DateFormat('dd MMM yyyy').format(targetDate);
      return '$formattedDate';
    } else {
      return '${duration.inMinutes}m : ${(duration.inSeconds % 60).toString().padLeft(2, '0')}s';
    }
  }
}

class AlertDialogClass extends StatefulWidget {
  var price;
  AlertDialogClass(this.price);

  @override
  _AlertDialogState createState() => _AlertDialogState();
}

class _AlertDialogState extends State<AlertDialogClass> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 260,
      color: Colors.lightBlue[100],
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/celebration.gif',
              fit: BoxFit.cover,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "You've got",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "\u20B9 ${widget.price}",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),

              Text(
                "Welcome bonus",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20), // Add spacing
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.green, // Button color// Button height and width
                ),
                child: Text('OK'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class YourWidgetName extends StatefulWidget {
  var token;
  ApiProvider apiProvider;
  YourWidgetName({Key? key, this.token, required this.apiProvider})
      : super(key: key);
  @override
  _YourWidgetNameState createState() => _YourWidgetNameState();
}

class _YourWidgetNameState extends State<YourWidgetName> {
  TextEditingController referral_controller = TextEditingController();
  bool reffral_code_loading = false;
  String _token = ''; // Your token variable
  // Define your SendReferral_Code function if you haven't already

  Future<void> SendReferral_Code(String token, String Reffral_Code) async {
    var apiUrl = 'https://admin.googly11.in/api/user_reffran';

    // Request headers
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${widget.token}',
    };

    Map<String, String> body = {'reffran_code': '$Reffral_Code'};
    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: body,
      );
      print('API call failed with status:::::::::: ${response.statusCode}');
      print('Response:::::::::: ${response.body}');
      if (response.statusCode == 200) {
        ReferAndEarn userAllData =
            ReferAndEarn.fromJson(jsonDecode(response.body));
        if (userAllData.status == 1) {
          Fluttertoast.showToast(
              msg:
                  "Referral code sent successfully! The corresponding amount will be added to your bonus balance",
              textColor: Colors.white,
              toastLength: Toast.LENGTH_LONG,
              backgroundColor: Colors.black);
          setState(() {
            widget.apiProvider.refferalStatus = "1";
            widget.apiProvider.notifyListeners();
            reffral_code_loading = false;
          });
          Navigator.pop(context);
        } else {
          Fluttertoast.showToast(
              msg: "Something went wrong", textColor: Colors.red);
        }
      } else if (response.statusCode == 401) {
        Fluttertoast.showToast(msg: "Token not found", textColor: Colors.red);
        print('API call failed with status ${response.statusCode}');
        print('Response: ${response.body}');
      } else if (response.statusCode == 400) {
        Fluttertoast.showToast(msg: "User not found", textColor: Colors.red);
      } else if (response.statusCode == 422) {
        ReferAndEarn userAllData =
            ReferAndEarn.fromJson(jsonDecode(response.body));
        Fluttertoast.showToast(
            msg: userAllData.message,
            textColor: Colors.red,
            backgroundColor: Colors.black);
      }
    } catch (e) {
      // Handle exceptions
      print('Error making API call: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Container(
        height: 600,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Refer and Earn',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: referral_controller,
              decoration: InputDecoration(
                hintText: 'Enter your referral code',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(
                    color: Colors.blue,
                    width: 2.0,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.redAccent),
                ),
                onPressed: () {
                  if (referral_controller.text.isNotEmpty) {
                    setState(() {
                      reffral_code_loading = true;
                    });
                    SendReferral_Code(
                            _token, referral_controller.text.toString())
                        .then((value) {
                      setState(() {
                        reffral_code_loading = false;
                      });
                    });
                  } else {
                    Fluttertoast.showToast(msg: "Please Enter a Referral Code");
                  }
                },
                child: reffral_code_loading
                    ? Center(
                        child: Container(
                            height: 30,
                            width: 30,
                            child: SpinKitFadingCircle(
                              color: Colors.redAccent,
                              size: 50.0,
                            )),
                      )
                    : Text('Submit'),
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: Align(
                child: Text(
                  'Refer and Earn 500 Rs \n'
                  'Unlock exclusive rewards with our referral program!',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
  final Widget child;
  const CustomAppBar({required this.child});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: child,
    );
  }
}
