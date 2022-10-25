class Validators {
  Validators._();

  /// Validates if the given string is empty
  static String? emptyStringValidator(
    String? value,
    String valueType,
  ) {
    if (value == null) {
      return null;
    } else if (value.isEmpty) {
      return "$valueType can't be empty";
    }  else if (value == '') {
      return "$valueType can't be empty";
    } else if (value == '0') {
      return "$valueType can't be zero";
    } else {
      return null;
    }
  }

  static String? depositAmountValidator(
    String? value,
    String valueType,
  ) {
    if (value == null) {
      return null;
    } else if (value.isEmpty) {
      return "$valueType can't be empty";
    }  else if (int.parse(value) < 15) {
      return "$valueType can't be less than 15";
    } else if (int.parse(value) >  54) {
      return "$valueType can't be greater than 45";
    } else {
      return null;
    }
  }

  static String? bookingTimeValidator(
    String start,
    String end,
  ) {
    if (int.parse(start) > int.parse(end)) {
      return 'Booking starting time must be earlier than the ending time';
    } else {
      return null;
    }
  }

  /// Validates the Email for User Authentication
  static String? emailValidator(String? email) {
    final RegExp emailRegExp = RegExp(
      r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
    );

    if (email == null) {
      return null;
    } else if (email.isEmpty) {
      return "Email can't be empty";
    } else if (!emailRegExp.hasMatch(email)) {
      return "Invalid Email Address";
    } else {
      return null;
    }
  }

  /// Validates the Password for User Authentication
  static String? passwordValidator(String? password) {
    // ignore: unnecessary_raw_strings
    final digitRegExp = RegExp(r'[0-9]');

    if (password == null) {
      return null;
    } else if (password.isEmpty) {
      return "Password can't be empty";
    } else if (!digitRegExp.hasMatch(password)) {
      return "Password must contain at least one digit";
    } else if (password.length < 8) {
      return "Password must be 8 characters long";
    } else {
      return null;
    }
  }

  /// Validates the Date Of Birth for Account Creation
  static String? dobValidator({
    required String? dob,
    required int age,
  }) {
    if (dob == null) {
      return null;
    } else if (dob.isEmpty) {
      return "Date can't be empty";
    } else if (age <= 16) {
      return "You must be over 16 to create a seller account";
    } else {
      return null;
    }
  }

  static String? userNameValidator({
    required String? username,
    required bool alreadyExists,
  }) {
    if (username == null) {
      return null;
    } else if (username.isEmpty) {
      return "Username can't be empty";
    } else if (alreadyExists) {
      return "Username already exists";
    } else {
      return null;
    }
  }
}
