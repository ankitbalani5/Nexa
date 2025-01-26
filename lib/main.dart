import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:nexa/Bloc/AddShippingAddressBloc/add_shipping_address_bloc.dart';
import 'package:nexa/Bloc/AllShippingAddressBloc/all_shipping_address_bloc.dart';
import 'package:nexa/Bloc/CartProductsBloc/cart_products_bloc.dart';
import 'package:nexa/Bloc/CategoryWiseProduct/category_wise_product_bloc.dart';
import 'package:nexa/Bloc/CountryBloc/country_bloc.dart';
import 'package:nexa/Bloc/CreateOrUpdateProfileBloc/create_or_update_profile_bloc.dart';
import 'package:nexa/Bloc/CustomerExistingBloc/customer_existing_bloc.dart';
import 'package:nexa/Bloc/CustomerRegisterOrLoginBloc/customer_register_or_login_bloc.dart';
import 'package:nexa/Bloc/CustomerSupportBloc/customer_support_bloc.dart';
import 'package:nexa/Bloc/HomeBloc/home_bloc.dart';
import 'package:nexa/Bloc/LoginBloc/login_bloc.dart';
import 'package:nexa/Bloc/NotificationBloc/notification_bloc.dart';
import 'package:nexa/Bloc/OtpVerifyEmailBloc/otp_verify_email_bloc.dart';
import 'package:nexa/Bloc/OtpVerifyForgotPasswordBloc/otp_verify_forgot_password_bloc.dart';
import 'package:nexa/Bloc/ResetPasswordBloc/reset_password_bloc.dart';
import 'package:nexa/Bloc/ReviewHelpfulBloc/review_helpful_bloc.dart';
import 'package:nexa/Bloc/VerifyEmailBloc/verify_email_bloc.dart';
import 'package:nexa/Bloc/get_coupon_model_bloc.dart';
import 'package:nexa/CurrencyConverterScreen.dart';
import 'package:nexa/Screens/AddReview.dart';
import 'package:nexa/Screens/BottomScreens/Cart/Checkout.dart';
import 'package:nexa/Screens/BottomScreens/home/AllProducts.dart';
import 'package:nexa/Screens/BottomScreens/home/ProductDetails.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Bloc/AllProductBloc/all_product_bloc.dart';
import 'Bloc/AllWishlistBloc/all_wishlist_bloc.dart';
import 'Bloc/ApplyCouponBloc/apply_coupon_bloc.dart';
import 'Bloc/BrandBloc/brand_bloc.dart';
import 'Bloc/CancelOrderBloc/cancel_order_bloc.dart';
import 'Bloc/CategoryBloc/category_bloc.dart';
import 'Bloc/CityBloc/city_bloc.dart';
import 'Bloc/CountdownBloc/countdown_bloc.dart';
import 'Bloc/ForgotPasswordBloc/forgot_password_bloc.dart';
import 'Bloc/OrderListBloc/order_list_bloc.dart';
import 'Bloc/PlaceOrderBloc/place_order_bloc.dart';
import 'Bloc/ProductReviewBloc/product_review_bloc.dart';
import 'Bloc/ReOrderBloc/re_order_bloc.dart';
import 'Bloc/SingleProductBloc/single_product_bloc.dart';
import 'Bloc/StateBloc/state_bloc.dart';
import 'Bloc/SubCategoryBloc/sub_category_bloc.dart';
import 'Bloc/SuggestionBloc/suggestion_bloc.dart';
import 'Constant.dart';
import 'NavBar.dart';
import 'PushNotification/push_notification_service.dart';
import 'Screens/SplashScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:app_links/app_links.dart';


import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize the notification service after Firebase has been initialized
  FireBaseNotification notificationService = FireBaseNotification();
  await notificationService.initializeNotification();

  //Assign publishable key to flutter_stripe
  Stripe.publishableKey = Constant.publishableKey;

  //Load our .env file that contains our Stripe Secret key
  await dotenv.load(fileName: "assets/.env");

  await InAppWebViewController.setWebContentsDebuggingEnabled(true);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white, // navigation bar color
        statusBarColor: Colors.white, // status bar color
      ));

  // Request notification permissions (especially important for iOS)
  // await _requestNotificationPermissions();

  // Fetch and print the FCM token
  Constant.fcmToken = await FirebaseMessaging.instance.getToken();
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.setString('fcmToken', Constant.fcmToken);
  print("FCM Token: ${Constant.fcmToken}");


  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  String? productId;
  // This widget is the root of your application.
  late AppLinks _appLinks;
  Uri? _initialUri;
  var uriPath;

  @override
  void initState() {
    super.initState();
    _appLinks = AppLinks();
    _setupDeepLinkListener();
  }

  void _setupDeepLinkListener() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool('deepLink', false);
    // Get the initial deep link if the app was opened using one
    try {
      _initialUri = await _appLinks.getInitialLink();
      if (_initialUri != null) {
        _handleDeepLink(_initialUri!);
      }
    } catch (e) {
      print("Error getting initial app link: $e");
    }

    // Listen for deep links while the app is running
    _appLinks.uriLinkStream.listen((Uri uri) {
      _handleDeepLink(uri);
    }, onError: (err) {
      print("Error listening to deep link stream: $err");
    });
  }

  Future<void> _handleDeepLink(Uri uri) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var token = pref.getString('token');
    // Handle the deep link based on the URI
    print("Received deep link: $uri");
    print("Received URI path: ${uri.path}");
    uriPath = uri.path;

    // Here, you can navigate to different screens based on the URI path
    if (uri.path == '/nexa/productDetails') {
      WidgetsBinding.instance.addPostFrameCallback((_) {

        print('iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii');
        print('token;;;------------------------------------------------------------------$token');
        if(token != null){
          print('token::::::$token');
          pref.setBool('deepLink', true);
        productId = uri.queryParameters['productId'];
        print('productId:::: ${productId}');
        _navigatorKey.currentState?.pushNamedAndRemoveUntil('/productDetails'/*, arguments: productId*/, (Route<dynamic> route) => false,);

        }
      });
    }
    /*else if (uri.path == '/add-review') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AddReview()),
      );
    }*/
    // Add other paths as needed
  }
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<LoginBloc>(create: (context) => LoginBloc(),),
          BlocProvider<HomeBloc>(create: (context) => HomeBloc(),),
          BlocProvider<BrandBloc>(create: (context) => BrandBloc(),),
          BlocProvider<ForgotPasswordBloc>(create: (context) => ForgotPasswordBloc(),),
          BlocProvider<CreateOrUpdateProfileBloc>(create: (context) => CreateOrUpdateProfileBloc(),),
          BlocProvider<OtpVerifyForgotPasswordBloc>(create: (context) => OtpVerifyForgotPasswordBloc(),),
          BlocProvider<ResetPasswordBloc>(create: (context) => ResetPasswordBloc(),),
          BlocProvider<CategoryBloc>(create: (context) => CategoryBloc(),),
          BlocProvider<CountryBloc>(create: (context) => CountryBloc(),),
          BlocProvider<StateBloc>(create: (context) => StateBloc(),),
          BlocProvider<CityBloc>(create: (context) => CityBloc(),),
          BlocProvider<AddShippingAddressBloc>(create: (context) => AddShippingAddressBloc(),),
          BlocProvider<AllWishlistBloc>(create: (context) => AllWishlistBloc(),),
          BlocProvider<AllProductBloc>(create: (context) => AllProductBloc(),),
          BlocProvider<SingleProductBloc>(create: (context) => SingleProductBloc(),),
          BlocProvider<AllShippingAddressBloc>(create: (context) => AllShippingAddressBloc(),),
          BlocProvider<CustomerSupportBloc>(create: (context) => CustomerSupportBloc(),),
          BlocProvider<CartProductsBloc>(create: (context) => CartProductsBloc(),),
          BlocProvider<CustomerExistingBloc>(create: (context) => CustomerExistingBloc(),),
          BlocProvider<CustomerRegisterOrLoginBloc>(create: (context) => CustomerRegisterOrLoginBloc(),),
          BlocProvider<GetCouponModelBloc>(create: (context) => GetCouponModelBloc(),),
          BlocProvider<CategoryWiseProductBloc>(create: (context) => CategoryWiseProductBloc(),),
          BlocProvider<PlaceOrderBloc>(create: (context) => PlaceOrderBloc(),),
          BlocProvider<ApplyCouponBloc>(create: (context) => ApplyCouponBloc(),),
          BlocProvider<VerifyEmailBloc>(create: (context) => VerifyEmailBloc(),),
          BlocProvider<OtpVerifyEmailBloc>(create: (context) => OtpVerifyEmailBloc(),),
          BlocProvider<SubCategoryBloc>(create: (context) => SubCategoryBloc(),),
          BlocProvider<OrderListBloc>(create: (context) => OrderListBloc(),),
          BlocProvider<SuggestionBloc>(create: (context) => SuggestionBloc(),),
          BlocProvider<ReOrderBloc>(create: (context) => ReOrderBloc(),),
          BlocProvider<CancelOrderBloc>(create: (context) => CancelOrderBloc(),),
          BlocProvider<ProductReviewBloc>(create: (context) => ProductReviewBloc(),),
          BlocProvider<ReviewHelpfulBloc>(create: (context) => ReviewHelpfulBloc(),),
          BlocProvider<NotificationBloc>(create: (context) => NotificationBloc(),),
          BlocProvider<CountdownBloc>(create: (context) => CountdownBloc(),),
        ],
        child: MaterialApp(
          navigatorKey: _navigatorKey,
          debugShowCheckedModeBanner: false,
          title: 'Nexa',
          theme: ThemeData(
            fontFamily: 'Roboto',
            primaryColor: Colors.white, // Set the primary color to white
            scaffoldBackgroundColor: Colors.white, // Set the background color to white
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.white, // Use white as the seed color
              brightness: Brightness.light, // Ensure it's a light theme
            ),
            useMaterial3: true,
            // Optional: Set app bar theme and other component themes if needed
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.white, // AppBar background color
              iconTheme: IconThemeData(color: Colors.black), // AppBar icons color
              titleTextStyle: TextStyle(color: Colors.black, fontSize: 20), // AppBar title text color
            ),
          ),
          routes: {
            '/': (context) => CurrencyConverterScreen()/*SplashScreen(uriPath, _navigatorKey)*/,
            '/productDetails': (context) => ProductDetails('splash', productId.toString()), // Named route for AllProducts page
            // Add other routes as needed
          },
          initialRoute: '/',
          /*ThemeData(
            fontFamily: 'Roboto',
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.white, ),

            useMaterial3: true,
          ),*/
          // home: const /*AddReview()*//*Checkout()*/SplashScreen(),
        )
    );

  }
}

