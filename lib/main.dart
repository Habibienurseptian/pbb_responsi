import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'recipe_model.dart';
import 'add_recipe_screen.dart';
import 'recipe_detail_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Resep App',
      theme: ThemeData(
        primarySwatch: Colors.orange, // Menggunakan warna oranye untuk tema
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: RecipeListScreen(),
    );
  }
}

class RecipeListScreen extends StatefulWidget {
  @override
  _RecipeListScreenState createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  List<Recipe> recipes = [];

  @override
  void initState() {
    super.initState();
    _loadRecipes();
  }

  // Mengambil data resep dari database
  _loadRecipes() async {
    final data = await DBHelper.getRecipes();
    setState(() {
      recipes = data;
    });
  }

  // Menambahkan resep baru
  _addRecipe(Recipe recipe) async {
    await DBHelper.insertRecipe(recipe);
    _loadRecipes(); // Reload daftar resep
  }

  // Menghapus resep dari database
  _removeRecipe(Recipe recipe) async {
    await DBHelper.deleteRecipe(recipe.id!);
    setState(() {
      recipes.remove(recipe);
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Resep berhasil dihapus"),
      backgroundColor: Colors.red,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Daftar Resep',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.orange,
        elevation: 0,
      ),
      body: recipes.isEmpty
          ? Center(child: Text("Tidak ada resep. Tambahkan resep baru."))
          : ListView.builder(
              itemCount: recipes.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    leading: Icon(
                      Icons.restaurant_menu,
                      color: Colors.orange,
                      size: 40,
                    ),
                    title: Text(
                      recipes[index].name,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Waktu Persiapan: ${recipes[index].preparationTime}',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    onTap: () async {
                      // Navigasi ke Detail Resep
                      final updatedRecipe = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecipeDetailScreen(
                            recipe: recipes[index],
                            onDelete: _removeRecipe,
                          ),
                        ),
                      );
                      if (updatedRecipe != null) {
                        // Jika resep diperbarui, perbarui daftar resep
                        await DBHelper.updateRecipe(updatedRecipe);
                        _loadRecipes();
                      }
                    },
                    trailing: IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () => _removeRecipe(recipes[index]),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newRecipe = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddRecipeScreen()),
          );
          if (newRecipe != null) {
            _addRecipe(newRecipe);
          }
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.orange,
      ),
    );
  }
}
