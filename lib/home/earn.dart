import 'dart:convert';
import 'package:bauntan/home/dash.dart';
import 'package:bauntan/home/person.dart';
import 'package:bauntan/home/sipport.dart';
import 'package:bauntan/home/trans.dart';
import 'package:bauntan/model/model.dart' hide copyText;
import 'package:bauntan/other/compo.dart';
import 'package:bauntan/other/drawer.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';

DateTime today = DateTime.now();

// For last 3 months
DateTime threeMonthsAgo = DateTime(today.year, today.month - 10, today.day);

// For last 6 months
DateTime sixMonthsAgo = DateTime(today.year, today.month - 6, today.day);

// Format to YYYY-MM-DD
String endDate =
    "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";
String startDate3 =
    "${threeMonthsAgo.year}-${threeMonthsAgo.month.toString().padLeft(2, '0')}-${threeMonthsAgo.day.toString().padLeft(2, '0')}";
String startDate6 =
    "${sixMonthsAgo.year}-${sixMonthsAgo.month.toString().padLeft(2, '0')}-${sixMonthsAgo.day.toString().padLeft(2, '0')}";

class EarningPage extends StatefulWidget {
  const EarningPage({super.key});

  @override
  State<EarningPage> createState() => _EarningPageState();
}

String startDate = startDate3;

class _EarningPageState extends State<EarningPage> {
  Map? Perfo;
  List<double> trafficData = [];
  List<double> earningsData = [];
  final TextEditingController ctl = TextEditingController();
  String chos = "3 Months";

  @override
  void initState() {
    super.initState();
    chos = "3 Months";
    updateDateRange("3M");
    // _getperf();
  }

  Future<void> _getperf() async {
    print(startDate);

    try {
      final res = await http.get(
        Uri.parse(
          "$BASE_URL/affiliate/performance-overview?startDate=${startDate}&endDate=${endDate}",
        ),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $userToken',
        },
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        Perfo = data;
        print(Perfo);

        trafficData = (data["data"]["traffic"]["monthly"] as List)
            .map<double>((e) => (e["count"] ?? 0).toDouble())
            .toList();

        earningsData = //[0, 992992];
        (data["data"]["earnings"]["monthly"] as List)
            .map<double>((e) => (e["amount"] ?? 0).toDouble())
            .toList();

        if (!mounted) return;
        msg = "data found!";

        setState(() {});
      } else {
        print("API Error: ${res.body}");
        if (!mounted) return;
        msg = "API Error!";

        setState(() {});
      }
    } catch (e) {
      print("Network Error: $e");
      if (!mounted) return;
      msg = "Network Error!";

      setState(() {});
    }
  }

  String selectedRange = "3M"; // default

  void updateDateRange(String range) {
    DateTime today = DateTime.now();
    DateTime start;

    if (range == "3M") {
      start = DateTime(today.year, today.month - 3, today.day);
    } else if (range == "6M") {
      start = DateTime(today.year, today.month - 6, today.day);
    } else if (range == "1Y") {
      start = DateTime(today.year - 1, today.month, today.day);
    } else {
      start = DateTime(today.year, today.month - 1, today.day);
    }

    startDate =
        "${start.year}-${start.month.toString().padLeft(2, '0')}-${start.day.toString().padLeft(2, '0')}";
    endDate =
        "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

    _getperf(); // re-fetch
  }

  String msg = "Loading";

  @override
  Widget build(BuildContext context) {
    // if (Perfo == null) {
    //   return Scaffold(
    //     backgroundColor: bg,
    //     appBar: _buildAppBar(),
    //     drawer: AppDrawer(page: 3),
    //     body:
    //   );
    // }

    return Scaffold(
      backgroundColor: bg,
      appBar: _buildAppBar(),
      drawer: AppDrawer(page: 3),

      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _headerSection(),
          SizedBox(height: 15),
          _linkSection(),
          SizedBox(height: 15),
          _actionButtons(),
          SizedBox(height: 15),
          (Perfo == null)
              ? Center(
                  child: Column(
                    children: [
                      Text(
                        msg,
                        style: TextStyle(
                          color: (msg == "Loading") ? Colors.green : Colors.red,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          _getperf();
                        },
                        icon: Icon(Icons.refresh),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    _buildStatCard(
                      title: "Traffic",
                      value: "${Perfo!["data"]["traffic"]["total"]}",
                      growth:
                          "${Perfo!["data"]["traffic"]["percentChange"] ?? 0}%",
                      chart: _buildTrafficChart(),
                    ),
                    SizedBox(height: 20),
                    _buildStatCard(
                      title: "Earning",
                      value: "₹${Perfo!["data"]["earnings"]["total"]}",
                      growth:
                          "${Perfo!["data"]["earnings"]["percentChange"] ?? 0}%",
                      chart: _buildEarningsChart(),
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      surfaceTintColor: Colors.white,
      title: Image.asset('assets/logo2.jpg', height: 40),
      backgroundColor: Colors.white,
      actions: [
        GestureDetector(
          onTap: () =>
              showDialog(context: context, builder: (_) => LogoutPage()),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue, width: 3),
              borderRadius: BorderRadius.circular(30),
            ),
            child: CircleAvatar(
              backgroundImage:
                  (Afpro != null && Afpro!['profile']?['media']?['url'] != null)
                  ? NetworkImage(Afpro!['profile']['media']['url'])
                        as ImageProvider
                  : AssetImage('assets/avatar.png'),
              radius: 15,
            ),
          ),
        ),
        SizedBox(width: 10),
      ],
    );
  }

  Widget _headerSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.all(13),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 200,
            child: Text(
              "Traffic and Earning overview",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
              maxLines: 5,
            ),
          ),
          DropdownButton<String>(
            value: chos,
            items: ["1 Month", "3 Months", "6 Months", "1 Year"]
                .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                .toList(),
            onChanged: (value) {
              if (value != null) {
                chos = value;

                print(startDate3);
                if (chos == "3 Months") {
                  updateDateRange("3M");
                } else if (chos == "6 Months") {
                  updateDateRange("6M");
                } else if (chos == "1 Year") {
                  updateDateRange("1Y");
                } else
                  updateDateRange("1M");
                // _getperf(); // Re-fetch data
                setState(() {});
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _linkSection() {
    return TextField(
      controller: ctl,
      readOnly: true,
      decoration: InputDecoration(
        hintText: (Stat == null || Stat["referralLink"] == null)
            ? "https://bounten.com/lakshit"
            : "${Stat["referralLink"]}",
        suffixIcon: IconButton(
          icon: Icon(Icons.qr_code, color: Colors.blue),
          onPressed: () {
            showDialog(context: context, builder: (_) => QrPage());
          },
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue),
        ),
        hintStyle: TextStyle(color: Colors.blue),
      ),
    );
  }

  Widget _actionButtons() {
    final referralLink = (Stat == null || Stat["referralLink"] == null)
        ? "https://bounten.com/lakshit"
        : "${Stat["referralLink"]}";

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _actionCard(
          onPressed: () => copyText(referralLink),
          icon: Icons.copy,
          text: 'Copy Link',
          backgroundColor: Colors.blue,
          textColor: Colors.white,
        ),
        _actionCard(
          onPressed: () => shareImageAndText(),
          icon: Icons.share_outlined,
          text: 'Share',
          backgroundColor: bg,
          textColor: Colors.blue,
          borderColor: adth,
        ),
      ],
    );
  }

  Widget _actionCard({
    required VoidCallback onPressed,
    required IconData icon,
    required String text,
    required Color backgroundColor,
    required Color textColor,
    Color? borderColor,
  }) {
    return Card(
      child: Container(
        width: 155,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: borderColor != null ? Border.all(color: borderColor) : null,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: MaterialButton(
            padding: EdgeInsets.all(15),
            color: backgroundColor,
            onPressed: onPressed,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: textColor),
                SizedBox(width: 8),
                Text(text, style: TextStyle(color: textColor)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String growth,
    required Widget chart,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 4),
          Row(
            children: [
              Text(
                value,
                style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 8),
              Text(growth, style: TextStyle(color: Colors.green)),
            ],
          ),
          SizedBox(height: 12),
          SizedBox(height: 300, child: chart),
        ],
      ),
    );
  }

  Widget _buildTrafficChart() {
    List months = (Perfo!["data"]["traffic"]["monthly"] as List)
        .map((e) => e["month"] ?? "")
        .toList();

    return LineChart(
      LineChartData(
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, _) {
                return Text(
                  (value.toInt() < months.length) ? months[value.toInt()] : '',
                  style: TextStyle(fontSize: 11),
                );
              },
            ),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: trafficData
                .asMap()
                .entries
                .map((e) => FlSpot(e.key.toDouble(), e.value))
                .toList(),
            color: Colors.blue,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.blue.withOpacity(0.2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEarningsChart() {
    List months = (Perfo!["data"]["earnings"]["monthly"] as List)
        .map((e) => e["month"] ?? "")
        .toList();

    return BarChart(
      BarChartData(
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, _) {
                return Text(
                  (value.toInt() < months.length) ? months[value.toInt()] : '',
                  style: TextStyle(fontSize: 11),
                );
              },
            ),
          ),
        ),
        barGroups: earningsData
            .asMap()
            .entries
            .map(
              (e) => BarChartGroupData(
                x: e.key,
                barRods: [
                  BarChartRodData(toY: e.value, width: 12, color: Colors.blue),
                ],
              ),
            )
            .toList(),
      ),
    );
  }
}

// import 'dart:convert';

// import 'package:bauntan/home/dash.dart';
// import 'package:bauntan/home/person.dart';
// import 'package:bauntan/home/sipport.dart';
// import 'package:bauntan/home/trans.dart';
// import 'package:bauntan/model/model.dart' hide copyText;
// import 'package:bauntan/other/compo.dart';
// import 'package:bauntan/other/drawer.dart';
// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:http/http.dart' as http;
// import 'package:share_plus/share_plus.dart';

// class EarningPage extends StatefulWidget {
//   const EarningPage({super.key});

//   @override
//   State<EarningPage> createState() => _EarningPageState();
// }

// class _EarningPageState extends State<EarningPage> {
//   Future<void> _getperf() async {
//     try {
//       final res = await http.get(
//         Uri.parse(
//           "${BASE_URL}/affiliate/performance-overview?startDate=2025-01-01&endDate=2025-07-16",
//         ),

//         headers: {
//           'Content-Type': 'application/json',
//           'Accept': 'application/json',
//           'Authorization': 'Bearer ${userToken}',
//         },
//       );

//       // https://bountenapi.socialseller.in/api/affiliate/transactions/37?pagination[page]=1&pagination[pageSize]=5

//       if (res.statusCode == 200) {
//         print(jsonDecode(res.body));

//         Perfo = jsonDecode(res.body);

//         g1 = true;

//         if (!mounted) return;

//         // if (g1 && g2 && g3) {
//         setState(() {});
//         // }
//       } else {
//         print("nndnndndnnd");
//       }
//     } catch (e) {
//       print(e);
//     }
//   }

//   List<double> trafficData = [];
//   List<double> earningsData = [];

//   String chos = "3 Months";

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();

//     _getperf();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: bg,
//       appBar: AppBar(
//         surfaceTintColor: Colors.white,
//         title: Image.asset('assets/logo2.jpg', height: 40),
//         backgroundColor: Colors.white,
//         actions: [
//           GestureDetector(
//             onTap: () {
//               showDialog(context: context, builder: (context) => LogoutPage());
//               // LogoutPage();
//             },
//             child: Container(
//               decoration: BoxDecoration(
//                 border: Border.all(
//                   color: const Color.from(
//                     alpha: 1,
//                     red: 0.416,
//                     green: 0.624,
//                     blue: 0.988,
//                   ),
//                   width: 3,
//                 ),
//                 borderRadius: BorderRadius.circular(30),
//               ),

//               child: CircleAvatar(
//                 backgroundImage: (Afpro != null)
//                     ? NetworkImage(Afpro['profile']['media']['url'])
//                     : AssetImage('assets/avatar.png'),
//                 radius: 15,
//               ),
//             ),
//           ),
//           SizedBox(width: 10),
//         ],
//       ),
//       drawer: AppDrawer(page: 3),
//       //   child: ListView(
//       //     padding: EdgeInsets.zero,
//       //     children: [
//       //       SizedBox(height: 70),
//       //       GestureDetector(
//       //         onTap: () {
//       //           Navigator.pop(context);
//       //         },
//       //         child: Row(
//       //           mainAxisAlignment: MainAxisAlignment.end,
//       //           children: [
//       //             Padding(
//       //               padding: const EdgeInsets.symmetric(horizontal: 30.0),
//       //               child: Icon(
//       //                 Icons.cancel,
//       //                 size: 30,
//       //                 color: const Color.fromARGB(255, 111, 110, 110),
//       //               ),
//       //             ),
//       //           ],
//       //         ),
//       //       ),
//       //       SizedBox(height: 10),
//       //       MaterialButton(
//       //         onPressed: () {
//       //           Navigator.pushAndRemoveUntil(
//       //             context,
//       //             MaterialPageRoute(builder: (context) => DashboardPage()),
//       //             (context) => false,
//       //           );
//       //         },
//       //         child: Container(
//       //           child: ListTile(
//       //             title: Row(
//       //               children: [
//       //                 (false)
//       //                     ? Icon(Icons.dashboard, color: Colors.blue)
//       //                     : Icon(Icons.dashboard_outlined),
//       //                 SizedBox(width: 10),
//       //                 Text(
//       //                   'Dashboard',
//       //                   style: TextStyle(
//       //                     fontWeight: FontWeight.bold,
//       //                     color: const Color.fromARGB(255, 111, 110, 110),
//       //                   ),
//       //                 ),
//       //               ],
//       //             ),
//       //           ),
//       //         ),
//       //       ),
//       //       MaterialButton(
//       //         onPressed: () {
//       //           Navigator.push(
//       //             context,
//       //             MaterialPageRoute(builder: (context) => PersonalInfoPage()),
//       //           );
//       //         },
//       //         child: ListTile(
//       //           title: Row(
//       //             children: [
//       //               (false)
//       //                   ? Icon(Icons.person_rounded, color: Colors.blue)
//       //                   : Icon(Icons.person_outline_rounded),
//       //               SizedBox(width: 10),
//       //               Text(
//       //                 'Profile',
//       //                 style: TextStyle(
//       //                   fontWeight: FontWeight.bold,
//       //                   color: const Color.fromARGB(255, 111, 110, 110),
//       //                 ),
//       //               ),
//       //             ],
//       //           ),
//       //         ),
//       //       ),
//       //       MaterialButton(
//       //         onPressed: () {
//       //           Navigator.push(
//       //             context,
//       //             MaterialPageRoute(builder: (context) => EarningPage()),
//       //           );
//       //         },
//       //         child: Container(
//       //           decoration: BoxDecoration(
//       //             color: const Color.fromARGB(255, 216, 240, 249),
//       //             borderRadius: BorderRadius.circular(12),
//       //           ),
//       //           child: ListTile(
//       //             title: Row(
//       //               children: [
//       //                 (true)
//       //                     ? Icon(Icons.local_activity, color: Colors.blue)
//       //                     : Icon(Icons.local_activity_outlined),
//       //                 SizedBox(width: 10),
//       //                 Text(
//       //                   'Performance',
//       //                   style: TextStyle(
//       //                     fontWeight: FontWeight.bold,
//       //                     color: Colors.blue,
//       //                   ),
//       //                 ),
//       //               ],
//       //             ),
//       //           ),
//       //         ),
//       //       ),
//       //       MaterialButton(
//       //         onPressed: () {
//       //           Navigator.push(
//       //             context,
//       //             MaterialPageRoute(
//       //               builder: (context) => TransactionHistoryPage(),
//       //             ),
//       //           );
//       //         },
//       //         child: ListTile(
//       //           title: Row(
//       //             children: [
//       //               (false)
//       //                   ? Icon(Icons.traffic_rounded, color: Colors.blue)
//       //                   : Icon(Icons.transform_outlined),
//       //               SizedBox(width: 10),
//       //               Text(
//       //                 'Transaction History',
//       //                 style: TextStyle(
//       //                   fontWeight: FontWeight.bold,
//       //                   color: const Color.fromARGB(255, 111, 110, 110),
//       //                 ),
//       //               ),
//       //             ],
//       //           ),
//       //         ),
//       //       ),
//       //       MaterialButton(
//       //         onPressed: () {
//       //           Navigator.push(
//       //             context,
//       //             MaterialPageRoute(builder: (context) => SupportTicketPage()),
//       //           );
//       //         },
//       //         child: ListTile(
//       //           title: Row(
//       //             children: [
//       //               (false)
//       //                   ? Icon(Icons.support_agent_rounded, color: Colors.blue)
//       //                   : Icon(Icons.support_agent_outlined),
//       //               SizedBox(width: 10),
//       //               Text(
//       //                 'Support',
//       //                 style: TextStyle(
//       //                   fontWeight: FontWeight.bold,
//       //                   color: const Color.fromARGB(255, 111, 110, 110),
//       //                 ),
//       //               ),
//       //             ],
//       //           ),
//       //         ),
//       //       ),
//       //     ],
//       //   ),
//       // ),
//       body: ListView(
//         padding: EdgeInsets.all(16),
//         children: [
//           Container(
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(10),
//             ),
//             padding: EdgeInsets.all(13),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 SizedBox(
//                   width: 200,
//                   child: Text(
//                     "Traffic and Earning overview",
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                     overflow: TextOverflow.ellipsis,
//                     maxLines: 5,
//                   ),
//                 ),
//                 DropdownButton<String>(
//                   value: chos,
//                   items: ["1 Month", "3 Months", "6 Months"]
//                       .map(
//                         (item) =>
//                             DropdownMenuItem(value: item, child: Text(item)),
//                       )
//                       .toList(),
//                   onChanged: (value) {
//                     chos = value.toString();
//                     setState(() {});
//                   },
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(height: 20),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: .0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: Container(
//                     decoration: BoxDecoration(
//                       // color: Colors.white,

//                       // borderRadius: BorderRadius.circular(15),
//                       // border: Border.all(color: Colors.blue),
//                     ),
//                     child: TextField(
//                       controller: ctl,
//                       readOnly: true,
//                       decoration: InputDecoration(
//                         hintText: (Stat == null || Stat["referralLink"] == null)
//                             ? "https://bounten.com/lakshit"
//                             : "${Stat["referralLink"]}",
//                         suffixIcon: IconButton(
//                           icon: Icon(Icons.qr_code, color: Colors.blue),
//                           onPressed: () {
//                             showDialog(
//                               context: context,
//                               builder: (context) => QrPage(),
//                             );
//                           },
//                         ),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: BorderSide(color: Colors.blue),
//                         ),
//                         hintStyle: TextStyle(color: Colors.blue),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(height: 15),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 0.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Card(
//                   child: Container(
//                     width: 155,
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(12),
//                       child: MaterialButton(
//                         color: Colors.blue,
//                         onPressed: () {
//                           copyText(
//                             (Stat == null || Stat["referralLink"] == null)
//                                 ? "https://bounten.com/lakshit"
//                                 : "${Stat["referralLink"]}",
//                           );
//                         },
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(Icons.copy, color: Colors.white),
//                             Padding(
//                               padding: const EdgeInsets.all(15.0),
//                               child: Text(
//                                 'Copy Link',
//                                 style: TextStyle(color: Colors.white),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Card(
//                   borderOnForeground: false,
//                   child: Container(
//                     width: 155,

//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(12),
//                       border: Border.all(color: adth),
//                     ),
//                     child: ClipRRect(
//                       borderRadius: BorderRadiusGeometry.circular(12),
//                       child: MaterialButton(
//                         // color: Colors.white,
//                         color: bg,
//                         onPressed: () {
//                           shareImageAndText();
//                         },
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(Icons.share_outlined, color: Colors.blue),
//                             Padding(
//                               padding: const EdgeInsets.all(15.0),
//                               child: Text(
//                                 'Share',
//                                 style: TextStyle(color: Colors.blue),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(height: 15),

//           // Traffic Chart
//           _buildStatCard(
//             title: "Traffic",
//             value: (Perfo != null)
//                 ? "${Perfo["data"]["traffic"]["total"]}"
//                 : "5,000",
//             growth: (Perfo != null)
//                 ? "${Perfo["data"]["traffic"]["percentChange"]}%"
//                 : "+1%",
//             chart: LineChart(
//               LineChartData(
//                 borderData: FlBorderData(show: false),
//                 titlesData: FlTitlesData(
//                   // leftTitles: AxisTitles(
//                   //   sideTitles: SideTitles(showTitles: true, reservedSize: 40),
//                   //   // axisNameSize: 10,
//                   // ),
//                   // rightTitles: AxisTitles(
//                   //   sideTitles: SideTitles(showTitles: false, reservedSize: 90),
//                   // ),
//                   bottomTitles: AxisTitles(
//                     sideTitles: SideTitles(
//                       showTitles: true,
//                       getTitlesWidget: (value, meta) {
//                         List xx = [];
//                         List<double> yy = [];

//                         for (
//                           int i = 0;
//                           i <
//                               ((Perfo != null)
//                                   ? Perfo["data"]["traffic"]["monthly"].length
//                                   : 0);
//                           i++
//                         ) {
//                           xx.add(
//                             Perfo["data"]["traffic"]["monthly"][i]["month"],
//                           );
//                           yy.add(
//                             (Perfo["data"]["traffic"]["monthly"][i]["count"] ??
//                                     0) *
//                                 1.0,
//                           );
//                         }

//                         trafficData = yy;

//                         final months = xx;

//                         if (value.toInt() >= 0 &&
//                             value.toInt() < months.length) {
//                           return Text(
//                             months[value.toInt()],
//                             style: TextStyle(fontSize: 11),
//                           );
//                         }
//                         return SizedBox.shrink();
//                       },
//                     ),
//                   ),
//                 ),
//                 lineBarsData: [
//                   LineChartBarData(
//                     // isCurved: true,
//                     spots: trafficData
//                         .asMap()
//                         .entries
//                         .map((e) => FlSpot(e.key.toDouble(), e.value))
//                         .toList(),
//                     color: Colors.blue,
//                     dotData: FlDotData(show: false),
//                     belowBarData: BarAreaData(
//                       show: true,
//                       color: Colors.blue.withOpacity(0.2),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           SizedBox(height: 20),

//           // Earning Chart
//           _buildStatCard(
//             title: "Earning",
//             value:
//                 '₹${(Perfo != null) ? "${Perfo["data"]["earnings"]["total"]}" : "7,23,234"}',
//             growth: "${Perfo["data"]["earnings"]["percentChange"] ?? 0}%",
//             chart: BarChart(
//               BarChartData(
//                 borderData: FlBorderData(show: false),
//                 titlesData: FlTitlesData(
//                   // leftTitles: AxisTitles(
//                   //   sideTitles: SideTitles(showTitles: true, reservedSize: 40),
//                   // ),
//                   // rightTitles: AxisTitles(
//                   //   sideTitles: SideTitles(showTitles: false, reservedSize: 40),
//                   // ),
//                   bottomTitles: AxisTitles(
//                     sideTitles: SideTitles(
//                       showTitles: true,
//                       getTitlesWidget: (value, meta) {
//                         List xx = [];
//                         List<double> yy = [];

//                         for (
//                           int i = 0;
//                           i <
//                               ((Perfo != null)
//                                   ? Perfo["data"]["earnings"]["monthly"].length
//                                   : 0);
//                           i++
//                         ) {
//                           xx.add(
//                             Perfo["data"]["earnings"]["monthly"][i]["month"],
//                           );
//                           yy.add(
//                             (Perfo["data"]["earnings"]["monthly"][i]["count"] ??
//                                     0) *
//                                 1.0,
//                           );
//                         }
//                         final months = xx;
//                         earningsData = yy;
//                         if (value.toInt() >= 0 &&
//                             value.toInt() < months.length) {
//                           return Text(
//                             months[value.toInt()],
//                             style: TextStyle(fontSize: 11),
//                           );
//                         }
//                         return SizedBox.shrink();
//                       },
//                     ),
//                   ),
//                 ),
//                 barGroups: earningsData
//                     .asMap()
//                     .entries
//                     .map(
//                       (e) => BarChartGroupData(
//                         x: e.key,
//                         barRods: [
//                           BarChartRodData(
//                             toY: e.value,
//                             width: 12,
//                             color: Colors.blue,
//                           ),
//                         ],
//                       ),
//                     )
//                     .toList(),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildStatCard({
//     required String title,
//     required String value,
//     required String growth,
//     required Widget chart,
//   }) {
//     return Container(
//       padding: EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             title,
//             style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
//           ),

//           SizedBox(height: 4),
//           Row(
//             children: [
//               Text(
//                 value,
//                 style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(width: 8),
//               Text(growth, style: TextStyle(color: Colors.green)),
//             ],
//           ),

//           SizedBox(height: 12),
//           SizedBox(height: 300, child: chart),
//         ],
//       ),
//     );
//   }
// }
