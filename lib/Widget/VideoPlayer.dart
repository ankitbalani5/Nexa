import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerWidget({Key? key, required this.videoUrl}) : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> with WidgetsBindingObserver {
  // late VideoPlayerController _controller;
  late VideoPlayerController _videoPlayerController;
  late Future<void> _initializeVideoPlayerFuture;
  bool isPlaying = false;
  bool isMuted = false;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
    _initializeVideoPlayerFuture = _videoPlayerController.initialize().then((_) {
      // _videoPlayerController.setLooping(true);
      setState(() {

      });
    },);
    WidgetsBinding.instance.addObserver(this);
  }
  @override
  void dispose() {
    // Remove the observer
    WidgetsBinding.instance.removeObserver(this);
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // Pause the video and mute the audio when the app is paused
      _videoPlayerController.pause();
      _videoPlayerController.setVolume(0.0);
      isPlaying = false;
      isMuted = true;
      setState(() {});
    }
  }
  // @override
  // void dispose() {
  //   _videoPlayerController.dispose();
  //   super.dispose();
  // }
  //
  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   final visibility = context.findRenderObject()?.paintBounds;
  //
  //   if (visibility != null && visibility.isEmpty) {
  //     _videoPlayerController.pause();
  //     _videoPlayerController.dispose();
  //     _videoPlayerController.setVolume(0.0);
  //   } /*else {
  //     _videoPlayerController.play();
  //   }*/
  // }

  void _togglePlayPause() {
    setState(() {
      if (isPlaying == true) {
        _videoPlayerController.pause();
        isPlaying = false;
      } else {
        _videoPlayerController.play();
        isPlaying = true;
      }
    });
  }

  void _toggleMute() {
    setState(() {
      if (isMuted) {
        _videoPlayerController.setVolume(1.0);
      } else {
        _videoPlayerController.setVolume(0.0);
      }
      isMuted = !isMuted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.done){
            return Stack(
              // alignment: Alignment.bottomCenter,
              children: [
                Positioned(
                  top: 0,
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: GestureDetector(
                    // onTap: _togglePlayPause,
                    child: AspectRatio(
                      aspectRatio: _videoPlayerController.value.aspectRatio,
                      child: VideoPlayer(_videoPlayerController),
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: GestureDetector(
                  onTap: _toggleMute,
                  child: Icon(
                    isMuted ? Icons.volume_off : Icons.volume_up,
                  color: Colors.white, size: 12,
                  ),
                  )
                  // IconButton(
                  //   onPressed: _toggleMute,
                  //   icon: Icon(
                  //     isMuted ? Icons.volume_off : Icons.volume_up,
                  //     color: Colors.white, size: 10,
                  //   ),
                  // ),
                ),
                Positioned(
                  top: 0,
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: GestureDetector(
                  onTap: _togglePlayPause,
                    child: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white, size: 20,
                    ),
                  )
                  // child: Icon(
                  //   isPlaying ? Icons.pause : Icons.play_arrow,
                  //   color: Colors.white, size: 15,
                  // ),
                ),
              ],
            );
          }else{
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
    );
    /*_controller.value.isInitialized
        ? AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: VideoPlayer(_controller),
    )
        : Center(child: CircularProgressIndicator());*/
  }
}
