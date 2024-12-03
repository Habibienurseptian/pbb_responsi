import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'recipe_model.dart'; // Import model Recipe yang sudah dibuat

class DBHelper {
  static Database? _database;

  // Membuka atau membuat database
  static Future<Database> get database async {
    if (_database != null) {
      return _database!;
    } else {
      _database = await _initDB();
      return _database!;
    }
  }

  // Inisialisasi database
  static Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'recipes.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  // Membuat tabel recipes
  static Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE recipes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        preparation_time TEXT,
        ingredients TEXT,
        instructions TEXT
      )
    ''');
  }

  // Menambahkan resep baru ke database
  static Future<int> insertRecipe(Recipe recipe) async {
    final db = await database;
    return await db.insert('recipes', recipe.toMap());
  }

  // Mengambil semua resep dari database
  static Future<List<Recipe>> getRecipes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('recipes');

    return List.generate(maps.length, (i) {
      return Recipe(
        id: maps[i]['id'],
        name: maps[i]['name'],
        preparationTime: maps[i]['preparation_time'],
        ingredients: maps[i]['ingredients'],
        instructions: maps[i]['instructions'],
      );
    });
  }

  // Mengupdate resep yang ada
  static Future<int> updateRecipe(Recipe recipe) async {
    final db = await database;
    return await db.update(
      'recipes',
      recipe.toMap(),
      where: 'id = ?',
      whereArgs: [recipe.id],
    );
  }

  // Menghapus resep dari database
  static Future<int> deleteRecipe(int id) async {
    final db = await database;
    return await db.delete(
      'recipes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
