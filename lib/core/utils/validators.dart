class Validators {
  static bool isValidPhone(String phone) {
    return phone.length >= 9;
  }

  static bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  static bool isValidName(String name) {
    return name.isNotEmpty && name.length >= 2;
  }

  static bool isNotEmpty(String value) {
    return value.trim().isNotEmpty;
  }
}
