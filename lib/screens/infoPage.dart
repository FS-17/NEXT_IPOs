import 'package:flutter/material.dart';
import '../consts.dart';
import '../myWidgets.dart';
import '../theme.dart';

class InfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: TheAppBar(
        title: "About",
        leading: IconButton(
          iconSize: 30,
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
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
        child: ListView(
          padding: EdgeInsets.fromLTRB(
              16, 99, 16, 40), // Adjusted top padding to match main page
          children: [
            _buildInfoCard(
              context,
              title: 'About NEXT IPO',
              content:
                  'NEXT IPO is an application designed to provide up-to-date information about upcoming Initial Public Offerings (IPOs) in the stock market. Stay informed about the latest investment opportunities with our comprehensive IPO listings.',
            ),
            SizedBox(height: 16),
            _buildInfoCard(
              context,
              title: 'Features',
              content:
                  '• View upcoming IPOs\n• Filter IPOs by market type\n• Set custom date ranges\n• Dark mode support\n• Multi-language support (coming soon)',
            ),
            SizedBox(height: 16),
            _buildInfoCard(
              context,
              title: 'How to Use',
              content:
                  '1. Browse the main screen to view upcoming IPOs\n2. Tap on an IPO card to view more details\n3. Use the settings page to customize your experience\n4. Adjust date ranges and market filters as needed',
            ),
            SizedBox(height: 16),
            _buildInfoCard(
              context,
              title: 'Contact Us',
              content:
                  'For support or feedback, please contact me at:\nFaisalsaweed@gmail.com',
            ),
            SizedBox(height: 16),
            _buildInfoCard(
              context,
              title: 'Version',
              content: 'NEXT IPO v1.0.0',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context,
      {required String title, required String content}) {
    return Card(
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: 8),
            Text(
              content,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
