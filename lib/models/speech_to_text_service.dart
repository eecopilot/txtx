import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

final speechToTextServiceProvider = Provider((ref) => SpeechToTextService());

class SpeechToTextService {
  final SpeechToText _speechToText = SpeechToText();
  // SpeechToTextService() {
  //   initialize();
  // }
  Future<void> initialize() async {
    await _speechToText.initialize();
  }

  Future<void> startListening(
      void Function(SpeechRecognitionResult) onResult) async {
    await _speechToText.listen(
      onResult: onResult,
      localeId: 'zh-CN',
      // pauseFor: const Duration(seconds: 3),
      // listenOptions: SpeechListenOptions(
      //   partialResults: false,
      // ),
    );
  }

  Future<void> stopListening() async {
    await _speechToText.stop();
  }

  Future<bool> hasPermission() async {
    return await _speechToText.hasPermission;
  }
}
