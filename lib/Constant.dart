import 'dart:ui';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:nexa/Widget/Btn.dart';
import 'package:nexa/Widget/Btn2.dart';
import 'package:permission_handler/permission_handler.dart';

import 'Model/CategoryModel.dart';
import 'Model/HomeModel.dart';

class Constant{
  static var token;
  static var firstName;
  static var lastName;
  static var country;
  static var countryCode;
  static var email;
  static var phone;
  static var image;
  static var deviceToken;
  static var loading;
  static var search;
  static var fcmToken;
  static var resendToken;
  static var publishableKey = 'pk_test_51Q7WwLJE1ERdWuZwRq3mLRDdPktYbVpnFpDWqJdY8EwTLfzqJ1Z3lo8AKGoFflkEQCSSE53P8gxd7j50kt418qEQ00ckzSwYiS';
  static var SecretKey = 'sk_test_51Q7WwLJE1ERdWuZwk9V9VjpmhqDLYdQxcdsWVtNZFHk1WaW5FzgoBGNx5XFMpTJmIU1bNZZw7yJCQuL4VXmSNK8d00D89r4GPv';
  static const Color bgOrange = Color(0xffFF8300);
  static const Color bgBlue = Color(0xffF3F5F9);
  static const Color bgOrangeLite = Color(0xffFFA31F);
  static const Color bgGrey = Color(0xff8F959E);
  static const Color textGrey = Color(0xFFB0B0B0);
  static const Color bgDivider = Color(0xffE2E2E2);
  static const Color bgTextField = Color(0xff494A54);
  static const Color bgLinearColor1 = Color(0xffFF8008);
  static const Color bgLinearColor2 = Color(0xffFFAF37);
  static const Color bgBtnGrey = Color(0xffE0E4EB);
  static const Color bgLiteGrey = Color(0xffF3F5F9);
  static const Color bgGreytile = Color(0xffF4F4F4);
  static const Color bgTextfieldHint = Color(0xffE0E0E0);
  static const Color bgWhite = Color(0xffffffff);
  static const Color bgRed = Color(0xffFF0000);

  static void showDialogProgress(BuildContext context) {

    showDialog(
      context: context,
      barrierDismissible: false, // Prevents dismissing the dialog by tapping outside
      builder: (context) => PopScope(
        canPop: false,
          child: AlertDialog(
              surfaceTintColor: Colors.transparent,
              backgroundColor: Colors.transparent,
              content: Center(
                child: LoadingAnimationWidget.fourRotatingDots(
                  color: Constant.bgOrangeLite,
                  size: 40,
                ),)
          ),
      )

    );
  }

  static Future<void> requestPermissions() async {
    final cameraStatus = await Permission.camera.status;

    if (!cameraStatus.isGranted) {
      await Permission.camera.request();
    }

    final galleryStatus13 = await Permission.photos.status;
    final galleryStatus12 = await Permission.storage.status;
    final deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;
    int sdkInt = androidInfo.version.sdkInt;

    if(sdkInt >= 33){
      if (galleryStatus13.isDenied) {
        if (Platform.isAndroid) {
          await Permission.photos.request();
        }  else if (Platform.isIOS) {
          await Permission.photos.request();
        } else {
          print("Platform not supported.");
          return;
        }
      }
    }else{
      if (galleryStatus12.isDenied) {
        if (Platform.isAndroid) {
          await Permission.storage.request();
        }else if (Platform.isIOS) {
          await Permission.photos.request();
        } else {
          print("Platform not supported.");
          return;
        }
      }
    }


  }

  static bool validatePhoneNumber(String phoneNumber, String countryCode) {
    Map<String, int> countryPhoneLengths = {
      'AF': 9, // Afghanistan
      'AL': 9, // Albania
      'DZ': 9, // Algeria
      'US': 10, // United States
      'AD': 6, // Andorra
      'AO': 9, // Angola
      'AR': 10, // Argentina
      'AM': 8, // Armenia
      'AU': 9, // Australia
      'AT': 10, // Austria
      'AZ': 9, // Azerbaijan
      'BH': 8, // Bahrain
      'BD': 10, // Bangladesh
      'BY': 9, // Belarus
      'BE': 9, // Belgium
      'BZ': 7, // Belize
      'BJ': 8, // Benin
      'BT': 8, // Bhutan
      'BO': 8, // Bolivia
      'BA': 8, // Bosnia and Herzegovina
      'BW': 7, // Botswana
      'BR': 11, // Brazil
      'BN': 7, // Brunei
      'BG': 9, // Bulgaria
      'BF': 8, // Burkina Faso
      'BI': 8, // Burundi
      'KH': 9, // Cambodia
      'CM': 9, // Cameroon
      'CA': 10, // Canada
      'CV': 7, // Cape Verde
      'CF': 8, // Central African Republic
      'TD': 8, // Chad
      'CL': 9, // Chile
      'CN': 11, // China
      'CO': 10, // Colombia
      'KM': 7, // Comoros
      'CG': 9, // Congo
      'CD': 9, // Congo, Democratic Republic of the
      'CK': 5, // Cook Islands
      'CR': 8, // Costa Rica
      'HR': 9, // Croatia
      'CU': 8, // Cuba
      'CY': 8, // Cyprus
      'CZ': 9, // Czech Republic
      'DK': 8, // Denmark
      'DJ': 6, // Djibouti
      'DM': 10, // Dominica
      'DO': 10, // Dominican Republic
      'EC': 9, // Ecuador
      'EG': 10, // Egypt
      'SV': 8, // El Salvador
      'GQ': 9, // Equatorial Guinea
      'ER': 7, // Eritrea
      'EE': 7, // Estonia
      'ET': 9, // Ethiopia
      'FJ': 7, // Fiji
      'FI': 10, // Finland
      'FR': 9, // France
      'GA': 7, // Gabon
      'GM': 7, // Gambia
      'GE': 9, // Georgia
      'DE': 10, // Germany
      'GH': 9, // Ghana
      'GR': 10, // Greece
      'GL': 6, // Greenland
      'GT': 8, // Guatemala
      'GN': 9, // Guinea
      'GW': 7, // Guinea-Bissau
      'GY': 7, // Guyana
      'HT': 8, // Haiti
      'HN': 8, // Honduras
      'HK': 8, // Hong Kong
      'HU': 9, // Hungary
      'IS': 7, // Iceland
      'IN': 10, // India
      'ID': 10, // Indonesia
      'IR': 10, // Iran
      'IQ': 10, // Iraq
      'IE': 9, // Ireland
      'IL': 9, // Israel
      'IT': 10, // Italy
      'CI': 8, // Ivory Coast
      'JM': 7, // Jamaica
      'JP': 10, // Japan
      'JO': 9, // Jordan
      'KZ': 10, // Kazakhstan
      'KE': 10, // Kenya
      'KI': 8, // Kiribati
      'KW': 8, // Kuwait
      'KG': 9, // Kyrgyzstan
      'LA': 9, // Laos
      'LV': 8, // Latvia
      'LB': 8, // Lebanon
      'LS': 8, // Lesotho
      'LR': 7, // Liberia
      'LY': 10, // Libya
      'LI': 7, // Liechtenstein
      'LT': 8, // Lithuania
      'LU': 9, // Luxembourg
      'MO': 8, // Macau
      'MK': 8, // Macedonia
      'MG': 9, // Madagascar
      'MW': 9, // Malawi
      'MY': 10, // Malaysia
      'MV': 7, // Maldives
      'ML': 8, // Mali
      'MT': 8, // Malta
      'MH': 7, // Marshall Islands
      'MR': 8, // Mauritania
      'MU': 8, // Mauritius
      'MX': 10, // Mexico
      'FM': 7, // Micronesia
      'MD': 8, // Moldova
      'MC': 8, // Monaco
      'MN': 8, // Mongolia
      'ME': 8, // Montenegro
      'MA': 9, // Morocco
      'MZ': 9, // Mozambique
      'MM': 9, // Myanmar
      'NA': 9, // Namibia
      'NR': 7, // Nauru
      'NP': 10, // Nepal
      'NL': 9, // Netherlands
      'NZ': 8, // New Zealand
      'NI': 8, // Nicaragua
      'NE': 8, // Niger
      'NG': 10, // Nigeria
      'NO': 8, // Norway
      'OM': 8, // Oman
      'PK': 10, // Pakistan
      'PW': 7, // Palau
      'PA': 8, // Panama
      'PG': 8, // Papua New Guinea
      'PY': 9, // Paraguay
      'PE': 9, // Peru
      'PH': 10, // Philippines
      'PL': 9, // Poland
      'PT': 9, // Portugal
      'QA': 8, // Qatar
      'RO': 10, // Romania
      'RU': 10, // Russia
      'RW': 9, // Rwanda
      'WS': 7, // Samoa
      'SM': 9, // San Marino
      'ST': 7, // Sao Tome and Principe
      'SA': 9, // Saudi Arabia
      'SN': 9, // Senegal
      'RS': 9, // Serbia
      'SC': 7, // Seychelles
      'SL': 8, // Sierra Leone
      'SG': 8, // Singapore
      'SK': 9, // Slovakia
      'SI': 9, // Slovenia
      'SB': 7, // Solomon Islands
      'SO': 7, // Somalia
      'ZA': 9, // South Africa
      'KR': 10, // South Korea
      'SS': 9, // South Sudan
      'ES': 9, // Spain
      'LK': 9, // Sri Lanka
      'SD': 9, // Sudan
      'SR': 7, // Suriname
      'SZ': 8, // Eswatini
      'SE': 9, // Sweden
      'CH': 9, // Switzerland
      'SY': 9, // Syria
      'TW': 9, // Taiwan
      'TJ': 9, // Tajikistan
      'TZ': 9, // Tanzania
      'TH': 9, // Thailand
      'TG': 8, // Togo
      'TO': 7, // Tonga
      'TN': 8, // Tunisia
      'TR': 10, // Turkey
      'TM': 8, // Turkmenistan
      'TV': 6, // Tuvalu
      'UG': 9, // Uganda
      'UA': 9, // Ukraine
      'AE': 9, // United Arab Emirates
      'GB': 10, // United Kingdom
      'UY': 9, // Uruguay
      'UZ': 9, // Uzbekistan
      'VU': 7, // Vanuatu
      'VE': 10, // Venezuela
      'VN': 9, // Vietnam
      'YE': 9, // Yemen
      'ZM': 9, // Zambia
      'ZW': 9 // Zimbabwe
    };

    int? expectedLength = countryPhoneLengths[countryCode];
    if (expectedLength != null) {
      return phoneNumber.length == expectedLength;
    }
    return false;
  }

  static bool validatePhoneNumberFromCode(String phoneNumber, String countryCode) {
    // Remove the '+' if present in the country code
    if (countryCode.startsWith('+')) {
      countryCode = countryCode.substring(1);
    }

    // Mapping country codes to expected phone number lengths
    Map<String, int> countryPhoneLengths = {
      '93': 9,   // Afghanistan
      '355': 9,  // Albania
      '213': 9,  // Algeria
      '1': 10,   // United States and Canada
      '376': 6,  // Andorra
      '244': 9,  // Angola
      '54': 10,  // Argentina
      '374': 8,  // Armenia
      '61': 9,   // Australia
      '43': 10,  // Austria
      '994': 9,  // Azerbaijan
      '973': 8,  // Bahrain
      '880': 10, // Bangladesh
      '375': 9,  // Belarus
      '32': 9,   // Belgium
      '501': 7,  // Belize
      '229': 8,  // Benin
      '975': 8,  // Bhutan
      '591': 8,  // Bolivia
      '387': 8,  // Bosnia and Herzegovina
      '267': 7,  // Botswana
      '55': 11,  // Brazil
      '673': 7,  // Brunei
      '359': 9,  // Bulgaria
      '226': 8,  // Burkina Faso
      '257': 8,  // Burundi
      '855': 9,  // Cambodia
      '237': 9,  // Cameroon
      '1': 10,   // Canada
      '238': 7,  // Cape Verde
      '236': 8,  // Central African Republic
      '235': 8,  // Chad
      '56': 9,   // Chile
      '86': 11,  // China
      '57': 10,  // Colombia
      '269': 7,  // Comoros
      '242': 9,  // Congo
      '243': 9,  // Congo, Democratic Republic of the
      '682': 5,  // Cook Islands
      '506': 8,  // Costa Rica
      '385': 9,  // Croatia
      '53': 8,   // Cuba
      '357': 8,  // Cyprus
      '420': 9,  // Czech Republic
      '45': 8,   // Denmark
      '253': 6,  // Djibouti
      '1': 10,   // Dominica
      '1': 10,   // Dominican Republic
      '593': 9,  // Ecuador
      '20': 10,  // Egypt
      '503': 8,  // El Salvador
      '240': 9,  // Equatorial Guinea
      '291': 7,  // Eritrea
      '372': 7,  // Estonia
      '251': 9,  // Ethiopia
      '679': 7,  // Fiji
      '358': 10, // Finland
      '33': 9,   // France
      '241': 7,  // Gabon
      '220': 7,  // Gambia
      '995': 9,  // Georgia
      '49': 10,  // Germany
      '233': 9,  // Ghana
      '30': 10,  // Greece
      '299': 6,  // Greenland
      '502': 8,  // Guatemala
      '224': 9,  // Guinea
      '245': 7,  // Guinea-Bissau
      '592': 7,  // Guyana
      '509': 8,  // Haiti
      '504': 8,  // Honduras
      '852': 8,  // Hong Kong
      '36': 9,   // Hungary
      '354': 7,  // Iceland
      '91': 10,  // India
      '62': 10,  // Indonesia
      '98': 10,  // Iran
      '964': 10, // Iraq
      '353': 9,  // Ireland
      '972': 9,  // Israel
      '39': 10,  // Italy
      '225': 8,  // Ivory Coast
      '1': 7,    // Jamaica
      '81': 10,  // Japan
      '962': 9,  // Jordan
      '7': 10,   // Kazakhstan
      '254': 10, // Kenya
      '686': 8,  // Kiribati
      '965': 8,  // Kuwait
      '996': 9,  // Kyrgyzstan
      '856': 9,  // Laos
      '371': 8,  // Latvia
      '961': 8,  // Lebanon
      '266': 8,  // Lesotho
      '231': 7,  // Liberia
      '218': 10, // Libya
      '423': 7,  // Liechtenstein
      '370': 8,  // Lithuania
      '352': 9,  // Luxembourg
      '853': 8,  // Macau
      '389': 8,  // Macedonia
      '261': 9,  // Madagascar
      '265': 9,  // Malawi
      '60': 10,  // Malaysia
      '960': 7,  // Maldives
      '223': 8,  // Mali
      '356': 8,  // Malta
      '692': 7,  // Marshall Islands
      '222': 8,  // Mauritania
      '230': 8,  // Mauritius
      '52': 10,  // Mexico
      '691': 7,  // Micronesia
      '373': 8,  // Moldova
      '377': 8,  // Monaco
      '976': 8,  // Mongolia
      '382': 8,  // Montenegro
      '212': 9,  // Morocco
      '258': 9,  // Mozambique
      '95': 9,   // Myanmar
      '264': 9,  // Namibia
      '674': 7,  // Nauru
      '977': 10, // Nepal
      '31': 9,   // Netherlands
      '64': 8,   // New Zealand
      '505': 8,  // Nicaragua
      '227': 8,  // Niger
      '234': 10, // Nigeria
      '47': 8,   // Norway
      '968': 8,  // Oman
      '92': 10,  // Pakistan
      '680': 7,  // Palau
      '507': 8,  // Panama
      '675': 8,  // Papua New Guinea
      '595': 9,  // Paraguay
      '51': 9,   // Peru
      '63': 10,  // Philippines
      '48': 9,   // Poland
      '351': 9,  // Portugal
      '974': 8,  // Qatar
      '40': 10,  // Romania
      '7': 10,   // Russia
      '250': 9,  // Rwanda
      '685': 7,  // Samoa
      '378': 9,  // San Marino
      '239': 7,  // Sao Tome and Principe
      '966': 9,  // Saudi Arabia
      '221': 9,  // Senegal
      '381': 9,  // Serbia
      '248': 7,  // Seychelles
      '232': 8,  // Sierra Leone
      '65': 8,   // Singapore
      '421': 9,  // Slovakia
      '386': 9,  // Slovenia
      '677': 7,  // Solomon Islands
      '252': 7,  // Somalia
      '27': 9,   // South Africa
      '82': 10,  // South Korea
      '211': 9,  // South Sudan
      '34': 9,   // Spain
      '94': 9,   // Sri Lanka
      '249': 9,  // Sudan
      '597': 7,  // Suriname
      '268': 8,  // Eswatini (Swaziland)
      '46': 9,   // Sweden
      '41': 9,   // Switzerland
      '963': 9,  // Syria
      '886': 9,  // Taiwan
      '992': 9,  // Tajikistan
      '255': 9,  // Tanzania
      '66': 9,   // Thailand
      '228': 8,  // Togo
      '676': 7,  // Tonga
      '216': 8,  // Tunisia
      '90': 10,  // Turkey
      '993': 8,  // Turkmenistan
      '688': 6,  // Tuvalu
      '256': 9,  // Uganda
      '380': 9,  // Ukraine
      '971': 9,  // United Arab Emirates
      '44': 10,  // United Kingdom
      '598': 9,  // Uruguay
      '998': 9,  // Uzbekistan
      '678': 7,  // Vanuatu
      '58': 10,  // Venezuela
      '84': 9,   // Vietnam
      '967': 9,  // Yemen
      '260': 9,  // Zambia
      '263': 9   // Zimbabwe
    };

    // Check if the phone number starts with the country code
    if (phoneNumber.startsWith(countryCode)) {
      // Remove the country code from the phone number
      phoneNumber = phoneNumber.substring(countryCode.length);
    }

    // Get the expected phone number length for the given country
    int? expectedLength = countryPhoneLengths[countryCode];

    // If expectedLength is available, validate the phone number length
    if (expectedLength != null) {
      return phoneNumber.length == expectedLength;
    }

    // If country code is not found in the map, return false
    return false;
  }


  static String getCountryCodeFromName(String countryName) {
    return countryNameToCode[countryName] ?? '';
  }

  static void customDialog(BuildContext context, String title, String content, String btn1, String btn2, VoidCallback callback){
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return SizedBox(
          height: 100,
          child: AlertDialog(
            insetPadding: EdgeInsets.symmetric(horizontal: 20, vertical: MediaQuery.of(context).size.height*.35),
            // contentPadding: EdgeInsets.symmetric(horizontal: 20),
            title: Center(child: Text(title, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22,),)),
            content: Center(child: Text(content, style: TextStyle(
              /*fontFamily: 'Gilroy-Medium',*/fontWeight: FontWeight.w400, fontSize: 14, color: Colors.grey),)),
            actions: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        // onTap: (){
                        //   Navigator.pop(context);
                        // },
                          child: Btn2(height: 50, width: MediaQuery.of(context).size.width,
                              name: 'Cancel', callBack: (){
                                Navigator.pop(context);
                              })
                        /*Container(
                          height: 60,
                          padding: EdgeInsets.symmetric(horizontal: 30, *//*vertical: 20*//*),

                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: bgOrangeLite, width: 1)
                          ),
                          child: Center(
                            child: Text('Cancel', style: TextStyle(color: bgOrangeLite,
                                fontWeight: FontWeight.w600, fontSize: 18),),
                          ),
                        ),*/
                      ),
                    ),
                    SizedBox(width: 10,),
                    Expanded(
                      child: InkWell(
                        // onTap: callback,
                          child: Btn('', height: 50, width: MediaQuery.of(context).size.width,
                              linearColor1: bgLinearColor1,
                              linearColor2: bgLinearColor2, name: 'Confirm', callBack: callback)
                        /*Container(
                          height: 60,
                          padding: EdgeInsets.symmetric(horizontal: 30, *//*vertical: 20*//*),
                          decoration: BoxDecoration(
                              color: bgOrangeLite,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: bgOrangeLite, width: 1)
                          ),
                          child: const Center(
                            child: Text('Confirm', style: TextStyle(color: Colors.white,
                                fontWeight: FontWeight.w600, fontSize: 18)),
                          ),
                        ),*/
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },);

  }


  static Map<String, String> countryNameToCode = {
    'Afghanistan': 'AF',
    'Albania': 'AL',
    'Algeria': 'DZ',
    'United States': 'US',
    'Andorra': 'AD',
    'Angola': 'AO',
    'Argentina': 'AR',
    'Armenia': 'AM',
    'Australia': 'AU',
    'Austria': 'AT',
    'Azerbaijan': 'AZ',
    'Bahrain': 'BH',
    'Bangladesh': 'BD',
    'Belarus': 'BY',
    'Belgium': 'BE',
    'Belize': 'BZ',
    'Benin': 'BJ',
    'Bhutan': 'BT',
    'Bolivia': 'BO',
    'Bosnia and Herzegovina': 'BA',
    'Botswana': 'BW',
    'Brazil': 'BR',
    'Brunei': 'BN',
    'Bulgaria': 'BG',
    'Burkina Faso': 'BF',
    'Burundi': 'BI',
    'Cambodia': 'KH',
    'Cameroon': 'CM',
    'Canada': 'CA',
    'Cape Verde': 'CV',
    'Central African Republic': 'CF',
    'Chad': 'TD',
    'Chile': 'CL',
    'China': 'CN',
    'Colombia': 'CO',
    'Comoros': 'KM',
    'Congo': 'CG',
    'Congo, Democratic Republic of the': 'CD',
    'Cook Islands': 'CK',
    'Costa Rica': 'CR',
    'Croatia': 'HR',
    'Cuba': 'CU',
    'Cyprus': 'CY',
    'Czech Republic': 'CZ',
    'Denmark': 'DK',
    'Djibouti': 'DJ',
    'Dominica': 'DM',
    'Dominican Republic': 'DO',
    'Ecuador': 'EC',
    'Egypt': 'EG',
    'El Salvador': 'SV',
    'Equatorial Guinea': 'GQ',
    'Eritrea': 'ER',
    'Estonia': 'EE',
    'Ethiopia': 'ET',
    'Fiji': 'FJ',
    'Finland': 'FI',
    'France': 'FR',
    'Gabon': 'GA',
    'Gambia': 'GM',
    'Georgia': 'GE',
    'Germany': 'DE',
    'Ghana': 'GH',
    'Greece': 'GR',
    'Greenland': 'GL',
    'Guatemala': 'GT',
    'Guinea': 'GN',
    'Guinea-Bissau': 'GW',
    'Guyana': 'GY',
    'Haiti': 'HT',
    'Honduras': 'HN',
    'Hong Kong': 'HK',
    'Hungary': 'HU',
    'Iceland': 'IS',
    'India': 'IN',
    'Indonesia': 'ID',
    'Iran': 'IR',
    'Iraq': 'IQ',
    'Ireland': 'IE',
    'Israel': 'IL',
    'Italy': 'IT',
    'Ivory Coast': 'CI',
    'Jamaica': 'JM',
    'Japan': 'JP',
    'Jordan': 'JO',
    'Kazakhstan': 'KZ',
    'Kenya': 'KE',
    'Kiribati': 'KI',
    'Kuwait': 'KW',
    'Kyrgyzstan': 'KG',
    'Laos': 'LA',
    'Latvia': 'LV',
    'Lebanon': 'LB',
    'Lesotho': 'LS',
    'Liberia': 'LR',
    'Libya': 'LY',
    'Liechtenstein': 'LI',
    'Lithuania': 'LT',
    'Luxembourg': 'LU',
    'Macau': 'MO',
    'Macedonia': 'MK',
    'Madagascar': 'MG',
    'Malawi': 'MW',
    'Malaysia': 'MY',
    'Maldives': 'MV',
    'Mali': 'ML',
    'Malta': 'MT',
    'Marshall Islands': 'MH',
    'Mauritania': 'MR',
    'Mauritius': 'MU',
    'Mexico': 'MX',
    'Micronesia': 'FM',
    'Moldova': 'MD',
    'Monaco': 'MC',
    'Mongolia': 'MN',
    'Montenegro': 'ME',
    'Morocco': 'MA',
    'Mozambique': 'MZ',
    'Myanmar': 'MM',
    'Namibia': 'NA',
    'Nauru': 'NR',
    'Nepal': 'NP',
    'Netherlands': 'NL',
    'New Zealand': 'NZ',
    'Nicaragua': 'NI',
    'Niger': 'NE',
    'Nigeria': 'NG',
    'Norway': 'NO',
    'Oman': 'OM',
    'Pakistan': 'PK',
    'Palau': 'PW',
    'Panama': 'PA',
    'Papua New Guinea': 'PG',
    'Paraguay': 'PY',
    'Peru': 'PE',
    'Philippines': 'PH',
    'Poland': 'PL',
    'Portugal': 'PT',
    'Qatar': 'QA',
    'Romania': 'RO',
    'Russia': 'RU',
    'Rwanda': 'RW',
    'Samoa': 'WS',
    'San Marino': 'SM',
    'Sao Tome and Principe': 'ST',
    'Saudi Arabia': 'SA',
    'Senegal': 'SN',
    'Serbia': 'RS',
    'Seychelles': 'SC',
    'Sierra Leone': 'SL',
    'Singapore': 'SG',
    'Slovakia': 'SK',
    'Slovenia': 'SI',
    'Solomon Islands': 'SB',
    'Somalia': 'SO',
    'South Africa': 'ZA',
    'South Korea': 'KR',
    'South Sudan': 'SS',
    'Spain': 'ES',
    'Sri Lanka': 'LK',
    'Sudan': 'SD',
    'Suriname': 'SR',
    'Eswatini': 'SZ',
    'Sweden': 'SE',
    'Switzerland': 'CH',
    'Syria': 'SY',
    'Taiwan': 'TW',
    'Tajikistan': 'TJ',
    'Tanzania': 'TZ',
    'Thailand': 'TH',
    'Togo': 'TG',
    'Tonga': 'TO',
    'Tunisia': 'TN',
    'Turkey': 'TR',
    'Turkmenistan': 'TM',
    'Tuvalu': 'TV',
    'Uganda': 'UG',
    'Ukraine': 'UA',
    'United Arab Emirates': 'AE',
    'United Kingdom': 'GB',
    'Uruguay': 'UY',
    'Uzbekistan': 'UZ',
    'Vanuatu': 'VU',
    'Venezuela': 'VE',
    'Vietnam': 'VN',
    'Yemen': 'YE',
    'Zambia': 'ZM',
    'Zimbabwe': 'ZW'
  };

  static String? getCountryCode(String dialCode) {
    Map<String, String> dialCodeToCountry = {
      '+93': 'AF',  // Afghanistan
      '+355': 'AL', // Albania
      '+213': 'DZ', // Algeria
      '+1': 'US',   // United States / Canada
      '+376': 'AD', // Andorra
      '+244': 'AO', // Angola
      '+54': 'AR',  // Argentina
      '+374': 'AM', // Armenia
      '+61': 'AU',  // Australia
      '+43': 'AT',  // Austria
      '+994': 'AZ', // Azerbaijan
      '+973': 'BH', // Bahrain
      '+880': 'BD', // Bangladesh
      '+375': 'BY', // Belarus
      '+32': 'BE',  // Belgium
      '+501': 'BZ', // Belize
      '+229': 'BJ', // Benin
      '+975': 'BT', // Bhutan
      '+591': 'BO', // Bolivia
      '+387': 'BA', // Bosnia and Herzegovina
      '+267': 'BW', // Botswana
      '+55': 'BR',  // Brazil
      '+673': 'BN', // Brunei
      '+359': 'BG', // Bulgaria
      '+226': 'BF', // Burkina Faso
      '+257': 'BI', // Burundi
      '+855': 'KH', // Cambodia
      '+237': 'CM', // Cameroon
      '+1': 'CA',   // Canada
      '+238': 'CV', // Cape Verde
      '+236': 'CF', // Central African Republic
      '+235': 'TD', // Chad
      '+56': 'CL',  // Chile
      '+86': 'CN',  // China
      '+57': 'CO',  // Colombia
      '+269': 'KM', // Comoros
      '+243': 'CD', // Congo, Democratic Republic of the
      '+682': 'CK', // Cook Islands
      '+506': 'CR', // Costa Rica
      '+385': 'HR', // Croatia
      '+53': 'CU',  // Cuba
      '+357': 'CY', // Cyprus
      '+420': 'CZ', // Czech Republic
      '+45': 'DK',  // Denmark
      '+253': 'DJ', // Djibouti
      '+1': 'DM',   // Dominica
      '+1': 'DO',   // Dominican Republic
      '+593': 'EC', // Ecuador
      '+20': 'EG',  // Egypt
      '+503': 'SV', // El Salvador
      '+240': 'GQ', // Equatorial Guinea
      '+291': 'ER', // Eritrea
      '+372': 'EE', // Estonia
      '+251': 'ET', // Ethiopia
      '+679': 'FJ', // Fiji
      '+358': 'FI', // Finland
      '+33': 'FR',  // France
      '+241': 'GA', // Gabon
      '+220': 'GM', // Gambia
      '+995': 'GE', // Georgia
      '+49': 'DE',  // Germany
      '+233': 'GH', // Ghana
      '+30': 'GR',  // Greece
      '+299': 'GL', // Greenland
      '+502': 'GT', // Guatemala
      '+224': 'GN', // Guinea
      '+245': 'GW', // Guinea-Bissau
      '+592': 'GY', // Guyana
      '+509': 'HT', // Haiti
      '+504': 'HN', // Honduras
      '+852': 'HK', // Hong Kong
      '+36': 'HU',  // Hungary
      '+354': 'IS', // Iceland
      '+91': 'IN',  // India
      '+62': 'ID',  // Indonesia
      '+98': 'IR',  // Iran
      '+964': 'IQ', // Iraq
      '+353': 'IE', // Ireland
      '+972': 'IL', // Israel
      '+39': 'IT',  // Italy
      '+225': 'CI', // Ivory Coast
      '+1': 'JM',   // Jamaica
      '+81': 'JP',  // Japan
      '+962': 'JO', // Jordan
      '+7': 'KZ',   // Kazakhstan
      '+254': 'KE', // Kenya
      '+686': 'KI', // Kiribati
      '+965': 'KW', // Kuwait
      '+996': 'KG', // Kyrgyzstan
      '+856': 'LA', // Laos
      '+371': 'LV', // Latvia
      '+961': 'LB', // Lebanon
      '+266': 'LS', // Lesotho
      '+231': 'LR', // Liberia
      '+218': 'LY', // Libya
      '+423': 'LI', // Liechtenstein
      '+370': 'LT', // Lithuania
      '+352': 'LU', // Luxembourg
      '+853': 'MO', // Macau
      '+389': 'MK', // Macedonia
      '+261': 'MG', // Madagascar
      '+265': 'MW', // Malawi
      '+60': 'MY',  // Malaysia
      '+960': 'MV', // Maldives
      '+223': 'ML', // Mali
      '+356': 'MT', // Malta
      '+692': 'MH', // Marshall Islands
      '+222': 'MR', // Mauritania
      '+230': 'MU', // Mauritius
      '+52': 'MX',  // Mexico
      '+691': 'FM', // Micronesia
      '+373': 'MD', // Moldova
      '+377': 'MC', // Monaco
      '+976': 'MN', // Mongolia
      '+382': 'ME', // Montenegro
      '+212': 'MA', // Morocco
      '+258': 'MZ', // Mozambique
      '+95': 'MM',  // Myanmar
      '+264': 'NA', // Namibia
      '+674': 'NR', // Nauru
      '+977': 'NP', // Nepal
      '+31': 'NL',  // Netherlands
      '+64': 'NZ',  // New Zealand
      '+505': 'NI', // Nicaragua
      '+227': 'NE', // Niger
      '+234': 'NG', // Nigeria
      '+47': 'NO',  // Norway
      '+968': 'OM', // Oman
      '+92': 'PK',  // Pakistan
      '+680': 'PW', // Palau
      '+507': 'PA', // Panama
      '+675': 'PG', // Papua New Guinea
      '+595': 'PY', // Paraguay
      '+51': 'PE',  // Peru
      '+63': 'PH',  // Philippines
      '+48': 'PL',  // Poland
      '+351': 'PT', // Portugal
      '+974': 'QA', // Qatar
      '+40': 'RO',  // Romania
      '+7': 'RU',   // Russia
      '+250': 'RW', // Rwanda
      '+685': 'WS', // Samoa
      '+378': 'SM', // San Marino
      '+239': 'ST', // Sao Tome and Principe
      '+966': 'SA', // Saudi Arabia
      '+221': 'SN', // Senegal
      '+381': 'RS', // Serbia
      '+248': 'SC', // Seychelles
      '+232': 'SL', // Sierra Leone
      '+65': 'SG',  // Singapore
      '+421': 'SK', // Slovakia
      '+386': 'SI', // Slovenia
      '+677': 'SB', // Solomon Islands
      '+252': 'SO', // Somalia
      '+27': 'ZA',  // South Africa
      '+82': 'KR',  // South Korea
      '+211': 'SS', // South Sudan
      '+34': 'ES',  // Spain
      '+94': 'LK',  // Sri Lanka
      '+249': 'SD', // Sudan
      '+597': 'SR', // Suriname
      '+268': 'SZ', // Eswatini
      '+46': 'SE',  // Sweden
      '+41': 'CH',  // Switzerland
      '+963': 'SY', // Syria
      '+886': 'TW', // Taiwan
      '+992': 'TJ', // Tajikistan
      '+255': 'TZ', // Tanzania
      '+66': 'TH',  // Thailand
      '+228': 'TG', // Togo
      '+676': 'TO', // Tonga
      '+216': 'TN', // Tunisia
      '+90': 'TR',  // Turkey
      '+993': 'TM', // Turkmenistan
      '+688': 'TV', // Tuvalu
      '+256': 'UG', // Uganda
      '+380': 'UA', // Ukraine
      '+971': 'AE', // United Arab Emirates
      '+44': 'GB',  // United Kingdom
      '+598': 'UY', // Uruguay
      '+998': 'UZ', // Uzbekistan
      '+678': 'VU', // Vanuatu
      '+58': 'VE',  // Venezuela
      '+84': 'VN',  // Vietnam
      '+967': 'YE', // Yemen
      '+260': 'ZM', // Zambia
      '+263': 'ZW'  // Zimbabwe
    };

    return dialCodeToCountry[dialCode];
  }


}