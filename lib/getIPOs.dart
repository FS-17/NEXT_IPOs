// import 'dart:ffi';

// import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'consts.dart';

var url =
    'https://www.saudiexchange.sa/wps/portal/saudiexchange/listing/ipos?locale=en';

var preurl = "https://www.saudiexchange.sa"; //real
var endurl =
    "/p0/IZ7_5A602H80OOMQC0604RU6VD10F0=CZ6_5A602H80OO5JC0QFMU3NNK3852=NJgetALLListingDataId=/";

// Alahli Capital, Al Rajhi Financial Company, Saudi Fransi Capital, Alinma Investment, Riyad Capital, Al Jazira Financial Markets Company, Investment Securities and Brokerage Company, Al Bilad Investment Company, Al-Arabi Financial Company, Al Awal Investment Company, Derayah Financial Company, yaqeen Capital, Alkhabeer Financial Company.
Map<String, String> banks = {
  "alahli": "assets/banks/snb.jpg",
  "rajhi": "assets/banks/alr.jpg",
  "fransi": "assets/banks/bsf.jpg",
  "alinma": "assets/banks/ali.jpg",
  "riyad": "assets/banks/rib.jpg",
  "jazira": "assets/banks/alj.jpg",
  "bilad": "assets/banks/alb.jpg",
  "arabi": "assets/banks/anb.jpg",
  "awal": "assets/banks/sab.jpg",
  "snb": "assets/banks/snb.jpg",
  "anb": "assets/banks/anb.jpg",
  "arab": "assets/banks/anb.jpg",
};

void main() async {
  try {
    await getCookies();
    await fetchIPOs();
  } catch (e) {
    print('Error: $e');
  }
}

Future<void> fetchIPOs() async {
  try {
    final response = await http.post(
      Uri.parse(ConstManager.fullUrl),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'User-Agent':
            'Mozilla/5.0 (iPhone; CPU iPhone OS 16_5_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.1 Mobile/15E148 Safari/605.1.15', // Example iOS user-agent
        'Accept': 'application/json, text/html', // Accept JSON primarily
        'Accept-Language': 'en-US,en;q=0.9', // Language preference
        'Cookie': ConstManager.fullCookie,
      },
      body: {
        'listedType': 'ALL',
        'market': ConstManager.market == "All" ? "" : ConstManager.market[0],
        'instrument': '',
        'fromDate': fixDate(ConstManager.fromDate),
        'toDate': fixDate(ConstManager.toDate),
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body); // Adjust the key as needed

      if (data.isNotEmpty) {
        // ConstManager.ipoList = data["ipoData"] + data["tradableData"];

        ConstManager.ipoList = linkImages(reFormat(data));
        print("done");
      } else {
        ConstManager.ipoList = [
          {"companyName": "No IPOs found"}
        ];
      }
    } else {
      throw Exception('Failed to load IPO data');
    }
  } catch (e) {
    print('Error: $e');
    ConstManager.ipoList = [
      {"companyName": "No IPOs found"}
    ];
  }
}

Future<void> getCookies() async {
  final response = await http.get(Uri.parse(url), headers: {
    'User-Agent':
        'Mozilla/5.0 (iPhone; CPU iPhone OS 16_5_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.1 Mobile/15E148 Safari/605.1.15', // Example iOS user-agent
    'Accept': 'application/json, text/html', // Accept JSON primarily
    'Accept-Language': 'en-US,en;q=0.9', // Language preference
  });

  if (response.statusCode == 200) {
    final headers = response.headers;

    final cookies = headers['set-cookie'];
    if (cookies == null) {
      // throw Exception('No cookies found');
      print('No cookies found');
      return;
    }

    final expire = headers["expires"].toString().split(', ')[1];

    final sapool =
        ".sa_pool=" + cookies.toString().split('.sa_pool=')[1].split(';')[0];
    final token = cookies.toString().split(' Secure,')[1].split(';')[0];
    var conLoc = (headers["content-location"].toString().split("/"))
        .sublist(0, 10)
        .join("/");
    final fullCookie =
        "BIGipServerSaudiExchange.sa.app~SaudiExchange$sapool; com.ibm.wps.state.preprocessors.locale.LanguageCookie=en; $token;";

    ConstManager.fullCookie = fullCookie;
    ConstManager.fullUrl = preurl + conLoc + endurl;

    ConstManager.lastTimeGetCookies =
        DateFormat("dd MMM yyyy HH:mm:ss 'GMT'").parse(expire);

    var timeoffset = DateTime.now().timeZoneOffset;
    ConstManager.lastTimeGetCookies =
        ConstManager.lastTimeGetCookies.add(timeoffset);

    ConstManager.saveSettings();
  } else {
    throw Exception('Failed to get cookies from: $url');
  }
}

String fixDate(iDate) {
  return DateFormat('dd/MM/yyyy').format(iDate);
}

bool isCookiesValid() {
  /// check if the cookies are expired or not
  /// if the cookies are expired return false
  /// if everything is ok return true

  if (DateTime.now().isAfter(ConstManager.lastTimeGetCookies) ||
      ConstManager.fullCookie == "" ||
      ConstManager.fullUrl == "") {
    return false;
  }
  return true;
}

List<dynamic> reFormat(dynamic data) {
  if (data["tradableData"].isNotEmpty) {
    var tradableData = data["tradableData"];
    tradableData.forEach((element) {
      // change the key named offerPrice to {
      element["issueprice"] = element["offerPrice"];
      element["ipoId"] = element["companyCode"];
      element["offeringDate"] = element["subscriptionFrom"];
      element["closingDate"] = element["subscriptionTo"];
      element["sharesOffer"] = element["offerSize"];
    });
  }

  return (data["ipoData"] + data["tradableData"]);
}

dynamic linkImages(dynamic ipoList) {
  // it will add images of banks to the rcvBank ke

  for (var element in ipoList) {
    // if there is element["rcvBank"] and it is not empty
    var banksList;
    var newBanksList = [];

    // if there is no rcvBank key using containsKey
    if (!element.containsKey("rcvBank") ||
        element["rcvBank"] == null ||
        element["rcvBank"] == "") {
      // print("empty");
      newBanksList = [""];
    } else {
      if (element["rcvBank"] == "All Market Members") {
        newBanksList = ["all banks"];
      } else if (element["rcvBank"].contains(",")) {
        banksList = element["rcvBank"].split(", ");
      } else {
        banksList = [element["rcvBank"]];
      }

      for (var bank in banksList) {
        for (var key in banks.keys) {
          if (bank.toLowerCase().contains(key)) {
            newBanksList.add(banks[key]);
            break;
          }
        }
      }
      if (newBanksList.isEmpty) {
        newBanksList = [""];
      }
    }

    int ipoId = element["ipoId"] is int
        ? element["ipoId"]
        : int.parse(element["ipoId"].toString());

    ConstManager.banks[ipoId] = newBanksList;
  }

  return ipoList;
}
