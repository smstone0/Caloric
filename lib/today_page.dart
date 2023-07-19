import 'package:flutter/material.dart';

class TodayPage extends StatelessWidget {
  const TodayPage({super.key});

  @override
  Widget build(BuildContext context) {
    String timeOfDay;
    String month;

    DateTime time = DateTime.parse(DateTime.now().toString());

    if (time.hour > 0 && time.hour < 12) {
      timeOfDay = "morning";
    } else if (time.hour > 12 && time.hour < 17) {
      timeOfDay = "afternoon";
    } else {
      timeOfDay = "evening";
    }

    switch (time.month) {
      case 1:
        month = "January";
        break;
      case 2:
        month = "February";
        break;
      case 3:
        month = "March";
        break;
      case 4:
        month = "April";
        break;
      case 5:
        month = "May";
        break;
      case 6:
        month = "June";
        break;
      case 7:
        month = "July";
        break;
      case 8:
        month = "August";
        break;
      case 9:
        month = "September";
        break;
      case 10:
        month = "October";
        break;
      case 11:
        month = "November";
        break;
      default:
        month = "December";
    }

    return ListView(
      children: [
        Center(
          child: Column(
            children: [
              Container(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: SafeArea(
                      child: Column(
                        children: [
                          Text("Good $timeOfDay!"),
                          Text("Today is ${time.day} $month"),
                          const SizedBox(height: 10),
                          const CalorieRing(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Column(
                  children: [
                    GreyCard(
                      child: ButtonCard(),
                    ),
                    SizedBox(height: 20),
                    GreyCard(
                      child: StatsCard(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CalorieRing extends StatelessWidget {
  const CalorieRing({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100),
      ),
      child: SizedBox(
        width: 125,
        height: 125,
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Card(
            color: Theme.of(context).colorScheme.primaryContainer,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
            child: Center(child: Text("/")),
          ),
        ),
      ),
    );
  }
}

class StatsCard extends StatelessWidget {
  const StatsCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Color colour;

    //Final
    double weight = 0;
    String weightUnit = "kg";
    double userHeight = 0;
    String heightUnit = "cm";
    double bmi = 0;

    if (bmi < 18.5) {
      colour = Colors.blue;
    } else if (bmi < 25) {
      colour = Colors.green;
    } else if (bmi < 30) {
      colour = Colors.orange;
    } else {
      colour = Colors.red;
    }

    return Column(
      children: [
        const Text("Your weight is"),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
          child: Card(
            elevation: 0,
            child: SizedBox(
              width: 100,
              height: 35,
              child: Center(child: Text("$weight$weightUnit")),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: Column(
            children: [
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: [
                    TextSpan(
                        text:
                            "For a height of $userHeight$heightUnit, this means your BMI is "),
                    TextSpan(text: "$bmi", style: TextStyle(color: colour)),
                  ],
                ),
              ),
              Text(
                "Last calculated on (Placeholder)",
                style: TextStyle(fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        CustomButton(
            text: "Update weight/height",
            onPressed: () {
              //Set page
            },
            colour: const Color.fromRGBO(217, 210, 226, 10),
            height: 38,
            width: 190),
      ],
    );
  }
}

class ButtonCard extends StatelessWidget {
  const ButtonCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final List<Widget> buttons = [
      CustomButton(
        text: "Add",
        onPressed: () {
          print("Placeholder 1");
        },
        colour: const Color.fromRGBO(205, 255, 182, 1),
        height: 50,
        width: 100,
      ),
      CustomButton(
        text: "View",
        onPressed: () {
          print("Placeholder 2");
        },
        colour: const Color.fromRGBO(255, 212, 161, 1),
        height: 50,
        width: 100,
      ),
      CustomButton(
        text: "Remove",
        onPressed: () {
          print("Placeholder 3");
        },
        colour: const Color.fromRGBO(229, 139, 139, 1),
        height: 50,
        width: 100,
      ),
    ];

    return Column(
      children: [
        const Text("Nutrition for today"),
        LayoutBuilder(builder: ((context, constraints) {
          if (constraints.maxWidth > 330) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: buttons,
            );
          } else {
            return Column(children: buttons);
          }
        }))
      ],
    );
  }
}

class CustomButton extends StatelessWidget {
  const CustomButton(
      {super.key,
      required this.text,
      required this.onPressed,
      required this.colour,
      required this.height,
      required this.width});

  final String text;
  final VoidCallback onPressed;
  final Color colour;
  final double height, width;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
      child: SizedBox(
        height: height,
        width: width,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: colour,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(
            text,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.normal),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class GreyCard extends StatelessWidget {
  const GreyCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: const Color.fromRGBO(217, 217, 217, 175),
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
          child: child,
        ),
      ),
    );
  }
}
