## Audio Cutter

Cut any audio clip

## Getting started

### Depend on it
```dart
dependencies:
  flutter_audio_cutter: ^1.0.0
```

## Usage

```dart
import 'package:flutter_audio_cutter/audio_cutter.dart';
...
var startPoint = 15.0; // the start time you want
var endPoint = 45.0; // end time
var pathToFile = 'path/to/audio-file.mp3'; //path to your file
var result = await AudioCutter.cutAudio(pathToFile, startPoint, endPoint);
...
```
