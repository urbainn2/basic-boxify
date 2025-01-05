import 'package:flutter_test/flutter_test.dart';
import 'package:boxify/app_core.dart';

void main() {
  group('Playlist', () {
    test('should be equal if all properties are equal', () {
      final playlist1 = Playlist(id: '123', name: 'Test Playlist');
      final playlist2 = Playlist(id: '123', name: 'Test Playlist');

      expect(playlist1, equals(playlist2));
    });

    test('copyWith should override values', () {
      final playlist = Playlist(id: '123', name: 'Test Playlist');
      final updatedPlaylist = playlist.copyWith(name: 'Updated Playlist');

      expect(updatedPlaylist.name, 'Updated Playlist');
    });

    // More tests...
  });
}
