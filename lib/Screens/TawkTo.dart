import 'package:flutter/material.dart';
import 'package:flutter_tawkto/flutter_tawk.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../Constant.dart';

class Tawkto extends StatefulWidget {
  const Tawkto({super.key});

  @override
  State<Tawkto> createState() => _TawktoState();
}

class _TawktoState extends State<Tawkto> {
  bool _isLoading = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Tawk(
              directChatLink: 'https://tawk.to/chat/66d7ee3aea492f34bc0d73ca/1i6tnl5mm',
              visitor: TawkVisitor(
                name: Constant.firstName.toString(),
                email: Constant.email.toString(),
              ),
              onLoad: () {
                setState(() {
                  _isLoading = false; // Set loading to false when Tawk is loaded
                });
                print('Hello Tawk!');
              },
              onLinkTap: (String url) {
                setState(() {
                  _isLoading = false; // Set loading to false when Tawk is loaded
                });
                print(url);
              },
              placeholder: Center(
                child: LoadingAnimationWidget.fourRotatingDots(
                  color: Constant.bgOrangeLite,
                  size: 40,
                ),
              ), // Empty container while loading
            ),
            if (_isLoading) // Show loading animation if still loading
              Center(
                child: LoadingAnimationWidget.fourRotatingDots(
                  color: Constant.bgOrangeLite,
                  size: 40,
                ),
              ),
          ],
        ),
        /*Tawk(
          directChatLink: 'https://tawk.to/chat/66d7ee3aea492f34bc0d73ca/1i6tnl5mm',
          visitor: TawkVisitor(
            name: Constant.firstName.toString(),
            email: Constant.email.toString(),
          ),
          onLoad: () {
            print('Hello Tawk!');
          },
          onLinkTap: (String url) {
            print(url);
          },
          placeholder: Center(
            child: LoadingAnimationWidget.fourRotatingDots(
              color: Constant.bgOrangeLite,
              size: 40,
            ),
          ),
        ),*/
      ),
    );
  }
}
