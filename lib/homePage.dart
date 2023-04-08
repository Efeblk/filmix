import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';
import 'package:vize/collections/film.dart';

class homepage extends StatefulWidget {
  const homepage({super.key});

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  late Isar isar;

  //List<Widget> filmList = [];
  List<Film> filmList = [];
  openCon() async {
    isar = await Isar.open([FilmSchema]);
    setState(() {});
  }

  closeCon() async {
    await isar.close();
  }

  filmtoWidget() {
    return filmList
        .map((e) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(e.name!),
                  Text(e.id.toString()),
                  ElevatedButton(
                      onPressed: () => deleteFilm(e.id),
                      child: Icon(Icons.delete)),
                ],
              ),
            ))
        .toList();
  }

  getFilms() async {
    final films = await isar.films.where().findAll();
    filmList = films;
    setState(() {});
  }

  /*@override
  void initState() {
    openCon();
    super.initState();
  }

  @override
  void dispose() {
    closeCon();
    super.dispose();
  }*/

  editFilm(int id, String sname) async {
    final film = Film()
      ..id = id
      ..name = sname;
    await isar.writeTxn(() async => await isar.films.put(film));
    getFilms();
  }

  addFilm(String sname) async {
    final newFilm = Film()..name = sname;
    await isar.writeTxn(() async => await isar.films.put(newFilm));
    getFilms();
  }

  deleteFilm(int id) async {
    await isar.writeTxn(() async {
      bool result = await isar.films.delete(id);
      if (result) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Silme başarılı')));
        getFilms();
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Silme başarısız')));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(title: const Text("filmix")),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: InkWell(
              onTap: () => GoRouter.of(context).push('/ekle'),
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Image.asset("assets/leo.jpg"),
                    SizedBox(width: 15),
                    Text('DATABASE'),
                  ],
                ),
              ),
            ),
          ),
        ],
      )),
    ));
  }
}
