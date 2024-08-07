import 'package:flutter/material.dart';
import '../myWidgets.dart';
import '../theme.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter/services.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: TheAppBar(
        title: "About",
        leading: IconButton(
          iconSize: 30,
          icon: const Icon(Icons.arrow_back),
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
          padding: const EdgeInsets.fromLTRB(
              16, 99, 16, 40), // Adjusted top padding to match main page
          children: [
            _buildInfoCard(
              context,
              title: 'About NEXT IPO',
              content:
                  'NEXT IPO is an application designed to provide up-to-date information about upcoming Initial Public Offerings (IPOs) in the stock market. Stay informed about the latest investment opportunities with our comprehensive IPO listings.',
            ),
            const SizedBox(height: 16),
            _buildInfoCard(
              context,
              title: 'Features',
              content:
                  '• View upcoming IPOs\n• Filter IPOs by market type\n• Set custom date ranges\n• Dark mode support\n• Multi-language support (coming soon)',
            ),
            const SizedBox(height: 16),
            _buildInfoCard(
              context,
              title: 'How to Use',
              content:
                  '1. Browse the main screen to view upcoming IPOs\n2. Tap on an IPO card to view more details\n3. Use the settings page to customize your experience\n4. Adjust date ranges and market filters as needed',
            ),
            const SizedBox(height: 16),
            _buildInfoCard(
              context,
              title: 'Contact Us',
              content:
                  'For support or feedback, please contact me at:\nFaisalsaweed@gmail.com',
            ),
            // privacy policy

            const SizedBox(height: 16),
            _buildInfoCard(
              context,
              title: 'Privacy Policy',
              child: MyButton(
                height: 43,
                width: double.infinity,
                onPressed: () => _showPrivacyPolicyDialog(context),
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColor,
                ],
                child: Text(
                  'Read Privacy Policy',
                  style: TextStyle(color: Theme.of(context).cardColor),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoCard(
              context,
              title: 'Version',
              content: 'NEXT IPO v1.1.0',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context,
      {required String title, String? content, Widget? child}) {
    return Card(
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            if (content != null)
              Text(
                content,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            if (child != null) child,
          ],
        ),
      ),
    );
  }

  void _showPrivacyPolicyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: Theme.of(context).cardColor,
          child: Column(
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: Text(
                  "Privacy Policy",
                  style: TextStyle(
                    color: Theme.of(context).iconTheme.color,
                  ),
                ),
                leading: IconButton(
                  icon: Icon(Icons.close,
                      color: Theme.of(context).iconTheme.color),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              Expanded(
                child: FutureBuilder(
                  future: rootBundle.loadString('assets/pp.md'),
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                    if (snapshot.hasData) {
                      return Markdown(
                        data: snapshot.data!,
                        styleSheet: MarkdownStyleSheet(
                          p: TextStyle(
                              color: Theme.of(context).iconTheme.color),
                          h1: TextStyle(
                              color: Theme.of(context).iconTheme.color),
                          h2: TextStyle(
                              color: Theme.of(context).iconTheme.color),
                          // Add more text styles as needed
                        ),
                      );
                    } else if (snapshot.hasError) {
                      print(snapshot.error);
                      return const Center(
                          child: Text('Error loading privacy policy'));
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
