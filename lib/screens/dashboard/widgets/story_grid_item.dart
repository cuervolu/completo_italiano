import 'package:completo_italiano/data/db/database.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class StoryGridItem extends StatelessWidget {
  final Story story;

  const StoryGridItem({super.key, required this.story});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(
          'story_detail',
          pathParameters: {'id': story.id.toString()},
        );
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Imagen o color de fondo
            Expanded(
              flex: 3,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Fondo de la tarjeta
                  if (story.backgroundImage != null)
                    // Imagen personalizada si existe
                    Image.asset(
                      story.backgroundImage!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        // Si hay error al cargar la imagen, mostrar un color
                        return Container(
                          color: _getBackgroundColor(story.title),
                        );
                      },
                    )
                  else
                    // Color generado basado en el título
                    Container(color: _getBackgroundColor(story.title)),

                  // Gradiente para mejorar legibilidad del texto
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.5),
                          ],
                          stops: const [0.6, 1.0],
                        ),
                      ),
                    ),
                  ),

                  // Título sobre la imagen
                  Positioned(
                    bottom: 12,
                    left: 12,
                    right: 12,
                    child: Text(
                      story.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        shadows: [
                          Shadow(
                            offset: Offset(1, 1),
                            blurRadius: 3,
                            color: Colors.black54,
                          ),
                        ],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

            // Información adicional
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Género
                    if (story.genre != null)
                      Text(
                        story.genre!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                    const SizedBox(height: 4),

                    // Descripción
                    if (story.description != null)
                      Expanded(
                        child: Text(
                          story.description!,
                          style: Theme.of(context).textTheme.bodySmall,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Generate a background color based on the story title.
  Color _getBackgroundColor(String title) {
    // A simple hash function to generate a unique number from the title
    final hash = title.hashCode;

    // Generate a paste color based on the hash
    const baseHue = 30; // Base shade for cream
    final saturation = 0.2 + (hash % 30) / 100; // Between 0.2 y 0.5
    final lightness = 0.7 + (hash % 20) / 100; // Between 0.7 y 0.9

    return HSLColor.fromAHSL(
      1.0,
      baseHue as double,
      saturation,
      lightness,
    ).toColor();
  }
}
