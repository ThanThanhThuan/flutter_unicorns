// lib/providers/unicorn_notifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_unicorns/providers/unicorn_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/unicorn.dart';
import '../repositories/unicorn_repository.dart';

part 'unicorn_notifier.g.dart';

@riverpod
class UnicornNotifier extends _$UnicornNotifier {
  // The generated part will turn this into a StateNotifier<AsyncValue<List<Unicorn>>>
  @override
  Future<List<Unicorn>> build() {
    final repo = ref.watch(unicornRepositoryProvider);
    // Directly return the Future
    return repo.fetchAll();
  }

  /// Helper: refresh the list after any mutation
  Future<void> _refresh() async {
    state = AsyncLoading();
    try {
      final repo = ref.read(unicornRepositoryProvider);
      state = AsyncData(await repo.fetchAll());
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> create(String name, int age, String color) async {
    state = AsyncLoading();
    try {
      final repo = ref.read(unicornRepositoryProvider);
      await repo.createUnicorn(name, age, color);
      await _refresh();
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> updateUnicorn(Unicorn u) async {
    state = AsyncLoading();
    try {
      final repo = ref.read(unicornRepositoryProvider);
      await repo.updateUnicorn(u);
      await _refresh();
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> delete(String id) async {
    state = AsyncLoading();
    try {
      final repo = ref.read(unicornRepositoryProvider);
      await repo.deleteUnicorn(id);
      await _refresh();
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
