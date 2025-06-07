import 'package:audioplayers/audioplayers.dart';

class AudioPlayerService {
  final AudioPlayer _player = AudioPlayer();

  /// Plays an asset audio file.
  Future<void> playAsset(String assetPath) async {
    await _stopIfPlaying();
    await _player.play(AssetSource(assetPath));
  }

  /// Plays audio from a network URL.
  Future<void> playUrl(String url) async {
    await _stopIfPlaying();
    await _player.play(UrlSource(url));
  }

  /// Pauses playback.
  Future<void> pause() async => await _player.pause();

  /// Resumes playback.
  Future<void> resume() async => await _player.resume();

  /// Stops playback.
  Future<void> stop() async => await _player.stop();

  /// Whether audio is currently playing.
  bool isPlaying() => _player.state == PlayerState.playing;

  /// Dispose the player when done.
  Future<void> dispose() async => await _player.dispose();

  Future<void> _stopIfPlaying() async {
    final state = _player.state;
    if (state == PlayerState.playing || state == PlayerState.paused) {
      await _player.stop();
    }
  }

  /// Optional: access to the underlying player if needed.
  AudioPlayer get player => _player;
}
