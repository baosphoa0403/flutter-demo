abstract class StringValidator {
  bool isValid(String value);
}

class NonEmptyStringValidator extends StringValidator {
  @override
  bool isValid(String value) {
    return value.isNotEmpty;
  }
}

// mixin is class and used to extend existing classes
class EmailAndPasswordValidator {
  final StringValidator emailValidator = NonEmptyStringValidator();
  final StringValidator passValidator = NonEmptyStringValidator();
  final String invalidEmailErrorText = "Email can't be empty";
  final String invalidPassErrorText = "Pass can't be empty";
}
