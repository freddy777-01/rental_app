import 'package:avatar_plus/avatar_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'tenants.dart';
import 'properties.dart';
import 'profile.dart';

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
        backgroundColor: Color(0xFF3F51B5), // Primary: Indigo Blue
        elevation: 5.6,
        selectedItemColor: Colors.white, // Selected item color
        unselectedItemColor: Colors.white.withOpacity(
          0.7,
        ), // Unselected item color
        type: BottomNavigationBarType.fixed, // Fixed type for better appearance
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_alt),
            label: "Tenants",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_work),
            label: "Properties",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TenantsScreen()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PropertiesScreen()),
            );
          } else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            );
          }
        },
      ),
      // backgroundColor: ,
      body: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Color(0xFFF5F6FA), // Background: Light Gray
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(10.0),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Color(0xFFFFFFFF), // Surface: White
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF3F51B5).withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Welcome!",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3F51B5), // Primary: Indigo Blue
                          ),
                        ),
                        Gap(12),
                        const Text(
                          "Fred Makaranga",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2C3E50), // Text: Primary
                          ),
                        ),
                        Gap(8),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFF2ECC71).withOpacity(
                              0.1,
                            ), // Accent: Emerald Green with opacity
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Color(0xFF2ECC71).withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            formattedDate,
                            style: TextStyle(
                              color: Color(0xFF2ECC71), // Accent: Emerald Green
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Gap(40),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(75),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF3F51B5).withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: AvatarPlus("Freddy", height: 120, width: 120),
                    ),
                  ],
                ),
              ),
              Gap(20),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Color(0xFFFFFFFF), // Surface: White
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF3F51B5).withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Color(
                          0xFF3F51B5,
                        ).withOpacity(0.1), // Primary: Indigo Blue with opacity
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.people_alt,
                        size: 32,
                        color: Color(0xFF3F51B5), // Primary: Indigo Blue
                      ),
                    ),
                    Gap(20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Total Tenants",
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF7F8C8D), // Text: Secondary
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Gap(4),
                        Text(
                          "50",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3F51B5), // Primary: Indigo Blue
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Gap(30),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFFFFFFFF), // Surface: White
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF3F51B5).withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Color(0xFF2ECC71).withOpacity(
                          0.1,
                        ), // Accent: Emerald Green with opacity
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Color(0xFF2ECC71), // Accent: Emerald Green
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.schedule,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          Gap(12),
                          Text(
                            "Upcoming Rent Due",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2ECC71), // Accent: Emerald Green
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height / 4,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: ListView.builder(
                        itemCount: _tenantsDueDate.length,
                        itemBuilder: (context, index) {
                          final d = _tenantsDueDate[index];
                          return Container(
                            margin: EdgeInsets.only(bottom: 8),
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Color(
                                0xFFF5F6FA,
                              ), // Background: Light Gray
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Color(0xFF2ECC71).withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Color(
                                    0xFF2ECC71,
                                  ), // Accent: Emerald Green
                                  radius: 20,
                                  child: Text(
                                    d['name'][0].toUpperCase(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Gap(16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        d['name'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Color(
                                            0xFF2C3E50,
                                          ), // Text: Primary
                                        ),
                                      ),
                                      Gap(4),
                                      Text(
                                        "Due: ${d['due_date']}",
                                        style: TextStyle(
                                          color: Color(
                                            0xFF7F8C8D,
                                          ), // Text: Secondary
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: Color(
                                    0xFF2ECC71,
                                  ), // Accent: Emerald Green
                                  size: 16,
                                ),
                              ],
                            ),
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
                  color: Color(0xFFFFFFFF), // Surface: White
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Color(
                        0xFFE74C3C,
                      ).withOpacity(0.1), // Error: Red with opacity
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Color(
                          0xFFE74C3C,
                        ).withOpacity(0.1), // Error: Red with opacity
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Color(0xFFE74C3C), // Error: Red
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.warning,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          Gap(12),
                          Text(
                            "Overdue Rent",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFE74C3C), // Error: Red
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height / 5,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: ListView.builder(
                        itemCount: _tenantsDueDate.length,
                        itemBuilder: (context, index) {
                          final d = _tenantsDueDate[index];
                          return Container(
                            margin: EdgeInsets.only(bottom: 8),
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Color(
                                0xFFF5F6FA,
                              ), // Background: Light Gray
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Color(0xFFE74C3C).withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Color(
                                    0xFFE74C3C,
                                  ), // Error: Red
                                  radius: 20,
                                  child: Text(
                                    d['name'][0].toUpperCase(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Gap(16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        d['name'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Color(
                                            0xFF2C3E50,
                                          ), // Text: Primary
                                        ),
                                      ),
                                      Gap(4),
                                      Text(
                                        "Overdue: ${d['due_date']}",
                                        style: TextStyle(
                                          color: Color(
                                            0xFFE74C3C,
                                          ), // Error: Red
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: Color(0xFFE74C3C), // Error: Red
                                  size: 16,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              // End of Tenants overdue
              Gap(30),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Color(0xFFFFFFFF), // Surface: White
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFFF1C40F).withOpacity(
                        0.1,
                      ), // Reminder Highlight: Yellow with opacity
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Color(
                              0xFFF1C40F,
                            ), // Reminder Highlight: Yellow
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.trending_up,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        Gap(12),
                        Text(
                          "Total Revenue",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(
                              0xFFF1C40F,
                            ), // Reminder Highlight: Yellow
                          ),
                        ),
                      ],
                    ),
                    Gap(20),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Color(0xFFF1C40F).withOpacity(
                                0.1,
                              ), // Reminder Highlight: Yellow with opacity
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Color(0xFFF1C40F).withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "2025",
                                  style: TextStyle(
                                    color: Color(0xFF7F8C8D), // Text: Secondary
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Gap(4),
                                Text(
                                  "TZS 20,000",
                                  style: TextStyle(
                                    color: Color(0xFF2C3E50), // Text: Primary
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Gap(12),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Color(0xFFF1C40F).withOpacity(
                                0.1,
                              ), // Reminder Highlight: Yellow with opacity
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Color(0xFFF1C40F).withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "2026",
                                  style: TextStyle(
                                    color: Color(0xFF7F8C8D), // Text: Secondary
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Gap(4),
                                Text(
                                  "TZS 5,000",
                                  style: TextStyle(
                                    color: Color(0xFF2C3E50), // Text: Primary
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Gap(12),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Color(0xFFF1C40F).withOpacity(
                                0.1,
                              ), // Reminder Highlight: Yellow with opacity
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Color(0xFFF1C40F).withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "2027",
                                  style: TextStyle(
                                    color: Color(0xFF7F8C8D), // Text: Secondary
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Gap(4),
                                Text(
                                  "TZS 4,000",
                                  style: TextStyle(
                                    color: Color(0xFF2C3E50), // Text: Primary
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
