import 'dart:convert';
import 'dart:io' as io;

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:nexa/Model/ApplyCouponModel.dart';
import 'package:nexa/Model/BrandModel.dart';
import 'package:nexa/Model/CategoryWiseProductModel.dart';
import 'package:nexa/Model/DecreaseCartModel.dart';
import 'package:nexa/Model/DeleteCartModel.dart';
import 'package:nexa/Model/GetCouponModel.dart';
import 'package:nexa/Model/GetProfileModel.dart';
import 'package:nexa/Model/IncreaseCartModel.dart';
import 'package:nexa/Model/InvoiceModel.dart';
import 'package:nexa/Model/NotificationDeleteModel.dart';
import 'package:nexa/Model/NotificationListModel.dart';
import 'package:nexa/Model/OtpVerifyModel.dart';
import 'package:nexa/Model/EmailOtpVerifyModel.dart';
import 'package:nexa/Model/OrderListModel.dart';
import 'package:nexa/Model/PlaceOrderModel.dart';
import 'package:nexa/Model/ProductReviewModel.dart';
import 'package:nexa/Model/ReOrderModel.dart';
import 'package:nexa/Model/SubCategoryModel.dart';
import 'package:nexa/Model/SuggestionModel.dart';
import 'package:path/path.dart' as path;
import 'package:nexa/Model/AddShippingAddressModel.dart';
import 'package:nexa/Model/AddToCartModel.dart';
import 'package:nexa/Model/AddWishlistModel.dart';
import 'package:nexa/Model/AllWishlistModel.dart';
import 'package:nexa/Model/CartProductsModel.dart';
import 'package:nexa/Model/CustomerExistingModel.dart';
import 'package:nexa/Model/CustomerRegisterOrLoginModel.dart';
import 'package:nexa/Model/DeleteShippingAddressModel.dart';
import 'package:nexa/Model/HomeModel.dart';
import 'package:nexa/Model/LoginModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Constant.dart';
import 'Model/AllProductModel.dart';
import 'Model/AllShippingAddressModel.dart';
import 'Model/CancelOrderModel.dart';
import 'Model/CategoryModel.dart';
import 'Model/CityModel.dart';
import 'Model/CountryModel.dart';
import 'Model/CreateOrUpdateProfileModel.dart';
import 'Model/CurrencyModel.dart';
import 'Model/CustomerSupportModel.dart';
import 'Model/ForgotPasswordModel.dart';
import 'Model/OrderDetailModel.dart';
import 'Model/ReviewHelpfulModel.dart';
import 'Model/SingleProductModel.dart';
import 'Model/StateModel.dart';
import 'Model/VerifyEmailModel.dart';
import 'Model/WareHouseModel.dart';

// Define a custom exception for HTTP errors
class HttpException implements Exception {
  final String message;
  HttpException(this.message);

  @override
  String toString() {
    return message;
  }
}

class Api{
  static final BaseUrl = 'https://urlsdemo.online/nexa/api/';


  static Future<LoginModel?> loginApi(String credentials, String password, String fcm_token) async {

    var fcmToken = Constant.fcmToken;
    final response = await http.post(Uri.parse('${BaseUrl}login'),

      body: {
      'credentials': credentials,
        'password': password,
        'fcm_token': fcmToken
      }
    );
    if (response.statusCode == 200) {
      try {
        final jsonString = jsonDecode(response.body);
        print(jsonString);
        return LoginModel.fromJson(jsonString);
      } catch (e) {
        print('Error parsing JSON loginApi: $e');
        return null; // Handle JSON parsing error
      }
    } else {
      print('Request failed with status loginApi: ${response.statusCode}');
      print('Response body: ${response.body}');
      return null; // Handle HTTP request failure
    }

  }

  static Future logoutApi(String fcm_token) async{
    var fcmToken = Constant.fcmToken;
    var token = Constant.token;
    final response = await http.post(Uri.parse('${BaseUrl}logout'),
      headers: {
        'authorization': 'Bearer $token',
      },
      body: {
      'fcm_token': fcmToken
      }
    );

    if (response.statusCode == 200) {
      try {
        final jsonString = jsonDecode(response.body);
        print(jsonString);
        return jsonString;
      } catch (e) {
        print('Error parsing JSON logoutApi: $e');
        return null; // Handle JSON parsing error
      }
    } else {
      print('Request failed with status logoutApi: ${response.statusCode}');
      print('Response body: ${response.body}');
      return null; // Handle HTTP request failure
    }
  }

  static Future<BrandModel?> brandApi() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    Constant.token = await pref.getString('token').toString();
    var token = Constant.token;
    final response = await http.get(Uri.parse('${BaseUrl}all-brands'),
      headers: {
        'authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      try {
        final jsonString = jsonDecode(response.body);
        print(jsonString);
        return BrandModel.fromJson(jsonString);
      } catch (e) {
        print('Error parsing JSON brandApi: $e');
        return null; // Handle JSON parsing error
      }
    } else {
      print('Request failed with status brandApi: ${response.statusCode}');
      print('Response body: ${response.body}');
      return null; // Handle HTTP request failure
    }
  }

  static Future<ForgotPasswordModel?> forgotPasswordApi(String credentials) async {

    final response = await http.post(Uri.parse('${BaseUrl}forgot-password'),

        body: {
          'credentials': credentials,
        }
    );
    if (response.statusCode == 200) {
      try {
        final jsonString = jsonDecode(response.body);
        print(jsonString);
        return ForgotPasswordModel.fromJson(jsonString);
      } catch (e) {
        print('Error parsing JSON forgotPasswordApi: $e');
        return null; // Handle JSON parsing error
      }
    } else {
      print('Request failed with status forgotPasswordApi: ${response.statusCode}');
      print('Response body: ${response.body}');
      return null; // Handle HTTP request failure
    }

  }

  static Future<VerifyEmailModel?> verifyEmailApi(String credentials) async {

    var token = Constant.token;
    final response = await http.post(Uri.parse('${BaseUrl}email-verify'),
        headers: {
          'authorization': 'Bearer $token',
        },
        body: {
          'email': credentials,
        }
    );
    if (response.statusCode == 200) {
      try {
        final jsonString = jsonDecode(response.body);
        print(jsonString);
        return VerifyEmailModel.fromJson(jsonString);
      } catch (e) {
        print('Error parsing JSON verifyEmailApi: $e');
        return null; // Handle JSON parsing error
      }
    } else {
      print('Request failed with status verifyEmailApi: ${response.statusCode}');
      print('Response body: ${response.body}');
      return null; // Handle HTTP request failure
    }

  }

  static Future<OtpVerifyModel?> otpVerifyForgotPasswordApi(String credentials, String otp) async {

    final response = await http.post(Uri.parse('${BaseUrl}forgot-password-otp-verified'),

        body: {
          'credentials': credentials,
          'otp': otp
        }
    );
    if (response.statusCode == 200) {
      try {
        final jsonString = jsonDecode(response.body);
        print(jsonString);
        return OtpVerifyModel.fromJson(jsonString);
      } catch (e) {
        print('Error parsing JSON otpVerifyForgotPasswordApi: $e');
        return null; // Handle JSON parsing error
      }
    } else {
      print('Request failed with status otpVerifyForgotPasswordApi: ${response.statusCode}');
      print('Response body: ${response.body}');
      return null; // Handle HTTP request failure
    }

  }

  static Future<EmailOtpVerifyModel?> emailOtpVerifyApi(String credentials, String otp) async {
    var token = Constant.token;

    final response = await http.post(Uri.parse('${BaseUrl}email-otp-verify'),
        headers: {
          'authorization': 'Bearer $token',
        },
        body: {
          'email': credentials,
          'otp': otp
        }
    );
    if (response.statusCode == 200) {
      try {
        final jsonString = jsonDecode(response.body);
        print(jsonString);
        return EmailOtpVerifyModel.fromJson(jsonString);
      } catch (e) {
        print('Error parsing JSON emailOtpVerifyApi: $e');
        return null; // Handle JSON parsing error
      }
    } else {
      print('Request failed with status emailOtpVerifyApi: ${response.statusCode}');
      print('Response body: ${response.body}');
      return null; // Handle HTTP request failure
    }

  }

  static Future resetPasswordApi(String credentials, String password) async {

    final response = await http.post(Uri.parse('${BaseUrl}reset-password'),

        body: {
          'credentials': credentials,
          'password': password
        }
    );
    if (response.statusCode == 200) {
      try {
        final jsonString = jsonDecode(response.body);
        print(jsonString);
        return jsonString;
      } catch (e) {
        print('Error parsing JSON resetPasswordApi: $e');
        return null; // Handle JSON parsing error
      }
    } else {
      print('Request failed with status resetPasswordApi: ${response.statusCode}');
      print('Response body: ${response.body}');
      return null; // Handle HTTP request failure
    }

  }

  static Future<CreateOrUpdateProfileModel?> createOrUpdateProfileApi(String first_name, String last_name, String country, String country_code, String phone, String password, io.File? image, String email) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var token = pref.getString('token');
    final request = http.MultipartRequest(
        'POST',
        Uri.parse('${BaseUrl}update-profile')
    );

    request.headers['authorization'] = 'Bearer $token';
    request.fields['first_name'] = first_name;
    request.fields['last_name'] = last_name;
    request.fields['country'] = country;
    request.fields['country_code'] = country_code;
    request.fields['phone'] = phone;
    request.fields['password'] = password;
    request.fields['email'] = email;

    if(image != null ){
      var stream = http.ByteStream(image.openRead());
      var length = await image.length();
      var multipartFile = http.MultipartFile('image',
          stream,
          length,
          filename: path.basename(image.path)
      );
      request.files.add(multipartFile);
    }

    var response = await request.send();

    if(response.statusCode == 200){
      try{
        var responseData = await response.stream.bytesToString();
        final jsonString = jsonDecode(responseData);
        print(jsonString);
        return CreateOrUpdateProfileModel.fromJson(jsonString);
      } catch (e) {
        print('Error parsing JSON createOrUpdateProfileApi: $e');
        return null; // Handle JSON parsing error
      }
    }else{
      print('Request failed with status createOrUpdateProfileApi: ${response.statusCode}');
      print('Response body: ${await response.stream.bytesToString()}');
      return null;
    }
    // final response = await http.post(Uri.parse('${BaseUrl}update-profile'),
    //     headers: {
    //       'authorization': 'Bearer $token'
    //     },
    //     body: {
    //       'first_name': first_name,
    //       'last_name': last_name,
    //       'country': country,
    //       'country_code': country_code,
    //       'phone': phone,
    //       'password': password,
    //       'image': image,
    //       'email': email
    //     }
    // );
    // if (response.statusCode == 200) {
    //   try {
    //     final jsonString = jsonDecode(response.body);
    //     print(jsonString);
    //     return CreateOrUpdateProfileModel.fromJson(jsonString);
    //   } catch (e) {
    //     print('Error parsing JSON: $e');
    //     return null; // Handle JSON parsing error
    //   }
    // } else {
    //   print('Request failed with status: ${response.statusCode}');
    //   print('Response body: ${response.body}');
    //   return null; // Handle HTTP request failure
    // }

  }

  static Future<CustomerExistingModel?> customerExistingApi(String credentials, String country_code) async {

    final response = await http.post(Uri.parse('${BaseUrl}Customer-ExistOrNot'),

        body: {
          'credentials': credentials,
          'country_code': country_code,
        }
    );
    if (response.statusCode == 200) {
      try {
        final jsonString = jsonDecode(response.body);
        print(jsonString);
        return CustomerExistingModel.fromJson(jsonString);
      } catch (e) {
        print('Error parsing JSON customerExistingApi: $e');
        return null; // Handle JSON parsing error
      }
    } else {
      print('Request failed with status customerExistingApi: ${response.statusCode}');
      print('Response body: ${response.body}');
      return null; // Handle HTTP request failure
    }

  }

  static Future<CustomerRegisterOrLoginModel?> customerRegisterOrLoginApi(String credentials, String country_code, String fcm_token) async {

    var fcmToken = Constant.fcmToken;
    final response = await http.post(Uri.parse('${BaseUrl}Customer-RegisterOrLogin'),

        body: {
          'credentials': credentials,
          'country_code': country_code,
          'fcm_token': fcmToken
        }
    );
    if (response.statusCode == 200) {
      try {
        final jsonString = jsonDecode(response.body);
        print(jsonString);
        return CustomerRegisterOrLoginModel.fromJson(jsonString);
      } catch (e) {
        print('Error parsing JSON customerRegisterOrLoginApi: $e');
        return null; // Handle JSON parsing error
      }
    } else {
      print('Request failed with status customerRegisterOrLoginApi: ${response.statusCode}');
      print('Response body: ${response.body}');
      return null; // Handle HTTP request failure
    }

  }

  static Future<HomeModel?> homeApi(String category_name, String product_name) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var token = await pref.getString('token').toString();
    // var token = Constant.token;
    final response = await http.post(Uri.parse('${BaseUrl}home'),
        headers: {
          'authorization': 'Bearer $token'
        },
        body: {
          'category_name': category_name,
          'product_name': product_name
        }
    );
    if (response.statusCode == 200) {
      try {
        final jsonString = jsonDecode(response.body);
        print(jsonString);
        return HomeModel.fromJson(jsonString);
      } catch (e) {
        print('Error parsing JSON homeApi: $e');
        return null; // Handle JSON parsing error
      }
    } else {
      print('Request failed with status homeApi: ${response.statusCode}');
      print('Response body: ${response.body}');
      return null; // Handle HTTP request failure
    }

  }

  static Future<NotificationDeleteModel?> notificationDeleteApi(String notification_id, ) async {
    var token = Constant.token;
    final response = await http.post(Uri.parse('${BaseUrl}notification-delete'),
        headers: {
          'authorization': 'Bearer $token'
        },
        body: {
          'notification_id': notification_id,
        }
    );
    if (response.statusCode == 200) {
      try {
        final jsonString = jsonDecode(response.body);
        print(jsonString);
        return NotificationDeleteModel.fromJson(jsonString);
      } catch (e) {
        print('Error parsing JSON notificationDeleteApi: $e');
        return null; // Handle JSON parsing error
      }
    } else {
      print('Request failed with status notificationDeleteApi: ${response.statusCode}');
      print('Response body: ${response.body}');
      return null; // Handle HTTP request failure
    }

  }

  static Future<CategoryModel?> categoryApi(/*String search_keyword*/) async {
    var token = Constant.token;
    final response = await http.get(Uri.parse('${BaseUrl}all-categories'),
        headers: {
          'authorization': 'Bearer $token'
        },
        // body: {
        //   // 'category_name': category_name,
        //   'search_keyword': search_keyword,
        //
        // }
    );
    if (response.statusCode == 200) {
      try {
        final jsonString = jsonDecode(response.body);
        print(jsonString);
        return CategoryModel.fromJson(jsonString);
      } catch (e) {
        print(FlutterError.demangleStackTrace);
        print('Error parsing JSON categoryApi: $e');
        return null; // Handle JSON parsing error
      }
    } else {
      print('Request failed with status categoryApi: ${response.statusCode}');
      print('Response body: ${response.body}');
      return null; // Handle HTTP request failure
    }

  }

  static Future<CategoryWiseProductModel?> categoryWiseProductApi(String category_id, /*String sub_category_id,*/ int page, String search_keyword) async {
    var token = Constant.token;
    final response = await http.post(Uri.parse('${BaseUrl}category-wise-product'),
      headers: {
        'authorization': 'Bearer $token'
      },
      body: {
        'category_id': category_id,
        // 'sub_category_id': sub_category_id,
        'page': page.toString(),
        'search_keyword': search_keyword,

      }
    );
    if (response.statusCode == 200) {
      try {
        final jsonString = jsonDecode(response.body);
        print(jsonString);
        return CategoryWiseProductModel.fromJson(jsonString);
      } catch (e) {
        print(FlutterError.demangleStackTrace);
        print('Error parsing JSON categoryWiseProductApi: $e');
        return null; // Handle JSON parsing error
      }
    } else {
      print('Request failed with status categoryWiseProductApi: ${response.statusCode}');
      print('Response body: ${response.body}');
      return null; // Handle HTTP request failure
    }

  }

  static Future<SubCategoryModel?> subCategoryApi(String category_id, String sub_cat_id, String page, String search_keyword) async {
    var token = Constant.token;
    final response = await http.post(Uri.parse('${BaseUrl}sub-category-wise-product'),
        headers: {
          'authorization': 'Bearer $token'
        },
        body: {
          'category_id': category_id,
          'sub_cat_id': sub_cat_id,
          'page': page.toString(),
          'search_keyword': search_keyword,

        }
    );
    if (response.statusCode == 200) {
      try {
        final jsonString = jsonDecode(response.body);
        print(jsonString);
        return SubCategoryModel.fromJson(jsonString);
      } catch (e) {
        print(FlutterError.demangleStackTrace);
        print('Error parsing JSON subCategoryApi: $e');
        return null; // Handle JSON parsing error
      }
    } else {
      print('Request failed with status subCategoryApi: ${response.statusCode}');
      print('Response body: ${response.body}');
      return null; // Handle HTTP request failure
    }

  }

  static Future<AllWishlistModel?> allWishlistApi() async {
    var token = Constant.token;
    final response = await http.get(Uri.parse('${BaseUrl}all-wishlist-products'),
        headers: {
          'authorization': 'Bearer $token'
        },
    );
    if (response.statusCode == 200) {
      try {
        final jsonString = jsonDecode(response.body);
        print(jsonString);
        return AllWishlistModel.fromJson(jsonString);
      } catch (e) {
        print('Error parsing JSON allWishlistApi: $e');
        return null; // Handle JSON parsing error
      }
    } else {
      print('Request failed with status allWishlistApi: ${response.statusCode}');
      print('Response body: ${response.body}');
      return null; // Handle HTTP request failure
    }

  }

  static Future<SuggestionModel?> suggestionApi(String keyword) async {
    var token = Constant.token;
    final response = await http.post(Uri.parse('${BaseUrl}keyword-suggestion'),
      headers: {
        'authorization': 'Bearer $token'
      },
      body: {
      'keyword': keyword
      }
    );
    if (response.statusCode == 200) {
      try {
        final jsonString = jsonDecode(response.body);
        print(jsonString);
        return SuggestionModel.fromJson(jsonString);
      } catch (e) {
        print('Error parsing JSON suggestionApi: $e');
        return null; // Handle JSON parsing error
      }
    } else {
      print('Request failed with status suggestionApi: ${response.statusCode}');
      print('Response body: ${response.body}');
      return null; // Handle HTTP request failure
    }

  }

  static Future<AllProductModel?> allProductApi(String brand_id, String price_min, String price_max, String rating, String price_ranges, String discount, int page, String top_sale, String price_sorting) async {
    var token = Constant.token;
    final response = await http.post(Uri.parse('${BaseUrl}all-products'),
      headers: {
        'authorization': 'Bearer $token'
      },
      body: {
        'brand_id': brand_id,
        'price_min': price_min,
        'price_max': price_max,
        'rating': rating,
        'price_ranges': price_ranges,
        'discount': discount,
        'page': page.toString(),
        'top_sale': top_sale,
        'price_sorting': price_sorting,
      }
      // body: {
      //   'category_id': category_id,
      //   'brand_id': brand_id,
      //   'price_min': price_min,
      //   'price_max': price_max
      // }
    );
    if (response.statusCode == 200) {
      try {
        final jsonString = jsonDecode(response.body);
        print(jsonString);
        return AllProductModel.fromJson(jsonString);
      } catch (e) {
        print('Error parsing JSON allProductApi: $e');
        return null; // Handle JSON parsing error
      }
    } else {
      print('Request failed with status allProductApi: ${response.statusCode}');
      print('Response body: ${response.body}');
      return null; // Handle HTTP request failure
    }

  }


  static Future<AllProductModel?> sortProductApi(var brand_id, String price_min, String price_max, var rating, var price_ranges, var discount, int page, String top_sale, String price_sorting) async {
    var token = Constant.token;
    Map<String, dynamic> requestBody = {
      'brand_id': brand_id.join(','), // e.g., "1,2,3"
      'price_min': price_min?.toString(),
      'price_max': price_max?.toString(),
      'rating': rating.join(','), // e.g., "4,5"
      'price_ranges': price_ranges.join(','), // e.g., "25-50,50-75"
      'discount': discount.join(','), // e.g., "25-50,50-75"
      'page': page.toString(),
      'top_sale': top_sale,
      'price_sorting': price_sorting,
    };
    final response = await http.post(Uri.parse('${BaseUrl}all-products'),
        headers: {
          'authorization': 'Bearer $token'
        },
        body: requestBody/*{
          'brand_id': brand_id,
          'price_min': price_min,
          'price_max': price_max,
          'rating': rating,
          'price_ranges': price_ranges,
          'discount': discount,
          'page': page.toString(),
          'top_sale': top_sale,
          'price_sorting': price_sorting,
        }*/
      // body: {
      //   'category_id': category_id,
      //   'brand_id': brand_id,
      //   'price_min': price_min,
      //   'price_max': price_max
      // }
    );
    if (response.statusCode == 200) {
      try {
        final jsonString = jsonDecode(response.body);
        print(jsonString);
        return AllProductModel.fromJson(jsonString);
      } catch (e) {
        print('Error parsing JSON sortProductApi: $e');
        return null; // Handle JSON parsing error
      }
    } else {
      print('Request failed with status sortProductApi: ${response.statusCode}');
      print('Response body: ${response.body}');
      return null; // Handle HTTP request failure
    }

  }


  static Future<SingleProductModel?> singleProductApi(String product_id) async {
    var token = Constant.token;
    final response = await http.post(Uri.parse('${BaseUrl}single-product'),
      headers: {
        'authorization': 'Bearer $token'
      },
      body: {
      'product_id': product_id
      }
    );
    if (response.statusCode == 200) {
      try {
        final jsonString = jsonDecode(response.body);
        print(jsonString);
        return SingleProductModel.fromJson(jsonString);
      } catch (e) {
        print('Error parsing JSON singleProductApi: $e');
        return null; // Handle JSON parsing error
      }
    } else {
      print('Request failed with status singleProductApi: ${response.statusCode}');
      print('Response body: ${response.body}');
      return null; // Handle HTTP request failure
    }

  }

  static Future<AddToCartModel?> addToCartApi(String product_id, String quantity, String price) async {
    var token = Constant.token;

    final response = await http.post(Uri.parse('${BaseUrl}add-to-cart'),
        headers: {
          'authorization': 'Bearer $token',
          // 'Content-Type': 'application/json',
        },
        body: /*jsonEncode(body)*/{
          'product_id': product_id,
          'total_quantity': quantity,
          'price': price,
        }
    );
    if (response.statusCode == 200) {
      try {
        final jsonString = jsonDecode(response.body);
        print(jsonString);
        return AddToCartModel.fromJson(jsonString);
      } catch (e) {
        print('Error parsing JSON addToCartApi: $e');
        return null; // Handle JSON parsing error
      }
    } else {
      print('Request failed with status addToCartApi: ${response.statusCode}');
      print('Response body: ${response.body}');
      return null; // Handle HTTP request failure
    }

  }

  static Future<AllShippingAddressModel?> allShippingAddressApi() async {
    var token = Constant.token;
    final response = await http.get(Uri.parse('${BaseUrl}all-shipping-address'),
      headers: {
        'authorization': 'Bearer $token'
      },
    );
    if (response.statusCode == 200) {
      try {
        final jsonString = jsonDecode(response.body);
        print(jsonString);
        return AllShippingAddressModel.fromJson(jsonString);
      } catch (e) {
        print('Error parsing JSON allShippingAddressApi: $e');
        return null; // Handle JSON parsing error
      }
    } else {
      print('Request failed with status allShippingAddressApi: ${response.statusCode}');
      print('Response body: ${response.body}');
      return null; // Handle HTTP request failure
    }

  }

  static Future<CustomerSupportModel?> customerSupportApi() async {
    var token = Constant.token;
    final response = await http.get(Uri.parse('${BaseUrl}customer-support'),
      headers: {
        'authorization': 'Bearer $token'
      },
    );
    if (response.statusCode == 200) {
      try {
        final jsonString = jsonDecode(response.body);
        print(jsonString);
        return CustomerSupportModel.fromJson(jsonString);
      } catch (e) {
        print('Error parsing JSON customerSupportApi: $e');
        return null; // Handle JSON parsing error
      }
    } else {
      print('Request failed with status customerSupportApi: ${response.statusCode}');
      print('Response body: ${response.body}');
      return null; // Handle HTTP request failure
    }

  }

  static Future<ApplyCouponModel?> applyCouponApi(String cart_ids , String coupon_code, String total_amount) async {
    Map body = {
      'cart_ids': cart_ids,
      'coupon_code': coupon_code,
      'total_amount': total_amount.toString()
    };
    print('::::::::::::::::: $cart_ids');
    var token = Constant.token;
    final response = await http.post(Uri.parse('${BaseUrl}apply-coupon'),
        headers: {
          'authorization': 'Bearer $token'
        },
        body: body
    );
    if (response.statusCode == 200) {
      try {
        final jsonString = jsonDecode(response.body);
        print(jsonString);
        return ApplyCouponModel.fromJson(jsonString);
      } catch (e, stacktrace) {
        print('Error parsing JSON applyCouponApi: $e');
        print('error stack: $stacktrace');
        return null; // Handle JSON parsing error
      }
    } else {
      print('Request failed with status applyCouponApi: ${response.statusCode}');
      print('Response body: ${response.body}');
      return null; // Handle HTTP request failure
    }

  }

  static Future orderDetailsApi(String order_id) async{
    var token = Constant.token;
    final response = await http.post(Uri.parse('${BaseUrl}single-order-details'),
        headers: {
          'authorization': 'Bearer $token',
        },
        body: {
          'order_id': order_id
        }
    );

    if (response.statusCode == 200) {
      try {
        final jsonString = jsonDecode(response.body);
        print(jsonString);
        return OrderDetailModel.fromJson(jsonString);
      } catch (e) {
        print('Error parsing JSON orderDetailsApi: $e');
        return null; // Handle JSON parsing error
      }
    } else {
      print('Request failed with status orderDetailsApi: ${response.statusCode}');
      print('Response body: ${response.body}');
      return null; // Handle HTTP request failure
    }
  }

  static Future<NotificationListModel?> notificationListApi() async {

    var token = Constant.token;
    final response = await http.get(Uri.parse('${BaseUrl}notification-list'),
        headers: {
          'authorization': 'Bearer $token'
        },
    );
    if (response.statusCode == 200) {
      try {
        final jsonString = jsonDecode(response.body);
        print(jsonString);
        return NotificationListModel.fromJson(jsonString);
      } catch (e, stacktrace) {
        print('Error parsing JSON notificationListApi: $e');
        print('error stack: $stacktrace');
        return null; // Handle JSON parsing error
      }
    } else {
      print('Request failed with status notificationListApi: ${response.statusCode}');
      print('Response body: ${response.body}');
      return null; // Handle HTTP request failure
    }

  }

  static Future<PlaceOrderModel?> placeOrderApi(
      {required String cart_id,
      required String sub_total_amount,
      required String item_discount_amount,
      required String total_amount,
      required String payment_mode,
      required String delivery_option,
      required String warehouse_id,
      required String address_id,
      required String coupon_id,
      required String message}) async {
    Map body = {
      'cart_id': cart_id,
      'sub_total_amount': sub_total_amount,
      'item_discount_amount': item_discount_amount,
      'total_amount': total_amount,
      'payment_mode': payment_mode,
      'delivery_option': delivery_option,
      'warehouse_id': warehouse_id,
      'address_id': address_id,
      'coupon_id': coupon_id,
      'message': message
    };
    print('::::::::::::::::: $cart_id');
    var token = Constant.token;
    final response = await http.post(Uri.parse('${BaseUrl}product-order'),
        headers: {
          'authorization': 'Bearer $token'
        },
        body: /*jsonEncode(*/body/*)*/
    );
    if (response.statusCode == 200) {
      try {
        final jsonString = jsonDecode(response.body);
        print(jsonString);
        return PlaceOrderModel.fromJson(jsonString);
      } catch (e, stacktrace) {
        print('Error parsing JSON placeOrderApi: $e');
        print('error stack: $stacktrace');
        return null; // Handle JSON parsing error
      }
    } else {
      print('Request failed with status placeOrderApi: ${response.statusCode}');
      print('Response body: ${response.body}');
      return null; // Handle HTTP request failure
    }

  }

  static Future<OrderListModel?> orderListApi(String order_status) async {
    Map body = {
      'order_status': order_status
    };
    var token = Constant.token;
    final response = await http.post(Uri.parse('${BaseUrl}get-order-list'),
        headers: {
          'authorization': 'Bearer $token'
        },
        body: body
    );
    if (response.statusCode == 200) {
      try {
        final jsonString = jsonDecode(response.body);
        print(jsonString);
        return OrderListModel.fromJson(jsonString);
      } catch (e, stacktrace) {
        print('Error parsing JSON orderListApi: $e');
        print('error stack: $stacktrace');
        return null; // Handle JSON parsing error
      }
    } else {
      print('Request failed with status orderListApi: ${response.statusCode}');
      print('Response body: ${response.body}');
      return null; // Handle HTTP request failure
    }

  }

  static Future<InvoiceModel?> downloadInvoiceApi(String order_id) async {
    Map body = {
      'order_id': order_id
    };
    var token = Constant.token;
    final response = await http.post(Uri.parse('${BaseUrl}single-order-details-pdf'),
        headers: {
          'authorization': 'Bearer $token'
        },
        body: body
    );
    if (response.statusCode == 200) {
      try {
        final jsonString = jsonDecode(response.body);
        print(jsonString);
        return InvoiceModel.fromJson(jsonString);
      } catch (e, stacktrace) {
        print('Error parsing JSON downloadInvoiceApi: $e');
        print('error stack: $stacktrace');
        return null; // Handle JSON parsing error
      }
    } else {
      print('Request failed with status downloadInvoiceApi: ${response.statusCode}');
      print('Response body: ${response.body}');
      return null; // Handle HTTP request failure
    }

  }

  static Future<ReOrderModel?> reOrderApi(String order_id) async {
    Map body = {
      'order_id': order_id
    };
    var token = Constant.token;
    final response = await http.post(Uri.parse('${BaseUrl}re-order'),
        headers: {
          'authorization': 'Bearer $token'
        },
        body: body
    );
    if (response.statusCode == 200) {
      try {
        final jsonString = jsonDecode(response.body);
        print(jsonString);
        return ReOrderModel.fromJson(jsonString);
      } catch (e, stacktrace) {
        print('Error parsing JSON reOrderApi: $e');
        print('error stack: $stacktrace');
        return null; // Handle JSON parsing error
      }
    } else {
      print('Request failed with status reOrderApi: ${response.statusCode}');
      print('Response body: ${response.body}');
      return null; // Handle HTTP request failure
    }

  }

  static Future<CancelOrderModel?> cancelOrderApi(String order_id) async {
    Map body = {
      'order_id': order_id
    };
    var token = Constant.token;
    final response = await http.post(Uri.parse('${BaseUrl}cancel-order'),
        headers: {
          'authorization': 'Bearer $token'
        },
        body: body
    );
    if (response.statusCode == 200) {
      try {
        final jsonString = jsonDecode(response.body);
        print(jsonString);
        return CancelOrderModel.fromJson(jsonString);
      } catch (e, stacktrace) {
        print('Error parsing JSON cancelOrderApi: $e');
        print('error stack: $stacktrace');
        return null; // Handle JSON parsing error
      }
    } else {
      print('Request failed with status cancelOrderApi: ${response.statusCode}');
      print('Response body: ${response.body}');
      return null; // Handle HTTP request failure
    }

  }


  static Future<ProductReviewModel?> productReviewApi(String product_id) async {
    Map body = {
      'product_id': product_id
    };
    var token = Constant.token;
    final response = await http.post(Uri.parse('${BaseUrl}product-all-reviews'),
        headers: {
          'authorization': 'Bearer $token'
        },
        body: body
    );
    if (response.statusCode == 200) {
      try {
        final jsonString = jsonDecode(response.body);
        print(jsonString);
        return ProductReviewModel.fromJson(jsonString);
      } catch (e, stacktrace) {
        print('Error parsing JSON productReviewApi: $e');
        print('error stack: $stacktrace');
        return null; // Handle JSON parsing error
      }
    } else {
      print('Request failed with status productReviewApi: ${response.statusCode}');
      print('Response body: ${response.body}');
      return null; // Handle HTTP request failure
    }

  }

  static Future<ReviewHelpfulModel?> reviewHelpfulApi(String product_id, String product_review_id) async {
    Map body = {
      'product_id': product_id,
      'product_review_id': product_review_id,
    };
    var token = Constant.token;
    final response = await http.post(Uri.parse('${BaseUrl}product-review-helpful'),
        headers: {
          'authorization': 'Bearer $token'
        },
        body: body
    );
    if (response.statusCode == 200) {
      try {
        final jsonString = jsonDecode(response.body);
        print(jsonString);
        return ReviewHelpfulModel.fromJson(jsonString);
      } catch (e, stacktrace) {
        print('Error parsing JSON reviewHelpfulApi: $e');
        print('error stack: $stacktrace');
        return null; // Handle JSON parsing error
      }
    } else {
      print('Request failed with status reviewHelpfulApi: ${response.statusCode}');
      print('Response body: ${response.body}');
      return null; // Handle HTTP request failure
    }

  }

  static Future<CurrencyModel?> currencyApi() async {
    var token = Constant.token;
    final response = await http.post(Uri.parse('https://api.exchangeratesapi.io/v1/latest?access_key=b7a5536378d1da99fbb1211f3a145b50&base=USD'),
        headers: {
          'authorization': 'Bearer $token'
        },
    );
    if (response.statusCode == 200) {
      try {
        final jsonString = jsonDecode(response.body);
        print(jsonString);
        return CurrencyModel.fromJson(jsonString);
      } catch (e, stacktrace) {
        print('Error parsing JSON reviewHelpfulApi: $e');
        print('error stack: $stacktrace');
        return null; // Handle JSON parsing error
      }
    } else {
      print('Request failed with status reviewHelpfulApi: ${response.statusCode}');
      print('Response body: ${response.body}');
      return null; // Handle HTTP request failure
    }

  }

  static Future socialLoginApi({required String socailite_type, required String socailite_id, required String first_name, required String email, required String fcm_token}) async {
    var token = Constant.token;
    var fcmToken = Constant.fcmToken;
    final response = await http.post(Uri.parse('${BaseUrl}socailite-login'),
        headers: {
          'authorization': 'Bearer $token'
        },
        body: {
        'socailite_type': socailite_type,
        'socailite_id': socailite_id,
        'first_name': first_name,
        'email': email,
        'fcm_token': fcmToken,
        }
    );
    if (response.statusCode == 200) {
      try {
        final jsonString = jsonDecode(response.body);
        print(jsonString);
        return jsonString;
      } catch (e, stacktrace) {
        print('Error parsing JSON socialLoginApi: $e');
        print('Error stack: $stacktrace');
        throw HttpException('Failed to parse cart data.');
      }
    } else {
      print('Request failed with status socialLoginApi: ${response.statusCode}');
      print('Response body: ${response.body}');
      // Throw an exception with a meaningful message
      throw HttpException(
          'Failed to load data');
    }

  }


  static Future<CartProductsModel?> cartProductsApi(String address_id) async {
    var token = Constant.token;
    final response = await http.post(Uri.parse('${BaseUrl}get-all-cart-data'),
      headers: {
        'authorization': 'Bearer $token'
      },
      body: {
      'address_id': address_id
      }
    );
    if (response.statusCode == 200) {
      try {
        final jsonString = jsonDecode(response.body);
        print(jsonString);
        return CartProductsModel.fromJson(jsonString);
      } catch (e, stacktrace) {
        print('Error parsing JSON cartProductsApi: $e');
        print('Error stack: $stacktrace');
        throw HttpException('Failed to parse cart data.');
      }
    } else {
      print('Request failed with status cartProductsApi: ${response.statusCode}');
      print('Response body: ${response.body}');
      // Throw an exception with a meaningful message
      throw HttpException(
          'Failed to load data');
    }

  }

  static Future<AddWishlistModel?> addWishlistApi(String product_id) async {
    var token = Constant.token;
    final response = await http.post(Uri.parse('${BaseUrl}add-to-wishlist'),
        headers: {
          'authorization': 'Bearer $token'
        },
        body: {
          'product_id': product_id
        }
    );
    if (response.statusCode == 200) {
      try {
        final jsonString = jsonDecode(response.body);
        print(jsonString);
        return AddWishlistModel.fromJson(jsonString);
      } catch (e) {
        print('Error parsing JSON addWishlistApi: $e');
        return null; // Handle JSON parsing error
      }
    } else {
      print('Request failed with status addWishlistApi: ${response.statusCode}');
      print('Response body: ${response.body}');
      return null; // Handle HTTP request failure
    }

  }

  static Future<IncreaseCartModel?> increaseCartApi(String cart_id) async {
    var token = Constant.token;
    final response = await http.post(Uri.parse('${BaseUrl}cart-qty-increase'),
        headers: {
          'authorization': 'Bearer $token'
        },
        body: {
          'cart_id': cart_id
        }
    );
    if (response.statusCode == 200) {
      try {
        final jsonString = jsonDecode(response.body);
        print(jsonString);
        return IncreaseCartModel.fromJson(jsonString);
      } catch (e) {
        print('Error parsing JSON increaseCartApi: $e');
        return null; // Handle JSON parsing error
      }
    } else {
      print('Request failed with status increaseCartApi: ${response.statusCode}');
      print('Response body: ${response.body}');
      return null; // Handle HTTP request failure
    }

  }

  static Future<DecreaseCartModel?> decreaseCartApi(String cart_id) async {
    var token = Constant.token;
    final response = await http.post(Uri.parse('${BaseUrl}cart-qty-decrease'),
        headers: {
          'authorization': 'Bearer $token'
        },
        body: {
          'cart_id': cart_id
        }
    );
    if (response.statusCode == 200) {
      try {
        final jsonString = jsonDecode(response.body);
        print(jsonString);
        return DecreaseCartModel.fromJson(jsonString);
      } catch (e) {
        print('Error parsing JSON decreaseCartApi: $e');
        return null; // Handle JSON parsing error
      }
    } else {
      print('Request failed with status decreaseCartApi: ${response.statusCode}');
      print('Response body: ${response.body}');
      return null; // Handle HTTP request failure
    }

  }

  static Future<DeleteCartModel?> deleteCartApi(String cart_id) async {
    var token = Constant.token;
    final response = await http.post(Uri.parse('${BaseUrl}delete-cart-item'),
        headers: {
          'authorization': 'Bearer $token'
        },
        body: {
          'cart_id': cart_id
        }
    );
    if (response.statusCode == 200) {
      try {
        final jsonString = jsonDecode(response.body);
        print(jsonString);
        return DeleteCartModel.fromJson(jsonString);
      } catch (e) {
        print('Error parsing JSON deleteCartApi: $e');
        return null; // Handle JSON parsing error
      }
    } else {
      print('Request failed with status deleteCartApi: ${response.statusCode}');
      print('Response body: ${response.body}');
      return null; // Handle HTTP request failure
    }

  }

  static Future<GetCouponModel?> getCouponApi() async {
    // var token = Constant.token;
    SharedPreferences pref = await SharedPreferences.getInstance();
    var token = pref.getString('token');
    final response = await http.get(Uri.parse('${BaseUrl}coupon-get'),
      headers: {
        'authorization': 'Bearer $token'
      },
    );
    if (response.statusCode == 200) {
      try {
        final jsonString = jsonDecode(response.body);
        print(jsonString);
        return GetCouponModel.fromJson(jsonString);
      } catch (e) {
        print('Error parsing JSON getCouponApi: $e');
        return null; // Handle JSON parsing error
      }
    } else {
      print('Request failed with status getCouponApi: ${response.statusCode}');
      print('Response body: ${response.body}');
      return null; // Handle HTTP request failure
    }

  }

  static Future<WareHouseModel?> getWarehouseListApi() async {
    // var token = Constant.token;
    SharedPreferences pref = await SharedPreferences.getInstance();
    var token = pref.getString('token');
    final response = await http.get(Uri.parse('${BaseUrl}get-warehouse-list'),
      headers: {
        'authorization': 'Bearer $token'
      },
    );
    if (response.statusCode == 200) {
      try {
        final jsonString = jsonDecode(response.body);
        print(jsonString);
        return WareHouseModel.fromJson(jsonString);
      } catch (e) {
        print('Error parsing JSON getWarehouseListApi: $e');
        return null; // Handle JSON parsing error
      }
    } else {
      print('Request failed with status getWarehouseListApi: ${response.statusCode}');
      print('Response body: ${response.body}');
      return null; // Handle HTTP request failure
    }

  }

  static Future<CountryModel?> countryApi() async {
    // var token = Constant.token;
    SharedPreferences pref = await SharedPreferences.getInstance();
    var token = pref.getString('token');
    final response = await http.get(Uri.parse('${BaseUrl}country-list'),
        headers: {
          'authorization': 'Bearer $token'
        },
    );
    if (response.statusCode == 200) {
      try {
        final jsonString = jsonDecode(response.body);
        print(jsonString);
        return CountryModel.fromJson(jsonString);
      } catch (e) {
        print('Error parsing JSON countryApi: $e');
        return null; // Handle JSON parsing error
      }
    } else {
      print('Request failed with status countryApi: ${response.statusCode}');
      print('Response body: ${response.body}');
      return null; // Handle HTTP request failure
    }

  }

  static Future<GetProfileModel?> getProfileApi() async {
    var token = Constant.token;
    final response = await http.get(Uri.parse('${BaseUrl}get-profile'),
        headers: {
          'authorization': 'Bearer $token'
        },
    );
    if (response.statusCode == 200) {
      try {
        final jsonString = jsonDecode(response.body);
        print(jsonString);
        return GetProfileModel.fromJson(jsonString);
      } catch (e) {
        print('Error parsing JSON getProfileApi: $e');
        return null; // Handle JSON parsing error
      }
    } else {
      print('Request failed with status getProfileApi: ${response.statusCode}');
      print('Response body: ${response.body}');
      return null; // Handle HTTP request failure
    }

  }

  static Future<StateModel?> stateApi(String country_id) async {
    var token = Constant.token;
    final response = await http.post(Uri.parse('${BaseUrl}state-list'),
      headers: {
        'authorization': 'Bearer $token'
      },
      body: {
      'country_id': country_id
      }
    );
    if (response.statusCode == 200) {
      try {
        final jsonString = jsonDecode(response.body);
        print(jsonString);
        return StateModel.fromJson(jsonString);
      } catch (e) {
        print('Error parsing JSON stateApi: $e');
        return null; // Handle JSON parsing error
      }
    } else {
      print('Request failed with status stateApi: ${response.statusCode}');
      print('Response body: ${response.body}');
      return null; // Handle HTTP request failure
    }

  }

  static Future<CityModel?> cityApi(String state_id) async {
    var token = Constant.token;
    final response = await http.post(Uri.parse('${BaseUrl}city-list'),
      headers: {
        'authorization': 'Bearer $token'
      },
        body: {
          'state_id': state_id
        }
    );
    if (response.statusCode == 200) {
      try {
        final jsonString = jsonDecode(response.body);
        print(jsonString);
        return CityModel.fromJson(jsonString);
      } catch (e) {
        print('Error parsing JSON cityApi: $e');
        return null; // Handle JSON parsing error
      }
    } else {
      print('Request failed with status cityApi: ${response.statusCode}');
      print('Response body: ${response.body}');
      return null; // Handle HTTP request failure
    }

  }

  static Future<AddShippingAddressModel?> addShippingAddressApi(String address_id, String name, String address, String country, String state, String city, String zip_code, String country_code, String phone, String primary_address,) async {
    var token = Constant.token;
    final response = await http.post(Uri.parse('${BaseUrl}add-update-shipping-address'),
        headers: {
          'authorization': 'Bearer $token'
        },
        body: {
          'address_id': address_id,
          'name': name,
          'address': address,
          'country': country,
          'state': state,
          'city': city,
          'zip_code': zip_code,
          'country_code': country_code,
          'phone': phone,
          'primary_address': primary_address,
        }
    );
    if (response.statusCode == 200) {
      try {
        final jsonString = jsonDecode(response.body);
        print(jsonString);
        return AddShippingAddressModel.fromJson(jsonString);
      } catch (e) {
        print('Error parsing JSON addShippingAddressApi: $e');
        return null; // Handle JSON parsing error
      }
    } else {
      print('Request failed with status addShippingAddressApi: ${response.statusCode}');
      print('Response body: ${response.body}');
      return null; // Handle HTTP request failure
    }

  }

  static Future<DeleteShippingAddressModel?> deleteShippingAddressApi(String address_id,) async {
    var token = Constant.token;
    final response = await http.post(Uri.parse('${BaseUrl}delete-shipping-address'),
        headers: {
          'authorization': 'Bearer $token'
        },
        body: {
          'address_id': address_id,
        }
    );
    if (response.statusCode == 200) {
      try {
        final jsonString = jsonDecode(response.body);
        print(jsonString);
        return DeleteShippingAddressModel.fromJson(jsonString);
      } catch (e) {
        print('Error parsing JSON deleteShippingAddressApi: $e');
        return null; // Handle JSON parsing error
      }
    } else {
      print('Request failed with status deleteShippingAddressApi: ${response.statusCode}');
      print('Response body: ${response.body}');
      return null; // Handle HTTP request failure
    }

  }

}