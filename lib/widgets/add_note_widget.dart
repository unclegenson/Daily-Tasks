import 'package:daily_tasks/screens/add_note_screen.dart';
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
    time = DateTime.now();
    void openDatePicker(BuildContext context) {
      BottomPicker.date(
        pickerTitle: const Text(
          'Choose Note Date',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: Colors.blue,
          ),
        ),
        initialDateTime: DateTime.now(),
        maxDateTime: DateTime(2030),
        minDateTime: DateTime(DateTime.now().year),
        pickerTextStyle: const TextStyle(
          color: Colors.blue,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        onSubmit: (index) {
          setState(() {
            time = index;
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
          return openDatePicker(context);
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.edit_calendar,
              ),
              Text(
                '${time.day.toString()} / ${time.month.toString()} / ${time.year.toString()}',
                style: const TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String? descriptionText;

class DescriptionInputWidget extends StatefulWidget {
  const DescriptionInputWidget({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  State<DescriptionInputWidget> createState() => _DescriptionInputWidgetState();
}

class _DescriptionInputWidgetState extends State<DescriptionInputWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size.width - 30,
      child: TextFormField(
        onChanged: (value) {
          setState(() {
            descriptionText = value;
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

String? titleText;

class TitleInputWidget extends StatefulWidget {
  const TitleInputWidget({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  State<TitleInputWidget> createState() => _TitleInputWidgetState();
}

class _TitleInputWidgetState extends State<TitleInputWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size.width - 30,
      child: TextFormField(
        onChanged: (value) {
          setState(() {
            titleText = value;
          });
        },
        style: const TextStyle(color: Colors.white),
        cursorColor: Colors.white,
        decoration: InputDecoration(
          suffixIcon: const Icon(
            Icons.mic,
            color: Colors.white,
          ),
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
