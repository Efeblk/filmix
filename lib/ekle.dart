// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:vize/collections/film.dart';
import 'package:isar/isar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late Isar isar;

  TextEditingController nameController = TextEditingController();
  List<Film> filmList = [];
  String name = "";
  bool edit = false;
  late int editId;
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
              child: Column(
                children: [
                  Image.asset("assets/leo.jpg"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(e.name!),
                      Row(
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                edit = true;
                                name = e.name!;
                                editId = e.id;
                                nameController =
                                    TextEditingController(text: e.name!);
                                setState(() {});
                              },
                              child: Icon(Icons.edit)),
                          SizedBox(
                            width: 5,
                          ),
                          ElevatedButton(
                              onPressed: () {
                                deleteFilm(e.id);
                              },
                              child: Icon(Icons.delete)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ))
        .toList();
  }

  getFilms() async {
    edit = false;
    final films = await isar.films.where().findAll();
    filmList = films;
    setState(() {});
  }

  editFilm(int id, String sname) async {
    final film = Film()
      ..id = id
      ..name = sname;
    await isar.writeTxn(() async => await isar.films.put(film));
    getFilms();
  }

  addFilm() async {
    edit = false;
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text('film adi girmeniz gerekiyor'),
      ));
    } else {
      final newFilm = Film()..name = name;

      await isar.writeTxn(() async {
        await isar.films.put(newFilm);

        nameController = TextEditingController(text: "");
        setState(() {});
      });

      getFilms();
    }
  }

  deleteFilm(int id) async {
    await isar.writeTxn(() async {
      bool result = await isar.films.delete(id);
      if (result) {
        edit = false;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Silme başarılı')));
        getFilms();
        nameController = TextEditingController(text: "");
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Silme başarısız')));
      }
    });
  }

  @override
  void initState() {
    openCon();
    super.initState();
  }

  @override
  void dispose() {
    closeCon();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Film; göster, ekle, çıkar'),
      ),
      body: Center(
          child: Column(
        children: [
          Container(
            child: TextField(
              onChanged: (value) {
                setState(() {
                  name = value;
                });
              },
              controller: nameController,
              obscureText: false,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              edit
                  ? ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green),
                      onPressed: () => editFilm(editId, name),
                      child: Text("güncelle"),
                    )
                  : SizedBox(
                      width: 85,
                    ),
              ElevatedButton(onPressed: () => addFilm(), child: Text("ekle")),
              ElevatedButton(onPressed: () => getFilms(), child: Text("göster"))
            ],
          ),
          Expanded(
              child: ListView(
            children: filmtoWidget(),
          ))
        ],
      )),
    );
  }
}
