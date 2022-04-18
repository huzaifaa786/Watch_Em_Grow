import 'package:flutter/material.dart';
import 'package:mipromo/ui/settings/settings_viewmodel.dart';
import 'package:mipromo/ui/shared/widgets/basic_loader.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_themes/stacked_themes.dart';
import 'package:velocity_x/velocity_x.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SettingsViewModel>.reactive(
      onModelReady: (model) => model.init(
        isDark: getThemeManager(context).selectedThemeMode == ThemeMode.dark,
      ),
      builder: (context, model, child) => model.isBusy
          ? const BasicLoader()
          : Scaffold(
              appBar: AppBar(
                title: "Settings".text.make(),
              ),
              body: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.color_lens_outlined,
                      color: Colors.grey.shade700,
                    ),
                    title: "Theme".text.make(),
                    onTap: () async {
                      await showDialog(
                        context: context,
                        builder: (context) => Dialog(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                title: 'Light Theme'.text.make(),
                                trailing: Radio<bool>(
                                  value: false,
                                  groupValue: model.isDarkMode,
                                  onChanged: (value) {
                                    model.toggleTheme(isDark: value!);
                                    getThemeManager(context)
                                        .toggleDarkLightTheme();
                                    getThemeManager(context)
                                        .setThemeMode(ThemeMode.light);
                                  },
                                ),
                              ),
                              ListTile(
                                title: 'Dark Theme'.text.make(),
                                trailing: Radio<bool>(
                                  value: true,
                                  groupValue: model.isDarkMode,
                                  onChanged: (value) {
                                    model.toggleTheme(isDark: value!);
                                    getThemeManager(context)
                                        .toggleDarkLightTheme();
                                    getThemeManager(context)
                                        .setThemeMode(ThemeMode.dark);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.description_outlined,
                      color: Colors.grey.shade700,
                    ),
                    title: "Terms & Conditions".text.make(),
                    onTap: () {
                      model.launchTermsUrl();
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.security_outlined,
                      color: Colors.grey.shade700,
                    ),
                    title: "Privacy Policy".text.make(),
                    onTap: () {
                      //model.navigateToPolicyView();
                      model.launchPrivacyUrl();
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.info_outline,
                      color: Colors.grey.shade700,
                    ),
                    title: "About".text.make(),
                    onTap: () {
                      //model.navigateToAboutView();
                      model.launchAboutUsUrl();
                    },
                  ),
                  /*ListTile(
                    leading: Icon(
                      Icons.help_outline,
                      color: Colors.grey.shade700,
                    ),
                    title: "Help".text.make(),
                    onTap: () {
                      model.navigateToHelpView();
                    },
                  ),*/
                  const Divider(
                    color: Colors.black,
                  ).px8(),
                  ListTile(
                    dense: true,
                    title: "Log Out".text.red500.make(),
                    onTap: () {
                      model.signOut();
                    },
                  ),
                  ListTile(
                    dense: true,
                    title: Row(children: [Text("Request account deactivation",style: TextStyle(color:Vx.red500,fontWeight: FontWeight.bold),),SizedBox(width: 5,), Icon(Icons.info_rounded)],),
                    onTap: () {
                      model.deactivate();
                    },
                  ),
                ],
              ),
            ),
      viewModelBuilder: () => SettingsViewModel(),
    );
  }
}
