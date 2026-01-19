import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/historical_recipes_service.dart';

final recipesProvider = FutureProvider<List<HistoricalRecipe>>((ref) async {
  return await HistoricalRecipesService().getAllRecipes();
});

final recipeCivilizationFilterProvider = StateProvider<String?>((ref) => null);

class HistoricalRecipesScreen extends ConsumerWidget {
  const HistoricalRecipesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipesAsync = ref.watch(recipesProvider);
    final selectedCiv = ref.watch(recipeCivilizationFilterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tarihi Yemekler'),
        actions: [
          PopupMenuButton<String?>(
            icon: const Icon(Icons.filter_list),
            onSelected: (value) {
              ref.read(recipeCivilizationFilterProvider.notifier).state = value;
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: null, child: Text('Tümü')),
              const PopupMenuItem(value: 'Antik Yunan', child: Text('Antik Yunan')),
              const PopupMenuItem(value: 'Antik Roma', child: Text('Antik Roma')),
              const PopupMenuItem(value: 'Antik Mısır', child: Text('Antik Mısır')),
              const PopupMenuItem(value: 'Mezopotamya', child: Text('Mezopotamya')),
              const PopupMenuItem(value: 'Viking', child: Text('Viking')),
              const PopupMenuItem(value: 'Çin', child: Text('Çin')),
              const PopupMenuItem(value: 'Japonya', child: Text('Japonya')),
              const PopupMenuItem(value: 'Hindistan', child: Text('Hindistan')),
              const PopupMenuItem(value: 'Maya', child: Text('Maya/Aztek')),
              const PopupMenuItem(value: 'Pers', child: Text('Pers')),
              const PopupMenuItem(value: 'Osmanlı', child: Text('Osmanlı')),
            ],
          ),
        ],
      ),
      body: recipesAsync.when(
        data: (recipes) {
          final filtered = selectedCiv == null
              ? recipes
              : recipes.where((r) => r.civilization.contains(selectedCiv)).toList();

          if (filtered.isEmpty) {
            return const Center(child: Text('Tarif bulunamadı'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              final recipe = filtered[index];
              return _RecipeCard(recipe: recipe);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Hata: $error')),
      ),
    );
  }
}

class _RecipeCard extends StatelessWidget {
  final HistoricalRecipe recipe;

  const _RecipeCard({required this.recipe});

  Color _getCivilizationColor() {
    if (recipe.civilization.contains('Yunan')) return Colors.blue;
    if (recipe.civilization.contains('Roma')) return Colors.red;
    if (recipe.civilization.contains('Mısır')) return Colors.amber;
    if (recipe.civilization.contains('Sümer') || recipe.civilization.contains('Babil')) return Colors.brown;
    if (recipe.civilization.contains('Viking')) return Colors.blueGrey;
    if (recipe.civilization.contains('Çin') || recipe.civilization.contains('Han')) return Colors.red[800]!;
    if (recipe.civilization.contains('Japon') || recipe.civilization.contains('Nara') || recipe.civilization.contains('Heian')) {
      return Colors.pink;
    }
    if (recipe.civilization.contains('Hint') || recipe.civilization.contains('Vedik')) return Colors.orange;
    if (recipe.civilization.contains('Maya') || recipe.civilization.contains('Aztek')) return Colors.green;
    if (recipe.civilization.contains('Pers')) return Colors.indigo;
    if (recipe.civilization.contains('Osmanlı')) return Colors.purple;
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecipeDetailScreen(recipe: recipe),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [
                _getCivilizationColor().withOpacity(0.1),
                _getCivilizationColor().withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _getCivilizationColor().withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.restaurant, color: _getCivilizationColor(), size: 28),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          recipe.name,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          recipe.civilization,
                          style: TextStyle(
                            fontSize: 14,
                            color: _getCivilizationColor(),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                recipe.description,
                style: const TextStyle(fontSize: 14),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              if (recipe.ingredients != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.shopping_basket, size: 16, color: _getCivilizationColor()),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          recipe.ingredients!,
                          style: TextStyle(fontSize: 12, color: Colors.grey[800]),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class RecipeDetailScreen extends StatelessWidget {
  final HistoricalRecipe recipe;

  const RecipeDetailScreen({super.key, required this.recipe});

  Color _getCivilizationColor() {
    if (recipe.civilization.contains('Yunan')) return Colors.blue;
    if (recipe.civilization.contains('Roma')) return Colors.red;
    if (recipe.civilization.contains('Mısır')) return Colors.amber;
    if (recipe.civilization.contains('Sümer') || recipe.civilization.contains('Babil')) return Colors.brown;
    if (recipe.civilization.contains('Viking')) return Colors.blueGrey;
    if (recipe.civilization.contains('Çin') || recipe.civilization.contains('Han')) return Colors.red[800]!;
    if (recipe.civilization.contains('Japon') || recipe.civilization.contains('Nara') || recipe.civilization.contains('Heian')) {
      return Colors.pink;
    }
    if (recipe.civilization.contains('Hint') || recipe.civilization.contains('Vedik')) return Colors.orange;
    if (recipe.civilization.contains('Maya') || recipe.civilization.contains('Aztek')) return Colors.green;
    if (recipe.civilization.contains('Pers')) return Colors.indigo;
    if (recipe.civilization.contains('Osmanlı')) return Colors.purple;
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.name),
        backgroundColor: _getCivilizationColor(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [
                      _getCivilizationColor().withOpacity(0.2),
                      _getCivilizationColor().withOpacity(0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(Icons.restaurant_menu, size: 80, color: _getCivilizationColor()),
                    const SizedBox(height: 16),
                    Text(
                      recipe.name,
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: _getCivilizationColor().withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        recipe.civilization,
                        style: TextStyle(
                          color: _getCivilizationColor(),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildInfoCard('Hakkında', recipe.description, Icons.info, Colors.blue),
            _buildInfoCard('Dönem', recipe.period, Icons.calendar_today, Colors.purple),
            if (recipe.ingredients != null)
              _buildInfoCard('Malzemeler', recipe.ingredients!, Icons.shopping_basket, Colors.green),
            if (recipe.preparation != null)
              _buildInfoCard('Hazırlanışı', recipe.preparation!, Icons.restaurant, Colors.orange),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String content, IconData icon, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              content,
              style: const TextStyle(fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}
