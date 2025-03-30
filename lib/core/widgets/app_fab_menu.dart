import 'package:flutter/material.dart';

class AppFabMenu extends StatefulWidget {
  final VoidCallback onCreateStory;
  final VoidCallback onCreateCharacter;

  const AppFabMenu({
    super.key,
    required this.onCreateStory,
    required this.onCreateCharacter,
  });

  @override
  State<AppFabMenu> createState() => _AppFabMenuState();
}

class _AppFabMenuState extends State<AppFabMenu>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _rotateAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _translateStoryAnimation;
  late Animation<double> _translateCharacterAnimation;

  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _rotateAnimation = Tween<double>(begin: 0, end: 0.375).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _scaleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _translateStoryAnimation = Tween<double>(begin: 0, end: -100).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _translateCharacterAnimation = Tween<double>(begin: 0, end: -170).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _isOpen = !_isOpen;
      if (_isOpen) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _translateCharacterAnimation.value),
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: child,
              ),
            );
          },
          child: FloatingActionButton(
            heroTag: "btnCreateCharacter",
            backgroundColor: Theme.of(context).colorScheme.secondary,
            onPressed: () {
              _toggle();
              widget.onCreateCharacter();
            },
            child: const Icon(Icons.person_add),
          ),
        ),
        AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _translateStoryAnimation.value),
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: child,
              ),
            );
          },
          child: FloatingActionButton(
            heroTag: "btnCreateStory",
            onPressed: () {
              _toggle();
              widget.onCreateStory();
            },
            child: const Icon(Icons.create_new_folder),
          ),
        ),

        AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.rotate(
              angle: _rotateAnimation.value * 2 * 3.14159,
              child: child,
            );
          },
          child: FloatingActionButton(
            heroTag: "btnMain",
            onPressed: _toggle,
            child: Icon(_isOpen ? Icons.close : Icons.add),
          ),
        ),
      ],
    );
  }
}
