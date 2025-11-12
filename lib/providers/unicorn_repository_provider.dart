// lib/providers/unicorn_repository_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/unicorn_repository.dart';

final unicornRepositoryProvider = Provider<UnicornRepository>((ref) {
  return UnicornRepository(); // a new instance per run
});
