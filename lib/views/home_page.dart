import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:speech_to_text/speech_to_text.dart';

class HomePage extends StatefulWidget {


   HomePage({ Key? key }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
 late SpeechToText _speech;

 late bool isListening;

 late String text;

 late double con = 1.0;

 final Map<String, HighlightedWord> high = {
    'flutter': HighlightedWord(
      onTap: () => print('flutter'),
      textStyle: const TextStyle(
        color: Colors.blue,
        fontWeight: FontWeight.bold,
      ),
    ),
    'voice': HighlightedWord(
      onTap: () => print('voice'),
      textStyle: const TextStyle(
        color: Colors.green,
        fontWeight: FontWeight.bold,
      ),
    ),
    'subscribe': HighlightedWord(
      onTap: () => print('subscribe'),
      textStyle: const TextStyle(
        color: Colors.red,
        fontWeight: FontWeight.bold,
      ),
    ),
    'like': HighlightedWord(
      onTap: () => print('like'),
      textStyle: const TextStyle(
        color: Colors.blueAccent,
        fontWeight: FontWeight.bold,
      ),
    ),
    'comment': HighlightedWord(
      onTap: () => print('comment'),
      textStyle: const TextStyle(
        color: Colors.green,
        fontWeight: FontWeight.bold,
      ),
    ),
  };

  @override
  void initState() {
    _speech = SpeechToText();
    super.initState() ;
    
  }

  void listen() async{
    if(isListening){
      bool avail = await _speech.initialize(
        onStatus: (val)=>print('onStatus $val'),
        onError: (val)=>print('onError $val')
      );
      if(avail){
        setState(()=>isListening = true);
        _speech.listen(
          onResult: (val)=>setState(() {
            text = val.recognizedWords;
            if(val.hasConfidenceRating && val.confidence>0){
              con = val.confidence;
            }
          })
        );
        
      }else{
        setState(() {
          isListening=false;
        });
        _speech.stop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confidence: ${(con * 100).toStringAsFixed(1)}%'),

      ),
      body:SingleChildScrollView(
        reverse: true,
        child: Container(
          padding: EdgeInsets.fromLTRB(30, 30, 30, 15),
          child: TextHighlight(text: text, words: high,textStyle: TextStyle(fontSize: 32,color: Colors.black,fontWeight: FontWeight.w400),),
        ),
      ) ,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: isListening,
        glowColor: Theme.of(context).primaryColor,
        endRadius: 75,
        duration: Duration(milliseconds: 2000),
        repeatPauseDuration: Duration(milliseconds: 100),
        repeat: true,
        child: FloatingActionButton(
          onPressed: listen,
          child: Icon(isListening? Icons.mic:Icons.mic_none),
        ),
      ),
    );
  }
}