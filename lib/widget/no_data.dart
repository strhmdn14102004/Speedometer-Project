
import "package:flutter/material.dart";
import "package:lottie/lottie.dart";
import "package:weather_sasat/helper/app_colors.dart";
import "package:weather_sasat/helper/dimension.dart";


class NoData extends StatelessWidget {
  NoData({
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
            "assets/lottie/no_data.json",
            frameRate: FrameRate(60),
            width: Dimensions.size100 * 3,
            repeat: true,
          ),
          Text(
            "Tidak ada data",
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
            "Data mungkin saja memang tidak ada atau silahkan lakukan pencarian data menggunakan kata pencarian dan periode yang berbeda",
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
