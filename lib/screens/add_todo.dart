import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo_api/screens/home.dart';

class addTodo extends StatelessWidget {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => HomePage()));
            },
            icon: Icon(Icons.arrow_back),
          ),
          title: const Text("Create TO-DO"),
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
                controller: _titleController,
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
                controller: _descriptionController,
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
                    if (_titleController.text.isNotEmpty &&
                        _descriptionController.text.isNotEmpty) {
                      onTapaddTodo(context);
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>HomePage()));
                      _descriptionController.clear();
                      _titleController.clear();
                    }
                  },
                  child: const Text("Add ToDo"),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white),
                ),
              ),
            ),
          ],
        ));
  }

  Future<void> onTapaddTodo(BuildContext context) async {
    final body = {
      "title": _titleController.text,
      "description": _descriptionController.text,
      "is_completed": false,
    };
    final uri = Uri.parse("https://api.nstack.in/v1/todos");
    final response = await http.post(
      uri,
      body: jsonEncode(body),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Added Successfully")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Creation failed"),
        backgroundColor: Colors.red,
      ));
    }

  }

}
