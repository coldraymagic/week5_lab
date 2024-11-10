import 'package:flutter/material.dart';
import 'package:floor/floor.dart';

import 'database.dart';
import 'mydatabase.dart';

// week8
Future<void> main() async {
  // final _database = await $FloorAppDatabase.databaseBuilder("wxw.db").build();
  //
  // print(_database);
  runApp(const MyApp());
}


class DatabaseService {
  // Singleton
  static final DatabaseService _instance = DatabaseService._internal();
  // return instance
  factory DatabaseService() {
    return _instance;
  }
  // make the constructor private
  DatabaseService._internal();
  AppDatabase? _database;
  Future<AppDatabase?> connect(String dbName) async {
    _database = await $FloorAppDatabase.databaseBuilder("{$dbName}").build();
    return _database;
  }
  AppDatabase? getDatabase(){
    return _database;
  }
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
  List<MyDatabase> data = [];
  late final DatabaseService dbService;
  MyDatabase? selectedItem = null;

  @override //same as in java
  void initState() {
    super.initState();
    textFieldController = TextEditingController();
    dbService = DatabaseService();
    dbService.connect("wxw.db").then((result){
      result!.myDatabaseDao.findAllData().then((result){
        data=(result.isEmpty)?[]:result;
        setState(() {});
      });
    });
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
      body: reactiveLayout(),
    );
  }
  Widget reactiveLayout() {
    var size = MediaQuery
        .of(context)
        .size;
    var height = size.height;
    var width = size.width;

    if ((width > height) && (width > 720)) {
      return Row(children: [
        Expanded(flex:1,child:toDoList()),
        Expanded(flex:2,child: DetailsPage())
      ]);
    } else {
      if(selectedItem==null){
        return toDoList();
      }
      else {
        return DetailsPage();
      }
    }
  }

  Widget DetailsPage(){
    return Column(children:[
        if (selectedItem==null)
          Text("Please select something from the list")
      else
          Text("You select:" + selectedItem!.itemValue),
    // ElevatedButton(child:Text("ok"),onPressed: (){
    //
    // }
    // )
    ]);
  }

  Widget toDoList(){
    return Center(
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
                            var current=MyDatabase(DateTime.now().millisecondsSinceEpoch, textFieldController.text);
                            data.add(current);
                            dbService.getDatabase()!.myDatabaseDao.insertData(current);
                            // words.add(textFieldController.text);
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

              if (data.isEmpty)
                Text("There are no items in the list")
              else
                Expanded(
                    child: ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, r) {
                          return GestureDetector(
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Text("item $r:"),
                                  Text("${data[r].itemValue}"),
                                ]),
                            //
                            onTap:(){
                              setState(() {
                                selectedItem=data[r];
                              });

                            },

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
                                          dbService.getDatabase()!.myDatabaseDao.deleteDataById(data[r].id);
                                          setState(() {
                                            data.removeAt(r);
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
        ));
  }
}
