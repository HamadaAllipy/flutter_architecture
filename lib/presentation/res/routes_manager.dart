import 'package:flutter/material.dart';
import 'package:flutter_architecture/presentation/res/res.dart';
import 'package:flutter_architecture/presentation/screens.dart';

class Routes {
  Routes._();

  static const String splashRoute = '/';
  static const String onBoardingRoute = '/onBoarding';
  static const String loginRoute = '/login';
  static const String registerRoute = '/register';
  static const String mainRoute = '/main';
}

class RoutesGenerator {
  static Route getRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splashRoute:
        return _move(const SplashView());
      case Routes.onBoardingRoute:
        return _move(const OnBoardingView());
      default:
        return _move(_noRouteWidget());
    }
  }

  static _move(Widget widget) {
    return MaterialPageRoute(builder: (BuildContext context) => widget);
  }

  static Widget _noRouteWidget() {
    return const Scaffold(
      body: Center(
        child: Text(
          AppStrings.noRouteFound,
        ),
      ),
    );
  }
}
