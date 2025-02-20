import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast_web/sembast_web.dart';
import '../models/training.model.dart';
import '../models/user.model.dart';

class AppDatabase {
  static late DatabaseClient db;
  static final BehaviorSubject<List<Training>> favouriteTrainingStream =
      BehaviorSubject<List<Training>>.seeded([]);

  static Future<DatabaseClient?> prepareDatabase() async {
    String dbPath = 'fc_social_fitness2.db';
    if (kIsWeb) {
      db = await databaseFactoryWeb.openDatabase(dbPath);
    } else {
      Directory appDocDir = await getApplicationSupportDirectory();
      db = await databaseFactoryIo.openDatabase(appDocDir.path + dbPath);
    }
    return db;
  }

  static Future storeUser(User user) async {
    var storeUser = intMapStoreFactory.store('users');
    await storeUser.add(AppDatabase.db, user.toMap());
  }

  static Future<User?> getCurrentUser() async {
    var storeUser = intMapStoreFactory.store('users');
    List<RecordSnapshot<int, Map<String, Object?>>> userMap =
        await storeUser.find(db);
    User? user;
    if (userMap.isNotEmpty) {
      user = User.formJson(userJSONObject: userMap.first.value);
    }
    return user;
  }

  static deleteCurrentUser() async {
    var storeUser = intMapStoreFactory.store('users');
    await storeUser.delete(db);
  }

  static Future storeTraining(Training training) async {
    var storeTraining = intMapStoreFactory.store('trainings');
    await storeTraining.add(AppDatabase.db, training.toMap());
    List<Training> favouriteTraining = favouriteTrainingStream.value;
    favouriteTraining.add(training);
    favouriteTrainingStream.add(favouriteTraining);
  }

  static Future<List<Training>> getFavouriteTrainings() async {
    List<Training> trainings = [];
    var storeTraining = intMapStoreFactory.store('trainings');
    List<RecordSnapshot<int, Map<String, Object?>>> trainingsMap =
        await storeTraining.find(db);
    if (trainingsMap.isNotEmpty) {
      trainings = List.from(trainingsMap)
          .map((element) => Training.formJson(trainingJSONObject: element))
          .toList();
    }
    favouriteTrainingStream.add(trainings);
    return trainings;
  }

  static deleteAllTrainings() async {
    var storeTraining = intMapStoreFactory.store('trainings');
    await storeTraining.delete(db);
  }

  static deleteTraining(Training training) async {
    var storeTraining = intMapStoreFactory.store('trainings');
    final key = await storeTraining.findKey(
      db,
      finder: Finder(filter: Filter.equals('id', training.id)),
    );
    if (key != null) {
      await storeTraining.record(key).delete(db);
      getFavouriteTrainings();
    }
  }

  static Future deleteCurrentUserModel() async {
    var storeUser = intMapStoreFactory.store('usermodel');
    await storeUser.delete(db);
  }
}
