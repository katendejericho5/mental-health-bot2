import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdHelper {
  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-6211856036422082/5043916149';
    } else if (Platform.isIOS) {
      return '<YOUR_IOS_REWARDED_AD_UNIT_ID>';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static RewardedAd? _rewardedAd;
  static bool _isRewardedAdReady = false;

  static loadRewardedAd() {
    RewardedAd.load(
      adUnitId: rewardedAdUnitId,
      request: AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          print('Rewarded ad loaded successfully');
          _rewardedAd = ad;
          _isRewardedAdReady = true;
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('Failed to load rewarded ad: $error');
          _isRewardedAdReady = false;
          // Retry loading the ad after a delay
          Future.delayed(Duration(minutes: 1), loadRewardedAd);
        },
      ),
    );
  }

  static Future<void> showRewardedAd(Function onRewarded) async {
    if (!_isRewardedAdReady || _rewardedAd == null) {
      print('Rewarded ad is not ready.');
      await loadRewardedAd();
      return;
    }

    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) =>
          print('Ad showed fullscreen content.'),
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        print('Ad dismissed fullscreen content.');
        ad.dispose();
        loadRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        print('Ad failed to show fullscreen content: $error');
        ad.dispose();
        loadRewardedAd();
      },
    );

    await _rewardedAd!.show(
      onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
        print('User earned reward: ${reward.amount} ${reward.type}');
        onRewarded();
      },
    );
  }
}
