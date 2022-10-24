import 'package:flutter/material.dart';
import 'package:stacked_themes/stacked_themes.dart';

class PolicyScreen extends StatefulWidget {
  PolicyScreen({Key? key, required this.policy}) : super(key: key);
  String policy;

  @override
  _PolicyScreenState createState() => _PolicyScreenState();
}

class _PolicyScreenState extends State<PolicyScreen> {
  bool isDark = false;
  @override
  void initState() {
    isDark = getThemeManager(context).selectedThemeMode == ThemeMode.dark;
    setState(() {
      
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Policy'),
      ),
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                    margin: EdgeInsets.only(left: 20, right: 20, top: 30),
                    child: widget.policy.isNotEmpty
                        ? Text(
                            widget.policy,
                            style:
                                TextStyle(color: isDark ? Colors.white : Colors.black.withOpacity(0.7), fontSize: 17),
                            textAlign: TextAlign.justify,
                          )
                        : Text(
                            "No Policy",
                            style: TextStyle(color: isDark ? Colors.white :Colors.black.withOpacity(0.7), fontSize: 17),
                            textAlign: TextAlign.justify,
                          )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
