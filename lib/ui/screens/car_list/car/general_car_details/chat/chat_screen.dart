import 'package:car_companion/controller/current_car.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key, required this.carName});
  final String carName;

  ChatScreenState createState() => ChatScreenState(carName);
}

class ChatScreenState extends ConsumerState<ChatScreen> {
  ChatScreenState(this.carName);

  final chatController = TextEditingController();
  final String carName;
  late final OpenAI _openAI;
  late List<OpenAIChatCompletionChoiceMessageModel> _messages;
  late bool _isLoading;

  Future<void> handleInit() async {
    // Create the initial setup message
    final systemMessage = OpenAIChatCompletionChoiceMessageModel(
      content: [
        OpenAIChatCompletionChoiceMessageContentItemModel.text(
          'You are a ${carName} Expert. The user is an owner of a ${carName}. Please send a super short intro message. Your name is Bumper.',
        ),
      ],
      role: OpenAIChatMessageRole.assistant,
    );

    // Send initial message and receive bot intro message
    OpenAIChatCompletionModel chatCompletion =
        await _openAI.chat.create(
      model: "gpt-3.5-turbo-1106",
      seed: 6,
      messages: [systemMessage],
      temperature: 0.0,
      maxTokens: 200,
    );

    setState(() {
    _messages = [chatCompletion.choices.first.message];
    });
  }

  Future<void> sendMessage(String message) async {
    setState(() {
      _isLoading = true;
    });

    // Create new MessageModel
    var newMessage = OpenAIChatCompletionChoiceMessageModel(
      content: [
        OpenAIChatCompletionChoiceMessageContentItemModel.text(
          message,
        ),
      ],
      role: OpenAIChatMessageRole.user,
    );

    // add it to the existing conversation
    setState(() {
      _messages.insert(0, newMessage);
    });

    // send new message and receive response 
    OpenAIChatCompletionModel chatCompletion =
        await _openAI.chat.create(
      model: "gpt-3.5-turbo-1106",
      seed: 6,
      messages: _messages,
      temperature: 0.0,
      maxTokens: 200,
    );

    // add new message to the conversation thread
    setState(() {
      _messages.insert(0, chatCompletion.choices.first.message);
      _isLoading = false;
    });
  }

  @override
  void initState() {
    setState(() {
      _isLoading = true;
      _messages = [];
    });

    OpenAI.apiKey = "";
    OpenAI.requestsTimeOut = Duration(seconds: 30);
    _openAI = OpenAI.instance;

    handleInit();    
    
    setState(() {
      _isLoading = false;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var currentCar = ref.watch(currentCarProvider);

    return switch (currentCar) {
      AsyncData() => WillPopScope(
          onWillPop: () async {
            return true;
          },
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            extendBody: true,
            backgroundColor: Color.fromARGB(0, 255, 255, 255),
            appBar: AppBar(
              title: Text("Chat"),
            ),
            body: Container(
              decoration: BoxDecoration(
                color: Colors.grey,
              ),
              padding: const EdgeInsets.only(bottom: 32),
              child: Stack(
                children: [
                  Column(
                    children: [
                      Flexible(
                        child: ListView.builder(
                          padding: const EdgeInsets.all(8.0),
                          reverse: true,
                          itemCount: _messages.length,
                          itemBuilder: (_, int index) {
                            return Container(margin: _messages[index].role == OpenAIChatMessageRole.user
                  ? const EdgeInsets.only(left: 100)
                  : const EdgeInsets.only(right: 100) ,child: Card(
                      color: _messages[index].role == OpenAIChatMessageRole.assistant ? Colors.white : Color.fromARGB(255, 175, 235, 255),
                                child: ListTile(
                              title: Text(_messages[index].content?[0].text ??
                                  "Filler"),
                            )),)
                            ;
                          },
                        ),
                      ),
                      Divider(height: 1.0),
                      Padding(
                          padding: EdgeInsets.only(
                              top: 12.0, bottom: 12.0, right: 25, left: 25.0),
                          child: Row(
                            children: [
                              Container(
                                width: 300,
                                padding: EdgeInsets.only(
                                  right: 12,
                                ),
                                child: TextField(
                                  controller: chatController,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'Chat',
                                  ),
                                ),
                              ),
                              IconButton(
                                  onPressed: _isLoading ? null : () {
                                    sendMessage(chatController.text);
                                    chatController.text = "";
                                  }, icon: Icon(color: Color.fromARGB(255, 175, 235, 255), Icons.send))
                            ],
                          )),
                    ],
                  ),
                  if (_isLoading)
                    Center(
                      child: Container(
                        margin: const EdgeInsets.all(20),
                        child: const CircularProgressIndicator(),
                      ),
                    ),
                ],
              ),
            ),
          )),
      AsyncError(:final error) => Text('Error: $error'),
      _ => Center(
          child: CircularProgressIndicator(),
        )
    };
  }
}
