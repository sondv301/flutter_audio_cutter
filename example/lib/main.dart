import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_cutter/audio_cutter.dart';
import 'package:just_audio/just_audio.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Audio Cutter Example',
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
  String inputFileView = 'input file path';
  File inputFile = File('');
  File outputFile = File('');
  RangeValues cutValues = const RangeValues(0, 5);
  int timeFile = 10;
  final player = AudioPlayer();
  final outputPlayer = AudioPlayer();
  bool previewPlay = false;
  bool outputPlay = false;
  bool isCutting = false;
  bool isCut = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio Cutter Example'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'INPUT',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                inputFileView,
                textAlign: TextAlign.center,
              ),
              MaterialButton(
                onPressed: _onPickFile,
                color: Colors.blue,
                child: const Text('Pick file'),
              ),
              const Divider(),
              const Text(
                'CUTTER',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              RangeSlider(
                  values: cutValues,
                  max: timeFile.toDouble(),
                  divisions: timeFile,
                  labels: RangeLabels(
                      _getViewTimeFromCut(cutValues.start.toInt()).toString(),
                      _getViewTimeFromCut(cutValues.end.toInt()).toString()),
                  onChanged: (values) {
                    setState(() => cutValues = values);
                    player.seek(Duration(seconds: cutValues.start.toInt()));
                  }),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                      'Start: ${_getViewTimeFromCut(cutValues.start.toInt())}'),
                  Text('End: ${_getViewTimeFromCut(cutValues.end.toInt())}'),
                ],
              ),
              IconButton(
                  onPressed: _onPlayPreview,
                  icon:
                      Icon(previewPlay ? Icons.stop_circle : Icons.play_arrow)),
              MaterialButton(
                onPressed: _onCut,
                color: Colors.blue,
                child: const Text('Cut'),
              ),
              const Divider(),
              const Text(
                'OUTPUT',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              isCutting
                  ? Column(
                      children: const [
                        CircularProgressIndicator(),
                        Text('Waitting...')
                      ],
                    )
                  : Column(
                      children: [
                        Text(isCut ? 'Done!' : ''),
                        Text(isCut ? outputFile.path : 'output file path'),
                        Text(
                            'Time: ${outputPlayer.duration?.inMinutes ?? 0}:${outputPlayer.duration?.inSeconds ?? 0}'),
                        IconButton(
                            onPressed: _onOutputPlayPreview,
                            icon: Icon(outputPlay
                                ? Icons.stop_circle
                                : Icons.play_arrow)),
                      ],
                    )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onPickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3'],
    );
    if (result != null) {
      inputFile = File(result.files.single.path!);
      await player.setFilePath(inputFile.path);
      setState(() {
        timeFile = player.duration!.inSeconds;
        cutValues = RangeValues(0, timeFile.toDouble());
        inputFileView = inputFile.path;
      });
    }
  }

  _getViewTimeFromCut(int index) {
    int minute = index ~/ 60;
    int second = index - minute * 60;
    return "$minute:$second";
  }

  void _onPlayPreview() {
    if (inputFile.path != '') {
      setState(() => previewPlay = !previewPlay);
      if (player.playing) {
        player.stop();
      } else {
        player.seek(Duration(seconds: cutValues.start.toInt()));
        player.play();
      }
    }
  }

  Future<void> _onCut() async {
    if (inputFile.path != '') {
      setState(() => isCutting = true);
      var result = await AudioCutter.cutAudio(
          inputFile.path, cutValues.start, cutValues.end);
      outputFile = File(result);
      await outputPlayer.setFilePath(result);
      setState(() {
        isCut = true;
        isCutting = false;
      });
    }
  }

  void _onOutputPlayPreview() {
    if (outputFile.path != '') {
      setState(() => outputPlay = !outputPlay);
      if (outputPlayer.playing) {
        print("stop");
        outputPlayer.stop();
      } else {
        print("play");
        outputPlayer.play();
      }
    }
  }
}
