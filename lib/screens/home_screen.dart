// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/unicorn_notifier.dart';
import '../screens/unicorn_form_screen.dart';
import '../screens/unicorn_detail_screen.dart';
import '../models/unicorn.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unicornsAsync = ref.watch(unicornNotifierProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text('Unicorns'),
            floating: true,
            snap: true,
            expandedHeight: 120,
            flexibleSpace: const FlexibleSpaceBar(
              title: Text('🌈 Unicorns'),
              centerTitle: true,
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(8),
            sliver: unicornsAsync.when(
              data: (list) => SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 3,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final u = list[index];
                    return GestureDetector(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => UnicornDetailScreen(unicornId: u.id),
                        ),
                      ),
                      child: Card(
                        color: _colorFromName(u.colour),
                        child: Center(
                          child: Text(
                            u.name + ' (Age: ${u.age})',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  childCount: list.length,
                ),
              ),
              loading: () => const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (err, st) => SliverFillRemaining(
                child: Center(
                  child: Text('Error: ${err.toString()}'),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const UnicornFormScreen()),
        ),
      ),
    );
  }

  // helper: crudcrud.com sends hex colour strings (e.g. "#FF00FF")
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
