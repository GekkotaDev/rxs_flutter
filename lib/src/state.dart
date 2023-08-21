// ignore_for_file: invalid_use_of_protected_member

import "package:flutter/widgets.dart";
import "package:rxs/rxs.dart" as rxs;

class LocalState<T> extends rxs.WritableState<T> {
  final WeakReference<State> parent;

  LocalState(
    T state, {
    required this.parent,
  }) {
    ctx.$.add(state);
  }

  @override
  void set(T value) {
    super.set(value);
    parent.target?.setState(() {});
  }

  @override
  void update(rxs.StateUpdater<T> setter) {
    super.update(setter);
    parent.target?.setState(() {});
  }

  @override
  void mutate(rxs.StateMutator<T> mutator) {
    super.mutate(mutator);
    parent.target?.setState(() {});
  }
}

extension Reactive on State {
  LocalState<T> state<T>(T state) =>
      LocalState(state, parent: WeakReference(this));

  rxs.ReadOnlyState<T> stateFrom<T>(rxs.Composite<T> composite) =>
      rxs.state.from(composite, onAccess: (notification) {
        final parent = WeakReference(this);
        if (notification != null) parent.target?.setState(() {});
      });
}
