import 'dart:io';
import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeech {
  final FlutterTts flutterTts = FlutterTts();
  TextToSpeech() {
    initTts();
  }
  Future<void> initTts() async {
    await flutterTts.setLanguage("zh-CN"); // 设置语言为中文
    await flutterTts.setPitch(1.0); // 设置音调
    await flutterTts.setSpeechRate(0.5); // 设置语速
    await flutterTts.setSharedInstance(true);

    if (Platform.isIOS) {
      await flutterTts.setIosAudioCategory(
        IosTextToSpeechAudioCategory.playback,
        [
          IosTextToSpeechAudioCategoryOptions.allowBluetooth,
          IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
          IosTextToSpeechAudioCategoryOptions.mixWithOthers,
          IosTextToSpeechAudioCategoryOptions.defaultToSpeaker
        ],
        IosTextToSpeechAudioMode.defaultMode,
      );
    }
  }

  Future<void> speak(String text) async {
    await flutterTts.speak(text);
  }

  Future<void> stop() async {
    await flutterTts.stop();
  }
}
