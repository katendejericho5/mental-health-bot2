// AdHelper.dart
import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/foundation.dart';

class AdHelper {
  static String get rewardedAdUnitId {
    if (kReleaseMode) {
      return 'ca-app-pub-3940256099942544/5224354917';
      //   return 'ca-app-pub-3940256099942544/5224354917';

    } else {
      if (Platform.isAndroid) {
        return 'ca-app-pub-3940256099942544/5224354917';
      } else if (Platform.isIOS) {
        return 'ca-app-pub-6211856036422082/5043916149';
      } else {
        throw UnsupportedError('Unsupported platform');
      }
    }
  }

  static RewardedAd? _rewardedAd;
  static bool _isRewardedAdReady = false;

  static void loadRewardedAd() {
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

  static Future<bool> showRewardedAd(Function onRewarded) async {
    if (!_isRewardedAdReady || _rewardedAd == null) {
      print('Rewarded ad is not ready. Loading status: $_isRewardedAdReady');
      loadRewardedAd(); // Try to load the ad again
      return false;
    }

    var adShown = false;

    await _rewardedAd!.show(
      onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
        print('User earned reward: ${reward.amount} ${reward.type}');
        onRewarded();
        adShown = true;
      },
    );

    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) => print('Ad showed fullscreen content.'),
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        print('Ad dismissed fullscreen content.');
        ad.dispose();
        _isRewardedAdReady = false;
        loadRewardedAd(); // Load a new ad for future use
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        print('Ad failed to show fullscreen content: $error');
        ad.dispose();
        _isRewardedAdReady = false;
        loadRewardedAd(); // Try to load a new ad
      },
    );

    return adShown;
  }
}
