// lib/src/services/voice_service.dart
import 'dart:async'; // Add this line
import 'package:speech_to_text/speech_to_text.dart' as stt;

class VoiceService {
  final stt.SpeechToText _speech = stt.SpeechToText();

  Future<String?> listen() async {
    bool available = await _speech.initialize(
      onStatus: (status) {
        // Optionally handle status changes
        print('Speech Status: $status');
      },
      onError: (errorNotification) {
        // Optionally handle errors
        print('Speech Error: ${errorNotification.errorMsg}');
      },
    );
    if (!available) return null;

    final completer = Completer<String?>(); // Now defined

    _speech.listen(onResult: (result) {
      if (result.finalResult) {
        completer.complete(result.recognizedWords);
        _speech.stop();
      }
    });

    // Set a timeout for listening
    Future.delayed(const Duration(seconds: 5)).then((_) {
      if (!_speech.isListening) return;
      completer.complete(_speech.lastRecognizedWords.isNotEmpty ? _speech.lastRecognizedWords : null);
      _speech.stop();
    });

    return completer.future;
  }
}
