import 'package:flutter/material.dart';

class TransitionUtils {
  // Function for a fade transition
  static PageRouteBuilder fadeTransition({
    required WidgetBuilder builder,
    RouteSettings? settings,
  }) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => builder(context),
      settings: settings,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }
  //function to sum two numbers

  // Function for a slide transition from right to left
  static PageRouteBuilder slideTransitionFromRightToLeft({
    required WidgetBuilder builder,
    RouteSettings? settings,
  }) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => builder(context),
      settings: settings,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      },
    );
  }

  // Function for a slide transition from bottom to top
  static PageRouteBuilder slideTransitionFromBottomToTop({
    required WidgetBuilder builder,
    RouteSettings? settings,
  }) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => builder(context),
      settings: settings,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: Offset(0.0, 1.0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      },
    );
  }

  // Function for a scale transition
  static PageRouteBuilder scaleTransition({
    required WidgetBuilder builder,
    RouteSettings? settings,
  }) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => builder(context),
      settings: settings,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.fastOutSlowIn,
            ),
          ),
          child: child,
        );
      },
    );
  }
}
