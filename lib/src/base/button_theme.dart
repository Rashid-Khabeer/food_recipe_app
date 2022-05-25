part of 'themes.dart';

class _MaterialStateProperty<T> implements MaterialStateProperty<T> {
  const _MaterialStateProperty(this.value);

  final T? value;

  @override
  T resolve(Set<MaterialState> states) => value!;
}

class _ColorProperty<T> implements MaterialStateProperty<T> {
  const _ColorProperty(this.enabled, this.disabled);

  final T enabled;
  final T disabled;

  @override
  T resolve(Set<MaterialState> states) {
    if (states.contains(MaterialState.disabled)) {
      return disabled;
    } else {
      return enabled;
    }
  }
}
