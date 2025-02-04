
import "package:flutter/material.dart";
import "package:lottie/lottie.dart";
import "package:speedometer/helper/app_colors.dart";
import "package:speedometer/helper/dimension.dart";


class LoadingFail extends StatelessWidget {
  LoadingFail({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Dimensions.screenHeight - Dimensions.size100 * 3,
      width: Dimensions.screenWidth,
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.size20,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            "assets/lottie/loading_fail.json",
            frameRate: FrameRate(60),
            width: Dimensions.size100 * 3,
            repeat: true,
          ),
          Text(
            "Gagal memuat data",
            style: TextStyle(
              fontSize: Dimensions.text24,
              fontWeight: FontWeight.bold,
              color: AppColors.onBackground(),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: Dimensions.size10,
          ),
          Text(
            "Silahkan swipe ke bawah untuk memuat ulang",
            style: TextStyle(
              fontSize: Dimensions.text16,
              color: AppColors.onBackground(),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
