import 'package:biometric_proj/screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  LocalAuthentication auth = LocalAuthentication();
  late bool _canCheckBiometric;
  late List<BiometricType> _availableBiometrics;
  String autherized = "Not Autherized";

  Future<void> _checkBiometric() async {
    late bool canCheckBiometric;
    try {
      canCheckBiometric = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;
    {
      setState(() {
        _canCheckBiometric = canCheckBiometric;
      });
      print(_canCheckBiometric);
    }
  }

  Future<void> _getAvailableBiometric() async {
    late List<BiometricType> availableBiometric;
    try {
      availableBiometric = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print(e);
    }
    setState(() {
      _availableBiometrics = availableBiometric;
      print(_availableBiometrics);
    });
  }

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      authenticated = await auth.authenticate(
          localizedReason: "Scan your finger to authenticate",
          useErrorDialogs: true,
          stickyAuth: false);
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;
    {
      setState(() {
        autherized = authenticated
            ? "Authentication Successful"
            : "Authentication failed";

        print(autherized);
        if (authenticated) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Screen()));
        }
        // AlertDialog alert = AlertDialog(
        //   title: Text("Authentication"),
        //   content: Text(autherized),
        // );
        // showDialog(
        //   context: context,
        //   builder: (BuildContext context) {
        //     return alert;
        //   },
        // );
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _checkBiometric();
    _getAvailableBiometric();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 43, 40, 48),
      body: Column(
        children: [
          Center(
            child: Container(
              margin: EdgeInsets.only(top: 90),
              child: Text(
                "Login",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 50),
            child: Column(
              children: [
                Image.asset('assets/fingerprint1.png', width: 100),
                Text("Authorized your account using fingerprint",
                    style: TextStyle(
                      color: Colors.white,
                    )),
              ],
            ),
          ),
          ElevatedButton(
              onPressed: () {
                _authenticate();
              },
              child: Text("Authenticate"))
        ],
      ),
    );
  }
}
