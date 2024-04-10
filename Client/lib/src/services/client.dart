import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:battery_plus/battery_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:sync_magnet/src/services/background_service.dart';

class SyncSocketClient {
  final String _seperator = "|:MAGNET:|";
  Socket? _socket;
  int? _fileLength;
  IOSink? _sinkFile;
  List<int>? _fileBytes;
  List<File>? _sendSelectedFiles;
  File? _file;
  bool _allowMultiple = false;
  String _addMultipleData = '';
  int _multipleDataNextIndex = 0;

  final List<Map<String, dynamic>> loadedFiles = [];
  final service = FlutterBackgroundService();
  int fileSize = 0;
  String fileName = "";
  String folder = "";
  String overFlowCommand = "";
  bool forPageIsLoadScreen = false;
  bool isGetFile = false;
  bool isSendFile = false;
  bool isGetFileCompleted = false;
  bool isConnected = false;
  bool isClose = false;
  bool clientIsDisconnect = false;
  bool isSendFileCompleted = false;
  bool isTransfer = false;

  Future<bool> clientSetup({String? ip, int? port}) async {
    try {
      _socket =
          await Socket.connect(ip, port!, timeout: const Duration(seconds: 20));
      isClose = false;
      isConnected = true;
      clientIsDisconnect = false;
      await SyncBackgroundService.initializeService();
      await service.startService();
      return true;
    } catch (e) {
      print("object -> $e");
      return false;
    }
  }

  void closeConnectToDevice() {
    isConnected = false;
    // clientIsDisconnect = true;
    isClose = true;
    _socket!.add(utf8.encode("DISCONNECT"));
    _socket!.close();
    service.invoke("stopService");
  }

  Future<void> listenServer() async {
    _socket!.listen(
      (Uint8List event) async {
        String data = String.fromCharCodes(event);
        _handleMessage(data);
      },
      onDone: () {
        if (_socket != null) {
          print("EVENT -> Bağlantı sonlandı");
          clientIsDisconnect = true;
          checkDownloadedFile();
          _socket!.close();
          service.invoke("stopService");
        }
      },
      onError: (error) {
        if (_socket != null) {
          print("EVENT -> ERRROR $error");
          clientIsDisconnect = true;
          checkDownloadedFile();
          _socket!.close();
          service.invoke("stopService");
        }
      },
      cancelOnError: true,
    );
  }

  Future<String> _getSendDeviceName() async {
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
    return androidInfo.model;
  }

  Future<int> _getSendDeviceBatteryState() async {
    final Battery battery = Battery();
    int percentage = 0;
    final level = await battery.batteryLevel;
    percentage = level;
    print("EVENT -> percentage: $percentage");
    return percentage;
  }

  Future<void> sendMultipleFile({required List<File> files}) async {
    const String multipleFileSendCommand = "C_MULTIPLE_FILE_SEND";
    isSendFile = true;
    _allowMultiple = true;
    isSendFileCompleted = false;

    for (var file in files) {
      var parts = file.path.split('/');
      fileName = parts[parts.length - 1];
      _fileLength = await file.length();
      _addMultipleData += "$_fileLength|$fileName|";
    }
    _socket!.add(utf8.encode(multipleFileSendCommand));
    print(_addMultipleData);
    files.sort((a, b) => a.lengthSync().compareTo(b.lengthSync()));
    _sendSelectedFiles = files;
    _sendSelectedFiles = _sendSelectedFiles!.reversed.toList();
  }

  Future<void> sendSelectFile({required File file_}) async {
    isSendFile = true;
    isSendFileCompleted = false;
    const String fileSendCommand = "C_FILE_SEND";
    _allowMultiple = false;
    final List<String> parts = file_.path.split('/');

    fileName = parts[parts.length - 1];
    _fileBytes = await file_.readAsBytes();
    _fileLength = _fileBytes!.length;

    _socket!.add(utf8.encode(fileSendCommand));
  }

  Future<void> declineFile() async {
    fileSize = 0;
    await _socket!.flush();
  }

  Future<void> _handleMessage(String data) async {
    switch (data.trim()) {
      case "OK_SEND":
        print("EVENT -> OK_SEND");
        if (!_allowMultiple) {
          print("EVENT -> Tek onay geldi");
          _socket!.add(utf8.encode("$_fileLength|$fileName|"));
        } else {
          print("EVENT -> çoklu onay geldi");
          print("EVENT -> $_addMultipleData");
          _socket!.add(utf8.encode(_addMultipleData));
          _addMultipleData = "";
        }
        break;

      case "S_FILE_CAME":
        sFileCame();
        break;

      case "FILE_SEND_END":
        print("EVENT -> FILE_SEND_END");
        forPageIsLoadScreen = false;
        isGetFile = false;
        isGetFileCompleted = true;
        isSendFileCompleted = true;
        isSendFile = false;
        if (_sinkFile != null) {
          await _sinkFile!.close();
          _sinkFile = null;
        }
        if (_allowMultiple) {
          print("EVENT -> Çoklu Dosya Gönderim Bitti");
          _sendSelectedFiles!.clear();
          _multipleDataNextIndex = 0;
          _allowMultiple = false;
        }
        checkDownloadedFile();
        break;

      case "DEVICE":
        try {
          print("EVENT -> DEVICE");
          isTransfer = false;
          String name = await _getSendDeviceName();
          final int batterySize = await _getSendDeviceBatteryState();
          _socket!.add(utf8.encode("${name.length}|$name|$batterySize"));
        } catch (e) {}
        break;

      case "SINGLE":
        print("EVENT -> SINGLE");
        _socket!.add(_fileBytes!);
        break;

      case "DECLINE":
        print("EVENT -> DECLINE");
        _socket!.flush();
        break;

      case "DISCONNECT":
        print("EVENT -> DISCONNECT");
        clientIsDisconnect = true;
        isClose = true;
        _socket!.close();
        checkDownloadedFile();
        break;

      case "H_TRANSFER":
        isTransfer = true;
        print("EVENT -> H_TRANSFER");
        _socket!.flush();
        break;

      case "NEXT":
        try {
          print("EVENT -> Çok dosya için NEXT komutu geldi");
          var readMultipleFileData =
              await _sendSelectedFiles![_multipleDataNextIndex].readAsBytes();
          _socket!.add(readMultipleFileData);
          _multipleDataNextIndex++;
          print("EVENT -> _multipleDataNextIndex $_multipleDataNextIndex");
          break;
        } catch (e) {
          print("HATA EVENT -> $e");
          break;
        }

      default:
        if (data.contains(_seperator)) {
          print("EVENT -> DOSYA <-> $data");
          var parts = data.split(_seperator);
          print("EVENT -> $parts");
          fileName = parts[1];
          fileSize = int.parse(parts[2]);
          if (parts.length == 4) {
            overFlowCommand = parts[3];
            print("EVENT -> overFlowCommand = $overFlowCommand");
            if (overFlowCommand == "S_FILE_CAME") sFileCame();
          }
          loadedFiles.add({"file_name": fileName, "file_size": fileSize});
        }
        if (_sinkFile != null) {
          if (!data.contains(_seperator)) {
            _sinkFile!.add(Uint8List.fromList(data.codeUnits));
          }
        }
        break;
    }
  }

  void sFileCame() {
    print("EVENT -> S_FILE_CAME");
    Future.delayed(const Duration(milliseconds: 10));
    forPageIsLoadScreen = true;
    isGetFile = true;
    _file = File("$folder/$fileName");
    print("EVENT -> $folder/$fileName");
    _sinkFile = _file!.openWrite(mode: FileMode.append);
    _socket!.add(utf8.encode("S_FILE_SEND"));
  }

  void checkDownloadedFile() {
    for (var i = 0; i < loadedFiles.length; i++) {
      var f = File("$folder/${loadedFiles[i]['file_name']}");
      var stat = f.statSync();
      print("${stat.size} <-> $f <-> ${loadedFiles[i]['file_size']}");
      if (stat.size == loadedFiles[i]['file_size']) {
        print("${loadedFiles[i]['file_name']} TAMAMLANDI");
      } else {
        print("!!!!!!!!!!!!!!!!! ${loadedFiles[i]['file_name']} EKSIK");
        f.deleteSync();
      }
    }
  }
}
