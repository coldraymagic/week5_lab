import 'package:flutter/material.dart';
import 'package:floor/floor.dart';

// week8
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Week8 Lab',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Week8 Lab, Xinwei Wang'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late TextEditingController textFieldController;
  List<String> words = [];

  @override //same as in java
  void initState() {
    super.initState();
    textFieldController = TextEditingController();
  }

  @override
  void dispose() {
    textFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(

        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),

      ),
      body: Center(
          child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          words.add(textFieldController.text);
                          textFieldController.clear();
                        });
                      },
                      child: Text("Add")
                  ),

                  SizedBox(width: 10),

                  Flexible(
                    child: TextField(
                      controller: textFieldController,
                      decoration: InputDecoration(
                        hintText: "Enter a search term",
                        labelText: "Enter a search term",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ]
            ),

            SizedBox(height: 10),

            if (words.isEmpty)
              Text("There are no items in the list")
            else
              Expanded(
                  child: ListView.builder(
                      itemCount: words.length,
                      itemBuilder: (context, r) {
                        return GestureDetector(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text("item $r:"),
                                Text("${words[r]}"),
                              ]),
                          //
                          onLongPress: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const Text('Warning'),
                                content: const Text(
                                    'The selected item will be remove. (Yes/No)'),
                                actions: <Widget>[
                                  OutlinedButton(
                                      onPressed: () {
                                        setState(() {
                                          words.removeAt(r);
                                        });
                                        Navigator.pop(context);
                                      },
                                      child: Text("Yes")),
                                  OutlinedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text("No"))
                                ],
                              ),
                            );
                          },
                        );
                      }
                  )
              ),
          ],
        ),
      )),
    );
  }
}
