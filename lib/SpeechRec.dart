import 'package:flutter/material.dart';
import 'package:speech_recognition/speech_recognition.dart';

class SpeechRec extends StatefulWidget {
  @override
  _SpeechRecState createState() => _SpeechRecState();
}

class _SpeechRecState extends State<SpeechRec> {
  SpeechRecognition _speech;
  bool isListening = false;
  bool isAvailable = false;

  String resultText = '';

  @override
  void initState() {
    super.initState();

    initStateRecognizer();
  }

  void initStateRecognizer() {
    _speech = SpeechRecognition();

    _speech.setAvailabilityHandler(
        (bool result) => setState(() => isAvailable = result));

    _speech
        .setRecognitionStartedHandler(() => setState(() => isListening = true));

    _speech.setRecognitionResultHandler(
        (text) => setState(() => resultText = text));

    _speech.setRecognitionCompleteHandler(
        () => setState(() => isListening = false));
    _speech.activate().then((result) => setState(() => isAvailable = result));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Speech Recognition',
          style: TextStyle(fontFamily: 'Brand-Bold', color: Colors.black),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 150,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                color: Colors.cyan,
                borderRadius: BorderRadius.circular(6),
              ),
              padding: EdgeInsets.all(50),
              child: Text(
                resultText,
                style: TextStyle(
                  fontFamily: 'Brand-Bold',
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            right: 0,
            left: 0,
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FloatingActionButton(
                          child: Icon(Icons.cancel),
                          mini: true,
                          backgroundColor: Colors.teal,
                          onPressed: () {
                            if (isListening) {
                              _speech.cancel().then((result) => setState(() {
                                    isListening = result;
                                    resultText = '';
                                  }));
                            }
                          }),
                      FloatingActionButton(
                          child: Icon(Icons.mic),
                          backgroundColor: Colors.blueAccent,
                          onPressed: () {
                            if (isAvailable && !isListening) {
                              _speech
                                  .listen(locale: 'en_US')
                                  .then((result) => print('$result'));
                            }
                          }),
                      FloatingActionButton(
                          child: Icon(Icons.stop),
                          mini: true,
                          backgroundColor: Colors.red,
                          onPressed: () {
                            if (isListening) {
                              _speech.stop().then((result) =>
                                  setState(() => isListening = result));
                            }
                          })
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
