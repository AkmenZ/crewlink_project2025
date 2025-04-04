import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'common_providers.g.dart';

// file for generic providers

@riverpod
class CreateAccount extends _$CreateAccount {
  @override
  bool build() => false; // init state

  void toggle() {
    state = !state; // toggle states
  }
}
