import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import '../Model/AllUpiDataGet/All_Upi_Data_Response.dart';
import '../Model/AllUpiDataGet/Data.dart';
import '../Model/DeleteUpi/Delete_Upi_Response.dart';
import '../Model/GetBankDetails/Data.dart';
import '../Model/GetBankDetails/GetBankDetailsResponse.dart';
import '../Model/GetContestData/Data.dart';
import '../Model/GetContestData/GetContestDataClass.dart';
import '../Model/JoinContestDataResponse/Data.dart';
import '../Model/JoinContestDataResponse/JoinContestDataResponse.dart';
import '../Model/JoinContestList/JoinContestList.dart';
import '../Model/UserAllTeamContestData/Data.dart';
import '../Model/UserAllTeamContestData/UserAllTeamContestDataResponse.dart';

class ApiProvider with ChangeNotifier {
  Future<void> callUserBankDetailsApi(String token) async {
    String apiUrl = 'https://admin.googly11.in/api/user_bank_details';
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    Map<String, String> body = {
      'mobile_number': '1234567890',
      'account_number': '123321123',
      'coform_account_number': '123321123',
      'ifsc_code': 'DAAAA55',
      'bank_name': 'SBI',
      'city': 'LKO',
      'branch': 'LKO',
      'refid': '656',
      'micr': '665',
      'name_at_bank': 'test',
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        print('API call successful');
        print('Response: ${response.body}');
      } else {
        print('API call failed. Status code: ${response.statusCode}');
        print('Response: ${response.body}');
      }
    } catch (error) {
      print('Error during API call: $error');
    }
  }

  List<TeamDataAll> _allTeamUserCreateData=[];
  List<All_Upi_Data> Upi_All_Data=[];
  List<ContestData> AllContestData=[];
  List<BankAllData> Bank_All_Data=[];
  List<TeamDataAll> _allTeamUserCreateDataContest_Id=[];
  List<TeamDataAll> get allTeamUserCreateData => _allTeamUserCreateData;
  List<All_Upi_Data> get all_Upi_Data_get => Upi_All_Data;
  List<BankAllData> get all_Bank_Data_get => Bank_All_Data;
  List<ContestData>? get all_Contest_Data => AllContestData;


  List<TeamDataAll> get allTeamUserCreateData_Contest_Id => _allTeamUserCreateDataContest_Id;
  List<JoinContestData_>? _allContestCreateData;
  List<JoinContestData_>? get allContestCreateData => _allContestCreateData;
  int _selectedIndex = -1;
  int get selectedIndex => _selectedIndex;
  int _selectedIndexBank = -1;
  int get selectedIndexBank => _selectedIndexBank;

  String _selectedUpiId = '';

  String get selectedUpiId => _selectedUpiId;
  String refferalStatus = '';

  String get refferal => refferalStatus;

  String _selectedBankId = '';

  String get selectedBankId => _selectedBankId;

  int Is_lineupOut= 0;
  int get is_lineupOut => Is_lineupOut;

  void setSelectedUpiId(String upiId) {
    _selectedUpiId = upiId;
    notifyListeners();
  }
  void setSelectedBankId(String upiId) {
    _selectedBankId = upiId;
    notifyListeners();
  }

  void toggleSelection(int index) {
    if (_selectedIndex == index) {
      _selectedIndex = -1; // Deselect if already selected
    } else {
      _selectedIndex = index;
    }
    notifyListeners();
  }
  void toggleSelectionBank(int index) {
    if (_selectedIndexBank == index) {
      _selectedIndexBank = -1; // Deselect if already selected
    } else {
      _selectedIndexBank = index;
    }
    notifyListeners();
  }


  Future<void> deleteUPI(int id,String token) async {
    final String url = 'https://admin.googly11.in/api/delete_upi_details/$id';

    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        DeleteUpiResponse upiResponse=DeleteUpiResponse.fromJson(json.decode(response.body));
        if(upiResponse.status == 1){
          Fluttertoast.showToast(msg: upiResponse.message.toString(),textColor: Colors.white,backgroundColor: Colors.black);
          notifyListeners();
        }else{
          Fluttertoast.showToast(msg: upiResponse.message.toString(),textColor: Colors.white,backgroundColor: Colors.black);
        }
      } else if(response.statusCode == 400){
        DeleteUpiResponse upiResponse=DeleteUpiResponse.fromJson(json.decode(response.body));
        if(upiResponse.status == 1){
          Fluttertoast.showToast(msg: upiResponse.message.toString(),textColor: Colors.white,backgroundColor: Colors.black);
          notifyListeners();
        }else{
          Fluttertoast.showToast(msg: upiResponse.message.toString(),textColor: Colors.white,backgroundColor: Colors.black);
        }

        // Handle other status codes
        print('DELETE request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exceptions
      print('Error during DELETE request: $e');
    }

    // Notify listeners to update UI if needed
    notifyListeners();
  }
  Future<void> deleteBank(int id,String token) async {
    final String url = 'https://admin.googly11.in/api/user_bank_details_delete/$id';

    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print("response::::::::::Data"+response.body);
      print("response::::::::::Data"+response.statusCode.toString());
      if (response.statusCode == 200) {
        DeleteUpiResponse upiResponse=DeleteUpiResponse.fromJson(json.decode(response.body));
        if(upiResponse.status == 1){
          Fluttertoast.showToast(msg: upiResponse.message.toString(),textColor: Colors.white,backgroundColor: Colors.black);
          notifyListeners();
        }else{
          Fluttertoast.showToast(msg: upiResponse.message.toString(),textColor: Colors.white,backgroundColor: Colors.black);
        }
      } else if(response.statusCode == 400){
        DeleteUpiResponse upiResponse=DeleteUpiResponse.fromJson(json.decode(response.body));
        if(upiResponse.status == 1){
          Fluttertoast.showToast(msg: upiResponse.message.toString(),textColor: Colors.white,backgroundColor: Colors.black);
          notifyListeners();
        }else{
          Fluttertoast.showToast(msg: upiResponse.message.toString(),textColor: Colors.white,backgroundColor: Colors.black);
        }

        // Handle other status codes
        print('DELETE request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exceptions
      print('Error during DELETE request: $e');
    }

    // Notify listeners to update UI if needed
    notifyListeners();
  }
  Future<void> VerifyBank(int id,String token) async {
    final String url = 'https://admin.googly11.in/api/user_bank_details_verify/$id';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print("response::::::::::Data"+response.body);
      print("response::::::::::Data"+response.statusCode.toString());
      if (response.statusCode == 200) {
        DeleteUpiResponse upiResponse=DeleteUpiResponse.fromJson(json.decode(response.body));
        if(upiResponse.status == 1){
          Fluttertoast.showToast(msg: upiResponse.message.toString(),textColor: Colors.white,backgroundColor: Colors.black);
          notifyListeners();
        }else{
          Fluttertoast.showToast(msg: upiResponse.message.toString(),textColor: Colors.white,backgroundColor: Colors.black);
        }
      } else if(response.statusCode == 400){
        DeleteUpiResponse upiResponse=DeleteUpiResponse.fromJson(json.decode(response.body));
        if(upiResponse.status == 1){
          Fluttertoast.showToast(msg: upiResponse.message.toString(),textColor: Colors.white,backgroundColor: Colors.black);
          notifyListeners();
        }else{
          Fluttertoast.showToast(msg: upiResponse.message.toString(),textColor: Colors.white,backgroundColor: Colors.black);
        }

        // Handle other status codes
        print('DELETE request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exceptions
      print('Error during DELETE request: $e');
    }

    // Notify listeners to update UI if needed
    notifyListeners();
  }

  Future<List<ContestData>?> fetchDataContestData(String match_Id,String token) async {
    final String apiUrl = "https://admin.googly11.in/api/get_contest?match_id=${match_Id}";
    print("Dataa:::::::::::::"+match_Id);
    final response = await http.get(Uri.parse(apiUrl),
        headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    print('Response: ${response.body}');
    print('Response: ${response}');
    if (response.statusCode == 200) {
      GetContestDataClass contestDataClass = GetContestDataClass.fromJson(json.decode(response.body));
      if(contestDataClass.status==1){

        AllContestData=contestDataClass.data!;

        notifyListeners();
        print('Response: ${response.body}');
        return contestDataClass.data;
      }else{
        AllContestData=[];
        notifyListeners();
        print('Response: ${response.body}');
        return contestDataClass.data;
      }
    } else if (response.statusCode == 400) {
      print('Response: ${response.body}');
      GetContestDataClass upcomingMatch=GetContestDataClass.fromJson(jsonDecode(response.body));
      if (upcomingMatch.status == 0) {
        AllContestData=upcomingMatch.data!;
        notifyListeners();
        return upcomingMatch.data;
       } else{
        AllContestData=upcomingMatch.data!;
        notifyListeners();
        return upcomingMatch.data;
      }
    } else {
      throw Exception('Failed to load data. Status Code: ${response.statusCode}');
    }
  }

  Future<List<TeamDataAll>?> fetchUserTeamData(String matchId, String token) async {

    final url = 'https://admin.googly11.in/api/user_All_Contest_Data?match_id=$matchId';
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        });
      print('Error::::::::: ${response.statusCode}');
      print('Response::::::::: ${response.body}');
      if (response.statusCode == 200) {
        final contestDataResponse = UserAllTeamContestDataResponse.fromJson(json.decode(response.body));
        if (contestDataResponse.status == 1) {
          // all_unAnnouncedPlayer=[];
          _allTeamUserCreateData = contestDataResponse.data!;
          // for(int i=0; i<_allTeamUserCreateData.length; i++){
          //   for(int j=0; j<_allTeamUserCreateData[i].players!.length; j++){
          //     if(_allTeamUserCreateData[i].players![j].playerDetails!.isPlay == 0){
          //       all_unAnnouncedPlayer.add(_allTeamUserCreateData[i].players![j].playerDetails!.playerId.toString());
          //       print('data::hfjshf'+all_unAnnouncedPlayer.toString());
          //     }
          //   }
          // }
          Is_lineupOut =contestDataResponse.is_lineupOut;
          print("data::::::::::Wk_Keeper"+_allTeamUserCreateData.length.toString());
          notifyListeners(); // Notify listeners of the change
          return contestDataResponse.data;
        } else if (contestDataResponse.status == 0) {
          _allTeamUserCreateData = contestDataResponse.data!;
          notifyListeners(); // Notify listeners of the change
          return contestDataResponse.data;
        }
      } else if (response.statusCode == 404) {
        final contestDataResponse = UserAllTeamContestDataResponse.fromJson(json.decode(response.body));
        if (contestDataResponse.status == 0) {
          _allTeamUserCreateData = [];
          notifyListeners(); // Notify listeners of the change
          return contestDataResponse.data;
        }
      } else {
        // Handle other errors
        print('Error: ${response.statusCode}');
        print('Response: ${response.body}');
      }
    } catch (error) {
      // Handle exceptions
      print('Exception: $error');
    }
    return null;
  }
  Future<List<TeamDataAll>?> fetchUserTeamDataWithContest_Id(String matchId, String token,String Contest_Id) async {
    final url = 'https://admin.googly11.in/api/user_All_Contest_Data?match_id=$matchId&contestID=$Contest_Id';
    print("url:::::::"+url.toString());
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      print('Error::::::::: ${response.statusCode}');
      print('Response::::::::: ${response.body}');
      if (response.statusCode == 200) {
        final contestDataResponse = UserAllTeamContestDataResponse.fromJson(json.decode(response.body));
        if (contestDataResponse.status == 1) {
          _allTeamUserCreateDataContest_Id = contestDataResponse.data!;
          Is_lineupOut =contestDataResponse.is_lineupOut;
          print("data::::::::::Wk_Keeper::::::::::"+_allTeamUserCreateDataContest_Id.length.toString());
          notifyListeners(); // Notify listeners of the change
          return contestDataResponse.data;
        } else if (contestDataResponse.status == 0) {
          _allTeamUserCreateDataContest_Id = contestDataResponse.data!;
          notifyListeners(); // Notify listeners of the change
          return contestDataResponse.data;
        }
      } else if (response.statusCode == 404) {
        final contestDataResponse = UserAllTeamContestDataResponse.fromJson(json.decode(response.body));
        if (contestDataResponse.status == 0) {
          _allTeamUserCreateDataContest_Id = [];
          notifyListeners(); // Notify listeners of the change
          return contestDataResponse.data;
        }
      } else {
        // Handle other errors
        print('Error: ${response.statusCode}');
        print('Response: ${response.body}');
      }
    } catch (error) {
      // Handle exceptions
      print('Exception: $error');
    }
    return null;
  }
  Future<List<JoinContestData_>?> fetchData(String match_id,String token) async {
    print("match_id:::::::"+match_id+":::::"+token);
    final String apiUrl = "https://admin.googly11.in/api/user_get_all_join_Contest?match_id=$match_id";
    // print("Dataa:::::::::::::"+widget.match_id.toString());
    final response = await http.get(Uri.parse(apiUrl), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    print('Response: ${response.body}');
    print('Response: ${response.statusCode}');
    if (response.statusCode == 200) {
      JoinContestDataResponse contestDataClass = JoinContestDataResponse.fromJson(json.decode(response.body));
      if(contestDataClass.status==1){
        _allContestCreateData = contestDataClass.data!;
        notifyListeners();
        print('Response: ${response.body}');
        return contestDataClass.data;
      }else if(contestDataClass.status==0){
        _allContestCreateData=[];
        notifyListeners();
        print('Response: ${response.body}');
        return contestDataClass.data;
      }
    } else if (response.statusCode == 400) {
      print('Response: ${response.body}');
      JoinContestList contestDataClass = JoinContestList.fromJson(json.decode(response.body));
      if (contestDataClass.status == 0) {
        _allContestCreateData = [];
        notifyListeners();
        return contestDataClass.data;
      }
    }  else if (response.statusCode == 404) {
      final contestDataResponse = JoinContestList.fromJson(json.decode(response.body));
      if (contestDataResponse.status == 0) {
        _allContestCreateData = [];
        notifyListeners(); // Notify listeners of the change
        return contestDataResponse.data;
      }
    } else {
      throw Exception('Failed to load data. Status Code: ${response.statusCode}');
    }
    return null;
  }

  Future<List<All_Upi_Data>?> getUpiDetails(String token) async {
    try {
      final response = await http.get(
        Uri.parse("https://admin.googly11.in/api/get-upi-details"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        // Handle the successful response
        AllUpiDataResponse upiDataResponse =AllUpiDataResponse.fromJson(json.decode(response.body));
        if(upiDataResponse.status == 1){
         Upi_All_Data=upiDataResponse.data!;
          notifyListeners();
          return upiDataResponse.data;
        }else{
          Upi_All_Data = [];
          notifyListeners();
          return upiDataResponse.data;
        }
      }else if (response.statusCode == 404) {
        AllUpiDataResponse upiDataResponse =AllUpiDataResponse.fromJson(json.decode(response.body));
        if(upiDataResponse.status == 1){
          Upi_All_Data=upiDataResponse.data!;
          notifyListeners();
          return upiDataResponse.data;
        }else{
          Upi_All_Data = [];
          notifyListeners();
          return upiDataResponse.data;
        }
      } else {
        // Handle error
        print('Error: ${response.statusCode}');
        print('Error Body: ${response.body}');
      }
    } catch (error) {
      // Handle network errors or other exceptions
      print('Error: $error');
    }
    return null;
  }
  Future<List<BankAllData>?> getBankDetails(String token) async {
    try {
      final response = await http.get(
        Uri.parse("https://admin.googly11.in/api/user_bank_details_get"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        // Handle the successful response
        GetBankDetailsResponse upiDataResponse =GetBankDetailsResponse.fromJson(json.decode(response.body));
        if(upiDataResponse.status == 1){
          Bank_All_Data=upiDataResponse.data!;
          notifyListeners();
          return upiDataResponse.data;
        }else{
          Bank_All_Data = [];
          notifyListeners();
          return upiDataResponse.data;
        }
      }else if (response.statusCode == 404) {
        GetBankDetailsResponse upiDataResponse =GetBankDetailsResponse.fromJson(json.decode(response.body));
        if(upiDataResponse.status == 1){
          Bank_All_Data=upiDataResponse.data!;
          notifyListeners();
          return upiDataResponse.data;
        }else{
          Bank_All_Data = [];
          notifyListeners();
          return upiDataResponse.data;
        }
      } else {
        // Handle error
        print('Error: ${response.statusCode}');
        print('Error Body: ${response.body}');
      }
    } catch (error) {
      // Handle network errors or other exceptions
      print('Error: $error');
    }
    return null;
  }

}
