import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:file/memory.dart';
import 'package:meta/meta.dart';

/// File service
class FileService {
  FileService._(this._fs);
  FileSystem _fs;

  /// write on a file
  void writeOn(String path, String contents) {
    _fs.file(path)
      ..createSync(recursive: true)
      ..writeAsStringSync(contents);
  }

  /// check if a file exists
  bool exists(String path) {
    return _fs.file(path).existsSync();
  }

  /// read a file
  String read(String path) {
    return _fs.file(path).readAsStringSync();
  }

  /// shared instance
  static FileService instance = FileService._(const LocalFileSystem());

  @visibleForTesting

  /// Test function, change the file system to MemoryFileSystem
  void withMemory() {
    _fs = MemoryFileSystem();
  }
}
