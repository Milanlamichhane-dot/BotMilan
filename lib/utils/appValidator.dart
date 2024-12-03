class AppValidator {
  String? validateEmail(value) {
    if (value!.isEmpty) {
      return "Please enter an email";
    }
    RegExp emailRegExp = RegExp(
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
    );
    if (!emailRegExp.hasMatch(value)) {
      return "Please enter a valid email";
    }
    return null;
  }

  String? validateNumber(value) {
    if (value!.isEmpty) {
      return "Please enter a phone number";
    }
    if (value.length != 10) {
      return "Enter 10 digit  phone Number";
    }
    return null;
  }

  String? validatePassword(value) {
    if (value!.isEmpty) {
      return "Please enter a password";
    }
    return null;
  }
}
