import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class updateTodo extends StatefulWidget {
  String id;
  updateTodo({required this.id});
  @override
  State<updateTodo> createState() => _updateTodoState();
}

class _updateTodoState extends State<updateTodo> {
  final TextEditingController _updatedtitleController = TextEditingController();

  final TextEditingController _updatedescriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Update TO-DO"),
          centerTitle: true,
          titleTextStyle: const TextStyle(
            fontSize: 22,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          backgroundColor: Colors.orange,
        ),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _updatedtitleController,
                maxLength: 20,
                decoration: const InputDecoration(
                  hintText: "title",
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _updatedescriptionController,
                keyboardType: TextInputType.multiline,
                minLines: 3,
                maxLines: 10,
                decoration: const InputDecoration(
                  hintText: "Description",
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    updateTodo(widget.id);
                    Navigator.pop(context,true);

                  },
                  child: const Text("Update ToDo"),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white),
                ),
              ),
            ),
          ],
        ));
  }

  Future<void> updateTodo(String id) async {
    final body = {
      "title": _updatedtitleController.text,
      "description": _updatedescriptionController.text,
      "is_completed": false,
    };
    final uri = Uri.parse("https://api.nstack.in/v1/todos/$id");
    final response = await http.put(
      uri,
      body: jsonEncode(body),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Update Successfully")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Update failed"),
        backgroundColor: Colors.red,
      ));
    }
  }
}
