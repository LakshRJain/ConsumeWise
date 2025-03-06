import 'package:flutter/material.dart';
import 'package:gen_ai/widgets/recommended_card.dart';

class RecipeDetailPage extends StatelessWidget {
  final RecommendedRecipe recipe;

  const RecipeDetailPage({required this.recipe, super.key});

  @override
  Widget build(BuildContext context) {
    Color textColor = Colors.black;
    return Scaffold(
      backgroundColor:
          _getBackgroundColor(recipe.color), // Dynamic background color
      appBar: AppBar(
        title: Text(
          recipe.title,
          style: const TextStyle(color: Colors.black), // Contrasting text color
        ),
        backgroundColor: Colors.transparent,
        elevation: 0, // No shadow for a clean look
        iconTheme: const IconThemeData(color: Colors.black), // Black back icon
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Center image with shadow and gradient overlay
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 250,
                      width: 250,
                      decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 12,
                            offset: Offset(0, 8),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          recipe.imageUrl,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        (loadingProgress.expectedTotalBytes ??
                                            1)
                                    : null,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                                child: Text('Image not available'));
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      child: Container(
                        width: 250,
                        height: 60,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.transparent, Colors.black54],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(16),
                            bottomRight: Radius.circular(16),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            recipe.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Title and summary
              _buildTitleSection(recipe),
              const SizedBox(height: 16),

              // Description Section
              _buildSectionTitle('Description'),
              _buildDescriptionText(recipe.description),
              _buildDivider(),

              // Ingredients Section
              _buildSectionTitle('Ingredients'),
              _buildDescriptionText(recipe.ingredients),
              _buildDivider(),

              // Nutritional Information Section
              _buildSectionTitle('Nutritional Information'),
              _buildNutritionChips(recipe),
              _buildDivider(),

              // Steps Section
              _buildSectionTitle('Steps'),
              _buildStepsList(recipe.steps),
            ],
          ),
        ),
      ),
    );
  }

  // Helper to determine background color based on recipe color
  Color _getBackgroundColor(String color) {
    switch (color) {
      case 'yellow':
        return const Color.fromARGB(255, 255, 252, 222);
      case 'pink':
        return const Color.fromARGB(255, 255, 231, 245);
      case 'blue':
        return const Color.fromARGB(255, 202, 231, 245);
      default:
        return Colors.white;
    }
  }

  // Title and summary section
  Widget _buildTitleSection(RecommendedRecipe recipe) {
    Color textColor = Colors.black;
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Cook:${recipe.cook} min | Prep:${recipe.prep} min',
            style: TextStyle(
              fontSize: 16,
              color: textColor,
            ),
          ),
          Text(
            'Serves: ${recipe.serves}',
            style: TextStyle(
              fontSize: 16,
              color: textColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            recipe.vegetarian == 'yes' ? 'Vegetarian' : 'Non-Vegetarian',
            style: TextStyle(
              fontSize: 16,
              color:
                  recipe.vegetarian == 'yes' ? Colors.green : Colors.redAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // Build a decorative section title
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.green.shade900,
      ),
    );
  }

  // Build description text
  Widget _buildDescriptionText(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        color: Colors.black,
        height: 1.5,
      ),
    );
  }

  // Build stylish divider with subtle shadows
  Widget _buildDivider() {
    return const Divider(
      height: 32,
      thickness: 1.5,
      color: Colors.black,
    );
  }

  // Build nutrition chips
  Widget _buildNutritionChips(RecommendedRecipe recipe) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: [
        _buildNutritionChip('Carbs', recipe.carbs),
        _buildNutritionChip('Protein', recipe.protein),
        _buildNutritionChip('Fat', recipe.fat),
        _buildNutritionChip('Kcal', recipe.kcal),
        _buildNutritionChip('Fibre', recipe.fibre),
        _buildNutritionChip('Sugars', recipe.sugars),
        _buildNutritionChip('Salt', recipe.salt),
        _buildNutritionChip('Saturates', recipe.saturates),
      ],
    );
  }

  // Steps section
  Widget _buildStepsList(Map<String, String> steps) {
    return Column(
      children: steps.entries.map((entry) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            '${entry.key}: ${entry.value}',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
              height: 1.5,
            ),
          ),
        );
      }).toList(),
    );
  }

  // Nutrition Chip builder (appending "g" for grams, except kcal)
  Widget _buildNutritionChip(String label, String value) {
    final displayValue = label == 'Kcal' ? value : '$value g';
    return Chip(
      label: Text(
        '$label: $displayValue',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.green.shade700,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    );
  }
}