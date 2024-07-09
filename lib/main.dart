import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'screens/settingsPage.dart';
import 'screens/infoPage.dart';
import 'myWidgets.dart';
import 'consts.dart';
import 'getIPOs.dart';
import 'theme.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await cashHelper.Init();
  ConstManager.getSettings();

  if (!isCookiesValid()) {
    await getCookies();
  }
  await fetchIPOs();

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(builder: (context, themeProvider, child) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'NEXT IPO',
        themeMode: ConstManager.dark ? ThemeMode.dark : ThemeMode.light,
        theme: themeProvider.currentTheme,
        home: IPOListScreen(),
      );
    });
  }
}

class IPOListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: TheAppBar(
        title: "NEXT IPO",
        actions: [
          IconButton(
            iconSize: 30,
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
          ),
          SizedBox(width: 4),
        ],
        leading: IconButton(
          iconSize: 30,
          icon: Icon(Icons.info_outline_rounded),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => InfoPage()),
            );
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: Theme.of(context).brightness == Brightness.light
                ? AppTheme.lightBackgroundGradient
                : AppTheme.darkBackgroundGradient,
          ),
        ),
        child: MasonryGridView.count(
          crossAxisCount: ConstManager.ipoList.length > 2 ? 2 : 1,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          padding: EdgeInsets.fromLTRB(10, 99, 10, 40),
          itemCount: ConstManager.ipoList.length,
          itemBuilder: (context, index) {
            return IPOCard(ipo: ConstManager.ipoList[index], index: index);
          },
        ),
      ),
    );
  }
}

class IPOCard extends StatefulWidget {
  final Map<String, dynamic> ipo;
  final int index;

  IPOCard({required this.ipo, required this.index});

  @override
  _IPOCardState createState() => _IPOCardState();
}

class _IPOCardState extends State<IPOCard> {
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    isExpanded = extendIndex == widget.index;
  }

  // final Map<String, dynamic> ipo;
  // final index;

  // IPOCard({required this.ipo,this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isExpanded) {
            extendIndex = null;
            isExpanded = false;
          } else {
            extendIndex = widget.index;
            isExpanded = true;
          }
        });
        // widget.onTap();
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        // height: isExpanded ? 300 : 180, // Adjust these values as needed
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),
          // color: ColorManager.ipoCardBackgroundGradient,
          margin: EdgeInsets.all(4),
          child: Container(
            // height: 50,
            // width: 150,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(4.0),
              gradient: LinearGradient(
                colors: Theme.of(context).brightness == Brightness.light
                    ? AppTheme.lightipoCardBackgroundGradient
                    : AppTheme.darkipoCardBackgroundGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Container(
              child: //declare your widget here
                  Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.ipo['companyName'],
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .color),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    if (widget.ipo['ipoId'] != null &&
                        widget.ipo['ipoId'] != '-')
                      Text('IPO ID: ${widget.ipo['ipoId']}',
                          style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodySmall!.color,
                              fontSize: 12)),
                    SizedBox(height: 8),
                    if (widget.ipo['issueprice'] != null &&
                        widget.ipo['issueprice'] != '-')
                      _buildInfoItem(Icons.event, 'Offering Price',
                          widget.ipo['issueprice']),
                    if (widget.ipo['offeringDate'] != null &&
                        widget.ipo['offeringDate'] != '-')
                      _buildInfoItem(Icons.calendar_today, 'Offering Date',
                          widget.ipo['offeringDate']),
                    if (widget.ipo['closingDate'] != null &&
                        widget.ipo['closingDate'] != '-')
                      _buildInfoItem(Icons.event, 'Closing Date',
                          widget.ipo['closingDate']),
                    if (isExpanded) ...[
                      if (widget.ipo['Capital'] != null &&
                          widget.ipo['Capital'] != '-')
                        _buildInfoItem(Icons.attach_money, 'Capital',
                            widget.ipo['capital']),
                      if (widget.ipo['sharesOffer'] != null &&
                          widget.ipo['sharesOffer'] != '-')
                        _buildInfoItem(Icons.show_chart, 'Shares Offer',
                            widget.ipo['sharesOffer']),
                      if (widget.ipo['persharesOffer'] != null &&
                          widget.ipo['persharesOffer'] != '-')
                        _buildInfoItem(Icons.percent, 'Offer %',
                            widget.ipo['persharesOffer']),
                      if (widget.ipo['marketType'] != null &&
                          widget.ipo['marketType'] != '-')
                        _buildInfoItem(
                            Icons.business, 'Market', widget.ipo['marketType']),
                    ],
                    SizedBox(height: 4),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    if (value == "") {
      return Container();
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.secondary, size: 16),
          SizedBox(width: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontSize: 12, color: Colors.grey)),
                Text(value,
                    style: TextStyle(
                        fontSize: 15,
                        color: Theme.of(context).textTheme.bodySmall!.color,
                        fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
