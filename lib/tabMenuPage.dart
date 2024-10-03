import 'package:flutter/material.dart';

class TabMenuPage extends StatefulWidget {
  final String username;

  const TabMenuPage({super.key, required this.username});
  
  @override
  State<StatefulWidget> createState() {
    return _TabMenuPageState();
  }
  
}

class _TabMenuPageState extends State<TabMenuPage>{
  late String _username;

  @override
  void initState() {
    super.initState();
    _username = widget.username;
  }

  void _logout() {
    Navigator.pop(context);
  }
  
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(length: 3,
        child: Scaffold(
            appBar: AppBar(
              title: const Text('My App'),
              bottom: const TabBar(
                  tabs: [
                    Tab(text: 'Home'),
                    Tab(text: 'Contact'),
                    Tab(text: 'Profile')
                  ]
              ),
            ),
            body: TabBarView(children: [
              const Center(
                child: Text('Home'),
              ),
              const Center(
                child: Text('Contact'),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.black,
                    ),
                    const Text('Name', style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold
                      ),
                    ),
                    ElevatedButton(
                        onPressed: _logout,
                        child: const Text('Logout')
                    )
                  ],
                )
              )
            ]),
        )
    );
  }
}