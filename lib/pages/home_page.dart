import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gemini/bloc/chat_bloc.dart';
import 'package:flutter_gemini/model/chat_message_model.dart';
import 'package:lottie/lottie.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ChatBloc chatBloc = ChatBloc();
  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ChatBloc, ChatState>(
        bloc: chatBloc,
        listener: (context, state) {},
        builder: (context, state) {
          switch (state.runtimeType) {
            case ChatSuccessState:
              List<ChatMessageModel> messages =
                  (state as ChatSuccessState).messages;
              return Container(
                width: double.maxFinite,
                height: double.maxFinite,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        opacity: 0.5,
                        image: AssetImage("assets/space_bg.jpeg"),
                        fit: BoxFit.cover)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      height: 100,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Space Pod",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 24),
                          ),
                          // GestureDetector(
                          //     onTap: () {
                          //       messages = [];
                          //     },
                          //     child:
                          //         Icon(Icons.open_in_new, color: Colors.white)),
                        ],
                      ),
                    ),
                    Expanded(
                        child: ListView.builder(
                            itemCount: messages.length,
                            itemBuilder: (context, index) {
                              return Container(
                                  margin: const EdgeInsets.only(
                                      bottom: 12, left: 16, right: 16),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      color: Colors.black87),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        messages[index].role == "user"
                                            ? "User"
                                            : "Space Pod",
                                        style: TextStyle(
                                            fontSize: 14,
                                            color:
                                                messages[index].role == "user"
                                                    ? Colors.amber
                                                    : Colors.purple.shade200),
                                      ),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                      Text(
                                        messages[index].parts.first.text,
                                        style: TextStyle(height: 1.2),
                                      ),
                                    ],
                                  ));
                            })),
                    if (chatBloc.generating)
                      Row(
                        children: [
                          Container(
                              height: 200,
                              width: 200,
                              child: Lottie.asset('assets/space_loader.json')),
                          const SizedBox(width: 20),
                          Text("Loading...")
                        ],
                      ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          Expanded(
                              child: TextField(
                            controller: textEditingController,
                            style: TextStyle(color: Colors.black),
                            cursorColor: Theme.of(context).primaryColor,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                fillColor: Colors.white,
                                hintText: "Ask Something from AI",
                                hintStyle:
                                    TextStyle(color: Colors.grey.shade400),
                                filled: true,
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(100),
                                    borderSide: BorderSide(
                                        color:
                                            Theme.of(context).primaryColor))),
                          )),
                          const SizedBox(width: 12),
                          InkWell(
                            onTap: () {
                              if (textEditingController.text.isNotEmpty) {
                                String text = textEditingController.text;
                                textEditingController.clear();
                                chatBloc.add(ChatGenerateNewTextMessageEvent(
                                    inputMessage: text));
                              }
                            },
                            child: CircleAvatar(
                              radius: 32,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.black87,
                                child: Center(
                                  child: Icon(Icons.send, color: Colors.white),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
              );

            default:
              return SizedBox();
          }
        },
      ),
    );
  }
}
