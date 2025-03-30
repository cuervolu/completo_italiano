import 'package:completo_italiano/core/widgets/app_bar_widget.dart';
import 'package:completo_italiano/core/widgets/app_drawer.dart';
import 'package:completo_italiano/core/widgets/app_fab_menu.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:completo_italiano/providers/database_provider.dart';

final hasStoriesProvider = FutureProvider<bool>((ref) async {
  final db = ref.read(databaseProvider);
  final stories = await db.storyDao.getAllStories();
  return stories.isNotEmpty;
});

class AppShell extends ConsumerWidget {
  final Widget child;
  final String title;
  final List<Widget>? appBarActions;
  final bool showBackButton;
  final bool enableFab;

  const AppShell({
    super.key,
    required this.child,
    required this.title,
    this.appBarActions,
    this.showBackButton = false,
    this.enableFab = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentRoute = GoRouterState.of(context).matchedLocation;
    
    return Scaffold(
      appBar: AppBarWidget(
        title: title,
        actions: appBarActions,
        showBackButton: showBackButton,
      ),
      drawer: AppDrawer(currentRoute: currentRoute),
      body: child,
      floatingActionButton: enableFab ? _buildFab(context, ref) : null,
    );
  }
  
  Widget _buildFab(BuildContext context, WidgetRef ref) {
    return AppFabMenu(
      onCreateStory: () {
        context.pushNamed('new_story');
      },
      onCreateCharacter: () {
        final hasStoriesAsync = ref.read(hasStoriesProvider);
        
        hasStoriesAsync.whenData((hasStories) {
          if (!hasStories) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Se necesita una historia'),
                content: const Text(
                  'Para crear un personaje, primero debes crear al menos una historia donde ubicarlo.',
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      context.pushNamed('new_story');
                    },
                    child: const Text('Crear Historia'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancelar'),
                  ),
                ],
              ),
            );
          } else {
            context.pushNamed('new_character');
          }
        });
      },
    );
  }
}