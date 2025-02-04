
import "package:flutter/material.dart";
import "package:lottie/lottie.dart";
import "package:weather_sasat/helper/dimension.dart";
import "package:weather_sasat/helper/navigator.dart";


class SuccessOverlay extends ModalRoute<void> {
  final String message;

  SuccessOverlay({
    required this.message,
  });

  @override
  Duration get transitionDuration => const Duration(milliseconds: 500);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => true;

  @override
  Color get barrierColor => Colors.black.withOpacity(0.8);

  @override
  String get barrierLabel => "null";

  @override
  bool get maintainState => true;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation,) {
    return Material(
      type: MaterialType.transparency,
      child: SafeArea(
        child: _buildOverlayContent(context),
      ),
    );
  }

  Widget _buildOverlayContent(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(Dimensions.size20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Lottie.asset(
              "assets/lottie/success.json",
              frameRate: FrameRate(60),
              width: Dimensions.size100 * 2,
              repeat: true,
            ),
            SizedBox(
              height: Dimensions.size50,
            ),
            Text(
              message,
              style: TextStyle(
                fontSize: Dimensions.text20,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: Dimensions.size50,
            ),
            IconButton(
              onPressed: () {
                Navigators.pop(context);
              },
              iconSize: Dimensions.size40,
              color: Colors.white,
              icon: const Icon(
                Icons.cancel_outlined,
              ),
            ),
            Text(
              "Tutup",
              style: TextStyle(
                fontSize: Dimensions.text16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child,) {
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: animation,
        child: child,
      ),
    );
  }
}