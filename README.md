## Audio Cutter

Cut any audio clip
A package used to cut a segment from an audio file supported on Android

## Getting started

### Depend on it
```dart
dependencies:
  flutter_audio_cutter: ^1.0.3+1
```

## Usage
I use the `ffmpeg_kit_flutter` package which requires a higher Android SDK version.
So please modify your `build.gradle` (app) file as follows to avoid errors.

```
defaultConfig {
  ...
  minSdkVersion 24
  ...
}
```
`AudioCutter.cutAudio(...)` return audio file path after cutting
```dart
import 'package:flutter_audio_cutter/audio_cutter.dart';
...
var startPoint = 15.0; // the start time you want
var endPoint = 45.0; // end time
var pathToFile = 'path/to/audio-file.mp3'; //path to your file
var result = await AudioCutter.cutAudio(pathToFile, startPoint, endPoint);
...
```
## Example
![](https://raw.githubusercontent.com/sondv301/flutter_audio_cutter/main/assets/images/scr1.png "Example")
