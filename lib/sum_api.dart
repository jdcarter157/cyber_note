import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';

final openAI = OpenAI.instance
    .build(token: "");

Future<String> getSummary(String text) async {
  // Build the request object
  final request = ChatCompleteText(messages: [
    Map.of({"role": "user", "content": "summarize this:"+text})
  ], maxToken: 256, model: ChatModel.gptTurbo);
  // Log the request message
  print('Sending request: ${jsonEncode(request.toJson())}');
  // Send the request to the OpenAI API
  final response = await openAI.onChatCompletion(request: request);
  // Log the response message
  print('Received response: ${jsonEncode(response)}');

  final summary = response?.choices.last.message?.content ?? '';

  // Return the summary
  return summary;
}
