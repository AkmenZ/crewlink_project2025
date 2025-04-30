import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'common_providers.g.dart';

// file for generic providers

// toggle login/signup
@riverpod
class CreateAccount extends _$CreateAccount {
  @override
  bool build() => false; // init state

  void toggle() {
    state = !state; // toggle states
  }
}

// hold selected index for bottom nav bar
@riverpod
class BottomNavIndex extends _$BottomNavIndex {
  @override
  int build() => 0;

  void setIndex(int newIndex) => state = newIndex;
}

// loading state
@riverpod
class LoadingState extends _$LoadingState {
  @override
  bool build() => false; // init state

  void startLoading() {
    state = true;
  }

  void stopLoading() {
    state = false;
  }
}
