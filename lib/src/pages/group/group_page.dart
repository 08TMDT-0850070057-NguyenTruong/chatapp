import 'package:flutter/material.dart';
// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../../foundation/msg_widget/other_msg_widget.dart';
import '../../foundation/msg_widget/own_msg_widget.dart';
import 'msg_model.dart';

class GroupPage extends StatefulWidget {
  final String name;
  final String userId;
  const GroupPage({Key? key, required this.name, required this.userId}) : super(key: key);

  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  IO.Socket? socket;
  List<MsgModel> listMsg = [];
  final TextEditingController _msgController = TextEditingController();

  @override
  void initState() {
    super.initState();
    connect();
  }

  void connect() {
    socket = IO.io("http://192.168.1.8:3000", <String, dynamic>{
      "transport": ["websocket"],
      "autoConnect": false,
    });
    socket!.connect();
    
    socket!.onConnect((_) {
      print('connect into to server');
      socket!.on("sendMsg", (msg) {
  print("Received message: $msg");
       if(msg["userId"]!= widget.userId){
         setState(() {
           listMsg.add(
               MsgModel(
                   msg: msg["msg"], type: msg["type"], sender: msg["senderName"]));
         });
       }
      });
    });
  }

  void sendMsg(String msg, String senderName) {
    MsgModel ownMsg = MsgModel(msg: msg, type: "ownMsg", sender: senderName);
    listMsg.add(ownMsg);
    setState(() {
      listMsg;
    });
    socket!.emit('sendMsg', {
      "type": "ownMsg",
      "msg": msg,
      "senderName": senderName,
      "userId": widget.userId,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Anonymous Group"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: listMsg.length,
              itemBuilder: (context, index) {
                if (listMsg[index].type == "ownMsg") {
                  return OwnMSgWidget(
                      msg: listMsg[index].msg, sender: listMsg[index].sender,);
                } else {
                  return OtherMSgWidget(
                      msg: listMsg[index].msg, sender: listMsg[index].sender,);
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _msgController,
                    decoration: InputDecoration(
                        hintText: "Type here...",
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          borderSide: BorderSide(
                            width: 2,
                          ),
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            String msg = _msgController.text;
                            if (msg.isNotEmpty) {
                              sendMsg(msg, widget.name);
                              _msgController.clear();
                            }
                          },
                          icon: const Icon(
                            Icons.send,
                            color: Colors.teal,
                            size: 26,
                          ),
                        )),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
