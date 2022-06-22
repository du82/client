import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:wordpress_app/config/config.dart';

class LocalVideoPlayer extends StatefulWidget {
  const LocalVideoPlayer({Key? key, required this.videoUrl}) : super(key: key);

  final String videoUrl;

  @override
  _LocalVideoPlayerState createState() => _LocalVideoPlayerState();
}

class _LocalVideoPlayerState extends State<LocalVideoPlayer> {
  late BetterPlayerController _betterPlayerController;

  @override
  void initState() {
    super.initState();
    BetterPlayerDataSource betterPlayerDataSource = BetterPlayerDataSource(BetterPlayerDataSourceType.network, widget.videoUrl);
    _betterPlayerController = BetterPlayerController(

      BetterPlayerConfiguration(
          deviceOrientationsAfterFullScreen: const [DeviceOrientation.portraitUp],
          aspectRatio: 16/9,
          controlsConfiguration: BetterPlayerControlsConfiguration(
            enableSkips: true,
            enablePip: true,
            enableOverflowMenu: true,
            enableMute: true,
            enableFullscreen: true,
            enablePlayPause: false,
            playIcon: Feather.play,
            pauseIcon: Feather.pause,
            fullscreenEnableIcon: Feather.maximize,
            fullscreenDisableIcon: Feather.minimize,
            muteIcon: Feather.volume_2,
            unMuteIcon: Feather.volume_x,
            progressBarPlayedColor: Config().appThemeColor,
          )
      ),
      betterPlayerDataSource: betterPlayerDataSource,

    );
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
        aspectRatio: 16 / 9,
        child: BetterPlayer(
          controller: _betterPlayerController,
        )
    );
  }
}
