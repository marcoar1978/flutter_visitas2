import 'package:flutter/material.dart';
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

class _ListaAudiosState extends State<ListaAudios> {
  List<Audio> audios = List();
  AudioDao audioDao = AudioDao();

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
              itemBuilder: (context, index){
                Audio audioIndex = this.audios[index];
                print(index);
                return this._cardAudio(context, audioIndex);
              },
            );
            break;
        }
        return Text('');
      },
    );
  }

  Widget _cardAudio(BuildContext context, Audio audio){
    return Card(
      elevation: 8.0,
      child: ListTile(
        title: Text('Duração: ${audio.duracao}'),
        subtitle: Text('teste'),
      ),
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 16.0, left: 8.0, right: 8.0, bottom: 8.0),
        child: _futureBuilderAudios(context),
      ),

    );
  }
}
