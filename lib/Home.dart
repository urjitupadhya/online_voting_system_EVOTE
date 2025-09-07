import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:online_voting_system/constants.dart';
import 'package:online_voting_system/screens/election_creation_screen.dart';
import 'package:online_voting_system/screens/ElectionInformationScree.dart'; // Import the InformationScreen
import 'package:online_voting_system/screens/election_creation_screen.dart'; // Import the ElectionScreen
import 'package:online_voting_system/screens/result_screen.dart'; // Import the AdminResultScreen

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Client? httpClient;
  Web3Client? ethClient;

  @override
  void initState() {
    super.initState();
    httpClient = Client();
    ethClient = Web3Client(infura_url, httpClient!);
  }

  @override
  void dispose() {
    httpClient?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color.fromARGB(255, 255, 223, 176)!, // Light orange
              const Color.fromARGB(255, 255, 255, 255)!, // Light blue
              const Color.fromARGB(255, 206, 255, 208)!, // Light green
            ],
          ),
        ),
        child: SafeArea(
          child: HomePage(ethClient: ethClient),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final Web3Client? ethClient;

  const HomePage({Key? key, required this.ethClient}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> categories = ["Create Elections", "Voters Info", "Candidate Info", "Voters"];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                ' Admin Dashboard',
                style: TextStyle(
                    color: Color.fromRGBO(0, 0, 0, 1),
                    fontWeight: FontWeight.bold,
                    fontSize: 25),
              ),
              SizedBox(height: 10),
              Container(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) =>
                      buildCategory(categories[index]),
                ),
              ),
              SizedBox(height: 0),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: Text(
            'Manage Elections',
            style: TextStyle(
                color: Color.fromRGBO(0, 0, 0, 1),
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) =>
                  buildItem(context, categories[index]),
            ),
          ),
        ),
        SizedBox(height: 0),
      ],
    );
  }

  Widget buildCategory(String title) {
    String displayTitle = title;
    if (title == "Voters") {
      displayTitle = "Result"; // Change the display title to "Result"
    }
    return GestureDetector(
      onTap: () {
        if (title == "Voters Info") {
          // Navigate to InformationScreen
          Navigator.push(
            context,
            FadePageRoute(builder: (context) => InformationScreen()),
          );
        } else {
          // Handle other categories if needed
        }
      },
      child: Container(
        width: 150,
        margin: EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: Color.fromRGBO(0, 0, 0, 1),
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(255, 134, 215, 255).withOpacity(0),
              spreadRadius: 0,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Center(
          child: Text(
            displayTitle, // Use the display title
            style: TextStyle(
              color: const Color.fromARGB(255, 255, 255, 255),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildItem(BuildContext context, String title) {
    String displayTitle = title;
    if (title == "Voters") {
      displayTitle = "Result"; // Change the display title to "Result"
    }

    String imagePath = '';
    if (title == "Voters Info") {
      imagePath = 'assets/images/aaq.png';
    } else if (title == "Candidate Info") {
      imagePath = 'assets/images/zs.png';
    } else if (title == "Result") { // Change condition to "Result"
      imagePath = 'assets/images/qq.png';
    } else {
      imagePath = 'assets/images/pp.png';
    }

    return GestureDetector(
      onTap: () {
        if (title == "Create Elections" && widget.ethClient != null) {
          // Navigate to ElectionCreationScreen with custom page transition
          Navigator.push(
            context,
            FadePageRoute(
              builder: (context) => ElectionCreationScreen(ethClient: widget.ethClient!),
            ),
          );
        } else if (title == "Candidate Info") {
          // Navigate to Election.dart
          Navigator.push(
            context,
            FadePageRoute(
              builder: (context) => ElectionScreen(
                  ethClient: widget.ethClient!,
                  electionName: "Candidate Information"),
            ),
          );
        } else if (title == "Voters Info") {
          // Navigate to InformationScreen
          Navigator.push(
            context,
            FadePageRoute(builder: (context) => InformationScreen()),
          );
        } else if (title == "Voters") { // Change condition to "Result"
          // Navigate to AdminResult.dart
          Navigator.push(
            context,
            FadePageRoute(builder: (context) => AdminResult(ethClient: widget.ethClient!)),
          );
        }
      },
      child: Container(
        width: 300,
        height: 390,
        margin: EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromRGBO(0, 0, 0, 1),
              Color.fromRGBO(1, 1, 1, 1),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              displayTitle, // Use the display title
              style: TextStyle(
                color: Color.fromARGB(255, 255, 255, 255),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30), // Circular corners
                child: Container(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FadePageRoute<T> extends PageRouteBuilder<T> {
  final WidgetBuilder builder;

  FadePageRoute({required this.builder})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              builder(context),
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );
}
