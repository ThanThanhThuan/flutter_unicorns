// lib/screens/unicorn_detail_screen.dart
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/unicorn_notifier.dart';
import '../models/unicorn.dart';
import 'unicorn_form_screen.dart';

class UnicornDetailScreen extends ConsumerWidget {
  final String unicornId;
  const UnicornDetailScreen({required this.unicornId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unicornsAsync = ref.watch(unicornNotifierProvider);

    return Scaffold(
      body: unicornsAsync.when(
        data: (list) {
          final unicorn = list.firstWhereOrNull((u) => u.id == unicornId);
          if (unicorn == null) {
            return const Center(child: Text('No Unicorn to show'));
          }
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                title: Text(unicorn.name),
                floating: true,
                snap: true,
                expandedHeight: 140,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(unicorn.name),
                  background: Container(
                    color: _colorFromName(unicorn.colour),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      Text(
                        'Name: ${unicorn.name}',
                        style: const TextStyle(fontSize: 22),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Age: ${unicorn.age}',
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Color: ${unicorn.colour}',
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          ElevatedButton.icon(
                            icon: const Icon(Icons.edit),
                            label: const Text('Edit'),
                            onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => UnicornFormScreen(
                                  unicorn: unicorn,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.delete),
                            label: const Text('Delete'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            onPressed: () async {
                              await ref
                                  .read(unicornNotifierProvider.notifier)
                                  .delete(unicornId);
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Color _colorFromHex(String hex) {
    final hexStr = hex.replaceAll('#', '');
    if (hexStr.length == 6) return Color(int.parse('FF$hexStr', radix: 16));
    return Colors.grey;
  }

  static const Map<String, Color> colorNames = {
    'red': Colors.red,
    'blue': Colors.blue,
    'green': Colors.green,
    'yellow': Colors.yellow,
    'orange': Colors.orange,
    'purple': Colors.purple,
    'black': Colors.black,
    'white': Colors.white,
    // Add more colors as needed
  };

// A function to get a Color from a name string
  Color? _colorFromName(String name) {
    // Normalize the name (e.g., convert to lowercase) to ensure a match
    final normalizedName = name.toLowerCase();
    if (colorNames.containsKey(normalizedName)) {
      return colorNames[normalizedName];
    }
    return colorNames['grey']; // Default color if name not found
  }
}
