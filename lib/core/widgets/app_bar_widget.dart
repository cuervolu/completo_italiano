import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBackButton;

  const AppBarWidget({
    super.key,
    required this.title,
    this.actions,
    this.showBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: true,
      leading:
          showBackButton
              ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  // Safer back navigation that checks if we can pop
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    // If we can't pop, navigate to the home screen
                    context.go('/');
                  }
                },
              )
              : IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
      actions:
          actions ??
          [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                context.pushNamed('search');
              },
            ),

            // Menú de opciones
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (value) {
                switch (value) {
                  case 'settings':
                    context.pushNamed('settings');
                    break;
                }
              },
              itemBuilder:
                  (context) => [
                    const PopupMenuItem(
                      value: 'settings',
                      child: Row(
                        children: [
                          Icon(Icons.settings, size: 20),
                          SizedBox(width: 8),
                          Text('Configuración'),
                        ],
                      ),
                    ),
                  ],
            ),
          ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}