library audio_cutter;

import 'dart:io';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class AudioCutter {
  /// Return audio file path after cutting
  static Future<String> cutAudio(String path, double start, double end,
      {String? outputDirPath}) async {
    if (start < 0 || end < 0) {
      throw ArgumentError('The starting and ending points cannot be negative');
    }
    if (start > end) {
      throw ArgumentError(
          'The starting point cannot be greater than the ending point');
    }
    var directory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationSupportDirectory();

    ///to determine the exact -acodec of the audio file
    String extension = p.extension(path);

    ///Delete previous file with same name
    File("${directory!.path}/trimmed$extension").delete();

    String outPath = "";

    if (outputDirPath != null) {
      outPath = outputDirPath;
      await File(outPath).create(recursive: true);
    } else {
      final Directory dir = await getTemporaryDirectory();
      final outPath = "${dir.path}/audio_cutter/output.mp3";
      await File(outPath).create(recursive: true);
    }

    var cmd =
        "-y -i \"$path\" -vn -ss $start -to $end -ar 16k -ac 2 -b:a 96k -acodec copy $outPath";

    await FFmpegKit.execute(cmd);

    return outPath;
  }
}
