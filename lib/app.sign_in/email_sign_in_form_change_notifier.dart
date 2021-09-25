import 'package:demoflutter/app.sign_in/email_sign_in_change_model.dart';
import 'package:demoflutter/common_widgets/form_submit_button.dart';
import 'package:demoflutter/common_widgets/show_exception_diaglog.dart';
import 'package:demoflutter/service/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// important use blocC with streams of immutable object
// use ChangeNotifier with mutable object
class EmailSignInFormChangeNotifier extends StatefulWidget {
  final EmailSignInChangeModel model; // nhà cung cấp
  const EmailSignInFormChangeNotifier({Key? key, required this.model})
      : super(key: key);

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return ChangeNotifierProvider<EmailSignInChangeModel>(
      // class này có mixin là changeNotifier
      create: (_) => EmailSignInChangeModel(auth: auth), // khởi tạo
      child: Consumer<EmailSignInChangeModel>(
        builder: (_, model, __) => EmailSignInFormChangeNotifier(
          model: model,
        ),
      ),
    );
  }

  @override
  _EmailSignInFormState createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInFormChangeNotifier> {
  // const EmailSignInFormStateful({Key? key}) : super(key: key);

  final TextEditingController _emailController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _passwordFocusNode = FocusNode();
  // EmailSignInFormType _formType = EmailSignInFormType.register;
  EmailSignInChangeModel get model =>
      widget.model; // RECOMMEND USE GETTER IN STATEFUL
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  List<Widget> _buildChildren() {
    return [
      _buttonEmailTextField(),
      const SizedBox(
        height: 20,
        width: 20,
      ),
      _buttonPasswordTextField(),
      FormSubmitButton(
        text: model.primaryButtonText,
        onPressed: model.canSubmit ? _submit : null,
      ),
      ElevatedButton(
          onPressed: !model.isLoading ? () => _toogleFormType(model) : null,
          child: Text(
            model.secondaryText,
            style: const TextStyle(color: Colors.black),
          ),
          style: ElevatedButton.styleFrom(
            primary: Colors.white, // background
            onPrimary: Colors.white, // foreground
            //  fixedSize: Size(300, 500)
          )),
    ];
  }

  TextField _buttonPasswordTextField() {
    return TextField(
        decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: "password",
            hintText: "123",
            errorText:
                model.showErrorText(model.password, model.invalidPassErrorText),
            enabled: model.isLoading == false),
        obscureText: true, // same same type password html
        controller: _passwordController,
        textInputAction: TextInputAction.done,
        focusNode: _passwordFocusNode,
        onChanged: (password) => {widget.model.updatePassword(password)},
        // {print("password" + password)},
        onEditingComplete: () => _submit());
  }

  TextField _buttonEmailTextField() {
    return TextField(
      decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: "email",
          hintText: "bao@gmail.com",
          errorText:
              model.showErrorText(model.email, model.invalidEmailErrorText),
          enabled: model.isLoading == false),
      // autocorrect: true,
      autofocus: true,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      controller: _emailController,
      focusNode: _emailFocusNode,
      onChanged: (email) => {
        {model.updateEmail(email)}
      },
      onEditingComplete: () {
        final newFocus = model.emailValidator
                .isValid(model.email) // check có cho chuyển forcus ko
            ? _passwordFocusNode
            : _emailFocusNode;
        FocusScope.of(context).requestFocus(newFocus);
      },
    );
  }

  void _submit() async {
    // build context always have in stateFull but need to passed inside stateless widget
    try {
      await widget.model.submit();
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      showExceptionAlertDialog(context,
          exception: e, title: "Sign in Failed", deafaultActionTex: "ok");
    }
  }

  void _toogleFormType(EmailSignInChangeModel model) {
    widget.model.toogleFormType();
    FocusScope.of(context).requestFocus(_emailFocusNode);
    _emailController.clear();
    _passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch, // chìu ngang
        mainAxisSize: MainAxisSize.min, // theo chìu dọc bỏ khoảng trắng bớt
        children: _buildChildren(),
      ),
    );
  }
}
