import 'package:daily_tasks/screens/add_task_screen.dart';
import 'package:flutter/material.dart';

import 'package:bottom_picker/bottom_picker.dart';

class CalenderWidget extends StatefulWidget {
  const CalenderWidget({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  State<CalenderWidget> createState() => _CalenderWidgetState();
}

bool showTime = false;
DateTime time = DateTime.now();

class _CalenderWidgetState extends State<CalenderWidget> {
  @override
  Widget build(BuildContext context) {
    void openDateTimePicker(BuildContext context) {
      BottomPicker.dateTime(
        pickerTitle: Text(
          'Choose Note Date',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: selectedColor,
          ),
        ),
        gradientColors: [selectedColor!, Colors.blue],
        backgroundColor: Colors.black87,
        closeIconColor: selectedColor!,
        initialDateTime: DateTime.now(),
        maxDateTime: DateTime(2030),
        minDateTime: DateTime(DateTime.now().year),
        pickerTextStyle: const TextStyle(
          color: Colors.blue,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        onSubmit: (p0) {
          var day = DateTime(time.year, time.month, time.day)
              .difference(DateTime.now())
              .inDays;
          int hour = DateTime(time.year, time.month, time.day, time.hour).hour -
              DateTime.now().hour;
          int minute =
              DateTime(time.year, time.month, time.day, time.hour, time.minute)
                      .minute -
                  DateTime.now().minute;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  '${day != 0 ? '$day days' : ''} ${hour.toString().length > 1 ? '$hour' : '0$hour'} hours ${minute.toString().length > 1 ? '$minute' : '0$minute'} minutes from now!'),
            ),
          );
        },
        onChange: (p0) {
          setState(() {
            time = p0;
            showTime = true;
          });
        },
      ).show(context);
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 1500),
      decoration: BoxDecoration(
        color: selectedColor,
        borderRadius: BorderRadius.circular(20),
      ),
      width: widget.size.width / 2 - 20,
      height: 100,
      child: InkWell(
        onTap: () {
          return openDateTimePicker(context);
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.edit_calendar,
              ),
              Text(
                '${time.day.toString()} - ${time.month.toString()} - ${time.year.toString()}',
                style: const TextStyle(fontSize: 20),
              ),
              Text(
                '${time.hour.toString().length > 1 ? time.hour.toString() : '0${time.hour.toString()}'} : ${time.minute.toString().length > 1 ? time.minute.toString() : '0${time.minute.toString()}'} ',
                style: const TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String? mainDescriptionText;

class DescriptionInputWidget extends StatefulWidget {
  const DescriptionInputWidget({
    super.key,
    required this.size,
    required this.descriptionText,
  });
  final String descriptionText;

  final Size size;

  @override
  State<DescriptionInputWidget> createState() => _DescriptionInputWidgetState();
}

class _DescriptionInputWidgetState extends State<DescriptionInputWidget> {
  @override
  void initState() {
    setState(() {
      mainDescriptionText = widget.descriptionText;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size.width - 30,
      child: TextFormField(
        initialValue: mainDescriptionText,
        onChanged: (value) {
          setState(() {
            mainDescriptionText = value;
          });
        },
        maxLines: 6,
        style: const TextStyle(color: Colors.white),
        cursorColor: Colors.white,
        decoration: InputDecoration(
          hintStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w300,
          ),
          hintText: 'Description',
          prefixText: '  ',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}

String? mainTitleText;

class TitleInputWidget extends StatefulWidget {
  const TitleInputWidget({
    super.key,
    required this.size,
    required this.titleText,
  });

  final String titleText;
  final Size size;

  @override
  State<TitleInputWidget> createState() => _TitleInputWidgetState();
}

class _TitleInputWidgetState extends State<TitleInputWidget> {
  @override
  void initState() {
    setState(() {
      mainTitleText = widget.titleText;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size.width - 30,
      child: TextFormField(
        initialValue: mainTitleText,
        onChanged: (value) {
          setState(() {
            mainTitleText = value;
          });
        },
        style: const TextStyle(color: Colors.white),
        cursorColor: Colors.white,
        decoration: InputDecoration(
          hintStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w300,
          ),
          hintText: 'Title',
          prefixText: '  ',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}
