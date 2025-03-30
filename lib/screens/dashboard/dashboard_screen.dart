import 'package:completo_italiano/config/logger/app_logger.dart';
import 'package:completo_italiano/data/db/database.dart';
import 'package:completo_italiano/data/repositories/story_repository.dart';
import 'package:completo_italiano/providers/database_provider.dart';
import 'package:completo_italiano/screens/dashboard/widgets/empty_dashboard.dart';
import 'package:completo_italiano/screens/dashboard/widgets/story_grid_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final storyRepositoryProvider = Provider<StoryRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return StoryRepository(
    storyDao: db.storyDao,
    storyboardDao: db.storyboardDao,
  );
});

final storiesProvider = FutureProvider<List<Story>>((ref) {
  final repository = ref.watch(storyRepositoryProvider);
  return repository.getAllStories();
});

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storiesAsync = ref.watch(storiesProvider);

    return storiesAsync.when(
      data: (stories) {
        if (stories.isEmpty) {
          return const EmptyDashboard();
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: stories.length,
          itemBuilder: (context, index) {
            final story = stories[index];
            return StoryGridItem(story: story);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) {
        logger.e('Error cargando historias', error: error, stackTrace: stackTrace);
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Error al cargar historias',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => ref.refresh(storiesProvider),
                child: const Text('Reintentar'),
              ),
            ],
          ),
        );
      },
    );
  }
}
