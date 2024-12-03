import 'package:flutter/material.dart';
import 'recipe_model.dart';
import 'db_helper.dart';
import 'add_recipe_screen.dart';

class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe;
  final Function(Recipe) onDelete;

  RecipeDetailScreen({required this.recipe, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          recipe.name,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.orange,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nama Resep
              Card(
                elevation: 5,
                margin: EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Nama Resep: ${recipe.name}',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.orangeAccent,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 16),

              // Waktu Persiapan
              Card(
                elevation: 5,
                margin: EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Waktu Persiapan: ${recipe.preparationTime}',
                    style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                  ),
                ),
              ),

              SizedBox(height: 16),

              // Bahan-bahan
              Text(
                'Bahan-bahan:',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange),
              ),
              Card(
                elevation: 3,
                margin: EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    recipe.ingredients,
                    style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                  ),
                ),
              ),

              SizedBox(height: 16),

              // Langkah-langkah
              Text(
                'Langkah-langkah:',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange),
              ),
              Card(
                elevation: 3,
                margin: EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    recipe.instructions,
                    style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                  ),
                ),
              ),

              SizedBox(height: 30),

              // Tombol Aksi: Edit dan Hapus
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () async {
                      // Navigasi ke layar Edit (Tambah Resep) dengan data yang sudah ada
                      final editedRecipe = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddRecipeScreen(
                            recipe:
                                recipe, // Kirim resep yang sudah ada untuk diedit
                          ),
                        ),
                      );
                      if (editedRecipe != null) {
                        // Jika pengguna mengedit resep, perbarui di database dan kembali ke daftar resep
                        await DBHelper.updateRecipe(editedRecipe);
                        Navigator.pop(context, editedRecipe);
                      }
                    },
                    icon: Icon(Icons.edit, color: Colors.white),
                    label: Text(
                      'Edit Resep',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () async {
                      // Menghapus resep dari database
                      await DBHelper.deleteRecipe(recipe.id!);
                      onDelete(
                          recipe); // Menghapus dari list resep di layar utama
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.delete, color: Colors.white),
                    label: Text(
                      'Hapus Resep',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
