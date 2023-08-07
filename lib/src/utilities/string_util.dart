class StringUtil {
  /// 이메일 형식이 맞는지 검사하는 메서드
  static bool validateEmail(String email) {
    const String pattern = r'^[a-zA-Z0-9+-\_.]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$';

    final emailRegx = RegExp(pattern);

    if (emailRegx.hasMatch(email)) {
      return true;
    }

    return false;
  }

  /// 휴대폰 번호 형식이 맞는지 검사하는 메서드 (숫자만 입력)
  static bool validatePhoneNum(String phoneNum) {
    const String pattern = r'^[0-9]{10,11}$';

    final phoneNumRegx = RegExp(pattern);

    if (phoneNumRegx.hasMatch(phoneNum)) {
      return true;
    }

    return false;
  }

  /// 비밀번호 형식이 맞는지 검사하는 메서드
  static bool validatePw(String pw) {
    const String pattern =
        r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{10,}$';

    final pwRegx = RegExp(pattern);

    if (pwRegx.hasMatch(pw)) {
      return true;
    }

    return false;
  }

  /// 한글 종성을 판별하는 메서드
  ///
  /// [true] : 받침 있음
  ///
  /// [false] : 받침 없음
  bool checkBottomConsonant(String input) {
    return (input.runes.last - 0xAC00) % 28 != 0;
  }
}
