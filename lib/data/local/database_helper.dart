import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:reyou/data/models/reminder.dart';
import 'package:reyou/data/models/app_lock_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('reyou_db.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 2, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE reminders(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        date TEXT NOT NULL,
        time TEXT NOT NULL,
        isActive INTEGER NOT NULL DEFAULT 1
      )
    ''');

    await db.execute('''
      CREATE TABLE app_lock(
        packageName TEXT PRIMARY KEY,
        appName TEXT NOT NULL,
        iconBase64 TEXT,
        unlockDate TEXT,
        unlockTime TEXT,
        isLocked INTEGER NOT NULL DEFAULT 0
      )
    ''');
  }

  Future<int> insertReminder(ReminderModel reminder) async {
    final db = await instance.database;
    return await db.insert('reminders', reminder.toMap());
  }

  Future<List<ReminderModel>> getReminders() async {
    final db = await instance.database;
    final result = await db.query('reminders');
    return result.map((json) => ReminderModel.fromMap(json)).toList();
  }

  Future<int> updateReminder(ReminderModel reminder) async {
    final db = await instance.database;
    return await db.update(
      'reminders',
      reminder.toMap(),
      where: 'id = ?',
      whereArgs: [reminder.id],
    );
  }

  Future<int> updateReminderStatus(int id, int isActive) async {
    final db = await instance.database;
    return await db.update(
      'reminders',
      {'isActive': isActive},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteReminder(int id) async {
    final db = await instance.database;
    return await db.delete('reminders', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> insertOrUpdateApp(AppLockModel app) async {
    final db = await instance.database;
    await db.insert(
      'app_lock',
      app.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<AppLockModel>> getAllAppLocks() async {
    final db = await instance.database;
    final result = await db.query('app_lock');
    return result.map((json) => AppLockModel.fromMap(json)).toList();
  }

  Future<int> updateLockStatus(String packageName, bool isLocked) async {
    final db = await instance.database;
    return await db.update(
      'app_lock',
      {'isLocked': isLocked ? 1 : 0},
      where: 'packageName = ?',
      whereArgs: [packageName],
    );
  }

  Future<int> deleteApp(String packageName) async {
    final db = await instance.database;
    return await db.delete(
      'app_lock',
      where: 'packageName = ?',
      whereArgs: [packageName],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
