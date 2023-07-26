import 'package:flutter/material.dart';
import 'package:orange_core/src/calendars/orange_calendar_util.dart';

class OrangeCalendar extends StatelessWidget {
  const OrangeCalendar({
    Key? key,
    this.constraints,
    this.calendarTitlePadding = const EdgeInsets.only(
      top: 15,
      left: 16.5,
      right: 16.5,
    ),
    this.calendarTitleTextStyle,
  }) : super(key: key);

  final BoxConstraints? constraints;

  final EdgeInsets calendarTitlePadding;
  final TextStyle? calendarTitleTextStyle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: constraints,
        child: LayoutBuilder(
          builder: (_, constraints) {
            return Column(
              children: [
                _buildCalendarWeeklyTitle(),
                _buildCalendarContents(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildCalendarWeeklyTitle() {
    return Container(
      padding: calendarTitlePadding,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            children: List.generate(
              7,
              (index) => _buildCalendarWeeklyTitleAt(
                context: context,
                constraints: constraints,
                index: index,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCalendarWeeklyTitleAt({
    required BuildContext context,
    required BoxConstraints constraints,
    required int index,
  }) {
    final weekdayIndex = OrangeCalendarUtil.getIntToWeekdayIndex(index);

    return Container(
      width: constraints.maxWidth / 7,
      alignment: Alignment.center,
      child: Text(
        OrangeCalendarUtil.getKoreanWeekdayShort(weekdayIndex),
        style: calendarTitleTextStyle,
      ),
    );
  }

  Widget _buildCalendarContents() {
    return Container();
  }
}
