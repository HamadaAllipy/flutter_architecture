// Flutter imports:
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_architecture/app/di.dart';
import 'package:flutter_architecture/presentation/common/state_renderer/state_renderer_impl.dart';

// Project imports:
import 'package:flutter_architecture/presentation/login/viewModel/login_view_model.dart';
import 'package:flutter_architecture/presentation/res/res.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> with WidgetsBindingObserver {
  final LoginViewModel _viewModel = instance<LoginViewModel>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        log('Resumed');
        break;
      case AppLifecycleState.inactive:
        log('Inactive');
        break;
      case AppLifecycleState.paused:
        log('Paused');
        break;
      case AppLifecycleState.detached:
        log('Detached');
        break;
    }
  }

  @override
  void initState() {
    _bind();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  _bind() {
    _viewModel.start();
    _emailController
        .addListener(() => _viewModel.setEmail(_emailController.text));
    _passwordController
        .addListener(() => _viewModel.setPassword(_passwordController.text));
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<FlowState>(
        stream: _viewModel.outputFlowStateStream,
        builder: (BuildContext context, AsyncSnapshot<FlowState> snapshot) {
            return snapshot.data?.getScreen(
              context: context,
              contentView: getContentWidget(),
              retryActionButton: () {
                _viewModel.login();
              },
            )??getContentWidget();
        },
      ),
    );
  }


  Widget getContentWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppPadding.p20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: AppSize.s100,
            ),
            Center(
              child: Image.asset(ImagesManager.splashLogo),
            ),
            const SizedBox(
              height: AppSize.s25,
            ),
            StreamBuilder<bool>(
              stream: _viewModel.isEmailValidStream,
              builder: (context, snapshot) {
                bool isValid = snapshot.data ?? true;
                return TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: AppStrings.email,
                    labelText: AppStrings.email,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSize.s12),
                    ),
                    errorText: isValid ? null : AppStrings.emailError,
                  ),
                );
              },
            ),
            const SizedBox(
              height: AppSize.s25,
            ),
            StreamBuilder<bool>(
              stream: _viewModel.isPasswordValidStream,
              builder: (context, snapshot) {
                bool isValid = snapshot.data ?? true;
                return TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: _passwordController,
                  decoration: InputDecoration(
                    hintText: AppStrings.password,
                    labelText: AppStrings.password,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSize.s12),
                    ),
                    errorText: isValid ? null : AppStrings.passwordError,
                  ),
                );
              },
            ),
            const SizedBox(
              height: AppSize.s25,
            ),
            SizedBox(
              width: double.infinity,
              height: AppSize.s50,
              child: StreamBuilder<bool>(
                stream: _viewModel.areFieldsValid,
                builder: (_, snapshot) {
                  bool isValid = snapshot.data ?? false;

                  return ElevatedButton(
                    onPressed: isValid ? () {
                      _viewModel.login();
                    } : null,
                    child: const Text(
                      AppStrings.login,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(
              height: AppSize.s25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    AppStrings.forgetPassword,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    AppStrings.registerText,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
