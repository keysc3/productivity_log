import 'package:flutter/material.dart';
import 'package:productivity_log/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const myTextColor = Color(0xFFF1F1F1);
    const accentColor = Color(0xFF9C1C26);
    const circularRadius = 8.0;
    const fillColor = Color(0xFF232323);
    const subTextColor = Color(0xFFA7A7A7);
    const highlightColor = Color(0xFF232323);

    return MaterialApp(
      title: 'Productivity Logging',
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFF060606),
        textTheme: ThemeData.light().textTheme.apply(
          bodyColor: myTextColor,
          displayColor: myTextColor,
        ),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: accentColor,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: accentColor,
            foregroundColor: myTextColor,
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(circularRadius)),
            disabledBackgroundColor: Colors.grey.shade700,
            disabledForegroundColor: Colors.grey.shade900,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: myTextColor.withValues(alpha: 0.5), width: 0.3),
            borderRadius: BorderRadius.circular(circularRadius),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:  BorderSide(color: accentColor, width: 2.0),
            borderRadius: BorderRadius.circular(circularRadius),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(circularRadius),
          ),
          floatingLabelStyle: TextStyle(
            color: accentColor,
            fontWeight: FontWeight.bold,
          ),
          filled: true,
          fillColor: fillColor,
          hoverColor: Colors.white.withValues(alpha: 0.1),
          labelStyle: TextStyle(color: subTextColor),
        ),
        listTileTheme: ListTileThemeData(
          tileColor: fillColor,
          textColor: subTextColor,
          iconColor: subTextColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          )
        ),
        iconButtonTheme: IconButtonThemeData(
          style: ButtonStyle(
            overlayColor: WidgetStateProperty.resolveWith<Color?>(
              (Set<WidgetState> states) {
                if (states.contains(WidgetState.hovered)) {
                  return Colors.white.withValues(alpha: 0.1);
                }
                return null;
              },
            ),
          ),
        ),
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        //colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const LoginPage(),
    );
  }
}