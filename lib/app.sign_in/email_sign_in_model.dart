import 'package:demoflutter/app.sign_in/validator.dart';

enum EmailSignInFormType { signIn, register }

class EmailSignInModel with EmailAndPasswordValidator {
  final String email, password;
  final EmailSignInFormType formType;
  final bool isLoading, submitted;
  EmailSignInModel(
      {this.email = "",
      this.password = "",
      this.formType = EmailSignInFormType.signIn,
      this.isLoading = false,
      this.submitted = false});

  EmailSignInModel copyWith(
      {String? email,
      String? password,
      EmailSignInFormType? formType,
      bool? isLoading,
      submitted}) {
    return EmailSignInModel(
        email: email ?? this.email,
        formType: formType ?? this.formType,
        isLoading: isLoading ?? this.isLoading,
        password: password ?? this.password,
        submitted: submitted ?? this.submitted);
  }

  String get primaryButtonText {
    return formType == EmailSignInFormType.signIn
        ? "Sign In"
        : "Create Account";
  }

  String get secondaryText {
    return formType == EmailSignInFormType.signIn
        ? "Need an Account? Register"
        : "have an account ? SignIn";
  }

  bool get canSubmit {
    return emailValidator.isValid(email) &&
        emailValidator.isValid(password) &&
        !isLoading;
  }

  String? showErrorText(String value, String mess) {
    final flag = submitted && !emailValidator.isValid(value);
    return flag ? mess : null;
  }
  // kiểm tra tình huống đã submit mà error firebase ném về
  // xong ngta xoá đi content thì empty => false => là null vì vậy phải phủ định !false => true show error
}
