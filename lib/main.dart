import 'dart:async';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // List of image URLs
  List<String> imageUrls = [
    "assets/cover.jpg",
  /*   "assets/cover1.jpg",
    "assets/cover2.jpg",
    "assets/cover3.jpg",
    "assets/cover5.jpg", */
    // Add more image URLs as needed
  ];

  int currentImageIndex = 0;
  bool isPlaying = false;
  double value = 0;
  final player = AudioPlayer();
  Duration? duration;

  void initPlayer() async {
    await player.setSource(AssetSource("music.mp3"));
    duration = await player.getDuration();
  }

  void changeImageAutomatically() {
    const int durationInSeconds = 5;

    Timer.periodic(Duration(seconds: durationInSeconds), (timer) {
      setState(() {
        currentImageIndex = (currentImageIndex + 1) % imageUrls.length;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    initPlayer();
    changeImageAutomatically();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            constraints: BoxConstraints.expand(),
            height: 300.0,
            width: 300.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(imageUrls[currentImageIndex]),
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 28, sigmaY: 28),
              child: Container(
                color: Colors.black.withOpacity(0.6),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //setting the music cover
              ClipRRect(
                borderRadius: BorderRadius.circular(30.0),
                child: Image.asset(
                  imageUrls[currentImageIndex],
                  width: 250.0,
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              const Text(
                "happy Mother's Day",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  letterSpacing: 6,
                ),
              ),
              //Setting the seekbar
              const SizedBox(
                height: 50.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${(value / 60).floor()}: ${(value % 60).floor()}",
                    style: TextStyle(color: Colors.white),
                  ),
                  Container(
                    width: 260.0,
                    child: Slider.adaptive(
                      onChangeEnd: (new_value) async {
                        setState(() {
                          value = new_value;
                          print(new_value);
                        });
                        await player.seek(Duration(seconds: new_value.toInt()));
                      },
                      min: 0.0,
                      value: value,
                      max: 214.0,
                      onChanged: (new_value) {
                        setState(() {
                          value = new_value;
                        });
                      },
                      activeColor: Colors.white,
                    ),
                  ),
                  Text(
                    "${duration != null ? duration!.inMinutes : 0} : ${(duration != null ? duration!.inSeconds : 0) % 60}",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              //setting the player controller
              const SizedBox(
                height: 60.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(60.0),
                      color: Color.fromARGB(221, 255, 255, 255),
                      border: Border.all(color: Color.fromARGB(96, 255, 255, 255)),
                    ),
                    width: 50.0,
                    height: 50.0,
                    child: InkWell(
                      onTapDown: (details) {
                        player.setPlaybackRate(0.5);
                      },
                      onTapUp: (details) {
                        player.setPlaybackRate(1);
                      },
                      child: const Center(
                        child: Icon(
                          Icons.fast_rewind_rounded,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(60.0),
                      color: Color.fromARGB(221, 255, 255, 255),
                      border: Border.all(color: Color.fromARGB(255, 255, 0, 0)),
                    ),
                    width: 60.0,
                    height: 60.0,
                    child: InkWell(
                      onTap: () async {
                        await player.resume();
                        player.onPositionChanged.listen(
                          (Duration d) {
                            setState(() {
                              value = d.inSeconds.toDouble();
                              print(value);
                            });
                          },
                        );
                        print(duration);
                      },
                      child: const Center(
                        child: Icon(
                          Icons.play_arrow,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(60.0),
                      color: Color.fromARGB(221, 255, 255, 255),
                      border: Border.all(color: Color.fromARGB(97, 255, 255, 255)),
                    ),
                    width: 50.0,
                    height: 50.0,
                    child: InkWell(
                      onTapDown: (details) {
                        player.setPlaybackRate(2);
                      },
                      onTapUp: (details) {
                        player.setPlaybackRate(1);
                      },
                      child: const Center(
                        child: Icon(
                          Icons.fast_forward_rounded,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
