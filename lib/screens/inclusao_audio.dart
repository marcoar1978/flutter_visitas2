import 'package:flutter/material.dart';
import 'dart:io' as io;
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:visitas_app5/database/daos/audio_dao.dart';
import 'package:visitas_app5/models/audio_model.dart';

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
    Icons.record_voice_over,
    size: 48.0,
  );
  String statusGravacao = '--';
  String duracaoGravacao = '';
  String pathGravacao = '';
  String msgGravacao = 'Iniciar gravação';
  AudioDao audioDao = AudioDao();
  List<Audio> audios;

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
      this.statusGravacao = _recording.status.toString();
      _buttonIcon = Icon(
        Icons.mic_none,
        size: 48.0,
      );
    });
  }

  Future _startRecording() async {
    await this._init();
    await _recorder.start();
    var current = await _recorder.current();
    setState(() {
      _recording = current;
      this.statusGravacao = _recording.status.toString();
    });
  }

  Future _stopRecording() async {
    DateTime now = DateTime.now();
    int dia = now.day;
    int mes = now.month;
    int ano = now.year;
    String data = '$dia/$mes/$ano';

    var result = await _recorder.stop();
    Audio audioInsert = Audio();
    audioInsert.visitaId = this.visita.id;
    audioInsert.legenda = 'Áudio ${this.audios.length + 1} -$data';
    audioInsert.arquivo = _recording.path;
    audioInsert.duracao = _recording.duration.inSeconds.toString();
    await audioDao.incluir(audioInsert);

    setState(() {
      _recording = result;
      this.statusGravacao = _recording.status.toString();
      this.duracaoGravacao = _recording.duration.inSeconds.toString();
      this.pathGravacao = _recording.path;
    });
    this._prepare();
  }

  void _opt() async {
    switch (_recording.status) {
      case RecordingStatus.Initialized:
        {
          await _startRecording();
          this.msgGravacao = 'Gravando';
          break;
        }
      case RecordingStatus.Recording:
        {
          await _stopRecording();
          this.msgGravacao = 'Gravação finalizada ($duracaoGravacao segundos)';
          break;
        }
      /*
      case RecordingStatus.Stopped:
        {
          await _prepare();
          break;
        }*/
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
      case RecordingStatus.Stopped:
        {
          return Icon(
            Icons.mic_none,
            size: 48.0,
          );
        }

      default:
        return Icon(
          Icons.mic_none,
          size: 48.0,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    this._recebeParamVisita(context);
    this.audioDao.listaPorVisita(this.visita.id).then((audiosFuture) {
      this.audios = audiosFuture;
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(this.visita.titulo),
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
                child: this._buttonIcon),
            SizedBox(
              height: 15,
            ),
            Text(
              this.msgGravacao,
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }
}
