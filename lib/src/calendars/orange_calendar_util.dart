class OrangeCalendarUtil {
  static const List<String> koreanWeekdays = [
    '일요일',
    '월요일',
    '화요일',
    '수요일',
    '목요일',
    '금요일',
    '토요일',
  ];

  /// 정수 값을 입력받아서 요일 인덱스로 변환하는 메서드
  ///
  /// (일요일 : 0, 토요일 6)
  static int getIntToWeekdayIndex(int index) {
    return index == 0 ? 6 : index - 1;
  }

  /// weekdayIndex에 해당하는 요일의 문자열 중 첫 번째 문자를 반환하는 메서드
  ///
  /// (일요일 : 0, 토요일 : 6)
  static String getKoreanWeekdayShort(int weekdayIndex) {
    return koreanWeekdays.elementAt(weekdayIndex)[0];
  }
}
