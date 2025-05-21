import 'package:flutter/material.dart';
import 'package:mtac_driver/configs/api_config.dart';
import 'package:mtac_driver/controller/user/login_controller.dart';
import 'package:mtac_driver/utils/text_util.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final ApiConfig _apiConfig = ApiConfig();
  final LoginController _loginController = LoginController();
  //
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    final serverIsUp = await _apiConfig.checkServerStatus();

    if (serverIsUp) {
      await Future.delayed(const Duration(milliseconds: 500));
      _loginController.checkLoginStatus();
    } else {
      _showServerError();
    }
  }

  void _showServerError() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l10n.txtErrConnectSP),
        content: const Text(txtSubErrConnectSP),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _initializeApp();
            },
            child: Text(l10n.txtRetryNI),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          "assets/image/loadingDot.gif",
          width: 70,
          height: 70,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
