import 'package:avatar_plus/avatar_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gap/flutter_gap.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _Welcome();
}

class _Welcome extends State<Welcome> {
  static DateTime today = DateTime.now();
  static final String formattedDate =
      "${today.day}/${today.month}/${today.year}";

  final List<Map<String, dynamic>> _tenantsDueDate = [
    {'name': "Reginald raymond", 'due_date': formattedDate, 'age': 30},
    {'name': "Heyday dismass", 'due_date': formattedDate, 'age': 30},
    {'name': "Henna sinbad", 'due_date': formattedDate, 'age': 30},
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rental App')),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromARGB(255, 249, 180, 255),
        elevation: 5.6,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_alt),
            label: "Tenants",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
      // backgroundColor: ,
      body: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 247, 183, 253),
              Color.fromARGB(255, 251, 206, 255),
              Color.fromARGB(255, 255, 255, 255),
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(10.0),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 2.0),
                ),
                child: Row(
                  // crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Welcome!",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Gap(20),
                        const Text(
                          "Fred Makaranga",
                          style: TextStyle(fontSize: 15),
                        ),
                        Gap(20),
                        Text(formattedDate),
                      ],
                    ),
                    const Gap(60),
                    AvatarPlus("Freddy", height: 150, width: 150),
                  ],
                ),
              ),
              Gap(20),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Icon(Icons.people_alt, size: 30),
                    Gap(20),
                    Text("Tenants", style: TextStyle(fontSize: 20)),
                    Gap(10),
                    Text("50", style: TextStyle(fontSize: 20)),
                  ],
                ),
              ),
              const Gap(30),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 2.0),
                ),
                // height: MediaQuery.of(context).size.height / 4,
                // width: MediaQuery.of(context).size.width,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Upcoming rent due",
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 4,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                        itemCount: _tenantsDueDate.length,
                        itemBuilder: (context, index) {
                          final d = _tenantsDueDate[index];
                          return ListTile(
                            title: Text(d['name']),
                            subtitle: Text(d['due_date'].toString()),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Gap(30),
              //Overdue Tenants
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 2.0),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            "Over due rent",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                    Gap(20),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 5,
                      child: ListView.builder(
                        itemCount: _tenantsDueDate.length,
                        itemBuilder: (context, index) {
                          final d = _tenantsDueDate[index];
                          return ListTile(
                            title: Text(d['name']),
                            subtitle: Text(d['due_date'].toString()),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              // End of Tenants overdue
              Gap(30),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [Text("Total revenue")],
                  ),
                  Container(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("2025 : Tzs 20000"),
                        Text("2026 : Tzs 5000"),
                        Text("2027: Tzs 4000"),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
