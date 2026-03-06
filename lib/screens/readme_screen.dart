// lib/screens/readme_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class ReadmeScreen extends StatelessWidget {
  const ReadmeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    final textColor = isDarkMode ? Colors.white : Colors.black;
    final highlightColor = isDarkMode ? Colors.cyanAccent : theme.primaryColor;
    final backgroundColor = isDarkMode ? const Color(0xFF161B22) : Colors.grey[200];
    final linkColor = isDarkMode ? Colors.blueAccent : theme.primaryColor;

    final markdownStyleSheet = MarkdownStyleSheet.fromTheme(theme).copyWith(
      p: TextStyle(color: textColor, fontSize: 16, height: 1.5),
      h1: TextStyle(color: highlightColor, fontSize: 32, fontWeight: FontWeight.bold),
      h2: TextStyle(color: textColor, fontSize: 24, fontWeight: FontWeight.bold),
      h3: TextStyle(color: textColor, fontSize: 20, fontWeight: FontWeight.bold),
      h4: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.bold),
      h5: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.bold),
      h6: TextStyle(color: textColor, fontSize: 14, fontWeight: FontWeight.bold),
      listBullet: TextStyle(color: textColor, fontSize: 16),
      strong: const TextStyle(fontWeight: FontWeight.bold), // Use default color for strong
      em: TextStyle(fontStyle: FontStyle.italic, color: textColor),
      blockquote: TextStyle(color: Colors.grey),
      code: TextStyle(backgroundColor: backgroundColor, color: highlightColor, fontFamily: 'monospace'),
      a: TextStyle(color: linkColor, decoration: TextDecoration.underline),
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: "Back to About",
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text("README"),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            tooltip: "Close to Calculator",
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: rootBundle.loadString("README.md"),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              
              // *** FIX STARTS HERE ***
              // Pre-process the markdown string to remove escaping backslashes.
              String rawMarkdown = snapshot.data!;
              String fixedMarkdown = rawMarkdown
                  .replaceAll(r'\#', '#')     // Un-escape # for headers
                  .replaceAll(r'\*', '*')     // Un-escape * for bold/italics
                  .replaceAll(r'\[', '[')     // Un-escape [
                  .replaceAll(r'\]', ']')     // Un-escape ]
                  .replaceAllMapped( // Un-escape numbered lists like \1. -> 1.
                      RegExp(r'\\(\d+\.)'), (match) => match.group(1)!); 
              // *** FIX ENDS HERE ***

              return Markdown(
                data: fixedMarkdown, // Use the fixed string here
                styleSheet: markdownStyleSheet,
                padding: const EdgeInsets.all(24.0),
              );
            } else {
              return const Center(child: Text("Error: Could not load README.md"));
            }
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}