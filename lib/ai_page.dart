import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AiPage extends StatefulWidget {
  const AiPage({super.key});

  @override
  State<AiPage> createState() => _AiPageState();
}

class _AiPageState extends State<AiPage> {
  final String _apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';

  final TextEditingController _textController = TextEditingController();
  String _geminiResponse = 'Gemini response will appear here.';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ask the AI'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: 'Enter your question here',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              maxLines: null, // Allows for multiline input
              keyboardType: TextInputType.multiline,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _sendToGemini(_textController.text);
              },
              child: const Text('Ask AI'),
            ),
            const SizedBox(height: 16.0),
 Text(
 _geminiResponse,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sendToGemini(String text) async {
 final uri = Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$_apiKey');
    
 
    final response = await http.post(
 uri,

      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'contents': [
 {'parts': [{'text': text}]}
        ],
        
 }));


    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      // Assuming the response structure has a 'candidates' array,
      // and the first candidate has a 'content' with 'parts' and 'text'.
      // Adjust the keys based on the actual API response structure.
      setState(() {
        _geminiResponse = decodedResponse['candidates'][0]['content']['parts'][0]['text'];
      });
    } else {
      setState(() {
        _geminiResponse = 'Error: ${response.statusCode} - ${response.body}';
      });
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}