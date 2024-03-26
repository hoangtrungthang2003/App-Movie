import 'package:app_movie/widget/constants.dart';
import 'package:flutter/material.dart';

class DateSelector extends StatefulWidget {
  const DateSelector({super.key});

  @override
  _DateSelectorState createState() => _DateSelectorState();
}

class _DateSelectorState extends State<DateSelector> {
  int dateIndexSelected = 1;
  DateTime currentDate = DateTime.now();

  String _dayFormat(int dayWeek) {
    switch (dayWeek) {
      case 1:
        return "T2";
      case 2:
        return "T3";
      case 3:
        return "T4";
      case 4:
        return "T5";
      case 5:
        return "T6";
      case 6:
        return "T7";
      case 7:
        return "CN";
      default:
        return "T2";
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Expanded(
      flex: 13,
      child: Container(
        width: size.width,
        padding: const EdgeInsets.only(left: appPadding * 1.5),
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: white.withOpacity(0.1),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  )),
            ),
            SizedBox(
              width: size.width,
              child: ListView.builder(
                  itemCount: 7,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    var date = currentDate.add(Duration(days: index));
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          dateIndexSelected = index;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(appPadding / 5),
                        margin: EdgeInsets.symmetric(
                          vertical: size.height * 0.02,
                          horizontal: 12,
                        ),
                        width: 44,
                        decoration: BoxDecoration(
                          color: dateIndexSelected == index
                              ? primary
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              date.day.toString(),
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                  height: 1.0,
                                  color: index == dateIndexSelected
                                      ? black
                                      : white),
                            ),
                            Text(
                              _dayFormat(date.weekday),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: index == dateIndexSelected
                                    ? black
                                    : white.withOpacity(0.5),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
