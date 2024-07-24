// import 'package:flutter/material.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
//
// class InternetConnectivityScreen extends StatelessWidget {
//   const InternetConnectivityScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     Connectivity connectivity =Connectivity();
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Check connectivity"),
//       ),
//       body: StreamBuilder<ConnectivityResult>(
//         stream: connectivity.onConnectivityChanged,
//         builder: (_,snapshot){
//           return   InternetConnectionWidget(result: snapshot, widget: Center(child: Text('connected')));
//         },
//       ),
//     );
//   }
// }
//
//
// class InternetConnectionWidget extends StatelessWidget {
//   final   AsyncSnapshot<ConnectivityResult> result;
//   final Widget widget;
//   const InternetConnectionWidget({
//     super.key,
//     required this.result,
//     required this.widget});
//
//   @override
//   Widget build(BuildContext context) {
//      switch(result.connectionState){
//        case ConnectionState.active:
//          final state=result.data!;
//          switch(state){
//            case ConnectivityResult.none:
//              return Center(child: Text('No Internet'),);
//            default:
//              return widget;
//          }
//        default:
//          return Text('');
//      }
//   }
// }
