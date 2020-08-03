import 'dart:async';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:audioplayers/audio_cache.dart';

void main() => runApp(VideoPlayerApp());

class VideoPlayerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Video Player Demo',
      home: VideoPlayerScreen(),
    );
  }
}

img() {
  var assetimg = AssetImage("images/music2.jpg");
  return assetimg;
}
voice() async {

  final assetsAudioPlayer = AssetsAudioPlayer();

try {
    await assetsAudioPlayer.open(
        Audio.network("http://www.mysite.com/myMp3file.mp3"),
    );
} catch (t) {
 return assetsAudioPlayer;  
}
}



class VideoPlayerScreen extends StatefulWidget {
  VideoPlayerScreen({Key key}) : super(key: key);
  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;
  @override
  void initState() {
    
    _controller = VideoPlayerController.network(
      'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
    );
    // Initialize the controller and store the Future for later use.
    _initializeVideoPlayerFuture = _controller.initialize();
    // Use the controller to loop the video.
    _controller.setLooping(true);
    super.initState();
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.shade100,
      appBar: AppBar(
        backgroundColor: Colors.redAccent.shade400,
        title: Text('Media Player'),
        leading: Icon(Icons.menu),
        actions: <Widget>[
          Icon(Icons.search),
          Text(" "),
        ],
      ),
      // Use a FutureBuilder to display a loading spinner while waiting for the
      // VideoPlayerController to finish initializing.
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 250,
              margin: EdgeInsets.all(40),
              child: FutureBuilder(
                future: _initializeVideoPlayerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    // If the VideoPlayerController has finished initialization, use
                    // the data it provides to limit the aspect ratio of the video.
                    return AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      // Use the VideoPlayer widget to display the video.
                      child: VideoPlayer(_controller),
                    );
                  } else {
                    // If the VideoPlayerController is still initializing, show a
                    // loading spinner.
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
             Divider(thickness: 2, color: Colors.redAccent.shade400,indent: 10,endIndent: 10,),
            
            Stack(
              children: <Widget>[
                Card(
                  color: Colors.redAccent.shade400,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  elevation: 30,
                  
                  child: Container(
                    width: 250,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.redAccent.shade400,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    margin: EdgeInsets.all(20),
                    child: Row(children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.pause),
                        onPressed: () {
                          var audio = AudioCache();
                          audio.play("audio1.mp3");
                        },
                        iconSize: 50,
                        padding: EdgeInsets.only(left: 60, top: 20),
                      ),
                      IconButton(
                        icon: Icon(Icons.play_arrow),
                        onPressed: () {
                          var audio = AudioCache();
                          audio.play("audio1.mp3");
                        },
                        iconSize: 50,
                        padding: EdgeInsets.only(top: 20),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.stop,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          var audio = AudioCache();
                          audio.play("audio1.mp3");
                        },
                        iconSize: 50,
                        padding: EdgeInsets.only(right: 20, top: 20),
                        color: Colors.black,
                      ),
                    ]),
                  ),
                ),
                
                 
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: img(),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(40),
                    border:
                        Border.all(color: Colors.redAccent.shade400, width: 5),
                  ),
                )
              ],
            ),
           Text(" "),
           
          Text("The above widget plays song from the local system",style: TextStyle(fontWeight: FontWeight.bold,fontSize:15),),
            Divider(thickness: 2, color: Colors.redAccent.shade400,indent: 10,endIndent: 10,),
            Card(
              shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
              margin: EdgeInsets.all(20),
              color: Colors.redAccent.shade400,
              elevation: 10,
              child: IconButton(icon: Icon(Icons.play_arrow), onPressed:  () {
                         voice();
                        } ,color: Colors.black,)
            ),
            Text("The above Button plays song from the internet",style: TextStyle(fontWeight: FontWeight.bold,fontSize:15 ),),
          Text(" "),
         
           Divider(thickness: 2, color: Colors.redAccent.shade400,indent: 10,endIndent: 10,),
          Text("This Button plays Video ---> ",style: TextStyle(fontWeight: FontWeight.bold,fontSize:15 ),),
          ],
          
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.redAccent.shade400,
        onPressed: () {
          // Wrap the play or pause in a call to `setState`. This ensures the
          // correct icon is shown.
          setState(() {
            // If the video is playing, pause it.
            if (_controller.value.isPlaying) {
              _controller.pause();
            } else {
              // If the video is paused, play it.
              _controller.play();
            }
          });
        },
        // Display the correct icon depending on the state of the player.
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
