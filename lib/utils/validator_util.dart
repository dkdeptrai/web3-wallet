class ValidatorUtil {
  static bool isEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  static bool isPassword(String password) {
    return password.length >= 6;
  }

  static bool isPasswordMatch(String password, String confirmPassword) {
    return password == confirmPassword;
  }

  static bool isName(String name) {
    return name.length >= 3;
  }

  static bool isPhoneNumber(String phoneNumber) {
    return RegExp(r'^[0-9]{10}$').hasMatch(phoneNumber);
  }

  static bool isAddress(String address) {
    return address.length >= 3;
  }
}
