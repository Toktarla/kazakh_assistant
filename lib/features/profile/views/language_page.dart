import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  @override
  _LanguagePageState createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  String _selectedLanguage = 'en';

  @override
  void initState() {
    super.initState();
    _loadSelectedLanguage();
  }

  Future<void> _loadSelectedLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedLanguage = prefs.getString('selectedLanguage') ?? context.locale.languageCode;
      context.setLocale(Locale(_selectedLanguage)); // Set locale based on saved language
    });
  }

  Future<void> _saveSelectedLanguage(String languageCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedLanguage', languageCode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Language').tr(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.2),
                spreadRadius: 8,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: IntrinsicHeight(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black87,
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: Image.asset('assets/images/US.png', width: 40),
                    title: const Text('English').tr(),
                    trailing: Radio<String>(
                      value: 'en',
                      groupValue: _selectedLanguage,
                      onChanged: (String? value) {
                        if (value != null) {
                          setState(() {
                            _selectedLanguage = value;
                          });
                          context.setLocale(const Locale('en'));
                          _saveSelectedLanguage('en');
                        }
                      },
                    ),
                    onTap: () {
                      setState(() {
                        _selectedLanguage = 'en';
                      });
                      context.setLocale(const Locale('en'));
                      _saveSelectedLanguage('en');
                    },
                  ),
                ),
                const SizedBox(height: 20),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black87,
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: Image.asset('assets/images/russia.png', width: 40),
                    title: const Text('Russian').tr(),
                    trailing: Radio<String>(
                      value: 'ru',
                      groupValue: _selectedLanguage,
                      onChanged: (String? value) {
                        if (value != null) {
                          setState(() {
                            _selectedLanguage = value;
                          });
                          context.setLocale(const Locale('ru'));
                          _saveSelectedLanguage('ru');
                        }
                      },
                    ),
                    onTap: () {
                      setState(() {
                        _selectedLanguage = 'ru';
                      });
                      context.setLocale(const Locale('ru'));
                      _saveSelectedLanguage('ru');
                    },
                  ),
                ),
                const SizedBox(height: 20),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black87,
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: Image.asset('assets/images/kazakhstan.png', width: 40),
                    title: const Text('Kazakh').tr(),
                    trailing: Radio<String>(
                      value: 'kk',
                      groupValue: _selectedLanguage,
                      onChanged: (String? value) {
                        if (value != null) {
                          setState(() {
                            _selectedLanguage = value;
                          });
                          context.setLocale(const Locale('kk'));
                          _saveSelectedLanguage('kk');
                        }
                      },
                    ),
                    onTap: () {
                      setState(() {
                        _selectedLanguage = 'kk';
                      });
                      context.setLocale(const Locale('kk'));
                      _saveSelectedLanguage('kk');
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}