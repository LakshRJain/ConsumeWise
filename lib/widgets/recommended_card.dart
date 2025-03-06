import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gen_ai/riverpod/riverpod_providers.dart';
import 'package:gen_ai/screen/recipeDetailsScreen.dart';

class RecommendedRecipes extends ConsumerWidget {
  const RecommendedRecipes({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipeStream = ref.watch(recipeProvider);

    return Container(
      child: recipeStream.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (DocumentSnapshot snapshot) {
          if (!snapshot.exists) {
            return const Center(child: Text('No recipes found'));
          }

          var recipeData = snapshot.data() as Map<String, dynamic>;
          List<RecommendedRecipe> recipes = recipeData.keys.map((key) {
            var data = recipeData[key];
            return RecommendedRecipe.fromFirestore(data);
          }).toList();

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Recommended Recipes',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 250,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: recipes.length,
                    itemBuilder: (context, index) {
                      final recipe = recipes[index];
                      return RecommendedCard(recipe: recipe);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class RecommendedRecipe {
  final String cook;
  final String dairy;
  final String description;
  final String difficulty;
  final String gluten;
  final String ingredients;
  final String carbs;
  final String fat;
  final String fibre;
  final String kcal;
  final String protein;
  final String salt;
  final String saturates;
  final String sugars;
  final String title;
  final String prep;
  final int serves;
  final Map<String, String> steps;
  final String vegetarian;
  final String imageUrl;
  final String color;

  RecommendedRecipe({
    required this.ingredients,
    required this.title,
    required this.dairy,
    required this.vegetarian,
    required this.gluten,
    required this.cook,
    required this.prep,
    required this.imageUrl,
    required this.description,
    required this.difficulty,
    required this.carbs,
    required this.protein,
    required this.sugars,
    required this.fat,
    required this.kcal,
    required this.fibre,
    required this.salt,
    required this.saturates,
    required this.serves,
    required this.color,
    required this.steps,
  });

  factory RecommendedRecipe.fromFirestore(Map<String, dynamic> data) {
    final nutrition = data['nutrition'] as Map<String, dynamic>?;

    return RecommendedRecipe(
      ingredients: data['ingredients'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      title: data['title'] ?? '',
      dairy: data['dairy'] ?? '',
      vegetarian: data['vegetarian'] ?? '',
      gluten: data['gluten'] ?? '',
      cook: data['cook'] ?? '',
      prep: data['prep'] ?? '',
      description: data['description'] ?? '',
      difficulty: data['difficulty'] ?? '',
      carbs: nutrition?['carbs'] ?? '',
      protein: nutrition?['protein'] ?? '',
      sugars: nutrition?['sugars'] ?? '',
      fat: nutrition?['fat'] ?? '',
      kcal: nutrition?['kcal'] ?? '',
      fibre: nutrition?['fibre'] ?? '',
      salt: nutrition?['salt'] ?? '',
      saturates: nutrition?['saturates'] ?? '',
      serves: int.tryParse(data['serves'] ?? '1') ?? 1,
      color: data['color'] ?? '',
      steps: Map<String, String>.from(data['steps'] ?? {}),
    );
  }
}

class RecommendedCard extends StatelessWidget {
  final RecommendedRecipe recipe;

  const RecommendedCard({required this.recipe, super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeDetailPage(recipe: recipe),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8), // Add margin between cards
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: _getCardColor(recipe.color), // Use a helper method for colors
          child: Container(
            width: 160, // Adjust width for the card
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    height: 100,
                    width: 100,
                    child: Image.network(
                      recipe.imageUrl,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    (loadingProgress.expectedTotalBytes ?? 1)
                                : null,
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Text('Failed to load image'),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  recipe.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text('${recipe.cook} min | Serves: ${recipe.serves}'),
                Text(recipe.vegetarian == 'yes'
                    ? 'Vegetarian'
                    : 'Non-vegetarian'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getCardColor(String color) {
    switch (color) {
      case 'yellow':
        return const Color(0xFFCBF3F0);
      case 'pink':
        return const Color(0xFFECAD5A);
      case 'blue':
        return const Color(0xFF2EC4B6);
      default:
        return Colors.orange; // Default color
    }
  }
}
