import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late VideoPlayerController controller;
  late Future<void> initializeVideoPlayerFuture;

  @override
  void initState() {
    loadVideoPlayer();
    super.initState();
  }

  loadVideoPlayer() {
    controller = VideoPlayerController.network(
        'https://www.fluttercampus.com/video.mp4');
    controller.addListener(() {
      setState(() {});
    });
    initializeVideoPlayerFuture = controller.initialize().then((value) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Player in Flutter'),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
      ),
      body: buildVideoPage(context),
    );
  }

  Widget buildVideoPage(context) {
    return FutureBuilder(
        future: initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Container(
                color: Colors.red[100],
                child: Column(children: [
                  SizedBox(height: 35),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: AspectRatio(
                      aspectRatio: controller.value.aspectRatio,
                      child: VideoPlayer(controller),
                    ),
                  ),
                  SizedBox(height: 15),
                  Container(
                    //duration of video
                    child: Text("Total Duration: " +
                        controller.value.duration.toString()),
                  ),
                  SizedBox(height: 5),
                  Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: VideoProgressIndicator(controller,
                          allowScrubbing: true,
                          colors: VideoProgressColors(
                            backgroundColor: Colors.redAccent,
                            playedColor: Colors.green,
                            bufferedColor: Colors.purple,
                          ))),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                            onPressed: () {
                              if (controller.value.isPlaying) {
                                controller.pause();
                              } else {
                                controller.play();
                              }

                              setState(() {});
                            },
                            iconSize: 36,
                            color: Colors.blueAccent,
                            icon: Icon(controller.value.isPlaying
                                ? Icons.pause
                                : Icons.play_arrow)),
                        IconButton(
                          onPressed: () {
                            controller.seekTo(Duration(seconds: 0));

                            setState(() {});
                          },
                          icon: Icon(Icons.stop),
                          iconSize: 36,
                          color: Colors.blueAccent,
                        ),
                      ],
                    ),
                  )
                ]));
          } else {
            return Center(
              child: SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  color: Colors.black,
                  strokeWidth: 7.0,
                ),
              ),
            );
          }
        });
  }
}
