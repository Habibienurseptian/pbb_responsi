class Recipe {
  int? id;
  String name;
  String preparationTime;
  String ingredients;
  String instructions;

  Recipe({
    this.id,
    required this.name,
    required this.preparationTime,
    required this.ingredients,
    required this.instructions,
  });

  // Mengonversi objek Recipe ke Map untuk disimpan di SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'preparation_time': preparationTime,
      'ingredients': ingredients,
      'instructions': instructions,
    };
  }

  // Mengonversi Map dari SQLite ke objek Recipe
  factory Recipe.fromMap(Map<String, dynamic> map) {
    return Recipe(
      id: map['id'],
      name: map['name'],
      preparationTime: map['preparation_time'],
      ingredients: map['ingredients'],
      instructions: map['instructions'],
    );
  }
}
