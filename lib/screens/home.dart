import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:todo_api/screens/add_todo.dart';
import 'package:http/http.dart' as http;
import 'package:todo_api/screens/update_todo.dart';



class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;
  List todoList = [];

  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      floatingActionButton: SizedBox(
        width: 100,
        child: FloatingActionButton(
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          onPressed: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => addTodo()));
          },
          child: const Text(
            "Add ToDo",
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
      body:  Visibility(
              visible: isLoading,
              child: const Center(
                child: CircularProgressIndicator(color: Colors.orange,),
              ),
              replacement:todoList.isEmpty
                  ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.list_alt,
                      size: 100,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 20),
                    Text(
                      "No To-Dos Available",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ):
              RefreshIndicator(
                color: Colors.orange,
                onRefresh: fetchData,
                child: ListView.builder(
                  itemBuilder: (_, index) {
                    final item = todoList[index] as Map;
                    final id = item["_id"] as String;
                    return Container(
                      padding: const EdgeInsets.all(4),
                      margin: const EdgeInsets.only(
                        left: 8,
                        right: 8,
                        top: 4,
                        bottom: 4,
                      ),
                      color: Colors.grey[400],
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text("${index + 1}"),
                          backgroundColor: Colors.orange,
                        ),
                        title: Text(
                          "${item['title']}",
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(
                          "${item['description']}",
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        trailing: PopupMenuButton(
                          color: Colors.grey[300],
                          onSelected: (value) {
                            if (value == 'edit') {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => updateTodo(
                                            id: id,
                                          )));
                            } else if (value == 'delete') {
                              deleteTodo(id);
                            }
                          },
                          itemBuilder: (_) {
                            return [
                              const PopupMenuItem(
                                child: Text("Edit"),
                                value: 'edit',
                              ),
                              const PopupMenuItem(
                                child: Text("Delete"),
                                value: 'delete',
                              ),
                            ];
                          },
                        ),
                      ),
                    );
                  },
                  // separatorBuilder: (_, index) {
                  //   return const Divider(thickness:0,);
                  // },
                  itemCount: todoList.length,
                ),
              ),
            ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: Colors.orange,
      title: const Text("TO-DO"),
      centerTitle: true,
      titleTextStyle: const TextStyle(
        fontSize: 22,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });
    final uri = Uri.parse("https://api.nstack.in/v1/todos?page=1&limit=20");
    final response = await http.get(uri);
    print(response.statusCode);
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final result = jsonResponse['items'] as List;
      setState(() {
        todoList = result;
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> deleteTodo(String id) async {
    final uri = Uri.parse("https://api.nstack.in/v1/todos/$id");
    final response = await http.delete(uri);
    if (response.statusCode == 200) {
      fetchData();
    }
  }
}
