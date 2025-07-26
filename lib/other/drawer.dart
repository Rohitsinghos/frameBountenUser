import 'package:bauntan/home/dash.dart';
import 'package:flutter/material.dart';
import 'package:bauntan/home/earn.dart';
import 'package:bauntan/home/person.dart';
import 'package:bauntan/home/sipport.dart';
import 'package:bauntan/home/trans.dart';
import 'package:bauntan/model/model.dart';

class AppDrawer extends StatelessWidget {
  final int page;
  AppDrawer({required this.page});

  TextStyle txs(int pg) {
    if (pg == page) {
      return TextStyle(fontWeight: FontWeight.bold, color: adth);
    }
    return TextStyle(
      fontWeight: FontWeight.bold,
      color: const Color.fromARGB(255, 111, 110, 110),
    );
  }

  BoxDecoration gbox(int pg) {
    return (page == pg)
        ? BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12))
        : BoxDecoration();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.all(15),
        children: [
          SizedBox(height: 100),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Icon(
                    Icons.cancel,
                    size: 30,
                    color: Colors
                        .blue, // const Color.fromARGB(255, 111, 110, 110),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              if (page == 1) {
                Navigator.pop(context);
              } else {
                Navigator.pop(context);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => DashboardPage()),
                  (conext) => false,
                );
              }
            },
            child: Container(
              decoration: gbox(1),
              child: ListTile(
                title: Row(
                  children: [
                    (page == 1)
                        ? Icon(Icons.dashboard, color: adth)
                        : Icon(Icons.dashboard_outlined),
                    SizedBox(width: 10),
                    Text('Dashboard', style: txs(1)),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 5),
          GestureDetector(
            onTap: () {
              if (page == 2) {
                Navigator.pop(context);
              } else {
                Navigator.pop(context);

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PersonalInfoPage()),
                );
              }
            },
            child: Container(
              decoration: gbox(2),
              child: ListTile(
                title: Row(
                  children: [
                    (page == 2)
                        ? Icon(Icons.account_circle, color: adth)
                        : Icon(Icons.account_circle_outlined),
                    SizedBox(width: 10),
                    Text('Profile', style: txs(2)),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 5),
          GestureDetector(
            onTap: () {
              if (page == 3) {
                Navigator.pop(context);
              } else {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EarningPage()),
                );
              }
            },
            child: Container(
              decoration: gbox(3),
              child: ListTile(
                title: Row(
                  children: [
                    (page == 3)
                        ? Icon(Icons.bar_chart, color: adth)
                        : Icon(Icons.bar_chart_outlined),
                    SizedBox(width: 10),
                    Text('Performance', style: txs(3)),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 5),
          GestureDetector(
            onTap: () {
              if (page == 4) {
                Navigator.pop(context);
              } else {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TransactionHistoryPage(),
                  ),
                );
              }
            },
            child: Container(
              decoration: gbox(4),
              child: ListTile(
                title: Row(
                  children: [
                    (page == 4)
                        ? Icon(Icons.transform, color: adth)
                        : Icon(Icons.transform_outlined),
                    SizedBox(width: 10),
                    Text('Transaction History', style: txs(4)),
                  ],
                ),
              ),
            ),
          ),
          // GestureDetector(
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => SupportTicketPage()),
          //     );
          //   },
          //   child: Container(
          //     decoration: gbox(5),
          //     child: ListTile(
          //       title: Row(
          //         children: [
          //           (page == 5)
          //               ? Icon(Icons.support_agent_rounded, color: adth)
          //               : Icon(Icons.support_agent_outlined),
          //           SizedBox(width: 10),
          //           Text('Support', style: txs(5)),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
