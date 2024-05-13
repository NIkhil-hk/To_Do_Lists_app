import 'package:flutter/material.dart';
import 'package:to_do_app/splash.dart';

void main() => runApp(MaterialApp(
      home: SplashPage(),
      debugShowCheckedModeBanner: false,
    ));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _todos = <Todo>[];

  final _todoController = TextEditingController();

  final _focusNode = new FocusNode();

  @override
  void dispose() {
    _todoController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Todo t1 = new Todo(title: "Eat BreakFast", isDone: false);
    Todo t2 = new Todo(title: "Go To Gym", isDone: false);
    Todo t3 = new Todo(title: "Meeting At 1pm", isDone: false);
    _todos.add(t1);
    _todos.add(t2);
    _todos.add(t3);
  }

  void _addTodo() {
    final title = _todoController.text;
    if (title.isEmpty) return;

    setState(() {
      _todos.add(Todo(title: title, isDone: false));
      _todoController.text = '';
    });
  }

  void _toggleTodo(Todo todo) {
    setState(() {
      todo.isDone = !todo.isDone;
    });
  }

  void _deleteTodo(Todo todo) {
    setState(() {
      _todos.remove(todo);
    });
  }

  void _showUpdateDialog(BuildContext context, Todo todo) {
    TextEditingController upevent = new TextEditingController();
    upevent.text = todo.title;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Update Todo'),
        content: TextField(
          controller: upevent,
          onSubmitted: (value) {
            setState(() {
              todo.title = value;
            });
            Navigator.pop(context);
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => setState(() {
              todo.title = upevent.text;

              Navigator.pop(context);
            }),
            child: Text('Update'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.amber),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('To Do List App'),
          backgroundColor: Colors.amber,
        ),
        backgroundColor: Color.fromARGB(255, 255, 239, 196),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: _todoController,
                focusNode: _focusNode,
                onSubmitted: (_) => _addTodo(),
                decoration: InputDecoration(
                  labelText: 'Add New Task',
                  // suffixIcon: IconButton(
                  //   icon: Icon(Icons.add),
                  //   onPressed: _addTodo,
                  // ),
                  hintText: "Enter New Task",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _todos.length,
                itemBuilder: (context, index) => _todoItem(_todos[index]),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_todoController.text.isEmpty) {
              _focusNode.requestFocus();
            } else {
              _addTodo();
            }
          },
          child: Icon(Icons.add),
          shape: CircleBorder(),
          backgroundColor: Colors.blue,
          elevation: 6,
          tooltip: "Add New Task",
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  Widget _todoItem(Todo todo) {
    return ListTile(
      leading: Checkbox(
        value: todo.isDone,
        onChanged: (_) => _toggleTodo(todo),
      ),
      title: Text(todo.title,
          style: TextStyle(
              decoration: todo.isDone ? TextDecoration.lineThrough : null)),
      trailing: PopupMenuButton<String>(
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 'Delete',
            child: ElevatedButton(
              child: Text("Delete"),
              onPressed: () {
                _deleteTodo(todo);
              },
            ),
          ),
          PopupMenuItem(
            value: 'Update',
            child: ElevatedButton(
              child: Text("Update"),
              onPressed: () {
                _showUpdateDialog(context, todo);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Todo {
  String title;
  bool isDone;

  Todo({required this.title, required this.isDone});
}
