import 'package:flutter/material.dart';
import 'dart:io' as io;
import 'dart:async';
import 'package:path_provider/path_provider.dart';

import 'package:visitas_app5/models/visita_model.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';

class InclusaoAudio extends StatefulWidget {
  static String routeName = 'inclusaoAudio';

  @override
  _InclusaoAudioState createState() => _InclusaoAudioState();
}

class _InclusaoAudioState extends State<InclusaoAudio> {
  Visita visita;
  FlutterAudioRecorder _recorder;
  Recording _recording;
  Widget _buttonIcon = Icon(
    Icons.play_circle_filled,
    size: 48.0,
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() {
      _prepare();
    });
  }

  void _recebeParamVisita(BuildContext context) {
    if (ModalRoute.of(context).settings.arguments != null &&
        ModalRoute.of(context).settings.arguments is Visita) {
      this.visita = ModalRoute.of(context).settings.arguments;
    }
  }

  Future _init() async {
    var hasPermission = await FlutterAudioRecorder.hasPermissions;
    if (hasPermission) {
      String customPath = '/flutter_audio_recorder_';
      io.Directory appDocDirectory;
      if (io.Platform.isIOS) {
        appDocDirectory = await getApplicationDocumentsDirectory();
      } else {
        appDocDirectory = await getExternalStorageDirectory();
      }

      // can add extension like ".mp4" ".wav" ".m4a" ".aac"
      customPath = appDocDirectory.path +
          customPath +
          DateTime.now().millisecondsSinceEpoch.toString();

      // .wav <---> AudioFormat.WAV
      // .mp4 .m4a .aac <---> AudioFormat.AAC
      // AudioFormat is optional, if given value, will overwrite path extension when there is conflicts.

      _recorder = FlutterAudioRecorder(customPath,
          audioFormat: AudioFormat.WAV, sampleRate: 22050);
      await _recorder.initialized;

    }
  }

  Future _prepare() async {
    await _init();
    var result = await _recorder.current();
    setState(() {
      _recording = result;
      _buttonIcon = Icon(Icons.play_circle_filled, size: 48.0,);
    });
  }

  Future _startRecording() async {
    await this._init();
    await _recorder.start();
    var current = await _recorder.current();
    setState(() {
      _recording = current;
    });
  }

  Future _stopRecording() async {
    var result = await _recorder.stop();

    setState(() {
      _recording = result;
      });

  }

  void _opt() async {
    switch (_recording.status) {
      case RecordingStatus.Initialized:
        {
          await _startRecording();
          break;
        }
      case RecordingStatus.Recording:
        {
          await _stopRecording();

          break;
        }
      case RecordingStatus.Stopped:
        {
          await _prepare();
          break;
        }
      default:
        break;
    }

    setState(() {
      _buttonIcon = _playerIcon(_recording.status);
    });
  }

  Widget _playerIcon(RecordingStatus status) {
    switch (status) {
      case RecordingStatus.Initialized:
        {
          return Icon(
            Icons.stop,
            size: 48.0,
          );
        }
      case RecordingStatus.Recording:
        {
          return Icon(
            Icons.stop,
            size: 48.0,
          );
        }
      case  RecordingStatus.Stopped:
        {
          return Icon(
            Icons.play_circle_filled,
            size: 48.0,
          );

        }

      default:
        return Icon(
          Icons.play_circle_filled,
          size: 48.0,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    this._recebeParamVisita(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Inclusão de Áudio'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
                onTap: () {
                  this._opt();
                  //this._init();
                },
                child: this._buttonIcon)
          ],
        ),
      ),
    );
  }
}
