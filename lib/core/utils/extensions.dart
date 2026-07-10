extension StringExtension on String {
  bool get isValidEmail {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(this);
  }

  bool get isValidPhone {
    return length >= 9;
  }

  String get capitalizeFirst {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}

extension ListExtension<T> on List<T> {
  bool get isNotEmptyList => isNotEmpty;
  
  List<T> removeDuplicates() {
    return toSet().toList();
  }
}
