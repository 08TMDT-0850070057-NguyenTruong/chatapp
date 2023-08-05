import 'package:flutter/material.dart';
import 'package:socketio_flutter/src/pages/group/group_page.dart';
import 'package:uuid/uuid.dart';
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController nameController = TextEditingController();

  final formkey = GlobalKey<FormState>();
var uuid = const Uuid();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Group Chat App"),
      ),
      body: Center(
        child: TextButton(
          onPressed: () => showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text("Please enter your name"),
              content: Form(
                key: formkey,
                child: TextFormField(
                  controller: nameController,
                  validator: (value){
                    if (value == null|| value.length<3)
                      {
                        return"User must have proper name";
                      }
                    return null;
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    nameController.clear();
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Cancel",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.green,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    if(formkey.currentState!.validate()) {
                      String name = nameController.text;
                      nameController.clear();
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GroupPage(
                            name: name,
                            userId: uuid.v1(),
                          ),
                        ),
                      );
                    }
                  },

                  child: const Text(
                    "Enter",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.orange,
                    ),
                  ),
                ),
              ],
            ),
          ),
          child: const Text(
            "Initiate Group chat",
            style: TextStyle(
              color: Colors.teal,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
