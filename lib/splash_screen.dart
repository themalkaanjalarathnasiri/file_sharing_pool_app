import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import 'package:share_pool/common/theme/app_theme.dart';
import 'package:share_pool/features/authentication/providers/authentication_provider.dart';
import 'package:share_pool/features/authentication/screens/login_view/login_view.dart';

import 'common/utils/assets_paths.dart';
import 'common/utils/nav_transition_utils.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState(){
    super.initState();
    navigateToNextScreen();
  }

  Future<void> navigateToNextScreen() async{
     Future.delayed(Duration(seconds: 5),(){
       final authProvider = Provider.of<AuthenticationProvider>(context,listen: false);
       authProvider.checkAuthenticationState(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SafeArea(child: Stack(
        alignment: Alignment.center,
        children: [
          Container(

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                 Expanded(child: SizedBox(
                    height:  200,
                    width: double.maxFinite,
                    child: RiveAnimation.asset('assets/animations/security_card.riv',fit: BoxFit.fitWidth,))),


                ],),
          ),
          Positioned(
            bottom: 50,
            child: LoadingAnimationWidget.staggeredDotsWave(
             color:Colors.white,
              size: 40,
            ),
          ),
        ],
      )),);
  }
}
