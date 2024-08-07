import 'package:flutter/material.dart';
import '../consts.dart';
import '../myWidgets.dart';
import 'package:intl/intl.dart';
import '../getIPOs.dart';
import '../theme.dart';
import 'package:provider/provider.dart';
import '../providers.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isDarkMode = ConstManager.dark;
  String selectedLanguage = ConstManager.userLang;
  String selectedMarket = ConstManager.market;
  bool settingsChanged = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(builder: (context, themeProvider, child) {
      return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: TheAppBar(
          title: "Settings",
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                if (settingsChanged == true ||
                    isDarkMode != ConstManager.dark) {
                  // show dialog
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Save Changes?'),
                          content: const Text(
                              'Do you want to save your changes before exiting?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Cancel',
                                  style: TextStyle(
                                    color: Color(0xFF3A5F9A),
                                  )),
                            ),
                            TextButton(
                              child: const Text('Save',
                                  style: TextStyle(
                                    color: Color(0xFF3A5F9A),
                                  )),
                              onPressed: () async {
                                ConstManager.saveSettings();
                                if (!isCookiesValid()) {
                                  await getCookies();
                                }

                                if (settingsChanged == true) {
                                  await fetchIPOs();
                                }
                                // update colors
                                themeProvider.makeDark(isDarkMode);
                                ConstManager.dark = isDarkMode;

                                // navigate to home and return (settingsChanged);
                                Navigator.of(context)
                                    .popUntil((route) => route.isFirst);
                              },
                            ),
                          ],
                        );
                      });
                } else {
                  Navigator.of(context).pop(settingsChanged);
                }
              }),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: themeProvider.isDarkMode
                  ? AppTheme.darkBackgroundGradient
                  : AppTheme.lightBackgroundGradient,
            ),
          ),
          child: SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildSettingsCard(
                  context,
                  title: 'Appearance',
                  children: [
                    _buildSwitchListTile(
                      context,
                      title: 'Dark Mode',
                      value: isDarkMode,
                      onChanged: (value) {
                        setState(() {
                          isDarkMode = value;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildSettingsCard(
                  context,
                  title: 'Language',
                  children: [
                    _buildDropdownListTile(
                      context,
                      title: 'Select Language',
                      value: selectedLanguage,
                      items: ['English', 'Arabic'],
                      onChanged: (value) {
                        setState(() {
                          settingsChanged = true;
                          selectedLanguage = value!;
                          ConstManager.userLang = value;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildSettingsCard(
                  context,
                  title: 'IPOs',
                  note:
                      "NOTE: These settings will reset each time you open the app",
                  children: [
                    _buildDropdownListTile(
                      context,
                      title: 'Market',
                      value: selectedMarket,
                      items: [
                        'All',
                        'Main Market',
                        'Nomu - Parallel Market',
                        'Sukuk'
                      ],
                      onChanged: (value) {
                        setState(() {
                          settingsChanged = true;
                          selectedMarket = value!;
                          ConstManager.market = value;
                        });
                      },
                    ),
                    _buildDatePickerListTile(
                      context,
                      title: 'From Date',
                      selectedDate: ConstManager.fromDate,
                      onDateChanged: (value) {
                        setState(() {
                          settingsChanged = true;
                          ConstManager.fromDate = value;
                        });
                      },
                    ),
                    _buildDatePickerListTile(
                      context,
                      title: 'To Date',
                      selectedDate: ConstManager.toDate,
                      onDateChanged: (value) {
                        setState(() {
                          settingsChanged = true;
                          ConstManager.toDate = value;
                        });
                      },
                      lastDate: DateTime.now().add(const Duration(days: 3650)),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                MyButton(
                  height: 70,
                  onPressed: () async {
                    ConstManager.saveSettings();
                    if (!isCookiesValid()) {
                      await getCookies();
                    }

                    if (settingsChanged == true) {
                      await fetchIPOs();
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          backgroundColor: const Color(0xFF4CAF50),
                          content: Text('Settings saved and IPOs updated',
                              style: Theme.of(context).textTheme.bodyMedium)),
                    );
                    // update colors
                    themeProvider.makeDark(isDarkMode);
                    ConstManager.dark = isDarkMode;

                    Navigator.of(context).pop(settingsChanged);
                  },
                  child: const Text(
                    'Save',
                    style: TextStyle(color: Colors.white, fontSize: 26),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildSettingsCard(BuildContext context,
      {required String title, String? note, required List<Widget> children}) {
    return Card(
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: note != null
                ? const EdgeInsets.fromLTRB(16, 16, 16, 4)
                : const EdgeInsets.all(16),
            child: Text(
              title,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          if (note != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: Text(
                note,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSwitchListTile(BuildContext context,
      {required String title,
      required bool value,
      required ValueChanged<bool> onChanged}) {
    return SwitchListTile(
      title: Text(title, style: Theme.of(context).textTheme.bodyMedium),
      value: value,
      onChanged: onChanged,
      activeColor: Theme.of(context).primaryColor,
    );
  }

  Widget _buildDropdownListTile(BuildContext context,
      {required String title,
      required String value,
      required List<String> items,
      required ValueChanged<String?> onChanged}) {
    return ListTile(
      title: Text(title, style: Theme.of(context).textTheme.bodyMedium),
      trailing: DropdownButton<String>(
        value: value,
        onChanged: onChanged,
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        dropdownColor: Theme.of(context).scaffoldBackgroundColor,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }

  Widget _buildDatePickerListTile(BuildContext context,
      {required String title,
      required DateTime selectedDate,
      required ValueChanged<DateTime> onDateChanged,
      DateTime? lastDate}) {
    return ListTile(
      title: Text(title, style: Theme.of(context).textTheme.bodyMedium),
      trailing: Text(
        DateFormat('yyyy-MM-dd').format(selectedDate),
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime(2000),
          lastDate: lastDate ?? DateTime.now(),
          builder: (BuildContext context, Widget? child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: Theme.of(context).colorScheme.copyWith(
                      primary: Theme.of(context).primaryColor,
                      onPrimary: Theme.of(context).colorScheme.onPrimary,
                    ),
                dialogTheme: DialogTheme(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              child: child!,
            );
          },
        );
        if (picked != null && picked != selectedDate) {
          onDateChanged(picked);
          setState(() {});
        }
      },
    );
  }
}
