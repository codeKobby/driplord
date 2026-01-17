import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/components/common/driplord_scaffold.dart';
import 'body_measurements_screen.dart';

class StylePreferenceScreen extends StatefulWidget {
  const StylePreferenceScreen({super.key});

  @override
  State<StylePreferenceScreen> createState() => _StylePreferenceScreenState();
}

class _StylePreferenceScreenState extends State<StylePreferenceScreen> {
  final List<Map<String, String>> _styles = [
    {
      "name": "STREETWEAR",
      "image":
          "https://images.unsplash.com/photo-1523381210434-271e8be1f52b?w=500&q=80",
    },
    {
      "name": "MINIMALIST",
      "image":
          "https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=500&q=80",
    },
    {
      "name": "VINTAGE",
      "image":
          "https://images.unsplash.com/photo-1520975954732-35dd2229969e?w=500&q=80",
    },
    {
      "name": "TECHWEAR",
      "image":
          "https://images.unsplash.com/photo-1552374196-1ab2a1c593e8?w=500&q=80",
    },
    {
      "name": "CASUAL",
      "image":
          "https://images.unsplash.com/photo-1516762689617-e1cffcef479d?w=500&q=80",
    },
    {
      "name": "FORMAL",
      "image":
          "https://images.unsplash.com/photo-1507679799987-c7377f323b88?w=500&q=80",
    },
    {
      "name": "Y2K",
      "image":
          "https://images.unsplash.com/photo-1551024601-bec78aea704b?w=500&q=80",
    },
    {
      "name": "LUXURY",
      "image":
          "https://images.unsplash.com/photo-1539109136881-3be0616acf4b?w=500&q=80",
    },
  ];

  final Set<String> _selectedStyles = {};

  void _toggleStyle(String style) {
    setState(() {
      if (_selectedStyles.contains(style)) {
        _selectedStyles.remove(style);
      } else {
        _selectedStyles.add(style);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DripLordScaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                visualDensity: VisualDensity.compact,
                icon: Icon(
                  LucideIcons.arrowLeft,
                  color: Theme.of(context).colorScheme.onSurface,
                  size: 20,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(height: 32),
              Text(
                "SELECT YOUR VIBE",
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.5),
                  letterSpacing: 2,
                  fontWeight: FontWeight.w900,
                ),
              ).animate().fadeIn(),
              const SizedBox(height: 8),
              Text(
                "Choose styles that define you.",
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  height: 1.1,
                ),
              ).animate().fadeIn(delay: 100.ms),

              const SizedBox(height: 48),

              Expanded(
                child: GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: _styles.length,
                  itemBuilder: (context, index) {
                    final style = _styles[index];
                    final styleName = style["name"]!;
                    final styleImage = style["image"]!;
                    final isSelected = _selectedStyles.contains(styleName);

                    return Semantics(
                      label:
                          'Style: $styleName, ${isSelected ? 'selected' : 'not selected'}',
                      button: true,
                      selected: isSelected,
                      excludeSemantics: true,
                      child: AnimatedScale(
                        duration: const Duration(milliseconds: 200),
                        scale: isSelected ? 0.95 : 1.0,
                        child: Material(
                          color: Theme.of(context).colorScheme.surface,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(
                              color: isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context)
                                      .colorScheme
                                      .outline
                                      .withValues(alpha: 0.2),
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: InkWell(
                            onTap: () => _toggleStyle(styleName),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.network(
                                  styleImage,
                                  fit: BoxFit.cover,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        Colors.black.withValues(alpha: 0.7),
                                      ],
                                      stops: const [0.6, 1.0],
                                    ),
                                  ),
                                ),
                                if (isSelected)
                                  Positioned(
                                    top: 12,
                                    right: 12,
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.check,
                                        size: 14,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onPrimary,
                                      ),
                                    ),
                                  ),
                                Positioned(
                                  bottom: 16,
                                  left: 16,
                                  right: 16,
                                  child: Text(
                                    styleName,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge
                                        ?.copyWith(
                                          fontWeight: FontWeight.w900,
                                          color: Colors.white,
                                          letterSpacing: 1,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                        .animate()
                        .fadeIn(delay: (index * 40).ms)
                        .scale(begin: const Offset(0.9, 0.9));
                  },
                ),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _selectedStyles.isNotEmpty
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const BodyMeasurementsScreen(),
                            ),
                          );
                        }
                      : null,
                  child: const Text("CONTINUE"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
