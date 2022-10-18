library audio_cutter;

import 'dart:io';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:path_provider/path_provider.dart';

class AudioCutter {
  /// Return audio file path after cutting
  static Future<String> cutAudio(String path, double start, double end) async {
    if (start < 0 || end < 0) {
      throw ArgumentError('The starting and ending points cannot be negative');
    }
    if (start > end) {
      throw ArgumentError(
          'The starting point cannot be greater than the ending point');
    }

//  /storage/emulated/0/Android/data/com.example.voxpod/files/question1.mp4
    final Directory dir = await getTemporaryDirectory();
    var path = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationSupportDirectory();
    final outPath = "${path!.path}/trimmed.mp3";
    await File(outPath).create(recursive: true);

    var cmd =
        "-y -i \"$path\" -vn -ss $start -to $end -ar 16k -ac 2 -b:a 96k -acodec copy $outPath";
    await FFmpegKit.execute(cmd);

    return outPath;
  }
}
