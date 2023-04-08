import "package:isar/isar.dart";

part 'film.g.dart';

@collection
class Film {
  Id id = Isar.autoIncrement;
  String? name;
  //final category = IsarLink<Category>();
}

/*@collection
class Category {
  Id id = Isar.autoIncrement;
  String? catName;
}*/
