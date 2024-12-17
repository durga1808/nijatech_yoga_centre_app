import 'package:flutter/material.dart';
import 'package:nijatech_yoga_centre_app/presentation/dashboard/customdialog.dart';
import 'package:nijatech_yoga_centre_app/presentation/dashboard/month_model.dart';
import 'package:nijatech_yoga_centre_app/presentation/dashboard/monthcontainer.dart';

class SimpleMonthYearPicker {
  static final List<MonthModel> _monthModelList = [
    MonthModel(index: 1, name: 'Jan'),
    MonthModel(index: 2, name: 'Feb'),
    MonthModel(index: 3, name: 'Mar'),
    MonthModel(index: 4, name: 'Apr'),
    MonthModel(index: 5, name: 'May'),
    MonthModel(index: 6, name: 'Jun'),
    MonthModel(index: 7, name: 'Jul'),
    MonthModel(index: 8, name: 'Aug'),
    MonthModel(index: 9, name: 'Sep'),
    MonthModel(index: 10, name: 'Oct'),
    MonthModel(index: 11, name: 'Nov'),
    MonthModel(index: 12, name: 'Dec'),
  ];

  static Future<DateTime> showMonthYearPickerDialog({
    required BuildContext context,
    TextStyle? titleTextStyle,
    TextStyle? yearTextStyle,
    TextStyle? monthTextStyle,
    Color? backgroundColor,
    Color? selectionColor,
    bool? barrierDismissible,
    bool? disableFuture,
  }) async {
    final ThemeData theme = Theme.of(context);
    var primaryColor = selectionColor ?? theme.primaryColor;
    var bgColor = backgroundColor ?? theme.scaffoldBackgroundColor;

    int selectedYear = DateTime.now().year;
    var selectedMonth = DateTime.now().month;

    await showDialog<DateTime>(
      context: context,
      barrierDismissible: barrierDismissible ?? true,
      builder: (_) {
        return StatefulBuilder(builder: (context, setState) {
          return CustomDialog(
            child: Stack(
              children: [
                SingleChildScrollView(  // Wrap content with SingleChildScrollView to avoid overflow
                  child: Container(
                    height: 300,  // Increased height to prevent overflow
                    width: 370,
                    decoration: BoxDecoration(
                      color: bgColor,
                      border: Border.all(
                        color: primaryColor,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15, top: 15),
                          child: Text(
                            Localizations.localeOf(context).languageCode == 'ta'
                                ? 'மாதம் மற்றும் வருடம் தேர்ந்தெடுக்கவும்'
                                : 'Select Month & Year',
                            style: titleTextStyle ?? TextStyle(
                              fontFamily: 'Rajdhani',
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 30, top: 5),
                          child: SizedBox(
                            height: 100,
                            width: 300,
                            child: GridView.builder(
                              itemCount: _monthModelList.length,
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 6,
                              ),
                              itemBuilder: (_, index) {
                                var monthModel = _monthModelList[index];
                                return InkWell(
                                  onTap: () {
                                    setState(() {
                                      selectedMonth = index + 1;
                                    });
                                  },
                                  child: MonthContainer(
                                    textStyle: monthTextStyle,
                                    month: monthModel.name,
                                    fillColor: index + 1 == selectedMonth
                                        ? primaryColor
                                        : bgColor,
                                    borderColor: index + 1 == selectedMonth
                                        ? primaryColor
                                        : bgColor,
                                    textColor: index + 1 == selectedMonth
                                        ? Colors.white
                                        : primaryColor,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                         GestureDetector(
  onTap: () {
    Navigator.pop(context);
  },
  child: Container(
    height: 30,
    decoration: BoxDecoration(
      color: bgColor,
      border: Border.all(
        color: primaryColor,
      ),
      borderRadius: BorderRadius.circular(6),
    ),
    child: Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 26, vertical: 6),
        child: Text(
          Localizations.localeOf(context).languageCode == 'ta'
              ? 'ரத்து செய்'
              : 'Cancel',
          style: TextStyle(
            color: primaryColor,
          ),
          overflow: TextOverflow.ellipsis, // Handles text overflow
        ),
      ),
    ),
  ),
),

                            const SizedBox(
                              width: 15,
                            ),
                            GestureDetector(
                              onTap: () {
                                String selectedMonthString = selectedMonth < 10
                                    ? "0$selectedMonth"
                                    : "$selectedMonth";
                                var selectedDate = DateTime.parse(
                                    '$selectedYear-$selectedMonthString-01');
                                Navigator.pop(context, selectedDate);
                              },
                              child: Container(
                                height: 30,
                                width: 70,
                                decoration: BoxDecoration(
                                  color: primaryColor,
                                  border: Border.all(
                                    color: primaryColor,
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Center(
                                  child: Text(
                                    Localizations.localeOf(context).languageCode == 'ta'
                                        ? 'சரி'
                                        : 'OK',
                                    style: TextStyle(
                                      color: bgColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 50,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned.fill(
                  top: 10,
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              selectedYear = selectedYear - 1;
                            });
                          },
                          icon: Icon(
                            Icons.arrow_back_ios,
                            size: 10,
                            color: primaryColor,
                          ),
                        ),
                        Text(
                          selectedYear.toString(),
                          style: yearTextStyle ??
                              TextStyle(
                                fontSize: 20,
                                fontFamily: 'Rajdhani',
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        if (!(disableFuture == true &&
                            selectedYear == DateTime.now().year))
                          IconButton(
                            onPressed: () {
                              if (disableFuture == true &&
                                  selectedYear == DateTime.now().year) {
                                null;
                              } else {
                                setState(() {
                                  selectedYear = selectedYear + 1;
                                });
                              }
                            },
                            icon: Icon(
                              Icons.arrow_forward_ios,
                              size: 10,
                              color: primaryColor,
                            ),
                          )
                        else
                          SizedBox(
                            width: 50,
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
    String selectedMonthString =
        selectedMonth < 10 ? "0$selectedMonth" : "$selectedMonth";
    return DateTime.parse('$selectedYear-$selectedMonthString-01');
  }
}
