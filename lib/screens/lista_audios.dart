import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';

import 'package:visitas_app5/components/progress.dart';
import 'package:visitas_app5/database/daos/audio_dao.dart';
import 'package:visitas_app5/models/audio_model.dart';
import 'package:visitas_app5/models/visita_model.dart';

class ListaAudios extends StatefulWidget {
  Visita visita;

  ListaAudios({this.visita});

  @override
  _ListaAudiosState createState() => _ListaAudiosState();
}

class _ListaAudiosState extends State<ListaAudios>
    with SingleTickerProviderStateMixin {
  List<Audio> audios = List();
  AudioDao audioDao = AudioDao();
  Widget iconeAudio = Icon(Icons.play_arrow);
  AnimationController animationController;
  bool isPlay = false;
  AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    this.animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
  }

  void dispose() {
    this.animationController.dispose();
    super.dispose();
  }

  Widget _futureBuilderAudios(BuildContext context) {
    return FutureBuilder(
      future: this.audioDao.listaPorVisita(widget.visita.id),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Progress();
            break;
          case ConnectionState.active:
            // TODO: Handle this case.
            break;
          case ConnectionState.done:
            if (snapshot.hasData) this.audios = snapshot.data;
            print('Qde audios: ${this.audios.length}');
            return ListView.builder(
              itemCount: this.audios.length,
              itemBuilder: (context, index) {
                Audio audioIndex = this.audios[index];
                return this._cardAudio(context, audioIndex);
              },
            );
            break;
        }
        return Text('');
      },
    );
  }

  Widget _cardAudio(BuildContext context, Audio audio) {
    var campoLegendaData = audio.legenda.split('-');

    return Card(
      elevation: 8.0,
      child: ListTile(
        title: Text('${campoLegendaData[0]}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            //Text('${campoLegendaData[1]}'),
            Text(_formataTime(audio.duracao)),
          ],
        ),
        onTap: () async {
          if (this.isPlay) this.animationController.reverse();
          this.isPlay = false;
          await this.audioPlayer.play(audio.arquivo, isLocal: true);
          this._bottomPlay(context, audio);
        },
      ),
    );
  }

  String _formataTime(String segundos) {
    int segundosInt = int.tryParse(segundos);
    String min;
    String segFormat;

    if (segundosInt % 60 > 0) {
      min = (segundosInt / 60).floor().toString();
      int seg = (segundosInt % 60).floor();
      segFormat = (seg >= 10) ? seg.toString() : '0${seg.toString()}';
    } else {
      min = '0';
      segFormat = (segundosInt >= 10)
          ? segundosInt.toString()
          : '0${segundosInt.toString()}';
    }

    return '${min}:${segFormat}';
  }

  Widget _bottomPlay(BuildContext context, Audio audio) {
    showBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheet(
            builder: (context) {
              return Padding(
                padding: const EdgeInsets.only(
                    top: 8.0, left: 36.0, right: 36.0, bottom: 8.0),
                child: Container(
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.all(
                        Radius.circular(5.0),
                      )),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('${audio.legenda}'),
                        ),
                      ),
                      IconButton(
                        icon: AnimatedIcon(
                          icon: AnimatedIcons.pause_play,
                          progress: this.animationController,
                        ),
                        iconSize: 36,
                        onPressed: () => playPauseAudio(audio),
                      ),
                    ],
                  ),
                ),
              );
            },
            onClosing: () {},
          );
        });
  }

  void playPauseAudio(Audio audio) async {
    this.isPlay = !this.isPlay;
    if (this.isPlay)
      await this.audioPlayer.pause();
    else
      this.audioPlayer.resume();
    isPlay
        ? this.animationController.forward()
        : this.animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
            top: 16.0, left: 8.0, right: 8.0, bottom: 8.0),
        child: _futureBuilderAudios(context),
      ),
    );
  }
}
