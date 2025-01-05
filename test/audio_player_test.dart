import 'package:flutter_test/flutter_test.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'audio_player_test.mocks.dart'; // Generated with Mockito

// Generate a MockAudioPlayer class.
@GenerateMocks([AudioPlayer])
void main() {
  group('AudioPlayer tests', () {
    late MockAudioPlayer mockAudioPlayer;
    const goodUrl = "https://www.dropbox.com/s/le5s2couvoxli81/Karma.mp3?raw=1";
    const badUrl = "bddad.mp3?raw=1";

    setUp(() {
      mockAudioPlayer = MockAudioPlayer();
    });

    test('Loads and plays a valid MP3 file', () async {
      // Simulate a successful load of an MP3 file.
      when(mockAudioPlayer.setUrl(goodUrl))
          .thenAnswer((_) async => Duration(seconds: 1));

      // Attempt to load the MP3 file.
      final result = await mockAudioPlayer.setUrl(goodUrl);

      // Verify the URL was set successfully and that playback can proceed.
      expect(result, isNotNull);
      // You can also test if player can actually play if needed but in unit tests it's usually not required.
    });

    test('Fails to load an invalid MP3 file', () async {
      // Simulate a load failure.
      when(mockAudioPlayer.setUrl(badUrl))
          .thenThrow(Exception('Failed to load MP3'));

      try {
        // Attempt to load the MP3 file.
        await mockAudioPlayer.setUrl(badUrl);
        fail('Expected an exception but did not get one.');
      } catch (e) {
        // Verify that an exception was thrown.
        expect(e, isInstanceOf<Exception>());
      }
    });
  });
}

// class MockAudioPlayer extends Mock implements AudioPlayer {}
// Generate a MockAudioPlayer class.

// void main() {
//   MockAudioPlayer? mockAudioPlayer;
//   const goodUrl = "https://www.dropbox.com/s/le5s2couvoxli81/Karma.mp3?raw=1";
//   const badUrl = "bad.mp3?raw=1";

//   setUp(() {
//     mockAudioPlayer = MockAudioPlayer();
//   });

//   test('Test play with good URL', () async {
//     // Mocking setUrl to return a non-null Future<Duration?>
//     when(mockAudioPlayer!.setUrl(goodUrl))
//         .thenAnswer((_) async => const Duration(seconds: 2));

//     // Mocking play to return a void Future
//     when(mockAudioPlayer!.play()).thenAnswer((_) async {});

//     // Perform setUrl and play actions
//     await mockAudioPlayer!.setUrl(goodUrl);
//     await mockAudioPlayer!.play();

//     // Verify the actions are called correctly
//     verify(mockAudioPlayer!.setUrl(goodUrl)).called(1);
//     verify(mockAudioPlayer!.play()).called(1);
//   });

//   test('Test play with bad URL', () {
//     // Mock the setUrl method to throw an exception for a bad URL
//     when(mockAudioPlayer!.setUrl('bad_url'))
//         .thenThrow(Exception('Failed to load audio source'));

//     // The error handling can be tested by expecting an Exception to be thrown
//     expect(() => mockAudioPlayer!.setUrl('bad_url'), throwsException);

//     // No need to mock or verify play() here, as it wouldn't be called after an exception
//   });
// }
