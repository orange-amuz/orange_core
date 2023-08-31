# orange_core

만든 위젯들을 모아놓은 라이브러리

## 빌드 환경

- Dart : 3.0.6
- Flutter : 3.10.6
- Android Studio : 2022.3
- Xcode : 14.3
  - CocoaPods : 1.12.1

## 패키지 개발 환경

호환성을 위해, 최대한 다른 패키지들을 사용하지 않고, 순수 Flutter만을 이용해서 구현하려고 합니다.

## Utility

### Screen Util

#### 사용법

ScreenUtil 클래스는 모든 변수와 메서드가 static으로 선언되어있기 때문에,
앱의 전역에서 `ScreenUtil.{변수}`의 방식으로 호출해서 사용할 수 있습니다.

그러나 **context**를 사용해서 몇몇 변수들을 선언하기에, 아래의 코드처럼 초기화를 해야합니다.

```dart
  MaterialApp(
    title: 'Flutter Demo',
    builder: (context, child) {
      if (!ScreenUtil.isInitialize()) {
        ScreenUtil.initialize(
          context,
          designedHeight: 375,
          designedWidth: 767,
        );
      } else {
        ScreenUtil.updateScreenValues(context);
      }

      return child!;
    },
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.deepPurple,
      ),
      useMaterial3: true,
    ),
    home: const MyHomePage(title: 'Flutter Demo Home Page'),
  );

```

MaterialApp 내부의 builder에서 ScreenUtil을 initialize합니다.

- `designedWidth` : 디자인 상에 나와있는 디바이스의 너비
- `designedHeight` : 디자인 상에 나와있는 디바이스의 높이

아래의 메서드를 사용하면
현재 실행중인 기기의 디바이스 크기를 고려하여, 변환된 값을 구할 수 있습니다.

- `getWidth(double width)` : 디자인 상에 나와있는 디바이스의 너비 비율에 맞게 변환된 너비
- `getHeight(double height)` : 디자인 상에 나와있는 디바이스의 높이 비율에 맞게 변환된 높이

**그러나, 대부분의 경우에서는 모든 비율 값은 너비를 기준으로 사용하기를 권장힙니다.**

모바일 기기의 경우, 화면의 높이는 별로 중요하지 않습니다. (스크롤이 가능하기 때문에)

#### 최대 너비 설정

기본값으로, **화면의 최대 너비**는 **500**으로 설정되어있습니다.

이 값은 `late final`로 선언되어있기 때문에, initialize 메서드를 호출할 때 속성으로 추가해주지 않으면, 후에 변경할 수 없습니다.

같은 방식으로, **Bottom Navigation의 최대 너비**는 **450**으로 설정되어있습니다.

#### 사용 가능한 변수

- **pixelRatio** : `MediaQuery.of(context).pixelRatio`와 동일
- **phsicalScreenSize** : `MediaQuery.of(context).size`와 동일, 실제 화면 크기
- **designedHeight** : 디자인 상에서 사용된 기기의 높이
- **designedWidth** : 디자인 상에서 사용된 기기의 너비
- **paddingTop** : 현재 기기의 상태바 높이
- **paddingBottom** : 현재 기기의 Bottom Safe Area의 크기
- **screenHeight** : 현재 기기의 스크린 높이
- **screenWidth** : 현재 기기의 스크린 너비
- **appHeight** : 현재 기기의 사용 가능한 영역의 높이 (screenHeight - paddingTop)
- **appWidth** : 현재 기기의 사용 가능한 영역의 너비
- **maxWidth** : 화면에 보여질 최대 너비
- **maxNavigationWidth** : Navigation의 화면에 보여질 최대 너비

#### 사용 가능한 메서드

- **getHeightRatio**(_double_ height) : 입력한 값의 높이 비율을 반환하는 메서드
- **getWidthRatio**(_double_ width) : 입력한 값의 너비 비율을 반환하는 메서드
- **getHeight**(_double_ height) : 변환된 높이를 반환하는 메서드
- **getWidth**(_double_ width) : 변환된 너비를 반환하는 메서드

### String Util

#### 사용법

StringUtil 클래스는 모든 메서드가 static 으로 선언되어 있기에,
앱의 전역에서 `StringUtil.{메서드}`로 호출해서 사용할 수 있습니다.

#### 사용 가능한 메서드

- **validateEmail**(_String_ email) : 입력한 이메일이 형식에 맞는지 검사하는 메서드
- **validatePhoneNum**(_String_ phoneNum) : 입력한 휴대폰 번호가 형식에 맞는지 검사하는 메서드
- **validatePw**(_String_ pw) : 입력한 비밀번호가 형식에 맞는지 검사하는 메서드
- **checkBottomConsonant**(_String_ input) : 한글 종성의 받침 유무를 검사하는 메서드

## 위젯 리스트

### AnimatedWidgetViewer

### Button

### ListButton

### ScaleButton
