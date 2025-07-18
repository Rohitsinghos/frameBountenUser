import 'dart:convert';

import 'package:bauntan/model/model.dart';
import 'package:bauntan/other/compo.dart';
import 'package:bauntan/other/drawer.dart';

// import 'package:bounten/model/appdata.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';

// Required for Clipboard

void copyText(String text) {
  Clipboard.setData(ClipboardData(text: text));
  print("✅ Text copied: $text");
}

Future<void> _shareImageAndText() async {
  // 1. Load image from assets or network (here: from assets)
  // final byteData = await rootBundle.load('assets/logo.jpg');

  // // 2. Save it to a temporary file
  // final tempDir = await getTemporaryDirectory();
  // final file = File('${tempDir.path}/shared_image.jpg');
  // await file.writeAsBytes(byteData.buffer.asUint8List());

  // 3. Share the image and text
  await Share.share(
    '${(Stat == null || Stat["referralLink"] == null) ? "https://bounten.com/lakshit" : "${Stat["referralLink"]}"}',
  );
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String load = "Loading";
  final List<Map<String, String>> leads = List.generate(
    10,
    (index) => {
      'name': 'Samuel Peterson',
      'product': 'Gadget Pro 2023',
      'quality': [
        'Poor',
        'High',
        'Low',
        'Poor',
        'Poor',
        'Poor',
        'Poor',
        'High',
        'Low',
        'Poor',
      ][index],
    },
  );

  int cp = 1;
  int mx = 1;

  List lead = [];

  Future<void> _getProfileData() async {
    try {
      if ((g1 && g2 && g3)) {
        return;
      }
      final res = await http.get(
        Uri.parse("${BASE_URL}/affiliate/profile"),

        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${userToken}',
        },
      );

      // https://bountenapi.socialseller.in/api/affiliate/transactions/37?pagination[page]=1&pagination[pageSize]=5

      if (res.statusCode == 200) {
        print(jsonDecode(res.body));

        Afpro = jsonDecode(res.body);

        g1 = true;

        if (!mounted) return;

        if (g1 && g2 && g3) {
          setState(() {});
        }
      } else {
        print("nndnndndnnd");
        load = "Something wrong with sever!";
        if (!mounted) return;

        setState(() {});
      }

      final res5 = await http.get(
        Uri.parse(
          "${BASE_URL}/affiliate/performance-overview?startDate=2025-06-16&endDate=2025-07-16",
        ),

        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${userToken}',
        },
      );

      // https://bountenapi.socialseller.in/api/affiliate/transactions/37?pagination[page]=1&pagination[pageSize]=5

      if (res5.statusCode == 200) {
        print(jsonDecode(res5.body));

        Perfo = jsonDecode(res5.body);
      } else {
        print("faillled");
        load = "Something wrong with sever!";
        if (!mounted) return;

        setState(() {});
      }

      final res4 = await http.get(
        Uri.parse(
          "${BASE_URL}/affiliate/transactions/37?pagination[page]=1&pagination[pageSize]=5",
        ),

        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${userToken}',
        },
      );

      // https://bountenapi.socialseller.in/api

      if (res4.statusCode == 200) {
        print(jsonDecode(res.body));

        Trans = jsonDecode(res4.body);
      } else {
        print("nndnndndnnd");
        load = "Something wrong with sever!";
        if (!mounted) return;

        setState(() {});
      }

      final res2 = await http.get(
        Uri.parse(
          "${BASE_URL}/affiliate/profile?pagination[page]=1&pagination[pageSize]=5",
        ),

        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${userToken}',
        },
      );

      if (res2.statusCode == 200) {
        print(jsonDecode(res2.body));

        Afpro5 = jsonDecode(res2.body);
        g2 = true;

        if (!mounted) return;

        if (g1 && g2 && g3) {
          setState(() {});
        }
      } else {
        print("nndnndndnnd");
        load = "Something wrong with sever!";
        if (!mounted) return;

        setState(() {});
      }

      final res3 = await http.get(
        Uri.parse("${BASE_URL}/affiliate/stats"),

        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${userToken}',
        },
      );

      if (res3.statusCode == 200) {
        print(jsonDecode(res3.body));

        Stat = jsonDecode(res3.body);

        g3 = true;

        ctl.text = (Stat == null || Stat["referralLink"] == null)
            ? 'https://bounten.com/lakshit'
            : "${Stat["referralLink"]}";

        if (!mounted) return;

        if (g1 && g2 && g3) {
          setState(() {});
        }
      } else {
        load = "Something wrong with sever!";
        if (!mounted) return;

        setState(() {});
        print("nndnndndnnd");
      }
    } catch (e) {
      print(e);
      load = "Internet not working!";
      if (!mounted) return;

      setState(() {});
    }
  }

  final _pickImage = null;

  // void _uploadPickedImage() async {
  //   final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
  //   if (picked != null) {
  //     File imageFile = File(picked.path);
  //     // _pickedImage = File(picked.path);
  //   }
  // }

  // Future<void> _showPickOptionsDialog() async {
  //   final isCamera = await showDialog<bool>(
  //     context: context,
  //     builder: (_) => AlertDialog(
  //       title: const Text('Select image source'),
  //       actions: [
  //         TextButton(
  //           child: const Text('Camera'),
  //           onPressed: () => Navigator.pop(context, true),
  //         ),
  //         TextButton(
  //           child: const Text('Gallery'),
  //           onPressed: () => Navigator.pop(context, false),
  //         ),
  //       ],
  //     ),
  //   );
  //   if (isCamera == null) return;
  //   _pickImage(isCamera ? ImageSource.camera : ImageSource.gallery);
  // }

  List tabst = ['All Leads', 'Hot', 'Warm', 'Cold', 'Sold', 'Rejected'];

  String selectedValue = 'Poor Quality';

  int tabb = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (!(g1 && g2 && g3)) {
      _getProfileData();
    }

    if (!mounted) return;
    setState(() {});
  }

  List leadData = [];

  Future<void> getleads() async {
    try {
      if ((g1 && g2 && g3)) {
        return;
      }
      final res = await http.get(
        Uri.parse(
          (tabb == 0)
              ? "${BASE_URL}/affiliate/profile"
              : "${BASE_URL}/affiliate/profile?pagination[page]=${cp}&pagination[pageSize]=10&status=${tabst[tabb]}",
        ),

        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${userToken}',
        },
      );

      // https://bountenapi.socialseller.in/api/affiliate/transactions/37?pagination[page]=1&pagination[pageSize]=5

      if (res.statusCode == 200) {
        print(jsonDecode(res.body));

        // leadData = jsonDecode(res.body)['profile']['leads'];

        Afpro = jsonDecode(res.body);

        // leadData =

        load = "User found!";
        // logi = true
        g1 = true;

        if (!mounted) return;

        if (g1 && g2 && g3) {
          setState(() {});
        }
      } else {
        print("nndnndndnnd");
        load = "Something wrong with sever!";
        if (!mounted) return;

        setState(() {});
      }
    } catch (e) {
      print(e);

      load = "Network error!";
      if (!mounted) return;

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (g1 && g2 && g3) {
      leadData = Afpro["leads"];
    }
    return WillPopScope(
      onWillPop: () async {
        // Show the confirmation dialog
        final shouldExit = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Exit App', style: TextStyle(color: adth)),
            content: Text('Do you want to exit the app?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text('Yes'),
              ),
            ],
          ),
        );
        // If the user confirmed, exit the app
        return shouldExit ?? false;
      },
      child: (!(g1 && g2 && g3))
          ? Scaffold(
              backgroundColor: bg,
              body: SafeArea(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,

                    children: [
                      Text(
                        load,
                        style: TextStyle(
                          fontSize: 16,
                          color: (load == "Loading")
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          load = "Loading";
                          setState(() {});
                          _getProfileData();
                        },
                        icon: Icon(Icons.refresh, color: Colors.blue),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : Scaffold(
              backgroundColor: bg,
              // backgroundColor: const Color.fromARGB(255, 238, 248, 252),
              appBar: AppBar(
                surfaceTintColor: Colors.white,
                title: Image.asset('assets/logo2.jpg', height: 40),
                backgroundColor: Colors.white,
                // leading: Builder(
                //   builder: (context) => IconButton(
                //     icon: Icon(Icons.menu),
                //     onPressed: () => Scaffold.of(context).openDrawer(),
                //   ),
                // ),
                actions: [
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => LogoutPage(),
                      );
                      // LogoutPage();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color.from(
                            alpha: 1,
                            red: 0.416,
                            green: 0.624,
                            blue: 0.988,
                          ),
                          width: 3,
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),

                      child: CircleAvatar(
                        backgroundImage:
                            (Afpro != null &&
                                Afpro!['profile']?['media']?['url'] != null)
                            ? NetworkImage(Afpro!['profile']['media']['url'])
                                  as ImageProvider
                            : AssetImage('assets/avatar.png'),
                        radius: 15,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                ],
              ),
              drawer: AppDrawer(page: 1),
              body: ListView(
                padding: EdgeInsets.symmetric(vertical: 10),
                children: [
                  Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      _buildStatCard(
                        "Total Traffic",
                        (Afpro == null ||
                                Afpro["stats"] == null ||
                                Afpro["stats"]["totalTraffic"] == null)
                            ? "15,678"
                            : "${Afpro["stats"]["totalTraffic"]}",
                        Icon(Icons.traffic, color: adthAccent),
                      ),
                      _buildStatCard(
                        "Total Leads",
                        (Afpro == null ||
                                Afpro["stats"] == null ||
                                Afpro["stats"]["totalLeads"] == null)
                            ? "15,678"
                            : "${Afpro["stats"]["totalLeads"]}",
                        Icon(Icons.group, color: adthAccent),
                      ),
                      _buildStatCard(
                        "Total Earnings",
                        "₹${(Afpro == null || Afpro["stats"] == null || Afpro["stats"]["totalEarnings"] == null) ? "15,678" : "${(Afpro["stats"]["totalEarnings"]).toInt()}"}",
                        Icon(Icons.account_balance_wallet, color: adthAccent),
                      ),
                      _buildStatCard(
                        "Pending Leads",
                        (Afpro == null ||
                                Afpro["stats"] == null ||
                                Afpro["stats"]["pendingLeadsCount"] == null)
                            ? "15,678"
                            : "${Afpro["stats"]["pendingLeadsCount"]}",
                        Icon(Icons.pending, color: adthAccent),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              // color: Colors.white,

                              // borderRadius: BorderRadius.circular(15),
                              // border: Border.all(color: adth),
                            ),
                            child: TextField(
                              controller: ctl,
                              readOnly: true,
                              style: TextStyle(color: Colors.blue),

                              decoration: InputDecoration(
                                hintText:
                                    (Stat == null ||
                                        Stat["referralLink"] == null)
                                    ? 'https://bounten.com/lakshit'
                                    : "${Stat["referralLink"]}",
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.qr_code, color: adth),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => QrPage(),
                                    );
                                  },
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),

                                  borderSide: BorderSide(color: adth),
                                ),
                                hintStyle: TextStyle(color: adth),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 15),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Card(
                          child: Container(
                            width: 160,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: MaterialButton(
                                color: adth,
                                onPressed: () {
                                  copyText(
                                    (Stat == null ||
                                            Stat["referralLink"] == null)
                                        ? 'https://bounten.com/lakshit'
                                        : "${Stat["referralLink"]}",
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.copy, color: Colors.white),
                                    Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Text(
                                        'Copy Link',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Card(
                          borderOnForeground: false,
                          child: Container(
                            width: 160,

                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: adth),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadiusGeometry.circular(12),
                              child: MaterialButton(
                                color: Colors.white,
                                onPressed: () {
                                  _shareImageAndText();
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.share_outlined, color: adth),
                                    Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Text(
                                        'Share',
                                        style: TextStyle(color: adth),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Leads Quality Analysis",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(255, 114, 114, 114),
                            ),
                          ),
                        ),

                        Container(
                          color: const Color.fromRGBO(255, 255, 255, 1),
                          child: Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: 40,
                                    child: Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: ListView.builder(
                                        itemCount: tabst.length,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (contex, index) => Container(
                                          margin: EdgeInsets.all(5),
                                          child: GestureDetector(
                                            onTap: () {
                                              tabb = index;
                                              g1 = false;
                                              setState(() {});

                                              getleads();
                                            },
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadiusGeometry.circular(
                                                    8,
                                                  ),

                                              child: Container(
                                                color: (index == tabb)
                                                    ? adth
                                                    : const Color.fromARGB(
                                                        255,
                                                        238,
                                                        248,
                                                        252,
                                                      ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 8.0,
                                                      ),
                                                  child: Center(
                                                    child: Text(
                                                      tabst[index],
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: (index != tabb)
                                                            ? adth
                                                            : Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                Table(
                                  border: TableBorder(
                                    horizontalInside: BorderSide(
                                      color: Colors.grey,
                                      width: 0.2,
                                    ),
                                  ),
                                  // defaultColumnWidth: ,
                                  columnWidths: const {
                                    // 0: FixedColumnWidth(190),
                                    1: FixedColumnWidth(80),
                                    2: FixedColumnWidth(80),
                                  },
                                  defaultVerticalAlignment:
                                      TableCellVerticalAlignment.middle,

                                  children: [
                                    TableRow(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(4),

                                          child: Text(
                                            textAlign: TextAlign.center,
                                            'Name',
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(4),
                                          child: Text(
                                            textAlign: TextAlign.center,
                                            'Location',
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(4),
                                          child: Text(
                                            textAlign: TextAlign.center,
                                            'Lead Quality Analysis',
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    // GridView.builder(gridDelegate: , itemBuilder: (context, index)=>Container()),
                                    for (
                                      int i = 0;
                                      i <
                                          ((Afpro == null && leadData == null)
                                              ? 0
                                              : leadData.length);
                                      i++
                                    )
                                      TableRow(
                                        children: [
                                          Container(
                                            height: 50,
                                            color: Colors.white,
                                            padding: EdgeInsets.all(4),
                                            child: Center(
                                              child: Text(
                                                leadData[i]["name"],
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            color: Colors.white,
                                            padding: EdgeInsets.all(4),
                                            child: Text(
                                              // overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.center,
                                              leadData[i]["location"],
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),

                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                    255,
                                                    238,
                                                    248,
                                                    252,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                padding: EdgeInsets.symmetric(
                                                  vertical: 5,
                                                  horizontal: 5,
                                                ),

                                                child: Center(
                                                  child: Text(
                                                    "${leadData[i]["status"]}",
                                                    style: TextStyle(
                                                      color: Colors.blue,
                                                    ),
                                                  ),

                                                  //  DropdownButton<String>(
                                                  //   // padding: EdgeInsets.symmetric(
                                                  //   //   horizontal: 5,
                                                  //   // ),
                                                  //   alignment: Alignment.center,

                                                  //   value: selectedValue,
                                                  //   icon: Icon(
                                                  //     Icons.arrow_drop_down,
                                                  //   ),
                                                  //   style: TextStyle(
                                                  //     color: Colors.black,
                                                  //     fontSize: 11,
                                                  //   ),
                                                  //   onChanged:
                                                  //       (String? newValue) {
                                                  //         setState(() {
                                                  //           selectedValue =
                                                  //               newValue!;
                                                  //         });
                                                  //       },
                                                  //   items:
                                                  //       <String>[
                                                  //         'High Quality',
                                                  //         'Low Quality',
                                                  //         'Poor Quality',
                                                  //         'Poori Quality',
                                                  //         // 'Mango',
                                                  //       ].map<
                                                  //         DropdownMenuItem<
                                                  //           String
                                                  //         >
                                                  //       >((String value) {
                                                  //         return DropdownMenuItem<
                                                  //           String
                                                  //         >(
                                                  //           value: value,
                                                  //           child: Text(value),
                                                  //         );
                                                  //       }).toList(),

                                                  // DropdownButton(
                                                  //   dropdownColor: const Color.fromARGB(
                                                  //     255,
                                                  //     238,
                                                  //     248,
                                                  //     252,
                                                  //   ),
                                                  //   iconEnabledColor: const Color.fromARGB(
                                                  //     255,
                                                  //     238,
                                                  //     248,
                                                  //     252,
                                                  //   ),
                                                  //   onChanged: (value) {
                                                  //     // butt = value.toString();
                                                  //   },
                                                  //   // value: lead,
                                                  //   items: [],
                                                  // child: Container(
                                                  //   color: const Color.fromARGB(
                                                  //     255,
                                                  //     238,
                                                  //     248,
                                                  //     252,
                                                  //   ),
                                                  //   padding: EdgeInsets.all(4),
                                                  //   child: Row(
                                                  //     children: [
                                                  //       Text(
                                                  //         // overflow: TextOverflow.ellipsis,
                                                  //         textAlign: TextAlign.center,
                                                  //         '${lead['quality']} Quality',
                                                  //         style: TextStyle(
                                                  //           fontSize: 11,
                                                  //           color: Colors.black,
                                                  //         ),
                                                  //       ),
                                                  //       Icon(Icons.arrow_drop_down),
                                                  //     ],
                                                  //   ),
                                                  // ),
                                                  // ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                  ],
                                ),

                                (leadData.length == 0)
                                    ? Column(
                                        children: [
                                          Divider(),
                                          Container(
                                            child: Center(
                                              child: Text(
                                                "No Data found",
                                                style: TextStyle(fontSize: 14),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 30),
                                        ],
                                      )
                                    : Text(""),


                                    (leadData.length == 0)
                                    ? Column(
                                        children: [
                                          // Divider(),
                                          IconButton(
                                            onPressed: (){
                                              if(cp <= 1){
                                                return;
                                              }
                                              cp--;
                                              setState({}),
                                            },
                                            Icon(Icons.next),
                                          ),
                                          Container(
                                            child: Center(
                                              child: Text(
                                                cp,
                                                style: TextStyle(fontSize: 14),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 30),
                                          IconButton(
                                            onPressed: (){
                                              if(cp >= mx){
                                                return;
                                              }
                                              cp++;
                                              setState({}),
                                            },
                                            Icon(Icons.next),
                                          ),
                                        ],
                                      ): Text(""),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 40),
                ],
              ),
            ),
    );
  }

  Widget _buildStatCard(String title, String value, Icon Ico) {
    return Container(
      padding: EdgeInsets.all(2),
      child: Card(
        elevation: 2,
        color: Colors.white,
        child: Container(
          width: 160,
          height: 90,
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 100,
                    child: Text(
                      value,
                      style: TextStyle(
                        fontSize: 19,
                        color: adthAccent,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 230, 230, 252),
                      borderRadius: BorderRadius.circular(7),
                    ),

                    padding: EdgeInsets.all(3),
                    child: Ico,
                  ),
                ],
              ),
              Text(
                title,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
