import 'package:demoflutter/app.sign_in/email_sign_in_bloc.dart';
import 'package:demoflutter/app.sign_in/email_sign_in_model.dart';
import 'package:demoflutter/common_widgets/form_submit_button.dart';
import 'package:demoflutter/common_widgets/show_exception_diaglog.dart';
import 'package:demoflutter/service/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmailSignInFormBlocBased extends StatefulWidget {
  final EmailSignInBloc bloc;
  const EmailSignInFormBlocBased({Key? key, required this.bloc})
      : super(key: key);

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return Provider<EmailSignInBloc>(
      create: (_) => EmailSignInBloc(auth: auth),
      child: Consumer<EmailSignInBloc>(
        builder: (_, bloc, __) => EmailSignInFormBlocBased(
          bloc: bloc,
        ),
      ),
    );
  }

  @override
  _EmailSignInFormState createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInFormBlocBased> {
  // const EmailSignInFormStateful({Key? key}) : super(key: key);

  final TextEditingController _emailController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _passwordFocusNode = FocusNode();
  // EmailSignInFormType _formType = EmailSignInFormType.register;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  List<Widget> _buildChildren(EmailSignInModel model) {
    return [
      _buttonEmailTextField(model),
      const SizedBox(
        height: 20,
        width: 20,
      ),
      _buttonPasswordTextField(model),
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

  TextField _buttonPasswordTextField(EmailSignInModel model) {
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
        onChanged: (password) => {widget.bloc.updatePassword(password)},
        // {print("password" + password)},
        onEditingComplete: () => _submit());
  }

  TextField _buttonEmailTextField(EmailSignInModel model) {
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
        {widget.bloc.updateEmail(email)}
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
      await widget.bloc.submit();
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      showExceptionAlertDialog(context,
          exception: e, title: "Sign in Failed", deafaultActionTex: "ok");
    }
  }

  void _toogleFormType(EmailSignInModel model) {
    widget.bloc.toogleFormType();
    FocusScope.of(context).requestFocus(_emailFocusNode);
    _emailController.clear();
    _passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<EmailSignInModel>(
        stream: widget.bloc.modelStream,
        initialData: EmailSignInModel(),
        builder: (context, snapshot) {
          final EmailSignInModel model = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch, // chìu ngang
              mainAxisSize:
                  MainAxisSize.min, // theo chìu dọc bỏ khoảng trắng bớt
              children: _buildChildren(model),
            ),
          );
        });
  }
}
